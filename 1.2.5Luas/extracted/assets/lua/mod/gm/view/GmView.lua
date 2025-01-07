GmView = BaseClass("GmView", BaseView)

local defaultTips = "选择指令填入模板"
local noParamTips = "无参数"

function GmView:__init()
	self:SetAsset("Prefabs/UI/Gm/GmView.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
	
	self.selectedData = {}
	self.selectedTag = 0
end

function GmView:__delete()
	EventMgr.Instance:RemoveListener(EventName.GetGMData, self:ToFunc("OnGetGmData"))
end

function GmView:__CacheObject()
	self.commandItem = self.CommandList.transform:Find("CommandItem")
	self.historyItem = self.HistoryList.transform:Find("HistoryItem")
	
	self.ParamInput1_input = self.ParamInput1:GetComponent(TMP_InputField)
	self.ParamInput2_input = self.ParamInput2:GetComponent(TMP_InputField)
	self.ParamInput3_input = self.ParamInput3:GetComponent(TMP_InputField)
	self.ParamInput4_input = self.ParamInput4:GetComponent(TMP_InputField)
end

function GmView:__BindListener()
	self.DoBtn_btn.onClick:AddListener(self:ToFunc("DoCommand"))
	self.ResetBtn_btn.onClick:AddListener(self:ToFunc("ResetCommand"))
	self.ClearBtn_btn.onClick:AddListener(self:ToFunc("ClearCommand"))
	self.CloseBtn_btn.onClick:AddListener(self:ToFunc("CloseWindow"))
	
	self.ServerBtn_btn.onClick:AddListener(self:ToFunc("SelectServerTag"))
	self.ClientBtn_btn.onClick:AddListener(self:ToFunc("SelectClientTag"))

	EventMgr.Instance:AddListener(EventName.GetGMData, self:ToFunc("OnGetGmData"))
end

function GmView:__Create()
	self.CommandLayout = LuaBoxLayout.New(self.CommandContent, {axis = BoxLayoutAxis.Y, cspacing = 0, scrollRect = self.CommandList_rect})
	self.ClientCommandLayout = LuaBoxLayout.New(self.ClientCommandContent, {axis = BoxLayoutAxis.Y, cspacing = 0, scrollRect = self.ClientCommandList_rect})
	self.HistoryLayout = LuaBoxLayout.New(self.HistoryContent, {axis = BoxLayoutAxis.Y, cspacing = 0, scrollRect = self.HistoryList_rect})
	
	self:RefreshCommandList(2)
end

function GmView:__Show()
	if not self.isRequest then
		mod.GmCtrl:RequestGmList()
	end
	
	local to = 0
	if next(self.selectedData) then
		to = #self.selectedData.args_desc_list
		self.EmptyTips.transform:SetActive(to == 0)
		if to == 0 then
			self.EmptyTips_txt.text = noParamTips
		end
	else
		self.EmptyTips.transform:SetActive(true)
		self.EmptyTips_txt.text = defaultTips
	end
	
	for i = 4, 1, -1 do
		self["ParamInput"..i].transform:SetActive(i <= to)
	end
	
	self:SelectServerTag()
end

function GmView:OnGetGmData(data)
	self.isRequest = true
	self:RefreshCommandList(1)
end

function GmView:RefreshCommandList(tag)
	local data
	local layout
	if tag == 1 then
		data = mod.GmCtrl.serverGmData
		layout = self.CommandLayout
	elseif tag == 2 then
		data = mod.GmCtrl.clientGmData
		layout = self.ClientCommandLayout
	end
	
	for i = 1, #data do
		local command = data[i].gm_name
		local example = data[i].gm_desc
		local argsDescList = data[i].args_desc_list
		self:AddListItem(self.commandItem, data[i].gm_desc, layout, self.OnClickCommandItem, data[i])
	end
	
end

function GmView:AddListItem(itemPrefab, itemMsg, parent, callback, args)
	local item = GameObject.Instantiate(itemPrefab)
	local trans = item.transform
	UtilsUI.GetText(trans:Find("Text")).text = itemMsg
	local btn = trans:GetComponent(Button)
	btn.onClick:AddListener(function() callback(self, item, args) end)
	parent:AddCell(item)
end

function GmView:DoCommand()
	if next(self.selectedData) then
		local descList = self.selectedData.args_desc_list
		local historyText = self.selectedData.gm_desc
		local historyData = UtilsBase.copytab(self.selectedData)
		local args = {}
		for i = 1, #descList do
			local param = self["ParamInput"..i.."_input"].text
			if param == "" then
				MsgBoxManager.Instance:ShowTips("参数有误")
				return
			end
			table.insert(args, param)
			historyData.args_desc_list[i].args_input = param
			historyText = historyText.." "..param
		end
		
		mod.GmCtrl:ExecGmCommand(self.selectedTag == 2, self.selectedData.gm_name, args)
		self:AddListItem(self.historyItem, historyText, self.HistoryLayout, self.OnClickHistoryItem, historyData)
	end
end

function GmView:ResetCommand()
	if next(self.selectedData) then
		local descList = self.selectedData.args_desc_list
		for i = 1, #descList do
			self["ParamInput"..i.."_input"].text = descList[i].args_default
		end
	end
end

function GmView:ClearCommand()
	self.selectedData = {}
	self.EmptyTips.transform:SetActive(true)
	self.EmptyTips_txt.text = defaultTips
	self.ExampleTips_txt.text = ""
	local descList = self.selectedData.args_desc_list
	for i = 1, 4 do
		self["ParamInput"..i].transform:SetActive(false)
	end
end

function GmView:CloseWindow()
	GmManager.Instance:CloseGmPanel()
end

function GmView:OnClickCommandItem(item, args)
	self.selectedData = args
	
	self.ExampleTips_txt.text = self.selectedData.gm_desc
	
	local showParams = {false, false, false, false}
	local descList = self.selectedData.args_desc_list or {}
	for i = 1, #descList do
		showParams[i] = true
		self["ParamPlaceholder"..i.."_txt"].text = descList[i].args_desc
		self["ParamInput"..i.."_input"].text = descList[i].args_input and descList[i].args_input or descList[i].args_default
	end
	
	self.EmptyTips.transform:SetActive(#descList == 0)
	if #descList == 0 then
		self.EmptyTips_txt.text = noParamTips
	end
	
	for i = 1, 4 do
		self["ParamInput"..i].transform:SetActive(showParams[i])
	end
end

function GmView:OnClickHistoryItem(item, args)
	self:OnClickCommandItem(nil, args)
end

function GmView:SelectServerTag()
	if self.selectedTag == 1 then return end
	self.selectedTag = 1
	self.ServerBtn_img.color = Color(0, 1, 0)
	self.ClientBtn_img.color = Color(1, 1, 1)
	self.CommandList:SetActive(true)
	self.ClientCommandList:SetActive(false)
	
	self:OnClickCommandItem(nil, {})
end

function GmView:SelectClientTag()
	if self.selectedTag == 2 then return end
	self.selectedTag = 2
	self.ServerBtn_img.color = Color(1, 1, 1)
	self.ClientBtn_img.color = Color(0, 1, 0)
	self.CommandList:SetActive(false)
	self.ClientCommandList:SetActive(true)
	
	self:OnClickCommandItem(nil, {})
end