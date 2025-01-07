DebugDetailPanel = BaseClass("DebugDetailPanel",BasePanel)

local ItemKind = {
	Group = 1 << 0,
	Sub = 1 << 1,
	Quick = 1 << 2	
}

local RowSize = 67
local ContentMinSize = 640
local QuickMinSize = 270

function DebugDetailPanel:__init()
	self:SetAsset("Prefabs/UI/FightDebug/DebugDetailPanel.prefab")
	
	self.tag = -1
	
	self.itemList = {}
	self.itemCachePool = {}
end

function DebugDetailPanel:__delete()
end

function DebugDetailPanel:__Create()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
	
	self.ParamInput1_input = self.ParamInput1:GetComponent(TMP_InputField)
	self.ParamInput2_input = self.ParamInput2:GetComponent(TMP_InputField)
	self.ParamInput3_input = self.ParamInput3:GetComponent(TMP_InputField)
end

function DebugDetailPanel:__BindListener()
	self.BackBtn_btn.onClick:AddListener(function()
			PanelManager.Instance:ClosePanel(DebugDetailPanel)
		end)
	
	for i = 1, 3 do
		UtilsUI.SetActive(self["TagSelected"..i], false)
		self["TagBtn"..i.."_btn"].onClick:AddListener(function()
				self:SelectTag(i)
			end)
	end
	
	self.QuickSelectBtn_btn.onClick:AddListener(self:ToFunc("AddQuick"))
	
	self.GroupToppingBtn_btn.onClick:AddListener(function() self:GroupTopping(true) end)
	self.SubToppingBtn_btn.onClick:AddListener(function() self:SubTopping(true) end)
	
	self.CancelGroupToppingBtn_btn.onClick:AddListener(function() self:GroupTopping(false) end)
	self.CancelSubToppingBtn_btn.onClick:AddListener(function() self:SubTopping(false) end)
end

function DebugDetailPanel:__Show()
	self.model = self.args
	self.canvas.sortingOrder = 10000
	self:SelectTag(self.model:GetLastSelectedTag())
	self:RefreshQuick()
end

function DebugDetailPanel:__Hide()
end

function DebugDetailPanel:Update()
end

function DebugDetailPanel:SelectTag(tag)
	if tag == self.tag then
		return
	end
	
	if self.tag ~= -1 then
		UtilsUI.SetActive(self["TagSelected"..self.tag], false)
	end
	UtilsUI.SetActive(self["TagSelected"..tag], true)
	
	self.curSelectedGroup = nil
	self.curSelectedSub = nil
	self.SelectedText_txt.text = " "
	
	self.tag = tag
	self.model:SetLastSelectedTag(tag)
	
	self.config = self.model:GetDebugConfig(tag)
	self:RefreshGroup()
	self:CacheItemByKind(ItemKind.Sub)
	self:UpdateParamConfig()
end

function DebugDetailPanel:UpdateParamConfig()
	if not self.curSelectedSub then
		UtilsUI.SetActive(self.ParamConfig, false)
		return 
	end
	
	local config = DebugConfig.GetDataConfig(self.tag, self.curSelectedSub.id)
	if not config then
		UtilsUI.SetActive(self.ParamConfig, false)
		return 
	end
	
	if config.param1 == "" and config.param2 == "" and config.param3 == "" then
		UtilsUI.SetActive(self.ParamConfig, false)
		return
	end
	
	UtilsUI.SetActive(self.ParamConfig, true)
	UtilsUI.SetActive(self.ParamInput1, config.param_num >= 1)
	UtilsUI.SetActive(self.ParamInput2, config.param_num >= 2)
	UtilsUI.SetActive(self.ParamInput3, config.param_num >= 3)
	
	self.ParamInput1_input.text = config.param1
	self.ParamInput2_input.text = config.param2
	self.ParamInput3_input.text = config.param3
	
	self.ConfirmBtn_btn.onClick:RemoveAllListeners()
	self.ConfirmBtn_btn.onClick:AddListener(function()
			local param1 = self.ParamInput1_input.text
			local param2 = self.ParamInput2_input.text
			local param3 = self.ParamInput3_input.text
			MsgBoxManager.Instance:ShowTips(string.format("执行[%s]", config.id_desc), 0.5)
			DebugConfig.CallFunc(self.tag, config.gm_func, param1, param2, param3)
		end)
end

function DebugDetailPanel:OnSelectItem(item, refresh)
	local curSelected = self.curSelectedGroup
	if item.kind == ItemKind.Sub then
		curSelected = self.curSelectedSub
	end
	
	if curSelected == item then
		return
	end

	if curSelected then
		UtilsUI.SetActive(curSelected.Select, false)
	end
	UtilsUI.SetActive(item.Select, true)

	if item.kind == ItemKind.Group then
		self.curSelectedGroup = item
		
		if not self.curSelectedSub or refresh then
			if refresh then
				self.curSelectedSub = nil
				self:UpdateParamConfig()
			end
			self:RefreshSub()
		end
	else
		self.curSelectedSub = item
		self:UpdateParamConfig()
	end
	
	local str = self.config[self.curSelectedGroup.id].desc
	if self.curSelectedSub then
		local config = DebugConfig.GetDataConfig(self.tag, self.curSelectedSub.id)
		str = str.."["..config.id_desc.."]"
	end
	self.SelectedText_txt.text = str
end

function DebugDetailPanel:GetItem(id, kind)
	local item = table.remove(self.itemCachePool)
	if not item then
		item = {}
		item.gameObject = GameObject.Instantiate(self.Item)
		UtilsUI.SetActive(item.gameObject, true)
		
		item.transform = item.gameObject.transform
		UtilsUI.GetContainerObject(item.transform, item)
	end
	
	local parent = self.GroupContent.transform
	if kind == ItemKind.Sub then
		parent = self.SubContent.transform
	elseif kind == ItemKind.Quick then
		parent = self.QuickContent.transform
	end
	
	item.id = id
	item.kind = kind
	item.tag = nil
	item.transform:SetParent(parent)
	item.transform:ResetAttr()

	return item
end

function DebugDetailPanel:GetParamStr(paramNum, param1, param2, param3)
	if not paramNum or paramNum == 0 then
		return ""
	end
	
	if param1 == "" and param2 == "" and param3 == "" then
		return ""
	end
	
	local str = "["
	if param1 ~= "" then
		str = str..param1..","
	end
	
	if param2 ~= "" then
		str = str..param2..","
	end
	
	if param3 ~= "" then
		str = str..param3..","
	end
	
	str = str.."]"
	return str
end

function DebugDetailPanel:UpdateTipsText(item, kind, relateUpdate)
	if kind == ItemKind.Group then
		local top = self.config[item.id].top
		UtilsUI.SetActive(item.TipText, top)
		if top then
			item.TipText_txt.text = "top"
		end
	elseif kind == ItemKind.Sub then
		local config = self.config[self.curSelectedGroup.id][item.id]
		if not config then
			UtilsUI.SetActive(item.TipText, false)
		else
			local top = config.top
			local quick = self.model:InCustomQuickList(self.tag, item.id)
			if not top and not quick then
				UtilsUI.SetActive(item.TipText, false)
			else
				UtilsUI.SetActive(item.TipText, true)
				local str = top and "top" or ""
				str = (top and quick) and str.." & " or str
				str = quick and str.."quick" or str
				
				item.TipText_txt.text = str
			end
		end
	elseif kind == ItemKind.Quick then
		UtilsUI.SetActive(item.TipText, false)
		if relateUpdate and item.tag and item.tag == self.tag then
			for i = 1, #self.itemList do
				local oItem = self.itemList[i]
				if oItem.kind == ItemKind.Sub and oItem.id == item.id then
					self:UpdateTipsText(oItem, oItem.kind)
					break
				end
			end
		end
	end
end

function DebugDetailPanel:AddItem(tag, id, desc, kind, func, paramNum, param1, param2, param3)
	local item = self:GetItem(id, kind)
	
	local txt = kind == ItemKind.Group and item.GroupDesc_txt or item.SubDesc_txt
	txt.text = desc --..self:GetParamStr(paramNum, param1, param2, param3)
	
	UtilsUI.SetActive(item.Confirm, kind ~= ItemKind.Group)
	UtilsUI.SetActive(item.SubDesc, kind ~= ItemKind.Group)
	UtilsUI.SetActive(item.GroupDesc, kind == ItemKind.Group)
	UtilsUI.SetActive(item.Select, false)
	
	item.SelectBtn_btn.onClick:RemoveAllListeners()
	if kind ~= ItemKind.Quick then
		item.SelectBtn_btn.onClick:AddListener(function()
				self:OnSelectItem(item, true)
			end)
	end
	
	item.ConfirmBtn_btn.onClick:RemoveAllListeners()
	if kind ~= ItemKind.Group then
		item.ConfirmBtn_btn.onClick:AddListener(function()
				if kind == ItemKind.Sub then
					MsgBoxManager.Instance:ShowTips(string.format("执行[%s]", desc), 0.5)
					DebugConfig.CallFunc(tag, func, param1, param2, param3)
				elseif kind == ItemKind.Quick then
					self:RemoveQuickItem(item)
				end
			end)
		
		local btnText = kind == ItemKind.Sub and "执行" or "移除"
		item.ConfirmText_txt.text = btnText
	end

	self:UpdateTipsText(item, kind)
	table.insert(self.itemList, item)
	
	return item
end

local IdxList = {}
function DebugDetailPanel:CacheItemByKind(kind)
	TableUtils.ClearTable(IdxList)
	for i = 1, #self.itemList do
		local v = self.itemList[i]
		if v.kind & kind ~= 0 then
			v.transform:SetParent(self.CachePool.transform)
			table.insert(self.itemCachePool, v)
			table.insert(IdxList, i)
		end
	end
	
	for i = #IdxList, 1, -1 do
		table.remove(self.itemList, IdxList[i])
	end
end

function DebugDetailPanel:CacheItem(item)
	for i = 1, #self.itemList do
		local v = self.itemList[i]
		if item == v  then
			item.transform:SetParent(self.CachePool.transform)
			table.insert(self.itemCachePool, item)
			table.remove(self.itemList, i)
			return
		end
	end
end

function DebugDetailPanel:RefreshGroup()
	self:CacheItemByKind(ItemKind.Group)
	
	local curSelectedId = self.curSelectedGroup and self.curSelectedGroup.id
	self.curSelectedGroup = nil
	
	local count = 0
	for k, v in pairs(self.config) do
		if tonumber(k) and v.top then
			local desc = v.desc
			self:AddItem(self.tag, k, desc, ItemKind.Group)
			count = count + 1
		end
	end
	
	for k, v in pairs(self.config) do
		if tonumber(k) and not v.top then
			local desc = v.desc
			self:AddItem(self.tag, k, desc, ItemKind.Group)
			count = count + 1
		end
	end
	
	local row = math.ceil(count / 2)
	local contentSize = math.max(row * RowSize, ContentMinSize)
	self.GroupContent_rect.sizeDelta = Vector2(0, contentSize)
	
	if curSelectedId then
		for i = 1, #self.itemList do
			local item = self.itemList[i]
			if item.id == curSelectedId and item.kind == ItemKind.Group then
				self:OnSelectItem(item)
				break
			end
		end
	end
end

function DebugDetailPanel:RefreshSub()
	self:CacheItemByKind(ItemKind.Sub)
	if not self.curSelectedGroup then
		return 
	end
	
	local curSelectedId = self.curSelectedSub and self.curSelectedSub.id
	self.curSelectedSub = nil
	
	local count = 0
	local config = self.config[self.curSelectedGroup.id]
	for k, v in pairs(config) do
		if tonumber(k) and v.top then
			self:AddItem(self.tag, k, v.config.id_desc, ItemKind.Sub, 
				v.config.gm_func, v.config.param_num, v.config.param1, v.config.param2, v.config.param3)
			count = count + 1
		end
	end
	
	for k, v in pairs(config) do
		if tonumber(k) and not v.top then
			self:AddItem(self.tag, k, v.config.id_desc, ItemKind.Sub,
				v.config.gm_func, v.config.param_num, v.config.param1, v.config.param2, v.config.param3)
			count = count + 1
		end
	end
	
	local row = math.ceil(count / 2)
	local contentSize = math.max(row * RowSize, ContentMinSize)
	self.SubContent_rect.sizeDelta = Vector2(0, contentSize)
	
	if curSelectedId then
		for i = 1, #self.itemList do
			local item = self.itemList[i]
			if item.id == curSelectedId and item.kind == ItemKind.Sub then
				self:OnSelectItem(item)
				break
			end
		end
	end
end

function DebugDetailPanel:RefreshQuick()
	local quickConfig = self.model:GetQuickConfig()
	if not quickConfig or not next(quickConfig) then
		return 
	end
	
	self:CacheItemByKind(ItemKind.Quick)
	
	local count = 0
	for tag, idList in pairs(quickConfig) do
		for _, v in pairs(idList) do
			local config = DebugConfig.GetDataConfig(tag, v)
			local item = self:AddItem(tag, config.id, config.id_desc, ItemKind.Quick)
			item.tag = tag
			
			count = count + 1
		end
	end
	
	local row = math.ceil(count / 2)
	local contentSize = math.max(row * RowSize, QuickMinSize)
	self.QuickContent_rect.sizeDelta = Vector2(0, contentSize)
end

function DebugDetailPanel:AddQuick()
	if not self.curSelectedGroup or not self.curSelectedSub then
		return
	end
	
	if not self.model:UpdateQuickList(self.tag, self.curSelectedSub.id, true) then
		return 
	end
	
	local config = DebugConfig.GetDataConfig(self.tag, self.curSelectedSub.id)
	local item = self:AddItem(self.tag, self.curSelectedSub.id, config.id_desc, ItemKind.Quick)
	item.tag = self.tag
	
	self:UpdateTipsText(item, ItemKind.Quick, true)
	
	local count = 0
	local quickConfig = self.model:GetQuickConfig()
	for tag, idList in pairs(quickConfig) do
		for _, v in pairs(idList) do
			count = count + 1
		end
	end
	
	local row = math.ceil(count / 2)
	local contentSize = math.max(row * RowSize, QuickMinSize)
	self.QuickContent_rect.sizeDelta = Vector2(0, contentSize)
end

function DebugDetailPanel:RemoveQuickItem(item)
	self.model:UpdateQuickList(item.tag, item.id, false)
	self:CacheItem(item)
	
	self:UpdateTipsText(item, ItemKind.Quick, true)
	
	local count = 0
	local quickConfig = self.model:GetQuickConfig()
	for tag, idList in pairs(quickConfig) do
		for _, v in pairs(idList) do
			count = count + 1
		end
	end

	local row = math.ceil(count / 2)
	local contentSize = math.max(row * RowSize, QuickMinSize)
	self.QuickContent_rect.sizeDelta = Vector2(0, contentSize)
end

function DebugDetailPanel:GroupTopping(set)
	if not self.curSelectedGroup then
		return 
	end
	
	if not self.model:UpdateGroupToppingList(self.tag, self.curSelectedGroup.id, set) then
		return 
	end
	
	self.config = self.model:GetDebugConfig(self.tag)
	self:RefreshGroup()
end

function DebugDetailPanel:SubTopping(set)
	if not self.curSelectedSub then
		return
	end

	if not self.model:UpdateSubToppingList(self.tag, self.curSelectedSub.id, set) then
		return 
	end
	
	self.config = self.model:GetDebugConfig(self.tag)
	self:RefreshSub()
end