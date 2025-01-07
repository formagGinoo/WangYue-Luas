
FightResourcesPreload = BaseClass("FightResourcesPreload")

local FirstPreload = true
function FightResourcesPreload:__init(clientFight)
	self.clientFight = clientFight
	self.resLoadHelp = FightResuorcesLoadHelp.New(self:ToFunc("CellLoad"))
end


function FightResourcesPreload:DoPreload(fightData,progress,callback)
	self.clientFight.assetsNodeManager.dynamic = false
	AssetManager.ChangeDeleteAssetInterval(1000)
	--ctx.LoadingPage:Progress(string.format(TI18N("预加载战斗资源(%0.1f%%)"), tostring(1)), 1)
	if LoadPanelManager.Instance then
		LoadPanelManager.Instance:Progress(1)
	end
	self.fightData = fightData
	self.preloadCallback = callback
	self.progressCallback = progress
	self:AnalyseFightData()
end

function FightResourcesPreload:AnalyseFightData()
	self:AnalyseFontData()
	self:AnalyseMapData()
	self:AnalyseUIData()
	self:AnalyseCameraData()
	self:AnalyseCommonData()
	self:AnalysePartnerData()
	self:Load()
end

function FightResourcesPreload:CellLoad()
	self.loadCount = self.loadCount + 1
	local progress = (self.loadCount / self.resCount) * 80
	--Log("FightResourcesPreload:CellLoad() "..progress)
	self.progressCallback(progress)
end

function FightResourcesPreload:AnalyseCameraData()
	self.resLoadHelp:AddRes({path = Config.CameraConfig.ManinCameraPrefab, type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = Config.CameraConfig.DefaultCamera, type = AssetType.Prefab})
end

function FightResourcesPreload:AnalysePartnerData()
	local partnerQualityCfg = Config.DataPartnerQuality.Find
	for _, data in pairs(partnerQualityCfg) do
		self.resLoadHelp:AddRes({path = data.jade_effect, type = AssetType.Prefab})
	end

	local SceneEffectConfig = Config.DataCommonCfg.Find["CatchPartnerSceneEffect"]
	local SceneEffectName = SceneEffectConfig.string_val
	self.resLoadHelp:AddRes({path = SceneEffectName, type = AssetType.Prefab})
end

function FightResourcesPreload:AnalyseFontData()
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/FontRoot.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type1.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type2.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type3.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type4.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type5.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type6.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type7.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type2_w.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type3_w.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type4_w.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type5_w.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/dmg_type6_w.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/effect_type.prefab", type = AssetType.Prefab})
end

function FightResourcesPreload:AnalyseMapData()
	local scenePrefab = "Prefabs/Scene/"..self.fightData.MapConfig.scene_prefab
	self.resLoadHelp:AddRes({path = scenePrefab, type = AssetType.Prefab})

	if self.fightData.MapConfig.map_area_prefab and self.fightData.MapConfig.map_area_prefab ~= "" then
		local mapAreaPath = "Prefabs/Scene/"..self.fightData.MapConfig.map_area_prefab
		self.resLoadHelp:AddRes({path = mapAreaPath, type = AssetType.Prefab})
	end
end

function FightResourcesPreload:AnalyseUIData()
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/LifeBar/LifeBarRoot.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/LifeBar/LifeBarObj.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/LifeBar/MonsterLifeBarObj.prefab", type = AssetType.Prefab})
	-- self.resLoadHelp:AddRes({path = "Prefabs/UI/FightResultWin/FightResultWin.prefab", type = AssetType.Prefab})
	-- self.resLoadHelp:AddRes({path = "Prefabs/UI/FightResultFail/FightResultFail.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightMainUI.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightGuidePanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightSystemPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightInfoPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightTargetInfoPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightJoyStickPanel.prefab", type = AssetType.Prefab})
	--self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightSquareSkillPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightFormationPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightGatherPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightInteractPanel.prefab", type = AssetType.Prefab})
	--self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/Coop/CoopDisplayPanel.prefab", type = AssetType.Prefab})
	--self.resLoadHelp:AddRes({path = "Prefabs/UI/Common/BlurBack.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/HeadInfo/HeadInfoRoot.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/HeadInfo/HeadInfoObj.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Story/StoryDialogWindow.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/FightNewSkillPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Skill/SkillInfoPanel.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/QTE/ClickQTE.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/QTE/HoldQTE.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/QTE/ResistQTE.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/QTE/ScratchQTE.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/QTE/SectionQTE.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/QTE/NewSwitchQTE.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/QTE/DebuffQTE.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/HeadAlertness/HeadAlertnessRoot.prefab", type = AssetType.Prefab})
	--self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/HeadAlertness/ArcAlertness.prefab", type = AssetType.Prefab})
	--self.resLoadHelp:AddRes({path = "Prefabs/UI/Fight/HeadAlertness/DiamondView.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Common/WaitCommandPanel.prefab", type = AssetType.Prefab})

	-- TODO 临时逻辑
	self.resLoadHelp:AddRes({path = "Font/custom/custom/type1.asset", type = AssetType.Asset})
	self.resLoadHelp:AddRes({path = "Font/custom/custom/type2.asset", type = AssetType.Asset})
end

function FightResourcesPreload:AnalyseCommonData()
	if FirstPreload then
		self.resLoadHelp:AddRes({path = "Character/BoneShake/BoneShakeData.asset",holdTime = 99999999, type = AssetType.Object})
		self.resLoadHelp:AddRes({path = "Character/BoneShake/IKFullBodyData.asset",holdTime = 99999999, type = AssetType.Object})
		self.resLoadHelp:AddRes({path = "Character/BoneShake/IKShakeData.asset",holdTime = 99999999, type = AssetType.Object})
		FirstPreload = false
	end

	self.resLoadHelp:AddRes({path = "Prefabs/Collider/Cube.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/Collider/Cylinder.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/Collider/Sphere.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "AssetsData/PostProcessTemplate.asset",holdTime = 99999999, type = AssetType.Object})

	-- load common role behavior
	local commonBehavior = _G["RoleAllParm"]
	if commonBehavior then
		if commonBehavior.GetMagics then
			local magics = commonBehavior.GetMagics()
			if magics then
				for i = 1, #magics do
					self.resLoadHelp:PreloadMagicAndBuffs(magics[i], nil, FightEnum.MagicConfigFormType.Player)
				end
			end
		end
	end
end

function FightResourcesPreload:OnResLoad(loadCount)
	self.loadCount = self.loadCount + loadCount        
    local progress = (self.loadCount / self.resCount) * 80
	self.progressCallback(progress)

	if self.loadCount == self.resCount then
		self:Done()
	end
end

function FightResourcesPreload:Load()

	self.loadCount = 0
    self.resCount = #self.resLoadHelp.resList
	-- 等待实例化完成
	local tempCount =  math.floor(self.resCount / 10)
	self.resCount = self.resCount + tempCount

    local callback = function()
        self:OnResLoad(1)
    end


	local commonLoadDone = function ()
		self:OnResLoad(tempCount)
	end


	self.clientFight.assetsNodeManager:LoadOther("Common",self.resLoadHelp.resList,commonLoadDone,callback)
	
    self:SetLoadEntity()
	self:SetLoadPlayer()
	self:SetLoadGlider()
    --self:SetLoadLevel()

    self:LoadEntity()
	self:LoadPlayer()
	self:LoadGlider()
    --self:LoadLevel()
end

function FightResourcesPreload:SetLoadRole()
	self.loadRoles = {}
	for key, value in pairs(self.fightData.PlayerData) do
		self.loadRoles[key] = value.roleInfo
		self.resCount = self.resCount + #self.loadRoles * 5
	end
end

function FightResourcesPreload:SetLoadPlayer()
	for key, value in pairs(self.fightData.PlayerData) do
		self.resCount = self.resCount + 10
	end
end

function FightResourcesPreload:LoadRole()
	local roleLoaded = function ()
		self:OnResLoad(5)
	end
	local assetsPoolMgr = mod.WorldCtrl.assetsPoolMgr:GetRoleMgr()
	for playerId, roles in pairs(self.loadRoles) do
		for _, value in pairs(roles) do
			local info = {
				weaponId = value.weaponId,
				partnerInfo = value.partnerInfo,
			}
			assetsPoolMgr:LoadRole(playerId, value.roleId, info, roleLoaded, true)
		end
	end
end

function FightResourcesPreload:LoadPlayer()
	local playerLoaded = function ()
		self:OnResLoad(10)
	end
	for key, value in pairs(self.fightData.PlayerData) do
		--self.resCount = self.resCount + 10
		self.clientFight.assetsNodeManager:LoadPlayer(value.Id,playerLoaded)
	end
end

function FightResourcesPreload:SetLoadGlider()
	self.loadGliders = {1000101}
	-- 预留接口
	-- for _, gliderId in pairs(self.fightData.PlayerData[1].glider) do

	-- end

	self.resCount = self.resCount + (#self.loadGliders * 5)
end

function FightResourcesPreload:LoadGlider()
	local gliderLoaded = function ()
		self:OnResLoad(5)
	end

	-- 临时用一下实体池子 后续修改成武器 佩从那种类型
	for _, gliderId in pairs(self.loadGliders) do
		self.clientFight.assetsNodeManager:LoadEntity(gliderId, gliderLoaded)
	end
end

function FightResourcesPreload:SetLoadEntity()
	self.loadEntityIds = {1000000000, 2000, 2001, 600000001, 900000001}
	--local DataHero = Config.DataHeroMain.Find
	--for k, v in pairs(self.fightData.PlayerData[1].heroes) do
		--local entityId = DataHero[v].entity_id
		--table.insert(self.loadEntityIds, entityId)
	--end

	self.resCount = self.resCount + #self.loadEntityIds * 5
end

function FightResourcesPreload:LoadEntity()
	local entityLoaded = function ()
		self:OnResLoad(5)
	end
	
	for k, v in pairs(self.loadEntityIds) do
		self.clientFight.assetsNodeManager:LoadEntity(v, entityLoaded)
	end
end

function FightResourcesPreload:SetLoadLevel()
	self.loadLevelList = {}
	local levelId = self.fightData.MapConfig.level_id
	if levelId > 0 then
		table.insert(self.loadLevelList, levelId)
	end

	local dupId, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
	if dupLevelId then
		table.insert(self.loadLevelList, dupLevelId)
	end

	self.resCount = self.resCount + #self.loadLevelList * 5
end

function FightResourcesPreload:LoadLevel()
	local levelLoaded = function ()
		self:OnResLoad(5)
	end

	for k, v in pairs(self.loadLevelList) do
		self.clientFight.assetsNodeManager:LoadLevel(v, levelLoaded)
	end

	-- if #self.loadLevelList == 0 then
	-- 	self:OnResLoad(0)
	-- end
end


function FightResourcesPreload:InstanceOnce()
	local assets = {}
	local instanceCount = 0
	for k, v in pairs(self.resList) do
		assets[v.path] = self.clientFight.assetsPool:Get(v.path)
		instanceCount = instanceCount + 1
		--local progress = 90 + (instanceCount / self.resCount) * 5
		--self.progressCallback(progress)
	end
	
	instanceCount = 0
	for k, v in pairs(assets) do
		if v.transform then
			self.clientFight.assetsPool:Cache(k,v)
		end
		instanceCount = instanceCount + 1
		--local progress = 95 + (instanceCount / self.resCount) * 5
		--self.progressCallback(progress)
	end
	--collectgarbage("collect")
	--collectgarbage("stop")
	self:Done()
end

function FightResourcesPreload:Generate(path)
	local asset = self.assetLoader:Pop(path)
	return asset
end

function FightResourcesPreload:Done()
	self.clientFight.assetsNodeManager.dynamic = true
	AssetManager.ChangeDeleteAssetInterval(10)
	self.progressCallback(80)
	--self.preloadCallback()
	LuaTimerManager.Instance:AddTimerByNextFrame(1,0,function() self.preloadCallback() end)
end

function FightResourcesPreload:__delete()
	if self.assetLoader ~= nil then
		self.assetLoader:DeleteMe()
		self.assetLoader = nil
	end
	self.fight = nil
	self.resList = nil
	--collectgarbage("restart")
	SceneManager.LoadScene("SceneJumper")
end
