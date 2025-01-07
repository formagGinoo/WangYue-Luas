ShopMainWindow = BaseClass("ShopMainWindow", BaseWindow)


function ShopMainWindow:__init()
	self:SetAsset("Prefabs/UI/Shop/ShopMainWindow.prefab")
    self.CurrencyBar1 = nil
    self.CurrencyBar2 = nil
end

function ShopMainWindow:__BindListener()
    self:SetHideNode("ShopMainWindow_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close_HideCallBack"),self:ToFunc("OnBack"))
end

function ShopMainWindow:__CacheObject()

end

function ShopMainWindow:__Create()

end

function ShopMainWindow:__delete()
    self.CurrencyBar1 = nil
    self.CurrencyBar2 = nil
    self.CommonBack2_btn.onClick:RemoveAllListeners()
end

function ShopMainWindow:__ShowComplete()
    local panel = ShopConfig.ShopPanel[self.args.shopId].shopPanel
    self.npcPlane = self:OpenPanel(panel,self.args)
end

function ShopMainWindow:__Hide()
end

function ShopMainWindow:__Show()
    self.shopInfo = ShopConfig.GetShopInfoById(self.args.shopId)
    self:InitCurrencyBar()
end

-- 初始化货币栏
function ShopMainWindow:InitCurrencyBar() 
    local curlist = self.shopInfo.cur_item_id 
    self.CurrencyBar1 = Fight.Instance.objectPool:Get(CurrencyBar)
    self.CurrencyBar1:init(self.CurrencyBar_1, curlist[1])
    if curlist[2] == 0 then
        self.CurrencyBar_2:SetActive(false)
    else
        self.CurrencyBar_2:SetActive(true)
        self.CurrencyBar2 = Fight.Instance.objectPool:Get(CurrencyBar)
        self.CurrencyBar2:init(self.CurrencyBar_2, curlist[2])
    end
end

function ShopMainWindow:SetBlurBack(isShow)
    CustomUnityUtils.SetDepthOfFieldBoken(isShow, 0.117, 42, 26)
end

function ShopMainWindow:OnBack()
    self.npcPlane:PlayHideAnim()
end

function ShopMainWindow:Close_HideCallBack()
    WindowManager.Instance:CloseWindow(self)
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
    self:SetBlurBack(false)
end