PurchaseRechargePanel = BaseClass("PurchaseRechargePanel", BasePanel)

function PurchaseRechargePanel:__init(parent)
    self:SetAsset("Prefabs/UI/Purchase/PurchaseRechargePanel.prefab")
    self.itemObjList = {}
end

function PurchaseRechargePanel:__BindEvent()
end

function PurchaseRechargePanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.OnPurchaseRecord, self:ToFunc("ReUpdateInfo"))
end

function PurchaseRechargePanel:__Create()

end

function PurchaseRechargePanel:__Show()
    self:UpdateInfo()
end

function PurchaseRechargePanel:__ShowComplete()

end

function PurchaseRechargePanel:__Hide()

end

function PurchaseRechargePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.OnPurchaseRecord, self:ToFunc("ReUpdateInfo"))
end

function PurchaseRechargePanel:UpdateInfo()
    local data = mod.PurchaseCtrl.PurchaseCfg
    for i, rechargeData in ipairs(data) do
        local itemObj = self.itemObjList[i] or self:GetItemObj()
        itemObj.FirstTip1_txt.text = TI18N("首充双倍")
        itemObj.FirstTip2_txt.text = TI18N("仅限一次")
        if rechargeData.icon ~= "" then
            AtlasIconLoader.Load(itemObj.MainIcon, rechargeData.icon)
        end
        if rechargeData.icon_bg ~= "" then
           AtlasIconLoader.Load(itemObj.BgIcon, rechargeData.icon_bg)
        end
        itemObj.Count_txt.text = rechargeData.name
        itemObj.CountUnit_txt.text = TI18N("枚")
        local itemConfig = ItemConfig.GetItemConfig(rechargeData.item_id)
        itemObj.Name_txt.text = itemConfig.name
        itemObj.PriceText_txt.text = TI18N("￥") .. rechargeData.price
        self:UpdateRechargeData(rechargeData, itemObj)
        local onClickBuy = function()
            mod.PurchaseCtrl:DoRecharge(data[i].id)
        end
        itemObj.Buy_btn.onClick:RemoveAllListeners()
        itemObj.Buy_btn.onClick:AddListener(onClickBuy)
        self.itemObjList[i] = itemObj
    end
end

function PurchaseRechargePanel:UpdateRechargeData(rechargeData, itemObj)
    --首充
    local isFirst = not mod.PurchaseCtrl.PurchaseRecord[rechargeData.id] or mod.PurchaseCtrl.PurchaseRecord[rechargeData.id] == 0
    itemObj.FirstRecharge:SetActive(isFirst)

    --额外奖励
    if isFirst then
        itemObj.ExtraReward:SetActive(rechargeData.first_item_id ~= 0)
        if rechargeData.first_item_id ~= 0 then
            itemObj.ExtraRewardCount_txt.text = rechargeData.first_item_num
        end
    else
        itemObj.ExtraReward:SetActive(rechargeData.extra_item_id ~= 0)
        if rechargeData.extra_item_id ~= 0 then
            itemObj.ExtraRewardCount_txt.text = rechargeData.extra_item_num
        end
    end
    itemObj.ExtraRewardText_txt.text = TI18N("额外赠")
    -- 归一镇库道具
    SingleIconLoader.Load(itemObj.ExtraRewardIcon, ItemConfig.GetItemIcon(4))
end

-- 更新首充和额外奖励信息
function PurchaseRechargePanel:ReUpdateInfo()
    local data = mod.PurchaseCtrl.PurchaseCfg
    for i, rechargeData in ipairs(data) do
        self:UpdateRechargeData(rechargeData, self.itemObjList[i])
    end
end

function PurchaseRechargePanel:GetItemObj()
    local obj = self:PopUITmpObject("Item")
    obj.objectTransform:SetParent(self.List.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    obj.objectTransform:SetActive(true)

    return obj
end

function PurchaseRechargePanel:Close_HideCallBack()
    self:Hide()
end
