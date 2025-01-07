NightMareAdvTipsPanel = BaseClass("NightMareAdvTipsPanel", BasePanel)
--梦魇冒险入口显示详细信息

function NightMareAdvTipsPanel:__init(parent)
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareAdvTipsPanel.prefab")
    self.evBuffItem = {}
    self.monsterItemList = {}
end
function NightMareAdvTipsPanel:__BindEvent()

end

function NightMareAdvTipsPanel:__BindListener()
    --self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))


    self:SetAcceptInput(true)
end

function NightMareAdvTipsPanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function NightMareAdvTipsPanel:__delete()
    for i, v in pairs(self.evBuffItem) do
        self:PushUITmpObject("buffDescItem", v)
    end
    self.evBuffItem = {}
    
    for i, v in pairs(self.monsterItemList) do
        self:PushUITmpObject("monsterItem", v)
    end
    self.monsterItemList = {}
end

function NightMareAdvTipsPanel:__Show()
    --self.TitleText_txt.text = TI18N("梦魇终-启")
    self.systemDuplicateId = self.args.systemDuplicateId
    self:ShowInfo()
end

function NightMareAdvTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function NightMareAdvTipsPanel:BlurComplete()
    self:SetActive(true)
end
function NightMareAdvTipsPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    PanelManager.Instance:ClosePanel(self)
end

function NightMareAdvTipsPanel:ShowInfo()
    --显示环境buff
    self:UpdateEvInfo()
    --显示怪物信息
    self:UpdateMonsterInfo()
end

function NightMareAdvTipsPanel:UpdateEvInfo()
    local nightDupInfo = NightMareConfig.GetDataNightmareDuplicate(self.systemDuplicateId)
    for i, evBuff in ipairs(nightDupInfo.environment_buff_id) do
        if evBuff ~= 0 then
            if not self.evBuffItem[evBuff] then
                self.evBuffItem[evBuff] = self:PopUITmpObject("buffDescItem", self.buffContent.transform)
            end
            UtilsUI.SetActive(self.evBuffItem[evBuff].object, true)
            self:UpdateBuffItem(evBuff)
        end
    end
end

function NightMareAdvTipsPanel:UpdateBuffItem(evBuff)
    local item = self.evBuffItem[evBuff]
    local sysBuffCfg = NightMareConfig.GetDataSystemBuff(evBuff)
    item.buffName_txt.text = sysBuffCfg.name
    item.desc_txt.text = sysBuffCfg.desc
end

function NightMareAdvTipsPanel:UpdateMonsterInfo()
    local systemDuplicateConfig = DuplicateConfig.GetSystemDuplicateConfigById(self.systemDuplicateId)
    local num = 0
    for i, monsterId in ipairs(systemDuplicateConfig.show_monster_id) do
        if monsterId ~= 0 then
            if not self.monsterItemList[monsterId] then
                self.monsterItemList[monsterId] = self:PopUITmpObject("monsterItem", self.monsterContent.transform)
            end
            UtilsUI.SetActive(self.monsterItemList[monsterId].object, true)
            self:UpdateMonsterItem(monsterId)
            num = num + 1
        end
    end
    --刷新提示信息
    self.monsterDes_txt.text = string.format("可能遭遇<#E4B265>%s</color>波敌人", num)
end

function NightMareAdvTipsPanel:UpdateMonsterItem(monsterId)
    local item = self.monsterItemList[monsterId]
    local monsterCfg = TaskDuplicateConfig.GetMonsterConfig(monsterId)
    if monsterCfg and monsterCfg.icon ~= "" then
        SingleIconLoader.Load(item.icon, monsterCfg.icon)
    end
    if monsterCfg and monsterCfg.level ~= "" then
        item.level_txt.text = string.format("%s级", monsterCfg.level)
    end
end

