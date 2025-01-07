WeaponRefineTipPanel = BaseClass("WeaponRefineTipPanel", BasePanel)

function WeaponRefineTipPanel:__init()
    self:SetAsset("Prefabs/UI/Weapon/WeaponRefineTipPanel.prefab")
end

function WeaponRefineTipPanel:__BindListener()
    self.Close_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
    --self.RoleStageUpTipPanel_Eixt_hcb.HideAction:AddListener(self:ToFunc("Close_HideCallBack"))
end

function WeaponRefineTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function WeaponRefineTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

--[[
    config = 
    {
        id,
        refine
    }
]]

function WeaponRefineTipPanel:__Show()
    self.config = self.args
    self:ShowDetail()
end

function WeaponRefineTipPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 3, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function WeaponRefineTipPanel:BlurComplete()
    self:SetActive(true)
end

function WeaponRefineTipPanel:ShowDetail()
    local id, refine = self.config.id, self.config.refine
    local refineConfig = RoleConfig.GetWeaponRefineConfig(id, refine)
    if refineConfig then
        self.SkillDescribe_txt.text = refineConfig.desc
    else
        self.SkillDescribe_txt.text = ""
    end
    self.RefineText_txt.text = refine
    self.RefineDescribe_txt.text = string.format(TI18N("精炼%s级"), refine)
    if refine < 5 then 
        UtilsUI.SetActive(self.Levelbg1,true)
        UtilsUI.SetActive(self.Levelbg2,false)
    else
        UtilsUI.SetActive(self.Levelbg1,false)
        UtilsUI.SetActive(self.Levelbg2,true)
    end

end

function WeaponRefineTipPanel:OnClick_ClosePanel()
    PanelManager.Instance:ClosePanel(WeaponRefineTipPanel)
end
