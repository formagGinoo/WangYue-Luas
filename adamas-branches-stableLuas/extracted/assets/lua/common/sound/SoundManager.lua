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
	
	self:SetEventLogGmState()
end

function SoundManager:SetEventLogGmState()
	SoundManager.LogBgmState = PlayerPrefs.GetInt("SoundEventLog", 0)
	self.gameWwise:SetEventLogGmState(SoundManager.LogBgmState)
end

function SoundManager:GetGameWwise()
	return self.gameWwise
end

function SoundManager:SetEventAsset(wwiseEventBankAsset)
	self.gameWwise:InitializeEventBank(wwiseEventBankAsset)
end

function SoundManager:PlaySound(soundEvent,holdTime)
	holdTime = holdTime or 60
	self.gameWwise:PlaySound(soundEvent, holdTime)
end

function SoundManager:StopUISound(soundEvent)
	self.gameWwise:StopUISound(soundEvent)
end

function SoundManager:PlayObjectSound(soundEvent, playObject, holdTime)
	holdTime = holdTime or 60
	if not playObject or not soundEvent then
		LogError("soundEvent or playObject is nil")
		return
	end

	self.gameWwise:PlayObjectSound(soundEvent, playObject, holdTime)
end

function SoundManager:PlayBgmSound(soundEvent)
	if not self.bgmSoundEvent or self.bgmSoundEvent ~= soundEvent then
		self:StopBgmSound()
		self.bgmSoundEvent = soundEvent
		self.gameWwise:PlayBgmSound(soundEvent)
	end
end

function SoundManager:StopBgmSound()
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

function SoundManager:StopSound(soundEvent)
	self.gameWwise:StopObjectSound(soundEvent, self.soundObject)
end

function SoundManager:StopObjectSound(soundEvent, playObject)
	self.gameWwise:StopObjectSound(soundEvent, playObject)
end

function SoundManager:StopObjectAllSound(playObject)
	self.gameWwise:StopObjectAllSound(playObject)
end

function SoundManager:StopChannelSound(channelType)
	self.gameWwise:StopChannelSound(channelType)
end

function SoundManager:UnLoadBankByEvent(EventName)
	self.gameWwise:UnLoadBankByEvent(EventName)
end

function SoundManager:OpenChannelSound(channelType)
	self.gameWwise:OpenChannelSound(channelType)
end

function SoundManager:CheckGameObjectPlaySound(soundEvent, playObject)
	return self.gameWwise:CheckGameObjectPlaySound(soundEvent, playObject)
end

function SoundManager:StopAllSound()
	self.bgmSoundEvent = ""
	self.gameWwise:StopAll() 
end