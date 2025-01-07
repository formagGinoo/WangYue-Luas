SingleAdjustmentCardItem = BaseClass("SingleAdjustmentCardItem")

function SingleAdjustmentCardItem:UpdateData(_data)
    self.object = _data.object
    self.transform = self.object.transform
    self.index = _data.index
    self.shopLevel = _data.shopLevel
    self.shopId = _data.shopId
    self.employeeNum = _data.employeeNum
    self.isSelected = _data.isSelected
    UtilsUI.GetContainerObject(self.transform, self)

    self.WhiteBgBtn_btn.onClick:RemoveAllListeners()
    self.WhiteBgBtn_btn.onClick:AddListener(function()
        EventMgr.Instance:Fire(EventName.OnClickSelectAdjustmentCard, self.index)
    end)
    self.CardIndex_txt.text = self.index
    
    self:SetSelectedState(self.isSelected)
end

function SingleAdjustmentCardItem:SetSelectedState(_isSelect)
    if _isSelect ~= nil then
        self.isSelected = _isSelect
        self.SelectedState_canvas.alpha = _isSelect and 1 or 0
        self.SelectedState_canvas.blocksRaycasts = _isSelect
    else
        self.isSelected = not self.isSelected
        self.SelectedState_canvas.alpha = self.isSelected and 1 or 0
        self.SelectedState_canvas.blocksRaycasts = self.isSelected
    end
end 