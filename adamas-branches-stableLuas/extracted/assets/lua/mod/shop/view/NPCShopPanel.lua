NPCShopPanel = BaseClass("NPCShopPanel", BasePanel)

function NPCShopPanel:__init(parent)  
    self:SetAsset("Prefabs/UI/Shop/NPCShopPanel.prefab")
    self.parent = parent
    self.selectGood = nil
    self.shopId = nil
    self.commonTips = nil
    self.goodObjList = {}
    self.curGoodData = {}
end

function NPCShopPanel:__BindListener()
    --self:SetHideNode("NPCShopPanel_Eixt")

    self.BuyBtn_btn.onClick:AddListener(self:ToFunc("OnClick_BuyBtn"))
    self.BgBtn_btn.onClick:AddListener(self:ToFunc("OnClick_BgBtn"))
    
    EventMgr.Instance:AddListener(EventName.ShopBuyGoodComplete, self:ToFunc("BuyGoodComplete"))
    EventMgr.Instance:AddListener(EventName.ShopListUpdate, self:ToFunc("ShopListUpdate"))
    UtilsUI.SetHideCallBack(self.NPCShopPanel_RightPart_Eixt, self:ToFunc("HideTips_HideCallBack"))
end

function NPCShopPanel:__Create()
end

function NPCShopPanel:__delete()
    for k, v in pairs(self.goodObjList) do
		PoolManager.Instance:Push(PoolType.class, "CommonGood", v.commonGood)
	end
    self.parent = nil
    self.selectGood = nil
    self.shopId = nil
    self.commonTips = nil
    self.goodObjList = {}
    self.curGoodData = {}

    self.BuyBtn_btn.onClick:RemoveAllListeners()
    self.BgBtn_btn.onClick:RemoveAllListeners()

    EventMgr.Instance:RemoveListener(EventName.ShopBuyGoodComplete, self:ToFunc("BuyGoodComplete"))
    EventMgr.Instance:RemoveListener(EventName.ShopListUpdate, self:ToFunc("ShopListUpdate"))
end

function NPCShopPanel:__Hide()
end

function NPCShopPanel:__Show()
    self.shopInfo = ShopConfig.GetShopInfoById(self.args.shopId)
    self.disCount = mod.ShopCtrl:GetDisCountByShopId(self.args.shopId)
    self:SetShopName()
    self:SetNPCDialog()
    self:SetBuyBtnText()
end

function NPCShopPanel:__ShowComplete()
    self.shopId = self.args.shopId
    self.CommonTipsObj = self.CommonTips
    self:RefreshGoodList()
end

function NPCShopPanel:RefreshGoodList()
    self.curGoodData = mod.ShopCtrl:GetGoodsList(self.shopId)
    local col = 1
    local row = math.ceil((self.GoodScroll_rect.rect.height - 25) / 145)
    local goodCount = #self.curGoodData

    local listNum = goodCount > (col * row) and goodCount or (col * row)
    self.GoodScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshGoodCell"))
    self.GoodScroll_recyceList:SetCellNum(listNum)
    self:CloseInfoTips()
end

function NPCShopPanel:RefreshGoodCell(index,go)
    if not go then
        return 
    end

    local commonGood
    local goodObj
    if self.goodObjList[index] then
        commonGood = self.goodObjList[index].commonGood
        goodObj = self.goodObjList[index].goodObj
    else
        local uiContainer = {}
        uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
        commonGood = PoolManager.Instance:Pop(PoolType.class, "CommonGood")
        if not commonGood then
            commonGood = CommonGood.New()
        end
        goodObj = uiContainer.SingleItem
        self.goodObjList[index] = {}
        self.goodObjList[index].commonGood = commonGood
        self.goodObjList[index].goodObj = goodObj
        self.goodObjList[index].isSelect = false
    end

    commonGood:InitGood(goodObj,self.curGoodData[index],self.disCount,true)
    local onClickFunc = function()
        self:OnClick_SingleGood(self.goodObjList[index].commonGood)
    end
    commonGood:SetBtnEvent(false,onClickFunc)

    if not self.curGoodData[index] or not next(self.curGoodData[index]) then
        return 
    end
end

function NPCShopPanel:SetShopName()
    self.ShopName_txt.text = self.shopInfo.name
end

function NPCShopPanel:SetNPCDialog()
    self.NPC_txt.text = BehaviorFunctions.GetNpcName(self.args.npcId)
    self.NPCText_txt.text = self.shopInfo.npc_text
end

function NPCShopPanel:SetBuyBtnText()
    self.BuyBtnText_txt.text = self.shopInfo.buy_text
end

function NPCShopPanel:OnClick_SingleGood(singleGood)
    local iteminfo = singleGood.goodInfo
    
    if self.selectGood and self.selectGood ~= singleGood then
        self.selectGood.isSelect = false
        self.selectGood:SetCheckBox()
        self.selectGood:ReSetGoods()
    end
    singleGood.isSelect = true
    singleGood:SetCheckBox()
    singleGood:OnClick()
    self.selectGood = singleGood

    self:ShowInfoTips(singleGood.itemInfo)

    if iteminfo.buy_limit == 0 or  iteminfo.buy_count < iteminfo.buy_limit then
        UtilsUI.SetActive(self.BuyBtn,true)
        UtilsUI.SetActive(self.SoldOut,false)
    else
        UtilsUI.SetActive(self.BuyBtn,false)
        UtilsUI.SetActive(self.SoldOut,true)
    end
end

function NPCShopPanel:ShowInfoTips(goodInfo)
    if nil == self.commonTips then
        self.commonTips = CommonItemTip.New(self.CommonTips) 
    end
    UtilsUI.SetActive(self.NPC,false)
    self.commonTips:ReSetInfo()
    self.commonTips:SetItemInfo(goodInfo, function()
        LuaTimerManager.Instance:AddTimerByNextFrame(1,0.04,function()
            self.NPCShopPanel_RightPart_Open:SetActive(false)
            self.NPCShopPanel_RightPart_Open:SetActive(true)
        end)

    end)
    UtilsUI.SetActive(self.CommonTips,true)
    UtilsUI.SetActive(self.BgBtn,true)

    self.parentWindow:SetBlurBack(true)
end

function NPCShopPanel:OnClick_BuyBtn()
    local goodId = self.selectGood.goodInfo.item_id
    PanelManager.Instance:OpenPanel(ShopBuyPanel, {shopId = self.shopId, itemId = goodId})
end

function NPCShopPanel:OnClick_BgBtn()
    self:CloseInfoTips()
end

function NPCShopPanel:CloseInfoTips()
    self.NPCShopPanel_RightPart_Open:SetActive(false)
    self.NPCShopPanel_RightPart_Eixt:SetActive(true)
end

function NPCShopPanel:BuyGoodComplete()
    if self.selectGood then
        self.selectGood.isSelect = false
        self.selectGood:SetCheckBox()
        self.selectGood:ReSetGoods()
        self.selectGood = nil
    end
    self:RefreshGoodList()
end

function NPCShopPanel:ShopListUpdate(shopId)
    if shopId == self.shopId then
        if self.selectGood then
            self.selectGood.isSelect = false
            self.selectGood:SetCheckBox()
            self.selectGood:ReSetGoods()
            self.selectGood = nil
        end
        self:RefreshGoodList()
    end
end

function NPCShopPanel:HideTips_HideCallBack()
    UtilsUI.SetActive(self.NPC,true)
    if self.selectGood then
        self.selectGood.isSelect = false
        self.selectGood:SetCheckBox()
        self.selectGood:ReSetGoods()
        self.selectGood = nil
    end
    UtilsUI.SetActive(self.CommonTips,false)
    UtilsUI.SetActive(self.BuyBtn,false)
    UtilsUI.SetActive(self.SoldOut,false)
    UtilsUI.SetActive(self.BgBtn,false)
    self.parentWindow:SetBlurBack(false)
end

function NPCShopPanel:RemoveTimer()
    for _, v in pairs(self.goodObjList) do
        v.commonGood:RemoveTimer()
    end
end