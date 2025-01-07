---@class PartenerDependenciesNode
PartenerDependenciesNode = BaseClass("PartenerDependenciesNode",DependenciesNodeBase)

function PartenerDependenciesNode:Init()

end

function PartenerDependenciesNode:Analyse(key)
	self.name = "Partener_"..key
	local loaderHelp = FightResuorcesLoadHelp.New()
	local entityId, skills = mod.RoleCtrl:GetRolePartnerEntityId(self.roleId)
	if entityId then
		loaderHelp:PreloadEntity(entityId)
	end

	self.resList = loaderHelp.resList

	if skills then
		for _, skill in pairs(skills) do
			local levelConfig = RoleConfig.GetPartnerSkillLevelConfig(skill.key, skill.value)
			if levelConfig and levelConfig.fight_magic and next(levelConfig.fight_magic) then
				local skillNode = PartenerSkillsDependenciesNode.New(self.nodeManager,self.totalAssetPool)
				local name = skill.key.."_"..skill.value
				self:AddChildNote(name,skillNode)
				skillNode:Analyse(skill)
			end
		end
	end
end

function PartenerDependenciesNode:OnCache()
	self.fight.objectPool:Cache(PartenerDependenciesNode,self)
end

function PartenerDependenciesNode:__delete()

end