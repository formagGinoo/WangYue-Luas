ShopBuyPanel = BaseClass("ShopBuyPanel", BasePanel)

--初始化
function ShopBuyPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Shop/ShopBuyPanel.prefab")
    self.parent = parent
end

--添加监听器
function ShopBuyPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CancelButton_btn,self:ToFunc("Close_HideCallBack"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Close_HideCallBack"))

    self.ConfirmButton_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmBuyItem"))
    self.MinusButton_btn.onClick:AddListener(self:ToFunc("OnClick_MinusButton"))
    self.PlusButton_btn.onClick:AddListener(self:ToFunc("OnClick_PlusButton"))
    self.BuyItemSlider_sld.onValueChanged:AddListener(self:ToFunc("OnValueChanged_BuyItemSlider"))
end

function ShopBuyPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ShopBuyGoods, self:ToFunc("UpdateData"))
end

--缓存对象
function ShopBuyPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ShopBuyPanel:__Create()

end

function ShopBuyPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ShopBuyGoods, self:ToFunc("UpdateData"))
    PoolManager.Instance:Push(PoolType.class, "CommonItem", self.commonItem)
end

function ShopBuyPanel:__Hide()
end

function ShopBuyPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function ShopBuyPanel:__Show(args)
    if not self.args or not self.args.itemId or not self.args.shopId then
        return
    end
    -- 从服务器传来的
    self.goodsList = mod.ShopCtrl:GetGoodsList(self.args.shopId)
    for key, value in pairs(self.goodsList) do
        if value.item_id == self.args.itemId then
            self:UpdateData(self.goodsList[key])
        end
    end
end

function ShopBuyPanel:UpdateData(goodsItem)
    local itemConfig = ItemConfig.GetItemConfig(goodsItem.item_id)
    self.goodsItem = goodsItem
    self.itemConfig = itemConfig
    self.ItemName_txt.text = itemConfig.name .. "x" .. goodsItem.item_count
    self:UpdateLimitBuy(goodsItem)
    self:UpDateTime(goodsItem)
    self:UpdataBuyInfo(goodsItem, itemConfig)
    self:UpdataDataByType(goodsItem, itemConfig)
    self:InitCommonItem(goodsItem)
    self:InitCurrencyBar(goodsItem.consume[1].key)
end

function ShopBuyPanel:UpdateLimitBuy(goodsItem)
    -- 不限购就不显示了
    if not (goodsItem.buy_limit == 0)  then
        self.LimitTxt_txt.text =  TI18N("限购") .. goodsItem.buy_limit - goodsItem.buy_count .. "/" .. goodsItem.buy_limit
    else
        self.LimitTxt_txt.text =  ""
    end
end

function ShopBuyPanel:UpDateTime(goodsItem)
    if goodsItem.refresh_id ~= 0 then
        local resettime = TimeUtils.GetRefreshTimeByRefreshId(goodsItem.refresh_id)
        if resettime.days > 0 then
            self.TimeLeftTxt_txt.text = resettime.days .. "天" .. resettime.hours .. "时"
        else
            self.TimeLeftTxt_txt.text = resettime.hours .. "时" .. resettime.minutes .. "分"	
        end
        self.TimeLeftIcon:SetActive(true)
    else
        self.TimeLeftTxt_txt.text = ""
        self.TimeLeftIcon:SetActive(false)
    end
end

function ShopBuyPanel:UpdataBuyInfo(goodsItem, itemConfig)
    local currencyId = goodsItem.consume[1].key
    self.itemPrice = goodsItem.consume[1].value
    self.currencyConfig = ItemConfig.GetItemConfig(currencyId)
    self.itemCondition = goodsItem.condition
    self.nowCurrencyCount = BagCtrl:GetItemCountById(currencyId)
    -- 当前限购数量
    local canBuyNumByLimit = goodsItem.buy_limit - goodsItem.buy_count
    if canBuyNumByLimit <= 0 then
        canBuyNumByLimit = 0
    end
    if goodsItem.buy_limit == 0 then
        canBuyNumByLimit = math.huge
    end
    -- 当前买得起的数量
    local canBuyNumByPrice = math.floor(self.nowCurrencyCount / self.itemPrice)
    local maxValue = canBuyNumByPrice < 1 and 1 or math.min(canBuyNumByPrice, canBuyNumByLimit)
    self.BuyNum_txt.text = maxValue
    self.BuyItemSlider_sld.minValue = 1
    --无限购物品特殊处理
    if canBuyNumByLimit == math.huge then
        self.BuyItemSlider_sld.maxValue = canBuyNumByPrice
        self.MaxNum_txt.text = canBuyNumByPrice
    else
        self.BuyItemSlider_sld.maxValue = (canBuyNumByLimit == 0 or canBuyNumByPrice == 0) and 1 or maxValue
        self.MaxNum_txt.text = (canBuyNumByLimit == 0 or canBuyNumByPrice == 0) and 1 or maxValue
    end
    self.BuyItemSlider_sld.value = maxValue > 0 and 1
    self.MinNum_txt.text = 1
    
    SingleIconLoader.Load(self.ConsumeIcon, ItemConfig.GetItemIcon(self.currencyConfig.id))
    if self.BuyItemSlider_sld.maxValue == self.BuyItemSlider_sld.minValue and
    -- 只能买一个
    self.BuyItemSlider_sld.maxValue == 1 then
        self:SetSliderFull()
    end
    -- 买不起一个/限购了
    if canBuyNumByLimit == 0 or (self.nowCurrencyCount / self.itemPrice) < 1 then
        self:SetButtonActive(false)
        self:SetSliderFull()
    else
        self:SetButtonActive(true)
    end
end

function ShopBuyPanel:InitCurrencyBar(type)
    if self.currencyBar or not type then
        return
    end
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.currencyBar:init(self.CurrencyBar, type)
end

function ShopBuyPanel:SetButtonActive(active)
    self.ConfirmBtn:SetActive(active)
    self.CanNotPressBtn:SetActive(not active)
end

function ShopBuyPanel:SetSliderFull()
    self.MinusButton_btn.interactable = false
    self.PlusButton_btn.interactable = false
    self.sliderIsfull = true
    self.BuyItemSlider_sld.maxValue = 1.01
    self.BuyItemSlider_sld.value = 1.01
    self.BuyItemSlider_sld.interactable = false
end

function ShopBuyPanel:UpdataDataByType(goodsItem, itemConfig)
    local type = ItemConfig.GetItemType(goodsItem.item_id)
    if type == BagEnum.BagType.Partner then
        self.ItemType_txt.text = RoleConfig.GetPartnerSkillTypeConfig(itemConfig.skill_type).name
        self.ItemDescTxt_txt.text = itemConfig.desc
    elseif type == BagEnum.BagType.Weapon then
        self.ItemType_txt.text = RoleConfig.GetWeaponTypeConfig(itemConfig.type).type_name
        self.ItemDescTxt_txt.text = itemConfig.desc
    elseif type == BagEnum.BagType.Item then
        self.ItemType_txt.text = ItemConfig.GetItemTypeConfig(itemConfig.type).type_name
        self.ItemDescTxt_txt.text = itemConfig.desc
    elseif type == BagEnum.BagType.Role then
        self.ItemType_txt.text = TI18N("脉者")
        self.ItemDescTxt_txt.text = itemConfig.detail_desc
    else
        self.ItemType_txt.text = ""
        self.ItemDescTxt_txt.text = ""
    end
end

function ShopBuyPanel:InitCommonItem(goodsItem)
    if self.commonItem then
        self:UpdateCommonItem(goodsItem)
        return
    end
    self.curItemData = {template_id = goodsItem.item_id, count = goodsItem.item_count}
    self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not self.commonItem then
        self.commonItem = CommonItem.New() 
    end
    self.commonItem:InitItem(self.CommonItem, self.curItemData, true)
end

function ShopBuyPanel:UpdateCommonItem(goodsItem)
    if not self.commonItem then
        return
    end
    self.curItemData = {template_id = goodsItem.item_id, count = "x"..goodsItem.item_count}
    self.commonItem:SetItem(self.curItemData)
    self.commonItem:Show()
end

function ShopBuyPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(self)
end

function ShopBuyPanel:OnClick_ConfirmBuyItem()
    if not self.buyItemCount then
        self.buyItemCount = math.floor(self.BuyItemSlider_sld.value)
    end
    if not Fight.Instance.conditionManager:CheckConditionByConfig(self.itemCondition) then
        PanelManager.Instance:ClosePanel(self)
        return
    end
    mod.ShopFacade:SendMsg("shop_goods_buy", self.goodsItem.goods_id, self.buyItemCount)
    PanelManager.Instance:ClosePanel(self)
end

function ShopBuyPanel:OnClick_MinusButton()
    if not self.BuyItemSlider_sld or self.BuyItemSlider_sld.value <= 0  then
        return
    end
    if self.sliderIsfull == true then
        return
    end
    self.BuyItemSlider_sld.value = self.BuyItemSlider_sld.value - 1
    self.BuyNum_txt.text = math.floor(self.BuyItemSlider_sld.value)
    self:UpdateItemSliderValue()
end
function ShopBuyPanel:OnClick_PlusButton()
    if not self.BuyItemSlider_sld or self.BuyItemSlider_sld.value >= self.BuyItemSlider_sld.maxValue then
        return
    end
    if self.sliderIsfull == true then
        return
    end
    self.BuyItemSlider_sld.value = math.floor(self.BuyItemSlider_sld.value + 1)
    self:UpdateItemSliderValue()
end

function ShopBuyPanel:OnValueChanged_BuyItemSlider()
    self:UpdateItemSliderValue()
end

function ShopBuyPanel:UpdateItemSliderValue()
    local colorCanNotBuy = Color(1,0.36,0.36)
    local colorCanBuy = Color(0.85,0.85,0.85)
    local nowValue = math.floor(self.BuyItemSlider_sld.value)
    self.BuyNum_txt.text = nowValue
    self.ConsumNum_txt.text = self.itemPrice * nowValue
    -- 不够钱了
    if self.nowCurrencyCount < nowValue * self.itemPrice then
        self:SetButtonActive(false)
        self.ConsumNum_txt.color = colorCanNotBuy
    else
        self:SetButtonActive(true)
        self.ConsumNum_txt.color = colorCanBuy
    end
end