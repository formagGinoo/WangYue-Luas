EntityShopPanel = BaseClass("EntityShopPanel", BasePanel)

function EntityShopPanel:__init()  
    self:SetAsset("Prefabs/UI/Shop/EntityShopPanel.prefab")
end

function EntityShopPanel:__BindListener()
    self.BuyBtn_btn.onClick:AddListener(self:ToFunc("OnClick_BuyBtn"))
    self.ExitBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ExitBtn"))

    UtilsUI.SetHideCallBack(self.EntityShopPanel_out, self:ToFunc("Exit_CallBack"))
end

function EntityShopPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
    EventMgr.Instance:AddListener(EventName.CloseEntityShop, self:ToFunc("Exit_CallBack"))

    UtilsUI.SetAnimationEventCallBack(self.BuySelect, self:ToFunc("OnClickBuyBtnCb"))
    UtilsUI.SetAnimationEventCallBack(self.ExitSelect, self:ToFunc("PlayHideAnim"))
end

function EntityShopPanel:__Create()
end

function EntityShopPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
end

function EntityShopPanel:__Hide()
end

function EntityShopPanel:__Show()
    self.animator = self.gameObject:GetComponent(Animator)
    self.shopInfo = ShopConfig.GetShopInfoById(self.args.shopId)
    self.shopId = self.args.shopId
    self.goodsList = mod.ShopCtrl:GetGoodsList(self.shopId)
    for _,goods in ipairs(self.goodsList) do
        if goods.goods_id == self.args.goodsId then
            self.goods = goods
        end
    end
    self:SetGoodsInfo()
    self:SetNPCDialog()
    self:SetBtnText()
    self.timer = LuaTimerManager.Instance:AddTimerByNextFrame(1,0,function()
		LayoutRebuilder.ForceRebuildLayoutImmediate(self.Root.transform)
	end)
end


function EntityShopPanel:__ShowComplete()
    self.shopId = self.args.shopId
end

function EntityShopPanel:SetGoodsInfo()
    if not self.goodsTips then
        self.goodsTips = GoodsInfoTip.New(self.GoodsInfoTip)
    end
    self.goodsTips:SetGoodsInfo(self.args.goodsId,self.goodsList.disCount)
end

function EntityShopPanel:SetNPCDialog()
    self.NPC_txt.text = TI18N(BehaviorFunctions.GetNpcName(self.shopInfo.relatenpc_id))
    self.NPCText_txt.text = TI18N(self.shopInfo.npc_text)
end

function EntityShopPanel:SetBtnText()
    self.BuyBtnText_txt.text = TI18N("购买")
    self.ExitBtnText_txt.text = TI18N("离开")
end

function EntityShopPanel:OnClick_BuyBtn()
    UtilsUI.SetActive(self.BuySelect,true)
end

function EntityShopPanel:OnClickBuyBtnCb()
    UtilsUI.SetActive(self.BuySelect,false)
    local goodId = self.goodsList[1].item_id
    PanelManager.Instance:OpenPanel(ShopBuyPanel, {shopId = self.shopId, itemId = goodId})
end

function EntityShopPanel:Exit_CallBack()
    self.parentWindow:Close_HideCallBack()
    --Fight.Instance.entityManager:CallBehaviorFun("OnExitShop", self.shopId)
    
    --WindowManager.Instance:CloseWindow(ShopMainWindow)
end

function EntityShopPanel:RemoveTimer()
end

function EntityShopPanel:PlayHideAnim()
    self.animator:Play("UI_EntityShopPanel_out")
end

function EntityShopPanel:OnClick_ExitBtn()
    UtilsUI.SetActive(self.ExitSelect,true)
end

function EntityShopPanel:UpdateCurrencyCount()
    self.goodsTips:RefreshCurrency()
end