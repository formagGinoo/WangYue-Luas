SingleBottomCardItem = BaseClass("SingleBottomCardItem")

function SingleBottomCardItem:UpdateData(_data)
    self.object = _data.object
    self.transform = self.object.transform
    self.index = _data.index
    self.shopLevel = _data.shopLevel
    self.shopId = _data.shopId
    self.shopEmployeeNum = _data.shopEmployeeNum
    UtilsUI.GetContainerObject(self.transform, self)
    
    self.BottomCardIndex_txt.text = self.index
    self.isNull = self.index > self.shopEmployeeNum
    self.BottomCommonState_canvas.alpha = self.index > self.shopEmployeeNum and 0 or 1
    self.BottomCommonState_canvas.blocksRaycasts = self.index > self.shopEmployeeNum and false or true
    self.BottomNullState_canvas.alpha = self.index > self.shopEmployeeNum and 1 or 0
    self.BottomNullState_canvas.blocksRaycasts = self.index > self.shopEmployeeNum
    
    self._btn.onClick:AddListener(function()
        EventMgr.Instance:Fire(EventName.OnClickSelectBottomCard, self.index)
    end)
end 

function SingleBottomCardItem:SetNullState()
    self.isNull = true
    self.BottomCommonState_canvas.alpha = 0
    self.BottomCommonState_canvas.blocksRaycasts = false
    self.BottomNullState_canvas.alpha = 1
    self.BottomNullState_canvas.blocksRaycasts = true
end 

function SingleBottomCardItem:SetCommonState()
    self.isNull = false
    self.BottomCommonState_canvas.alpha = 1
    self.BottomCommonState_canvas.blocksRaycasts = true
    self.BottomNullState_canvas.alpha = 0
    self.BottomNullState_canvas.blocksRaycasts = false
end 