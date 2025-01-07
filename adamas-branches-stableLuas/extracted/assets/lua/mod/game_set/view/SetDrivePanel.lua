SetDrivePanel = BaseClass("SetDrivePanel", BasePanel)

function SetDrivePanel:__init()
	self.itemObjList = {}
    self.curMode = nil 
    self.curDriveCameraMode = nil
    self:SetAsset("Prefabs/UI/GameSet/SetDrivePanel.prefab")
end

function SetDrivePanel:__Create()

end

function SetDrivePanel:__BindListener()

end

function SetDrivePanel:__ShowComplete()
	self.dirveDataList = GameSetConfig.Dirve
    self.Title_txt.text = TI18N("载具设置")
    self:RefreshItemList()
	
	self.OriginTrafficMode = mod.GameSetCtrl:GetDrive(GameSetConfig.SaveKey.TrafficMode)
    self.DriveCameraCentralAuto = mod.GameSetCtrl:GetDrive(GameSetConfig.SaveKey.DriveCameraCentralAuto)
end

function SetDrivePanel:RefreshItemList()
    local listNum = #self.dirveDataList
    self.FightList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.FightList_recyceList:SetCellNum(listNum)
end

function SetDrivePanel:RefreshItemCell(index, go)
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

        local valueIndexMap = {}
		for i, v in ipairs(self.dirveDataList[index].SetValues) do
			local optionData = TMP_Dropdown.OptionData(v.name)
			itemObj.Dropdown_drop.options:Add(optionData)
            valueIndexMap[v.value] = i
		end
		itemObj.Dropdown_drop.onValueChanged:AddListener(function(value)
            if self.dirveDataList[index].SetName == "载具驾驶模式" then
                local ctrlId = Fight.Instance.playerManager:GetPlayer():GetCtrlEntity()
                if BehaviorFunctions.CheckEntityState(ctrlId, FightEnum.EntityState.OpenDoor) then
                    MsgBoxManager.Instance:ShowTips(TI18N("不支持修改此模式，请离开载具后重试"))

                    itemObj.Dropdown_drop:SetValueWithoutNotify(itemObj.lastValue)
                    return
                end
                if mod.GameSetCtrl:GetDrive(self.dirveDataList[index].SaveKey) == 1 then
                    itemObj.des_txt.text = TI18N("处于都市自由模式时，请注意遵守交通规则")
                else
                    itemObj.des_txt.text = TI18N("处于安全竞速模式时不会触发交通违法")
                end
                self.curMode = self.dirveDataList[index].SetValues[value+1].value
            else
                self.curDriveCameraMode = self.dirveDataList[index].SetValues[value + 1].value
            end
			--mod.GameSetCtrl:SetDrive(self.dirveDataList[index].SaveKey, self.dirveDataList[index].SetValues[value+1].value)
		end)
        local saveValue = mod.GameSetCtrl:GetDrive(self.dirveDataList[index].SaveKey)
        if valueIndexMap[saveValue] then
            itemObj.Dropdown_drop:SetValueWithoutNotify(valueIndexMap[saveValue] - 1 )
            itemObj.lastValue = valueIndexMap[saveValue] - 1
        end
        self.itemObjList[index] = {}
        self.itemObjList[index].itemObj = itemObj
    end
   		
   	local keyInfo = self.dirveDataList[index]
   	itemObj.Key_txt.text = keyInfo.SetName
    itemObj.des_txt.text = ""
    
    UnityUtils.SetActive(itemObj.des, false)
    if keyInfo.SetName == "载具驾驶模式" then
       UnityUtils.SetActive(itemObj.wenhao, true)
        local clickFunc = function ()
            UnityUtils.SetActive(itemObj.des, true)
            
            if mod.GameSetCtrl:GetDrive(self.dirveDataList[index].SaveKey) == 1 then
                itemObj.des_txt.text = TI18N("处于都市自由模式时，请注意遵守交通规则")
            else
                itemObj.des_txt.text = TI18N("处于安全竞速模式时不会触发交通违法")
            end
        end
        
        itemObj.wenhao_btn.onClick:RemoveAllListeners()
        itemObj.wenhao_btn.onClick:AddListener(clickFunc)
    else
        UnityUtils.SetActive(itemObj.wenhao, false)
    end 
    
   	-- AtlasIconLoader.Load(itemObj.btnKey.gameObject, keyInfo.image)
end

function SetDrivePanel:__Show()

end

function SetDrivePanel:__delete()
    if self.curMode and self.OriginTrafficMode ~= self.curMode then
        BehaviorFunctions.SetTrafficMode(self.curMode,
                function ()
                    CurtainManager.Instance:EnterWait()
                end,
                function ()
                    CurtainManager.Instance:ExitWait()
                end)
    end
    if self.curDriveCameraMode and self.DriveCameraCentralAuto ~= self.curDriveCameraMode then
        BehaviorFunctions.SetTrafficCameraMode(self.curDriveCameraMode)
    end

    self.curMode = nil
    self.curDriveCameraMode = nil
end


