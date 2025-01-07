---@class PartenerSkillsDependenciesNode
PartenerSkillsDependenciesNode = BaseClass("PartenerSkillsDependenciesNode",DependenciesNodeBase)

function PartenerSkillsDependenciesNode:Init()

end

function PartenerSkillsDependenciesNode:Analyse(skill)
	self.name = "PartenerSkill_"..skill.key.."_"..skill.value
	local loaderHelp = FightResuorcesLoadHelp.New()
	loaderHelp:PreloadPartnerSkill(skill.key,skill.value)
	self.resList = loaderHelp.resList
end

function PartenerSkillsDependenciesNode:OnCache()
	self.fight.objectPool:Cache(PartenerSkillsDependenciesNode,self)
end

function PartenerSkillsDependenciesNode:__delete()

end