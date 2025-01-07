
EventTypeItem = BaseClass("EventTypeItem", Module)

function EventTypeItem:__init()
	self.parent = nil
	self.object = nil
	self.node = {}
	self.eventItemList = {}
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

-- info = {main_type = x,legendList = {}}
function EventTypeItem:InitItem(object, info, defaultShow)
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)

	self.type = info.main_type
	self.legendList = info.legendList
	table.sort(self.legendList,	function(a,b)
		return a < b
	end)
    self.eventTypeItemTransform = self.node.EventTypeItem.transform
	self:Show()
end

function EventTypeItem:Show()
	self:SetTitle()
	self:SetEventItem()
end

function EventTypeItem:SetTitle()
	self.node.TitleName_txt.text = WorldMapTipConfig.GetLegendName(self.type)
end

function EventTypeItem:SetEventItem()
	for i, v in ipairs(self.legendList) do
		local objectInfo = self:GetEeventItem(i)
		local legendConfig = WorldMapTipConfig.GetLegendConfig(v)
		objectInfo.Name_txt.text = legendConfig.name
		SingleIconLoader.Load(objectInfo.Icon, legendConfig.icon)
	end
end

function EventTypeItem:GetEeventItem(idx)
	local objectInfo
	if self.eventItemList[idx] then
		objectInfo = self.eventItemList[idx]
	else
		objectInfo = {}
		objectInfo.object = GameObject.Instantiate(self.node.EventItem)
		UtilsUI.SetActive(objectInfo.object,true)
		objectInfo.objectTransform = objectInfo.object.transform
		UtilsUI.GetContainerObject(objectInfo.objectTransform, objectInfo)
		objectInfo.objectTransform:SetParent(self.eventTypeItemTransform)
		UnityUtils.SetLocalScale(objectInfo.objectTransform, 1,1,1)
		self.eventItemList[idx] = objectInfo
	end
	return objectInfo
end

function EventTypeItem:OnReset()
	self.eventItemList = {}
end