local BoneShakeAsset
local _tinsert = table.insert

local LoadTaskType =
{
	FightRes = 1, 
	TerrianRes = 2,
	WorldRes = 3,
	EcoRes = 4,
}

local LoadTaskInfo =
{
	[LoadTaskType.FightRes] = {LoadPercent = 75, func = "LoadFightRes", taskType = LoadTaskType.FightRes},
	[LoadTaskType.TerrianRes] = {LoadPercent = 5, func = "LoadTerrianRes", taskType = LoadTaskType.TerrianRes},
	[LoadTaskType.WorldRes] = {LoadPercent = 15, func = "LoadWorldRes", taskType = LoadTaskType.WorldRes},
	[LoadTaskType.EcoRes] = {LoadPercent = 5, func = "LoadEcoRes", taskType = LoadTaskType.EcoRes},
}

local MapConfig = Config.DataMap.data_map


SceneResourcesPreload = BaseClass("SceneResourcesPreload")
function SceneResourcesPreload:__init(clientFight)
	self.curLoadIdx = 0
	self.maxPercent = 0 
	self.loadedPercent = 0
	self.clientFight = clientFight
	self.clientMap = clientFight.clientMap
end

function SceneResourcesPreload:StartLoadTask(fightData)
	if LoadPanelManager.Instance then
		local type = fightData.isLogin and 
		SystemConfig.LoadingPageType.Login or SystemConfig.LoadingPageType.Normal
		LoadPanelManager.Instance:Show(type)
	end

	self.fightData = fightData
	self.loadTaskList = {}
	self.mapdId = fightData.MapConfig.id
	local map_id = fightData.MapConfig.map_id
	if not MapConfig[map_id] then
		_tinsert(self.loadTaskList, LoadTaskInfo[LoadTaskType.FightRes])
		_tinsert(self.loadTaskList, LoadTaskInfo[LoadTaskType.TerrianRes])
	else
		_tinsert(self.loadTaskList, LoadTaskInfo[LoadTaskType.FightRes])
		_tinsert(self.loadTaskList, LoadTaskInfo[LoadTaskType.TerrianRes])
		_tinsert(self.loadTaskList, LoadTaskInfo[LoadTaskType.WorldRes])
		_tinsert(self.loadTaskList, LoadTaskInfo[LoadTaskType.EcoRes])
	end

	for k, v in pairs(self.loadTaskList) do
		self.maxPercent = self.maxPercent + v.LoadPercent
	end 

	self:DoLoadTask()
end


function SceneResourcesPreload:DoLoadTask()
	if self.loadEnd then
		return
	end

	if self.curTask then
		self.loadedPercent = self.loadedPercent + self.curTask.LoadPercent
	end

	self.curLoadIdx = self.curLoadIdx + 1
	if not self.loadTaskList[self.curLoadIdx] then
		Fight.Instance:OnFightStart()
		self.loadEnd = true
	else
		self.curTask = self.loadTaskList[self.curLoadIdx]
		self[self.curTask.func](self)
	end
	print("self.curLoadIdx "..self.curLoadIdx)
end

function SceneResourcesPreload:DoLoadTaskEnd(taskType)
	if self.curTask.taskType == taskType then
		self:DoLoadTask()
	end 
end

-- taskPercent 0 - 1
function SceneResourcesPreload:PreloadProgress(taskPercent)
	local curPercent = taskPercent * self.curTask.LoadPercent + self.loadedPercent
	LoadPanelManager.Instance:Progress(curPercent/self.maxPercent * 100)
end

function SceneResourcesPreload:LoadFightRes()
	self.resourcesPreload = FightResourcesPreload.New(self.clientFight)
	self.resourcesPreload:DoPreload(self.fightData,
		function(taskPercent) self:PreloadProgress(taskPercent) end,
		self:ToFunc("LoadFightResDone"))
end

function SceneResourcesPreload:LoadFightResDone()
	if not BoneShakeAsset then
		local assetsPool = self.clientFight.assetsPool
		BoneShakeAsset = assetsPool:Get("Character/BoneShake/BoneShakeData.asset")
		CustomUnityUtils.SetBoneSakeDataObject(BoneShakeAsset)

		local IKShakeAsset = assetsPool:Get("Character/BoneShake/IKShakeData.asset")
		local IKFullBodyAsset = assetsPool:Get("Character/BoneShake/IKFullBodyData.asset")
		CustomUnityUtils.SetIKBoneSakeDataObject(IKShakeAsset, IKFullBodyAsset)
	end
	
	Fight.Instance:PreloadDone()

	self:DoLoadTaskEnd(LoadTaskType.FightRes)
end

function SceneResourcesPreload:LoadTerrianRes()
	local pos = Fight.Instance.enterPosition
	HWorldTerrain.Instance:LoadPos(pos.x, pos.y, pos.z, self:ToFunc("LoadTerrianResDone"))
end

function SceneResourcesPreload:LoadTerrianResDone()
	local ctrlEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local transform = ctrlEntity.clientTransformComponent.transform
	self.clientMap:SetTerrianFollow(transform)
	SceneUnitManager.Instance:SetTargetTransform(transform)
	self:DoLoadTaskEnd(LoadTaskType.TerrianRes)
end

function SceneResourcesPreload:LoadWorldRes()
	local pos = Fight.Instance.enterPosition
	local animLoad = WorldSwitchTimeLine.Instance.switchStart and true or false
	SceneUnitManager.Instance:DoEnterLoad(self:ToFunc("LoadWorldResProgress"), 
		self.clientMap.transform, pos.x, pos.y, pos.z, animLoad)
end

function SceneResourcesPreload:LoadWorldResProgress(taskPercent)
	self:PreloadProgress(taskPercent)
	if taskPercent == 1 then
		self:DoLoadTaskEnd(LoadTaskType.WorldRes)
	end
end

function SceneResourcesPreload:LoadEcoRes()
	local ecosystemCtrlManager = Fight.Instance.entityManager.ecosystemCtrlManager
	ecosystemCtrlManager:StartLoading(self.mapdId, self:ToFunc("LoadEcoResProgress"))
end

function SceneResourcesPreload:LoadEcoResProgress(taskPercent)
	self:PreloadProgress(taskPercent)
	if taskPercent == 1 then
		self:DoLoadTaskEnd(LoadTaskType.EcoRes)
	end
end