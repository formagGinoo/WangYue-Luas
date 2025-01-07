SetViewPanel = BaseClass("SetViewPanel", BasePanel)

function SetViewPanel:__init()
	self.itemObjList = {}
	self.dropItemList = {}
    self:SetAsset("Prefabs/UI/GameSet/SetViewPanel.prefab")
end

function SetViewPanel:__Create()

end

function SetViewPanel:__Show()

end

function SetViewPanel:__BindListener()
    self.dropGround_btn.onClick:AddListener(self:ToFunc("OnHideDropDown"))
end

function SetViewPanel:__ShowComplete()
	self.dropItemParent = self.dropList.transform
    self:RefreshItemList()
end

function SetViewPanel:RefreshItemList()
	self.viewList = TableUtils.CopyTable(GameSetConfig.View)
    for i = 1, #self.viewList do 
    	if GameSetConfig.View[i].SaveKey == GameSetConfig.SaveKey.ViewAAType then
    		-- 根据不同的抗锯齿类型选择
    		local aaType = mod.GameSetCtrl:GetView(GameSetConfig.SaveKey.ViewAAType)
			table.insert(self.viewList, i + 1, GameSetConfig.AASet[aaType])
    	end
    end

    local listNum = #self.viewList
    self.SetList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.SetList_recyceList:SetCellNum(listNum)
end

function SetViewPanel:OnHideDropDown()
	self.dropDown:SetActive(false)
	self.dropGround:SetActive(false)
end

function SetViewPanel:RefreshItemCell(index, go)
    if not go then
        return
    end

	local itemObj
	local setInfo = self.viewList[index]
    if self.itemObjList[index] then
        itemObj = self.itemObjList[index].itemObj
    else
    	itemObj = UtilsUI.GetContainerObject(go)
    	local OnCallBack = function()
    		if self.dropDown.gameObject.activeSelf then
				self.dropDown:SetActive(false)
				self.dropGround:SetActive(false)
		        return
		    end

    		self:CreateDropDown(itemObj, self.viewList[index].SaveKey)
    	end

    	itemObj.btnKey_btn.onClick:AddListener(OnCallBack)
        self.itemObjList[index] = {}
        self.itemObjList[index].go = go
        self.itemObjList[index].itemObj = itemObj
    end

    itemObj.imgLine:SetActive(index ~= #self.viewList)
    itemObj.setName_txt.text = setInfo.SetName
    local value = mod.GameSetCtrl:GetView(setInfo.SaveKey)
    itemObj.setValue_txt.text = GameSetConfig.GetViewSetName(setInfo.SaveKey, value)	
end

function SetViewPanel:CreateDropDown(itemObj, saveKey)
	local value = mod.GameSetCtrl:GetView(saveKey)
	local curTxtValue = GameSetConfig.GetViewSetName(saveKey, value)
	local viewInfo = GameSetConfig.GetViewInfo(saveKey)
	
	
	local worldPos = itemObj.btnKey_rect.position
	local spPoint = ctx.UICamera:WorldToScreenPoint(worldPos)
	local spPoint2 = Vector2(spPoint.x, spPoint.y)
	local _, pos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.transform, spPoint2, ctx.UICamera)
	CustomUnityUtils.SetAnchoredPosition(self.dropDown_rect, 415, pos.y - 25)

	for k, v in pairs(self.dropItemList) do
		v.toggle.onValueChanged:RemoveAllListeners()
		self:PushUITmpObject("dropItem", v, self.transform)
	end
	self.dropSetValue = -100
	self.dropItemList = {}
	self.dropInit = false
    for k, v in ipairs(viewInfo.SetValues) do
        local objectInfo, new = self:PopUITmpObject("dropItem")
        objectInfo.dropUName_txt.text = v.name
    	objectInfo.dropSName_txt.text = v.name
		table.insert(self.dropItemList, objectInfo)
    	if new then
    		objectInfo.toggle = objectInfo.objectTransform:GetComponent(Toggle)
    	end

    	local isCurSelect = v.name == curTxtValue 
    	objectInfo.dropSName:SetActive(isCurSelect)
    	objectInfo.dropSMark:SetActive(isCurSelect)
    	objectInfo.dropUName:SetActive(not isCurSelect)
		if isCurSelect then
			self.dropSetValue = v.value
		end
		
        local OnToggle = function()
            self:OnSelect(itemObj, objectInfo, saveKey, v.value)
        end
        objectInfo.toggle.onValueChanged:AddListener(OnToggle)
		objectInfo.toggle.isOn = isCurSelect
        objectInfo.object.transform:SetParent(self.dropList.transform)
        objectInfo.object.transform.localScale = Vector3.one
        objectInfo.object:SetActive(true)
    end

    local sizeY = math.min(420, 20 + 50 * #viewInfo.SetValues)
    UnityUtils.SetSizeDelata(self.dropDown.transform, 361, sizeY)
	
	self.dropDown:SetActive(true)
	self.dropGround:SetActive(true)
	self.dropInit = true
end


function SetViewPanel:OnSelect(itemObj, objectInfo, saveKey, value)
	if not self.dropInit then
		return	
	end

	if objectInfo.toggle.isOn and self.dropSetValue ~= value then
		mod.GameSetCtrl:SetView(saveKey, value, true)
	 
	 	local strValue = GameSetConfig.GetViewSetName(saveKey, value)
	 	itemObj.setValue_txt.text = strValue

	 	if saveKey ~= GameSetConfig.SaveKey.ViewQualityLevel and 
	 		saveKey ~= GameSetConfig.SaveKey.ViewResolution then
	 		self.itemObjList[1].itemObj.setValue_txt.text = TI18N("自定义")
	 	end
		
		-- 品质等级和抗锯齿类型修改，刷新列表
		if saveKey == GameSetConfig.SaveKey.ViewQualityLevel or
			saveKey == GameSetConfig.SaveKey.ViewAAType then
			--local listNum = #self.viewList
			--for i = 1, listNum do
				--self:RefreshItemCell(i, self.itemObjList[i].go)
			--end
			self:RefreshItemList()
		end

	 	self.dropDown:SetActive(false)
	 	self.dropGround:SetActive(false)
	 end
end
