SoundManager = SingleClass("SoundManager")

SoundManager.ChannelType = 
{
	Bgm = 1,
	Sound = 2,
	Object = 3,
}

SoundManager.ActionEvent =
{
	AkActionOnEventType_Stop = 0,
	AkActionOnEventType_Pause = 1,
	AkActionOnEventType_Resume = 2,
	AkActionOnEventType_Break = 3,
	AkActionOnEventType_ReleaseEnvelope = 4
}

SoundManager.AkCurveInterpolation =
{
	AkCurveInterpolation_Log3 = 0,
	AkCurveInterpolation_Sine = 1,
	AkCurveInterpolation_Log1 = 2,
	AkCurveInterpolation_InvSCurve = 3,
	AkCurveInterpolation_Linear = 4,
	AkCurveInterpolation_SCurve = 5,
	AkCurveInterpolation_Exp1 = 6,
	AkCurveInterpolation_SineRecip = 7,
	AkCurveInterpolation_Exp3 = 8,
	AkCurveInterpolation_LastFadeCurve = 8,
	AkCurveInterpolation_Constant = 9
}

function SoundManager:__init()
	local SoundRootObject = GameObject("SoundRoot")	
	local SoundRootTransform = SoundRootObject.transform
	GameObject.DontDestroyOnLoad(SoundRootObject)
	self.gameWwise = SoundRootObject:AddComponent(CS.GameWwise.GameWwiseContext)
	self.soundObject = SoundRootTransform:Find("SoundChannel").gameObject
	self.bgmObject = SoundRootTransform:Find("BgmChannel").gameObject 
	self.bgmSoundEvent = nil
	BgmManager.New(self.bgmObject)
end

function SoundManager:GetGameWwise()
	return self.gameWwise
end

function SoundManager:SetEventAsset(wwiseEventBankAsset)
	self.gameWwise:InitializeEventBank(wwiseEventBankAsset)
end

function SoundManager:PlaySound(soundEvent)
	self.gameWwise:PlaySound(soundEvent)
end

function SoundManager:PlayObjectSound(soundEvent, playObject)
	if not playObject then
		return
	end

	self.gameWwise:PlayObjectSound(soundEvent, playObject)
end

function SoundManager:PlayBgmSound(soundEvent)
	if not self.bgmSoundEvent or self.bgmSoundEvent ~= soundEvent then
		self.bgmSoundEvent = soundEvent
		self.gameWwise:PlayBgmSound(soundEvent)
	end
end

function SoundManager:StopBgmSound(soundEvent)
	if self.bgmSoundEvent then
		self.gameWwise:StopObjectSound(self.bgmSoundEvent, self.bgmObject)
		self.bgmSoundEvent = nil
	end
end

function SoundManager:PauseBgmSound()
	if self.bgmSoundEvent then
		self.gameWwise:PauseObjectSound(self.bgmSoundEvent, self.bgmObject)
	end
end

function SoundManager:ResumeBgmSound()
	if self.bgmSoundEvent then
		self.gameWwise:ResumeObjectSound(self.bgmSoundEvent, self.bgmObject)
	end
end

function SoundManager:StopSound()
	
end

function SoundManager:StopObjectSound(soundEvent, playObject)
	self.gameWwise:StopObjectSound(soundEvent, playObject)
end

function SoundManager:StopChannelSound(channelType)
	self.gameWwise:StopChannelSound(channelType)
end

function SoundManager:OpenChannelSound(channelType)
	self.gameWwise:OpenChannelSound(channelType)
end
