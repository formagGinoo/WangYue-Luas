


BgmManager = SingleClass("BgmManager")

local BgmStateConfig = Config.MusicState

-- local AreaTypeStateGroup =
-- {
-- 	[FightEnum.AreaType.Small] = "SmallArea",
-- 	[FightEnum.AreaType.Mid] = "MidArea",
-- }

local SwitchGroup =
{
	["ActiveBGM"] = true,
	["BgmType"] = true,
	["Area"] = true,
	["SpecialArea"] = true,
	["MapId"] = true,
}

local BgmTypeDefalut =
{
	["Area"] = true,
	["SpecialArea"] = true,
	["MapId"] = true,
	["PlayerLife"] = true,
	["GameTime"] = true
}

local SpecialAreaDefault =
{
	["Area"] = true,
}

local GamePlayTypeDefault =
{
	["GameTime"] = true
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
	self:InitBgmState()
	self:SetBgmState("ActiveBGM", "TRUE")
	self:SetBgmState("BgmType", "GamePlay")
	self:SetBgmState("PlayerLife", "Alive")
	self:SetBgmState("GamePlayType", "Explore")
	self:RefreshTimeState()
	SoundManager.Instance:PlayBgmSound("Bgm_Logic")
end

function BgmManager:InitBgmState()
	self.playState = ""
	self.preloadPlayState = ""
	self.loadingPlayState = ""
	self.playAudioList = nil
	self:UnLoadBgm()
end

function BgmManager:InitEvent()
	EventMgr.Instance:AddListener(EventName.Revive, self:ToFunc("OnRevive"))
	EventMgr.Instance:AddListener(EventName.OnEntityDeath, self:ToFunc("OnEnterDeath"))
	--EventMgr.Instance:AddListener(EventName.EnterMapArea, self:ToFunc("OnEnterMapArea"))
	--EventMgr.Instance:AddListener(EventName.ExitMapArea, self:ToFunc("OnExitMapArea"))
	EventMgr.Instance:AddListener(EventName.StartFight, self:ToFunc("OnStartFight"))

	EventMgr.Instance:AddListener(EventName.DayNightHourChanged, self:ToFunc("RefreshTimeState"))
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

function BgmManager:OnRevive()
	self:SetBgmState("PlayerLife", "Alive")
end

function BgmManager:OnEnterDeath()
	if instanceId == BehaviorFunctions.GetCtrlEntity() then
		self:SetBgmState("PlayerLife", "Dead")
	end
end

function BgmManager:RefreshTimeState()
	local h,m = DayNightMgr.Instance:GetStandardTime()
	if h >= 6 and h < 9 then
		self:SetBgmState("GameTime", "Morning")
	elseif h>=9 and h<17 then
		self:SetBgmState("GameTime", "Day")
	elseif h>=17 and h<19 then
		self:SetBgmState("GameTime", "Evening")
	elseif h>=19 or h<6 then
		self:SetBgmState("GameTime", "Night")
	end
end

-- function BgmManager:OnEnterMapArea(areaType, areaId)
-- 	if not areaId then
-- 		return
-- 	end

-- 	local stateGroup = AreaTypeStateGroup[areaType]
-- 	if not stateGroup then
-- 		return
-- 	end

-- 	self:SetBgmState(stateGroup, stateGroup..areaId)
-- end

-- function BgmManager:OnExitMapArea(areaType, areaId)
-- 	if not areaId then
-- 		return
-- 	end

-- 	local stateGroup = AreaTypeStateGroup[areaType]
-- 	if not stateGroup then
-- 		return
-- 	end

-- 	self:SetBgmState(stateGroup, 0)
-- end

function BgmManager:OnStartFight()
	local mapId = Fight.Instance:GetFightMap()
	self:SetBgmState("MapId", "MapId"..mapId)
	self:SetBgmState("SpecialArea","default")
end

function BgmManager:SetBgmState(stateGroup, state)
	if not self.stateValueConfigMap[state] then
		state = "default"
	end
	
	if state == "Explore" or state == "Combat" then
		if self.stateGroup["BgmType"] ~= "GamePlay" then
			return
		end
	end

	self.stateGroup[stateGroup] = state
	self:PlayBgm()
end

function BgmManager:GetBgmState(stateGroup)
	return self.stateGroup[stateGroup] or "default"
end

function BgmManager:SetActiveBGM(state)
	self.stateGroup["ActiveBGM"] = state
	if state == "FALSE" then
		self:InitBgmState()
	else
		SoundManager.Instance:PlayBgmSound("Bgm_Logic")
	end
	GameWwiseContext.SetSwitch("ActiveBGM", state, self.bgmObject)
end

function BgmManager:GetStateAudioList()
	local audioList
	local playMap = self.statePlayMap
	local playState = ""
	local state
	local bgmTypeState = self.stateGroup["BgmType"] or "default"
	local specialAreaState = self.stateGroup["SpecialArea"] or "default"
	local gamePlayTypeState = self.stateGroup["GamePlayType"] or "default"

	local state
	for k, stateGroup in ipairs(BgmStateConfig.stateGroupList) do
		if playState ~= "" then
			playState = playState.."."
		end
		local isDefault = false
		if bgmTypeState ~= "GamePlay" and BgmTypeDefalut[stateGroup]  then
			isDefault = true
		else
			state = self.stateGroup[stateGroup] or "default"
		end

		if specialAreaState ~= "default" and SpecialAreaDefault[stateGroup]  then
			isDefault = true
		else
			state = self.stateGroup[stateGroup] or "default"
		end

		if gamePlayTypeState ~= "Explore" and GamePlayTypeDefault[stateGroup]  then
			isDefault = true
		else
			state = self.stateGroup[stateGroup] or "default"
		end

		if isDefault then
			state = "default"
		end

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

		if not self.unLoadTimer then
			self.unLoadTimer = LuaTimerManager.Instance:AddTimer(1, 3, function ()
				self.unLoadTimer = nil
				local gameWwise = SoundManager.Instance:GetGameWwise()
				for bankName, time in pairs(self.deleteBankMap) do
					if bankName ~= self.playAudioList[1] then
						gameWwise:UnLoadSoundBank(bankName)
					end
				end
				TableUtils.ClearTable(self.deleteBankMap)
			end)
		end

		self.preloadPlayState = ""
		self.playAudioList = audioList
		
		
		local bgmTypeState = self.stateGroup["BgmType"] or "default"
		local specialAreaState = self.stateGroup["SpecialArea"] or "default"
		local gamePlayTypeState = self.stateGroup["GamePlayType"] or "default"

		local state
		for k, stateGroup in ipairs(BgmStateConfig.stateGroupList) do

			local isDefault = false
			if bgmTypeState ~= "GamePlay" and BgmTypeDefalut[stateGroup]  then
				isDefault = true
			else
				state = self.stateGroup[stateGroup] or "default"
			end

			if specialAreaState ~= "default" and SpecialAreaDefault[stateGroup]  then
				isDefault = true
			else
				state = self.stateGroup[stateGroup] or "default"
			end

			if gamePlayTypeState ~= "Explore" and GamePlayTypeDefault[stateGroup]  then
				isDefault = true
			else
				state = self.stateGroup[stateGroup] or "default"
			end

			if isDefault then
				state = "default"
			end

			if SwitchGroup[stateGroup] then
				if self.bgmObject then
					GameWwiseContext.SetSwitch(stateGroup, state, self.bgmObject)
				end
			else
				GameWwiseContext.SetState(stateGroup, state)
			end
		end
		if SoundManager.LogBgmState == 1 then
			Log(string.format("sound: <color=blue>%s</color>", audioList[1]));
		end
	end

	local gameWwise = SoundManager.Instance:GetGameWwise()
	gameWwise:LoadSoundBank(audioList[1], -1, true, cb)
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
	local audioList, playState = self:GetStateAudioList()
	print("playState "..playState)
end

