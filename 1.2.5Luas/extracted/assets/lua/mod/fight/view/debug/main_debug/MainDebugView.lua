MainDebugView = BaseClass("MainDebugView",BaseView)
MainDebugView.NotClear = true

function MainDebugView:__init(model)
	self.model = model
	self:SetAsset(AssetConfig.main_debug)

	self.showDebugList = false
	self.fontAniVisible = true
	CustomUnityUtils.SetRenderScale(1)
end

function MainDebugView:__delete()
	--self.inputField.onEndEdit:RemoveListener(self.onEndEditCallback)
end

function MainDebugView:__CacheObject()
	self.debugList = self.transform:Find("DebugList")
end

function MainDebugView:__Create()
	local canvas = self:Find(nil,Canvas)
    if canvas ~= nil then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end
	self.timer = LuaTimerManager.Instance:AddTimer(0, 0.2,self:ToFunc("Update"))
	self.frameStamp = 0
	self.timeStamp = 0
	self.frameUpdate = 0
	self.updateShowDeltaTime = 0
	self.fps = 0
	
	if Application.platform == RuntimePlatform.Android or
		Application.platform == RuntimePlatform.IPhonePlayer then
		local area = self.transform:Find("Main"):GetComponent(RectTransform)
		local buttonAreaAnchor = area.anchoredPosition
		area.anchoredPosition = Vector2(buttonAreaAnchor.x + 250, buttonAreaAnchor.y)
		
		area = self.transform:Find("DebugList"):GetComponent(RectTransform)
		buttonAreaAnchor = area.anchoredPosition
		area.anchoredPosition = Vector2(buttonAreaAnchor.x + 250, buttonAreaAnchor.y)
	end
end

function MainDebugView:Update()
	local f = (Time.frameCount - self.frameStamp) / (Time.realtimeSinceStartup - self.timeStamp)
	self.FPS_txt.text = tostring(math.floor(f))
	self.timeStamp = Time.realtimeSinceStartup
	self.frameStamp = Time.frameCount
end

function MainDebugView:__BindListener()
	self.btnMain = self:Find("Main",Button)
	self.btnMain.onClick:AddListener(function() self:OpenDebugList() end)

	self.btnMapList = self:Find("DebugList/MapList",Button)
	self.btnMapList.onClick:AddListener(function() self:OpenMapList() end)
	self.btnGameSpeed = self:Find("DebugList/GameSpeed",Button)
	self.btnGameSpeed.onClick:AddListener(function() self:OpenGameSpeed() end)
	self.btnGameSpeed = self:Find("DebugList/ReloadLua",Button)
	self.btnGameSpeed.onClick:AddListener(function() self:ReloadLua() end)
	self:Find("DebugList/exit_btn",Button).onClick:AddListener(self:ToFunc("ExitFight"))
	self:Find("DebugList/DamagePause",Button).onClick:AddListener(self:ToFunc("DamagePause"))
	self:Find("DebugList/ShowTerrain",Button).onClick:AddListener(self:ToFunc("ShowTerrain"))
	self.damagePauseText = UtilsUI.GetText(self:Find("DebugList/DamagePause/Text"))

	self:Find("DebugList/SetFontAniVisible", Button).onClick:AddListener(self:ToFunc("SetFontAniVisible"))
	self:Find("DebugList/GoWinResult", Button).onClick:AddListener(self:ToFunc("GoWinResult"))
	self:Find("DebugList/GoLoseResult", Button).onClick:AddListener(self:ToFunc("GoLoseResult"))
	self.PlayerDie_btn.onClick:AddListener(self:ToFunc("OnPlayerDie"))
	self.fontAniVisibleText = UtilsUI.GetText(self:Find("DebugList/SetFontAniVisible/Text"))
	self.Log_btn.onClick:AddListener(self:ToFunc("OnLog"))
	
	self.ChargingPoint_btn.onClick:AddListener(self:ToFunc("ShowChargingView"))
	
	self:Find("DebugList/DebugInfo",Button).onClick:AddListener(self:ToFunc("ShowDebugInfo"))

	self:Find("DebugList/ShowCollider",Button).onClick:AddListener(self:ToFunc("ShowAttackCollider"))	
	self.showColliderText = UtilsUI.GetText(self:Find("DebugList/ShowCollider/Text"))

	self.GM_btn.onClick:AddListener(self:ToFunc("ShowGMPanel"))
	self.DebugAttr_btn.onClick:AddListener(self:ToFunc("ShowDebugAttrPanel"))
	self.SystemFunction_btn.onClick:AddListener(self:ToFunc("ShowDebugSystemPanel"))

	self.ShaderVarLog_btn.onClick:AddListener(self:ToFunc("ShowShaderVarLog"))
	self.ShaderVarLogText = UtilsUI.GetText(self:Find("DebugList/ShaderVarLog_/Text"))
	
	self.Settings_btn.onClick:AddListener(self:ToFunc("ShowSettings"))
	self.InputCode_btn.onClick:AddListener(self:ToFunc("ShowCodeView"))
	self.ConditionQuery_btn.onClick:AddListener(self:ToFunc("ShowConditionCheck"))
	self.StoryCtrl_btn.onClick:AddListener(self:ToFunc("ShowStoryCtrl"))
	self.TerrainLayer_btn.onClick:AddListener(self:ToFunc("ShowTerrainLayer"))
	self.TerrainLayerText = UtilsUI.GetText(self:Find("DebugList/TerrainLayer_/Text"))
	self.SkillList_btn.onClick:AddListener(self:ToFunc("ShowSkillList"))
	self.ChangeMonster_btn.onClick:AddListener(self:ToFunc("ChangeSceneMonster"))
	self.ShowActiveEntity_btn.onClick:AddListener(self:ToFunc("ShowActiveEntityPanel"))
end

function MainDebugView:__Hide()
	self:HideDebugObject(self.chargingView)
	self:HideDebugObject(self.debugInfo)
	self:HideDebugObject(self.showTerrainView)
	
	if MapListManager.Instance.model.visable then
		MapListManager.Instance.model:CloseMainUI()
	end
	
	if GameSpeedManager.Instance.model.visable then
		GameSpeedManager.Instance.model:CloseMainUI()
	end
end

function MainDebugView:HideDebugObject(obj)
	if obj and obj.active then
		obj:Hide()
	end
end

function MainDebugView:ReloadLua()
	--重设ActionMap
	InputManager.Instance:SwitchActionMap("Player")
	if not GmHotUpdateManager.Instance then
		GmHotUpdateManager.New()
	end

	if MapListManager.Instance and MapListManager.Instance.model.visable then
		MapListManager.Instance.model:CloseMainUI()
	end

	local fightData = nil
	local heroList = {}
	if Fight.Instance then
		fightData = UtilsBase.copytab(Fight.Instance.fightData)

		local formationInfo = mod.FormationCtrl:GetCurFormationInfo()
		for k, v in pairs(formationInfo.roleList) do
			table.insert(heroList, v)
		end

		Fight.Instance:Clear()
	else
		WindowManager.Instance:CloseAllWindow(true)
		PanelManager.Instance:CloseAllPanel(true)
		WindowManager.Instance:OpenWindow(LoginWindow)
	end

	Facade.ClearModuleData()
	GmHotUpdateManager.Instance:HotUpdate()
	if not ItemManager.Instance then
		ItemManager.New()
	end
	if not GmManager.Instance then
		GmManager.New()
	end

	if fightData then
		Fight.New()
		Fight.Instance:SetDebugFormation(heroList)
		Fight.Instance:EnterFight(fightData)
	end

	if self.debugAttrPanel and self.debugAttrPanel.active then
		self.debugAttrPanel:Destroy()
		self.debugAttrPanel = nil
		self:ShowDebugAttrPanel()
	end

	if self.debugSkillListPanel then
		PanelManager.Instance:ClosePanel(DebugSkillListPanel)
		self.debugSkillListPanel = nil
	end
end

function MainDebugView:OpenDebugList()
	self.showDebugList = not self.showDebugList
	self.debugList.gameObject:SetActive(self.showDebugList)
end

function MainDebugView:OpenMapList()
	if not MapListManager.Instance then
		MapListManager.New()
	end
	if MapListManager.Instance.model.visable then
		MapListManager.Instance.model:CloseMainUI()
	else
		MapListManager.Instance.model:InitMainUI()
	end
end

function MainDebugView:__Show()
	self.debugList.gameObject:SetActive(false)
end

function MainDebugView:OpenGameSpeed()
	if GameSpeedManager.Instance.model.visable then
		GameSpeedManager.Instance.model:CloseMainUI()
	else
		GameSpeedManager.Instance.model:InitMainUI()
	end
end

function MainDebugView:ExitFight()
	BehaviorFunctions.SetSceneObjectLoadPause(false)
	Network.Instance:Disconnect(5)

	if Fight.Instance then
		Fight.Instance:Clear()
	end

	WindowManager.Instance:OpenWindow(LoginWindow)
	-- Network.Instance:Disconnect(5)
end

function MainDebugView:DamagePause()
	FightDebugManager.Instance.damagePause = not FightDebugManager.Instance.damagePause
	if FightDebugManager.Instance.damagePause then
		CustomUnityUtils.SetTextColor(self.damagePauseText, 0, 255, 0, 255)
	else
		CustomUnityUtils.SetTextColor(self.damagePauseText, 255, 255, 255, 255)
	end
end

function MainDebugView:ShowTerrain()
	if not self.showTerrainView then
		self.showTerrainView = ShowTerrainView.New()
		self.showTerrainView:Show()
		return
	end
	if self.showTerrainView.active then
		self.showTerrainView:Hide()
	else
		self.showTerrainView:Show()
	end
	
end

function MainDebugView:SetFontAniVisible()
	if ctx then
		local clientFight = Fight.Instance.clientFight
		self.fontAniVisible = not self.fontAniVisible
		clientFight.fontAnimManager:SetVisible(self.fontAniVisible)
		if not self.fontAniVisible then
			self.fontAniVisibleText.text = TI18N("显示飘字")
		else
			self.fontAniVisibleText.text = TI18N("隐藏飘字")
		end
	end
end

function MainDebugView:GoWinResult()
	BehaviorFunctions.SetFightResult(true)
end

function MainDebugView:GoLoseResult()
	BehaviorFunctions.SetFightResult(false)
end

function MainDebugView:OnPlayerDie()
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	player.attrComponent:SetValue(EntityAttrsConfig.AttrType.Life, 0)
end

function MainDebugView:OnLog()
	_G.LogView:GetComponent(CS.ReporterGUI):ShowReporter(true)
end

function MainDebugView:ShowChargingView()
	if not self.chargingView then
		self.chargingView = ChargingView.New()
		self.chargingView:Show()
		return
	end
	if self.chargingView.active then
		self.chargingView:Hide()
	else
		self.chargingView:Show()
	end
end

function MainDebugView:ShowDebugInfo()
	if not self.debugInfo then
		self.debugInfo = DebugInfo.New()
		self.debugInfo:Show()
		return
	end
	if self.debugInfo.active then
		self.debugInfo:Hide()
	else
		self.debugInfo:Show()
	end
end

function MainDebugView:ShowAttackCollider()
	_G.ShowAttackCollider = _G.ShowAttackCollider or 0
	_G.ShowAttackCollider = (_G.ShowAttackCollider + 1) % 3
	if _G.ShowAttackCollider == 1 then
		CustomUnityUtils.SetTextColor(self.showColliderText, 255, 0, 0, 255)
	elseif _G.ShowAttackCollider == 2 then
		CustomUnityUtils.SetTextColor(self.showColliderText, 0, 0, 255, 255)
	else
		CustomUnityUtils.SetTextColor(self.showColliderText, 255, 255, 255, 255)
	end

end

function MainDebugView:ShowGMPanel()
	if not GmManager.Instance.windowVisible then
		GmManager.Instance:OpenGmPanel()
	else
		GmManager.Instance:CloseGmPanel()
	end
end

function MainDebugView:ShowDebugAttrPanel()
	if not self.debugAttrPanel then
		self.debugAttrPanel = AttrDebugPanel.New()
		self.debugAttrPanel:Show()
		return
	end
	
	if self.debugAttrPanel.active then
		self.debugAttrPanel:Destroy()
		self.debugAttrPanel = nil
	else
		self.debugAttrPanel = nil
		self:ShowDebugAttrPanel()
	end
end

function MainDebugView:ShowDebugSystemPanel()
	if not self.debugSystemPanel then
		self.debugSystemPanel = DebugSystemPanel.New()
		self.debugSystemPanel:Show()
		return
	end
	if self.debugSystemPanel.active then
		self.debugSystemPanel:Destroy()
		self.debugSystemPanel = nil
	else
		self.debugSystemPanel = nil
		self:ShowDebugSystemPanel()
	end
end

function MainDebugView:ShowShaderVarLog()
	AssetBatchLoader.ShaderVarLog = not AssetBatchLoader.ShaderVarLog
	if AssetBatchLoader.ShaderVarLog then
		CustomUnityUtils.SetTextColor(self.ShaderVarLogText, 0, 255, 0, 255)
	else
		CustomUnityUtils.SetTextColor(self.ShaderVarLogText, 255, 255, 255, 255)
	end
end


function MainDebugView:ShowSettings()
	if not self.debugSettings then
		self.debugSettings = DebugSettings.New()
		self.debugSettings:Show()
		return
	end
	if self.debugSettings.active then
		self.debugSettings:Hide()
	else
		self.debugSettings:Show()
	end
end

function MainDebugView:ShowCodeView()
	if not self.codeView then
		self.codeView = DebugCodeView.New()
		self.codeView:Show()
		return
	end
	if self.codeView.active then
		self.codeView:Hide()
	else
		self.codeView:Show()
	end
end

function MainDebugView:ShowConditionCheck()
	if not self.conditionCheckView then
		self.conditionCheckView = PanelManager.Instance:OpenPanel(GMConditionQueryPanel)
	end

	if self.conditionCheckView.active then
		self.conditionCheckView:Hide()
	else
		self.conditionCheckView:Show()
	end
end

function MainDebugView:ShowStoryCtrl()
	if not self.debugStoryPanel then
		self.debugStoryPanel = PanelManager.Instance:OpenPanel(DebugStoryPanel)
	end
	
	if self.debugStoryPanel.active then
		self.debugStoryPanel:Hide()
	else
		self.debugStoryPanel:Show()
	end
end


function MainDebugView:ShowTerrainLayer()
	if self.showTerrainLayer == nil then
		self.showTerrainLayer = false
	end
	self.showTerrainLayer = not self.showTerrainLayer

	if self.showTerrainLayer then
		if not self.terrainLayertimer then
			self.terrainLayertimer = LuaTimerManager.Instance:AddTimer(0, 0.2,self:ToFunc("_ShowTerrainLayer"))
		end
		CustomUnityUtils.SetTextColor(self.TerrainLayerText, 0, 255, 0, 255)
	else
		if self.terrainLayertimer then
	        LuaTimerManager.Instance:RemoveTimer(self.terrainLayertimer)
	        self.terrainLayertimer = nil
	    end
		CustomUnityUtils.SetTextColor(self.TerrainLayerText, 255, 255, 255, 255)

		self.cubeList = {}
		self.cubeCache = {}
		GameObject.Destroy(self.terrainDebug)
		self.terrainDebug = nil
	end
end

function MainDebugView:_ShowTerrainLayer()
	local id = BehaviorFunctions.GetCtrlEntity()
	local playerPos = BehaviorFunctions.GetPositionP(id) 
	
	if not self.terrainDebug then
		self.terrainDebug = GameObject("TerrainDebug")
	end
	FindPathComponent.DrawFindLine = self.terrainDebug ~= nil

	self.cubeCache = self.cubeCache or {}
	self.cubeList = self.cubeList or {} 
	self:PushCube()
	
	for x = 0, 0 do
		for z = 0, 0 do
			local posX = playerPos.x + x
			local posZ = playerPos.z + z 
			local layer = TerrainMatLayerConfig.GetMatLayer(posX, posZ)
	        local color = TerrainMatLayerConfig.LayerColor[layer] 
			color.a = 0.8
	        local go = self:PopCube()
	        go.transform.parent = self.terrainDebug.transform
	        local height, haveGround = CustomUnityUtils.GetTerrainHeight(posX, playerPos.y, posZ)
			local posY = playerPos.y - height
			go.transform.localScale = Vector3(1, 0.1, 1)
			go.transform.position = Vector3(posX, posY + 0.1, posZ)
			CustomUnityUtils.SetPrimitiveMaterialColor(go, color)
		end
	end
end

function MainDebugView:ShowSkillList()
	if not self.debugSkillListPanel then
		self.debugSkillListPanel = PanelManager.Instance:OpenPanel(DebugSkillListPanel)
		self.debugSkillListPanel:Show()
		return
	end
	if self.debugSkillListPanel then
		PanelManager.Instance:ClosePanel(DebugSkillListPanel)
		self.debugSkillListPanel = nil
	else
		self.debugSkillListPanel = PanelManager.Instance:OpenPanel(DebugSkillListPanel)
	end
end


function MainDebugView:PopCube()
	local cube = table.remove(self.cubeCache)
	if not cube then
		cube = GameObject.CreatePrimitive(PrimitiveType.Cube)
		local collider = cube:GetComponent(BoxCollider)
		collider.enabled = false
		cube.transform.parent = self.terrainDebug.transform
	else
		cube:SetActive(true)
	end

	table.insert(self.cubeList, cube)
	return cube
end

function MainDebugView:PushCube()
	for k, v in pairs(self.cubeList) do
		v:SetActive(false)
		table.insert(self.cubeCache, v)
	end

	self.cubeList = {}
end

function MainDebugView:ChangeSceneMonster()
	if not self.debugChangeMonsterPnl then
		self.debugChangeMonsterPnl = PanelManager.Instance:OpenPanel(DebugChangeMonster)
		return
	end
	if self.debugChangeMonsterPnl.active then
		-- self.debugChangeMonsterPnl:Hide()
		PanelManager.Instance:ClosePanel(DebugChangeMonster)
	else
		self.debugChangeMonsterPnl = PanelManager.Instance:OpenPanel(DebugChangeMonster)
	end
end

function MainDebugView:ShowActiveEntityPanel()
	if not self.activeEntityPanel then
		self.activeEntityPanel = PanelManager.Instance:OpenPanel(ShowActiveEntityPanel)
		return
	end
	if self.activeEntityPanel.active then
		PanelManager.Instance:ClosePanel(ShowActiveEntityPanel)
	else
		self.activeEntityPanel = PanelManager.Instance:OpenPanel(ShowActiveEntityPanel)
	end
end