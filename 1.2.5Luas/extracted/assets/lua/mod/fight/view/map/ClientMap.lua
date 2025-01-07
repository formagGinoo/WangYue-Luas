---@class ClientMap
ClientMap = BaseClass("ClientMap")

function ClientMap:__init(clientFight)
	self.clientFight = clientFight
	self.sceneObjects = {}
	-- self.mapCinemachineBrain = nil
	self:AddListener()
end

function ClientMap:AddListener()
	EventMgr.Instance:AddListener(EventName.ShowScenneObj, self:ToFunc("ShowScenneObj"))
end

function ClientMap:StartFight(mapConfig)
	--Log("ClientMap:StartFight")
	self.levelManager = Fight.Instance.levelManager
	
	local scenePath = "Prefabs/Scene/"..mapConfig.scene_prefab
	local sceneGameObject = self.clientFight.assetsPool:Get(scenePath)
	self.rootTransform = self.clientFight.fightRoot.transform
	sceneGameObject.name = string.gsub(sceneGameObject.name, "[(]Clone[)]", "")
	self.transform = sceneGameObject.transform
	self.transform:SetParent(self.rootTransform)
	UnityUtils.SetPosition(self.transform,0, 0, 0)

	self.worldTerrainCmp = HWorldTerrain.Instance
	self.chunkManager = self.transform:GetComponentInChildren(CS.ChunkManager)
	if self.chunkManager then
		BgmManager.Instance:InitWorldBgm()
	end
	-- self:InitSceneObjects()

	if mapConfig.map_area_prefab and mapConfig.map_area_prefab ~= "" then
		local mapAreaPath = "Prefabs/Scene/"..mapConfig.map_area_prefab
		local mapAreaObject = self.clientFight.assetsPool:Get(mapAreaPath)
		mapAreaObject.name = string.gsub(mapAreaObject.name, "[(]Clone[)]", "")
		mapAreaObject.transform:SetParent(self.rootTransform)
		UnityUtils.SetPosition(mapAreaObject.transform,0, 0, 0)
	end
end

function ClientMap:Update()
	if self.timnelinePlaying then
		self.time = self.time + Global.deltaTime
		CustomUnityUtils.SetPlayableDirectorTime(self.playableDirector,self.time)
	end
end

function ClientMap:PlayTimeline(name, levelId)
	self.timelineObject = self.levelManager:GetSceneObject(name)
	if not self.timelineObject then
		return
	end

	self.timelineObject:SetActive(true)
	self.playableDirector = self.timelineObject.gameObject:GetComponent(CS.UnityEngine.Playables.PlayableDirector)
	self.time = 0
	self.timnelinePlaying = true
end

function ClientMap:StopTimeline()
	self.timelineObject:SetActive(false)
	self.timnelinePlaying = false
end

function ClientMap:InitSceneObjects()
	-- local VCBrain = self.logicGameObject.transform:Find("VCBrain")
	-- if VCBrain then
	-- 	self.mapCinemachineBrain = VCBrain:GetComponent(Cinemachine.CinemachineBrain)
	-- end
	
end

function ClientMap:ActiveObj(objName,flag,levelId)
	local obj = self.levelManager:GetSceneObject(objName, levelId)
	if obj then
		obj.gameObject:SetActive(flag)
	end
end

function ClientMap:ActiveSceneObjByPath(path,active)
	local transform = self.rootTransform:Find(path)
	if UtilsBase.IsNull(transform) then
		LogError("obj ont found "..path)
		return
	end
	transform:SetActive(active)
end

function ClientMap:PlayAnim(objName, animName, levelId)
	local obj = self.levelManager:GetSceneObject(objName, levelId)
	if obj then
		local animator = obj:GetComponent(Animator)
		animator:Play(animName)
	end
end

function ClientMap:GetSceneObject(objName, levelId)
	return self.levelManager:GetSceneObject(objName, levelId)
end

function ClientMap:SetSceneSpeed(speed)
	-- if self.sceneObjectsCmp then
	-- 	self.sceneObjectsCmp:SetSceneSpeed(speed)
	-- end
end

function ClientMap:SetCameraLockAt(objName,entity,levelId)
	local cameraTarget = entity.clientEntity.clientTransformComponent.transform:Find("CameraTarget")
	local obj = self.levelManager:GetSceneObject(objName, levelId)
	if obj then
		local cvc = obj:GetComponent(CinemachineVirtualCamera)
		cvc.m_Follow = cameraTarget
		cvc.m_LookAt = cameraTarget
	end
end

function ClientMap:AddDitherObject(transform)
	-- self.ditherObjectsCmp:AddDitherObject(transform)
end

function ClientMap:GetObjectPosition(objectName, levelId, belongId)
	if not levelId then
		local mapId = self.clientFight.fight:GetFightMap()
		levelId = mod.WorldMapCtrl:GetMapConfig(mapId).level_id
	end

	if not belongId and levelId == 10020001 then
		belongId = "Logic10020001_1"
	end

	local position = mod.WorldMapCtrl:GetMapPositionConfig(levelId, objectName, belongId)
	if position then
		return position
	end
	levelId = levelId or 0
end

function ClientMap:SetTerrianFollow(transform,cb)
	if self.chunkManager then
		self.worldTerrainCmp:SetFollowTransform(transform,cb)
	else
		if cb then
			cb()
		end
	end
end

function ClientMap:LoadTerrian(x, y, z, cb)
	if self.chunkManager then
		self.worldTerrainCmp:LoadPos(x, y, z, cb)
	else
		if cb then
			cb()
		end
	end
end

function ClientMap:ShowScenneObj(isShow)
	self.transform:SetActive(isShow or false)
	if isShow and self.chunkManager then
		self.worldTerrainCmp:OnResume()
	end
end

function ClientMap:__delete()
	if self.chunkManager then
		self.worldTerrainCmp:OnPause()
	end
	EventMgr.Instance:RemoveListener(EventName.ShowScenneObj, self:ToFunc("ShowScenneObj"))
end