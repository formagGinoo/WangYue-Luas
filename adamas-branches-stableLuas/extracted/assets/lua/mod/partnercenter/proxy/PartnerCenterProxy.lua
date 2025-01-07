PartnerCenterProxy = BaseClass("PartnerCenterProxy",Proxy)

function PartnerCenterProxy:__init()
    
end

function PartnerCenterProxy:__InitProxy()
    self:BindMsg("asset_center_food_set")
    self:BindMsg("asset_center_work_fetch")
    self:BindMsg("asset_center_work_cancel")
    self:BindMsg("asset_center_work_partner_set")
    self:BindMsg("asset_center_work_partner_replace")
    self:BindMsg("asset_center_partner_set")
    self:BindMsg("asset_center_work_set")
    self:BindMsg("asset_partner_skill_unlock")
end

-- 设置餐桌食物
function PartnerCenterProxy:Send_asset_center_food_set(asset_id,decoration_id,food_list)
    return { asset_id = asset_id , decoration_id = decoration_id,food_list = food_list}
end

--获取物件工作产物
function PartnerCenterProxy:Send_asset_center_work_fetch(asset_id, decoration_id)
    return { asset_id = asset_id , decoration_id = decoration_id}
end

--取消物件工作
function PartnerCenterProxy:Send_asset_center_work_cancel(asset_id, decoration_id)
    return { asset_id = asset_id , decoration_id = decoration_id}
end

-- 修改物件工作月灵
function PartnerCenterProxy:Send_asset_center_work_partner_set(asset_id, decoration_id, partner_list)
    return { asset_id = asset_id, decoration_id = decoration_id, partner_list = partner_list}
end

-- 替换物件工作月灵
function PartnerCenterProxy:Send_asset_center_work_partner_replace(asset_id, decoration_id, old_partner_id, new_partner_id)
    return { asset_id = asset_id, decoration_id = decoration_id, old_partner_id = old_partner_id, new_partner_id = new_partner_id}
end

-- 修改资产上阵月灵
function PartnerCenterProxy:Send_asset_center_partner_set(asset_id,partner_list)
    return { asset_id = asset_id, partner_list = partner_list}
end 

-- 设置物件工作
function PartnerCenterProxy:Send_asset_center_work_set(asset_id, decoration_id, partner_list, work_id, work_amount, product_id)
    return { asset_id = asset_id, decoration_id = decoration_id, partner_list = partner_list, work_id = work_id, work_amount = work_amount, product_id = product_id}
end

function PartnerCenterProxy:Send_asset_partner_skill_unlock(partner_id, skill_id, assist_partner_id)
    return { partner_id = partner_id, skill_id = skill_id, assist_partner_id = assist_partner_id}
end
