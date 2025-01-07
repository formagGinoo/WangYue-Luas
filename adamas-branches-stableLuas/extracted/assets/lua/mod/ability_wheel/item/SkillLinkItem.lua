SkillLinkItem = BaseClass("SkillLinkItem", Module)

function SkillLinkItem:__init()
    self.cont = nil
end

function SkillLinkItem:__delete()
	
end

function SkillLinkItem:InitItem(skillItemGo, linkId)
    self.cont = UtilsUI.GetContainerObject(skillItemGo)

    self:ResetItem(linkId)
end

function SkillLinkItem:ResetGo(skillItemGo)
    self.cont = UtilsUI.GetContainerObject(skillItemGo)
end

function SkillLinkItem:ResetItem(linkId)
    if linkId and linkId > 0 then
        self.abilityInfo = AbilityWheelConfig.GetWheelAbility(linkId)
    else
        self.abilityInfo = nil
    end

    if self.abilityInfo then
        UtilsUI.SetActive(self.cont.BackNode, true)
        UtilsUI.SetActive(self.cont.PartnerNode, true)
        UtilsUI.SetActive(self.cont.SkillIcon, true)

        if self.abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Active then
            UtilsUI.SetActive(self.cont.ActiveBackNode, true)
            UtilsUI.SetActive(self.cont.PassiveBackNode, false)
        elseif self.abilityInfo.skill_type == AbilityWheelEnum.AbilitySkillType.Passive then
            UtilsUI.SetActive(self.cont.ActiveBackNode, false)
            UtilsUI.SetActive(self.cont.PassiveBackNode, true)
        else
            UtilsUI.SetActive(self.cont.ActiveBackNode, false)
            UtilsUI.SetActive(self.cont.PassiveBackNode, false)
        end

        if self.abilityInfo.type == AbilityWheelEnum.AbilityType.Partner then
            UtilsUI.SetActive(self.cont.PartnerNode, true)
            if self.abilityInfo.partner then
                local partnerId = self.abilityInfo.partner[1]
                local partnerCfg = PartnerConfig.GetPartnerConfig(partnerId)
                SingleIconLoader.Load(self.cont.PartnerIcon, partnerCfg.chead_icon)
                UtilsUI.SetActive(self.cont.PartnerIcon, true)
            else
                UtilsUI.SetActive(self.cont.PartnerIcon, false)
            end
        else
            UtilsUI.SetActive(self.cont.PartnerNode, false)
        end

        local overrideIconPath = mod.AbilityWheelCtrl:GetOverrideLinkIcon(linkId)

        if overrideIconPath then
            SingleIconLoader.Load(self.cont.SkillIcon, overrideIconPath)
            UtilsUI.SetActive(self.cont.SkillIcon, true)
        elseif self.abilityInfo.icon then
            SingleIconLoader.Load(self.cont.SkillIcon, self.abilityInfo.icon)
            UtilsUI.SetActive(self.cont.SkillIcon, true)
        else
            UtilsUI.SetActive(self.cont.SkillIcon, false)
        end
    else
        UtilsUI.SetActive(self.cont.BackNode, false)
        UtilsUI.SetActive(self.cont.PartnerNode, false)
        UtilsUI.SetActive(self.cont.SkillIcon, false)
    end
end

function SkillLinkItem:SetPartnerIsLock(isLock)
    if isLock then
        UtilsUI.SetActive(self.cont.PartnerLock, true)
    else
        UtilsUI.SetActive(self.cont.PartnerLock, false)
    end
end

function SkillLinkItem:Reset()
	
end

function SkillLinkItem:OnReset()

end