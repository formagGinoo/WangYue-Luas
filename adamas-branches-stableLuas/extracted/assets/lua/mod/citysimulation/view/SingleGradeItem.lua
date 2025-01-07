SingleGradeItem = BaseClass("SingleGradeItem")

local color = {
    ["black"] = Color(0, 0, 0, 1),
    ["white"] = Color(1, 1, 1, 1),
}

function SingleGradeItem:UpdateData(data)
    self.object = data.object
    self.transform = self.object.transform
    self.index = data.index
    UtilsUI.GetContainerObject(self.transform, self)
    
    self.GradeName_txt.text = TI18N("委托评级") .. data.des
    self:SetLockState(true)
    
    self._btn.onClick:AddListener(self:ToFunc("OnClick_UpdateSelectState"))
end 

function SingleGradeItem:SetSelectState(_isSelect)
    if _isSelect then
        self.Selected:SetActive(true)
        self.Unselected:SetActive(false)
        self.GradeName_txt.color = color["white"]
    else
        self.Selected:SetActive(false)
        self.Unselected:SetActive(true)
        self.GradeName_txt.color = color["black"]
    end
end 

function SingleGradeItem:OnClick_UpdateSelectState()
    --todo 如果没达到评级 直接返回
    EventMgr.Instance:Fire(EventName.RefreshGradeItemSelectState, self.index)
end 

function SingleGradeItem:SetLockState(_isLock)
    if _isLock then
        self.Locked:SetActive(true)
        self.Unlocked:SetActive(false)
    else
        self.Locked:SetActive(false)
        self.Unlocked:SetActive(true)
    end
end 