NightMareFailWindow = BaseClass("NightMareFailWindow", BaseWindow)
--梦魇失败界面 
local HeroData = Config.DataHeroMain.Find

function NightMareFailWindow:__init(parent)
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareFailWindow.prefab")
    self.heroIconListUI = {}
    self.buffIconListUI = {}
end
function NightMareFailWindow:__BindEvent()

end

function NightMareFailWindow:__BindListener()
    self.quitBtn_btn.onClick:AddListener(self:ToFunc("OnClickQuitBtn"))
    self.reSetBtn_btn.onClick:AddListener(self:ToFunc("OnClickResetBtn"))
end

function NightMareFailWindow:__Create()

end

function NightMareFailWindow:__delete()
    for i, v in pairs(self.heroIconListUI) do
        self:PushUITmpObject("heroIcon", v)
    end
    self.heroIconListUI = {}

    for i, v in pairs(self.buffIconListUI) do
        self:PushUITmpObject("buffIcon", v)
    end
    self.buffIconListUI = {}
end

function NightMareFailWindow:__Show()
    --self.TitleText_txt.text = TI18N("梦魇终-启")
    self.systemDuplicateId = self.args.systemDuplicateId
    self.nightDupCfg = NightMareConfig.GetDataNightmareDuplicate(self.systemDuplicateId)
    self:ShowInfo()
end

function NightMareFailWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function NightMareFailWindow:BlurComplete()
    self:SetActive(true)
end
function NightMareFailWindow:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function NightMareFailWindow:ShowInfo()
    self:UpdateInfoByResult()
end

function NightMareFailWindow:UpdateInfoByResult()
    --更新左侧的人物立绘
    self:UpdateLeftHeroInfo()
    --更新积分
    self:UpdatePoint()
    --更新角色信息
    self:UpdateHeroInfo()
    --更新buff信息
    self:UpdateBuffInfo()
end

function NightMareFailWindow:UpdateLeftHeroInfo()
    --获取当前控制的角色
    local instanceId = BehaviorFunctions.GetCtrlEntity()
    local info = Fight.Instance.playerManager:GetPlayer():GetEntityInfo(instanceId)
    if not info then return end
    local heroData = HeroData[info.HeroId]
    SingleIconLoader.Load(self.leftHero, heroData.stand_icon, function()
        self.leftHero:SetActive(true)
    end)
end

function NightMareFailWindow:UpdatePoint()
    local totalPoint, baseTypePoint = mod.NightMareDuplicateCtrl:GetMaxTypePoint()
    --预计总积分
    self.totalPoint_txt.text = totalPoint
    --混沌积分
    self.typePoint_txt.text = baseTypePoint
end

function NightMareFailWindow:UpdateHeroInfo()
    for i, v in pairs(self.heroIconListUI) do
        UtilsUI.SetActive(v.object, false)
    end

    local useHeroIdList = mod.NightMareDuplicateCtrl:GetNightMareUseHeroList()
    for index, roleId in pairs(useHeroIdList) do
        if not self.heroIconListUI[roleId] then
            self.heroIconListUI[roleId] = self:PopUITmpObject("heroIcon", self.heroListContent.transform)
        end
        UtilsUI.SetActive(self.heroIconListUI[roleId].object, true)
        self:UpdateHeroIcon(roleId)
    end
end

function NightMareFailWindow:UpdateHeroIcon(roleId)
    local item = self.heroIconListUI[roleId]
    local heroCfg = HeroData[roleId]
    if heroCfg and heroCfg.rhead_icon ~= "" then
        SingleIconLoader.Load(item.icon, heroCfg.rhead_icon, function()
            item.icon:SetActive(true)
        end)
    end
end

function NightMareFailWindow:UpdateBuffInfo()
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

function NightMareFailWindow:UpdateBuffIcon(fight_base_id, buffId, pointId)
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

function NightMareFailWindow:OnClickQuitBtn()
    mod.DuplicateCtrl:QuitDuplicate()
    WindowManager.Instance:CloseWindow(self)
end

function NightMareFailWindow:OnClickResetBtn()
    if Fight.Instance then
        Fight.Instance.duplicateManager:AgainDuplicateLevel()
    end
    WindowManager.Instance:CloseWindow(self)
end

