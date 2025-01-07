FightGoodsInteractPanel = BaseClass("FightGoodsInteractPanel", BasePanel)

local ScrollMaxNum = 2 --目前滚轮最大数量

function FightGoodsInteractPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightGoodsInteractPanel.prefab")
    self.mainView = mainView
    self.selectIndex = nil
    self.uniqueIdList = {}
end

function FightGoodsInteractPanel:__CacheObject()

end

function FightGoodsInteractPanel:__BindListener()
    self.BuyInteract_btn.onClick:AddListener(self:ToFunc("OnClickBuyBtn"))
    self.StealInteract_btn.onClick:AddListener(self:ToFunc("OnClickStealBtn"))

    UtilsUI.SetHideCallBack(self.FightGoodsInteractPanel_out, self:ToFunc("Exit_CallBack"))
end

function FightGoodsInteractPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActiveGoodsInteract, self:ToFunc("ActiveGoodsInteract"))
    EventMgr.Instance:RemoveListener(EventName.RemoveGoodsInteract, self:ToFunc("RemoveGoodsInteract"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function FightGoodsInteractPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ActiveGoodsInteract, self:ToFunc("ActiveGoodsInteract"))
    EventMgr.Instance:AddListener(EventName.RemoveGoodsInteract, self:ToFunc("RemoveGoodsInteract"))
    --EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))

    --UtilsUI.SetAnimationEventCallBack(self.BuySelect, self:ToFunc("OnClickBuyBtnCb"))
    --UtilsUI.SetAnimationEventCallBack(self.StealSelect, self:ToFunc("OnClickStealBtnCb"))
end

function FightGoodsInteractPanel:__BaseShow()
    self:SetParent(self.mainView.PanelParent.transform)
end

function FightGoodsInteractPanel:__Show()
    self.Root:SetActive(false)
    self.BuyInteractText_txt.text = TI18N("购买")
    self.StealInteractText_txt.text = TI18N("拿取")
    self.btnListUI = {
        [1] = self.BuySelect,
        [2] = self.StealSelect
    }
    self.BtnOnClickFunc = {
        [1] = self:ToFunc("OnClickBuyBtnCb"),
        [2] = self:ToFunc("OnClickStealBtnCb")
    }
end

function FightGoodsInteractPanel:__ShowComplete()
    self.mainView:AddLoadDoneCount()
end

function FightGoodsInteractPanel:__Hide()
    self.selectIndex = nil
end

function FightGoodsInteractPanel:Update()
    --这里加个对人物距离的判断，当前列表中最近的显示
    if not next(self.uniqueIdList) then return end
    
    local ctrlInstance = BehaviorFunctions.GetCtrlEntity()
    local showInstance
    local checkDistance
    for instanceId, instanceInfo in pairs(self.uniqueIdList) do
        local distance = BehaviorFunctions.GetDistanceFromTarget(ctrlInstance, instanceId)
        if not checkDistance then
            checkDistance = distance
        end
        if not showInstance then
            showInstance = instanceId
        end
        
        if distance < checkDistance then
            checkDistance = distance
            showInstance = instanceId
        end
    end
    if self.showInstance ~= showInstance then
        self.showInstance = showInstance
        self:ShowGoodsInteractInfo(self.uniqueIdList[showInstance], showInstance)
    end
end

function FightGoodsInteractPanel:OnActionInput(key, value)
    if key == FightEnum.KeyEvent.MouseScroll then
        if not self.selectIndex then return end 
        if value.y > 100 then --往上滑
            self:OnScrollUp()
        elseif value.y < -100 then
            self:OnScrollDown()
        end
        self:UpdateInteractSelect()
    end
end

function FightGoodsInteractPanel:OnScrollUp()
    if self.selectIndex > 1 then
        self.selectIndex = self.selectIndex - 1

        if self.selectIndex < 1 then
            self.selectIndex = 1
        end
    end
end

function FightGoodsInteractPanel:OnScrollDown()
    if self.selectIndex >= 1 then
        self.selectIndex = self.selectIndex + 1

        if self.selectIndex > ScrollMaxNum then
            self.selectIndex = ScrollMaxNum
        end
    end
end

function FightGoodsInteractPanel:UpdateInteractSelect()
    for i, v in ipairs(self.btnListUI) do
        v:SetActive(i == self.selectIndex)
    end
end

function FightGoodsInteractPanel:SetInfo()
    if not self.goodsTips then
        self.goodsTips = GoodsInfoTip.New(self.GoodsInfoTip)
    end

    self.goodsTips:SetGoodsInfo(self.info.goods_id,mod.ShopCtrl:GetGoodsList(self.info.shop_id).disCount or 10000)
end

function FightGoodsInteractPanel:ActiveGoodsInteract(interactInfo,instanceId)
    if self.uniqueIdList[instanceId] then return end
    --收到消息塞到列表，不直接显示，update中判断距离最近的，去显示
    self.uniqueIdList[instanceId] = interactInfo
end

function FightGoodsInteractPanel:ShowGoodsInteractInfo(interactInfo, instanceId)
    self.info = interactInfo
    self.instanceId = instanceId
    local goodsList = mod.ShopCtrl:GetGoodsList(interactInfo.shop_id)
    if not goodsList or not goodsList[interactInfo.shop_id] then
        mod.ShopCtrl:GetShopInfo(interactInfo.shop_id)
        EventMgr.Instance:AddListener(EventName.GetEcoGoodsInfo, self:ToFunc("ShowInfo"))
    else
        self:ShowInfo()
    end
    --默认选择第一个
    if not self.selectIndex then
        self.selectIndex = 1
    end
    self:UpdateInteractSelect()
end

function FightGoodsInteractPanel:ShowInfo()
    UtilsUI.SetActive(self.Root,true)
    self:SetInfo()
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
    EventMgr.Instance:AddListener(EventName.ShopListUpdate, self:ToFunc("ShowInfo"))
    EventMgr.Instance:RemoveListener(EventName.GetEcoGoodsInfo, self:ToFunc("ShowInfo"))
    EventMgr.Instance:AddListener(EventName.WorldInteractKeyClick, self:ToFunc("OnClickBtnCb"))
end
 
function FightGoodsInteractPanel:RemoveGoodsInteract(goodsId, instanceId)
    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
    EventMgr.Instance:RemoveListener(EventName.GetEcoGoodsInfo, self:ToFunc("ShowInfo"))
    EventMgr.Instance:RemoveListener(EventName.ShopListUpdate, self:ToFunc("ShowInfo"))
    EventMgr.Instance:RemoveListener(EventName.WorldInteractKeyClick, self:ToFunc("OnClickBtnCb"))
    
    self.info = nil
    self.uniqueIdList[instanceId] = nil
    self.showInstance = nil
    
    --这里在所有物品都退出之后再隐藏界面
    if not next(self.uniqueIdList) then
        self.Root:SetActive(false)
        self.FightGoodsInteractPanel_out:SetActive(false)
    end
end

function FightGoodsInteractPanel:Exit_CallBack()
    self.Root:SetActive(false)
    self.selectIndex = nil
end

function FightGoodsInteractPanel:UpdateCurrencyCount()
    self.goodsTips:RefreshCurrency()
end

function FightGoodsInteractPanel:OnClickBtnCb()
    --选择当前选中的
    if self.BtnOnClickFunc[self.selectIndex] then
        --临时处理音效
        if self.selectIndex == 1 then
            self.BuyInteract_sound:PlayButtonSound()
        else
            self.StealInteract_sound:PlayButtonSound()
        end
        self.BtnOnClickFunc[self.selectIndex]()
    end
end

function FightGoodsInteractPanel:OnClickBuyBtn()
    self.selectIndex = 1
    self:UpdateInteractSelect()
    self:OnClickBtnCb()
end

function FightGoodsInteractPanel:OnClickBuyBtnCb()
    mod.ShopCtrl.goodsId = self.info.goods_id
    self.npcId = ShopConfig.GetShopInfoById(self.info.shop_id).relatenpc_id
    --mod.ShopCtrl:SetShopCamera(self.npcId)
    WindowManager.Instance:OpenWindow(ShopMainWindow, {npcId = self.npcId, shopId = self.info.shop_id, goodsId = self.info.goods_id})
end

function FightGoodsInteractPanel:OnClickStealBtn()
    self.selectIndex = 2
    self:UpdateInteractSelect()
    self:OnClickBtnCb()
end

function FightGoodsInteractPanel:OnClickStealBtnCb()
    Fight.Instance.entityManager:CallBehaviorFun("OnStealEntityGoods", self.info.goods_id,self.instanceId)
    self:RemoveGoodsInteract(self.info.goods_id, self.instanceId)
end


