AssetAgreementPanel = BaseClass("AssetAgreementPanel", BasePanel)

local StateUIName = {"RenovationInfo","FurnitureInfo","DeviceInfo","AgreementInfo","OrnamentScroll","LastAndNextGroup","LastBtn","CompleteBtnGroup"}

local UIState = {
    [1] = {true,false,false,false,true,true,false,false},
    [2] = {false,true,false,false,true,true,true,false},
    [3] = {false,false,true,false,false,true,true,false},
    [4] = {false,false,false,true,false,false,false,true},
}

function AssetAgreementPanel:__init()  
    self:SetAsset("Prefabs/UI/AssetPurchase/AssetAgreementPanel.prefab")
    self.ornamentGroupList = {}
    self.deviceItemList = {}
    self.ornamentSelectMap = {}
end

function AssetAgreementPanel:__BindListener()
    self.CompleteLastBtn_btn.onClick:AddListener(self:ToFunc("OnClick_LastBtn"))
    self.LastBtn_btn.onClick:AddListener(self:ToFunc("OnClick_LastBtn"))
    self.NextBtn_btn.onClick:AddListener(self:ToFunc("OnClick_NextBtn"))
    self.CompleteBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CompleteBtn"))
    self.BackBtn_btn.onClick:AddListener(self:ToFunc("OnClick_BackBtn"))
end

function AssetAgreementPanel:__BindEvent()

end

function AssetAgreementPanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AssetAgreementPanel:__delete()
end

function AssetAgreementPanel:__Hide()
end

function AssetAgreementPanel:__Show()
    self.assetInfo = self.args.assetInfo
    self.assetAgreementInfo = AssetPurchaseConfig.GetAssetAgreementById(self.assetInfo.id)
    self.index = 1
end

function AssetAgreementPanel:__ShowComplete()
    self:RefreshUI()
    self:RefreshInfo()
end

function AssetAgreementPanel:RefreshUI()
    for i, v in ipairs(StateUIName) do
        UtilsUI.SetActive(self[v],UIState[self.index][i])
    end
end

function AssetAgreementPanel:RefreshInfo()
    if self.index == 1 then
        self.groupInfo = AssetPurchaseConfig.GetAssetAgreementShowById(self.assetAgreementInfo.renovation_id)
        self.groupList = AssetPurchaseConfig.GetAssetAgreementShowListById(self.assetAgreementInfo.renovation_id)
        self:RefreshGroupList()
    elseif self.index == 2 then
        self.groupInfo = AssetPurchaseConfig.GetAssetAgreementShowById(self.assetAgreementInfo.furniture_id)
        self.groupList = AssetPurchaseConfig.GetAssetAgreementShowListById(self.assetAgreementInfo.furniture_id)
        self:RefreshGroupList()
    elseif self.index == 3 then
        self.deviceList = self.assetAgreementInfo.device_show
        self:RefreshDeviceList()
    elseif self.index == 4 then
        self.PlayerName_txt.text = string.format(TI18N("购买者：%s"),mod.InformationCtrl:GetPlayerInfo().nick_name)
        if self.assetAgreementInfo.free_show then
            UtilsUI.SetActive(self.Cost,false)
            UtilsUI.SetActive(self.FreeText,true)
        else
            UtilsUI.SetActive(self.Cost,true)
            UtilsUI.SetActive(self.FreeText,false)
            SingleIconLoader.Load(self.CostIcon, ItemConfig.GetItemIcon(self.assetAgreementInfo.real_cost[1][1]))
            self.CostCount_txt.text = self.assetAgreementInfo.real_cost[1][2]
            local cost = self.assetAgreementInfo.real_cost[1][2]
            local have = mod.BagCtrl:GetItemCountById(self.assetAgreementInfo.real_cost[1][1])
            if cost > have then
                self.CostCount_txt.color = Color(1,0.36,0.36)
            else
                self.CostCount_txt.color = Color(0.11,0.11,0.125)
            end
        end
    end
end

function AssetAgreementPanel:RefreshGroupList()
    local listNum = #self.groupList
    self.OrnamentScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshGroupCell"))
    self.OrnamentScroll_recyceList:SetCellNum(listNum)
end

function AssetAgreementPanel:RefreshGroupCell(index,go)
    if not go then
        return 
    end

    local ornamentGroup
    local ornamentGroupObj
    if self.ornamentGroupList[index] then
        ornamentGroup = self.ornamentGroupList[index].ornamentGroup
        ornamentGroupObj = self.ornamentGroupList[index].ornamentGroupObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        ornamentGroup = PoolManager.Instance:Pop(PoolType.class, "OrnamentGroup")
        if not ornamentGroup then
            ornamentGroup = OrnamentGroup.New()
        end
        ornamentGroupObj = uiContainer.OrnamentGroup
        self.ornamentGroupList[index] = {}
        self.ornamentGroupList[index].ornamentGroup = ornamentGroup
        self.ornamentGroupList[index].ornamentGroupObj = ornamentGroupObj
    end

    ornamentGroup:InitItem(self,ornamentGroupObj,self.groupInfo[self.groupList[index]],true)
    
    -- local callBackFunc = function()
    --     self:OrnamentSelectChange(self.ornamentGroupList[index].ornamentGroup)
    -- end
    -- ornamentGroup:SetSelectChangeCallBack(callBackFunc)
end

function AssetAgreementPanel:OrnamentSelectChange(ornamentGroup)
    local selectItem = ornamentGroup.curSelect.ornamentInfo
    self.ornamentSelectMap[selectItem.group_id] = selectItem.id

    SingleIconLoader.Load(self.RenovationShowImage,selectItem.show_pic)
    SingleIconLoader.Load(self.FurnitureShowImage,selectItem.show_pic)
end

function AssetAgreementPanel:GetSelectOrnament(groupId)
    return self.ornamentSelectMap[groupId]
end

function AssetAgreementPanel:RefreshDeviceList()
    local listNum = #self.deviceList
    self.DeviceList_recyceList:SetLuaCallBack(self:ToFunc("RefreshDeviceCell"))
    self.DeviceList_recyceList:SetCellNum(listNum)
end

function AssetAgreementPanel:RefreshDeviceCell(index,go)
    if not go then
        return 
    end

    local deviceItem
    local deviceItemObj
    if self.deviceItemList[index] then
        deviceItem = self.deviceItemList[index].deviceItem
        deviceItemObj = self.deviceItemList[index].deviceItemObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        deviceItem = PoolManager.Instance:Pop(PoolType.class, "SimpleDeviceItem")
        if not deviceItem then
            deviceItem = SimpleDeviceItem.New()
        end
        deviceItemObj = uiContainer.SimpleDeviceItem
        self.deviceItemList[index] = {}
        self.deviceItemList[index].deviceItem = deviceItem
        self.deviceItemList[index].deviceItemObj = deviceItemObj
    end
    local info = AssetPurchaseConfig.GetAssetDeviceInfoById(self.deviceList[index])
    deviceItem:InitItem(deviceItemObj,info,true)
end

function AssetAgreementPanel:OnClick_LastBtn()
    self.index = self.index - 1
    self:RefreshUI()
    self:RefreshInfo()
end

function AssetAgreementPanel:OnClick_NextBtn()
    self.index = self.index + 1
    self:RefreshUI()
    self:RefreshInfo()
end

function AssetAgreementPanel:OnClick_CompleteBtn()
    if not self.assetAgreementInfo.free_show then
        local cost = self.assetAgreementInfo.real_cost[1][2]
        local have = mod.BagCtrl:GetItemCountById(self.assetAgreementInfo.real_cost[1][1])
        if have < cost then
            local desc = string.format(TI18N("%s不足"), ItemConfig.GetItemConfig(self.assetAgreementInfo.real_cost[1][1]).name)
            MsgBoxManager.Instance:ShowTips(desc)
            return
        end
    end
    
    local show_id_list = {}
    for k, v in pairs(self.ornamentSelectMap) do
        table.insert(show_id_list,v)
    end
    local purchase_template_id = self.assetAgreementInfo.id
    CurtainManager.Instance:EnterWait()
    self.waitServer = true
    local id,cmd = mod.AssetPurchaseFacade:SendMsg("asset_center_buy_asset", {purchase_template_id = purchase_template_id,show_id_list = show_id_list})
    
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(ERRORCODE)
        if self.waitServer then
            CurtainManager.Instance:ExitWait()
            self.waitServer = nil
        end
        if ERRORCODE == 0 then
            self.parentWindow:SetJumpAsset(self.assetAgreementInfo.asset_id)
            self.parentWindow:OpenPanel(PurchaseSucceedPanel)
            self.parentWindow:ClosePanel(self)
        end
    end)
    
end

function AssetAgreementPanel:OnClick_BackBtn()
    self.parentWindow:OnPurchaseBtnClick()
    self.parentWindow:ClosePanel(self)
end
