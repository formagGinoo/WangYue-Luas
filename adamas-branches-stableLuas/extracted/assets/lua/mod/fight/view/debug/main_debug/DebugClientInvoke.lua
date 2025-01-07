DebugClientInvoke = {}

function DebugClientInvoke.SetCache(cache)
	DebugClientInvoke.Cache = cache
end

function DebugClientInvoke.ReloadLua()
	local cache = DebugClientInvoke.Cache
	EntityLODManager.Instance:OnReLoad()
	if DebugClientInvoke.Cache.debugAttrPanel and DebugClientInvoke.Cache.debugAttrPanel.active then
		DebugClientInvoke.Cache.debugAttrPanel:Destroy()
		DebugClientInvoke.Cache.debugAttrPanel = nil
	end

	if DebugClientInvoke.Cache.debugSkillListPanel then
		PanelManager.Instance:ClosePanel(DebugSkillListPanel)
		DebugClientInvoke.Cache.debugSkillListPanel = nil
	end
	
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
	local enterPosition = nil
	local isDebugDuplicate = false
	if Fight.Instance then
		isDebugDuplicate = Fight.Instance:IsDebugDuplicate()
		-- fightData = UtilsBase.copytab(Fight.Instance.fightData)
		fightData = FightData.New()
		
		local formationInfo = mod.FormationCtrl:GetCurFormationInfo()
		for k, v in pairs(formationInfo.roleList) do
			table.insert(heroList, v)
		end
		fightData:BuildFightData(heroList, mod.WorldMapCtrl.mapId)
		local curEntity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
		enterPosition = curEntity.transformComponent.position

		WindowManager.Instance:CloseAllWindow(true)
		PanelManager.Instance:CloseAllPanel(true)
		Fight.Instance:Clear()
	else
		WindowManager.Instance:CloseAllWindow(true)
		PanelManager.Instance:CloseAllPanel(true)
		WindowManager.Instance:OpenWindow(LoginWindow)
	end
	-- Facade.ClearModuleData()
	GmHotUpdateManager.Instance:HotUpdate()
	if not ItemManager.Instance then
		ItemManager.New()
	end
	if not GmManager.Instance then
		GmManager.New()
	end

	if fightData then
		Fight.New()
		if isDebugDuplicate then
			Fight.Instance:SetDebugFormation(heroList)
		end
		Fight.Instance:EnterFight(fightData:GetFightData(), enterPosition)
	end

	if not heroList then
		local curFormation = mod.FormationCtrl:GetCurFormationInfo()
		heroList = {}
		local index = 0
		for i = 1, #curFormation.roleList do
			if curFormation.roleList[i] ~= 0 then
				index = index + 1
				heroList[index] = curFormation.roleList[i]
			end
		end
	end

	DebugClientInvoke.SetCache(cache)
	DebugPlanInvoke.SetCache(cache)
	DebugTestInvoke.SetCache(cache)

	GameSetCtrl.ScreenW = Screen.width
	GameSetCtrl.ScreenH = Screen.height
end

function DebugClientInvoke.OpenMapList()
	if not MapListManager.Instance then
		MapListManager.New()
	end
	if MapListManager.Instance.model.visable then
		MapListManager.Instance.model:CloseMainUI()
	else
		MapListManager.Instance.model:InitMainUI()
	end
end

function DebugClientInvoke.DoubleGameSpeed()
	Time.timeScale = 2
end

function DebugClientInvoke.HalfGameSpeed()
	Time.timeScale = 0.5
end

function DebugClientInvoke.OneGameSpeed()
	Time.timeScale = 1
end

function DebugClientInvoke.ToggleAttackCollision()
	DebugClientInvoke.Cache.ShowAttackCollider = not DebugClientInvoke.Cache.ShowAttackCollider
	return DebugClientInvoke.Cache.ShowAttackCollider
end

function DebugClientInvoke.ToggleCollision()
	DebugClientInvoke.Cache.ShowCollider = not DebugClientInvoke.Cache.ShowCollider
	CS.KCCCharacterManager.Instance:EnableDebug(DebugClientInvoke.Cache.ShowCollider)
	return DebugClientInvoke.Cache.ShowCollider
end

function DebugClientInvoke.SetRoleDeath()
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	player.attrComponent:SetValue(EntityAttrsConfig.AttrType.Life, 0)
	mod.FormationCtrl:SyncServerProperty(player.instanceId)
end

function DebugClientInvoke.OpenGM()
	if not GmManager.Instance.windowVisible then
		GmManager.Instance:OpenGmPanel()
	else
		GmManager.Instance:CloseGmPanel()
	end
end

function DebugClientInvoke.OpenLog()
	_G.LogView:GetComponent(CS.ReporterGUI):ShowReporter(true)
end

function DebugClientInvoke.OpenEntityAttr()
	if not DebugClientInvoke.Cache.debugAttrPanel then
		DebugClientInvoke.Cache.debugAttrPanel = AttrDebugPanel.New()
		DebugClientInvoke.Cache.debugAttrPanel:Show()
		return
	end

	if DebugClientInvoke.Cache.debugAttrPanel.active then
		DebugClientInvoke.Cache.debugAttrPanel:Destroy()
		DebugClientInvoke.Cache.debugAttrPanel = nil
	else
		DebugClientInvoke.Cache.debugAttrPanel = nil
		DebugClientInvoke.Cache.OpenEntityAttr()
	end
end

function DebugClientInvoke.OpenLuaCmd()
	if not DebugClientInvoke.Cache.codeView then
		DebugClientInvoke.Cache.codeView = DebugCodeView.New()
		DebugClientInvoke.Cache.codeView:Show()
		return
	end
	if DebugClientInvoke.Cache.codeView.active then
		DebugClientInvoke.Cache.codeView:Hide()
		InputManager.Instance:SetCanInputState(true)
	else
		DebugClientInvoke.Cache.codeView:Show()
	end
end

function DebugClientInvoke.OpenStoryCtrl()
	if not DebugClientInvoke.Cache.debugStoryPanel then
		DebugClientInvoke.Cache.debugStoryPanel = DebugStoryPanel.New()
		DebugClientInvoke.Cache.debugStoryPanel:Show()
		return
	end

	if DebugClientInvoke.Cache.debugStoryPanel.active then
		DebugClientInvoke.Cache.debugStoryPanel:Hide()
	else
		DebugClientInvoke.Cache.debugStoryPanel:Show()
	end
end

function DebugClientInvoke.OpenRoleSkill()
	if not DebugClientInvoke.Cache.debugSkillListPanel then
		DebugClientInvoke.Cache.debugSkillListPanel = PanelManager.Instance:OpenPanel(DebugSkillListPanel)
		DebugClientInvoke.Cache.debugSkillListPanel:Show()
		return
	end
	if DebugClientInvoke.Cache.debugSkillListPanel then
		PanelManager.Instance:ClosePanel(DebugSkillListPanel)
		DebugClientInvoke.Cache.debugSkillListPanel = nil
	else
		DebugClientInvoke.Cache.debugSkillListPanel = PanelManager.Instance:OpenPanel(DebugSkillListPanel)
	end
end

function DebugClientInvoke.ChangeMonster(id)
	if id == "" then return end
	local newId = tonumber(id)
	if not newId then return end
	local cb = function ()
		BehaviorFunctions.fight.levelManager:GMChangeBehaviorMonsterId(newId)
	end
	Fight.Instance.clientFight.lifeBarManager:ClearLifeBarMap()
	BehaviorFunctions.fight.clientFight.assetsNodeManager:LoadEntity(newId, cb)
end

function DebugClientInvoke.OpenActiveEntity()
	if not DebugClientInvoke.Cache.activeEntityPanel then
		DebugClientInvoke.Cache.activeEntityPanel = PanelManager.Instance:OpenPanel(ShowActiveEntityPanel)
		return
	end
	if DebugClientInvoke.Cache.activeEntityPanel.active then
		PanelManager.Instance:ClosePanel(ShowActiveEntityPanel)
	else
		DebugClientInvoke.Cache.activeEntityPanel = PanelManager.Instance:OpenPanel(ShowActiveEntityPanel)
	end
end

function DebugClientInvoke.SetGameSpeed(speed)
	Time.timeScale = tonumber(speed)
end

function DebugClientInvoke.HideFontAnim()
	if ctx then
		local clientFight = Fight.Instance.clientFight
		DebugClientInvoke.Cache.fontAniVisible = not DebugClientInvoke.Cache.fontAniVisible
		clientFight.fontAnimManager:SetVisible(DebugClientInvoke.Cache.fontAniVisible)
	end
end


function DebugClientInvoke.OpenSetting()
	if not DebugClientInvoke.Cache.debugSettings then
		DebugClientInvoke.Cache.debugSettings = DebugSettings.New()
		InputManager.Instance:SetCanInputState(false)
		DebugClientInvoke.Cache.debugSettings:Show()
		return
	end
	if DebugClientInvoke.Cache.debugSettings.active then
		InputManager.Instance:SetCanInputState(true)
		DebugClientInvoke.Cache.debugSettings:Hide()
	else
		InputManager.Instance:SetCanInputState(false)
		DebugClientInvoke.Cache.debugSettings:Show()
	end
end

function DebugClientInvoke.CheckCondition()
	if not DebugClientInvoke.Cache.conditionCheckView then
		DebugClientInvoke.Cache.conditionCheckView = PanelManager.Instance:OpenPanel(GMConditionQueryPanel)
	end

	if DebugClientInvoke.Cache.conditionCheckView.active then
		DebugClientInvoke.Cache.conditionCheckView:Hide()
	else
		DebugClientInvoke.Cache.conditionCheckView:Show()
	end
end

function DebugClientInvoke.DamagePause()
	DebugClientInvoke.Cache.damagePause = not DebugClientInvoke.Cache.damagePause
	return DebugClientInvoke.Cache.damagePause
end

function DebugClientInvoke.SetScreenSize(width, height, screenFull)
	width = tonumber(width)
	height = tonumber(height)
	screenFull = tonumber(screenFull)
	local isFull = screenFull ~= 0
	Screen.SetResolution(width, height, isFull)
end

function DebugClientInvoke.TrafficTest()
	if not Fight.Instance then
		return false
	end
	
	local trafficManager = Fight.Instance.entityManager.trafficManager
	if not trafficManager then
		return false
	end
	DebugClientInvoke.Cache.trafficTest = trafficManager:DrawPoints(not DebugClientInvoke.Cache.trafficTest)
	return DebugClientInvoke.Cache.trafficTest
end

function DebugClientInvoke.CloseAllUI()
	DebugClientInvoke.Cache.closeUI = not DebugClientInvoke.Cache.closeUI
	EventMgr.Instance:Fire(EventName.CloseAllUI)
	-- local uiCamera = ctx.UICamera
	-- if uiCamera then
	-- 	uiCamera.gameObject:SetActive(not DebugClientInvoke.Cache.closeUI)
	-- end

	return DebugClientInvoke.Cache.closeUI
end

function DebugClientInvoke.ShowPackageInfo()
	print("当前资源版本 = ", ctx.RemoteResVersion)
	print("当前账号 = ", PlayerPrefs.GetString("last_account"))
	local severIdx =  tonumber(PlayerPrefs.GetString("last_server_idx"))
	local selectServer = LoginDefine.ServerListConfig[severIdx]
	print("所在服务器 = ", selectServer.name)

	local localResPath = Application.persistentDataPath .. "/res/_svn_version.txt"
	local file = io.open(localResPath, "r")
	if file then
		local content = file:read("*a")
		file:close()
		local versionMap = StringHelper.Split(content, "#")
		local resVersion = versionMap[1] or ""
		local luaVersion = versionMap[2] or ""
		local configVersion = versionMap[3] or ""
		print("资源版本:", resVersion, "脚本版本:", luaVersion, "配置版本:", configVersion)
	else
		print("无法打开文件")
	end
end

function DebugClientInvoke.BulletProject()
	DebugClientInvoke.Cache.BulletProject = not DebugClientInvoke.Cache.BulletProject
	return DebugClientInvoke.Cache.BulletProject
end

function DebugClientInvoke.ChangeRoleSpeed(speedTimes)
	DebugClientInvoke.Cache.speedTimes = speedTimes
end

function DebugClientInvoke.RegenerateMaxHealth()
	local player = BehaviorFunctions.fight.playerManager:GetPlayer()
	if not player then
		LogError("未找到角色")
		return
	end
	local instanceId = player.ctrlId
	if not instanceId then
		LogError("角色没有实例Id")
		return
	end
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not entity.attrComponent then
		LogError("角色没有 attr组件")
		return
	end

	local val, maxVal = entity.attrComponent:GetValueAndMaxValue(EntityAttrsConfig.AttrType.Life)
	entity.attrComponent:SetValue(EntityAttrsConfig.AttrType.Life, maxVal)
end

function DebugClientInvoke.ProtocolTest()
	WindowManager.Instance:OpenWindow(GMProtocolTestWindow)
end

function DebugClientInvoke.SetDamageMultiplier(num)
	num = tonumber(num)
	if not num then
		LogError("参数需要为数值")
		return
	end
	if num < 0 then
		LogError("倍率不可为负数")
		return
	end
	DebugClientInvoke.Cache.damageMultiplier = num

	LogInfo("调整伤害倍率 x", num)
end

function DebugClientInvoke.SetAge(age)
	age = tonumber(age)
	mod.LoginCtrl:SetAge(age)
end

function DebugClientInvoke.ShowServerInfo()
	if not DebugClientInvoke.Cache.serverInfo then
		DebugClientInvoke.Cache.serverInfo = DebugServerInfo.New()
		DebugClientInvoke.Cache.serverInfo:Show()
		return
	end
	if DebugClientInvoke.Cache.serverInfo.active then
		DebugClientInvoke.Cache.serverInfo:Destroy()
		DebugClientInvoke.Cache.serverInfo = nil
	else
		DebugClientInvoke.Cache.serverInfo = nil
		DebugClientInvoke.Cache.ShowServerInfo()
	end
end

function DebugClientInvoke.BlockPopWindow(num)
	Fight.Instance.tipQueueManger.isDisplay = true
	EventMgr.Instance:Fire(EventName.PauseTipQueue)
	LogInfo("已阻塞所有弹窗")
end

function DebugClientInvoke:ShowDamageLog()
	DebugConfig.ShowDamageLog = not DebugConfig.ShowDamageLog
	if DebugConfig.ShowDamageLog then
		LogInfo("显示伤害日志")
	else
		LogInfo("停止显示伤害日志")
	end
end


function DebugClientInvoke:StopMonsterLogic()
	DebugConfig.StopMonsterLogic = not DebugConfig.StopMonsterLogic
	if DebugConfig.StopMonsterLogic then
		LogInfo("停止怪物行为逻辑")
	else
		LogInfo("恢复怪物行为逻辑")
	end
end

function DebugClientInvoke.OpenProfiler()
	WindowManager.Instance:OpenWindow(GmProfilerWindow)
end

function DebugClientInvoke.SceneProfilerCollect()
	Fight.Instance:Pause()
	local player = Fight.Instance.playerManager:GetPlayer()
	local entity = player:GetCtrlEntityObject()
	entity.clientTransformComponent.model:SetActive(false)
end

function DebugClientInvoke.OpenGMProfilerWindow(transform)
	local winName = GmProfilerWindow.__className
	local window = WindowManager.Instance:GetWindow(winName)
	if window then
		window:UpdateCustomTrasform(transform)
	else
		WindowManager.Instance:OpenWindow(GmProfilerWindow, transform)
	end
end

if ctx then
	CS.GameProfiler.MemoryProfiler.LuaProfilerAction = DebugClientInvoke.OpenGMProfilerWindow
	CS.SceneProfilerCollect.StartCollectAction = DebugClientInvoke.SceneProfilerCollect
end


function DebugClientInvoke.GetAllItem(num)
	--num = tonumber(num)
	local itemDatas = Config.DataItem.Find
	for index, info in pairs(itemDatas) do
		mod.GmFacade:SendMsg("gm_exec", "item_gain", {tostring(info.id), num})
	end
end

function DebugClientInvoke.TDSetEntityAttr(entityId, attrId, value)
	local TDSetEntityAttr_EntityId = tonumber(entityId)
	local TDSetEntityAttr_AttrId = tonumber(attrId)
	local TDSetEntityAttr_Value = tonumber(value)

	BehaviorFunctions.SetEntityAttr(TDSetEntityAttr_EntityId, TDSetEntityAttr_AttrId,  TDSetEntityAttr_Value)
	Log(BehaviorFunctions.GetEntity(TDSetEntityAttr_EntityId).attrComponent:GetValue(TDSetEntityAttr_AttrId))
end


function DebugClientInvoke.TDLogEntityAttr(entityId, attrId)
	local TDLogEntityAttr_entityId = tonumber(entityId)
	local TDLogEntityAttr_attrId = tonumber(attrId)
	local entity = BehaviorFunctions.GetEntity(TDLogEntityAttr_entityId)
	if TDLogEntityAttr_attrId then
		local TDLogEntityAttr_value =  entity.attrComponent:GetValue(TDLogEntityAttr_attrId)
		local baseValue = entity.attrComponent:GetBaseValue(TDLogEntityAttr_attrId)
		local _, logTable = entity.attrComponent:CalcFinalTotalAttrValue(TDLogEntityAttr_attrId, true)
		Log(string.format("属性【%s】，最终值(基础值+加成值+额外值+转化值)：%s， 基础值(实体+玩家)：%s",
		TDLogEntityAttr_attrId, TDLogEntityAttr_value, baseValue))
		LogTable("模拟计算过程:",logTable)
		return
	end

	local data = {}
	for k, v in pairs(EntityAttrsConfig.AttrType) do
		local name = EntityAttrsConfig.GetAttrName(v)
		local value = entity.attrComponent:GetValue(v) or 0
		local baseValue = entity.attrComponent:GetBaseValue(v) or 0
		local totalValue = value + value
		local log = string.format("[%s]%s:  最终值 %s  基础值: %s", v, name, value, baseValue)
		table.insert(data, {type = v, value = totalValue, log = log})
	end
	table.sort(data, function(a, b)
		if a.value ~= 0 and b.value == 0 then
			return true
		elseif b.value ~= 0 and a.value == 0 then
			return false
		else
			return a.type < b.type
		end
	end)
	local res = {}

	for i, v in ipairs(data) do
		table.insert(res, v.log)
	end

	LogTable(string.format( "实体[%s&%s]属性列表:", entityId, entity.entityId),res)
end


function DebugClientInvoke.TDDoMagic(instanceId, targetInstanceId,magicId)
	local TDDoMagic_instanceId = tonumber(instanceId)
	local TDDoMagic_targetInstanceId = tonumber(targetInstanceId)
	local TDDoMagic_magicId = tonumber(magicId)
	BehaviorFunctions.DoMagic(TDDoMagic_instanceId, TDDoMagic_targetInstanceId, TDDoMagic_magicId)
end

function DebugClientInvoke.TDLogEntitySheild(entityid)
	local TDLogEntitySheild_entityid=tonumber(entityid)
	local entity = BehaviorFunctions.GetEntity(TDLogEntitySheild_entityid)
	local res = {}
	for k, v in pairs(entity.attrComponent.backups[3]) do
		if k==110 or k ==111 or k ==112 or k ==113 or k ==114 or k ==115 or k ==116 or k ==117 or k ==118 or k ==119 then
			table.insert(res, {key = k, value = v})
		end
	end
	table.sort(res, function(a, b)
		return a.key < b.key
	end)
	LogTable("属性信息", res)
end

function DebugClientInvoke.ShowCheckEntityCollide()
	DebugConfig.ShowCheckEntityCollide = not DebugConfig.ShowCheckEntityCollide
end

function DebugClientInvoke.ForceAllowDoubleJump()
	local curInstanceId = BehaviorFunctions.GetCtrlEntity()
	BehaviorFunctions.SetAllowDoubleJump(curInstanceId, true)
end

function DebugClientInvoke.FastMagic(magicId, targetInstanceId, isAdd)
	magicId = tonumber(magicId)
	if targetInstanceId == "" then
		targetInstanceId = BehaviorFunctions.GetCtrlEntity()
	else
		targetInstanceId = tonumber(targetInstanceId)
	end
	if isAdd == "-1" then
		isAdd = false
	else
		isAdd = true
	end

	if isAdd then
		BehaviorFunctions.DoMagic(1, targetInstanceId, magicId)
	else
		BehaviorFunctions.RemoveBuff(targetInstanceId, magicId)
	end
end

function DebugClientInvoke.FastEntitySign(entitySignId, targetInstanceId, isAdd)
	entitySignId = tonumber(entitySignId)
	if targetInstanceId == "" then
		targetInstanceId = BehaviorFunctions.GetCtrlEntity()
	else
		targetInstanceId = tonumber(targetInstanceId)
	end
	if isAdd == "-1" then
		isAdd = false
	else
		isAdd = true
	end

	if isAdd then
		BehaviorFunctions.AddEntitySign(targetInstanceId, entitySignId)
	else
		BehaviorFunctions.RemoveEntitySign(targetInstanceId, entitySignId)
	end
end

function DebugClientInvoke.LoadLuaFile()
	if Application.platform == RuntimePlatform.WindowsEditor then
		local relactivePath = "/../../"
		local luaPath = IOUtils.GetAbsPath(Application.dataPath .. relactivePath .."other.lua")
		local f = io.open(luaPath, "r")
		if f ~= nil then
			io.close(f)
			local ff = loadfile(luaPath, "t")
			ff()
		else
			LogError(luaPath .. " 文件不存在")
		end
	end
	
end

function DebugClientInvoke.OpenDamgeStatistics()
	if not DebugClientInvoke.Cache.debugDamagePanel then
		DebugClientInvoke.Cache.debugDamagePanel = DebugDamagePanel.New()
		DebugClientInvoke.Cache.debugDamagePanel:Show()
		return
	end

	if DebugClientInvoke.Cache.debugDamagePanel.active then
		DebugClientInvoke.Cache.debugDamagePanel:Hide()
	else
		DebugClientInvoke.Cache.debugDamagePanel:Show()
	end
end

-- 创建生态怪物，测试时需要数值修改生态表的怪物重生时间为负数，怪物生成地点是对应生态表的position
function DebugClientInvoke.CreateEcoEntity(_ecoId, _level)
	BehaviorFunctions.CreateEcoEntity(_ecoId, _level)
end 

-- 设置不受伤害状态但保持受击效果
function DebugClientInvoke.SetInvincibleState()
	if DebugClientInvoke.Cache.IsInvincibleSwitchOn == nil then
		DebugClientInvoke.Cache.IsInvincibleSwitchOn = true
	else
		DebugClientInvoke.Cache.IsInvincibleSwitchOn = not DebugClientInvoke.Cache.IsInvincibleSwitchOn
	end

	if DebugClientInvoke.Cache.IsInvincibleSwitchOn then
		LogInfo("开启无敌状态")
	else
		LogInfo("关闭无敌状态")
	end
end

function DebugClientInvoke.DisableEcoAndCar()
	if DebugClientInvoke.Cache.IsDisableEcoAndCar == nil then
		DebugClientInvoke.Cache.IsDisableEcoAndCar = true
	end

	if DebugClientInvoke.Cache.IsDisableEcoAndCar then
		LogInfo("禁用生态和车辆")
		BehaviorFunctions.fight.entityManager.trafficManager:ClearCtrl()
		for k, v in pairs(BehaviorFunctions.fight.entityManager.ecosystemCtrlManager.ecosystemCtrls) do
			v:Unload()
		end
		BehaviorFunctions.fight.entityManager.ecosystemCtrlManager:Pause()
	end
end

function DebugClientInvoke.LoadABAsset(path, dis)
	local loader
	if AssetBatchLoader.UseLocalRes then
		Log("当前为本地模式")
	else
		Log("当前为AB模式")
	end
	local prefix = "Assets/Things/"
	if string.sub(path, 1, string.len(prefix)) == prefix then
        path = string.sub(path, string.len(prefix) + 1)
    end
	local function func()
		local role = BehaviorFunctions.GetCtrlEntity()
		dis = dis and tonumber(dis) or 5
		local pos = BehaviorFunctions.GetPositionOffsetBySelf(role, dis, 0)
		local obj = loader:Pop(path)
		UnityUtils.SetPosition(obj.transform,pos.x,pos.y,pos.z)
		AssetMgrProxy.Instance:CacheLoader(loader)
	end

	local list = {{path = path, type = AssetType.Prefab}}
	loader = AssetMgrProxy.Instance:GetLoader("LoadABAsset")
	loader:AddListener(func)
	loader:LoadAll(list)
end

function DebugClientInvoke.OpenAbilityFightPanel()
	mod.AbilityWheelCtrl:OpenFightAbilityWheel(false)
end

function DebugClientInvoke.OpenPartnerDisplayDebug()
	Fight.Instance.entityManager.partnerDisplayManager.debug = true
	Fight.Instance.entityManager.partnerDisplayManager:UpdateAllDisplayDecoration()
end

function DebugClientInvoke.UnloadUnusedAssets()
	AssetManager.UnloadUnusedAssets(true)
end

function DebugClientInvoke.SetMapTool()
	DebugConfig.MapToolOpen = not DebugConfig.MapToolOpen
	if DebugConfig.MapToolOpen then 
		MsgBoxManager.Instance:ShowTips(TI18N("地图工具已开启"), 1)
	else
		MsgBoxManager.Instance:ShowTips(TI18N("地图工具已关闭"), 1)
	end
end