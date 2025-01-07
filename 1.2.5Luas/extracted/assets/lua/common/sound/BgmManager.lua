


BgmManager = SingleClass("BgmManager")

local BgmStateConfig = Config.MusicState 

local AreaTypeStateGroup =
{
	[FightEnum.AreaType.Small] = "SmallArea",
	[FightEnum.AreaType.Mid] = "MidArea",
}

local SwitchGroup =
{
	["ActiveBGM"] = true,
	["BgmType"] = true,
	["MidArea"] = true,
	["SmallArea"] = true,
}

function BgmManager:__init(bgmObject)
	self.bgmObject = bgmObject
	self.stateGroup = {}
	self.stateValueConfigMap = {}
	self.deleteBankMap = {}
	self:InitEvent()
	self:InitConfig()
end

function BgmManager:InitWorldBgm()	
	self.playState = ""
	self.preloadPlayState = ""
	self.loadingPlayState = ""
	TableUtils.ClearTable(self.deleteBankMap)
	self:SetBgmState("ActiveBGM", "TRUE")
	self:SetBgmState("BgmType", "GamePlay")
	self:SetBgmState("PlayerLife", "Alive")
	self:SetBgmState("GamePlayType", "Explore")
	SoundManager.Instance:PlayBgmSound("Bgm_Logic")
end

function BgmManager:InitEvent()
	EventMgr.Instance:AddListener(EventName.Revive, self:ToFunc("Revive"))
	EventMgr.Instance:AddListener(EventName.OnEntityDeath, self:ToFunc("EnterDeath"))
	EventMgr.Instance:AddListener(EventName.EnterMapArea, self:ToFunc("EnterMapArea"))
	EventMgr.Instance:AddListener(EventName.ExitMapArea, self:ToFunc("ExitMapArea"))
end

function BgmManager:InitConfig()
	self.statePlayMap = {}
	for _, audioEntry in pairs(BgmStateConfig.audioEntryList) do
		local list = StringHelper.SplitParam(audioEntry.state, ".")
		for k, v in pairs(list) do
			self.stateValueConfigMap[v] = true
		end
		self.statePlayMap[audioEntry.state] = audioEntry.audioList
	end
end

function BgmManager:Revive()
	self:SetBgmState("PlayerLife", "Alive")
end

function BgmManager:EnterDeath()
	if instanceId == BehaviorFunctions.GetCtrlEntity() then
		self:SetBgmState("PlayerLife", "Dead")
	end
end

function BgmManager:EnterMapArea(areaType, areaId)
	if not areaId then
		return
	end

	local stateGroup = AreaTypeStateGroup[areaType]
	if not stateGroup then
		return
	end

	self:SetBgmState(stateGroup, stateGroup..areaId)
end

function BgmManager:ExitMapArea(areaType, areaId)
	if not areaId then
		return
	end

	local stateGroup = AreaTypeStateGroup[areaType]
	if not stateGroup then
		return
	end

	self:SetBgmState(stateGroup, 0)
end

function BgmManager:SetBgmState(stateGroup, state)
	if not self.stateValueConfigMap[state] then
		state = "default"
	end

	self.stateGroup[stateGroup] = state
	self:PlayBgm()
end

function BgmManager:SetActiveBGM(state)
	self.stateGroup["ActiveBGM"] = state
	GameWwiseContext.SetSwitch("ActiveBGM", state, self.bgmObject)
end

function BgmManager:GetStateAudioList()
	local audioList
	local playMap = self.statePlayMap
	local playState = ""
	for k, stateGroup in ipairs(BgmStateConfig.stateGroupList) do
		if playState ~= "" then
			playState = playState.."."
		end
		local state = self.stateGroup[stateGroup] or "default" 
		playState = playState..state
	end

	return self.statePlayMap[playState], playState
end

function BgmManager:PlayBgm()
	local audioList, playState = self:GetStateAudioList()
	if not audioList then
		return
	end

	self.preloadPlayState = playState
	if self.loadingPlayState ~= "" then
		return
	end

	self.loadingPlayState = playState

    local cb = function()
		self.loadingPlayState = ""
    	if self.playState == playState then
    		return
    	end

		-- LogInfo("PlayBgm "..playState.."load suc "..audioList[1])
		self.playState = playState
		if self.preloadPlayState ~= self.playState then 
			self:PlayBgm()
			return
		end

		local time = os.time()
    	if self.playAudioList then
    		for k, v in pairs(self.playAudioList) do
    			self.deleteBankMap[v] = time
    		end
    	end
    	self:UnLoadBgm()

		self.preloadPlayState = ""
		self.playAudioList = audioList
		for k, stateGroup in ipairs(BgmStateConfig.stateGroupList) do
			local state = self.stateGroup[stateGroup] or "default" 
			if SwitchGroup[stateGroup] then
				if self.bgmObject then
					GameWwiseContext.SetSwitch(stateGroup, state, self.bgmObject)
				end
			else
				GameWwiseContext.SetState(stateGroup, state)
			end
		end
    end
	
	local gameWwise = SoundManager.Instance:GetGameWwise()
	gameWwise:LoadSoundBank(audioList[1], -1, true, cb)

	self:UnLoadBgm()
end

function BgmManager:UnLoadBgm()
	--先立马删除
	local gameWwise = SoundManager.Instance:GetGameWwise()
	for bankName, time in pairs(self.deleteBankMap) do 
		gameWwise:UnLoadSoundBank(bankName)
	end
	TableUtils.ClearTable(self.deleteBankMap)
end

function BgmManager:PrintBgmState()
	print("playState "..self.playState)
end

