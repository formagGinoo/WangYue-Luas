---@class RoleDependenciesNode
RoleDependenciesNode = BaseClass("RoleDependenciesNode",DependenciesNodeBase)

function RoleDependenciesNode:Init()

end

function RoleDependenciesNode:Analyse(key)
	self.name = "Role_"..key
	local loaderHelp = FightResuorcesLoadHelp.New()
	
	local roleEntityId = RoleConfig.GetRoleEntityId(key) or key
	
	loaderHelp:PreloadEntity(roleEntityId, false, true)
	self.resList = loaderHelp.resList
	local partnerId = mod.RoleCtrl:GetRolePartner(key)

	local uniqueId = mod.RoleCtrl:GetRoleWeapon(key)
	local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, key)
	local weaponNote = WeaponDependenciesNode.New(self.nodeManager,self.totalAssetPool)
	local weaponKey = "Weapon_"..weaponData.unique_id
	self:AddChildNote(weaponKey,weaponNote)
	weaponNote:Analyse(weaponData.template_id)
	
	if partnerId then
		local partenerNode = PartenerDependenciesNode.New(self.nodeManager,self.totalAssetPool)
		local partnerKey = "Partner_"..partnerId
		self:AddChildNote(partnerKey,partenerNode)
		partenerNode.roleId = key
		partenerNode:Analyse(partnerId)
	end
	
end

function RoleDependenciesNode:OnCache()
	self.fight.objectPool:Cache(RoleDependenciesNode,self)
end

function RoleDependenciesNode:__delete()

end