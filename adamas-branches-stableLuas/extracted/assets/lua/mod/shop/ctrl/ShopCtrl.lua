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
    local shopConfig = ShopConfig.GetShopInfoById(shopId)
    if shopConfig.shop_type == 102 then 
        EventMgr.Instance:Fire(EventName.GetEcoGoodsInfo)
        return
    end

    if shopConfig.shop_type == 103 then
        EventMgr.Instance:Fire(EventName.GetPurchaseExchangeGoods, shopId)
        return
    end

    if shopConfig.shop_type == 101 then 
        if not self.npcId then
            return
        end
    
        self:SetShopCamera()
    
        WindowManager.Instance:OpenWindow(ShopMainWindow, { shopId = shopId, npcId = self.npcId })
    end

end

function ShopCtrl:SetShopCamera(npcId)
    local shopId,condition,camera_params
    if not npcId then 
        npcId = self.npcId
        camera_params = self.camera_params
    else 
        shopId,condition,camera_params = StoryConfig.GetNpcStoreId(npcId)
    end
    local npcEntity = BehaviorFunctions.GetNpcEntity(npcId)
    local CameraTarget = npcEntity.clientTransformComponent.gameObject.transform:Find("CameraTarget")
    if not CameraTarget then
        CameraTarget = GameObject("CameraTarget")
        npcEntity.clientTransformComponent:SetTransformChild(CameraTarget.transform)
    end
    
    BehaviorFunctions.SetCameraState(FightEnum.CameraState.NpcShop)
    BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.NpcShop]:SetCameraParam(camera_params[1],
            camera_params[2], camera_params[3], camera_params[4], camera_params[5])
    BehaviorFunctions.fight.clientFight.cameraManager.states[FightEnum.CameraState.NpcShop]:SetMainTarget(CameraTarget.transform)
end

function ShopCtrl:UpdateGoodsList(shopId, goodsList, disCount)
    if not self.shopList[shopId] then
        self.shopList[shopId] = goodsList
        table.sort(self.shopList[shopId],sortByPriority)
    else
        for _, serverGoods in ipairs(goodsList) do
            local flag = true
            for clineIndex, clineGoods in ipairs(self.shopList[shopId]) do
                if clineGoods.goods_id == serverGoods.goods_id then
                    flag = false
                    self.shopList[shopId][clineIndex] = serverGoods
                    break
                end
            end
            if flag then
                table.insert(self.shopList[shopId], serverGoods)
            end
        end
	end
    self.shopList[shopId].disCount = disCount or 10000
    EventMgr.Instance:Fire(EventName.ShopListUpdate, shopId, true)
end

function ShopCtrl:GetGoodsList(shopId)
    if not self.shopList[shopId] then
        return
    end
    table.sort(self.shopList[shopId],sortByPriority)
    return self.shopList[shopId]
end

function ShopCtrl:GetGoodsInfo(goodsId)
    for _,shop in pairs(self.shopList) do
        for _,goods in ipairs(shop) do
            if goods.goods_id == goodsId then 
                return goods
            end
        end
    end
end

function ShopCtrl:GetDisCountByShopId(id)
    return self.shopList[id].disCount or 10000
end

function ShopCtrl:GetShopParent(shopParent)
    if not shopParent then
        return
    end
    self.shopParent = shopParent
end