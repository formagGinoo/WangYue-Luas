AssetPurchaseProxy = BaseClass("AssetPurchaseProxy",Proxy)

function AssetPurchaseProxy:__init()

end

function AssetPurchaseProxy:__InitProxy()
    self:BindMsg("asset_center_buy_asset")
    self:BindMsg("asset_center_asset_build_list")
    self:BindMsg("asset_center_decoration_count_list")
    self:BindMsg("asset_center_build_level")
    self:BindMsg("asset_center_work_update")
end

function AssetPurchaseProxy:Send_asset_center_buy_asset(data)
    return data
end

--资产信息初始化回包
function AssetPurchaseProxy:Recv_asset_center_asset_build_list(data)
    mod.AssetPurchaseCtrl:UpdataAssetInfo(data.asset_build_list)
end

function AssetPurchaseProxy:Recv_asset_center_decoration_count_list(data)
    mod.AssetPurchaseCtrl:UpdataAssetDecorationCountList(data)
end

function AssetPurchaseProxy:Recv_asset_center_build_level(data)
    mod.AssetPurchaseCtrl:UpdataAssetLevel(data.asset_id,data.level)
end

--物件更新notify
function AssetPurchaseProxy:Recv_asset_center_work_update(data)
    mod.AssetPurchaseCtrl:UpdataAssetWorkUpdate(data)
end
