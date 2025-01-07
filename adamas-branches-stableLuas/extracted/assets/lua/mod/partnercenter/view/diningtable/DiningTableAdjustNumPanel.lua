DiningTableAdjustNumPanel = BaseClass("DiningTableAdjustNumPanel", BasePanel)
DiningTableAdjustNumPanel.active = true

function DiningTableAdjustNumPanel:__init()
    self:SetAsset("Prefabs/UI/PartnerCenter/DiningTableAdjustNumPanel.prefab")
end

function DiningTableAdjustNumPanel:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.IncreaseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_IncreaseItemNum"))
    self.DecreaseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_DecreaseItemNum"))
    self.ConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeItemNum"))
    self.CancelBtn_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.Slider_sld.onValueChanged:AddListener(self:ToFunc("OnDragSlider_UpdateItemNum"))
end

function DiningTableAdjustNumPanel:__Show()
    self.itemId = self.args.itemId
    self.originNum = self.args.currNum
    self.currNum = self.args.currNum
    self.maxNum = self.args.maxNum
    self.bagItemNum = self.args.bagItemNum
    self.assetId = self.args.assetId
    self.uniqueId = self.args.uniqueId
    self.foodList = self.args.foodList
    self.parent = self.args.parent
    
    -- 初始化道具展示
    self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not self.commonItem then
        self.commonItem = CommonItem.New()
    end

    local itemData = ItemConfig.GetItemConfig(self.itemId)
    local itemInfo = {template_id = self.itemId, count = self.maxNum or 0, numColor = {1,1,1,0}}
    self.commonItem:InitItem(self.CommonItem2, itemInfo, true)
    self.ItemName_txt.text = TI18N(string.format("<color=#888A96>%s</color>", itemData.name))
    
    -- 更新数目
    self:UpdateItemNumText(self.currNum)
    self.IncreaseItemArea:SetActive(false)
    self.DecreaseItemArea:SetActive(false)
    self.SliderMinNum_txt.text = 0
    self.SliderMaxNum_txt.text = self.maxNum

    -- 初始化Slider
    self:InitSlider()
end

function DiningTableAdjustNumPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function DiningTableAdjustNumPanel:BlurShowCb()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function DiningTableAdjustNumPanel:__Hide()
    self:CacheBar()
end

function DiningTableAdjustNumPanel:__delete()
    if self.commonItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.commonItem)
    end
end

function DiningTableAdjustNumPanel:CacheBar()

end

function DiningTableAdjustNumPanel:InitSlider()
    self.Slider_sld.minValue = 0
    self.Slider_sld.maxValue = self.maxNum
    self.Slider_sld.value = self.currNum
end

function DiningTableAdjustNumPanel:UpdateItemNumText(currNum)
    if currNum > self.originNum and self.originNum + self.bagItemNum < currNum then     -- 超过可添加数量时红字提醒
        self.ItemNumText_txt.text = string.format("食物数目 (<color=#E53D2B>%d</color>/%d)", currNum, self.maxNum)
    else
        self.ItemNumText_txt.text = string.format("食物数目 (%d/%d)", currNum, self.maxNum)
    end
end

function DiningTableAdjustNumPanel:UpdateItemNumTips(currNum)
    if currNum > self.originNum then
        self.IncreaseItemArea:SetActive(true)
        self.DecreaseItemArea:SetActive(false)

        self.IncreaseItemText_txt.text = string.format("添加食物 %d", currNum - self.originNum)
        
    elseif currNum < self.originNum then
        self.IncreaseItemArea:SetActive(false)
        self.DecreaseItemArea:SetActive(true)

        self.DecreaseItemText_txt.text = string.format("减少食物 %d", self.originNum - currNum)
        
    else
        self.IncreaseItemArea:SetActive(false)
        self.DecreaseItemArea:SetActive(false)
    end
end

function DiningTableAdjustNumPanel:OnDragSlider_UpdateItemNum()
    self.currNum = self.Slider_sld.value
    
    self:UpdateItemNumText(self.currNum)
    
    self:UpdateItemNumTips(self.currNum)
end

function DiningTableAdjustNumPanel:OnClick_IncreaseItemNum()
    self.Slider_sld.value = self.Slider_sld.value + 1
    
    self:OnDragSlider_UpdateItemNum()
end

function DiningTableAdjustNumPanel:OnClick_DecreaseItemNum()
    self.Slider_sld.value = self.Slider_sld.value - 1

    self:OnDragSlider_UpdateItemNum()
end

function DiningTableAdjustNumPanel:OnClick_ChangeItemNum()
    if self.currNum > self.originNum and self.originNum + self.bagItemNum < self.currNum then
        MsgBoxManager.Instance:ShowTips(TI18N("背包道具不足"))
        return
    end

    if self.currNum == self.originNum then
        return
    end

    local foodList = {}
    for i = 1, #self.foodList do
        if self.foodList[i].itemId == self.itemId then
            table.insert(foodList, {["key"] = self.itemId, ["value"] = self.currNum})
        else
            table.insert(foodList, {["key"] = self.foodList[i].itemId, ["value"] = self.foodList[i].currNum})
        end
    end

    mod.PartnerCenterCtrl:SetDiningTableItemNum(self.assetId, self.uniqueId, foodList)
    
    self:PlayExitAnim()
end

function DiningTableAdjustNumPanel:__AfterExitAnim()
    self.parent:ClosePanel(DiningTableAdjustNumPanel)
end