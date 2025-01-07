CameraShake = BaseClass("CameraShake",PoolBaseClass)

function CameraShake:__init()
	self.amplitude = 0
	self.frequency = 0
end

function CameraShake:Init(cameraShakeManager,instanceId,shakeType,startAmplitude,startFrequency,
	targetAmplitude,targetFrequency,amplitudeChangeTime,frequencyChangeTime,durationTime,sign,distanceDampingId,startOffset,random)
	self.cameraShakeManager = cameraShakeManager
	self.fight = cameraShakeManager.cameraManager.clientFight.fight
	self.lastAmplitude = 0
	self.lastFrequency = 0
	self.instanceId = instanceId
	self.shakeType = shakeType
	self.startOffset = startOffset or 0
	self.amplitude = startAmplitude
	self.frequency = startFrequency
	self.targetAmplitude = targetAmplitude
	self.targetFrequency = targetFrequency
	self.amplitudeChangeTime = amplitudeChangeTime
	self.amplitudeChangeOffset = (targetAmplitude - startAmplitude) / amplitudeChangeTime
	self.frequencyChangeTime = frequencyChangeTime
	self.frequencyChangeOffset = (targetFrequency - startFrequency) / frequencyChangeTime
	self.durationTime = durationTime
	self.sign = sign
	self.random = random
	--self.distanceDampingConfig = Config.CameraShakeDistanceDampingConfig[distanceDampingId]
	self.first = true
	self.totalA = 0
	self.totalF = 0
end

function CameraShake:Update()
	--local timeScale = self.fight.entityManager.enemyCommonTimeScale
	local timeScale = self.cameraShakeManager.cameraManager:GetMainRoleTimeScale()
	local time = Time.deltaTime * timeScale
	
	
	if self.durationTime <= 0 then
		--self.cameraShakeManager:AddNoise(self.shakeType,
			---self.lastAmplitude,-self.lastFrequency)
		self.cameraShakeManager:RemoveShake(self.instanceId)
	else
		self.totalA = self.totalA + self.amplitude - self.lastAmplitude
		self.totalF = self.totalF + self.frequency - self.lastFrequency
		self.cameraShakeManager:AddNoise(self.shakeType,
			self.amplitude - self.lastAmplitude,self.frequency - self.lastFrequency,self.first,self.startOffset,self.random)
	end
	self.first = false
	self.lastAmplitude = self.amplitude
	self.lastFrequency = self.frequency
	
	if self.amplitudeChangeTime <= 0 then
		self.amplitude = self.targetAmplitude
	else
		self.amplitude = self.amplitude + self.amplitudeChangeOffset * time
	end
	if self.frequencyChangeTime <= 0 then
		self.frequency = self.targetFrequency
	else
		self.frequency = self.frequency + self.frequencyChangeOffset * time 
	end
	
	self.durationTime = self.durationTime - time
	self.amplitudeChangeTime = self.amplitudeChangeTime - time
	self.frequencyChangeTime = self.frequencyChangeTime - time
end

function CameraShake:__cache()
	self.cameraShakeManager:AddNoise(self.shakeType,
		-self.totalA,-self.totalF,self.first,self.startOffset)
end

function CameraShake:__delete()
end