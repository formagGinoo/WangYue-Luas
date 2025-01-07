CameraOffsetManager = BaseClass("CameraOffsetManager")

--规则类似buff
function CameraOffsetManager:__init(cameraManager)
	self.cameraManager = cameraManager
	self.fight = cameraManager.clientFight.fight
	self.instanceId = 0
	self.cameraOffsets = {}--key = instanceId,value = offset,存放所有的offset
	self.cameraOffsetGroups = {}--key = groupId, value = offsets,存放所有的分组
end

function CameraOffsetManager:Create(config)
	local groupId = config.GroupId
	local cameraOffsets = config.CameraOffsets
	local cameraOffset = self.fight.objectPool:Get(CameraOffset)
	
	if groupId > 0 then
		local cameraOffsets = self.cameraOffsetGroups[groupId]
		if cameraOffsets then
			for k, v in pairs(cameraOffsets) do
				self:ChangeOutState(v.instanceId)
			end
		end
	end
	if self.cameraManager.cameraFixedManager:HasFixed() then
		Log("存在固定相机偏移，基础偏移添加失败")
		return
		--self.cameraManager.cameraFixedManager:RealRemoveAll()
	end
	self.instanceId = self.instanceId + 1
 	cameraOffset:Init(cameraOffsets,self.instanceId,groupId,self,config.DurationTime,config.EntityId,config.EaseInTime,config.EaseOutTime,config.UseTimescale)
	self.cameraOffsets[self.instanceId] = cameraOffset
	local cameraOffsetGroup = self.cameraOffsetGroups[groupId]
	if not cameraOffsetGroup then
		self.cameraOffsetGroups[groupId] = {}
		cameraOffsetGroup = self.cameraOffsetGroups[groupId]
	end
	cameraOffsetGroup[self.instanceId] = cameraOffset
	return cameraOffset.instanceId
end

function CameraOffsetManager:Remove(instanceId)
	self:ChangeOutState(instanceId)
end


function CameraOffsetManager:RealRemove(instanceId)
	local cameraOffset = self.cameraOffsets[instanceId]
	if not cameraOffset then
		return
	end

	self.cameraOffsets[cameraOffset.instanceId] = nil
	self.cameraOffsetGroups[cameraOffset.groupId][cameraOffset.instanceId] = nil
	self.fight.objectPool:Cache(CameraOffset,cameraOffset)

	if not next(self.cameraOffsets) then
		self:OffsetEnd()
	end
end

function CameraOffsetManager:OffsetEnd()
	local ShakeType
	local Lenght = FightEnum.CameraShakeType.Lenght
	for _, val in pairs(FightEnum.CameraShakeType) do
		if val ~= Lenght then
			ShakeType = val + Lenght - 3
			self.cameraManager:NoiseEffectEnd(ShakeType)
		end
	end
end

function CameraOffsetManager:ChangeOutState(instanceId)
	local cameraOffset = self.cameraOffsets[instanceId]
	if not cameraOffset then
		return
	end
	cameraOffset:ChangeOutState()
end

function CameraOffsetManager:RealRemoveAll()
	for k, v in pairs(self.cameraOffsets) do
		self:RealRemove(v.instanceId)
	end
end

function CameraOffsetManager:Update(lerpTime)
	 for k, v in pairs(self.cameraOffsets) do
	 	v:Update(lerpTime)
	 end
end

function CameraOffsetManager:__delete()
end