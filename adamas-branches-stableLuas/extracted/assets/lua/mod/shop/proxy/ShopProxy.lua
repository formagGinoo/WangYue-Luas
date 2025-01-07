ShopProxy = BaseClass("ShopProxy",Proxy)

local RewardSrc = {
    shopGoods = 1,      -- 获取商品列表请求返回
    shopGoodsBuy = 2,   -- 购买商品请求返回
    severPush = 3,      -- 服务器主动推送
}

function ShopProxy:__init()

end

function ShopProxy:__InitProxy()
    self:BindMsg("shop_goods")
    self:BindMsg("shop_goods_buy")
end

function ShopProxy:__InitComplete()

end

function ShopProxy:Send_shop_goods(shopId)
    return {shop_id = shopId}
end

function ShopProxy:Recv_shop_goods(data)
    mod.ShopCtrl:UpdateGoodsList(data.shop_id, data.goods_list, data.discount)
    if RewardSrc.shopGoods == data.refresh_type then
        EventMgr.Instance:Fire(EventName.ShopOpen, data.shop_id)
    end
    if RewardSrc.shopGoodsBuy == data.refresh_type then
        EventMgr.Instance:Fire(EventName.ShopBuyGoodComplete)
    end
end

function ShopProxy:Send_shop_goods_buy(goodsId, buyCount)
    return {goods_id = goodsId, buy_count = buyCount}
end

