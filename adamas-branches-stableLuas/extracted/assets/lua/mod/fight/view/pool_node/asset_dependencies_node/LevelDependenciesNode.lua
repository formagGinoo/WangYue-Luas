---@class LevelDependenciesNode
LevelDependenciesNode = BaseClass("LevelDependenciesNode",DependenciesNodeBase)
local DataDuplicateLevel = Config.DataDuplicate.data_duplicate_level
function LevelDependenciesNode:__init(nodeManager,totalAssetPool)
	self.nodeManager = nodeManager
	self.totalAssetPool = totalAssetPool
end

function LevelDependenciesNode:Init()

end


function LevelDependenciesNode:Analyse(key)
	self.name = "Level_"..key
	self.blackCurtain = false
	self.blackTime = 0
	local resLoadHelp = FightResuorcesLoadHelp.New()
	local levelConfig = DataDuplicateLevel[key]
	if levelConfig then
		local levelBehavior = _G[levelConfig.behavior]
		if levelBehavior then
			if levelBehavior.GetUIGenerates then
				local uiGenerates = levelBehavior.GetUIGenerates()
				for i = 1, #uiGenerates do
					resLoadHelp:AddRes({ path = uiGenerates[i], type = AssetType.Prefab })
				end
			end

			if levelBehavior.GetMagics then
				local magics = levelBehavior.GetMagics()
				for i = 1, #magics do
					resLoadHelp:PreloadMagicAndBuffs(magics[i], nil, FightEnum.MagicConfigFormType.Level)
				end
			end

			if levelBehavior.GetGenerates then
				local generates = levelBehavior.GetGenerates()
				for i = 1, #generates do
					resLoadHelp:PreloadEntity(generates[i], false, true)
				end
			end

			if levelBehavior.GetStorys then
				local storys = levelBehavior.GetStorys()
				for i = 1, #storys do
					resLoadHelp:PreloadStorys(storys[i])
				end
			end

			if levelBehavior.NeedBlackCurtain then
				local blackCurtain,blackTime = levelBehavior.NeedBlackCurtain()
				self.blackCurtain = blackCurtain
				self.blackTime = blackTime
			end
		end

		if levelConfig.scene_logic ~= "" then
			local logicPrefab = "Prefabs/Scene/"..levelConfig.scene_logic
			resLoadHelp:AddRes({path = logicPrefab, type = AssetType.Prefab})
		end
	else
		LogError("找不到关卡配置！"..key)
	end
	self.resList = resLoadHelp.resList
end

function LevelDependenciesNode:OnCache()
	self.fight.objectPool:Cache(LevelDependenciesNode,self)
end

function LevelDependenciesNode:__delete()

end