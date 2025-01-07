---@class FindPathComponent
FindPathComponent = BaseClass("FindPathComponent",PoolBaseClass)
FindPathComponent.DrawFindLine = false

function FindPathComponent:__init()
end

function FindPathComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function FindPathComponent:SetPathFollowPos(pos,startOnGround)
	self.findPos = pos
	self.pathCorners = nil
	self.pathFollowEntity = nil
	self.pathConerUpdateTime = 0

	return self:UpdateFindPathCorners(startOnGround)
end

function FindPathComponent:SetStart(instanceId,startOnGround)
	
end
function FindPathComponent:SetPathFollowEntity(instanceId,startOnGround)
	local pathFollowEntity = self.fight.entityManager:GetEntity(instanceId)
	self.pathFollowEntity = pathFollowEntity
	self.pathCorners = nil
	self.pathConerUpdateTime = 0
	return self:UpdateFindPathCorners()
end

function FindPathComponent:UpdateFindPathCorners(startOnGround)
	if self.pathFollowEntity then
		self.findPos = self.pathFollowEntity.transformComponent.position
	end
	
	if self.pathCorners then
		self.pathConerUpdateTime = self.pathConerUpdateTime + Time.deltaTime
		if self.pathConerUpdateTime < 1 then
			return true
		end
	end

	if not self.transform then
		self.transform = self.entity.clientTransformComponent.transform	
	end
	self.updateFindPos = self.findPos
	local position = self.transform.position
	if startOnGround then
		local h,layer = BehaviorFunctions.CheckPosHeight(position)
		if h then
			position = Vec3.New(position.x,position.y-h,position.z)
		end
	end
	local posArray, count
	--新增飞行寻路逻辑
	if self.entity.moveComponent.isFlyEntity then
		--posArray, count = self:FlyCalculatePath(position, self.findPos)
		count = 1
		if count == 0 then
			return false
		end
		if FindPathComponent.DrawFindLine then

		end
		
		if not self.pathCorners then
			self.pathCorners = {}
		else
			TableUtils.ClearTable(self.pathCorners)
		end
		self.pathIndex = 1
		table.insert(self.pathCorners, self.findPos)
	else
		posArray, count = CustomUnityUtils.NavCalculatePath(position, self.findPos, 1)
		if count == 0 then
			return false
		end

		local lastPos = posArray[count - 1]
		if Vec3.SquareDistance(lastPos, self.findPos) > 1 then
			return false
		end

		local temp = {}
		for i = 0, count - 1 do
			table.insert(temp, Vec3.New(posArray[i].x, posArray[i].y, posArray[i].z))
		end

		local comp = Vec3.New(0, 0, 0)
		local protect = 100
		local result = {}
		local finish = false
		while not finish do
			protect = protect - 1
			if protect <= 0 then
				finish = true
			end

			for i = 1, #temp - 1 do
				table.insert(result, temp[i])
				local dis = Vec3.SquareDistance(temp[i], temp[i + 1])
				if dis < 1 and (i ~= #temp - 1 or Vec3.SquareDistance(temp[i], self.findPos) > 1) then
					-- 新的地块的寻路列表
					posArray, count = CustomUnityUtils.NavCalculatePath(temp[i + 1], self.findPos, 1)
					comp = count > 0 and comp:Set(posArray[0].x, posArray[0].y, posArray[0].z) or comp
					if count > 0 and not comp:Equals(temp[1]) then
						temp = {}
						for j = 0, count - 1 do
							table.insert(temp, Vec3.New(posArray[j].x, posArray[j].y, posArray[j].z))
						end
						break
					end
				end

				if i == #temp - 1 then
					table.insert(result, temp[i + 1])
					finish = true
				end
			end

			if #temp <= 1 then
				if #temp == 1 then
					table.insert(result, temp[1])
				end
				finish = true
			end
		end

		if FindPathComponent.DrawFindLine then
			-- CustomUnityUtils.DrawNavPathRenderLine(self.transform.gameObject, self.findPos, 1)
			self.entity.clientEntity.clientTransformComponent:SetLines(result)
		end

		if not self.pathCorners then
			self.pathCorners = {}
		else
			TableUtils.ClearTable(self.pathCorners)
		end
		self.pathIndex = 1
		self.pathCorners = result
		-- for i = 0, count - 1 do
		-- 	table.insert(self.pathCorners, posArray[i])
		-- end
	end

    self.pathConerUpdateTime = 0

	return true
end

function FindPathComponent:UpdatePathFinding(speed)
	if not self.pathCorners or UtilsBase.IsNull(self.transform)then
		return
	end
	
	if not self:UpdateFindPathCorners() then
		self.fight.entityManager:CallBehaviorFun("PathFindingEnd", self.entity.instanceId, false)
		EventMgr.Instance:Fire(EventName.PathFindEnd, self.entity.instanceId, false)
		return
	end

	local pos = self.pathCorners[self.pathIndex]	
	if not pos then
		Log("self.pathIndex "..self.pathIndex.. "pathCorners count "..#self.pathCorners)
		self.fight.entityManager:CallBehaviorFun("PathFindingEnd", self.entity.instanceId, false)
		EventMgr.Instance:Fire(EventName.PathFindEnd, self.entity.instanceId, false)
		return
	end

	speed = math.max(speed, 0.03)
	local dist = Vec3.DistanceXZ(self.transform.position, pos)
	local distLess = dist < speed
	if distLess then
		while true do
			local oldPos = self.pathCorners[self.pathIndex]
			self.pathIndex = self.pathIndex + 1
			local newPos = self.pathCorners[self.pathIndex]
			if not newPos then
				break	
			end
			
			if Vec3.DistanceXZ(oldPos, newPos) > 0.2 then
				break
			end
		end
	end
	
	if self.pathIndex > #self.pathCorners then
		if Vec3.DistanceXZ(self.transform.position, self.findPos) < 1 then
			self.pathCorners = nil
			self.fight.entityManager:CallBehaviorFun("PathFindingEnd", self.entity.instanceId, true)
			EventMgr.Instance:Fire(EventName.PathFindEnd, self.entity.instanceId, true)
		else
			if not self:UpdateFindPathCorners() then
				self.pathCorners = nil
				self.fight.entityManager:CallBehaviorFun("PathFindingEnd", self.entity.instanceId, false)
				EventMgr.Instance:Fire(EventName.PathFindEnd, self.entity.instanceId, true)
			end
		end
		return
	end

	pos = self.pathCorners[self.pathIndex]
	self.entity.rotateComponent:LookAtPosition(pos.x, pos.z)
	
	return true
end

function FindPathComponent:FlyCalculatePath(startPosition, endPosition)
	---从起点到终点的射线检测，没有障碍则直接移动，有障碍到下一步
	--有障碍时，获取障碍物AABB，计算离起点最近的AABB的面，找到每条边上离起点最近的点，加上一定的偏移后，计算能不能到达
	--从能到达的点，移动到下一个AABB的位置
end

function FindPathComponent:ClearPathFinding()
	self.pathCorners = nil
	self.pathFollowEntity = nil
	if FindPathComponent.DrawFindLine and self.transform then
		CustomUnityUtils.HideNavPathRenderLine(self.transform.gameObject)
	end
end

function FindPathComponent:OnCache()
	self.transform = nil
	self.fight.objectPool:Cache(FindPathComponent,self)
end