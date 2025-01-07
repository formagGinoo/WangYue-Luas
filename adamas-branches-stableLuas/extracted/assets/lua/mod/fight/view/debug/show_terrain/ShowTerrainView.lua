ShowTerrainView = BaseClass("ShowTerrainView",BaseView)

function ShowTerrainView:__init()
	self:SetAsset("Prefabs/UI/FightDebug/DebugShowTerrain.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)

	self.showType = 0
	self.cubeCache = {}
	self.cubeList = {}
	self.terrainDebug = GameObject("TerrainDebug")
	self.cubeOrigin = GameObject.CreatePrimitive(PrimitiveType.Cube)
	self.cubeOrigin:SetActive(false)
end

function ShowTerrainView:__Show()
	
end

function ShowTerrainView:__Hide()
	self:PushCube()
	self:RemoveTimer()
end

function ShowTerrainView:__CacheObject()
	local canvas = self.gameObject:GetComponent(Canvas)
	if canvas ~= nil then
		canvas.pixelPerfect = false
		canvas.overrideSorting = true
	end
	self:Find("ShowTerrainCollider",Button).onClick:AddListener(self:ToFunc("ShowTerrainCollider"))
	self:Find("ShowTerrainInfo",Button).onClick:AddListener(self:ToFunc("ShowTerrainInfo"))

	self:Find("LogicHeight",Button).onClick:AddListener(self:ToFunc("LogicHeight"))
	self.text = UtilsUI.GetText(self:Find("LogicHeight/Text"))
end

function ShowTerrainView:PopCube()
	local cube = table.remove(self.cubeCache)
	if not cube then
		cube = GameObject.Instantiate(self.cubeOrigin) 
		cube.transform.parent = self.terrainDebug.transform
	else
		cube:SetActive(true)
	end

	table.insert(self.cubeList, cube)
	return cube
end

function ShowTerrainView:PushCube()
	for k, v in pairs(self.cubeList) do
		v:SetActive(false)
		table.insert(self.cubeCache, v)
	end

	self.cubeList = {}
end

function ShowTerrainView:RemoveTimer()
    if self.timer then
        LuaTimerManager.Instance:RemoveTimer(self.timer)
        self.timer = nil
    end
end

function ShowTerrainView:ShowTerrainCollider()
	if self.showType ~= 1 then
		self:RemoveTimer()
		self.showType = 1
	end

	if not self.timer then
		self.timer = LuaTimerManager.Instance:AddTimer(0, 0.5,self:ToFunc("ShowTerrainCollider"))
	end

	self:PushCube()
	local terrain = Fight.Instance.terrain
	local id = BehaviorFunctions.GetCtrlEntity()
	local playerPos = BehaviorFunctions.GetPositionP(id) 
	local pos = playerPos - terrain.terrain.Center
	local centerY = terrain.terrain.Center.y
	for x = -5, 5 do
		for y = 0, 5 do
			for z = -5, 5 do
				local yIndex = terrain:GetHeightIndex(pos.y + y * 0.25)
				if yIndex > 0 then
					local b = terrain:CheckObstacle(yIndex,pos.x + x * 0.5,pos.z + z *0.5)
					if b then
						local go = self:PopCube()
						go.transform.parent = self.terrainDebug.transform
						go.transform.localScale = Vector3(0.5, 0.25, 0.5);
						go.transform.position = Vector3(playerPos.x + x * 0.5, pos.y + centerY + y * 0.25, playerPos.z + z *0.5)
					end
				end
			end
		end
	end
end

function ShowTerrainView:ShowTerrainInfo()
	if self.showType ~= 2 then
		self:RemoveTimer()
		self.showType = 2
	end
	
	if not self.timer then
		self.timer = LuaTimerManager.Instance:AddTimer(0, 0.5,self:ToFunc("ShowTerrainInfo"))
	end
	
	self:PushCube()
	local id = BehaviorFunctions.GetCtrlEntity()
	local pos = BehaviorFunctions.GetPositionP(id)
	
	local terrain = Fight.Instance.terrain
	local centerY = terrain.terrain.Center.y
	for x = -6, 6 do
		for z = -6, 6 do
			local yCache = {}
			for y = 1, 6 do
				local setY, isFind = terrain:CheckTerrainY(Vector3(pos.x + x * 0.5, pos.y + y, pos.z + z *0.5))
				if isFind and not yCache[setY] then
					yCache[setY] = {}

					local go = self:PopCube()
					go.transform.parent = self.terrainDebug.transform
					go.transform.localScale = Vector3(0.5, 0.25, 0.5);
					go.transform.position = Vector3(pos.x + x * 0.5, setY + centerY, pos.z + z *0.5)
				end
			end
		end
	end
end

function ShowTerrainView:LogicHeight()
	FightDebugManager.Instance.logicHeight = not FightDebugManager.Instance.logicHeight
	if FightDebugManager.Instance.logicHeight then
		CustomUnityUtils.SetTextColor(self.text, 0, 255, 0, 255)
	else
		CustomUnityUtils.SetTextColor(self.text, 0, 0, 0, 255)
	end
end

function ShowTerrainView:__delete()
	for k, v in pairs(self.cubeList) do
		GameObject.Destroy(v)
	end

	for k, v in pairs(self.cubeCache) do
		GameObject.Destroy(v)
	end

	GameObject.Destroy(self.terrainDebug)
	GameObject.Destroy(self.cubeOrigin)

	self:RemoveTimer()
end

function ShowTerrainView:__Create()
end

