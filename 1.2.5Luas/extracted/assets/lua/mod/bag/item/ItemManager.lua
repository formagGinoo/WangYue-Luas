ItemManager = SingleClass("ItemManager")

local Quality_Convert_ColorImg = {
    [1] = { front = "quality_f1", tipsFront = "quality_b1", back = "01", effect = "20020" },
    [2] = { front = "quality_f2", tipsFront = "quality_b2", back = "02", effect = "20020" },
    [3] = { front = "quality_f3", tipsFront = "quality_b3", back = "03", effect = "20020" },
    [4] = { front = "quality_f4", tipsFront = "quality_b4", back = "04", effect = "20020" },
    [5] = { front = "quality_f5", tipsFront = "quality_b5", back = "05", effect = "20019" },
    [6] = { front = "quality_f6", tipsFront = "quality_b6", back = "06", effect = "20019" },
}

function ItemManager.GetItemColorImg(quality)
    local colorImgData = Quality_Convert_ColorImg[quality]
    return colorImgData.front, colorImgData.back
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

function ItemManager:GetItem(parent, itemInfo, defaultShow)
	local item = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
	if not item then
		item = CommonItem.New()
	end
	item:LoadItem(parent, itemInfo, defaultShow)
	return item
end

function ItemManager:PushItemToPool(item)
	item:Reset()
	PoolManager.Instance:Push(PoolType.class, "CommonItem", item)
end

function ItemManager:ShowItemTipsPanel(itemInfo)
	if itemInfo == nil then
		LogError("展示道具信息为空")
		return
	end
	local itemType = ItemConfig.GetItemType(itemInfo.template_id)
	if itemType == BagEnum.BagType.Partner and itemInfo.unique_id then
		PanelManager.Instance:OpenPanel(PartnerTipsPanel, {unique_id = itemInfo.unique_id})
	else
		local itemTipsPanel = PanelManager.Instance:OpenPanel(ItemTipsPanel)
		itemTipsPanel:SetItemInfo(itemInfo)
	end
end