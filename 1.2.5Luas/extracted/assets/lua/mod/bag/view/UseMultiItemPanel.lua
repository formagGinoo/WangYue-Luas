UseMultiItemPanel = BaseClass("UseMultiItemPanel", BasePanel)

function UseMultiItemPanel:__init(parent)
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

function UseMultiItemPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Back"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmUse"))
end

function UseMultiItemPanel:__Show()
    self.items = self.args.item_ids
    self.useCallBack = self.args.callBack
    self.selectedIndex = self.args.selectedIndex

    self:UpdateInfo()
end

function UseMultiItemPanel:__ShowComplete()
    -- if not self.blurBack then
    --     local setting = { bindNode = self.BlurNode }
    --     self.blurBack = BlurBack.New(self, setting)
    -- end
    -- self:SetActive(false)
    -- self.blurBack:Show()
end

function UseMultiItemPanel:__Hide()
    self.useCallBack = nil
    self.selectedItem = nil

    self:CacheItemObj()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function UseMultiItemPanel:__delete()
    self.useCallBack = nil
    self.selectedItem = nil

    self:CacheItemObj()
    if self.blurBack then
        self.blurBack:Destroy()
    end
end

function UseMultiItemPanel:UpdateInfo()
    local onclick = function (itemId)
        self.selectedItem.commonItem:SetSelected_Normal(false)
        self.selectedItem = self.itemObj[itemId]
        self.selectedItem.commonItem:SetSelected_Normal(true)
    end

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

        local item = self:GetItemObj()
        item.object.transform:SetParent(self.Content.transform)
        UnityUtils.SetLocalScale(item.object.transform, 1, 1, 1)
        item.object:SetActive(true)

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

function UseMultiItemPanel:OnClick_ConfirmUse()
    local itemCount = mod.BagCtrl:GetItemCountById(self.selectedItem.commonItem.itemConfig.id)
    if itemCount <= 0 then
        MsgBoxManager.Instance:ShowTips("道具数量不足")
        return
    end

    local magicIds = self.selectedItem.commonItem.itemConfig.use_effect
    if magicIds and next(magicIds) then
        for k = 1, #magicIds do
            Fight.Instance.playerManager:GetPlayer():UseItem(self.selectedIndex, magicIds[k])
        end
    end

    MsgBoxManager.Instance:ShowTips("使用道具成功")
    mod.BagCtrl:UseItem({ unique_id = self.selectedItem.uniqueId, count = 1 })
    if self.useCallBack then
        self.useCallBack()
    end

    self:OnClick_Back()
end

function UseMultiItemPanel:OnClick_Back()
    self.CommonTipPart_Exit:SetActive(true)
end

function UseMultiItemPanel:Back()
    self:Hide()
end

function UseMultiItemPanel:GetItemObj()
    if self.cacheList and next(self.cacheList) then
        return table.remove(self.cacheList, 1)
    end

    local itemObj = self:PopUITmpObject("CommonItem")
    itemObj.commonItem = CommonItem.New()

    return itemObj
end

function UseMultiItemPanel:CacheItemObj()
    for k, v in pairs(self.itemObj) do
        v.object:SetActive(false)
        table.insert(self.cacheList, v)
    end

    TableUtils.ClearTable(self.itemObj)
end