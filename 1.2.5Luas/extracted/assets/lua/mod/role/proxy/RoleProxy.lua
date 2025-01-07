RoleProxy = BaseClass("RoleProxy",Proxy)

function RoleProxy:__init()

end

function RoleProxy:__InitProxy()
	self:BindMsg("hero_list")
	self:BindMsg("hero_lev_up")
	self:BindMsg("hero_stage_up")
	self:BindMsg("hero_star_up")
	self:BindMsg("hero_skill_lev_up")
	self:BindMsg("hero_use")
	self:BindMsg("hero_sync_property")
	self:BindMsg("hero_change_weapon")
	self:BindMsg("weapon_lev_up")
	self:BindMsg("weapon_stage_up")
	self:BindMsg("weapon_refine")
	self:BindMsg("hero_equip_partner")
	self:BindMsg("hero_unequip_partner")
	self:BindMsg("partner_lev_up")
	self:BindMsg("partner_skill_lev_up")
    self:BindMsg("statistic_info")
end

function RoleProxy:__InitComplete()

end

-- 更新列表信息
function RoleProxy:Recv_hero_list(data)
	--[[
	repeated struct_hero hero_list = 1;
	
	message struct_hero_skill {
		int32 order_id = 1;
		int32 lev = 2;
	}

	message struct_hero {
		int64 id = 1;

		int32 lev = 2;
		int32 exp = 3;
		int32 stage = 4;

		int32 star = 5;

		repeated struct_hero_skill skill_list = 10;
	}

	]]
	mod.RoleCtrl:UpdateRoleList(data.hero_list)

end

-- 升级
function RoleProxy:Send_hero_lev_up(heroId, itemList)
	--[[
	int32 hero_id = 1;
	repeated struct_kv item_list = 2;
	
	message struct_kv {
		int32 key = 1;
		int32 value = 2;
	}

	]]
	return {hero_id = heroId, item_list = itemList}
end

function RoleProxy:Recv_hero_lev_up(data)
	--data.error_code
	EventMgr.Instance:Fire(EventName.HeroLevelUp, data)
	print("RoleProxy:Recv_hero_lev_up:", data.error_code)
end

-- 突破
function RoleProxy:Send_hero_stage_up(heroId)
	return {hero_id = heroId}
end

function RoleProxy:Recv_hero_stage_up(data)
	--data.error_code
	EventMgr.Instance:Fire(EventName.HeroStageUp, data)
	print("RoleProxy:Recv_hero_stage_up:", data.error_code)
end

-- 升星
function RoleProxy:Send_hero_star_up(heroId)
	return {hero_id = heroId}
end

function RoleProxy:Recv_hero_star_up(data)
	--data.error_code
	print("RoleProxy:Recv_hero_star_up:", data.error_code)
end

-- 技能升级
function RoleProxy:Send_hero_skill_lev_up(heroId, skillOrderId)
	return {hero_id = heroId, skill_order_id = skillOrderId}
end

function RoleProxy:Recv_hero_skill_lev_up(data)
	--data.error_code
	print("RoleProxy:Recv_hero_skill_lev_up:", data.error_code)
end

function RoleProxy:Send_hero_use(id)
	return {id = id}
end

function RoleProxy:Recv_hero_use(data)
	mod.RoleCtrl:SetCurUseRole(data.id)
end

function RoleProxy:Send_hero_sync_property(id, propertyList)
	return {hero_id = id, property_list = propertyList}
end

function RoleProxy:Send_hero_change_weapon(id, weapon_id)
	return {id = id, weapon_id = weapon_id}
end

function RoleProxy:Send_weapon_lev_up(weapon_id,weapon_id_list, item_list)
	return {weapon_id = weapon_id, weapon_id_list = weapon_id_list, item_list = item_list}
end
function RoleProxy:Recv_weapon_lev_up(data)
	EventMgr.Instance:Fire(EventName.WeaponUpgradeComplete)
end

function RoleProxy:Send_weapon_stage_up(weapon_id)
	return {weapon_id = weapon_id}
end

function RoleProxy:Send_weapon_refine(weapon_id, weaponList)
	return{weapon_id = weapon_id, weapon_id_list = weaponList}
end

function RoleProxy:Send_hero_equip_partner(roleId, partnerId)
	return {id = roleId, partner_id = partnerId}
end

function RoleProxy:Send_hero_unequip_partner(roleId)
	return {id = roleId}
end

function RoleProxy:Send_partner_lev_up(partnerId, partnerIdList)
	return {partner_id = partnerId, partner_id_list = partnerIdList}
end

function RoleProxy:Send_partner_skill_lev_up(partnerId, skillId)
	return {partner_id = partnerId, skill_id = skillId}
end

-- 统计的数据
function RoleProxy:Recv_statistic_info(data)
	mod.RoleCtrl:RecvStatisticData(data)
end
