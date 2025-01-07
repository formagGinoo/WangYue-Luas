UseMultiItemWindow = BaseClass("UseMultiItemWindow", BaseWindow)

function UseMultiItemWindow:__init(parent)
    self:SetAsset("Prefabs/UI/Bag/UseMultiItemPanel.prefab")
    self.parent = parent
    self.cacheMode = UIDefine.CacheMode.hide

    self.items = {}
    self.itemObj = {}
    self.selectedItem = nil
    self.useCallBack = nil

    self.cacheList = {}

    self.blurBack = nil
end

function UseMultiItemWindow:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Back"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmUse"))
end

function UseMultiItemWindow:__Show()
    self:SetBlurBack()
    self.TitleText_txt.text = TI18N("使用道具")
    self.items = self.args.item_ids
    self.useCallBack = self.args.callBack
    self.selectedIndex = self.args.selectedIndex

    table.sort(self.items, function (a, b)
        local ac = ItemConfig.GetItemConfig(a)
        local bc = ItemConfig.GetItemConfig(b)
        if ac.quality ~= bc.quality then
            return ac.quality > bc.quality
        end

        return ac.order_id > bc.order_id
    end)
    self:UpdateInfo()
end

function UseMultiItemWindow:__ShowComplete()
end

function UseMultiItemWindow:__Hide()
    self.useCallBack = nil
    self.selectedItem = nil

    self:PushAllUITmpObject("CommonItem", self.CacheRoot_rect)
end

function UseMultiItemWindow:__delete()
    self.useCallBack = nil
    self.selectedItem = nil


end

function UseMultiItemWindow:UpdateInfo()
    local onclick = function (itemId)
        self.selectedItem.commonItem:SetSelected_Normal(false)
        self.selectedItem = self.itemObj[itemId]
        self.selectedItem.commonItem:SetSelected_Normal(true)
    end
    
    local index = 0
    for i = 1, #self.items do
        local items = mod.BagCtrl:GetItemInBag(self.items[i])
        local itemNum = 0
        local uniqueId = nil
        if items then
            for k, v in pairs(items) do
                itemNum = itemNum + v.count
                if not uniqueId and v.count ~= 0 then
                    uniqueId = v.unique_id
                end
            end
        end
        if itemNum > 0 then
            index = index + 1;
            local item = self:GetItemObj()
            local itemInfo = { template_id = self.items[i], count = itemNum, can_lock = false, btnFunc = function() onclick(self.items[i]) end }
            item.commonItem:InitItem(item.object, itemInfo, true)
            --item.commonItem:Show()
            item.uniqueId = uniqueId

            self.itemObj[self.items[i]] = item
            if not self.selectedItem then
                self.selectedItem = item
                self.selectedItem.commonItem:SetSelected_Normal(true)
            end
        end
    end
    self.Tips:SetActive(index == 0)
    if index == 0 then
        self.Tips_txt.text = TI18N("暂无复活道具")
    end
end

function UseMultiItemWindow:OnClick_ConfirmUse()
    if not self.selectedItem then
        self:OnClick_Back()
        return
    end
    local itemCount = mod.BagCtrl:GetItemCountById(self.selectedItem.commonItem.itemConfig.id)
    if itemCount <= 0 then
        MsgBoxManager.Instance:ShowTips(TI18N("道具数量不足"))
        return
    end
    local itemConfig = self.selectedItem.commonItem.itemConfig
    local magicIds = itemConfig.use_effect
    local lev = itemConfig.property1 or 0
    lev = math.max(lev, 1)
    if magicIds and next(magicIds) then
        for k = 1, #magicIds do
            Fight.Instance.playerManager:GetPlayer():UseItem(self.selectedIndex, magicIds[k], lev)
        end
    end

    MsgBoxManager.Instance:ShowTips(TI18N("使用道具成功"))
    mod.BagCtrl:UseItem({ unique_id = self.selectedItem.uniqueId, count = 1 })
    if self.useCallBack then
        self.useCallBack()
    end

    self:OnClick_Back()
end

function UseMultiItemWindow:OnClick_Back()
    WindowManager.Instance:CloseWindow(self)
end

function UseMultiItemWindow:Back()
    WindowManager.Instance:CloseWindow(self)
end

function UseMultiItemWindow:GetItemObj()
    local itemObj = self:PopUITmpObject("CommonItem", self.Content_rect)
    itemObj.commonItem = CommonItem.New()

    return itemObj
end

function UseMultiItemWindow:CacheItemObj()
end