AssetsPoolLevel = BaseClass("AssetsPoolLevel", AssetsPool)

local _insert = table.insert
local DataDuplicateLevel = Config.DataDuplicate.data_duplicate_level

function AssetsPoolLevel:__init()
	self.callBackList = {}
end

function AssetsPoolLevel:LoadLevelRes(levelId, loadedCallBack)
	local blackCurtain, blackTime = false, 0
	table.insert(self.callBackList, loadedCallBack)
	local resLoadHelp = FightResuorcesLoadHelp.New()
	local levelConfig = DataDuplicateLevel[levelId]
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
					resLoadHelp:PreloadEntity(generates[i])
				end	
			end

			if levelBehavior.GetStorys then
				local storys = levelBehavior.GetStorys()
				for i = 1, #storys do
					resLoadHelp:PreloadStorys(storys[i])
				end	
			end
			
			if levelBehavior.NeedBlackCurtain then
				blackCurtain,blackTime = levelBehavior.NeedBlackCurtain()
			end	
		end

		local logicPrefab = "Prefabs/Scene/"..levelConfig.scene_logic
		resLoadHelp:AddRes({path = logicPrefab, type = AssetType.Prefab})
	end

	self.loader = AssetBatchLoader.New("AssetsPoolLevel")
    local callback = function()
        self:LoadDone(levelId, resLoadHelp.resList)
        for k, loadedCallBack in pairs(self.callBackList) do
	        loadedCallBack(levelId)
	    end
	    self.callBackList = nil
	    self.resLoaded = true
    end

    self.loader:AddListener(callback)
    self.loader:LoadAll(resLoadHelp.resList)
	return blackCurtain, blackTime or 0.2
end

function AssetsPoolLevel:ClearObjectDirty(gameObject, cloneGameObject)
    Fight.Instance.clientFight.clientEntityManager:ClearGameObjectDirty(gameObject, cloneGameObject)
end

function AssetsPoolLevel:LoadDone(levelId, resList)
	for k, v in pairs(resList) do
		local path = v.path
		local asset = self:Get(path, true)
		if asset.transform then
			self:Cache(path, asset)
		end
	end
end