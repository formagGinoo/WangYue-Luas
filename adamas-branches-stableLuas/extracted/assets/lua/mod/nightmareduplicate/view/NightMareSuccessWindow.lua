NightMareSuccessWindow = BaseClass("NightMareSuccessWindow", BaseWindow)
--梦魇成功界面 
local HeroData = Config.DataHeroMain.Find

function NightMareSuccessWindow:__init(parent)
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareSuccessWindow.prefab")
    self.heroIconListUI = {}
    self.buffIconListUI = {}
end
function NightMareSuccessWindow:__BindEvent()

end

function NightMareSuccessWindow:__BindListener()
    self.quitBtn_btn.onClick:AddListener(self:ToFunc("OnClickQuitBtn"))
    self.reSetBtn_btn.onClick:AddListener(self:ToFunc("OnClickResetBtn"))
end

function NightMareSuccessWindow:__Create()

end

function NightMareSuccessWindow:__delete()
    for i, v in pairs(self.heroIconListUI) do
        self:PushUITmpObject("heroIcon", v)
    end
    self.heroIconListUI = {}

    for i, v in pairs(self.buffIconListUI) do
        self:PushUITmpObject("buffIcon", v)
    end
    self.buffIconListUI = {}
end

function NightMareSuccessWindow:__Show()
    --self.TitleText_txt.text = TI18N("梦魇终-启")
    self.systemDuplicateId = self.args.systemDuplicateId
    self.nightDupCfg = NightMareConfig.GetDataNightmareDuplicate(self.systemDuplicateId)
    self:ShowInfo()
end

function NightMareSuccessWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function NightMareSuccessWindow:BlurComplete()
    self:SetActive(true)
end
function NightMareSuccessWindow:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function NightMareSuccessWindow:ShowInfo()
    self:UpdateInfoByResult()
end

function NightMareSuccessWindow:UpdateInfoByResult()
    --更新左侧的人物立绘
    self:UpdateLeftHeroInfo()
    --更新积分、血量、耗时信息
    self:UpdateTopInfo()
    --更新角色信息
    self:UpdateHeroInfo()
    --更新buff信息
    self:UpdateBuffInfo()
    --更新底部的信息
    self:UpdateBottomTips()
end

function NightMareSuccessWindow:UpdateLeftHeroInfo()
    --获取当前控制的角色
    local instanceId = BehaviorFunctions.GetCtrlEntity()
    local info = Fight.Instance.playerManager:GetPlayer():GetEntityInfo(instanceId)
    if not info then return end
    local heroData = HeroData[info.HeroId]
    SingleIconLoader.Load(self.leftHero, heroData.stand_icon, function()
        self.leftHero:SetActive(true)
    end)
end

function NightMareSuccessWindow:UpdateTopInfo()
    local dupState = mod.DuplicateCtrl:GetDuplicateStateBySysId(self.systemDuplicateId)
    --本关总积分(历史最高todo)
    self.totalPoint_txt.text = dupState and dupState.current_score or 0
    local maxPoint, maxTypePoint = mod.NightMareDuplicateCtrl:GetMaxTypePoint()
    --混沌积分
    self.typePoint_txt.text = maxTypePoint
    --剩余血量
    self.hpPercent_txt.text = string.format("%.2f", mod.NightMareDuplicateCtrl:GetNightMareHpPercent() * 100).."%"
    --副本耗时
    self.duplicateUseTime_txt.text = string.format("%.2f", mod.NightMareDuplicateCtrl:GetNightMareDuplicateUseTime())..'s'
end

function NightMareSuccessWindow:UpdateHeroInfo()
    for i, v in pairs(self.heroIconListUI) do
        UtilsUI.SetActive(v.object, false)
    end

    local useHeroIdList = mod.NightMareDuplicateCtrl:GetNightMareUseHeroList()
    for _, roleId in pairs(useHeroIdList) do
        if not self.heroIconListUI[roleId] then
            self.heroIconListUI[roleId] = self:PopUITmpObject("heroIcon", self.heroListContent.transform)
        end
        UtilsUI.SetActive(self.heroIconListUI[roleId].object, true)
        self:UpdateHeroIcon(roleId)
    end
end

function NightMareSuccessWindow:UpdateHeroIcon(roleId)
    local item = self.heroIconListUI[roleId]
    local heroCfg = HeroData[roleId]
    if heroCfg and heroCfg.rhead_icon ~= "" then
        SingleIconLoader.Load(item.icon, heroCfg.rhead_icon, function()
            item.icon:SetActive(true)
        end)
    end
end

function NightMareSuccessWindow:UpdateBuffInfo()
    for i, val in pairs(self.buffIconListUI) do
        UtilsUI.SetActive(val.object, false)
    end

    local usebuffList = mod.NightMareDuplicateCtrl:GetNightMareUseBuffList()
    for _, v in ipairs(usebuffList) do
        local fight_base_id = v.key
        local index = v.value

        if not self.buffIconListUI[fight_base_id] then
            self.buffIconListUI[fight_base_id] = self:PopUITmpObject("buffIcon", self.buffContent.transform)
        end
        UtilsUI.SetActive(self.buffIconListUI[fight_base_id].object, true)
        local nightBuffCfg = NightMareConfig.GetDataNightmareBuff(fight_base_id)
        local fight_buff = nightBuffCfg.fight_buff[index]
        local buffId = fight_buff[1]
        local pointId = fight_buff[2]
        if buffId == 0 then --buffId等于0代表找不到该buff
            goto continue
        end

        self:UpdateBuffIcon(fight_base_id, buffId, pointId)
        ::continue::
    end
end

function NightMareSuccessWindow:UpdateBuffIcon(fight_base_id, buffId, pointId)
    local item = self.buffIconListUI[fight_base_id]
    local buffConfig = NightMareConfig.GetDataSystemBuff(buffId)
    local pointConfig = NightMareConfig.GetDataNightmarePointRule(pointId)
    --等级
    item.level_txt.text = "LV."..buffConfig.buff_level
    if pointConfig then
        --分数
        item.score_txt.text = pointConfig.point
    end
    --icon
    if buffConfig.icon ~= "" then
        AtlasIconLoader.Load(item.icon, buffConfig.icon)
    end
    --quality
    if buffConfig.quality ~= "" then
        local path = AssetConfig.GetNightMareQualityIcon(buffConfig.quality)
        AtlasIconLoader.Load(item.quality, path)
    end
end

function NightMareSuccessWindow:UpdateBottomTips()
    --获取上次的stateList
    local lastDupStateList = mod.NightMareDuplicateCtrl:GetLastDupStateList()
    local dupStateList = mod.DuplicateCtrl:GetDuplicateStateBySysId(self.systemDuplicateId)
    local lastScore = lastDupStateList and lastDupStateList.current_score or 0
    
    local lerp = dupStateList.current_score - lastScore
    if lastScore > 0 then
        self.bottomTips_txt.text = string.format("本次挑战已提升本轮积分<#F3CB74>%s+%s</color>", lastScore, lerp)
    else
        self.bottomTips_txt.text = string.format("本次挑战积分<#F3CB74>%s</color>", dupStateList.current_score)
    end
end

function NightMareSuccessWindow:OnClickQuitBtn()
    mod.DuplicateCtrl:QuitDuplicate()
    WindowManager.Instance:CloseWindow(self)
end

function NightMareSuccessWindow:OnClickResetBtn()
    if Fight.Instance then
        Fight.Instance.duplicateManager:AgainDuplicateLevel()
    end
    WindowManager.Instance:CloseWindow(self)
end

