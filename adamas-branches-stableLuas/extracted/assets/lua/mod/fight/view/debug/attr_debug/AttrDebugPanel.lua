AttrDebugPanel = BaseClass("AttrDebugPanel",BaseView)

local SelectedColor = {
	[1] = Color(0, 1, 0),
	[2] = Color(0, 0, 1),
	[3] = Color(1, 0, 0),
}

function AttrDebugPanel:__init()
	self:SetAsset("Prefabs/UI/FightDebug/DebugAttrPanel.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)
	
	self.itemObjList = {}
	self.subItemObjList = {}
	self.curSelectedItemId = {}
	self.subPanel = nil
	
	self.scrollTag = 1
	self.textListByAttr = {}
end

function AttrDebugPanel:__Hide()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
	
	if self.subPanel then
		self.subPanel:OnClose()
	end
end

function AttrDebugPanel:__BindListener()
	self.CloseBtn_btn.onClick:RemoveAllListeners()
	self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClose"))
	
	for i = 1, 4 do
		self["TagBtn"..i.."_btn"].onClick:RemoveAllListeners()
		self["TagBtn"..i.."_btn"].onClick:AddListener(function() self:OnSelectTag(i) end)
	end
end

function AttrDebugPanel:__CacheObject()
	local canvas = self.gameObject:GetComponent(Canvas)
	if canvas ~= nil then
		canvas.pixelPerfect = false
		canvas.overrideSorting = true
	end

	if self.EntityScrollView_recyceList then
		self.EntityScrollView_recyceList:SetLuaCallBack(self:ToFunc("OnScroll"))
	end
	
	self.RangeInput_txt = self.RangeInput.transform:GetComponent(TMP_InputField)
end

function AttrDebugPanel:__delete()
end

function AttrDebugPanel:__Create()
	if not Fight.Instance then return end
	self.entityManager = Fight.Instance.entityManager

	self.EntityScrollView_recyceList:SetCellNum(20)
end

function AttrDebugPanel:__Show()
	self:OnSelectTag(1)
	if not self.timer then
		self.timer = LuaTimerManager.Instance:AddTimer(0, 0.01,self:ToFunc("Update"))
	end
end

function AttrDebugPanel:_GetItemById(id)
	for _, v in pairs(self.itemObjList) do
		if v.instanceId == id then
			return v
		end
	end
	
	for _, v in pairs(self.subItemObjList) do
		if v.instanceId == id then
			return v
		end
	end
end

function AttrDebugPanel:_GetIdListWithTag(tag)
	local disInterval = tonumber(self.RangeInput_txt.text) or 0
	local idList = {}
	local entityInstances = self.entityManager.entityInstances
	local ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	if tag == 1 then
		for i = 1, #entityInstances do
			local entity = self.entityManager:GetEntity(entityInstances[i])
			if entity and entity.tagComponent and entity.tagComponent.tag == FightEnum.EntityTag.Npc then
				local dis = Vec3.Distance(ctrlEntity.transformComponent.position, entity.transformComponent.position)
				if dis <= disInterval then
					table.insert(idList, {id = entityInstances[i], dis = dis})
				end
			end
		end
	elseif tag == 2 then
		for i = 1, #entityInstances do
			local entity = self.entityManager:GetEntity(entityInstances[i])
			if entity and entity.tagComponent and entity.tagComponent.tag == FightEnum.EntityTag.Bullet then
				local dis = Vec3.Distance(ctrlEntity.transformComponent.position, entity.transformComponent.position)
				if dis <= disInterval then
					table.insert(idList, {id = entityInstances[i], dis = dis})
				end
			end
		end
	elseif tag == 3 then
		for i = 1, #entityInstances do
			local entity = self.entityManager:GetEntity(entityInstances[i])
			if entity and entity.tagComponent and entity.tagComponent.tag == FightEnum.EntityTag.SceneObj then
				local dis = Vec3.Distance(ctrlEntity.transformComponent.position, entity.transformComponent.position)
				if dis <= disInterval then
					table.insert(idList, {id = entityInstances[i], dis = dis})
				end
			end
		end
	elseif tag == 4 then
		for i = 1, #entityInstances do
			local entity = self.entityManager:GetEntity(entityInstances[i])
			if entity and (not entity.tagComponent or entity.tagComponent.tag == FightEnum.EntityTag.None) then
				local dis = Vec3.Distance(ctrlEntity.transformComponent.position, entity.transformComponent.position)
				if dis <= disInterval then
					table.insert(idList, {id = entityInstances[i], dis = dis})
				end
			end
		end
	end
	
	table.sort(idList, function(a, b) return a.dis < b.dis end)
	
	local ids = {}
	for i = 1, #idList do
		table.insert(ids, idList[i].id)
	end
	
	return ids
end

local updateV3= Vec3.New(0,0.85,0)
function AttrDebugPanel:Update()
	if not Fight.Instance then
		self:OnClose()
		return
	end
	
	self:RefreshScroll()
	if self.subPanel then
		self.subPanel:UpdateInfoPanel()
		
		local entity = self.entityManager:GetEntity(self.curSelectedItemId[1])
		if entity and entity.transformComponent then
			local targetPos = entity.transformComponent.position + updateV3
			local sp = UtilsBase.WorldToUIPointBase(targetPos.x, targetPos.y, targetPos.z)
			if sp.z >= 0 then
				self.Lock:SetActive(true)
				self.Lock_img.color = SelectedColor[1]
				UnityUtils.SetLocalPosition(self.Lock.transform, sp.x, sp.y , 0)
				return
			end
		end
	end
	self.Lock:SetActive(false)
end

function AttrDebugPanel:OnScroll(index, obj)
	local item = self:CreateBaseItem(index, obj)
	item.type = 1
	self.itemObjList[index] = item
	
	for i = 1, #self.itemObjList do
		local obj = self.itemObjList[i].gameObject
		if index ~= i and item.gameObject == obj then
			self.itemObjList[i].gameObject = nil
		end
	end
end

function AttrDebugPanel:OnSubScroll(index, obj)
	local item = self:CreateBaseItem(index, obj)
	item.type = 2
	self.subItemObjList[index] = item
end

function AttrDebugPanel:CreateBaseItem(index, obj)
	local item = {}
	item.gameObject = obj
	item.transform = item.gameObject.transform
	UtilsUI.GetContainerObject(item.transform, item)
	item.gameObject:SetActive(false)
	
	return item
end

function AttrDebugPanel:OnEntityItemSelect(item)
	if self.curSelectedItemId[item.type] and self.curSelectedItemId[item.type] == item.instanceId then
		self.subPanel:OnClose()
		return
	end
	
	if self.curSelectedItemId[item.type] then
		local lastItem = self:_GetItemById(self.curSelectedItemId[item.type])
		if lastItem then
			lastItem.EntityIdText_txt.color = Color(1, 1, 1)
		end
	end
	
	
	item.EntityIdText_txt.color = SelectedColor[1]
	
	self.curSelectedItemId[item.type] = item.instanceId
	self:UpdateDetailPanel(item.entity, item.type)
end

function AttrDebugPanel:UpdateDetailPanel(entity, itemType)
	if self.subPanel and self.subPanel.entity and 
		self.subPanel.entity.instanceId == entity.instanceId then
		return
	end
	
	local closeCallback = function()
		local curItem = self:_GetItemById(self.curSelectedItemId[itemType])
		if curItem then
			curItem.EntityIdText_txt.color = Color(1, 1, 1)
		end
		self.curSelectedItemId[itemType] = nil
		--self.subPanel = nil
	end
	
	if not self.subPanel then
		self.subPanel = AttrSubPanel.New(self, self.transform, SelectedColor[1])
	end
	self.subPanel:Reload(entity, closeCallback)
end

function AttrDebugPanel:RefreshScroll()
	local entityInstances = self:_GetIdListWithTag(self.scrollTag)
	self:UpdateScroll(entityInstances, self.itemObjList)
	
	if self.curSelectedItemId[2] then
		local curItem = self:_GetItemById(self.curSelectedItemId[2])
		if curItem then
			self:UpdateDetailPanel(curItem.entity)
		else
			self.subPanel:OnClose()
		end
	elseif self.curSelectedItemId[1] then
		local curItem = self:_GetItemById(self.curSelectedItemId[1])
		if curItem then
			curItem.EntityIdText_txt.color = SelectedColor[1]
			self:UpdateDetailPanel(curItem.entity)
		else
			self.subPanel:OnClose()
		end
	end
end

function AttrDebugPanel:UpdateScroll(entityInstances, itemObjList)
	for i = 1, #entityInstances do
		local item = itemObjList[i]
		if item and item.instanceId ~= entityInstances[i] then
			local entity = self.entityManager:GetEntity(entityInstances[i])
			if entity then
				self:UpdateItem(item, entity)
			end
		end
	end

	for i = #entityInstances + 1, #itemObjList do
		itemObjList[i].instanceId = nil
		itemObjList[i].entity = nil
		if itemObjList[i].gameObject then
			itemObjList[i].gameObject:SetActive(false)
		end
	end
end

function AttrDebugPanel:UpdateItem(item, entity)
	item.instanceId = entity.instanceId
	item.entity = entity

	item.EntityBtn_btn.onClick:RemoveAllListeners()
	item.EntityBtn_btn.onClick:AddListener(function() self:OnEntityItemSelect(item) end)
	item.EntityIdText_txt.color = Color(1, 1, 1)
	if item.entity.parent and item.entity.parent.instanceId ~= item.entity.instanceId then
		item.EntityIdText_txt.text = string.format("id: %d[%d]->%d", item.entity.instanceId, item.entity.entityId, item.entity.parent.instanceId)
	else
		item.EntityIdText_txt.text = string.format("id: %d[%d]", item.entity.instanceId, item.entity.entityId)
	end
	if item.gameObject then
		item.gameObject:SetActive(true)
	end
end

function AttrDebugPanel:OnSelectTag(tag)
	for i = 1, 4 do
		self["TagText"..i.."_txt"].color = Color(1, 1, 1)
	end
	
	self["TagText"..tag.."_txt"].color = SelectedColor[1]
	self.scrollTag = tag
end

function AttrDebugPanel:OnClose()
	self:Destroy()
end