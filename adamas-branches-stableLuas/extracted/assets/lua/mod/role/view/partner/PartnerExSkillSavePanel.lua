PartnerExSkillSavePanel = BaseClass("PartnerExSkillSavePanel", BasePanel)

function PartnerExSkillSavePanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerExSkillSavePanel.prefab")
end

function PartnerExSkillSavePanel:__BindEvent()

end

function PartnerExSkillSavePanel:__BindListener()
    self:BindCloseBtn(self.Close_btn,self:ToFunc("Close_HideCallBack"))
end

function PartnerExSkillSavePanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerExSkillSavePanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

local AttrType = 
{
    Desc = 1,
    Value = 2
}

function PartnerExSkillSavePanel:__Show()
    self.point = self.args.point
    self.config = self.args.config
    self:ShowDetail()
end

function PartnerExSkillSavePanel:ShowDetail()
    self.UseSkillPoint_txt.text = self.point
    local tempIndex = 0
    for i, v in ipairs(self.config) do
        local config = RoleConfig.GetPartnerSkillConfig(v.skillId)
        tempIndex = tempIndex + 1

        if tempIndex % 2 == 1 then
            self.nowTempObj = self:GetSkillGroupItemObj()
            UtilsUI.SetActive(self.nowTempObj.YellowTypeBg, config.type == RoleConfig.PartnerSkillType.BigNode)
            UtilsUI.SetActive(self.nowTempObj.BlueTypeBg1, config.type == RoleConfig.PartnerSkillType.MidNode)
  
            UtilsUI.SetActive(self.nowTempObj.Skill1, true)
            UtilsUI.SetActive(self.nowTempObj.Skill2, false)
            if config.type == RoleConfig.PartnerSkillType.BigNode then
                tempIndex = tempIndex + 1
            end
            if v.type == AttrType.Desc then
                local desc = v.desc
                SingleIconLoader.Load(self.nowTempObj.SkillIcon1, config.icon)
                self.nowTempObj.Desc1_txt.text = desc
            else
                local icon = RoleConfig.GetAttrConfig(v.attrKey).icon
                local desc, value = RoleConfig.GetShowAttr(v.attrKey, v.desc)
                SingleIconLoader.Load(self.nowTempObj.SkillIcon1, config.icon)
                self.nowTempObj.Desc1_txt.text = string.format("%s + %s",  desc, value)
            end
            if config.type == RoleConfig.PartnerSkillType.SmallNode then
                UtilsUI.SetTextColor(self.nowTempObj.Desc1_txt, "#000000")
            else
                UtilsUI.SetTextColor(self.nowTempObj.Desc1_txt, "#FFFFFF")
            end
        else
            UtilsUI.SetActive(self.nowTempObj.Skill2, true)
            UtilsUI.SetActive(self.nowTempObj.BlueTypeBg2, config.type == RoleConfig.PartnerSkillType.MidNode)
            if v.type == AttrType.Desc then
                local desc = v.desc
                SingleIconLoader.Load(self.nowTempObj.SkillIcon2, config.icon)
                self.nowTempObj.Desc2_txt.text = desc
            else
                local icon = RoleConfig.GetAttrConfig(v.attrKey).icon
                local desc, value = RoleConfig.GetShowAttr(v.attrKey, v.desc)
                SingleIconLoader.Load(self.nowTempObj.SkillIcon2, config.icon)
                self.nowTempObj.Desc2_txt.text = string.format("%s + %s",  desc, value)
            end
            if config.type == RoleConfig.PartnerSkillType.SmallNode then
                UtilsUI.SetTextColor(self.nowTempObj.Desc2_txt, "#000000")
            else
                UtilsUI.SetTextColor(self.nowTempObj.Desc2_txt, "#FFFFFF")
            end
        end
    end
end

function PartnerExSkillSavePanel:GetSkillGroupItemObj()
    local obj = self:PopUITmpObject("SkillAttrGroup")
    obj.objectTransform:SetParent(self.SkillScrollContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function PartnerExSkillSavePanel:__ShowComplete()
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

function PartnerExSkillSavePanel:BlurComplete()
    self:SetActive(true)
end

function PartnerExSkillSavePanel:OnClick_Close()
    
end

function PartnerExSkillSavePanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end