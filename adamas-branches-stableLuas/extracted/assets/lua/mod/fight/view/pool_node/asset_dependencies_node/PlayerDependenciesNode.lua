---@class PlayerDependenciesNode
PlayerDependenciesNode = BaseClass("PlayerDependenciesNode",DependenciesNodeBase)

function PlayerDependenciesNode:Init()

end

function PlayerDependenciesNode:Analyse(key)
	self.name = "Player_"..key
	self.resList = {}
	self.playerInfo = self.nodeManager.fight.playerManager.players[key]
	for i = 1, #self.playerInfo.heroIds do
		local roleId = self.playerInfo.heroIds[i]
		local roleNode = RoleDependenciesNode.New(self.nodeManager,self.totalAssetPool)
		self:AddChildNote(roleId,roleNode)
		roleNode:Analyse(roleId)
	end
	
	local abilityPartner = self.playerInfo.abilityPartner

	if abilityPartner then
		local node = AbilityPartnerDependenciesNode.New(self.nodeManager,self.totalAssetPool)
		local key = "AbilityPartner_".. abilityPartner
		self:AddChildNote(key,node)
		node:Analyse(abilityPartner)
	end
	--Glider
end

function PlayerDependenciesNode:OnCache()
	self.fight.objectPool:Cache(PlayerDependenciesNode,self)
end

function PlayerDependenciesNode:__delete()

end