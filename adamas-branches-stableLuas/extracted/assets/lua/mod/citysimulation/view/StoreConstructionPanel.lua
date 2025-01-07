StoreConstructionPanel = BaseClass("StoreConstructionPanel", BasePanel)
StoreConstructionPanel.active = true

function StoreConstructionPanel:__init()
    self:SetAsset("Prefabs/UI/CitySimulation/StoreConstructionPanel.prefab")
end

function StoreConstructionPanel:__BindListener()
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function StoreConstructionPanel:__Show()
    self:InitBar()
end

function StoreConstructionPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function StoreConstructionPanel:BlurShowCb()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function StoreConstructionPanel:__Hide()
    self:CacheBar()
end

function StoreConstructionPanel:__delete()

end

-- 初始化货币栏
function StoreConstructionPanel:InitBar()
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)

    local goldID = CitySimulationConfig:GetGoldIconID()
    self.currencyBar:init(self.CurrencyBar, goldID)
end

-- 移除货币栏
function StoreConstructionPanel:CacheBar()
    self.currencyBar:OnCache()
end


function StoreConstructionPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end