AssetPurchaseMainWindow = BaseClass("AssetPurchaseMainWindow", BaseWindow)


function AssetPurchaseMainWindow:__init()
	self:SetAsset("Prefabs/UI/AssetPurchase/AssetPurchaseMainWindow.prefab")
end

function AssetPurchaseMainWindow:__BindListener()
    self:BindCloseBtn(self.CloseBtn_btn)
    --self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnCloseBtnClick"))
    self.PurchaseBtn_btn.onClick:AddListener(self:ToFunc("OnPurchaseBtnClick"))
    self.ManageBtn_btn.onClick:AddListener(self:ToFunc("OnManageBtnClick"))
end

function AssetPurchaseMainWindow:__CacheObject()

end

function AssetPurchaseMainWindow:__Create()

end

function AssetPurchaseMainWindow:__delete()
end

function AssetPurchaseMainWindow:__ShowComplete()
    
end

function AssetPurchaseMainWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

function AssetPurchaseMainWindow:__Hide()
    --self.currencyBar:OnCache()
end

function AssetPurchaseMainWindow:__Show()
    if self.args and self.args.needBlurBack then
        self:SetBlurBack()
    end
    self:SetTopInfo()
    self.existingAssetList = mod.AssetPurchaseCtrl:GetExistingAssetInfo()
end

function AssetPurchaseMainWindow:__ShowComplete()
    if not self.existingAssetList or next(self.existingAssetList) == nil then
        self:OnPurchaseBtnClick()
    else
        self:OnManageBtnClick()
    end
end

function AssetPurchaseMainWindow:SetTopInfo()
    self.Title_txt = TI18N("资产中心")
    self:InitCurrencyBar()
    --local timestamp = TimeUtils.GetCurTimestamp()
    local h,m = DayNightMgr.Instance:GetStandardTime()
    local dateStr = string.format("%02d:%02d", h,m)
    self.Time_txt.text = dateStr
end

-- 初始化货币栏
function AssetPurchaseMainWindow:InitCurrencyBar() 
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.currencyBar:init(self.CurrencyBar, 2)
end

function AssetPurchaseMainWindow:OpenBuyInfoPanel(assetInfo)
    UtilsUI.SetActive(self.BottomBtns,false)
    self:OpenPanel(AssetBuyInfoPanel,{assetInfo = assetInfo})
end

function AssetPurchaseMainWindow:OpenAssetAgreementPanel(assetInfo)
    self:OpenPanel(AssetAgreementPanel,{assetInfo = assetInfo})
end

function AssetPurchaseMainWindow:CloseBuyInfoPanel()
    UtilsUI.SetActive(self.BottomBtns,true)
    self:ClosePanel(AssetBuyInfoPanel)
    self:OpenPanel(AssetPurchaseGuidePanel)
end

function AssetPurchaseMainWindow:OnCloseBtnClick()
    WindowManager.Instance:CloseWindow(self)
end

local selectColor = Color(1,1,1,1)
local defauleColor = Color(0.35,0.35,0.4,1)
function AssetPurchaseMainWindow:OnPurchaseBtnClick()
    print("OnPurchaseBtnClick")
    UtilsUI.SetActive(self.BottomBtns,true)
    UtilsUI.SetActive(self.PurchaseBtnSelect,true)
    UtilsUI.SetActive(self.ManageBtnSelect,false)
    self.PurchaseBtnText_txt.color = selectColor
    self.ManageBtnText_txt.color = defauleColor
    if self.AssetExistingPanel then
        self.AssetExistingPanel = self:ClosePanel(AssetExistingPanel)
    end
    self.AssetPurchaseGuidePanel = self:OpenPanel(AssetPurchaseGuidePanel)
end


function AssetPurchaseMainWindow:OnManageBtnClick()
    print("OnManageBtnClick")
    UtilsUI.SetActive(self.BottomBtns,true)
    UtilsUI.SetActive(self.PurchaseBtnSelect,false)
    UtilsUI.SetActive(self.ManageBtnSelect,true)
    self.PurchaseBtnText_txt.color = defauleColor
    self.ManageBtnText_txt.color = selectColor
    if self.AssetPurchaseGuidePanel then
        self:ClosePanel(self.AssetPurchaseGuidePanel)
    end
    self.AssetExistingPanel = self:OpenPanel(AssetExistingPanel,{jumpAssetId = self.args.jumpAssetId})
    self.args.jumpAssetId = nil
end

function AssetPurchaseMainWindow:SetJumpAsset(asset_id)
    self.args.jumpAssetId = asset_id
end

function AssetPurchaseMainWindow:AfterBuyComplete()
    self:ClosePanel(self.AssetPurchaseGuidePanel)
    self:OnManageBtnClick()
end