NightMareMonsterTipsPanel = BaseClass("NightMareMonsterTipsPanel", BasePanel)
--buff(状态增益)

function NightMareMonsterTipsPanel:__init(parent)
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareMonsterTipsPanel.prefab")
    
    --ui 
    self.monsterIconListUI = {}
end
function NightMareMonsterTipsPanel:__BindEvent()

end

function NightMareMonsterTipsPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))


    self:SetAcceptInput(true)
end

function NightMareMonsterTipsPanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function NightMareMonsterTipsPanel:__delete()
    for i, v in pairs(self.monsterIconListUI) do
        self:PushUITmpObject("monsterIcon", v)
    end
    self.monsterIconListUI = {}
end

function NightMareMonsterTipsPanel:__Show()
    --self.TitleText_txt.text = TI18N("梦魇终-启")
    self.monsterList = self.args.monsterList or {}
    self.selectId = self.args.selectId
    self:ShowInfo()
end

function NightMareMonsterTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function NightMareMonsterTipsPanel:BlurComplete()
    self:SetActive(true)
end
function NightMareMonsterTipsPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    PanelManager.Instance:ClosePanel(self)
end

function NightMareMonsterTipsPanel:ShowInfo()
    --显示怪物列表
    self:UpdateMonsterList()
end

function NightMareMonsterTipsPanel:UpdateMonsterList()
    for i, monsterId in ipairs(self.monsterList) do
        if monsterId ~= 0 then
            if not self.monsterIconListUI[monsterId] then
                self.monsterIconListUI[monsterId] = self:PopUITmpObject("monsterIcon", self.monsterContent.transform)
            end
            UtilsUI.SetActive(self.monsterIconListUI[monsterId].object, true)
            self:UpdateMonsterICon(monsterId)
        end
        
        if self.selectId == monsterId then
            self:OnClickShowMonsterInfo(monsterId)
        end
    end
end

function NightMareMonsterTipsPanel:UpdateMonsterICon(monsterId)
    local item = self.monsterIconListUI[monsterId]
    local monsterCfg = TaskDuplicateConfig.GetMonsterConfig(monsterId)
    if monsterCfg and monsterCfg.icon ~= "" then
        SingleIconLoader.Load(item.icon, monsterCfg.icon)
    end
    if monsterCfg and monsterCfg.level then
        item.level_txt.text = string.format("%s级", monsterCfg.level)
    end
    item.icon_btn.onClick:RemoveAllListeners()
    item.icon_btn.onClick:AddListener(function()
        self:OnClickShowMonsterInfo(monsterId)
    end)
end

function NightMareMonsterTipsPanel:OnClickShowMonsterInfo(monsterId)
    for monsId, v in pairs(self.monsterIconListUI) do
        v.select:SetActive(monsId == monsterId)
    end
    self.right:SetActive(true)
    self:UpdateRight(monsterId)
end

function NightMareMonsterTipsPanel:UpdateRight(monsterId)
    local monsterCfg = TaskDuplicateConfig.GetMonsterConfig(monsterId)
    
    if monsterCfg and monsterCfg.name then
        self.monsterName_txt.text = monsterCfg.name
    end
    if monsterCfg and monsterCfg.level then
        self.point_txt.text = string.format("Lv.%s", monsterCfg.level)
    end
    if monsterCfg and monsterCfg.desc then
        self.monsterDes_txt.text = monsterCfg.desc
    end
end

