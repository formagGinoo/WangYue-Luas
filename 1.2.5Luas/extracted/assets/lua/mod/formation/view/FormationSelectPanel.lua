FormationSelectPanel = BaseClass("FormationSelectPanel", BasePanel)

local Idx2Location = {
	[1] = TI18N("首发"),
	[2] = TI18N("并肩助战"),
	[3] = TI18N("并肩助战"),
}

function FormationSelectPanel:__init(main)
	self:SetAsset("Prefabs/UI/Formation/FormationSelectPanel.prefab")

	self.main = main

	self.roleIdList = nil
	self.curSelectedRoleIdList = {}
	self.itemObjList = {}
	self.selectedList = {}

	self.selectedSortElement = nil
	self.selectedSortType = nil
	self.sortItemList = {}
end

function FormationSelectPanel:__BindEvent()
end

function FormationSelectPanel:__BindListener()
	self.Back_btn.onClick:AddListener(self:ToFunc("OnBack"))
	self.Home_btn.onClick:AddListener(self:ToFunc("OnHome"))
	self.ChangeBtn_btn.onClick:AddListener(self:ToFunc("OnGo"))
	self.DetailBtn_btn.onClick:AddListener(self:ToFunc("OnShowRoleDetail"))
	self.SortTypeBtn_btn.onClick:AddListener(function() self:OnClickSortGroup(FormationConfig.Sort.Type) end)
	self.SortElementBtn_btn.onClick:AddListener(function() self:OnClickSortGroup(FormationConfig.Sort.Element) end)
end

function FormationSelectPanel:__CacheObject()
	self.RoleItemGrid_recycelList:SetLuaCallBack(self:ToFunc("OnScroll"))
end

function FormationSelectPanel:__Create()
	--TODO:后续这里改成所有角色数量
	self.RoleItemGrid_recycelList:SetCellNum(20)
	
	self.modelRtView = ModelRtView.New(self, self.RoleModel_rimg, true)
	self.modelRtView:SetCameraPosition(-0.07, 0.86, 1.97)
	
	self.sortItemList[FormationConfig.SortElement] = {}
	for i = 1, #FormationConfig.SortElement do
		local item = self:CreateBaseSortItem(self.SortElementGroup.transform, FormationConfig.SortElement[i], FormationConfig.Sort.Element)
		item.element = i
		self.sortItemList[FormationConfig.SortElement][i] = item
	end
	
	self.sortItemList[FormationConfig.SortType] = {}
	for i = 1, #FormationConfig.SortType do
		local item = self:CreateBaseSortItem(self.SortTypeGroup.transform, FormationConfig.SortType[i], FormationConfig.Sort.Type)
		item.type = i
		self.sortItemList[FormationConfig.SortType][i] = item
	end
end

function FormationSelectPanel:__Hide()
	if self.modelRtView then
		self.modelRtView:Hide()
	end

	for i = 1, FormationConfig.MaxRoleNum do
		local item = self:_GetItemById(self.curSelectedRoleIdList[i])
		if item then
			item:SetSelect(false)
			item:SetTag(false)
		end
	end
	self.curSelectedRoleIdList = {}

	self.locIndex = nil
	self.selectedList = {}
	
	self.selectedSortElement = nil
	self.selectedSortType = nil
end

function FormationSelectPanel:__delete()
	for _, v in pairs(self.itemObjList) do
		v:Recycle()
	end
	
	if self.modelRtView then
		self.modelRtView:DeleteMe()
	end
end

function FormationSelectPanel:__Show()
	self.selectedList = UtilsBase.copytab(self.args[1])
	self.locIndex = self.args[2]
	self.curFormationId = self.args[3]
	
	if self.locIndex then
		self:SetSortCmpVisible(true)
		self.SortElementGroup:SetActive(false)
		self.SortTypeGroup:SetActive(false)
	else
		self:SetSortCmpVisible(false)
	end
	
	self:OnClickSortItem(self.sortItemList[FormationConfig.SortElement][1], FormationConfig.Sort.Element)
	self:OnClickSortItem(self.sortItemList[FormationConfig.SortType][1], FormationConfig.Sort.Type)
end

function FormationSelectPanel:_GetRoleIdList()
	if not self.roleIdList then
		self.roleIdList = mod.RoleCtrl:GetRoleIdList()
	end
	return self.roleIdList
end

function FormationSelectPanel:_GetItemById(roleId)
	for i = 1, #self.itemObjList do
		local item = self.itemObjList[i]
		if item.roleId == roleId then
			return item
		end
	end
end

local ChangeText, AddText, SaveText, delText = TI18N("替换"), TI18N("加入"), TI18N("保存"), TI18N("换下")
function FormationSelectPanel:InitRoleGrid()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
	
	local roleIdList = self:_GetRoleIdList()
	for i = 1, #roleIdList do
		local item = self:_GetItemById(roleIdList[i])
		if item then
			self:UpdateTag(item, false)
		end
	end

	if self.locIndex then
		if self.selectedList[self.locIndex] then
			self:OnSelectRole(self.selectedList[self.locIndex])
		else
			self.RoleModel:SetActive(false)
			self:UpdateRoleInfo(false)
		end

		self:SetRoleInfoVisible(true)
		self.LocationText_txt.text = Idx2Location[self.locIndex]
	else
		for k, v in pairs(self.selectedList) do
			self:InitMultipleSelection(k, self:_GetItemById(v))
		end

		self.Info:SetActive(true)
		self.Empty:SetActive(false)
		self:SetRoleInfoVisible(false)
	end

	self:RefreshBtnText()
end

function FormationSelectPanel:RefreshBtnText()
	if self.locIndex then
		local isSame = self.selectedList[self.locIndex] ~= nil and self.curSelectedRoleIdList[self.locIndex] ~= nil and self.selectedList[self.locIndex] == self.curSelectedRoleIdList[self.locIndex]
		self.ChangeBtnText_txt.text = self.selectedList[self.locIndex] ~= nil and (isSame and delText or ChangeText) or AddText
	else
		self.ChangeBtnText_txt.text = SaveText
	end
end

function FormationSelectPanel:CreateBaseSortItem(parent, text, sortType)
	local sortItem = {}
	sortItem.gameObject = GameObject.Instantiate(self.SortItem)
	sortItem.transform = sortItem.gameObject.transform
	sortItem.transform:SetParent(parent)
	sortItem.transform.localScale = Vector3(1, 1, 1)
	sortItem.gameObject:SetActive(true)
	UtilsUI.GetContainerObject(sortItem.transform, sortItem)
	
	sortItem.SortItemText_txt.text = text
	sortItem.SortItemText_txt.color = Color(1, 1, 1)
	sortItem.Tick:SetActive(false)
	sortItem.SortItemBtn_btn.onClick:AddListener(function() self:OnClickSortItem(sortItem, sortType) end)
	
	return sortItem
end

--TODO：目前只开放了单选时的分类排序（多选逻辑没调完），分类排序还没有明确的规则，策划说demo期还不需要，后续完善
function FormationSelectPanel:SetSortCmpVisible(visible)
	self.SortElement:SetActive(visible)
	self.SortType:SetActive(visible)
	self.UpDownBtn:SetActive(visible)
end

function FormationSelectPanel:SetRoleInfoVisible(visible)
	self.RoleInfo:SetActive(visible)
	self.DetailBtn:SetActive(visible)
	self.RoleModel:SetActive(visible)
end

function FormationSelectPanel:UpdateRoleInfo(enable, name, level)
	self.Info:SetActive(enable)
	self.Empty:SetActive(not enable)

	if enable and name then
		self.RoleName_txt.text = name
		self.RoleLevelText_txt.text = tostring(level)
	end
end

function FormationSelectPanel:OnScroll(index, obj)
	local roleIdList = self:_GetRoleIdList()
	local roleId = roleIdList[index]
	
	local callback = function()
		self:OnSelectRole(roleId)
	end
	
	if self.itemObjList[index] then
		self.itemObjList[index]:Reload(obj, roleId, callback)
	else
		local item = RoleItem.Get(obj, roleId, callback)
		self.itemObjList[index] = item
	end
	self:UpdateTag(self.itemObjList[index], false)
end

function FormationSelectPanel:OnSelectRole(roleId)
	local item = self:_GetItemById(roleId)
	if not item or not item.unlock then
		return
	end

	if self.locIndex then
		self:DoSingleSelectionLogic(item)
	else
		self:DoMultipleSelectionLogic(item)
	end
end

function FormationSelectPanel:DoSingleSelectionLogic(item)
	local lastRoleId = self.curSelectedRoleIdList[self.locIndex]
	if lastRoleId then
		if item.roleId == lastRoleId then
			item:SetSelect(true)
			self:UpdateTag(item, true, self.locIndex)
			return
		end

		local lastItem = self:_GetItemById(lastRoleId)
		if lastItem then
			lastItem:SetSelect(false)
			self:UpdateTag(lastItem, false, self.locIndex)
		end
	end

	item:SetSelect(true)
	self:UpdateTag(item, true, self.locIndex)
	self:UpdateRoleInfo(true, item.base.name, item.data.lev)
	self.curSelectedRoleIdList[self.locIndex] = item.roleId

	self:RefreshBtnText()

	if self.modelRtView then
		self.RoleModel:SetActive(true)
		self.modelRtView:ShowHero(item.data.id)
		self.modelRtView:Show()
	end
end

function FormationSelectPanel:InitMultipleSelection(locIndex, item)
	if item then
		item:SetSelect(true)
		self:UpdateTag(item, true, locIndex)
		self.curSelectedRoleIdList[locIndex] = item.roleId
	end
end

function FormationSelectPanel:DoMultipleSelectionLogic(item)
	for i = 1, FormationConfig.MaxRoleNum do
		local roleId = self.curSelectedRoleIdList[i]
		if roleId then
			local selectedItem = self:_GetItemById(roleId)
			if selectedItem and selectedItem.roleId == item.roleId then
				item:SetSelect(false)
				item:SetTag(false)
				self.curSelectedRoleIdList[i] = nil
				return
			end
		end
	end
	
	for i = 1, FormationConfig.MaxRoleNum do
		local roleId = self.curSelectedRoleIdList[i]
		if not roleId then
			item:SetSelect(true)
			self:UpdateTag(item, true, i)
			self.curSelectedRoleIdList[i] = item.roleId
			return
		end
	end
end

local CtrlRoleColor, AssistColor = Color(243 / 255, 223 / 255, 197 / 255), Color(1, 1, 1)
local CtrlRoleText, AssistText = TI18N("首发"), TI18N("助战")
function FormationSelectPanel:UpdateTag(item, enable, locIndex)
	if enable then
		local text, color = CtrlRoleText, CtrlRoleColor
		if locIndex and locIndex ~= 1 then
			text, color = AssistText, AssistColor
		end
		item:SetTag(true, text, color)
	else
		for k, v in pairs(self.selectedList) do
			if v == item.roleId then
				if locIndex and k == locIndex then
					break
				end
				local text, color = CtrlRoleText, CtrlRoleColor
				if k ~= 1 then
					text, color = AssistText, AssistColor
				end
				item:SetTag(true, text, color)
				return
			end
		end
		item:SetTag(false)
	end
end

function FormationSelectPanel:UpdateAfterSort(element)
	if element == 1 then
		self.roleIdList = mod.RoleCtrl:GetRoleIdList()
	else
		self.roleIdList = mod.RoleCtrl:GetRoleIdListByElement(element)
	end
	
	for i = 1, FormationConfig.MaxRoleNum do
		local item = self:_GetItemById(self.curSelectedRoleIdList[i])
		if item then
			item:SetSelect(false)
			item:SetTag(false)
		end
	end
	self.curSelectedRoleIdList = {}
	
	--TODO:后续这里改成所有角色数量，刷新可改用直接操作itemobjList，这样就是同步的
	self.RoleItemGrid_recycelList:SetCellNum(20)
	
	--间隔0.1s初始化，因为格子创建是异步的，如果直接操作，可能格子还没生成出来
	--self:InitRoleGrid()
	self.timer = LuaTimerManager.Instance:AddTimer(1, 0.1, self:ToFunc("InitRoleGrid"))
end

function FormationSelectPanel:OnClickSortGroup(sortType)
	if sortType == FormationConfig.Sort.Element then
		self.SortElementGroup:SetActive(not self.SortElementGroup.activeInHierarchy)
		self.SortTypeGroup:SetActive(false)
	elseif sortType ==FormationConfig.Sort.Type then
		self.SortTypeGroup:SetActive(not self.SortTypeGroup.activeInHierarchy)
		self.SortElementGroup:SetActive(false)
	end
end

local selectedSortItemColor = Color(84 / 255, 254 / 255, 218 / 255)
function FormationSelectPanel:OnClickSortItem(item, sortType)
	self.SortElementGroup:SetActive(false)
	self.SortTypeGroup:SetActive(false)
	
	if sortType == FormationConfig.Sort.Element then
		if self.selectedSortElement then
			if self.selectedSortElement.element == item.element then
				return 
			end
			
			self.selectedSortElement.Tick:SetActive(false)
			self.selectedSortElement.SortItemText_txt.color = Color(1, 1, 1)
		end
		self.selectedSortElement = item
		self.SortElementText_txt.text = item.SortItemText_txt.text
		
		self:UpdateAfterSort(item.element)
	elseif sortType ==FormationConfig.Sort.Type then
		if self.selectedSortType then
			if self.selectedSortType.type == item.type then
				return
			end
			
			self.selectedSortType.Tick:SetActive(false)
			self.selectedSortType.SortItemText_txt.color = Color(1, 1, 1)
		end
		self.selectedSortType = item
		self.SortTypeText_txt.text = item.SortItemText_txt.text
		
		--TODO：类型排序
	end
	
	item.Tick:SetActive(true)
	item.SortItemText_txt.color = selectedSortItemColor
end

-- TODO 跳转有问题
function FormationSelectPanel:OnShowRoleDetail()
	if self.locIndex and self.curSelectedRoleIdList[self.locIndex] then
		WindowManager.Instance:OpenWindow(RoleMainWindow, self.curSelectedRoleIdList[self.locIndex])
	end
end

-- todo 可能需要修改
function FormationSelectPanel:OnGo()
	local updateList = {}
	if self.locIndex and self.curSelectedRoleIdList[self.locIndex] then
		if self.locIndex then
			for i = 1, #self.selectedList do
				updateList[i] = self.selectedList[i]
			end

			local isSame = self.selectedList[self.locIndex] == self.curSelectedRoleIdList[self.locIndex]
			if isSame then
				table.remove(updateList, self.locIndex)
			else
				if updateList[self.locIndex] then
					updateList[self.locIndex] = self.curSelectedRoleIdList[self.locIndex]
				else
					table.insert(updateList, self.curSelectedRoleIdList[self.locIndex])
				end
			end
		end
	else
		for i = 1, #self.curSelectedRoleIdList do
			table.insert(updateList, self.curSelectedRoleIdList[i])
		end
	end

	mod.FormationCtrl:ReqFormationUpdate(self.curFormationId, updateList)
	self:OnHide()
end

function FormationSelectPanel:OnBack()
	self:OnHide()
end

function FormationSelectPanel:OnHome()
	WindowManager.Instance:CloseAllWindow()
end

function FormationSelectPanel:OnHide()
	self.main:SetWindowVisible(true)
	self:Hide()
end