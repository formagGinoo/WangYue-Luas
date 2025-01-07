ShopMainWindow = BaseClass("ShopMainWindow", BaseWindow)


function ShopMainWindow:__init()
	self:SetAsset("Prefabs/UI/Shop/ShopMainWindow.prefab")
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
    self.CommonBack2_btn.onClick:RemoveAllListeners()
end

function ShopMainWindow:__ShowComplete()
    if self.shopInfo.shop_type == 102 then 
        UtilsUI.SetActiveByScale(self.Root,false)
        self.npcPlane = self:OpenPanelByName("EntityShopPanel",self.args)
    else
        UtilsUI.SetActiveByScale(self.Root,true)
        self.npcPlane = self:OpenPanelByName(self.shopInfo.panel_name,self.args)
    end
end
function ShopMainWindow:__Hide()
    self.CurrencyBar1:OnCache()
    if self.CurrencyBar2 then
        self.CurrencyBar2:OnCache()
    end
    InputManager.Instance:MinusLayerCount("UI")
end

function ShopMainWindow:__Show()
    self.shopInfo = ShopConfig.GetShopInfoById(self.args.shopId)
    if self.args.npcId then 
        Fight.Instance.entityManager.npcEntityManager:SetNpcHeadInfoVisible(self.args.npcId, false)
    end
    self:InitCurrencyBar()
    EventMgr.Instance:Fire(EventName.ShowCursor, true)
    InputManager.Instance:AddLayerCount("UI")
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
    self.npcPlane:RemoveTimer()
	if self.npcPlane.PlayHideAnim then
		self.npcPlane:PlayHideAnim()
	end
end

function ShopMainWindow:Close_HideCallBack()
    Fight.Instance.entityManager.npcEntityManager:SetNpcHeadInfoVisible(self.args.npcId, true)
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
    self:SetBlurBack(false)
    Fight.Instance.entityManager:CallBehaviorFun("OnExitShop", self.args.shopId)
    WindowManager.Instance:CloseWindow(self)
    EventMgr.Instance:Fire(EventName.ShowCursor, false)
end