PartnerSkillPreviewPanel = BaseClass("PartnerSkillPreviewPanel", BasePanel)

function PartnerSkillPreviewPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerSkillPreviewPanel.prefab")
end

function PartnerSkillPreviewPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerSkillPreviewPanel:__BindListener()
    self.CloseButton_btn.onClick:AddListener(self:ToFunc("Close"))
    UtilsUI.SetHideCallBack(self.PartnerSkillPreviewPanel_Eixt, function ()
        PanelManager.Instance:ClosePanel(self)
    end)
end

function PartnerSkillPreviewPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function PartnerSkillPreviewPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 3, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function PartnerSkillPreviewPanel:BlurComplete()
    self:SetActive(true)
end

function PartnerSkillPreviewPanel:__Show()
    self.partnerId = self.args.partnerId
    self:ShowDetail(self.partnerId)
end

function PartnerSkillPreviewPanel:ShowDetail(partnerId)
    local partnerData = mod.BagCtrl:GetPartnerData(partnerId)
    local unlockLev, count = RoleConfig.GetPartnerNextUnlockSkillCount(partnerData.template_id, partnerData.lev)
    --#FFC42E
    self.UnlockDesc_txt.text = string.format(TI18N("升至<color=#FFC42E>LV.%s</color>随机解锁%s个新战技"), unlockLev, count)
    local skillList = RoleConfig.GetPartnerSkillRandom(partnerData.template_id, unlockLev)
    for i = 1, #skillList, 1 do
        local skillId = skillList[i]
        local skillConfig = RoleConfig.GetPartnerSkillConfig(skillId)
        local skillLev = mod.BagCtrl:GetPartnerSkillLevel(partnerId, skillId)
        local obj
        if skillConfig.type == RoleConfig.PartnerSkillType.Specificity then
            obj = self:GetSkillObject(self.SpecificityRoot_rect)
            obj.Box:SetActive(true)
        elseif skillConfig.type == RoleConfig.PartnerSkillType.Common then
            obj = self:GetSkillObject(self.CommonRoot_rect)
            obj.Box:SetActive(false)
        end
        obj.LockBg:SetActive(false)
        obj.Learn:SetActive(skillLev and true)
        skillLev = skillLev or 1
        obj.Level_txt.text = skillLev
        obj.SkillName_txt.text = skillConfig.name
        SingleIconLoader.Load(obj.Icon, skillConfig.icon)
        local levelConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, skillLev)
        if levelConfig.simple_desc == "" then
            obj.SkillDesc_txt.text = levelConfig.desc_info
        else
            obj.SkillDesc_txt.text = levelConfig.simple_desc
        end

    end
    -- 触发自适应
    UnityUtils.SetAnchoredPosition(self.SpecificityRoot_rect, 0,0)
    UnityUtils.SetAnchoredPosition(self.CommonRoot_rect, 0,0)
end

function PartnerSkillPreviewPanel:GetSkillObject(parent)
    local obj = self:PopUITmpObject("SkillObject")
    obj.objectTransform:SetParent(parent)
    obj.objectTransform:ResetAttr()
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function PartnerSkillPreviewPanel:Close()
    self.PartnerSkillPreviewPanel_Eixt:SetActive(true)
end