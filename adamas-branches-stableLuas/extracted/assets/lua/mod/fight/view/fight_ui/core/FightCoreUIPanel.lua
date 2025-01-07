FightCoreUIPanel = BaseClass("FightCoreUIPanel", BasePanel)

function FightCoreUIPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Fight/FightCoreUIPanel.prefab")
    self.mainView = parent
    self.btns = {}
	self.btnAlpha = {}
    self.effectMap = {}

	self.coreUI = {}
end

function FightCoreUIPanel:__BaseShow()

end

function FightCoreUIPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
    EventMgr.Instance:AddListener(EventName.StoryDialogEnd, self:ToFunc("ShowPanel"))
	EventMgr.Instance:AddListener(EventName.StoryDialogStart, self:ToFunc("HidePanel"))
	EventMgr.Instance:AddListener(EventName.CloseAllUI, self:ToFunc("CloseUI"))
end

function FightCoreUIPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.PlayerUpdate, self:ToFunc("UpdatePlayer"))
    EventMgr.Instance:RemoveListener(EventName.StoryDialogEnd, self:ToFunc("ShowPanel"))
	EventMgr.Instance:RemoveListener(EventName.StoryDialogStart, self:ToFunc("HidePanel"))
	EventMgr.Instance:RemoveListener(EventName.CloseAllUI, self:ToFunc("CloseUI"))
	for k, v in pairs(self.coreUI) do
		v:Cache()
	end
	self.coreUI = {}
end

function FightCoreUIPanel:__Show()
end

function FightCoreUIPanel:__ShowComplete()
    self.loadDone = true
	self:UpdatePlayer()
end

function FightCoreUIPanel:CloseUI()
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByScale(self.CoreUIParent,false)
		return
	else
		UtilsUI.SetActiveByScale(self.CoreUIParent,true)
	end
end

--更新技能界面（按组成刷新,拆分每个图层的逻辑）

function FightCoreUIPanel:Update()
	for k, v in pairs(self.coreUI) do
		if v.enable then
			v:Update()
		end
	end
end

--更换角色(切换到对应配置，对应技能状态)
function FightCoreUIPanel:UpdatePlayer()
    if not self.loadDone then return end
    self.playerObject = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
	local lastRoleId = self.playerObject and self.playerObject.masterId or -1
    self.skillSetComponent = self.playerObject.skillSetComponent
	self:UpdateCoreUI(lastRoleId)
	
	if self.coreUI and next(self.coreUI) then
		UnityUtils.SetActive(self.CoreUIParent, true)
	end
end

function FightCoreUIPanel:UpdateCoreUI(lastRoleId)

	local roleList = mod.FormationCtrl:GetCurFormationInfo().roleList
    for k, v in pairs(self.coreUI) do
        v:SetCoreUIEnable(false)
		
		local contain = false
		for i = 1, #roleList do
			if roleList[i] == k then
				contain = true
			end
		end
		
		if not contain then
			v:Cache()
			self.coreUI[k] = nil
		end
    end

	local curRoleId = self.playerObject and self.playerObject.masterId or -1
	if curRoleId ~= -1 then
		local coreUI = self.coreUI[curRoleId]
		if not coreUI then
			local config = self.playerObject.skillSetComponent.setConfig.CoreUIConfig
			local coreUILogic = _G["CoreUILogic"..self.playerObject.entityId]
			if config and coreUILogic then
            self.coreUI[curRoleId] = Fight.Instance.objectPool:Get(coreUILogic)
				--coreUILogic.New(self.playerObject, config, self.CoreUIParent.transform, self.canvas.sortingOrder)
				coreUI = self.coreUI[curRoleId]
				coreUI:Init(self.playerObject, config, self.CoreUIParent.transform, self.canvas.sortingOrder)
			end
		end

		if coreUI then
			coreUI:SetCoreUIEnable(true)
			coreUI:EntityAttrChange(coreUI.bindRes, self.playerObject)
		end
	end
end

function FightCoreUIPanel:ShowPanel()
    self:SetPanelActive(true)
end

function FightCoreUIPanel:HidePanel()
    self:SetPanelActive(false)
end

function FightCoreUIPanel:SetPanelActive(active)
	if not self.loadDone then
		return
	end
    UtilsUI.SetActiveByPosition(self.CoreUIParent, active)
end
