ShowActiveEntityPanel = BaseClass("ShowActiveEntityPanel",BasePanel)

local CacheTable = {}

function ShowActiveEntityPanel:__init()
	self:SetAsset("Prefabs/UI/FightDebug/DebugShowAcitveEntity.prefab")
	
	self.content = {}
	self.loadDone = false
	
	self.tag = 1
	self.showEcoId = false
end

function ShowActiveEntityPanel:__CacheObject()
end

function ShowActiveEntityPanel:__BindListener()
	self.AllAction_btn.onClick:AddListener(self:ToFunc("OnClickAll"))
	self.LodAction_btn.onClick:AddListener(self:ToFunc("OnClickLod"))
	
	self.EcoIdAction_btn.onClick:AddListener(self:ToFunc("OnClickEcoId"))
end

function ShowActiveEntityPanel:__Show()
	if not Fight.Instance then
		return 
	end
	self.entityManager = Fight.Instance.entityManager
	self.loadDone = true
	
	self:OnClickAll()
end

function ShowActiveEntityPanel:__Hide()
	self.loadDone = false
end

function ShowActiveEntityPanel:__delete()
	self.loadDone = false
end

function ShowActiveEntityPanel:SelectTag(tag)
	if tag == self.tag then
		return 
	end
	
	self.tag = tag
	
	self.AllText_txt.color = Color(1, 1, 1)
	self.LodText_txt.color = Color(1, 1, 1)
end

function ShowActiveEntityPanel:OnClickAll()
	self:SelectTag(1)
	self.AllText_txt.color = Color(0, 1, 0)
	self.showEntities = true
	self.showUnavailableEntities = true
end

function ShowActiveEntityPanel:OnClickLod()
	self:SelectTag(2)
	self.LodText_txt.color = Color(0, 1, 0)
	self.showLod0 = true
	self.showLod1 = true
	self.showUnavailableEntities = true
end

function ShowActiveEntityPanel:OnClickEcoId()
	self.showEcoId = not self.showEcoId
	self.EcoIdText_txt.color = self.showEcoId and Color(0, 1, 0) or Color(1, 1, 1)
end

local TitleColor = Color(0, 1, 0)
local TitleStr = "<color=#%s>%s:%d</color>"
local TitleExpandStr = "<color=#%s>+%s:%d</color>"
function ShowActiveEntityPanel:GetTilte(title, num, expand)
	local str = TitleStr
	str = expand and TitleExpandStr or str
	return string.format(str, ColorUtility.ToHtmlStringRGB(TitleColor), title, num)
end

local NormalColor = Color(1, 1, 1)
local NotFoundColor = Color(1, 0, 0)
local NotFountStr = "<color=#%s>%d</color>"
local EntityStr = "<color=#%s>%d[%d]</color>"
local EntityWithDisStr = "<color=#%s>%d[%d]:%0.2f</color>"
function ShowActiveEntityPanel:GetShowContent(instanceId, entity, dis, color)
	if not entity or (self.showEcoId and not entity.sInstanceId) then
		local showColor = entity and NormalColor or NotFoundColor
		color = color or showColor
		return string.format(NotFountStr, ColorUtility.ToHtmlStringRGB(color), instanceId)
	end
	
	color = color or NormalColor
	if entity.sInstanceId and self.showEcoId then
		return dis and string.format(EntityWithDisStr, ColorUtility.ToHtmlStringRGB(color), instanceId, entity.sInstanceId, dis) or
			string.format(EntityStr, ColorUtility.ToHtmlStringRGB(color), instanceId, entity.sInstanceId)
	end
	
	return dis and string.format(EntityWithDisStr, ColorUtility.ToHtmlStringRGB(color), instanceId, entity.entityId, dis) or
		string.format(EntityStr, ColorUtility.ToHtmlStringRGB(color), instanceId, entity.entityId)
end

function ShowActiveEntityPanel:ShowAllEntities(index)
	local entityInstances = self.entityManager.entityInstances
	local entites = self.entityManager.entites
	
	TableUtils.ClearTable(CacheTable)
	for _, v in pairs(entityInstances) do
		local entity = entites[v]
		if entity then
			table.insert(CacheTable, v)
		end
	end
	
	index = self:AddContent(index, self:GetTilte("Entities", #CacheTable, self.showEntities), function()
		self.showEntities = not self.showEntities
	end)
	if self.showEntities then
		for _, v in pairs(CacheTable) do
			local entity = entites[v]
			index = self:AddContent(index, self:GetShowContent(v, entity))
		end
	end

	
	TableUtils.ClearTable(CacheTable)
	for _, v in pairs(entityInstances) do
		local entity = entites[v]
		if not entity then
			table.insert(CacheTable, v)
		end
	end
	
	index = self:AddContent(index, self:GetTilte("Unavailable Entities", #CacheTable, self.showUnavailableEntities), function()
		self.showUnavailableEntities = not self.showUnavailableEntities
	end)
	if self.showUnavailableEntities then
		for _, v in pairs(CacheTable) do
			index = self:AddContent(index, self:GetShowContent(v))
		end
	end
	
	return index
end

function ShowActiveEntityPanel:ShowLodEntities(index)
	local entityInstances = self.entityManager.entityInstances
	local entites = self.entityManager.entites
	
	TableUtils.ClearTable(CacheTable)
	for _, v in pairs(entityInstances) do
		local entity = entites[v]
		if entity and not entity.componentLodInfo then
			table.insert(CacheTable, v)
		end
	end
	
	index = self:AddContent(index, self:GetTilte("Lod0", #CacheTable, self.showLod0), function()
		self.showLod0 = not self.showLod0
	end)
	if self.showLod0 then
		for _, v in pairs(CacheTable) do
			local entity = entites[v]
			index = self:AddContent(index, self:GetShowContent(v, entity))
		end
	end
	
	TableUtils.ClearTable(CacheTable)
	for _, v in pairs(entityInstances) do
		local entity = entites[v]
		if entity and entity.componentLodInfo and entity.componentLodInfo.Lod == 1 then
			table.insert(CacheTable, v)
		end
	end
	
	index = self:AddContent(index, self:GetTilte("Lod1", #CacheTable, self.showLod1), function()
		self.showLod1 = not self.showLod1
	end)
	if self.showLod1 then
		for _, v in pairs(CacheTable) do
			local entity = entites[v]
			index = self:AddContent(index, self:GetShowContent(v, entity, entity.componentLodInfo.debugShowDistance))
		end
	end
	
	TableUtils.ClearTable(CacheTable)
	for _, v in pairs(entityInstances) do
		local entity = entites[v]
		if not entity then
			table.insert(CacheTable, v)
		end
	end
	
	index = self:AddContent(index, self:GetTilte("Unavailable Entities", #CacheTable, self.showUnavailableEntities), function()
		self.showUnavailableEntities = not self.showUnavailableEntities
	end)
	if self.showUnavailableEntities then
		for _, v in pairs(CacheTable) do
			index = self:AddContent(index, self:GetShowContent(v))
		end
	end
	
	return index
end

function ShowActiveEntityPanel:Update()
	if not self.loadDone then
		return 
	end
	
	local index = 1
	if self.tag == 1 then
		index = self:ShowAllEntities(index)
	elseif self.tag == 2 then
		index = self:ShowLodEntities(index)	
	end
	self:HideUnuseItem(index)
	self:UpdatePanelSize()
end

function ShowActiveEntityPanel:AddContent(index, content, callback)
	local contentIns = self.content[index]
	if not contentIns then
		local textParent = self.ActiveEntityList.transform
		local contentObj = GameObject.Instantiate(self.Clone)
		contentObj.transform:SetParent(textParent)
		contentObj.transform.localScale = Vector3(1, 1, 1)

		contentIns = {}
		contentIns.gameObject = contentObj
		contentIns.transform = contentObj.transform
		UtilsUI.GetContainerObject(contentIns.transform, contentIns)
		self.content[index] = contentIns
	end
	if not contentIns.gameObject.activeInHierarchy then
		contentIns.gameObject:SetActive(true)
	end
	
	contentIns.Action_btn.onClick:RemoveAllListeners()
	if callback then
		contentIns.Action_btn.onClick:AddListener(callback)
	end

	contentIns.Text_txt.text = content
	return index + 1
end

function ShowActiveEntityPanel:HideUnuseItem(start)
	local startIndex = start or 1
	for i = startIndex, #self.content do
		self.content[i].gameObject:SetActive(false)
		self.content[i].Action_btn.onClick:RemoveAllListeners()
	end
end

local cellSize = 28
function ShowActiveEntityPanel:UpdatePanelSize()
	local count = 0
	local transform = self.ActiveEntityList.transform
	for i = 1, transform.childCount do
		if transform:GetChild(i - 1).gameObject.activeSelf then
			count = count + 1
		end
	end
	
	self.ActiveEntityList_rect.sizeDelta = Vector2(self.ActiveEntityList_rect.sizeDelta.x, count * cellSize)
end