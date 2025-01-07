---@class FightData
FightData = BaseClass("FightData")
--[[
FightData =
{
	MapId = 1001,
	PlayerData = {
		[1] = {
			Id = 0,
			Entites = 
				[1] = {
						1001 = {}
					}
		}
	}
}
--]]

function FightData:__init()
	self.fightData = {}
end

function FightData:BuildFightData(heroesData, mapId)
	self.fightData.MapConfig = Config.DataMap.data_map[mapId]
	self.fightData.PlayerData = {[1] = {Id = 1,heroes = {}, roleInfo = {}}}
	for k, id in ipairs(heroesData) do
		local playData = self.fightData.PlayerData[1]
		playData.heroes[k] = id
		local partnerId, skills = mod.RoleCtrl:GetRolePartnerEntityId(id)
		local weaponId = mod.BagCtrl:GetWeaponData(mod.RoleCtrl:GetRoleWeapon(id), id).template_id
		local info = {}
		info.roleId = id
		info.weaponId = weaponId
		if partnerId then
			info.partnerInfo = {partnerId = partnerId, skills = skills}
		end
		
		playData.roleInfo[k] = info
	end
	return self.fightData
end

function FightData:GetFightData()
	return self.fightData
end

function FightData:__delete()
end

