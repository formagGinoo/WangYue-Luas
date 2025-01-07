CameraShakeManager = BaseClass("CameraShakeManager")

function CameraShakeManager:__init(cameraManager)
	self.cameraManager = cameraManager
	self.fight = cameraManager.clientFight.fight
	self.instanceId = 0
	self.enable = true
	self.shakes = {}
	self.shakeInstances = {}
	self.shakeSigns = {}
	self.addQueue = {}
	self.removeQueue = {}

	self.triggerShakeEntityFrameMap = {}
	self.noiseValue = {
		[FightEnum.CameraShakeType.Shake6D] = {
			Amplitude = 0,
			Frequency = 0,
			},
		[FightEnum.CameraShakeType.PositionX] = {
			Amplitude = 0,
			Frequency = 0,
			},
		[FightEnum.CameraShakeType.PositionY] = {
			Amplitude = 0,
			Frequency = 0,
			},
		[FightEnum.CameraShakeType.PositionZ] = {
			Amplitude = 0,
			Frequency = 0,
			},
		[FightEnum.CameraShakeType.RotationX] = {
			Amplitude = 0,
			Frequency = 0,
			},
		[FightEnum.CameraShakeType.RotationY] = {
			Amplitude = 0,
			Frequency = 0,
			},
		[FightEnum.CameraShakeType.RotationZ] = {
			Amplitude = 0,
			Frequency = 0,
			},
	}

	self.shakeSkillMap = {}
	self.shieldShakeData = nil
end

function CameraShakeManager:Update()
	for i = 1, #self.shakeInstances do
		local shake = self.shakes[self.shakeInstances[i]]
		if shake then
			shake:Update()
		else
			table.insert(self.removeQueue,i)
		end
	end
	for i = 1, #self.addQueue do
		local shake = self.shakes[self.addQueue[i]]
		if shake then
			shake:Update()
			table.insert(self.shakeInstances,shake.instanceId)
		end
	end

	for i = #self.addQueue, 1, -1 do
		table.remove(self.addQueue)
	end

	for i = #self.removeQueue, 1,-1 do
		table.remove(self.shakeInstances,self.removeQueue[i])
	end

	for i = #self.removeQueue, 1, -1 do
		table.remove(self.removeQueue)
	end
	
	self:SetNoise()
	self:CheckRemoveShieldShakeData()
end

function CameraShakeManager:SetNoise()
	for k, v in pairs(self.noiseValue) do
		if v.Change then
			self.cameraManager:SetNoise(k,v.Amplitude,v.Frequency,v.ResetTime,v.StartOffset,v.Random)
			v.Change = false
		end
	end
end

function CameraShakeManager:SetNoiseScale(timeScale)
	self.cameraManager:UpdateNoiseTimeScale(timeScale)
end

function CameraShakeManager:AddNoise(type,amplitude,frequency,resetTime,startOffset,random)
	
	self.noiseValue[type].Change = true
	self.noiseValue[type].ResetTime = resetTime
	self.noiseValue[type].Amplitude = self.noiseValue[type].Amplitude + amplitude
	self.noiseValue[type].Frequency = self.noiseValue[type].Frequency + frequency
	self.noiseValue[type].StartOffset = startOffset
	self.noiseValue[type].Random = random
end

function CameraShakeManager:CheckTriggerShake(skillId)
	if not self.enable then
		return
	end

	if self.shieldShakeData then
		local shieldShakeType = self.shieldShakeData.shieldShakeType
		if shieldShakeType == FightEnum.ShieldCameraShakeType.AllShake then
			return
		elseif shieldShakeType == FightEnum.ShieldCameraShakeType.NoSelfShake and self.shieldShakeData.triggerSkillId ~= skillId then
			return
		end
	end

	return true
end

function CameraShakeManager:Shake(params, entity)
	local shakeType = params.ShakeType
	local sign = params.Sign
	local instanceId = entity.instanceId
	local skillComponent = entity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end

	if not self:CheckTriggerShake(curSkillId) then
		return
	end

	local curFrame = self.fight.fightFrame
	local lastFrameData = self.triggerShakeEntityFrameMap[instanceId]
	if lastFrameData then
		local shakeFrame = lastFrameData[shakeType]
		if shakeFrame and shakeFrame == curFrame then
			return
		end
	end

	if sign > 0 and self.shakeSigns[sign] then
		return
		--self:RemoveShake(self.shakeSigns[sign])
	end

	self.triggerShakeEntityFrameMap[instanceId] = self.triggerShakeEntityFrameMap[instanceId] or {}
	self.triggerShakeEntityFrameMap[instanceId][shakeType] = curFrame

	local shake = self.fight.objectPool:Get(CameraShake)
	self.instanceId = self.instanceId + 1
	shake:Init(self,self.instanceId, params)
	self.shakes[shake.instanceId] = shake
	self.shakeSigns[sign] = shake.instanceId
	table.insert(self.addQueue,shake.instanceId)

	self.shakeSkillMap[curSkillId] = self.shakeSkillMap[curSkillId] or {}
	table.insert(self.shakeSkillMap[curSkillId], shake.instanceId)

	return shake.instanceId
end

function CameraShakeManager:AddShieldShakeData(data, entity)
	local skillComponent = entity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end

	local curFrame = self.fight.fightFrame
	local endFrame = curFrame + data.durationFrame

	-- 同一时间存在一个屏蔽数据，后来的直接覆盖这个
	self.shieldShakeData = data
	self.shieldShakeData.triggerSkillId = curSkillId
	self.shieldShakeData.endFrame = endFrame

	local shieldType = data.shieldShakeType
	if shieldType == FightEnum.ShieldCameraShakeType.NoSelfShake then
		self:RemoveShakeBySkillId(curSkillId)
	elseif shieldType == FightEnum.ShieldCameraShakeType.AllShake then
		self:RemoveAllShake()
	end
end

function CameraShakeManager:CheckRemoveShieldShakeData()
	if not self.shieldShakeData then return end
	local curFrame = self.fight.fightFrame
	if self.shieldShakeData.endFrame <= curFrame then
		self.shieldShakeData = nil
	end
end

function CameraShakeManager:BreakShieldShake()
	if not self.shieldShakeData then
		return
	end

	if not self.shieldShakeData.BindSkill then
		return
	end
	self.shieldShakeData = nil
end

function CameraShakeManager:RemoveShakeBySkillId(skillId)
	for id, insIdMap in pairs(self.shakeSkillMap) do
		if id ~= skillId or id == 0 then
			for _, insId in pairs(insIdMap) do
				self:RemoveShake(insId)
			end
			insIdMap = {}
		end
	end
end

function CameraShakeManager:RemoveShake(instanceId)
	local shake = self.shakes[instanceId]
	if not shake then
		return
	end
	self.shakeSigns[shake.sign] = nil
	self.shakes[instanceId] = nil

	for _, insIdMap in pairs(self.shakeSkillMap) do
		for idx, insId in ipairs(insIdMap) do
			if insId == instanceId then
				table.remove(insIdMap, idx)
				break
			end
		end
	end

	self.fight.objectPool:Cache(CameraShake,shake)
end

function CameraShakeManager:RemoveAllShake()
	for i = 1, #self.shakeInstances do
		local shake = self.shakes[self.shakeInstances[i]]
		if shake then
			self:RemoveShake(shake.instanceId)
		end
	end
end

function CameraShakeManager:EnableShake(enable)
	self.enable = enable
end

function CameraShakeManager:__delete()
end