NightMareBuffTipsPanel = BaseClass("NightMareBuffTipsPanel", BasePanel)
--buff(状态增益)

function NightMareBuffTipsPanel:__init(parent)
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareBuffTipsPanel.prefab")
    self.initSelect = nil
    
    --ui 
    self.buffListUI = {}
end
function NightMareBuffTipsPanel:__BindEvent()

end

function NightMareBuffTipsPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Hide"))


    self:SetAcceptInput(true)
end

function NightMareBuffTipsPanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function NightMareBuffTipsPanel:__delete()
    for i, v in pairs(self.buffListUI) do
        self:PushUITmpObject("buffIcon", v)
    end
    self.buffListUI = {}
    self.initSelect = nil
end

function NightMareBuffTipsPanel:__Show()
    --self.TitleText_txt.text = TI18N("梦魇终-启")
    self.buffList = self.args.buffList or {}
    self:ShowInfo()
end

function NightMareBuffTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function NightMareBuffTipsPanel:BlurComplete()
    self:SetActive(true)
end
function NightMareBuffTipsPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    PanelManager.Instance:ClosePanel(self)
end

function NightMareBuffTipsPanel:ShowInfo()
    for i, v in pairs(self.buffListUI) do
        UtilsUI.SetActive(v.object, false)    
    end
    
    for fight_base_id, index in pairs(self.buffList) do
        if index ~= 0 then
            --获取buffId 
            local nightMareBuffCfg = NightMareConfig.GetDataNightmareBuff(fight_base_id)
            local values = nightMareBuffCfg.fight_buff[index]
            local buffId = values[1]
            if buffId == 0 then --buffId等于0代表找不到该buff
                goto continue
            end

            local pointId = values[2]
            if not self.buffListUI[fight_base_id] then
                self.buffListUI[fight_base_id] = self:PopUITmpObject("buffIcon", self.buffContent.transform)
                self:BindListerner(fight_base_id, buffId, pointId)
            end
            self:UpdateBuffIcon(fight_base_id, buffId, pointId)
        end
        ::continue::
    end
end

function NightMareBuffTipsPanel:UpdateBuffIcon(fight_base_id, buffId, pointId)
    local item = self.buffListUI[fight_base_id]
    UnityUtils.SetActive(item.object, true)
    local buffConfig = NightMareConfig.GetDataSystemBuff(buffId)

    --icon 
    if buffConfig.icon ~= "" then
        AtlasIconLoader.Load(item.icon, buffConfig.icon)
    end
    --quality
    if buffConfig.quality ~= "" then
        local path = AssetConfig.GetNightMareQualityIcon(buffConfig.quality)
        AtlasIconLoader.Load(item.quality, path)
    end
    --等级
    item.level_txt.text = "LV."..buffConfig.buff_level
    if not self.initSelect then
        self.initSelect = true 
        --选择第一个
        self:OnClickBuff(fight_base_id, buffId, pointId)
    end
end

function NightMareBuffTipsPanel:BindListerner(fight_base_id, buffId, pointId)
    local item = self.buffListUI[fight_base_id]
    --添加UIDrag事件
    local dragBehaviour = item.object:GetComponent(UIDragBehaviour)
    if not dragBehaviour then
        dragBehaviour = item.object:AddComponent(UIDragBehaviour)
    end
    dragBehaviour.ignorePass = true
    dragBehaviour.onPointerClick = function(data)
        self:OnClickBuff(fight_base_id, buffId, pointId)
    end
end

function NightMareBuffTipsPanel:OnClickBuff(fight_base_id, buffId, pointId)
    for fightBaseId, v in pairs(self.buffListUI) do
        v.select:SetActive(fightBaseId == fight_base_id)
    end
    self.right:SetActive(true)
    self:UpdateRight(buffId, pointId)
end

function NightMareBuffTipsPanel:UpdateRight(buffId, pointId)
    local buffConfig = NightMareConfig.GetDataSystemBuff(buffId)
    local pointConfig = NightMareConfig.GetDataNightmarePointRule(pointId)
    local pointNum = 0
    if pointConfig then
        pointNum = pointConfig.point
    end
    
    self.buffName_txt.text = buffConfig.name
    self.point_txt.text = string.format("积分: %s", pointNum)
    self.buffDes_txt.text = buffConfig.desc
end

