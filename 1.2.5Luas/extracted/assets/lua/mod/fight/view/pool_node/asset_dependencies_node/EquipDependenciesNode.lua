---@class EntityReferenceNode
EquipDependenciesNode = BaseClass("EquipDependenciesNode",DependenciesNodeBase)

function EquipDependenciesNode:__init()
end

function EquipDependenciesNode:Init()

end

function EquipDependenciesNode:OnCache()
	self.fight.objectPool:Cache(EquipDependenciesNode,self)
end

function EquipDependenciesNode:__delete()

end