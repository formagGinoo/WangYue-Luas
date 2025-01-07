TradeProxy = BaseClass("TradeProxy", Proxy)

function TradeProxy:__init()

end

function TradeProxy:__InitProxy()
    self:BindMsg("trade_info")
    self:BindMsg("trade_store_activate")
    self:BindMsg("trade_order")
end

function TradeProxy:Send_trade_info()
    
end

function TradeProxy:Recv_trade_info(data)
    mod.TradeCtrl:RecvStoreInfo(data.store_list)
end

function TradeProxy:Send_trade_store_activate(storeId)
    return {store_id = storeId}
end

function TradeProxy:Send_trade_order(storeId, orderId, itemId)
    return {store_id = storeId, order_id = orderId, item_id = itemId}
end