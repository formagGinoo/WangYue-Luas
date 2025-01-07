CitySimulationMainWindow = BaseClass("CitySimulationMainWindow", BaseWindow)
CitySimulationMainWindow.active = true

function CitySimulationMainWindow:__init()
    self:SetAsset("Prefabs/UI/CitySimulation/CitySimulationMainWindow.prefab")

    self.operateUpConfig = {}
    self.operateMainConfig = {}
end

function CitySimulationMainWindow:__CacheObject()
    
end

function CitySimulationMainWindow:__BindListener()
    self.ConstructionBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenConstructionPanel"))
    self.ManagementBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenManagementWindow"))
    self.EntrustmentBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenEntrustmentChoiceWindow"))
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function CitySimulationMainWindow:__Show()
    self.shopId = self.args.shopId
    self.shopLevel = mod.CitySimulationCtrl:GetShopLevel(self.shopId)
    self.operateUpConfig = CitySimulationConfig:GetCityOperateUpData(self.shopId, self.shopLevel)
    self.operateMainConfig = CitySimulationConfig:GetCityOperateMainData(self.shopId)
    
    self.ShopNameText_txt.text = TI18N(self.operateMainConfig.store_name)
    self.ShopLevelValue_txt.text = self.shopLevel .. " " .. TI18N("级")
    self.DailyText_txt.text = TI18N("每日营业")
    self.DailyIncomeValue_txt.text = self.operateUpConfig.store_revenue
    
    self:InitBar()
end

function CitySimulationMainWindow:__Hide()
    self:CacheBar()
end

function CitySimulationMainWindow:__delete()
    
end

function CitySimulationMainWindow:OnClick_OpenConstructionPanel()
    self:OpenPanel(StoreConstructionPanel, {  })
end

function CitySimulationMainWindow:OnClick_OpenManagementWindow()
    WindowManager.Instance:OpenWindow(EmployeeManagementWindow, { shopId = self.shopId})
end

function CitySimulationMainWindow:OnClick_OpenEntrustmentChoiceWindow()
    WindowManager.Instance:OpenWindow(EntrustmentChoiceWindow, { shopId = self.shopId})
end

-- 初始化货币和体力栏
function CitySimulationMainWindow:InitBar()
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.vitBar = Fight.Instance.objectPool:Get(CurrencyBar)

    local goldID = CitySimulationConfig:GetGoldIconID()
    local VITID = CitySimulationConfig:GetVITIconID()
    self.currencyBar:init(self.CurrencyBar, goldID)
    self.vitBar:init(self.VITBar, VITID)
end

-- 移除货币栏和体力栏
function CitySimulationMainWindow:CacheBar()
    self.currencyBar:OnCache()
    self.vitBar:OnCache()
end

function CitySimulationMainWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end