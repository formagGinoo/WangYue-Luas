DecorationProxy = BaseClass("DecorationProxy", Proxy)

function DecorationProxy:__init()
    
end

function DecorationProxy:__InitProxy()
    self:BindMsg("asset_center_buy_decoration")
    self:BindMsg("asset_center_change_decoration_pos")
    self:BindMsg("asset_center_decoration_list")

    self:BindMsg("asset_center_decoration_bag_list")
    self:BindMsg("asset_center_decoration_bag_list_del_id")
    self:BindMsg("asset_center_decoration_bag_count_list")
end

function DecorationProxy:Send_asset_center_buy_decoration(asset_id,decoration_template_id,amount)
    return { asset_id = asset_id, decoration_template_id = decoration_template_id, amount = amount }
end

--修改物件坐标信息
function DecorationProxy:Send_asset_center_change_decoration_pos(asset_id,id,pos_info)--pos_info是string类型
    return { asset_id = asset_id, id = id, pos_info = pos_info }
end

--单独更新某个资产物件信息
function DecorationProxy:Recv_asset_center_decoration_list(data)
    local value = data.decoration_list[1]
    if value.pos_info ~="" then
        mod.AssetPurchaseCtrl:AddAssetDecorationBagList(data)
        mod.DecorationCtrl:ChangeDecorationInfo(value)
        local instacneId  = mod.DecorationCtrl:GetEntityByData(value)
        local entity = BF.GetEntity(instacneId)
        if entity then
            Fight.Instance.entityManager.partnerDisplayManager:AddDecorationEntity(value.id,entity,value.template_id)   
        end
        EventMgr.Instance:Fire(EventName.UpdateDecorationNumInAsset)
    end
end

--单独更新物件背包信息(购买或销毁时)
function DecorationProxy:Recv_asset_center_decoration_bag_list (data)
    mod.DecorationCtrl:InitData(data)--decoration_list
end

--单独删除物件背包一个物件(放置时)
function DecorationProxy:Recv_asset_center_decoration_bag_list_del_id(data)
    mod.DecorationCtrl:RemoveDecoration(data)-- only_id
end

--单独更新物件背包数量信息（购买或者收购时）
function DecorationProxy:Recv_asset_center_decoration_bag_count_list(data)
    mod.DecorationCtrl:UpdateDecorationCountList(data)
end