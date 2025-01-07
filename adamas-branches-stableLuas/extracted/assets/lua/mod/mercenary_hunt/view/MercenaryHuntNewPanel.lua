MercenaryHuntNewPanel = BaseClass("MercenaryHuntNewPanel", BasePanel)

local _tinsert = table.insert
local _tremove = table.remove

local DiscoverState = MercenaryHuntConfig.MercenaryDiscoverState
local ChaseState = MercenaryHuntConfig.MercenaryChaseState

local ViewStage = {
    last = 0,
    def = 1,
    next = 2
}

local initModeViewIdx = {
    [ViewStage.last] = 1,
    [ViewStage.def] = 4,
    [ViewStage.next] = 7,
}

local LevelColor = {
	Low = "#FFFFFF",
	Normal = "#65f152",
	High = "#efdb95",
	Highest = "#f64229"
}

local timeStr = TI18N("%s后+1")

function MercenaryHuntNewPanel.LoadShowModScene(cb)
    local sceneViewType = ModelViewConfig.ViewType.Mercenary
    Fight.Instance.modelViewMgr:LoadView(sceneViewType, function ()
        Fight.Instance.modelViewMgr:GetView(sceneViewType):LoadScene(ModelViewConfig.Scene.Mercenary, function ()
            if cb then
                cb()
            end
            Fight.Instance.modelViewMgr:ShowView(sceneViewType)
        end)
    end)
end

function MercenaryHuntNewPanel:__init()
	self:SetAsset("Prefabs/UI/MercenaryHunt/MercenaryHuntNewPanel.prefab")
end

function MercenaryHuntNewPanel:__BindListener()
    self.RuleBtn_btn.onClick:AddListener(self:ToFunc("ClickRuleBtn"))
    self.RankRewardBtn_btn.onClick:AddListener(self:ToFunc("ClickRankRewardBtn"))
    self.MedalBtn_btn.onClick:AddListener(self:ToFunc("ClickMedalBtn"))
    self.LastBtn_btn.onClick:AddListener(self:ToFunc("ClickLastStageBtn"))
    self.NextBtn_btn.onClick:AddListener(self:ToFunc("ClickNextStageBtn"))

    for i = 1, 3 do
        self["Rank"..i.."_btn"].onClick:AddListener(function ()
            self:ClickModeBtn(i)
        end)
    end

end

function MercenaryHuntNewPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.UpdatePromoteInfo, self:ToFunc("UpdatePromoteInfo"))

    EventMgr.Instance:AddListener(EventName.GetRankReward, self:ToFunc("UpdateRewardBtnRed"))
    EventMgr.Instance:AddListener(EventName.UpdateDailyRewardInfo, self:ToFunc("UpdateRewardBtnRed"))
end

function MercenaryHuntNewPanel:__CacheObject()
    
end

function MercenaryHuntNewPanel:__ShowComplete()
    
end

function MercenaryHuntNewPanel:__Hide()
    EventMgr.Instance:RemoveListener(EventName.UpdatePromoteInfo, self:ToFunc("UpdatePromoteInfo"))
    self:CacheCurrencyBar()
    if self.parentWindow then
        self.parentWindow.BlurNode:SetActive(true)
    end

    if self.modeView then
        for i = 1, 3 do
            local modeKey = "FormationRoot_"..i
            local model = self.modeView:GetModelTrans(modeKey)
            if model then
                self:UpdateModeLightState(i, false)
            end
        end
    end

    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Mercenary)
end

function MercenaryHuntNewPanel:__Show()
    self.modelMap = {}

    self:initCurrencyBar()
    self.mercenaryHuntCtrl = mod.MercenaryHuntCtrl
    self.mercenaryHuntMgr = Fight.Instance.mercenaryHuntManager
    local mainId = self.mercenaryHuntCtrl:GetMainId()
    self.mainCfg = MercenaryHuntConfig.GetMercenaryHuntMainConfig(mainId)

    if self.parentWindow then
        self.parentWindow.BlurNode:SetActive(false)
    end
    self.modeView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Mercenary)
    self.modeView:BlendToNewCamera(MercenaryHuntConfig.CameraPos.initPos, MercenaryHuntConfig.CameraPos.initRot)
    self.modeView:SetDepthOfFieldGaussian(false)
    
    self:UpdatePromoteInfo()
    self:GetSortMercenaryMap()
    self:UpdateStageMonsterView()
    self:UpdateRewardBtnRed()
end

-- 初始化货币栏
function MercenaryHuntNewPanel:initCurrencyBar()
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.CurrencyBar, 6)
end

-- 移除货币栏
function MercenaryHuntNewPanel:CacheCurrencyBar()
    self.CurrencyBar1:OnCache()
end

function MercenaryHuntNewPanel:GetSortMercenaryMap()
    local mercenaryMap = self.mercenaryHuntCtrl:GetAllMercenaryData()
    local newMap = {}
    for _, data in pairs(mercenaryMap) do
        _tinsert(newMap, data)
    end

    table.sort(newMap, function (a, b)
        if a.rank_id == b.rank_id then
            return a.rank_lv < b.rank_lv
        end
        return a.rank_id < b.rank_id
    end)

    self:UpdateStage(newMap)

    self.showMencenaryMap = newMap
    local rankId, rankLv = self.mercenaryHuntCtrl:GetCurRankInfo()
    local playerId = self:GetShowPlayerModeViewInfo()
    -- 中间插入玩家数据，玩家占据当前的格子，当前格子怪物像前移动一位
    for i = #newMap, 1, -1 do
        local data = newMap[i]
        if data.rank_id == rankId and data.rank_lv == rankLv then
            _tinsert(self.showMencenaryMap, i + 1, {isShowPlayer = true, roleId = playerId})
            break
        end
    end
    _tremove(newMap, 1)
end

function MercenaryHuntNewPanel:GetShowPlayerModeViewInfo()
    local player = Fight.Instance.playerManager:GetPlayer()
    local entity = player:GetCtrlEntityObject()
    local heroId = player:GetHeroIdByInstanceId(entity.instanceId)

    return heroId
end

function MercenaryHuntNewPanel:CheckShowPlayerModeView(data)
    local rankId, rankLv = self.mercenaryHuntCtrl:GetCurRankInfo()
    if data.rank_id == rankId and data.rank_lv == rankLv then
        local player = Fight.Instance.playerManager:GetPlayer()
        local entity = player:GetCtrlEntityObject()
        local heroId = player:GetHeroIdByInstanceId(entity.instanceId)
        return true, heroId
    end
    return false
end

function MercenaryHuntNewPanel:UpdateStage(mercenaryMap)
    local curRankId = self.mercenaryHuntCtrl:GetCurRankInfo()
    local charIdx = 1
    local maxIdx
    for idx, data in ipairs(mercenaryMap) do
        if data.rank_id == curRankId then
            charIdx = idx
            break
        end
    end

    self.charIdx = charIdx
    if charIdx > 3 then
        self.clickStage = ViewStage.def
    else
        self.clickStage = ViewStage.last
    end
	self.maxStage = mercenaryMap[charIdx + 3] and self.clickStage + 1 or self.clickStage
end

function MercenaryHuntNewPanel:GetMercenaryEntityId(ecoId)
    local ecoCfg = MercenaryHuntConfig:GetMercenaryEcoConfig(ecoId)
    return ecoCfg.entity_id, ecoCfg.ui_model, ecoCfg.mode_scale / 100
end

function MercenaryHuntNewPanel:CheckDefeat(data)
    local curRankId, curRankLv = self.mercenaryHuntCtrl:GetCurRankInfo()
    if data.rank_id < curRankId then
        return true
    end

    if data.rank_id == curRankId and data.rank_lv <= curRankLv then
        return true
    end

    return false
end

function MercenaryHuntNewPanel:ShowMonsterModeView()
    self.curShowModeInfo = {}
    self.modelMap = {}

    local mercenaryMap = self.showMencenaryMap
    local cacheIdx = 0
    for i = self.initShowIdx, self.initShowIdx + 2 do
		cacheIdx = cacheIdx + 1

        local loadIdx = cacheIdx
        local data = mercenaryMap[i]
        local modeKey = "FormationRoot_"..loadIdx
        local model = self.modeView:GetModelTrans(modeKey)
        if model then
            self:UpdateModeLightState(loadIdx, false)
        end
        if data then
            local isShowPlayer = data.isShowPlayer
            local roleId, uiModeKey, scale
            local isDefeat = false
            local isEscape = false
            local isChase = false
            if not isShowPlayer then
                roleId, uiModeKey, scale = self:GetMercenaryEntityId(data.ecosystem_id)
                isDefeat = self:CheckDefeat(data)
                isEscape = self.mercenaryHuntCtrl:CheckMercenaryEscape(data.ecosystem_id)
                self.modelMap[data.ecosystem_id] = loadIdx
                isChase = data.chase_state == ChaseState.Chase
            else
                roleId = data.roleId
            end

            local rotation = {x = 0, y = 0, z = 0}
            rotation.y = (isDefeat or isEscape) and 180 or 0
            if isChase then
                rotation.y = 0
            end

            local cb = function ()
                self.modeView:SetModelScale(modeKey, scale, scale, scale)
                self.modeView:SetModelRootRotation(modeKey, rotation)
                self:UpdateModeInfo(data, loadIdx, isShowPlayer)
            end

            if isShowPlayer then
                rotation.y = 0
                scale = 1
                uiModeKey = nil
            end
        
            self.modeView:ShowModelRoot(modeKey, true)
            self.modeView:LoadModel(modeKey, roleId, cb, uiModeKey)
            _tinsert(self.curShowModeInfo, data)

        else
            self.modeView:ShowModelRoot(modeKey, false)
            self:UpdateModeInfo(nil, nil, nil, true)
        end
    end
end

function MercenaryHuntNewPanel:UpdateModeInfo(data, idx, isPlayer, isHide)
    if isHide then
        self["Rank"..idx]:SetActive(false)
        self["RankTitle"..idx]:SetActive(false)
        self["MercenaryState"..idx]:SetActive(false)
        return
    end
    self["Rank"..idx]:SetActive(true)
    self["RankTitle"..idx]:SetActive(true)
    local rankId = data.rank_id
    local showLv = 0

    local name = ""

    local isDiscover = data.discover_state == DiscoverState.Discover
    local isChase = data.chase_state == ChaseState.Chase
    -- 是否处于溃逃中
    local isEscape = self.mercenaryHuntCtrl:CheckMercenaryEscape(data.ecosystem_id)
    local isDefeat = false

    if isPlayer then
        rankId, _ = self.mercenaryHuntCtrl:GetCurRankInfo()
        local info = mod.InformationCtrl:GetPlayerInfo()
        name = info.nick_name
        isDiscover = true
        self["MercenaryState"..idx]:SetActive(false)
    else
        isDefeat = self:CheckDefeat(data)
        name = self.mercenaryHuntMgr:GetMercenaryName(data.ecosystem_id)
        self["MercenaryState"..idx]:SetActive(true)
        showLv = self.mercenaryHuntMgr:GetMercenaryLv(data.ecosystem_id)
    end

    -- 置黑
    local isDark = false
    if (not isDiscover or isEscape) and not isPlayer then
        isDark = true
    end

    -- 击败
    if isDefeat then
        isDiscover = true
    end

    -- 溃逃
    if isEscape then
        isDiscover = true
        isDefeat = false
        isChase = false
    end

    -- 更新角色的轮廓是否置黑
    self:UpdateModeLightState(idx, isDark)

    local rankCfg = MercenaryHuntConfig.GetMercenaryHuntRankLvConfig(rankId)
    if isPlayer then
        showLv = rankCfg.icon_num
    end

    self["Name"..idx.."_txt"].text = name

    SingleIconLoader.Load(self["RankIcon"..idx], rankCfg.icon_path2)
    self["RankVal"..idx.."_txt"].text = showLv

    self["RankIcon"..idx]:SetActive(isDiscover)
    self["NoDiscoverIcon"..idx]:SetActive(not isDiscover)
    
    self["NoDiscover"..idx]:SetActive(not isDiscover)
    self["Discover"..idx]:SetActive(isDiscover)
    self["NameBg"..idx]:SetActive(isDiscover)

    self["Chase"..idx]:SetActive(isChase)
    self["Defeat"..idx]:SetActive(isDefeat)
    if isDefeat then
        self["Discover"..idx]:SetActive(false)
        self["NoDiscover"..idx]:SetActive(false)
    end

    if isChase then
        self["NoDiscover"..idx]:SetActive(false)
        self["Discover"..idx]:SetActive(false)
        self["Defeat"..idx]:SetActive(false)
    end
    
    self["Escape"..idx]:SetActive(isEscape)
    if isEscape then
        self["Discover"..idx]:SetActive(false)
    end

    self:UpdateLvColor(data, idx, isPlayer)
end

function MercenaryHuntNewPanel:UpdateLvColor(data, idx, isPlayer)
    local lev = mod.RoleCtrl:GetMaxRoleLev()
    local colorIdx = LevelColor.Low
    if not isPlayer then
        local mercenaryLv = self.mercenaryHuntMgr:GetMercenaryLv(data.ecosystem_id)
	    local lvOffset = mercenaryLv - lev
        if lvOffset <= -5 then
            colorIdx = LevelColor.Low
        elseif lvOffset > -5 and lvOffset < 5 then
            colorIdx = LevelColor.Normal
        elseif  lvOffset >= 5 and lvOffset < 10 then
            colorIdx = LevelColor.High
        elseif lvOffset >= 10 then
            colorIdx = LevelColor.Highest
        end
    end

    UtilsUI.SetTextColor(self["RankVal"..idx.."_txt"], colorIdx)
end

function MercenaryHuntNewPanel:ClickRuleBtn()
    BehaviorFunctions.ShowGuideImageTips(MercenaryHuntConfig.TeachId)
end

function MercenaryHuntNewPanel:ClickLastStageBtn()
    if self.clickStage <= ViewStage.last then return end
    self.clickStage = self.clickStage - 1
    self:UpdateStageMonsterView()
end

function MercenaryHuntNewPanel:ClickNextStageBtn()
    if self.clickStage >= self.maxStage then return end
    self.clickStage = self.clickStage + 1
    self:UpdateStageMonsterView()
end

function MercenaryHuntNewPanel:ClickModeBtn(idx)
    local showData = self.curShowModeInfo[idx]
    if not showData or showData.isShowPlayer then
        return
    end

    if showData.discover_state ~= DiscoverState.Discover then return end

    PanelManager.Instance:OpenPanel(MercenaryTipsPanel, {openType = 0, hunterInfo = showData})
end

function MercenaryHuntNewPanel:ClickRankRewardBtn()
    PanelManager.Instance:OpenPanel(RankRewardNewPanel)
end

function MercenaryHuntNewPanel:ClickMedalBtn()
    JumpToConfig.DoJump(MercenaryHuntConfig.MapJumpId)
end

function MercenaryHuntNewPanel:UpdateStageBtnVisible()
    self.LastBtn:SetActive(self.clickStage > ViewStage.last)
    self.NextBtn:SetActive(self.clickStage < self.maxStage)
end

function MercenaryHuntNewPanel:UpdateStageMonsterView()
    local val = self.charIdx % 3
    local starVal = self.charIdx - val
    if self.clickStage == ViewStage.last then
        self.initShowIdx = starVal - 3
    elseif self.clickStage == ViewStage.def then
		if self.charIdx < 3 then
			self.initShowIdx = starVal + 4
		else
			self.initShowIdx = starVal + 1
		end
    elseif self.clickStage == ViewStage.next then
        self.initShowIdx = starVal + 4
    end
		
	if self.initShowIdx <= 0 then
		self.initShowIdx = 1
	end
		
    self:ShowMonsterModeView()
    self:UpdateStageBtnVisible()

    local showData = self.showMencenaryMap[self.initShowIdx]
    self:UpdateCurRankInfo(showData.rank_id)
end


function MercenaryHuntNewPanel:Update()
    if not self:Active() then return end
    self:UpdatePromoteCd()
end

function MercenaryHuntNewPanel:UpdateCurRankInfo(curRankId)
    if not curRankId then
        curRankId = self.mercenaryHuntCtrl:GetCurRankInfo()
    end

    local rankCfg = MercenaryHuntConfig.GetMercenaryHuntRankLvConfig(curRankId)
    if not rankCfg then return end

    SingleIconLoader.Load(self.CurRankIcon, rankCfg.icon_path1)
    self.CurRankLv_txt.text = rankCfg.icon_num
end

function MercenaryHuntNewPanel:UpdatePromoteInfo()
    local maxNum = self.mainCfg.promote_num_limit
    local curPromoteNum = self.mercenaryHuntCtrl:GetCurPromoteNum()
    self.UpCount_txt.text = curPromoteNum .. "/" .. maxNum
end

function MercenaryHuntNewPanel:UpdatePromoteTimeVisible(isVisible)
    if self.UpCd.activeSelf == isVisible then return end
    self.UpCd:SetActive(isVisible)
end

function MercenaryHuntNewPanel:UpdatePromoteCd()
    if not self.mainCfg then
        self:UpdatePromoteTimeVisible(false)
        return
    end
    local maxNum = self.mainCfg.promote_num_limit
    local curPromoteNum = self.mercenaryHuntCtrl:GetCurPromoteNum()
    if curPromoteNum >= maxNum then
        self:UpdatePromoteTimeVisible(false)
        return
    end

    local lastRecoverTime = self.mercenaryHuntCtrl:GetLastPromoteRecoverTime()
    local cdTime = self.mainCfg.add_promote_time_cd * 1000
    local targetTime = lastRecoverTime + cdTime
    local curTime = TimeUtils.GetCurTimestamp() * 1000
    local needTime = targetTime - curTime
    if needTime <= 0 then
        self:UpdatePromoteTimeVisible(false)
        return
    end
    self:UpdatePromoteTimeVisible(true)
    local timeDesc = TimeUtils.GetTimeDesc(needTime / 1000)
    self.UpCd_txt.text = string.format(timeStr, timeDesc)
end

function MercenaryHuntNewPanel:UpdateRewardBtnRed()
    local isShowRed = self.mercenaryHuntCtrl:CheckCanGetRankReward()
    self.RewardRed:SetActive(isShowRed)
end

function MercenaryHuntNewPanel:GetDarkSpitLight(ecoId)
    if not self.modeView then return end
    local idx = self.modelMap[ecoId]
    if not idx then return end
    local modeKey = "FormationRoot_"..idx
    local modelRoot = self.modeView:GetTargetTransform(modeKey)
    if not modelRoot then return end

    local darkKey = "DarkSpitLight"..idx
    local darkSpitLight = modelRoot:Find(darkKey)
    return darkSpitLight
end

function MercenaryHuntNewPanel:UpdateModeLightState(idx, isDark)
    local modeKey = "FormationRoot_"..idx
    local model = self.modeView:GetModelTrans(modeKey)
    if not model then return end
    CustomUnityUtils.SetModelDarkState(model.gameObject, isDark)
end