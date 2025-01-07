ItemMsgBox = BaseClass("ItemMsgBox", BaseView)

local defaultTips = TI18N("获得奖励")

function ItemMsgBox:__init(msgBoxType)
	self:SetAsset("Prefabs/UI/Common/ItemMsgBox.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)

	self.msgBoxType = msgBoxType
	self.itemList = {}
	self.itemObjList = {}
	self.tipsContent = nil
end

function ItemMsgBox:__delete()
	if self.blurBack then
        self.blurBack:Destroy()
    end
end

function ItemMsgBox:__CacheObject()
end

function ItemMsgBox:__ShowComplete()
	-- if not self.blurBack then
    --     self.blurBack = BlurBack.New(self)
    -- end
	
	-- self:SetActive(false)
	-- self.blurBack:Show()
end

function ItemMsgBox:__Show()
	self.TipsText_txt.text = self.tipsContent
	for _, v in pairs(self.itemList) do
		
		local itemInfo = {template_id = v[1], count = v[2], can_lock = false, nameShow = true, nameColor = {0.4, 0.4, 0.4, 1}}
		local item = ItemManager.Instance:GetItem(self.RewardsGroup, itemInfo)
		table.insert(self.itemObjList, item)
	end
end

function ItemMsgBox:__BindListener()
	self.Back_btn.onClick:AddListener(self:ToFunc("OnClickBackBtn"))
end

function ItemMsgBox:__Hide()
	for i = 1, #self.itemObjList do
		ItemManager.Instance:PushItemToPool(self.itemObjList[i])
	end
	self.itemList = {}
	self.itemObjList = {}
	self.tipsContent = nil
	
	if self.blurBack then
        self.blurBack:Hide()
    end
end

function ItemMsgBox:ResetView(itemList, tips)
	self.itemList = itemList
	self.tipsContent = tips or defaultTips
end

function ItemMsgBox:OnClickBackBtn()
	MsgBoxManager.Instance:HideMsgBox(self)
end