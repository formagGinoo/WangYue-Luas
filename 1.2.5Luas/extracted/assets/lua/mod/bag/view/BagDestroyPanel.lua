BagDestroyPanel = BaseClass("BagDestroyPanel", BasePanel)

function BagDestroyPanel:__init()
    self:SetAsset("Prefabs/UI/Bag/BagDestroyPanel.prefab")

    -- 临时的退场计时器
    self.animatorTimers = {}

    self.itemList = {}
    self.returnList = {}

    -- itemObj缓存和showList
    self.itemObjList = {}
    self.itemObjShowList = {}
end

function BagDestroyPanel:__BindEvent()

end

function BagDestroyPanel:__BindListener()
    self.BackBtn_btn.onClick:AddListener(self:ToFunc("ClosePanel"))
    self.CancelBtn_btn.onClick:AddListener(self:ToFunc("ClosePanel"))
    self.ConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Confirm"))
end

function BagDestroyPanel:__CacheObject()

end

function BagDestroyPanel:__delete()
    if self.blurBack then
        self.blurBack:Destroy()
    end

    if self.animatorTimers then
        for k, v in pairs(self.animatorTimers) do
            LuaTimerManager.Instance:RemoveTimer(v)
            v = nil
        end
    end
end

function BagDestroyPanel:__Hide()
    self.itemList = {}
    self.returnList = {}

    for i = #self.itemObjShowList, 1, -1 do
        local obj = table.remove(self.itemObjShowList)
        UtilsUI.SetActive(obj.object, false)
        table.insert(self.itemObjList, obj)
    end

    if self.blurBack then
        self.blurBack:Hide()
    end

    if self.animatorTimers then
        for k, v in pairs(self.animatorTimers) do
            LuaTimerManager.Instance:RemoveTimer(v)
            v = nil
        end
    end
end

function BagDestroyPanel:__Show()
    self:SetItemList(self.args.itemList)

    local haveReturn = self.returnList and next(self.returnList)
    self.HaveReturn:SetActive(haveReturn)
    self.NoReturn:SetActive(not haveReturn)
    self:UpdateDestroyList(haveReturn)
    if haveReturn then
        self:UpdateReturnList()
    end
end

function BagDestroyPanel:__ShowComplete()
    -- if not self.blurBack then
    --     local setting = { bindNode = self.BlurNode }
    --     self.blurBack = BlurBack.New(self, setting)
    -- end
    -- self:SetActive(false)
    -- self.blurBack:Show()
end

function BagDestroyPanel:ClosePanel()
    if self.animatorTimers["MainPanel"] then
        LuaTimerManager.Instance:RemoveTimer(self.animatorTimers["MainPanel"])
        self.animatorTimers["MainPanel"] = nil
    end

    local callBackFunc = function ()
        self:Hide()
    end
    local animator = self.transform:GetComponent(Animator)
    animator:SetBool("IsExit", true)
    self.animatorTimers["MainPanel"] = LuaTimerManager.Instance:AddTimer(1, 0.5, callBackFunc)
end

function BagDestroyPanel:SetItemList(itemList)
    if not itemList or not next(itemList) then
        return
    end

    local tempSellList = {}
    for k, v in pairs(itemList) do
        local sellGet = v.singleItem.commonItem.itemConfig.sell_get
        if sellGet and next(sellGet) then
            for i = 1, #sellGet do
                if not tempSellList[sellGet[i][1]] then
                    tempSellList[sellGet[i][1]] = sellGet[i][2] * v.count
                else
                    tempSellList[sellGet[i][1]] = tempSellList[sellGet[i][1]] + (sellGet[i][2] * v.count)
                end
            end
        end

        table.insert(self.itemList, { unique_id = v.unique_id, template_id = v.singleItem.commonItem.itemConfig.id, count = v.count })
    end

    for k, v in pairs(tempSellList) do
        table.insert(self.returnList, { template_id = k, count = v })
    end

    mod.BagCtrl:SortItemData(self.itemList, BagEnum.SortType.Quality, false)
    mod.BagCtrl:SortItemData(self.returnList, BagEnum.SortType.Quality, false)
end

function BagDestroyPanel:UpdateDestroyList(haveReturn)
    for i = 1, #self.itemList do
        local singleItem = self:GetItemObj()
        singleItem.commonItem:InitItem(singleItem.object, self.itemList[i])
        --singleItem.commonItem:Show()

        local singleItemRect = singleItem.object:GetComponent(RectTransform)
        singleItem.rect = singleItemRect
        singleItemRect:SetParent(haveReturn and self.DestroyList_rect or self.NoReturnList_rect)
        UnityUtils.SetLocalScale(singleItem.object.transform, 0.8, 0.8, 0.8)
        singleItem.object:SetActive(true)

        table.insert(self.itemObjShowList, singleItem)
    end
end

function BagDestroyPanel:UpdateReturnList()
    for i = 1, #self.returnList do
        local singleItem = self:GetItemObj()
        singleItem.commonItem:InitItem(singleItem.object, self.returnList[i])
        --singleItem.commonItem:Show()

        local singleItemRect = singleItem.object:GetComponent(RectTransform)
        singleItem.rect = singleItemRect
        singleItemRect:SetParent(self.ReturnList_rect)
        UnityUtils.SetLocalScale(singleItem.object.transform, 0.8, 0.8, 0.8)
        singleItem.object:SetActive(true)

        table.insert(self.itemObjShowList, singleItem)
    end
end

function BagDestroyPanel:GetItemObj()
    if self.itemObjList and next(self.itemObjList) then
        return table.remove(self.itemObjList)
    end

    local obj = self:PopUITmpObject("CommonItem")
    local commonItem = CommonItem.New()
    obj.commonItem = commonItem

    return obj
end

function BagDestroyPanel:OnClick_Confirm()
    self.parentWindow:ConfirmDel()
    self:ClosePanel()
end