AiCarController = BaseClass("AiCarController",PoolBaseClass)

local _random = math.random
local _sin = math.sin
local _rad = math.rad
local _clamp = math.Clamp
local CollideCheckLayer = FightEnum.LayerBit.CarBody | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water

function AiCarController:__init()

end

function AiCarController:Init(movement)
    self.movement = movement
	self.tcca = movement.tcca
    self.collistionComponent = self.movement.entity.collistionComponent
    
    self.motionInstanceId = 0
    self.effectors = {}
    self.motions = {}

    self.maxSpeedDefinites = {}
    self.maxSpeedAddtives = {}
    self.maxSpeedMultipliers = {}

    self.accDefinites = {}
    self.accAddtives = {}
    self.accMultipliers = {}

    self.changeLanes = {}

    self.offsetX = nil
end

function AiCarController:DoAction(action)
    if action.actionType == FightEnum.AiCarActionType.maxSpeedMultiplier then
        self.maxSpeedMultipliers[action.actionInstanceId] = action.args[1]
        action:SetComplete()
    end
    
    if action.actionType == FightEnum.AiCarActionType.maxSpeedDefinite then
        self.maxSpeedDefinites[action.actionInstanceId] = action.args[1]
        action:SetComplete()
    end
    
    if action.actionType == FightEnum.AiCarActionType.maxSpeedAddtive then
        self.maxSpeedAddtives[action.actionInstanceId] = action.args[1]
        action:SetComplete()
    end
    
    if action.actionType == FightEnum.AiCarActionType.accelerationMultiplier then
        self.accMultipliers[action.actionInstanceId] = action.args[1]
        action:SetComplete()
    end
    
    if action.actionType == FightEnum.AiCarActionType.accelerationDefinite then
        self.accDefinites[action.actionInstanceId] = action.args[1]
        action:SetComplete()
    end
    if action.actionType == FightEnum.AiCarActionType.accelerationAddtive then
        self.accAddtives[action.actionInstanceId] = action.args[1]
        action:SetComplete()
    end
    if action.actionType == FightEnum.AiCarActionType.changeLanes then
        self.changeLanes[action.actionInstanceId] = self.changeLanes[action.actionInstanceId] or 1
        self:DoChangeLanes(action)
    end

    if action.actionType == FightEnum.AiCarActionType.unStopable then
        self.movement.unStopable = true
        local mass = action.args[1] or 1
        self.tcca:SetMassMult(mass)
        action:SetComplete()
    end
    
end

function AiCarController:UnDoAction(action)
    if action.actionType == FightEnum.AiCarActionType.maxSpeedMultiplier then
        self.maxSpeedMultipliers[action.actionInstanceId] = nil
    end
    
    if action.actionType == FightEnum.AiCarActionType.maxSpeedDefinite then
        self.maxSpeedDefinites[action.actionInstanceId] = nil
    end
    
    if action.actionType == FightEnum.AiCarActionType.maxSpeedAddtive then
        self.maxSpeedAddtives[action.actionInstanceId] = nil
    end
    
    if action.actionType == FightEnum.AiCarActionType.accelerationMultiplier then
        self.accMultipliers[action.actionInstanceId] = nil
    end
    
    if action.actionType == FightEnum.AiCarActionType.accelerationDefinite then
        self.accDefinites[action.actionInstanceId] = nil
    end
    if action.actionType == FightEnum.AiCarActionType.accelerationAddtive then
        self.accAddtives[action.actionInstanceId] = nil
    end

	if action.actionType == FightEnum.AiCarActionType.changeLanes then
		self.changeLanes[action.actionInstanceId] = nil
	end
    
    if action.actionType == FightEnum.AiCarActionType.unStopable then
        self.movement.unStopable = false
        self.tcca:SetMassMult(1)
    end
end

function AiCarController:CheckObstacle(args)
    
    local maxDis = args and args[1] or 10
    return self.movement.obstacleDis < maxDis
    
end

function AiCarController:GetPlayerDistance()
    
	local curEntityId = BehaviorFunctions.fight.playerManager:GetPlayer():GetCtrlEntity()
	local curEntity = Fight.Instance.entityManager:GetEntity(curEntityId)
    local carEntity = self.movement.entity
    if curEntity and carEntity then
        return Vec3.Distance(curEntity.transformComponent:GetPosition(),carEntity.transformComponent:GetPosition())
    end

    return math.huge
    
end

-- 获取可以通过的车道偏移
function AiCarController:CheckPassableSpace(args)
    
    local canVehicle = args and args[1] or false
    local customX = args and args[2] or self.movement.passCheckBox.x


    self.localCheckBox =  self.localCheckBox or  Vector3.zero
    self.localCheckBox.x = customX
    self.localCheckBox.y = self.movement.passCheckBox.y
    self.localCheckBox.z = self.movement.passCheckBox.z
    local trackPoint = self.movement:GetTargetTrackPoint()

    -- 即不是路点，也不是路口差值点的特殊点，如掉头点，放弃变道
    if not trackPoint.streetIndex and not trackPoint.crossIndex  then
        return
    end

    if self.movement:CountRemainToTrack() < 2 then
        -- 只剩小于两个点放弃变道
        return
    end
    
	local checkPosition = self.movement.checkTransform.position - self.movement.checkTransform.forward * self.movement.passCheckBox.z
    local carPosition = self.movement.rootTransform.position
	local checkDistance = self.movement.obstacleDis + 1


    -- 获取当前位置相较道路中线的偏移

    self.GPS_cache1 = self.GPS_cache1 or Vec3.New()
    self.GPS_cache2 = self.GPS_cache2 or Vec3.New()
    self.GPS_cache3 = self.GPS_cache3 or Vec3.New()
    self.GPS_cache4 = self.GPS_cache4 or Vec3.New()
    self.GPS_cache5 = self.GPS_cache5 or Vec3.New()
	self.GPS_cache6 = self.GPS_cache6 or Vec3.New()
	self.GPS_cache7 = self.GPS_cache7 or Vec3.New()
	self.GPS_cache8 = self.GPS_cache8 or Vec3.New()
    
    local linePoint1 = self.GPS_cache2
    local linePoint2 = self.GPS_cache3

    local leftOffset
    local rightOffset
    if trackPoint.streetIndex then
        
        local curStreet = self.movement.trafficManager:GetStreetCenterData(trackPoint.streetIndex)
        -- 路点是否朝前
        local forward = self.movement:GetTargetTrackPoint().roadLine > (self.movement.trafficManager:GetRoadLineNum(curStreet.RoadLevel) + 1 )/2

        -- 计算当前距离道路中线距离
        local targetIdxDirect = self.GPS_cache1
        self.movement.trafficManager:GetStreetPointIndexDirect(curStreet, trackPoint.pointIndex ,targetIdxDirect)
        linePoint1:SetA(curStreet.CenterPoint[trackPoint.pointIndex])
        linePoint2:SetA(linePoint1)

        -- 判断行驶forward，保证linePoint2处于linePoint1行驶方向上的前方
        if forward then
            linePoint2:Add(targetIdxDirect)
        else
            linePoint2:Sub(targetIdxDirect)
        end

        local roadWidthOut = self.movement.trafficManager:GetRoadWidth(curStreet.RoadLevel , true) - self.movement.passCheckBox.x
        local roadWidthInside = self.movement.trafficManager:GetRoadWidth(curStreet.RoadLevel , false) + self.movement.passCheckBox.x

        rightOffset = roadWidthOut
        if canVehicle then
            leftOffset = roadWidthOut
        else
            leftOffset = -roadWidthInside
        end
    else
        
        local tempIndex = self.movement.targetIdx
        -- 路口尽头点
		local loopCount = 0
        while tempIndex + 1 <= #self.movement.trackPath do
            tempIndex = tempIndex + 1
            if self.movement.trackPath[tempIndex].streetIndex  then
                linePoint2:SetA(self.movement.trackPath[tempIndex].originPos)
                break
            end
        end
        -- 路口起始点
        tempIndex = self.movement.targetIdx

        local beforeStreetIndex
        while tempIndex - 1 > 0 do
            tempIndex = tempIndex - 1
            if self.movement.trackPath[tempIndex].streetIndex then
                linePoint1:SetA(self.movement.trackPath[tempIndex].originPos)
                beforeStreetIndex = self.movement.trackPath[tempIndex].streetIndex 
                break
            end
        end

            
        local curStreet = self.movement.trafficManager:GetStreetCenterData(beforeStreetIndex)

        
        local roadWidthOut = self.movement.trafficManager:GetRoadWidth(curStreet.RoadLevel , true) - self.movement.passCheckBox.x
        local roadWidthInside = self.movement.trafficManager:GetRoadWidth(curStreet.RoadLevel , false) + self.movement.passCheckBox.x

        -- 路口无论canVehicle都不允许逆行
        rightOffset = roadWidthOut * _sin(_rad(45))
        leftOffset = -roadWidthInside * _sin(_rad(45))
    end

    -- 计算出检查点当前距离道路中线距离
    local project = self.GPS_cache4
    local pointToLineStart = self.GPS_cache5
    self.movement.trafficManager:FindProjectionPoint(checkPosition, linePoint1, linePoint2 , project)
	project:Sub(linePoint1)
    pointToLineStart:SetA(checkPosition)
    pointToLineStart:Sub(linePoint1)
    pointToLineStart:Sub(project)
    local currentOffset = pointToLineStart:Magnitude()

    self.GPS_cache6:SetA(checkPosition)
    self.GPS_cache6:Sub(linePoint1)
    self.GPS_cache7:SetA(linePoint2)
    self.GPS_cache7:Sub(linePoint1)
    -- 判断检查点是否处于行驶方向的中线左边来判断正负
    if self.GPS_cache6:CrossA(self.GPS_cache7).y > 0 then
        currentOffset = -currentOffset
    end

	
	local carForwardDir = self.GPS_cache7
    -- 求单侧路段

    -- 左右可偏移空间
    leftOffset = math.max(0,leftOffset + currentOffset )
    rightOffset = math.max(0,rightOffset - currentOffset )

	
	self.movement:SetHideRayCast()

    -- 这里检测用checkPosition，因为movement里检测障碍也是用checkPosition，需要一致才能保证这里计算出的Offset确实可以绕过障碍
	local check, dis, clearPoint = CS.PhysicsTerrain.GetBoxClearOffset(checkPosition, self.movement.passCheckBox, Quat.LookRotation(carForwardDir):ToUnityQuat(),
		carForwardDir, checkDistance, leftOffset, rightOffset ,0, Vector3.zero,  FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.CarBody, self.movement.entity.clientTransformComponent.transform)

    self.movement:SetShowRayCast()
    if check then
        self.offsetX = dis + currentOffset
        self.clearPoint = clearPoint
        return true
    else
        self.offsetX = 0
        return false
    end
end

-- 执行变道
function AiCarController:DoChangeLanes(action)
    local actionInstanceId = action.actionInstanceId
    local step = self.changeLanes[actionInstanceId]
    if step == 1 then
        self:DoChangeLanes1()
        --self.movement:DrawPoints()
        self.changeLanes[actionInstanceId] = 2
    elseif step == 2 then
        if action.motion:GetStayTime() > 2 then
            action:SetComplete()
        end
    end
end
-- 设置新路径
function AiCarController:DoChangeLanes1()
    
	self.DCL_cache1 = self.DCL_cache1 or Vec3.New()
	self.DCL_cache2 = self.DCL_cache2 or Vec3.New()
	self.DCL_cache3 = self.DCL_cache3 or Vec3.New()
	self.DCL_cache4 = self.DCL_cache4 or Vec3.New()
	self.DCL_cache5 = self.DCL_cache5 or Vec3.New()
	self.DCL_cache6 = self.DCL_cache6 or Vec3.New()

    if not self.offsetX or self.offsetX == 0 then
        return
    end
    
    self.DoChangeLanes1Idx = self.movement.targetIdx
    
	if self.movement:GetTargetTrackPoint().streetIndex then
        -- 道路避障会改一整路的点

        -- 找出当前所在道路剩余点和路口插值点
		local targetStreetIndex = self.movement:GetTargetTrackPoint().streetIndex
        local roadEndIndex = self.movement.targetIdx
        local tempIndex = self.movement.targetIdx
        local nextStreetIndex
        -- 当前道路终点
		local loopCount = 0
		while tempIndex + 1 <= #self.movement.trackPath do
			tempIndex = tempIndex + 1
			if self.movement.trackPath[tempIndex].streetIndex and self.movement.trackPath[tempIndex].streetIndex == targetStreetIndex then
                roadEndIndex = tempIndex
            else
                break
			end
		end
        -- 当前道路起点
        tempIndex = self.movement.targetIdx
        local roadStartIndex = self.movement.targetIdx
		while tempIndex - 1 > 0 do
			tempIndex = tempIndex - 1
			if self.movement.trackPath[tempIndex].streetIndex and self.movement.trackPath[tempIndex].streetIndex == targetStreetIndex then
                roadStartIndex = tempIndex
            else
                break
			end
		end
        -- 当前道路后的路口插值终点
		local crossEndIdx = roadEndIndex
        if self.movement.trackPath[crossEndIdx].crossIndex then
            local targetCrossIndex = self.movement.trackPath[crossEndIdx].crossIndex
            tempIndex = crossEndIdx
            while tempIndex + 1 <= #self.movement.trackPath do
                tempIndex = tempIndex + 1
                if self.movement.trackPath[tempIndex].crossIndex and self.movement.trackPath[tempIndex].crossIndex == targetCrossIndex then
                    crossEndIdx = tempIndex
                else
                    if self.movement.trackPath[tempIndex].streetIndex then
                        nextStreetIndex = self.movement.trackPath[tempIndex].streetIndex
                    else
		                LogError("路口点"..targetCrossIndex.."后没有接下一条路点，不可能")
                    end
                    break
                end
            end
        end
            
            local curStreet = self.movement.trafficManager:GetStreetCenterData(targetStreetIndex)
            
            -- 路点是否朝前
            local forward = self.movement:GetTargetTrackPoint().roadLine > (self.movement.trafficManager:GetRoadLineNum(curStreet.RoadLevel) + 1 )/2


            -- 重新当前所在道路剩余点偏移
            for i = roadStartIndex, roadEndIndex, 1 do
                local curTrackPoint = self.movement.trackPath[i]
                -- 还原到路中心点
                curTrackPoint.pos:SetA(curStreet.CenterPoint[curTrackPoint.pointIndex])
                
                -- 读取道路方向法线
                local normal = self.DCL_cache1
                self.movement.trafficManager:GetStreetPointIndexNormal(curStreet, curTrackPoint.pointIndex ,normal)

                -- 设置新偏移
                curTrackPoint.pos:Add(normal:Mul(forward and self.offsetX or -self.offsetX))
            end

            -- 重新计算路口差值点
            if crossEndIdx > roadEndIndex then

                local nextStreet = self.movement.trafficManager:GetStreetCenterData(nextStreetIndex)

                -- 读取道路方向法线
                local tempNormal = self.DCL_cache1

                -- 获取当前道路最后两个路点，应用偏移
                local lastPoint1 = self.DCL_cache2
                local lastPoint2 = self.DCL_cache3
                local lastPoint1CenterIndex = self.movement.trackPath[roadEndIndex].pointIndex
                lastPoint1:SetA(curStreet.CenterPoint[lastPoint1CenterIndex])
                self.movement.trafficManager:GetStreetPointIndexNormal(curStreet, lastPoint1CenterIndex ,tempNormal)   -- 获取法线
                lastPoint1:Add(tempNormal:Mul(forward and self.offsetX or -self.offsetX))

                
                self.movement.trafficManager:GetStreetPointIndexDirect(curStreet, lastPoint1CenterIndex ,tempNormal)   -- 获取方向向量
                lastPoint2:SetA(lastPoint1)
                lastPoint2:Add(tempNormal)

                
                -- 获取下段道路最后两个路点
                local nextPoint1 = self.DCL_cache4
                local nextPoint2 = self.DCL_cache5
                local nextPoint1CenterIndex = self.movement.trackPath[crossEndIdx + 1].pointIndex -- 规划道路点不会断在路口，如果存在路口差值点，则后面一定有下条路的至少一个点，放心+1
                nextPoint1:SetA(self.movement.trackPath[crossEndIdx + 1].pos)
                
                -- 获取下段道路第一个点的方向向量，叠加获得下段道路第二个点
                self.movement.trafficManager:GetStreetPointIndexDirect(nextStreet, nextPoint1CenterIndex ,tempNormal)   -- 获取方向向量
                nextPoint2:SetA(nextPoint1)
                nextPoint2:Add(tempNormal)
                
                
                -- 当前路径的最后两点  与下一条路点的前两点 的交点
                local middleX,middleZ = self.movement.trafficManager:calculateIntersectionPoint(lastPoint1.x,lastPoint1.z,lastPoint2.x,lastPoint2.z,nextPoint1.x,nextPoint1.z,nextPoint2.x,nextPoint2.z)
                local middleY = (lastPoint1.y + nextPoint1.y) /2
                local middlePos = self.DCL_cache6
                middlePos:Set(middleX,middleY,middleZ)
                
                -- 根据交点重新计算路口插值点位置
                local totalCrossLength = (Vec3.DistanceXZ(lastPoint1 , middlePos) + Vec3.DistanceXZ(nextPoint1 , middlePos))
                if crossEndIdx - roadEndIndex > 1 then
                    local crossBezierCount = crossEndIdx - roadEndIndex
                    local lengthPer = totalCrossLength/crossBezierCount
                    for i = 1, crossBezierCount -1, 1 do
                        --插入贝塞尔曲线点
                        local tValue = lengthPer * i /totalCrossLength
                        local calPos = Vec3:CalculateBezierPoint(tValue,lastPoint1,middlePos,nextPoint1,self.DCL_cache1,self.DCL_cache3,self.DCL_cache5)

                        -- 重新设置路口差值点
                        local curTrackPoint = self.movement.trackPath[roadEndIndex + i]
                        local originPos = curTrackPoint.pos
                        originPos:SetA(calPos)
                    end

                else
                    local tValue = Vec3.DistanceXZ(lastPoint1 , middlePos)/totalCrossLength
                    local calPos = Vec3:CalculateBezierPoint(tValue,lastPoint1,middlePos,nextPoint1,self.DCL_cache2,self.DCL_cache3,self.DCL_cache4)
                    -- 重新设置路口差值点
                    local curTrackPoint = self.movement.trackPath[roadEndIndex + 1]
                    local originPos = curTrackPoint.pos
                    originPos:SetA(calPos)
                end
            end

            -- 重新设置目标点位置，以保证可以绕过前方障碍
            local carPosition = self.movement.rootTransform.position
            local targetPoint = self.movement.trackPath[self.movement.targetIdx].pos

            self.clearPoint.y = targetPoint.y
            local newNextPoint = self.clearPoint
            
            local dis1 = Vec3.DistanceXZ(carPosition,newNextPoint)
			-- 把往后所有比clearPoint更近的路径变成clearPoint
			local tempIndex = self.movement.targetIdx
			while tempIndex + 1 <= #self.movement.trackPath do
				tempIndex = tempIndex + 1
				local nextPoint = self.movement.trackPath[tempIndex].pos

                -- 下个点到原目标点
                self.DCL_cache2:SetA(targetPoint)
                self.DCL_cache2:Sub(nextPoint)
                
                -- 下个点到新目标点
                self.DCL_cache3:SetA(newNextPoint)
                self.DCL_cache3:Sub(nextPoint)
                
                -- 点乘判断新目标点是否前于该点，前则该点设置为新目标点
                if Vec3.Dot(self.DCL_cache2,self.DCL_cache3) < 0 then
					nextPoint:SetA(newNextPoint)
				else
					break
				end
			end
            tempIndex = self.movement.targetIdx
			while tempIndex -1 > 0 do
				tempIndex = tempIndex -1
				local nextPoint = self.movement.trackPath[tempIndex].pos

                -- 前个点到原目标点
                self.DCL_cache2:SetA(targetPoint)
                self.DCL_cache2:Sub(nextPoint)
                
                -- 前个点到新目标点
                self.DCL_cache3:SetA(newNextPoint)
                self.DCL_cache3:Sub(nextPoint)
                
                -- 点乘判断新目标点是否后于该点，后则该点设置为新目标点
                if Vec3.Dot(self.DCL_cache2,self.DCL_cache3) < 0 then
					nextPoint:SetA(newNextPoint)
				else
					break
				end
			end
			targetPoint:SetA(newNextPoint)
    else
        -- 路口避障只会改目标点
        local carPosition = self.movement.rootTransform.position
        local nextPoint = self.movement.trackPath[self.movement.targetIdx].pos

        self.clearPoint.y = nextPoint.y
        local newNextPoint = self.clearPoint
		
		nextPoint:SetA(newNextPoint)
		
		-- 把往后所有的路口差值点改成这个点
		local tempIndex = self.movement.targetIdx
		local loopCount = 0
		while tempIndex + 1 <= #self.movement.trackPath do
			tempIndex = tempIndex + 1
            if not self.movement.trackPath[tempIndex].streetIndex  then
			    nextPoint = self.movement.trackPath[tempIndex].pos
				nextPoint:SetA(newNextPoint)
			else
				break
			end
		end
        

    end

end

function AiCarController:Update()
    for i, v in ipairs(self.motions) do
        v:Update()
    end

    local maxSpeedMultiplier = 1
    local maxSpeedAddtive = 0
    for k, v in pairs(self.maxSpeedMultipliers) do
        maxSpeedMultiplier = v * maxSpeedMultiplier
    end
    for k, v in pairs(self.maxSpeedAddtives) do
        maxSpeedAddtive = v + maxSpeedAddtive
    end
    local maxSpeedDefinite = -1
    for k, v in pairs(self.maxSpeedDefinites) do
        maxSpeedDefinite = v 
    end
    maxSpeedMultiplier = maxSpeedMultiplier == 1 and -1 or maxSpeedMultiplier
    maxSpeedAddtive = maxSpeedAddtive == 0 and -1 or maxSpeedAddtive



    local accMultiplier = 1
    local accAddtive = 0
    for k, v in pairs(self.accMultipliers) do
        accMultiplier = v * accMultiplier
    end
    for k, v in pairs(self.accAddtives) do
        accAddtive = v + accAddtive
    end
    local accDefinite = -1
    for k, v in pairs(self.accDefinites) do
        accDefinite = v 
    end
    accMultiplier = accMultiplier == 1 and -1 or accMultiplier
    accAddtive = accAddtive == 0 and -1 or accAddtive

    self.tcca:SetMaxSpeedParam(maxSpeedDefinite,maxSpeedAddtive,maxSpeedMultiplier,accDefinite,accAddtive,accMultiplier)
end

function AiCarController:AddMotion(motion)
    self.motionInstanceId = self.motionInstanceId + 1
    motion:Init(self, self.motionInstanceId)

    table.insert(self.motions,motion)
end

function AiCarController:RemoveMotion(motion)
    local targetIndex = 0
    for i, v in ipairs(self.motions) do
        if v.motionInstanceId == motion then
            targetIndex = i
        end
    end
    if targetIndex > 0 then
        self.motions:Undo()
        table.remove(self.motions,targetIndex)
    end
end


function AiCarController:__cache()
end

function AiCarController:__delete()
end
