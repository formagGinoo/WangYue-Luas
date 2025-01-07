PurchaseProxy = BaseClass("PurchaseProxy", Proxy)

function PurchaseProxy:__init()

end

function PurchaseProxy:__InitProxy()
    self:BindMsg("purchase_cfg")
    self:BindMsg("purchase_info")
    self:BindMsg("purchase_buy")
    self:BindMsg("purchase_package_cfg")
    self:BindMsg("purchase_package_page_cfg")
    self:BindMsg("purchase_package_info")
    self:BindMsg("purchase_package_buy")
    self:BindMsg("monthcard_info")
    self:BindMsg("monthcard_buy")
    self:BindMsg("monthcard_reward")
end

function PurchaseProxy:__InitComplete()

end


--[[
//充值配置
message reg_purchase_cfg {
    int32 id = 1,
    int32 item_id = 2, //获得物品id
    int32 item_num = 3, //获得物品数量
    int32 first_item_id = 4, //首次充值额外物品id
    int32 first_item_num = 5, --首次充值额外物品数量
    int32 extra_item_id = 6, //非首次充值额外物品id
    int32 extra_item_num = 7, --非首次充值额外物品数量
    string name = 8, //名称
    string icon = 9, //图表
    string icon_bg = 10, //背景
    string priority = 11, //优先级
}
//充值信息
message req_purchase_info {
    int32  id = 1,
    int32 buy_count = 2, //已购买次数
}

//充值
message reg_purchase_buy {
    int32 id = 1,
}

//礼包配置信息
message resp_purchase_package_cfg {
    int32 id= 1,
    string name = 2,// 名称
    string icon = 3,//图标
    int32 page = 4,// 所属分页
    int32 cost item = 5,// 消耗道具
    int32 cost_item num = 6,// 消耗道具数量
    int32 reward_id = 7,// 奖励id
    int32 buy_limit = 8,// 购买次数限制
    int32 refresh = 9,// 次数限制重置id
    int32 show_tag = 10,// 标签
    int32 show discount = 11,// 显示折扣
    bool soldout_show = 12,// 售罄显示
    int32 priority = 13,// 优先级
}

message resp_purchase_package_page_cfg{
    int32  id = 1,
    string name = 2,// 名称
    int32  priority = 3, / 优先级
}

//礼包购买信息
message reg_purchase_package_info {
    int32 id  1,
    int32 buy_count = 2,// 已购买数量
}

//买礼包
message reg_purchase_package_buy (
    int32 id =  1,
}

//月卡信息
message resp_monthcard_info{
    int32  id = 1,//
    int32 rest_day = 2, //剩余天数
}

//买月卡
message req_monthcard_buy{
    int32 id = 1,
}

// 领取每日奖励
message req_monthcard_reward {
    int32 id = 1;
}
--]]

--充值
function PurchaseProxy:Send_purchase_buy(id)
    return { id = id }
end

--购买礼包
function PurchaseProxy:Send_purchase_package_buy(id)
    return { id = id }
end

--购买月卡
function PurchaseProxy:Send_monthcard_buy(id)
    return { id = id }
end

--领取月卡奖励
function PurchaseProxy:Send_monthcard_reward(id)
    return { id = id }
end

function PurchaseProxy:Recv_purchase_cfg(data)
    mod.PurchaseCtrl:UpdatePurchaseCfg(data)
end

function PurchaseProxy:Recv_purchase_info(data)
    mod.PurchaseCtrl:UpdatePurchaseRecord(data)
end

-- 礼包配置信息
function PurchaseProxy:Recv_purchase_package_cfg(data)
    mod.PurchaseCtrl:UpdatePackageCfg(data)
end

function PurchaseProxy:Recv_purchase_package_page_cfg(data)
    LogTable("Recv_purchase_package_page_cfg", data)
end

-- 礼包购买信息
function PurchaseProxy:Recv_purchase_package_info(data)
    mod.PurchaseCtrl:UpdatePackageRecord(data)
end

function PurchaseProxy:Recv_monthcard_info(data)
    mod.PurchaseCtrl:UpdateMonthInfo(data)
end