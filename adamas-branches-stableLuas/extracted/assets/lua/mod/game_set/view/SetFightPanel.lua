SetFightPanel = BaseClass("SetFightPanel", BasePanel)

function SetFightPanel:__init()
	self.itemObjList = {}
    self:SetAsset("Prefabs/UI/GameSet/SetFightPanel.prefab")
end

function SetFightPanel:__Create()

end

function SetFightPanel:__BindListener()

end

function SetFightPanel:__ShowComplete()
	self.fightDataList = GameSetConfig.Fight
    self:RefreshItemList()
end

function SetFightPanel:RefreshItemList()
    local listNum = #self.fightDataList
    self.FightList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.FightList_recyceList:SetCellNum(listNum)
end

function SetFightPanel:RefreshItemCell(index, go)
	local itemObj
    if not go then
        return
    end

    if self.itemObjList[index] then
        itemObj = self.itemObjList[index].itemObj
    else
    	itemObj = UtilsUI.GetContainerObject(go)

    	itemObj.Dropdown_drop = itemObj.Dropdown:GetComponent(TMP_Dropdown)
		itemObj.Dropdown_drop.options:Clear()
		for i, v in ipairs(self.fightDataList[index].SetValues) do
			local optionData = TMP_Dropdown.OptionData(v.name)
			itemObj.Dropdown_drop.options:Add(optionData)
		end
		itemObj.Dropdown_drop.onValueChanged:AddListener(function(value)
			mod.GameSetCtrl:SetFight(self.fightDataList[index].SaveKey, value)
		end)
		itemObj.Dropdown_drop.value = mod.GameSetCtrl:GetFight(self.fightDataList[index].SaveKey)
        self.itemObjList[index] = {}
        self.itemObjList[index].itemObj = itemObj
    end
   		
   	local keyInfo = self.fightDataList[index]
   	itemObj.Key_txt.text = keyInfo.SetName
   	-- AtlasIconLoader.Load(itemObj.btnKey.gameObject, keyInfo.image)
end

function SetFightPanel:__Show()

end



