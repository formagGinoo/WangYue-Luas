CameraShake = BaseClass("CameraShake",PoolBaseClass)

function CameraShake:__init()
	self.amplitude = 0
	self.startFrequency = 0
end

function CameraShake:Init(cameraShakeManager, instanceId, params)
	self.cameraShakeManager = cameraShakeManager
	self.fight = cameraShakeManager.cameraManager.clientFight.fight
	self.lastAmplitude = 0
	self.lastFrequency = 0
	self.instanceId = instanceId
	self.shakeType = params.ShakeType
	self.startOffset = params.StartOffset or 0
	self.amplitude = params.StartAmplitude
	self.startFrequency = params.StartFrequency
	self.targetAmplitude = params.TargetAmplitude
	self.targetFrequency = params.TargetFrequency
	self.amplitudeChangeTime = params.AmplitudeChangeTime
	self.amplitudeChangeOffset = (self.targetAmplitude - self.amplitude) / self.amplitudeChangeTime
	self.frequencyChangeTime = params.FrequencyChangeTime
	self.frequencyChangeOffset = (self.targetFrequency - self.startFrequency) / self.frequencyChangeTime
	self.durationTime = params.DurationTime
	self.sign = params.Sign
	self.random = params.Random
	self.isNoTimeScale = params.IsNoTimeScale
	self.timeScaleMinVal = params.TimeScaleMinVal or 0

	--self.distanceDampingConfig = Config.CameraShakeDistanceDampingConfig[distanceDampingId]
	self.first = true
	self.totalA = 0
	self.totalF = 0
end

function CameraShake:Update()
	--local timeScale = self.fight.entityManager.commonTimeScaleManager.enemyCommonTimeScale
	local timeScale = self.cameraShakeManager.cameraManager:GetMainRoleTimeScale()
	timeScale = self.isNoTimeScale and 1 or timeScale

	if self.isNoTimeScale then
		self.cameraShakeManager:SetNoiseScale(1)
	else
		timeScale = math.max(timeScale, self.timeScaleMinVal)
		self.cameraShakeManager:SetNoiseScale(timeScale)
	end

	local time = Time.deltaTime * timeScale
	
	if self.durationTime <= 0 then
		--self.cameraShakeManager:AddNoise(self.shakeType,
			---self.lastAmplitude,-self.lastFrequency)
		self.cameraShakeManager:RemoveShake(self.instanceId)
	else
		self.totalA = self.totalA + self.amplitude - self.lastAmplitude
		self.totalF = self.totalF + self.startFrequency - self.lastFrequency
		self.cameraShakeManager:AddNoise(self.shakeType,
			self.amplitude - self.lastAmplitude,self.startFrequency - self.lastFrequency,self.first,self.startOffset,self.random)
	end
	self.first = false
	self.lastAmplitude = self.amplitude
	self.lastFrequency = self.startFrequency
	
	if self.amplitudeChangeTime <= 0 then
		self.amplitude = self.targetAmplitude
	else
		self.amplitude = self.amplitude + self.amplitudeChangeOffset * time
	end

	if self.frequencyChangeTime <= 0 then
		self.startFrequency = self.targetFrequency
	else
		self.startFrequency = self.startFrequency + self.frequencyChangeOffset * time 
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