DebugClientInvoke = {}

function DebugClientInvoke.SetCache(cache)
	DebugClientInvoke.Cache = cache
end

function DebugClientInvoke.ReloadLua()
	local cache = DebugClientInvoke.Cache
	
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
	if Fight.Instance then
		fightData = UtilsBase.copytab(Fight.Instance.fightData)

		local formationInfo = mod.FormationCtrl:GetCurFormationInfo()
		for k, v in pairs(formationInfo.roleList) do
			table.insert(heroList, v)
		end

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
		Fight.Instance:EnterFight(fightData, enterPosition)
	end
	
	DebugClientInvoke.SetCache(cache)
	DebugPlanInvoke.SetCache(cache)
	DebugTestInvoke.SetCache(cache)
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
end

function DebugClientInvoke.ToggleCollision()
	DebugClientInvoke.Cache.ShowCollider = not DebugClientInvoke.Cache.ShowCollider
end

function DebugClientInvoke.SetRoleDeath()
	local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	player.attrComponent:SetValue(EntityAttrsConfig.AttrType.Life, 0)
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
	else
		DebugClientInvoke.Cache.codeView:Show()
	end
end

function DebugClientInvoke.OpenStoryCtrl()
	if not DebugClientInvoke.Cache.debugStoryPanel then
		DebugClientInvoke.Cache.debugStoryPanel = PanelManager.Instance:OpenPanel(DebugStoryPanel)
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
		DebugClientInvoke.Cache.debugSettings:Show()
		return
	end
	if DebugClientInvoke.Cache.debugSettings.active then
		DebugClientInvoke.Cache.debugSettings:Hide()
	else
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