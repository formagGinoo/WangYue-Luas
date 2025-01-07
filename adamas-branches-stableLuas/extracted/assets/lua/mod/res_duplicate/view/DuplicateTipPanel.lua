DuplicateTipPanel = BaseClass("DuplicateTipPanel",BasePanel)
function DuplicateTipPanel:__init()
    self:SetAsset("Prefabs/UI/ResDuplicate/DuplicateTipPanel.prefab")
end

function DuplicateTipPanel:__CacheObject()

end

function DuplicateTipPanel:__BindListener()
    --  

    self.Cancel_btn.onClick:AddListener(self:ToFunc("OnClickCancelBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickShowBtn"))
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClickCloseBtn"))
    EventMgr.Instance:AddListener(EventName.LeaveDuplicate, self:ToFunc("OnClickCloseBtn"))
    EventMgr.Instance:AddListener(EventName.ResetDuplicate, self:ToFunc("OnClickCloseBtn"))

    -- self:BindCloseBtn(self.Cancel_btn,self:ToFunc("OnClickCancelBtn"))
    -- self:BindCloseBtn(self.Submit_btn,self:ToFunc("OnClickShowBtn"))
    -- self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClickCloseBtn"))
end

function DuplicateTipPanel:__Show()
    self.sureCallBack = self.args.sureCallBack
    self.hideCallBack = self.args.hideCallBack
    self:UpdateView()
    if InputManager.Instance then
        InputManager.Instance:SetCanInputState(false)
    end
end

function DuplicateTipPanel:__Hide()
    if InputManager.Instance then
        InputManager.Instance:SetCanInputState(true)
    end
end

function DuplicateTipPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.LeaveDuplicate, self:ToFunc("OnClickCloseBtn"))
    EventMgr.Instance:RemoveListener(EventName.ResetDuplicate, self:ToFunc("OnClickCloseBtn"))
end

function DuplicateTipPanel:UpdateView()
end

function DuplicateTipPanel:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(self)
end

function DuplicateTipPanel:OnClickShowBtn()
    if self.sureCallBack then
        self.sureCallBack()
        self.sureCallBack = nil
    end
    PanelManager.Instance:ClosePanel(self)
end

function DuplicateTipPanel:OnClickCancelBtn()
    if self.hideCallBack then
        self.hideCallBack()
        self.hideCallBack = nil
    end
    PanelManager.Instance:ClosePanel(self)
end
