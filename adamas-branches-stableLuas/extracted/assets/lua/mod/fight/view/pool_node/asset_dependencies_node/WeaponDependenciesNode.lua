---@class WeaponDependenciesNode
WeaponDependenciesNode = BaseClass("WeaponDependenciesNode",DependenciesNodeBase)

function WeaponDependenciesNode:Init()

end

function WeaponDependenciesNode:Analyse(key)
	self.name = "Weapon_"..key
	if not AssetsNodeManager.AnalyseAssetsCache[self.name] then
		local loaderHelp = FightResuorcesLoadHelp.New()
		loaderHelp:PreloadWeapon(key)
		self.resList = loaderHelp.resList
		AssetsNodeManager.AnalyseAssetsCache[self.name] = TableUtils.CopyTable(self.resList)
	else
		self.resList = TableUtils.CopyTable(AssetsNodeManager.AnalyseAssetsCache[self.name])
	end
end

function WeaponDependenciesNode:OnCache()
	self.fight.objectPool:Cache(WeaponDependenciesNode,self)
end

function WeaponDependenciesNode:__delete()

end