---@class PartenerSkillsDependenciesNode
PartenerSkillsDependenciesNode = BaseClass("PartenerSkillsDependenciesNode",DependenciesNodeBase)

function PartenerSkillsDependenciesNode:Init()

end

function PartenerSkillsDependenciesNode:Analyse(skillId)
	self.name = "PartenerSkill_"..skillId
	if not AssetsNodeManager.AnalyseAssetsCache[self.name] then
		local loaderHelp = FightResuorcesLoadHelp.New()
		loaderHelp:PreloadPartnerSkill(skillId)
		self.resList = loaderHelp.resList
	else
		self.resList = AssetsNodeManager.AnalyseAssetsCache[self.name] 
	end
end

function PartenerSkillsDependenciesNode:OnCache()
	self.fight.objectPool:Cache(PartenerSkillsDependenciesNode,self)
end

function PartenerSkillsDependenciesNode:__delete()

end