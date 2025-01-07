---@class AbilityPartnerDependenciesNode
AbilityPartnerDependenciesNode = BaseClass("AbilityPartnerDependenciesNode",DependenciesNodeBase)

function AbilityPartnerDependenciesNode:Init()

end

function AbilityPartnerDependenciesNode:Analyse(key)
	self.name = "AbilityPartner_"..key
	local partnerData = mod.BagCtrl:GetPartnerData(key)
	local partnerEntityId = RoleConfig.GetPartnerEntityId(partnerData.template_id)
    local loaderHelp = FightResuorcesLoadHelp.New()
	loaderHelp:PreloadEntity(partnerEntityId, false, true)
	self.resList = loaderHelp.resList
end

function AbilityPartnerDependenciesNode:OnCache()
	self.fight.objectPool:Cache(AbilityPartnerDependenciesNode,self)
end

function AbilityPartnerDependenciesNode:__delete()

end