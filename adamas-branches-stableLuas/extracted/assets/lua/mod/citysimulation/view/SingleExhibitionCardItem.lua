SingleExhibitionCardItem = BaseClass("SingleExhibitionCardItem")

function SingleExhibitionCardItem:UpdateData(_data)
    self.object = _data.object
    self.transform = self.object.transform
    self.index = _data.index
    self.shopLevel = _data.shopLevel
    self.shopId = _data.shopId
    self.shopEmployeeNum = _data.shopEmployeeNum
    self.parentWindow = _data.parentWindow
    UtilsUI.GetContainerObject(self.transform, self)

    if self.index > self.shopEmployeeNum then
        self:UpdateNullStatePart()
    else
       self:UpdateCommonStatePart()
    end

    -- todo 长按功能测试
    local position = self.parentWindow._rect:InverseTransformPoint(self.AbilityIconBtn1_rect.position)      -- 需要获取世界坐标
    local downCallback = function() self.parentWindow:ShowDetailTips(position) end
    local upCallback = function() self.parentWindow:HideDetailTips() end
    self:SetLongPressEvent(self.AbilityIconBtn1, downCallback, upCallback, 1, 1)
    
    local position1 = self.parentWindow._rect:InverseTransformPoint(self.AbilityIconBtn2_rect.position)
    local downCallback1 = function() self.parentWindow:ShowDetailTips(position1) end
    self:SetLongPressEvent(self.AbilityIconBtn2, downCallback1, upCallback, 1, 1)
end

function SingleExhibitionCardItem:UpdateNullStatePart()
    self.NullStatePart_canvas.alpha = 1
    self.NullStatePart_canvas.blocksRaycasts = true
    self.CommonStatePart_canvas.alpha = 0
    self.CommonStatePart_canvas.blocksRaycasts = false
    
    self.NullBtn_btn.onClick:RemoveAllListeners()
    self.NullBtn_btn.onClick:AddListener(function() EventMgr.Instance:Fire(EventName.OpenAdjustmentPanel) end)
    
    self.Index_txt.text = self.index
end 

function SingleExhibitionCardItem:UpdateCommonStatePart()
    self.NullStatePart_canvas.alpha = 0
    self.NullStatePart_canvas.blocksRaycasts = false
    self.CommonStatePart_canvas.alpha = 1
    self.CommonStatePart_canvas.blocksRaycasts = true
    
    self.Index_txt.text = self.index
end 

function SingleExhibitionCardItem:SetLongPressEvent(_obj, _pointerDownCallback, _pointerUpCallback, _pressTime, _invokeRate)
    local longPressEvent = _obj:GetComponent(LongPressEvent)
    if not longPressEvent then
        longPressEvent = _obj:AddComponent(LongPressEvent)
    end

    longPressEvent.enabled = true
    longPressEvent:SetLongPressParam(_pointerDownCallback, _pointerUpCallback, _pressTime, _invokeRate or 0)
end

function SingleExhibitionCardItem:ShowDetailTips()
    
end 

function SingleExhibitionCardItem:HideDetailTips()
    
end 