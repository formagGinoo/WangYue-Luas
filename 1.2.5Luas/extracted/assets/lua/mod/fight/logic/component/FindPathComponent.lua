---@class FindPathComponent
FindPathComponent = BaseClass("FindPathComponent",PoolBaseClass)
FindPathComponent.DrawFindLine = false

function FindPathComponent:__init()
end

function FindPathComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
end

function FindPathComponent:SetPathFollowPos(pos)
	self.findPos = pos
	self.pathCorners = nil
	self.pathFollowEntity = nil
	self.pathConerUpdateTime = 0
	return self:UpdateFindPathCorners()
end

function FindPathComponent:SetPathFollowEntity(instanceId)
	local pathFollowEntity = self.fight.entityManager:GetEntity(instanceId)
	self.pathFollowEntity = pathFollowEntity
	self.pathCorners = nil
	self.pathConerUpdateTime = 0
	return self:UpdateFindPathCorners()
end

function FindPathComponent:UpdateFindPathCorners()
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
		self.transform = self.entity.clientEntity.clientTransformComponent.transform	
	end
	
	
	self.updateFindPos = self.findPos
	
	local position = self.transform.position
	local posArray, count = CustomUnityUtils.NavCalculatePath(position, self.findPos, 1)
	if count == 0 then
		return false
	end
	
	local lastPos = posArray[count - 1]
	if Vec3.SquareDistance(lastPos, self.findPos) > 1 then
		return false
	end

	if FindPathComponent.DrawFindLine then
		CustomUnityUtils.DrawNavPathRenderLine(self.transform.gameObject, self.findPos, 1)
	end

	if not self.pathCorners then
		self.pathCorners = {}
	else
		TableUtils.ClearTable(self.pathCorners)
	end
	self.pathIndex = 1	
    for i = 0, count - 1 do
		table.insert(self.pathCorners, posArray[i])
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
		return
	end

	local pos = self.pathCorners[self.pathIndex]	
	if not pos then
		Log("self.pathIndex "..self.pathIndex.. "pathCorners count "..#self.pathCorners)
		self.fight.entityManager:CallBehaviorFun("PathFindingEnd", self.entity.instanceId, false)
		return
	end

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
		else
			if not self:UpdateFindPathCorners() then
				self.pathCorners = nil
				self.fight.entityManager:CallBehaviorFun("PathFindingEnd", self.entity.instanceId, false)
			end
		end
		return
	end

	pos = self.pathCorners[self.pathIndex]
	self.entity.rotateComponent:LookAtPosition(pos.x, pos.z)
	return true
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