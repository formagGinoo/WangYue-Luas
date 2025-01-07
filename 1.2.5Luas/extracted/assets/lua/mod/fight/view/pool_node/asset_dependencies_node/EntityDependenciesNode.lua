---@class EntityDependenciesNode
EntityDependenciesNode = BaseClass("EntityDependenciesNode",DependenciesNodeBase)

function EntityDependenciesNode:Init()

end

function EntityDependenciesNode:Analyse(key)
	self.name = "Entity_"..key
	local loaderHelp = FightResuorcesLoadHelp.New()
	loaderHelp:PreloadEntity(key)
	self.resList = loaderHelp.resList
end

function EntityDependenciesNode:OnCache()
	self.fight.objectPool:Cache(EntityDependenciesNode,self)
end

function EntityDependenciesNode:__delete()

end