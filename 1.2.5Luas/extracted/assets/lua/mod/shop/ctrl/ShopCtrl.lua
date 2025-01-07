---@class ShopCtrl : Controller
ShopCtrl = BaseClass("ShopCtrl", Controller)

local function isSoldOut(a)
    if a.buy_limit == 0 then return false end
    return a.buy_count == a.buy_limit
end

local function sortByPriority(a,b)
    if isSoldOut(a) == isSoldOut(b) then
        return a.priority > b.priority
    else
        return isSoldOut(b)
    end
end

function ShopCtrl:__init()
    self.shopList = {}
    EventMgr.Instance:AddListener(EventName.ShopOpen, self:ToFunc("OpenShop"))
end

function ShopCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.ShopOpen, self:ToFunc("OpenShop"))
end

function ShopCtrl:__InitComplete()

end

function ShopCtrl:GetShopGoodsAndOpenShop(shopId, npcId, camera_params)
    mod.ShopFacade:SendMsg("shop_goods", shopId)
    self.npcId = npcId
    self.camera_params = camera_params
end

function ShopCtrl:GetShopInfo(shopId)
    mod.ShopFacade:SendMsg("shop_goods", shopId)
end

function ShopCtrl:OpenShop(shopId)
    if not self.npcId then
        return
    end

    local npcEntity = BehaviorFunctions.GetNpcEntity(self.npcId)
    local CameraTarget = npcEntity.clientEntity.clientTransformComponent.gameObject.transform:Find("CameraTarget")
    if not CameraTarget then
        CameraTarget = GameObject("CameraTarget")
        npcEntity.clientEntity.clientTransformComponent:SetTransformChild(CameraTarget.transform)
    end

    BehaviorFunctions.SetCameraState(FightEnum.CameraState.NpcShop)
    BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.NpcShop]:SetCameraParam(self.camera_params[1],
            self.camera_params[2], self.camera_params[3], self.camera_params[4], self.camera_params[5])
    BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.NpcShop]:SetMainTarget(CameraTarget.transform)
    WindowManager.Instance:OpenWindow(ShopMainWindow, { shopId = shopId, npcId = self.npcId }, nil, true)
end

function ShopCtrl:UpdateGoodsList(shopId, goodsList)
    if not self.shopList[shopId] then
        self.shopList[shopId] = goodsList
        table.sort(self.shopList[shopId],sortByPriority)
    else
	    for shopKey, value in pairs(self.shopList[shopId]) do
	        for goodsKey, value in pairs(goodsList) do
	            if self.shopList[shopId][shopKey].goods_id == goodsList[goodsKey].goods_id then
	                self.shopList[shopId][shopKey] = goodsList[goodsKey]
	            end
	        end
	    end
	end

    EventMgr.Instance:Fire(EventName.ShopListUpdate, shopId)
end

function ShopCtrl:GetGoodsList(shopId)
    if not self.shopList[shopId] then
        return
    end
    table.sort(self.shopList[shopId],sortByPriority)
    return self.shopList[shopId]
end

function ShopCtrl:GetShopParent(shopParent)
    if not shopParent then
        return
    end
    self.shopParent = shopParent
end