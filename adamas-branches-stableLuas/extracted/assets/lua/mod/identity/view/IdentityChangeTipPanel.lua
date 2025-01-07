IdentityChangeTipPanel = BaseClass("IdentityChangeTipPanel", BasePanel)

function IdentityChangeTipPanel:__init()
    self:SetAsset("Prefabs/UI/Identity/IdentityChangeTipPanel.prefab")
end

function IdentityChangeTipPanel:__BindListener()

end

function IdentityChangeTipPanel:__Hide()
end

function IdentityChangeTipPanel:__Show()
    if self.args.type then
        self.type = self.args.type
        UtilsUI.SetActive(self.IdentityLvUp,true)
        UtilsUI.SetActive(self.IdentityChange,false)
        self.IdentityName_txt.text = IdentityConfig.GetIdentityTitleConfig(self.type,self.args.lv).name
    else
        --self.args = {{id = 10,val = 1}, {id = 11,val = 3}, {id = 12,val = 3}}
        UtilsUI.SetTextColor(self.ChangValue1_txt,IdentityConfig.GetIdentityAttrConfig(10).color)
        UtilsUI.SetTextColor(self.ChangValue2_txt,IdentityConfig.GetIdentityAttrConfig(11).color)
        UtilsUI.SetTextColor(self.ChangValue3_txt,IdentityConfig.GetIdentityAttrConfig(12).color)
        UtilsUI.SetActive(self.IdentityLvUp,false)
        UtilsUI.SetActive(self.IdentityChange,true)
        self:ShowDetail()
    end
    LuaTimerManager.Instance:AddTimer(1,3,self:ToFunc("OnClose"))
end

function IdentityChangeTipPanel:ShowDetail()
    UtilsUI.SetActive(self.Value1,false)
    UtilsUI.SetActive(self.Value2,false)
    UtilsUI.SetActive(self.Value3,false)
    for k, v in pairs(self.args) do
        if v.id == 10 then
            UtilsUI.SetActive(self.Value1,true)
            self.ChangValue1_txt.text = TI18N(IdentityConfig.GetIdentityAttrConfig(10).name) .. "+" .. v.val
        elseif v.id == 11 then
            UtilsUI.SetActive(self.Value2,true)
            self.ChangValue2_txt.text = TI18N(IdentityConfig.GetIdentityAttrConfig(11).name) .. "+" .. v.val
        elseif v.id == 12 then
            UtilsUI.SetActive(self.Value3,true)
            self.ChangValue3_txt.text = TI18N(IdentityConfig.GetIdentityAttrConfig(12).name) .. "+" .. v.val
        end
    end
end

function IdentityChangeTipPanel:OnClose()
    self:Hide()
end