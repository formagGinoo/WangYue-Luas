EntrustmentEntryPanel = BaseClass("EntrustmentEntryPanel", BasePanel)
EntrustmentEntryPanel.active = true

function EntrustmentEntryPanel:__init()
    self:SetAsset("Prefabs/UI/CitySimulation/EntrustmentEntryPanel.prefab")
end

function EntrustmentEntryPanel:__BindListener()
    self.EmployeeStoreButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenEmployeeStorePanel"))
    self.GoBuyBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenBuyShopWindow"))
    self.GoShopBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenCitySimulationMainWindow"))

    EventMgr.Instance:AddListener(EventName.RefreshShopInfoArea, self:ToFunc("RefreshShopInfoArea"))
end

function EntrustmentEntryPanel:__Show()
    self:InitBar()

    self.shopItemDic = {}               -- index -> SingleShopItem映射表
    self.shopConfigData = {}            -- index -> 商店信息映射表
    self.entrustmentItemDic = {}        -- index -> SingleEntrustmentItem映射表
    self.entrustmentConfigData = {}     -- index -> 委托信息映射表
    self.entrustmentItemObjList = {}    -- SingleEntrustmentItem对象表
    self.currShopId = 0                 -- 选中店铺ID
    self.currShopEntrustmentLevel = 0   -- 选中店铺委托评级
    self.currShopLevel = 1              -- todo 选中店铺等级（测试变量
    self.needGuide = false              -- todo 引导（测试变量
    self.haveBoughtShop = false         -- todo 是否购买（测试变量
    self.ItemTransform = self.needGuide and self.GuideContent_rect or self.SingleItemContent_rect
    self.shopConfigData = CitySimulationConfig:GetShopPositionList()

    -- 取第一个商店Item作为默认ID
    if self.shopConfigData[1] then
        self.currShopId = self.shopConfigData[1].store_id
        self.currShopEntrustmentLevel = mod.CitySimulationCtrl:GetCurrEntrustmentLevel(self.currShopId)
        
        local len = TableUtils.GetTabelLen(self.shopConfigData)
        self:RefreshShopItemList(len)

        -- 初始化第一个商店Item选择状态
        if self.shopItemDic[1] then
            local item = self.shopItemDic[1]
            item:SetSelectState(true)
        end

        -- 新手引导不需要显示状态栏
        self.GuideArea:SetActive(self.needGuide)
        self.CommonArea:SetActive(not self.needGuide)
        self:RefreshEntrustmentInfoList(self.currShopId)
        if not self.needGuide then self:UpdateManagementStateBar(self.currShopId) end
    end
end

function EntrustmentEntryPanel:__Hide()
    self:CacheBar()
    
    self.ShopScrollView_recyceList:CleanAllCell()
    
    -- 释放实例化的委托对象
    self:DeleteEntrustmentItems()
end

function EntrustmentEntryPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.RefreshShopInfoArea, self:ToFunc("RefreshShopInfoArea"))


    
    -- 释放实例化对象
    self:DeleteEntrustmentItems()

    self.shopItemDic = nil
    self.shopConfigData = nil
    self.entrustmentItemDic = nil
    self.entrustmentConfigData = nil
    self.entrustmentItemObjList = nil
end

-- 刷新店铺列表
function EntrustmentEntryPanel:RefreshShopItemList(_len)
    if not self.ShopScrollView_recyceList then
        return 
    end
    
    self.ShopScrollView_recyceList:CleanAllCell()
    self.ShopScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateShopItem"))
    self.ShopScrollView_recyceList:SetCellNum(_len)
end

-- 更新商铺Item
function EntrustmentEntryPanel:UpdateShopItem(_index, _obj)
    if not _obj then
        return
    end
    
    if not self.shopItemDic[_index] then
        self.shopItemDic[_index] = SingleShopItem.New()
    end
    
    local data = self.shopConfigData[_index]
    data.index = _index
    data.object = _obj
    
    local item = self.shopItemDic[_index]
    item:UpdateData(data)
end

-- 店铺切换时更新显示
function EntrustmentEntryPanel:RefreshShopInfoArea(_shopID)
    if _shopID == self.currShopId then
        return
    end

    self.currShopId = _shopID
    self.currShopEntrustmentLevel = mod.CitySimulationCtrl:GetCurrEntrustmentLevel(self.currShopId)
    
    self:RefreshShopItemSelectState()
    
    self:UpdateManagementStateBar()
    
    self:RefreshEntrustmentInfoList()
end

-- 刷新商店Item选择状态
function EntrustmentEntryPanel:RefreshShopItemSelectState()
    for _, item in pairs(self.shopItemDic) do
        item:SetSelectState(item.id == self.currShopId)
    end
end

-- 更新经营状态栏
function EntrustmentEntryPanel:UpdateManagementStateBar()
    local data = CitySimulationConfig:GetCityOperateUpData(self.currShopId, self.currShopLevel)
    if not data then 
        return 
    end
    
    if self.haveBoughtShop then
        self.GoBuyPart:SetActive(false)
        self.GoShopPart:SetActive(true)

        self.DailyBusinessText_txt.text = TI18N("每日营业")
        self.ManagementStateText_txt.text = TI18N("经营状态")
        self.GoShopBtnText_txt.text = TI18N("前往经营")
        self.IncomeValue_txt.text = data.store_up
        self.ManagementState_txt.text = "C"  -- todo 看一下怎么算出来的
    else
        self.GoBuyPart:SetActive(true)
        self.GoShopPart:SetActive(false)

        self.GoBuyText_txt.text = TI18N("店铺暂未购买")
        self.GoBuyNeedText_txt.text = TI18N("购买需要") .. ": "
        self.GoBuyBtnText_txt.text = TI18N("前往购买")
        self.CostValue_txt.text = data.store_up
    end
end

-- 刷新委托列表
function EntrustmentEntryPanel:RefreshEntrustmentInfoList()
    self:DeleteEntrustmentItems()
    
    self.entrustmentItemDic = {}
    self.entrustmentConfigData = {}
    self.entrustmentItemObjList = {}
    
    self.entrustmentConfigData = CitySimulationConfig:GetCommonEntrustmentJumpInfoByShopID(self.currShopId)
    for index, data in pairsByKeys(self.entrustmentConfigData) do
       
        self.entrustmentItemDic[index] = SingleEntrustmentItem.New()
        local go = GameObject.Instantiate(self.SingleEntrustmentItem)
        go.transform:SetParent(self.ItemTransform)
        table.insert(self.entrustmentItemObjList, go)
        
        local entrustDuplicateInfo = CitySimulationConfig:GetEntrustmentDuplicateInfoByID(data.entrust_id, self.currShopEntrustmentLevel, 1) --todo 奖励ID先用假数据测试
        local info = data
        info.index = index
        info.object = go
        info.parentWindow = self.parentWindow
        info.duplicateID = entrustDuplicateInfo.system_duplicate_id
        info.cost = entrustDuplicateInfo.cost
        info.rewardID = entrustDuplicateInfo.show_reward
        info.duplicateDropRewardID = entrustDuplicateInfo.drop
        info.shopID = self.currShopId

        self.entrustmentItemDic[index]:UpdateData(info)
    end
end

-- 删除委托列表内对象
function EntrustmentEntryPanel:DeleteEntrustmentItems()
    -- 删除Item内实例化对象
    if self.entrustmentItemDic then
        for _, item in pairs(self.entrustmentItemDic) do
            item:Delete()
        end
    end

    -- 删除Item对象
    if self.entrustmentItemObjList then
        for i = 1, #self.entrustmentItemObjList do
            GameObject.Destroy(self.entrustmentItemObjList[i])
        end
    end
end

function EntrustmentEntryPanel:OnClick_OpenEmployeeStorePanel()
    print("Click EmployeeStore Button")
end

function EntrustmentEntryPanel:OnClick_OpenBuyShopWindow()
    WindowManager.Instance:OpenWindow(CitySimulationMainWindow, {shopId = self.currShopId})
    
    WindowManager.Instance:CloseWindow(self.parentWindow)
end

function EntrustmentEntryPanel:OnClick_OpenCitySimulationMainWindow()
    print("OnClick_OpenCitySimulationMainWindow")
end

-- 初始化货币和体力栏
function EntrustmentEntryPanel:InitBar()
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.vitBar = Fight.Instance.objectPool:Get(CurrencyBar)

    local goldID = CitySimulationConfig:GetGoldIconID()
    local VITID = CitySimulationConfig:GetVITIconID()
    self.currencyBar:init(self.CurrencyBar, goldID)
    self.vitBar:init(self.VITBar, VITID)
end

-- 移除货币栏和体力栏
function EntrustmentEntryPanel:CacheBar()
    self.currencyBar:OnCache()
    self.vitBar:OnCache()
end

-- 顺序输出迭代器
function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
        a[#a+1] = n
    end
    table.sort(a)
    local i = 0
    return function()
        i = i + 1
        return a[i], t[a[i]]
    end
end