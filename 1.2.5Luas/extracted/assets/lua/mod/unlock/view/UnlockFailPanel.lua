UnlockFailPanel = BaseClass("UnlockFailPanel", BasePanel)

function UnlockFailPanel:__init()
    self:SetAsset("Prefabs/UI/Unlock/UnlockFailPanel.prefab")
end

function UnlockFailPanel:__delete()
end

function UnlockFailPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("ClickBackBtnCb"),function()
        self.case = 1
    end)
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("ClickBackBtnCb"),function()
        self.case = 2
    end)

    self.Submit_btn.onClick:AddListener(self:ToFunc("ClickSubmit"))
end

function UnlockFailPanel:ClickBackBtnCb()
    if self.case == 1 then 
        self:Hide()
    elseif self.case == 2 then 
        self:Hide()
        self.parentWindow:WinBack()
    end
end

function UnlockFailPanel:ClickSubmit()
    local cfg = self.unlockInitCfg
    local itemId = cfg.cost_id
    local costNum = cfg.cos_num
    if mod.BagCtrl:GetItemCountById(itemId) < costNum then
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
        return
    end
    -- 通知再次开锁
    mod.UnlockFacade:SendMsg("unlock_begin", cfg.lock_id)
    self.parentWindow:RestartUnlock()
    self:Hide()
end

function UnlockFailPanel:__Create()

end

function UnlockFailPanel:__Show()
    self.ecoId = self.args.ecoId
    local skillId = self.args.unlockSkillId

    self.unlockInitCfg = UnlockConfig.GetUnlockInitCfg(self.ecoId)
    self.partnerSkillCfg = RoleConfig.GetPartnerSkillConfig(skillId)

    self:UpdateCostView()
    self:UpdateTip()
end

function UnlockFailPanel:__Hide()
end

function UnlockFailPanel:UpdateCostView()
    local costId = self.unlockInitCfg.cost_id
    local costNum = self.unlockInitCfg.cos_num
    local curNum = mod.BagCtrl:GetItemCountById(costId)

    local desc = ""
    if curNum < costNum then
        desc = string.format("<color=#FF7171>%s</color>/<color=#B5B7BE>%s</color>", curNum, costNum)
    else
        desc = string.format("<color=#B5B7BE>%s/%s</color>", curNum, costNum)
    end
    self.NeedTxt_txt.text = desc

    -- self.Submit:SetActive(curNum >= costNum)
    -- self.LockBtn:SetActive(curNum < costNum)

    self.Submit:SetActive(true)
    self.LockBtn:SetActive(false)

    desc = string.format("提升佩从天赋【%s】可降低开锁难度", self.partnerSkillCfg.name)
    self.Desc_txt.text = desc
end

function UnlockFailPanel:UpdateTip()

end

