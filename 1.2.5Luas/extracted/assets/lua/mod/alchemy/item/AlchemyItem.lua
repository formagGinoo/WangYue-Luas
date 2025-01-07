AlchemyItem = BaseClass("AlchemyItem", Module)

function AlchemyItem:__init()

end

function AlchemyItem:__delete()
	
end

function AlchemyItem:InitAlchemyItem(object, AlchemyInfo, formulaInfo, parent, defaultShow)
	-- 获取对应的组件
	self.object = object
	self.parent = parent
	self.formulaInfo = formulaInfo
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	if defaultShow ~= nil then self.defaultShow = defaultShow end
	self.loadDone = true
	self.AlchemyInfo = AlchemyInfo
	self.object:SetActive(false)
	self:Show()
end

function AlchemyItem:Show()
	if not self.loadDone then 
        return 
    end
    if self.defaultShow then
		self.object:SetActive(true)
	end
	self.alreadyNum = 0
	self:InitCommonItem()
	self:UpdateItem()
end

function AlchemyItem:InitCommonItem()
	local commonObj = self.node.CommonItem
	self.commonItem = CommonItem.New()
	self.commonItem:InitItem(commonObj, self.AlchemyInfo)
	UtilsUI.SetActive(self.commonItem.node.Num, true)
	self:UpdateEffectLayer()
end

function AlchemyItem:UpdateItem()
	self.node.ClickBtn_btn.onClick:RemoveAllListeners()
	self:AddClickListener()
	self:UpdateImageState()
	self:SetItemElementType()
end

function AlchemyItem:UpdateImageState()
	if self.alreadyNum > 0 then
		UtilsUI.SetActive(self.node.HasItem, false)
		self.commonItem.node.Num_txt.text = string.format("已放：<color=%s>%s</color>", AlchemyConfig.TextColor.Yellow, self.alreadyNum)
	else
		UtilsUI.SetActive(self.node.HasItem, true)
		local itemCount = mod.BagCtrl:GetItemCountById(self.AlchemyInfo.id)
		if itemCount > 0 then
			self.commonItem.node.Num_txt.text = string.format("拥有：<color=%s>%s</color>", AlchemyConfig.TextColor.Yellow, itemCount)
		else
			self.commonItem.node.Num_txt.text = string.format("拥有：<color=%s>%s</color>", AlchemyConfig.TextColor.Red, itemCount)
		end
	end
end


function AlchemyItem:SetItemElementType()
	self.elementType = AlchemyConfig.GetEleItemtypeInfoById(self.AlchemyInfo.id)
	for i = 1, self.node.SelectEle.transform.childCount do
		UtilsUI.SetActive(self.node.SelectEle.transform:GetChild(i - 1), false)
	end
	UtilsUI.SetActive(self.node[self.elementType], true)
end

function AlchemyItem:SetItemNum(num)
	self.alreadyNum = num
	UtilsUI.SetActive(self.commonItem.node.Num, true)
	self:UpdateImageState()
end

function AlchemyItem:SetItemElementNum(num)
	self.node.SelectNum_txt.text = tostring(num)
end

function AlchemyItem:AddClickListener()
	self.node.ClickBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ClickBtn"))
end

function AlchemyItem:OnClick_ClickBtn()
	local window = WindowManager.Instance:GetWindow("AlchemyMainWindow")
	local alchemySmeltPanel = window:GetPanel(AlchemySmeltPanel)
	PanelManager.Instance:OpenPanel(AlchemySmeltSelectItemPanel, {formulaInfo = self.formulaInfo, alchemyItemsInfo = alchemySmeltPanel.alchemyItemsInfo})
end

function AlchemyItem:UpdateEffectLayer()
	local layer = WindowManager.Instance:GetCurOrderLayer()
    UtilsUI.SetEffectSortingOrder(self.node["22136"], layer + 11)
end

function AlchemyItem:UpdateEffectState(state)
	UtilsUI.SetActive(self.node["22136"], state)
end

function AlchemyItem:OnReset()
	
end