
OrnamentGroup = BaseClass("OrnamentGroup", Module)

function OrnamentGroup:__init()
	self.parent = nil
	self.object = nil
	self.curSelect = nil
	self.node = {}
	self.ornamentItemList = {}
	self.isLoadObject = false
	self.loadDone = false
	self.defaultShow = true
end

function OrnamentGroup:InitItem(parent,object, groupInfo, defaultShow)
	self.parent = parent
	self.object = object
	self.node = UtilsUI.GetContainerObject(self.object.transform)
	
	self.groupInfo = TableUtils.CopyTable(groupInfo)
	table.sort(self.groupInfo, function(a,b)
		return a.order < b.order
	end)
	self.curSelectId = self.parent:GetSelectOrnament(groupInfo[1].group_id)
	self.curSelect = nil

	self:Show()
end

function OrnamentGroup:Show()
	self:SetTitle()
	self:RefreshGroup()
end

function OrnamentGroup:SetTitle()
	self.node.WallTitle_txt.text = self.groupInfo[1].name
end

function OrnamentGroup:RefreshGroup()
    local listNum = #self.groupInfo
    self.node.Group_recyceList:SetLuaCallBack(self:ToFunc("RefreshGroupCell"))
    self.node.Group_recyceList:SetCellNum(listNum)
end

function OrnamentGroup:RefreshGroupCell(index,go)
    if not go then
        return
    end

    local ornamentItem
    local assetInfoObj
    if self.ornamentItemList[index] then
        ornamentItem = self.ornamentItemList[index].ornamentItem
        assetInfoObj = self.ornamentItemList[index].assetInfoObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        ornamentItem = PoolManager.Instance:Pop(PoolType.class, "OrnamentItem")
        if not ornamentItem then
            ornamentItem = OrnamentItem.New()
        end
        assetInfoObj = uiContainer.OrnamentItem
        self.ornamentItemList[index] = {}
        self.ornamentItemList[index].ornamentItem = ornamentItem
        self.ornamentItemList[index].assetInfoObj = assetInfoObj
        self.ornamentItemList[index].isSelect = false
    end

    ornamentItem:InitItem(assetInfoObj,self.groupInfo[index],true)
    local onClickFunc = function()
        self:OnSelectItem(self.ornamentItemList[index].ornamentItem)
    end
	if self.curSelectId == nil or (self.groupInfo[index].id == self.curSelectId) then
		onClickFunc()
	end
    ornamentItem:SetBtnEvent(false,onClickFunc)

    if not self.groupInfo[index] or not next(self.groupInfo[index]) then
        return 
    end
end

function OrnamentGroup:OnSelectItem(ornamentItem)
	ornamentItem:SetSelect(true)
	if self.curSelect == nil then
		self.curSelect = ornamentItem
		self.curSelectId = ornamentItem.ornamentInfo.id
		self.parent:OrnamentSelectChange(self)
		return 
	end
	if self.curSelect == ornamentItem then
		return 
	end
	self.curSelect:SetSelect(false)
	self.curSelect = ornamentItem
	self.curSelectId = ornamentItem.ornamentInfo.id
	self.parent:OrnamentSelectChange(self)
end

function OrnamentGroup:SetSelectChangeCallBack(func)
	self.selectChangeCallBack = func
end

function OrnamentGroup:OnReset()
end

function OrnamentGroup:OnPush()
	for i, v in ipairs(self.ornamentItemList) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", v.ornamentItem)
	end
end