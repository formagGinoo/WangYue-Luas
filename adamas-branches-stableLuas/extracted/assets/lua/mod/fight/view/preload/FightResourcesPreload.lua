
FightResourcesPreload = BaseClass("FightResourcesPreload")

local FirstPreload = true
function FightResourcesPreload:__init(clientFight)
	self.clientFight = clientFight
	self.resLoadHelp = FightResuorcesLoadHelp.New(self:ToFunc("CellLoad"))
end


function FightResourcesPreload:DoPreload(fightData,progress,callback)
	self.clientFight.assetsNodeManager.dynamic = false
	AssetManager.ChangeDeleteAssetInterval(1000)
	self.fightData = fightData
	self.preloadCallback = callback
	self.progressCallback = progress
	self:AnalyseFightData()
end

function FightResourcesPreload:AnalyseFightData()
	if DebugConfig.ShowLevelLogic then
		self.resLoadHelp:AddRes({path = "CommonEntity/ShowPosition.prefab", type = AssetType.Prefab})
	end

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
	local progress = (self.loadCount / self.resCount)
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
	self.resLoadHelp:AddRes({path = "Prefabs/UI/Font/tips_type.prefab", type = AssetType.Prefab})

end

function FightResourcesPreload:AnalyseMapData()
	local mapConfig = self.fightData.MapConfig
	local scenePrefab = "Prefabs/Scene/"..mapConfig.scene_prefab
	self.resLoadHelp:AddRes({path = scenePrefab, type = AssetType.Prefab})

	--TODO 临时处理 后面任务要用自己的logic
	if mapConfig.id == 10020001 or mapConfig.id == 10020004 or mapConfig.id == 10020005 then
		local logicPath = string.format("Prefabs/Scene/Scene%s/Logic%s.prefab", mapConfig.id, mapConfig.id)
		self.resLoadHelp:AddRes({path = logicPath, type = AssetType.Prefab})
	end

	if self.fightData.MapConfig.map_area_prefab and self.fightData.MapConfig.map_area_prefab ~= "" then
		local mapAreaPath = "Prefabs/Scene/"..self.fightData.MapConfig.map_area_prefab
		self.resLoadHelp:AddRes({path = mapAreaPath, type = AssetType.Prefab})
	end
end
FightResourcesPreload.resPreloadList = 
{
	{path = "Prefabs/UI/Fight/LifeBar/LifeBarRoot.prefab", type = AssetType.Prefab},
	{path = "Prefabs/UI/Fight/LifeBar/LifeBarRoot.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/LifeBar/LifeBarObj.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/LifeBar/MonsterLifeBarObj.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightMainUI.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightGuidePanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightSystemPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightInfoPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightTargetInfoPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightJoyStickPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightFormationPanelV2.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightGatherPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightInteractPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/DrivePanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadInfo/HeadInfoRoot.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadInfo/HeadInfoObj.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/FightNewSkillPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/QTE/ClickQTE.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/QTE/HoldQTE.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/QTE/ResistQTE.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/QTE/ScratchQTE.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/QTE/SectionQTE.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/QTE/NewSwitchQTE.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/QTE/DebuffQTE.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadAlertness/HeadAlertnessRoot.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadAlertness/ArcAlertness.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadAlertness/DiamondView.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadAlertness/MonsterQuestionAlertness.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadAlertness/MonsterWarnAlertness.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadAlertness/NPCSelect.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Fight/HeadAlertness/CarSummon.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Common/CommonLeftTabPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Formation/FormationWindowV2.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Role/RoleMainWindow.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Common/WaitCommandPanel.prefab", type = AssetType.Prefab},
    {path = "Prefabs/UI/Common/ScrollTextTips.prefab", type = AssetType.Prefab},
    {path = "Font/custom/custom/type1.asset", type = AssetType.Asset},
    {path = "Font/custom/custom/type2.asset", type = AssetType.Asset},
	{path = "Prefabs/UI/Common/Curtain.prefab", type = AssetType.Prefab},
	{path = "Prefabs/UI/Common/CommonItem2.prefab", type = AssetType.Prefab},
	{path = "Prefabs/UI/Common/CommonItem.prefab", type = AssetType.Prefab},
	{path = "Prefabs/UI/Fight/FightGrowNotice.prefab", type = AssetType.Prefab},
	{path = "Prefabs/UI/Fight/FightRightTip/FightRightTipPanel.prefab", type = AssetType.Prefab},
}

function FightResourcesPreload:AnalyseUIData()
	for _, res in ipairs(FightResourcesPreload.resPreloadList) do
		if UtilsUI.CheckPCPlatform() then
			res.path = WindowDefine.PCPanel[res.path] or res.path
		end
		self.resLoadHelp:AddRes(res)
		
	end
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
	self.resLoadHelp:AddRes({path = "Prefabs/Collider/CylinderMesh.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/Collider/Sector.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Prefabs/Collider/CylinderMesh_01.prefab", type = AssetType.Prefab})
	self.resLoadHelp:AddRes({path = "Character/Animal/Glider/Huaxiangsan/Huaxiangsan.prefab", type = AssetType.Prefab})
	
	if AssetBatchLoader.UseLocalRes  then
		self.resLoadHelp:AddRes({path = "Prefabs/Others/TimeOfDayRoot.prefab", type = AssetType.Prefab})  
	end
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
    local progress = (self.loadCount / self.resCount)
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
    self:SetLoadLevel()

    self:LoadEntity()
	self:LoadPlayer()
	self:LoadGlider()
    self:LoadLevel()
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
	self.resCount = self.resCount + (#self.loadGliders * 5)
end

function FightResourcesPreload:LoadGlider()
	local gliderLoaded = function ()
		self:OnResLoad(5)
	end

	-- 临时用一下实体池子 后续修改成武器 月灵那种类型
	for _, gliderId in pairs(self.loadGliders) do
		self.clientFight.assetsNodeManager:LoadEntity(gliderId, gliderLoaded)
	end
end

function FightResourcesPreload:SetLoadEntity()
	self.loadEntityIds = {1000000000, 2000, 2001, 2002, 600000001, 900000001}
	
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
	if not LoginCtrl.IsInGame() then
		self.loadLevelList = {}
		return
	end
	self.loadLevelList = {101010101}
	--local levelId = self.fightData.MapConfig.level_id
	--if levelId > 0 then
		--table.insert(self.loadLevelList, levelId)
	--end

	--local dupId, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
	--if dupLevelId then
		--table.insert(self.loadLevelList, dupLevelId)
	--end

	self.resCount = self.resCount + #self.loadLevelList * 5
end

function FightResourcesPreload:LoadLevel()
	local levelLoaded = function ()
		self:OnResLoad(5)
	end

	for k, v in pairs(self.loadLevelList) do
		self.clientFight.assetsNodeManager:LoadLevel(v, levelLoaded)
	end
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
	self.progressCallback(1)
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
end
