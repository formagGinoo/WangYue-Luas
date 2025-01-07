SetKeyMapPanel = BaseClass("SetKeyMapPanel", BasePanel)

function SetKeyMapPanel:__init()
	self.itemObjList = {}
    self:SetAsset("Prefabs/UI/GameSet/SetKeyMapPanel.prefab")
end

function SetKeyMapPanel:__Create()

end

function SetKeyMapPanel:__BindListener()

end

function SetKeyMapPanel:__ShowComplete()
	self.keyDataList = {}
	for k, v in pairs(Config.DataKey.Find) do
		table.insert(self.keyDataList, v)
	end

	local onSort = function (a, b)
		return ((100 - a.group) * 100  + a.priority) > ((100 - b.group) * 100  + b.priority)
	end
	table.sort(self.keyDataList, onSort)

    self:RefreshItemList()
end

function SetKeyMapPanel:RefreshItemList()
    local listNum = #self.keyDataList
    self.KeyList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.KeyList_recyceList:SetCellNum(listNum)
end

function SetKeyMapPanel:RefreshItemCell(index, go)
	local itemObj
    if not go then
        return
    end

    if self.itemObjList[index] then
        itemObj = self.itemObjList[index].itemObj
    else
    	itemObj = UtilsUI.GetContainerObject(go)
    	itemObj.btnKey_btn.onClick:AddListener(self:ToFunc("OnKey"))
        self.itemObjList[index] = {}
        self.itemObjList[index].itemObj = itemObj
    end
   		
   	local keyInfo = self.keyDataList[index]
   	itemObj.Key_txt.text = keyInfo.desc
   	AtlasIconLoader.Load(itemObj.btnKey.gameObject, keyInfo.image)
end

function SetKeyMapPanel:OnKey()
	MsgBoxManager.Instance:ShowTips(TI18N("不支持修改此键位"))
end

function SetKeyMapPanel:__Show()

end



