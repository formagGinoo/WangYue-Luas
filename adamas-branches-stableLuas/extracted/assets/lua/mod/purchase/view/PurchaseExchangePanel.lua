PurchaseExchangePanel = BaseClass("PurchaseExchangePanel", BasePanel)

function PurchaseExchangePanel:__init()
    self:SetAsset("Prefabs/UI/Purchase/PurchaseExchangePanel.prefab")
    self.typeObjList = {}
    self.goodObjList = {}
    self.goodsList = {}
end

function PurchaseExchangePanel:__BindListener()
    --self:SetHideNode("PurchaseExchangePanel_Eixt")
    -- self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("Close_HideCallBack"), self:ToFunc("OnBack"))
    EventMgr.Instance:AddListener(EventName.ShopListUpdate, self:ToFunc("ShowInfo"))

end

function PurchaseExchangePanel:__CacheObject()

end

function PurchaseExchangePanel:__Create()
    local selectIdx = self.parentWindow:GetSubSelectTagIdx()
    if selectIdx and selectIdx ~= 0 then
        self.selectType = selectIdx
    end
    self:CreateTypeList()

    local args = self.args or {}
    local selectType = args._jump and args._jump[1]
    if selectType then
        selectType = tonumber(selectType)
        self.tabPanel:SelectType(selectType)
    end
end

function PurchaseExchangePanel:__delete()
    for k, v in pairs(self.goodObjList) do
		PoolManager.Instance:Push(PoolType.class, "PurchaseCommonGoods", v.commonGoods)
	end
    self.goodObjList = {}
    EventMgr.Instance:RemoveListener(EventName.ShopListUpdate, self:ToFunc("ShowInfo"))
end

function PurchaseExchangePanel:__ShowComplete()

    
end
function PurchaseExchangePanel:__Hide()
    self.selectType = nil
end

function PurchaseExchangePanel:__Show()
    if self.curType and not self.selectType then
        self:SelectType(self.curType)
    elseif self.selectType then
        self:SelectType(self.selectType)
    end
end

function PurchaseExchangePanel:CreateTypeList()
    local tabList = {}
    local i = 1
    for k, info in pairs(PurchaseConfig.DataShop) do
        if info.shop_type == 103 then
            table.insert(tabList, {type = i, name = info.name, callback = function(parent, isSelect)
                if isSelect then
                    self:ActiveGoodsInteract(info)
                end
            end})
            i = i + 1
        end
    end

    for _, typeInfo in pairs(tabList) do
        ---检查系统是否开放
        local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(typeInfo.systemId)
        if not typeInfo.systemId or isOpen then
            local typeObj = self:GetTypeObj()
            if not self.defaultSelect and not self.selectType then
                self.defaultSelect = typeInfo.type
            end
            -- self:BindRedPoint(RedPointName.PurchasePackage, obj.RedPoint)
            typeObj.UTypeName_txt.text = typeInfo.name
            typeObj.STypeName_txt.text = typeInfo.name
            typeObj.callback = typeInfo.callback
            local onToggleFunc = function(isEnter)
                self:OnToggle_Type(typeInfo.type, isEnter)
            end
            local hideCb = function()
                typeObj.Selected:SetActive(false)
            end
            typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
            typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)
            typeObj.object:SetActive(true)

            self.typeObjList[typeInfo.type] = typeObj
        end
    end
    if self.defaultSelect then
        self:SelectType(self.defaultSelect)
    end
end

function PurchaseExchangePanel:ActiveGoodsInteract(interactInfo)
    local goodsList = mod.ShopCtrl:GetGoodsList(interactInfo.shop_id)
    if not goodsList then 
        mod.ShopCtrl:GetShopInfo(interactInfo.shop_id)
        EventMgr.Instance:AddListener(EventName.GetPurchaseExchangeGoods, self:ToFunc("ShowInfo"))
    else
        self:ShowInfo(interactInfo.shop_id)
    end
end

function PurchaseExchangePanel:ShowInfo(shopId,byServer)
    if ShopConfig.GetShopTypeByShopId(shopId) ~= ShopConfig.ShopType.UIExchangeShop then
        return
    end
    self.shopId = shopId
    self.goodsList[self.shopId] = mod.ShopCtrl:GetGoodsList(shopId)
    self.isMod = byServer
    self.parentWindow:UpdateCurrencyBarInfo(PurchaseConfig.DataShop[self.shopId].cur_item_id)
    self:RefreshScroll()
end

function PurchaseExchangePanel:RefreshScroll()
    local AwardCount = #self.goodsList[self.shopId]
    local listNum = AwardCount

    local scroll = self.ExchangeScollList.transform:GetComponent(ScrollRect)
    UnityUtils.SetAnchoredPosition(self.ScrollList.transform, 0, 0)
    scroll.inertia = false
    LuaTimerManager.Instance:AddTimer(1,0.1, function()
        scroll.inertia = true
    end)

    if not self.shops then
        self.shops = {}
    end

    if not self.shops[self.shopId] then
        self.shops[self.shopId] = {}
    elseif self.isMod == true then
        for k, data in pairs(self.shops[self.shopId]) do
            GameObject.Destroy(data.gameObject)
        end
        self.shops[self.shopId] = {}
    end

    for _, page in pairs(self.shops) do
        if page and next(page) then
            for k, item in pairs(page) do
                UtilsUI.SetActive(item.gameObject,false)
            end
        end
    end

    --for i, info in ipairs(self.goodsList[self.shopId]) do
        --if not self.shops[self.shopId][i] then
            --local go = GameObject.Instantiate(self.ExchangeScollItem, self.ExchangeScollItem.transform.parent)
            --self.shops[self.shopId][i] = {gameObject = go, info = info}
            --self:InitCell(i,go)
        --else
            --self:RefreshCell(i)
        --end
    --end
	self.startRefreshCell = true
	self.currentIndex = 1
	self.maxPerFrame = 10
end

function PurchaseExchangePanel:ProcessNextFrame(maxPerFrame)
    local endIndex = math.min(self.currentIndex + maxPerFrame - 1, #self.goodsList[self.shopId])
    for i = self.currentIndex, endIndex do
        local info = self.goodsList[self.shopId][i]
        if not self.shops[self.shopId][i] then
            local go = GameObject.Instantiate(self.ExchangeScollItem, self.ExchangeScollItem.transform.parent)
            self.shops[self.shopId][i] = { gameObject = go, info = info }
            self:InitCell(i, go)
        else
            self:RefreshCell(i)
        end
    end
	self.currentIndex = endIndex + 1
	self.startRefreshCell = self.currentIndex < #self.goodsList[self.shopId]
end


local currentIndex = 1
local maxFramesPerUpdate = 10

function PurchaseExchangePanel:Update()
	if self.startRefreshCell == true then
		self:ProcessNextFrame(self.maxPerFrame)
	end

end

function PurchaseExchangePanel:RefreshCell(id)
    local data = self.shops[self.shopId][id]
    UtilsUI.SetActive(data.gameObject,true)
    -- data.commonGoods:InitGoods(data.exchangeScollItem, data.info, 10000 , true)
    -- local onClickFunc = function()
    --     self:OnClick_SingleGoods(data.info)
    -- end
    -- data.commonGoods:SetBtnEvent(false,onClickFunc)
end

function PurchaseExchangePanel:InitCell(index, go)
    if not go then
        return 
    end
    local uiContainer = UtilsUI.GetContainerObject(go.transform)
    local commonGoods = PurchaseCommonGoods.New()
    commonGoods:InitGoods(uiContainer.ExchangeScollItem,self.goodsList[self.shopId][index],10000 ,true)
    local onClickFunc = function()
        self:OnClick_SingleGoods(self.goodsList[self.shopId][index])
    end
    commonGoods:SetBtnEvent(false,onClickFunc)
    self.shops[self.shopId][index].commonGoods = commonGoods
    self.shops[self.shopId][index].exchangeScollItem = uiContainer.ExchangeScollItem

end

function PurchaseExchangePanel:OnClick_SingleGoods(info)
    PanelManager.Instance:OpenPanel(ShopBuyPanel, {shopId = self.shopId, itemId = info.item_id})
end

function PurchaseExchangePanel:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if typeObj then
        if typeObj.SingleType_tog.isOn == true then
            self:OnToggle_Type(typeId, true)
        end
        typeObj.SingleType_tog.isOn = true
    end
end

function PurchaseExchangePanel:OnToggle_Type(typeId, isEnter)
    self.curType = typeId
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.Selected:SetActive(true)
        typeObj.UnSelect:SetActive(false)
    else
        typeObj.Selected:SetActive(false)
        typeObj.UnSelect:SetActive(true)
    end

    typeObj.callback(self, typeObj.SingleType_tog.isOn)
end

function PurchaseExchangePanel:GetTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    if self.closeSound then
        obj.SingleType_sound.notActive = true
    else
        obj.SingleType_sound.notActive = false
    end
    obj.objectTransform:SetParent(self.TypeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end
