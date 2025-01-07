PartnerSkillUnlockPanel = BaseClass("PartnerSkillUnlockPanel", BasePanel)

function PartnerSkillUnlockPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerSkillUnlockPanel.prefab")
end

function PartnerSkillUnlockPanel:__BindEvent()

end

function PartnerSkillUnlockPanel:__BindListener()
    self:BindCloseBtn(self.Close_btn,self:ToFunc("Close_HideCallBack"))
end

function PartnerSkillUnlockPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerSkillUnlockPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

local ShowType = {
    SingleType = "SingleType",
    ExType = "ExType",
    MultiType = "MultiType",
}

function PartnerSkillUnlockPanel:__Show()
    self.config = self.args.config
    self.skillNum = #self.config
    self.partnerData = self.args.data
    self.partnerId = self.partnerData.template_id
    self.uniqueId = self.partnerData.unique_id
    self.showType = ShowType.SingleType
    self:ShowDetail()
end

function PartnerSkillUnlockPanel:ShowDetail()
    local plateList = self.partnerData.panel_list
    if self.skillNum == 1 then      -- 一次获得一个技能
        local skillConfig = RoleConfig.GetPartnerSkillConfig(self.config[1].skillId)
        if plateList and next(plateList) then
            self.showType = ShowType.ExType
            self.itemObj = UtilsUI.GetContainerObject(self.ExSkillItem.transform)
            self.itemObj.SkillName_txt.text = skillConfig.name
            self.ExDesc_txt.text = skillConfig.desc
            UtilsUI.SetActive(self.itemObj.Time, skillConfig.show_cd ~= 0)
            if skillConfig.show_cd ~= 0 then
                self.itemObj.TimeText_txt.text = string.format("%s秒", skillConfig.show_cd)
            end
            if skillConfig.tag and skillConfig.tag[1] then
                local tag = RoleConfig.GetPartnerSkillTagConfig(skillConfig.tag[1])
                UtilsUI.SetActive(self.itemObj.ActiveState, skillConfig.tag[1] == 1)
                UtilsUI.SetActive(self.itemObj.PassiveState, skillConfig.tag[1] == 2)
                self.itemObj.StateText_txt.text = tag.name
            end
            local plateSkillList = plateList[self.config[1].index].skill_list
            table.sort(plateSkillList, function(a, b)
                local ap = RoleConfig.GetPartnerSkillConfig(a.skill_id).type
                local bp = RoleConfig.GetPartnerSkillConfig(b.skill_id).type
                return ap < bp
            end)
            local tempIndex = 0
            for k, skill in pairs(plateSkillList) do
                local config = RoleConfig.GetPartnerSkillConfig(skill.skill_id)
                if config.type <= RoleConfig.PartnerSkillType.MidNode then -- 大节点或者中节点
                    tempIndex = tempIndex + 1
                    if tempIndex % 2 == 1 then
                        self.nowTempObj = self:GetExAttrItemObj()
                        UtilsUI.SetActive(self.nowTempObj.object, true)
                        for idx = 1, 3, 1 do
                            UtilsUI.SetActive(self.nowTempObj["BgType".. idx], config.type == RoleConfig.PartnerSkillType.BigNode)
                        end
                        if config.type == RoleConfig.PartnerSkillType.BigNode then
                            tempIndex = tempIndex + 1
                            for idx = 2, 3, 1 do
                                UtilsUI.SetActive(self.nowTempObj["BgType".. idx], false)
                            end
                        else
                            UtilsUI.SetActive(self.nowTempObj.BgType2, true)
                        end
                        SingleIconLoader.Load(self.nowTempObj.AttrIcon1, config.icon)
                        self.nowTempObj.AttrDesc1_txt.text = config.desc
                    else
                        SingleIconLoader.Load(self.nowTempObj.AttrIcon2, config.icon)
                        self.nowTempObj.AttrDesc2_txt.text = config.desc
                    end
                    UtilsUI.SetActive(self.nowTempObj.BgType3, tempIndex % 2 ~= 1 and config.type ~= RoleConfig.PartnerSkillType.BigNode)
                    UtilsUI.SetActive(self.nowTempObj.AttrIcon2, tempIndex % 2 ~= 1 and config.type ~= RoleConfig.PartnerSkillType.BigNode)
                    UtilsUI.SetActive(self.nowTempObj.AttrDesc2, tempIndex % 2 ~= 1 and config.type ~= RoleConfig.PartnerSkillType.BigNode)
                end
            end
            self.itemObj.PosText_txt.text = "0".. self.config[1].index
        else
            self.showType = ShowType.SingleType
            self.itemObj = UtilsUI.GetContainerObject(self.SingleSkillItem.transform)
            self.SingleTypeDesc_txt.text = skillConfig.desc
            self.SingleSkillName_txt.text = skillConfig.name
            UtilsUI.SetActive(self.SingleTime, skillConfig.show_cd ~= 0)
            if skillConfig.show_cd ~= 0 then
                self.SingleTimeText_txt.text = string.format("%s秒", skillConfig.show_cd)
            end
            if skillConfig.tag and skillConfig.tag[1] then
                local tag = RoleConfig.GetPartnerSkillTagConfig(skillConfig.tag[1])
                UtilsUI.SetActive(self.SingleActiveState, skillConfig.tag[1] == 1)
                UtilsUI.SetActive(self.SinglePassiveState, skillConfig.tag[1] == 2)
                self.SingleStateText_txt.text = tag.name
            end
            self.itemObj.PosTextPosText_txt.text = "0".. self.config[1].index
        end
        self:SetSingleItemDefultPart(skillConfig)
    elseif self.skillNum > 1 then   -- 一次获得多个技能
        self.showType = ShowType.MultiType
        for i, v in ipairs(self.config) do
            local skillConfig = RoleConfig.GetPartnerSkillConfig(self.config[i].skillId)
            local obj = self:GetMutiItemObj()
            obj.SkillName_txt.text = skillConfig.name
            UtilsUI.SetActive(obj.Time, skillConfig.show_cd ~= 0)
            if skillConfig.show_cd ~= 0 then
                obj.TimeText_txt.text = string.format("%s秒", skillConfig.show_cd)
            end
            if skillConfig.tag and skillConfig.tag[1] then
                local tag = RoleConfig.GetPartnerSkillTagConfig(skillConfig.tag[1])
                UtilsUI.SetActive(obj.ActiveState, skillConfig.tag[1] == 1)
                UtilsUI.SetActive(obj.PassiveState, skillConfig.tag[1] == 2)
                obj.StateText_txt.text = tag.name
            end
            SingleIconLoader.Load(obj.SkillIcon, skillConfig.icon)
            AtlasIconLoader.Load(obj.Quality, AssetConfig.GetPartnerSkillQuality(skillConfig.quality))
            obj.PosText_txt.text = "0".. self.config[i].index
            obj.Bg_btn.onClick:RemoveAllListeners()
            obj.Bg_btn.onClick:AddListener(function()
                PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                    uid = self.uid,
                    skillId = self.config[i].skillId, 
                })
            end)
        end
        
    end
    for k, v in pairs(ShowType) do
        UtilsUI.SetActive(self[v], self.showType == v)
    end
end

function PartnerSkillUnlockPanel:SetSingleItemDefultPart(skillConfig)
    if not self.itemObj or not self.config[1] then
        return
    end
    SingleIconLoader.Load(self.itemObj.SkillIcon, skillConfig.icon)
    AtlasIconLoader.Load(self.itemObj.Quality, AssetConfig.GetPartnerSkillQuality(skillConfig.quality))
    self.itemObj.Bg_btn.enabled = false
end

-- 单个巅峰盘的大中小节点
function PartnerSkillUnlockPanel:GetExAttrItemObj()
    local obj = self:PopUITmpObject("ExAttrItem")
    obj.objectTransform:SetParent(self.ExScrollContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

-- 多个战技
function PartnerSkillUnlockPanel:GetMutiItemObj()
    local obj = self:PopUITmpObject("MultiSkillItem")
    obj.objectTransform:SetParent(self.MultiType.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function PartnerSkillUnlockPanel:__ShowComplete()
    if not self.blurBack then
        local setting = {passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({self:ToFunc("BlurComplete") })
    self.Close:SetActive(false)
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1,1,function()
        if self.Close then
            self.Close:SetActive(true)
        end
    end)
end

function PartnerSkillUnlockPanel:BlurComplete()
    self:SetActive(true)
end

function PartnerSkillUnlockPanel:OnClick_Close()
    
end

function PartnerSkillUnlockPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end