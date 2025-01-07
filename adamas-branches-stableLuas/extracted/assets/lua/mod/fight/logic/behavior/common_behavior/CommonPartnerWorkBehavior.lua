CommonPartnerWorkBehavior = BaseClass("CommonPartnerWorkBehavior", BehaviorBase)

local CollideCheckLayer = FightEnum.LayerBit.Default | FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Terrain | FightEnum.LayerBit.Wall | FightEnum.LayerBit.Water
local BuildData = Config.DataBuild.Find
local BF = BehaviorFunctions

local clamp = MathX.Clamp


local PartnerWorkState = 
{
    none = 0,
    idle = 1,
    working = 2,
    tracking = 3,
    fadeing = 4
}


function CommonPartnerWorkBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonPartnerWorkBehavior:InitConfig(fight, entity)
    self.fight = fight
    self.entity = entity

    self.serverEvent = {}
    self.clientEvent = {}

    self.partnerDisplayManager = BehaviorFunctions.fight.entityManager.partnerDisplayManager

    self:ClearEventParams()

    self.isTakeBuilding = false

    self.workDisplaySpeed = 1
    self.curDisplaySpeed = 1
    self.idleTime = 0
    self.idleDelay = 5 * math.random(5,15)/10

    self.serverState = nil
    self.clientState = nil
    self.curState = nil

    self.isSetPathFollow = false
    self.blockTime = 0
    self.blockTimeDelay = 5


    EventMgr.Instance:AddListener(EventName.PartnerDisplayUpdate, self:ToFunc("OnPartnerDisplayUpdate"))
    EventMgr.Instance:AddListener(EventName.UpdatePartnerDisplayState, self:ToFunc("OnUpdatePartnerDisplayState"))
    
end

function CommonPartnerWorkBehavior:ClearEventParams()
    self.workState = PartnerWorkState.none
    self.targetUniqueId = nil
end

function CommonPartnerWorkBehavior:OnTakeBuilding(instanceId)
    if instanceId == self.entity.instanceId then
        self.isTakeBuilding = true
        
        -- 被操作时中断一切event
        self:ClearEventParams()

        BehaviorFunctions.StopMove(self.entity.instanceId)
        self.entity.displayComponent:Display(FightEnum.PartnerDisplayType.takeUp,true)
        
        self.clientState = FightEnum.PartnerStatusEnum.TakeUp
        
    end
end


function CommonPartnerWorkBehavior:GetCheckRange()
    return 1.2
end

function CommonPartnerWorkBehavior:GetEntityColliderMinSqrDistance(entity1, entity2)
    local Layer = FightEnum.Layer.AirWall
    --TODO 直接用Vector3,性能不好,要优化
    local distance, _pointA, _pointB, targetObj = CustomUnityUtils.GetClosestPoint(entity1.clientTransformComponent.gameObject, entity2.clientTransformComponent.gameObject, Layer, pointA, pointB)
    return distance, _pointA, _pointB, (targetObj and targetObj.name or nil)
end
function CommonPartnerWorkBehavior:OnExitTakeBuilding(instanceId)
    if instanceId == self.entity.instanceId and self.isTakeBuilding then

        self.isTakeBuilding = false
        self.clientState = nil

		
		local size = self.entity.displayComponent:GetBodyily()
		local bodyily
		for k, v in pairs(FightEnum.WorkPlaceSize) do
			if v== size then
				bodyily = k
			end
		end
		
        --获取所有建造物
        local entitys = Fight.Instance.entityManager:GetEntites()
        --过滤出5m范围内的
        local minSqrDistance = 100
        local closestEntity_World
        local targetUnique
        --找到最短距离
        for _, targetEntity in pairs(entitys) do
            if targetEntity.tagComponent and targetEntity.tagComponent.sceneObjectTag == FightEnum.EntitySceneObjTag.Decoration then
				local decoration = self.partnerDisplayManager:GetDecorationByEntity(targetEntity.instanceId)
				
				local position = self.entity.transformComponent:GetPosition()
				if decoration and position then
					local station = decoration:GetAnyStation(bodyily,position)
					if station then
						local stationDis = Vec3.SquareDistance(position, station.transform.position)
						if stationDis < self:GetCheckRange()^2 * 3 and stationDis < minSqrDistance  then
							minSqrDistance = stationDis
							closestEntity_World = targetEntity
                            targetUnique = station.unique
						end
					end
				end
                
            end
        end

        if closestEntity_World then
            self.partnerDisplayManager:TrySetWork(self.entity.instanceId,closestEntity_World.instanceId,targetUnique)
        end
    end
end


function CommonPartnerWorkBehavior:GetAnimationName(displayType,animType)
    if not displayType then
        
        
        local layer = self.entity.clientAnimatorComponent:GetLayerIndex(FightEnum.AnimationLayerIndexToName[3])
        local startTimeLength = BehaviorFunctions.CheckAnimTime(self.entity.instanceId, name, layer)

    end
end

function CommonPartnerWorkBehavior:UpdateDisplaySpeed(speed)
    if speed ~= self.curDisplaySpeed then
        self.curDisplaySpeed = speed
        
        self.entity.displayComponent:SetSpeed(speed)
    end
end

function CommonPartnerWorkBehavior:Update()

    

    local targetState 
	if self.clientState then
		targetState = self.clientState	
	elseif self.serverState then
		targetState = self.serverState
	else
		targetState = FightEnum.PartnerStatusEnum.None
	end
    self.entity.displayComponent:ChangeState(targetState)
    
    if self.isTakeBuilding  then
        return
    end
	

	if self.workState == PartnerWorkState.working then
        -- 工作中
        local targetWorkAnimSpeed = self:GetWorkAnimSpeed()
        self:UpdateDisplaySpeed(targetWorkAnimSpeed)
    else
        self:UpdateDisplaySpeed(1)
    end

    if self.workState == PartnerWorkState.fadeing then
        return -- 暂时不允许打断fade动画
    end
	
	local event = self:GetWorkInfo()

	local targetPosition = event and event.navTargetPosition
	local eventType = event and event.eventType
	local uniqueId = event and event.uniqueId
    -- 交互对象变化
    if uniqueId ~= self.targetUniqueId then
        
        -- 退出完毕，设置新event
        local exitFuc = function (finishType)
            
            if finishType == FightEnum.DisplayFinishType.FadeOut then

                self.workState = PartnerWorkState.none
                self.targetUniqueId = uniqueId
            end
            -- 取消已有寻路
            if self.isSetPathFollow then
                self:ClearPathFinding()
            end
        end

        -- 如果正在播放，设置fadeout
        if self.workState == PartnerWorkState.working then
            self.workState = PartnerWorkState.fadeing
            self.entity.displayComponent:Display(nil,false,exitFuc)
        else
            exitFuc(FightEnum.DisplayFinishType.FadeOut)
        end
        
    else
        
        if eventType then
			
			if self.workState == PartnerWorkState.working then
				-- 正在工作
            else
				-- 寻路
				local disTarget = Vec3.Distance(targetPosition,self.entity.transformComponent.position)
				if disTarget <= self:GetCheckRange() then
                    -- 设置工作
					self:SetInStation()
                else
                    -- 设置寻路
                    self.workState = PartnerWorkState.tracking

                    if not self.entity.moveComponent.isAloft and BehaviorFunctions.GetEntityState(self.entity.instanceId) ~= FightEnum.EntityState.Move then
                        BehaviorFunctions.DoSetEntityState(self.entity.instanceId,FightEnum.EntityState.Move)
                    end

                    if not self.entity.moveComponent.isAloft then
                        
                        -- 无障碍 
                        if not self:CheckObstaclesBetweenPos(targetPosition) then
                            -- 取消已有寻路
                            if self.isSetPathFollow then
                                self:ClearPathFinding()
                            end
                            -- 设置朝向
                            if BehaviorFunctions.GetEntityState(self.entity.instanceId) == FightEnum.EntityState.Move then
                                BehaviorFunctions.DoLookAtPositionByLerp(self.entity.instanceId,targetPosition.x,nil,targetPosition.z,false,360,180)
                            end
                        else
                            -- 有障碍，寻路
                            if not self.isSetPathFollow then
                                if not self:SetPathFollowPos(targetPosition) then 
                                    -- 寻路失败
                                    self:SetInStation()

                                end
                                self.blockTime = 0
                            else
                                -- 寻路后一直处于阻挡超过n秒后视为寻路失败
                                self.blockTime = self.blockTime + FightUtil.deltaTimeSecond
                                if self.blockTime > self.blockTimeDelay then
                                    self.blockTime = 0
                                    -- 寻路失败
                                    self:SetInStation()
                                end
                            end
                        end
                    end
                end
            end
        else
            -- idle状态
            if self.workState ~= PartnerWorkState.idle then
                self.workState = PartnerWorkState.idle 
                -- 随便找个点跑过去播idle
                local navPos = BehaviorFunctions.GetRandomNavRationalPoint(self.entity.instanceId ,2,10,true)
                if navPos then
                    self:SetPathFollowPos(navPos) 
                    BehaviorFunctions.DoSetEntityState(self.entity.instanceId,FightEnum.EntityState.Move)
					BehaviorFunctions.DoSetMoveType(self.entity.instanceId,FightEnum.EntityMoveSubState.Walk)
                    self.idleTime = 0
                else
					-- 如果没找到寻路，可能处于床上，直接走个三秒
                    
			        local MapPos = AssetPurchaseCtrl:GetAssetEnterPos(mod.AssetPurchaseCtrl:GetCurAssetId())
                    BehaviorFunctions.DoLookAtPositionImmediately(self.entity.instanceId,MapPos.x,nil,MapPos.z)
					BehaviorFunctions.DoSetEntityState(self.entity.instanceId,FightEnum.EntityState.Move)
					BehaviorFunctions.DoSetMoveType(self.entity.instanceId,FightEnum.EntityMoveSubState.Walk)
					self.idleTime = self.idleDelay - 3
                end
            else
                self.idleTime = self.idleTime + FightUtil.deltaTimeSecond
                if self.idleTime > self.idleDelay then
                    self.idleTime = 0
                    self.workState = PartnerWorkState.none
                end
            end
        end
            
    end

end

function CommonPartnerWorkBehavior:ClearPathFinding()
    BehaviorFunctions.ClearPathFinding(self.entity.instanceId)
    self.isSetPathFollow = false
end

function CommonPartnerWorkBehavior:CheckObstaclesBetweenPos(targetPosition)

	local from = self.entity.transformComponent:GetPosition()
	if self.entity.collistionComponent then
		local offset = Vec3.up * (0.5 * self.entity.collistionComponent.config.Height)
		from:Add(offset)
	end
	
	local to = Vec3.CreateByCustom(targetPosition)
	to.y = from.y
	
	local check, toX, toY, toZ = BehaviorFunctions.CheckObstaclesBetweenPos(from, to)
	return check
end

function CommonPartnerWorkBehavior:SetPathFollowPos(targetpos)

    BehaviorFunctions.CancelLookAt(self.entity.instanceId)
    local h,layer=BehaviorFunctions.CheckPosHeight(targetpos)
    if not h then
        return
    end
    local pos1 = Vec3.New(targetpos.x,targetpos.y-h,targetpos.z)
    
    local result = BehaviorFunctions.SetPathFollowPos(self.entity.instanceId,pos1,true)

    if result then
        self.isSetPathFollow = true
    end
    
    return result
end



function CommonPartnerWorkBehavior:SetServerEvent(uniqueId,eventType,position,rotation,direct,dontSetPos,navTargetPosition)
    self.serverEvent.uniqueId = uniqueId
    self.serverEvent.eventType = eventType
    self.serverEvent.position = position
    self.serverEvent.rotation = rotation
    self.serverEvent.dontSetPos = dontSetPos
    self.serverEvent.navTargetPosition = navTargetPosition or position
    
    
    if direct then
		

		local event = self:GetWorkInfo()

		local uniqueId = event and event.uniqueId
		
		self.targetUniqueId = uniqueId
        self:SetInStation()
    end
end

function CommonPartnerWorkBehavior:SetClientEvent(uniqueId,eventType,position,rotation,direct,dontSetPos,navTargetPosition)
    self.clientEvent.uniqueId = uniqueId
    self.clientEvent.eventType = eventType
    self.clientEvent.position = position
    self.clientEvent.rotation = rotation
    self.clientEvent.dontSetPos = dontSetPos
    self.clientEvent.navTargetPosition = navTargetPosition or position
    if direct then
        self:SetInStation()
    end
end
function CommonPartnerWorkBehavior:PathFindingEnd(instanceId)

	if instanceId == self.entity.instanceId then
        self:SetInStation()
    end
end 

function CommonPartnerWorkBehavior:GetWorkInfo()
    
    if self.clientEvent.eventType then
		return self.clientEvent
    elseif self.serverEvent.eventType then
		return self.serverEvent
    end
    
end


--设置上工位
function CommonPartnerWorkBehavior:SetInStation(position,rotation)

    self:ClearPathFinding()
    BehaviorFunctions.CancelLookAt(self.entity.instanceId)
    BehaviorFunctions.StopMove(self.entity.instanceId)

    local event = self:GetWorkInfo()
	
	local position = event and event.position
	local rotation = event and event.rotation
	local eventType = event and event.eventType
	local uniqueId = event and event.uniqueId
	local dontSetPos = event and event.dontSetPos

    if eventType then
        self.workState = PartnerWorkState.fadeing
        if not dontSetPos  then
            BehaviorFunctions.DoSetPosition(self.entity.instanceId, position.x, position.y, position.z)
        end
        BehaviorFunctions.SetEntityEuler(self.entity.instanceId,rotation.x,rotation.y,rotation.z)

        local enterFuc = function (finishType)
            if finishType == FightEnum.DisplayFinishType.FadeIn then
                self.workState = PartnerWorkState.working
            end
        end

        self.entity.displayComponent:Display(eventType,false,enterFuc)
        
    else
        self.entity.displayComponent:Display(FightEnum.PartnerDisplayType.idle)
        self.workState = PartnerWorkState.idle
    end
    

end

function CommonPartnerWorkBehavior:GetWorkAnimSpeed()
    return self.workDisplaySpeed or 1
end


-- 后端更新交互
function CommonPartnerWorkBehavior:OnUpdatePartnerDisplayState(instanceId,state,speed)
    if instanceId == self.entity.instanceId then
        self.serverState = state
        self.workDisplaySpeed = speed
    end
end


-- 后端更新交互
function CommonPartnerWorkBehavior:OnPartnerDisplayUpdate(instanceId,uniqueId,eventType,position,rotation,isClient,direct,dontSetPos,navTargetPosition)
    if instanceId == self.entity.instanceId then
        if isClient then
            
            if eventType == FightEnum.PartnerDisplayType.interact then
                self.clientState = FightEnum.PartnerStatusEnum.Interact
            end
            
            if not eventType and self.clientState == FightEnum.PartnerStatusEnum.Interact then
                self.clientState = nil
            end
            self:SetClientEvent(uniqueId,eventType,position,rotation,direct,dontSetPos,navTargetPosition)
        else
            self:SetServerEvent(uniqueId,eventType,position,rotation,direct,dontSetPos,navTargetPosition)
        end
    end
end

function CommonPartnerWorkBehavior:SetEnable(isEnable)
    self.enable = isEnable
end

function CommonPartnerWorkBehavior:OnCache()
    
	EventMgr.Instance:RemoveListener(EventName.PartnerDisplayUpdate, self:ToFunc("OnPartnerDisplayUpdate"))
    EventMgr.Instance:RemoveListener(EventName.UpdatePartnerDisplayState, self:ToFunc("OnUpdatePartnerDisplayState"))
end

