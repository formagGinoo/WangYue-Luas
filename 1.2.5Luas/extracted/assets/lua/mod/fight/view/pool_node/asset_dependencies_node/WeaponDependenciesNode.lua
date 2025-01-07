---@class WeaponDependenciesNode
WeaponDependenciesNode = BaseClass("WeaponDependenciesNode",DependenciesNodeBase)

function WeaponDependenciesNode:Init()

end

function WeaponDependenciesNode:Analyse(key)
	self.name = "Weapon_"..key
	local loaderHelp = FightResuorcesLoadHelp.New()
	loaderHelp:PreloadWeapon(key)
	self.resList = loaderHelp.resList
end

function WeaponDependenciesNode:OnCache()
	self.fight.objectPool:Cache(WeaponDependenciesNode,self)
end

function WeaponDependenciesNode:__delete()

end