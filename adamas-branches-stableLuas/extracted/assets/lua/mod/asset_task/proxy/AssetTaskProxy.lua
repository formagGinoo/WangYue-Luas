AssetTaskProxy = BaseClass("AssetTaskProxy",Proxy)

function AssetTaskProxy:__init()

end

function AssetTaskProxy:__InitProxy()
    self:BindMsg("asset_center_asset_level_up")
end

function AssetTaskProxy:Send_asset_center_asset_level_up(data)
    return data
end
