ItemManager = SingleClass("ItemManager")

local itemTipsPanel = nil
local partnetTipsPanel = nil

local Quality_Convert_ColorImg = {
    [1] = { itemFront = "quality_f1" , front = "quality_shenf1", itemFront2 = "quality_f21", tipsFront = "quality_tf1", back = "qualityb11", back2 = "qualityb21", effect = "20020" },
    [2] = { itemFront = "quality_f2" ,front = "quality_shenf2", itemFront2 = "quality_f22",tipsFront = "quality_tf2", back = "qualityb12", back2 = "qualityb22",effect = "20020" },
    [3] = { itemFront = "quality_f3" ,front = "quality_shenf3", itemFront2 = "quality_f23",tipsFront = "quality_tf3", back = "qualityb13", back2 = "qualityb23",effect = "20020" },
    [4] = { itemFront = "quality_f4" ,front = "quality_shenf4", itemFront2 = "quality_f24",tipsFront = "quality_tf4", back = "qualityb14", back2 = "qualityb24",effect = "20020" },
    [5] = { itemFront = "quality_f5" ,front = "quality_shenf5", itemFront2 = "quality_f25",tipsFront = "quality_tf5", back = "qualityb15", back2 = "qualityb25",effect = "20019" },
    [6] = { itemFront = "quality_f6" ,front = "quality_shenf6", itemFront2 = "quality_f26",tipsFront = "quality_tf6", back = "qualityb16", back2 = "qualityb26",effect = "20019" },
}

ItemManager.CommonItemType = {
	Normal = 1, --正常正方向的commonitem
	Long = 2,-- 长方形的commonitem
}

function ItemManager.GetItemColorImg(quality)
    local colorImgData = Quality_Convert_ColorImg[quality]
    return colorImgData.front, colorImgData.back, colorImgData.itemFront, colorImgData.itemFront2,colorImgData.back2
end

function ItemManager.GetItemColorData(quality)
	return Quality_Convert_ColorImg[quality]
end

function ItemManager.GetItemEffect(quality)
	local colorImgData = Quality_Convert_ColorImg[quality]
	return colorImgData.effect
end

function ItemManager:__init()

end

function ItemManager:__delete()

end

function ItemManager:GetItem(parent, itemInfo, defaultShow, type)
	local item = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
	if not item then
		item = CommonItem.New()
	end
	item:LoadItem(parent, itemInfo, defaultShow,type)
	return item
end

function ItemManager:PushItemToPool(item)
	item:Reset()
	PoolManager.Instance:Push(PoolType.class, "CommonItem", item)
end

ItemManager.ItemTipsType = {
	White = 1,
	Black = 2,
}

function ItemManager:ShowItemTipsPanel(itemInfo, type)
	if itemInfo == nil then
		LogError("展示道具信息为空")
		return
	end
	local itemType = ItemConfig.GetItemType(itemInfo.template_id)
	if itemType == BagEnum.BagType.Partner and itemInfo.unique_id then
		if not partnetTipsPanel then 
			partnetTipsPanel = PanelManager.Instance:OpenPanel(PartnerTipsPanel, {unique_id = itemInfo.unique_id})
		end
	else
		if not itemTipsPanel then 
			itemTipsPanel = PanelManager.Instance:OpenPanel(ItemTipsPanel,{itemInfo = itemInfo})
		end
		itemTipsPanel:SetItemInfo(itemInfo)
	end
end

function ItemManager:CloseItemTipsPanel()
	itemTipsPanel = nil
end

function ItemManager:ClosePartnerTipsPanel()
	partnetTipsPanel = nil
end