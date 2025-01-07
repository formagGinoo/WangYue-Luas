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
end

function CameraShakeManager:SetNoise()
	for k, v in pairs(self.noiseValue) do
		if v.Change then
			self.cameraManager:SetNoise(k,v.Amplitude,v.Frequency,v.ResetTime,v.StartOffset,v.Random)
			v.Change = false
		end
	end
end

function CameraShakeManager:AddNoise(type,amplitude,frequency,resetTime,startOffset,random)
	
	self.noiseValue[type].Change = true
	self.noiseValue[type].ResetTime = resetTime
	self.noiseValue[type].Amplitude = self.noiseValue[type].Amplitude + amplitude
	self.noiseValue[type].Frequency = self.noiseValue[type].Frequency + frequency
	self.noiseValue[type].StartOffset = startOffset
	self.noiseValue[type].Random = random
end

function CameraShakeManager:Shake(shakeType,startAmplitude,startFrequency,
	targetAmplitude,targetFrequency,amplitudeChangeTime,frequencyChangeTime,durationTime,sign,distanceDampingId,startOffset,random)	
	if not self.enable then
		return
	end
	if sign > 0 and self.shakeSigns[sign] then
		return
		--self:RemoveShake(self.shakeSigns[sign])
	end
	local shake = self.fight.objectPool:Get(CameraShake)
	self.instanceId = self.instanceId + 1
	shake:Init(self,self.instanceId,shakeType,startAmplitude,startFrequency,
	targetAmplitude,targetFrequency,amplitudeChangeTime,frequencyChangeTime,durationTime,sign,distanceDampingId,startOffset,random)
	self.shakes[shake.instanceId] = shake
	self.shakeSigns[sign] = shake.instanceId
	table.insert(self.addQueue,shake.instanceId)
	return shake.instanceId
end

function CameraShakeManager:RemoveShake(instanceId)
	local shake = self.shakes[instanceId]
	if not shake then
		return
	end
	self.shakeSigns[shake.sign] = nil
	self.shakes[instanceId] = nil
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