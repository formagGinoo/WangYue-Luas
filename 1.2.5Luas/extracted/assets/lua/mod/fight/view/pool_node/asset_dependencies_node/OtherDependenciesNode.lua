---@class EntityReferenceNode
OtherDependenciesNode = BaseClass("OtherDependenciesNode",DependenciesNodeBase)

function OtherDependenciesNode:Init()

end

function OtherDependenciesNode:OnCache()
	self.fight.objectPool:Cache(OtherDependenciesNode,self)
end

function OtherDependenciesNode:__delete()

end