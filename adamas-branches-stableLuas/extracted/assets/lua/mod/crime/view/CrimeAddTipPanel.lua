CrimeAddTipPanel = BaseClass("CrimeAddTipPanel", BasePanel)

function CrimeAddTipPanel:__init()
    self:SetAsset("Prefabs/UI/Crime/CrimeAddTipPanel.prefab")
end

function CrimeAddTipPanel:__BindListener()

end

function CrimeAddTipPanel:__Hide()
end

function CrimeAddTipPanel:__Show()
    -- if self.args.type then
    --     self.type = self.args.type
    --     UtilsUI.SetActive(self.IdentityLvUp,true)
    --     UtilsUI.SetActive(self.IdentityChange,false)
    --     self.IdentityName_txt.text = IdentityConfig.GetIdentityTitleConfig(self.type,self.args.lv).name
    -- else
    --     --self.args = {{id = 10,val = 1}, {id = 11,val = 3}, {id = 12,val = 3}}
    --     UtilsUI.SetTextColor(self.ChangValue1_txt,IdentityConfig.GetIdentityAttrConfig(10).color)
    --     UtilsUI.SetTextColor(self.ChangValue2_txt,IdentityConfig.GetIdentityAttrConfig(11).color)
    --     UtilsUI.SetTextColor(self.ChangValue3_txt,IdentityConfig.GetIdentityAttrConfig(12).color)
    --     UtilsUI.SetActive(self.IdentityLvUp,false)
    --     UtilsUI.SetActive(self.IdentityChange,true)
    --     self:ShowDetail()
    -- end
    self.type = self.args.type
    self:ShowDetail()
    LuaTimerManager.Instance:AddTimer(1,3,self:ToFunc("OnClose"))
end

function CrimeAddTipPanel:ShowDetail()
    local desc = CrimeConfig.GetBountyConfigByType(self.type).desc
    self.AddDesc_txt.text = desc
    self.BountyValue_txt.text = mod.CrimeCtrl:GetBountyValue()

    -- 头像
    local path = RoleConfig.HeroBaseInfo[mod.InformationCtrl:GetPlayerInfo().avatar_id].chead_icon
    SingleIconLoader.Load(self.HeadIcon, path)
end

function CrimeAddTipPanel:SetTxt()
    self.NowTxt_txt.text = TI18N("现在")
    self.CaseTxt_txt.text = TI18N("因")
    self.BountyDesc_txt.text = TI18N("悬赏值")
end

function CrimeAddTipPanel:OnClose()
    self:Hide()
end