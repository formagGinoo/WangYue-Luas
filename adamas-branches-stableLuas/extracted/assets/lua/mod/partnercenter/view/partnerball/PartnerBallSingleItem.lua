PartnerBallSingleItem = BaseClass("PartnerBallSingleItem")

function PartnerBallSingleItem:UpdateData(data)
    self.object = data.obj
    self.transform = self.object.transform
    self.index = data.index
    self.item = data.item
    self.name = data.name
    self.desc = data.desc
    self.icon = data.icon
    self.condition = data.condition
    self.isLock = Fight.Instance.conditionManager:CheckConditionByConfig(self.condition) == false
    self.isSelect = false
    UtilsUI.GetContainerObject(self.transform, self)
    
    for i = 1, 5, 1 do
        UtilsUI.SetActive(self["ItemQuality".. i], i == data.quality)
    end
    SingleIconLoader.Load(self.PartnerIcon, self.icon)
    self.PartnerBallText_txt.text = TI18N(self.name)
    self.LockIcon:SetActive(self.isLock)

    -- 注册点击事件
    self._btn.onClick:RemoveAllListeners()
    self._btn.onClick:AddListener(function()
        if self.isLock then
            MsgBoxManager.Instance:ShowTips(Fight.Instance.conditionManager:GetConditionDesc(self.condition))
            return
        end
        
        EventMgr.Instance:Fire(EventName.UpdateSelectedPartnerBallItem, data)
    end)
end

function PartnerBallSingleItem:UpdateSelectedState(isSelect)
    self.Selected:SetActive(isSelect)
end