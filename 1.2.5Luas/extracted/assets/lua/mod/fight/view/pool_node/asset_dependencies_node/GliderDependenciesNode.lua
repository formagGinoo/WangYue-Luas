---@class GliderDependenciesNode
GliderDependenciesNode = BaseClass("GliderDependenciesNode",DependenciesNodeBase)

function GliderDependenciesNode:__init(nodeManager,totalAssetPool)
	self.nodeManager = nodeManager
	self.totalAssetPool = totalAssetPool
end
function GliderDependenciesNode:Init()

end

function GliderDependenciesNode:Analyse(key)
	self.name = "Glider_"..key
	local loaderHelp = FightResuorcesLoadHelp.New()
	loaderHelp:PreloadGlider(key)
	self.resList = loaderHelp.resList
end

function GliderDependenciesNode:OnCache()
	self.fight.objectPool:Cache(GliderDependenciesNode,self)
end

function GliderDependenciesNode:__delete()

end