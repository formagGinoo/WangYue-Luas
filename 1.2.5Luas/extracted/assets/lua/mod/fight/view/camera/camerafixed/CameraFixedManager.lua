CameraFixedManager = BaseClass("CameraFixedManager")

--规则类似buff
function CameraFixedManager:__init(cameraManager)
	self.cameraManager = cameraManager
	self.fight = cameraManager.clientFight.fight
	self.instanceId = 0
	self.cameraFixeds = {}--key = instanceId,value = fixed,存放所有的fixed
	self.cameraFixedGroups = {}--key = groupId, value = fixeds,存放所有的分组
end

function CameraFixedManager:Create(config)
	local groupId = config.GroupId
	local cameraFixeds = config.CameraFixeds
	local cameraFixed = self.fight.objectPool:Get(CameraFixed)

	--if groupId > 0 then
	--local cameraFixeds = self.cameraFixedGroups[groupId]
	--if cameraFixeds then
	--for k, v in pairs(cameraFixeds) do
	--self:ChangeOutState(v.instanceId)
	--end
	--end
	--end
	self:RealRemoveAll()
	self.cameraManager.cameraOffsetManager:RealRemoveAll()

	self.instanceId = self.instanceId + 1
	cameraFixed:Init(cameraFixeds,self.instanceId,groupId,self,config.DurationTime,config.EntityId,config.EaseInTime,config.EaseOutTime,config.UseTimescale)
	self.cameraFixeds[self.instanceId] = cameraFixed
	local cameraFixedGroup = self.cameraFixedGroups[groupId]
	if not cameraFixedGroup then
		self.cameraFixedGroups[groupId] = {}
		cameraFixedGroup = self.cameraFixedGroups[groupId]
	end
	cameraFixedGroup[self.instanceId] = cameraFixed
	return cameraFixed.instanceId
end

function CameraFixedManager:Remove(instanceId)
	self:ChangeOutState(instanceId)
end


function CameraFixedManager:HasFixed()
	if not next(self.cameraFixeds) then
		return false
	end
	for k, v in pairs(self.cameraFixeds) do
		if not v.outState then
			return false
		end
	end
	return true
end

function CameraFixedManager:RealRemove(instanceId)
	local cameraFixed = self.cameraFixeds[instanceId]
	if not cameraFixed then
		return
	end
	self.cameraFixeds[cameraFixed.instanceId] = nil
	self.cameraFixedGroups[cameraFixed.groupId][cameraFixed.instanceId] = nil
	self.fight.objectPool:Cache(CameraFixed,cameraFixed)
end

function CameraFixedManager:ChangeOutState(instanceId)
	local cameraFixed = self.cameraFixeds[instanceId]
	if not cameraFixed then
		return
	end
	cameraFixed:ChangeOutState()
end

function CameraFixedManager:RealRemoveAll()
	for k, v in pairs(self.cameraFixeds) do
		self:RealRemove(v.instanceId)
	end
end

function CameraFixedManager:Update(lerpTime)
	for k, v in pairs(self.cameraFixeds) do
		v:Update(lerpTime)
	end
end

function CameraFixedManager:__delete()
end