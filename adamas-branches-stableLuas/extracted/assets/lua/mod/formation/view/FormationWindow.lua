FormationWindow = BaseClass("FormationWindow", BaseWindow)

local DataHero = Config.DataHeroMain.Find

function FormationWindow:__init()
	self:SetAsset("Prefabs/UI/Formation/FormationWindow.prefab")

	self.robotBattle = false
	self.selectPanel = nil
	self.selectedList = {}
end

function FormationWindow:__BindEvent()

end

function FormationWindow:__BindListener()
	self.Back_btn.onClick:AddListener(self:ToFunc("OnBack"))
	self.Home_btn.onClick:AddListener(self:ToFunc("OnHome"))
	self.QuickFormate_btn.onClick:AddListener(self:ToFunc("OnQuickFormate"))
	self.Go_btn.onClick:AddListener(self:ToFunc("OnGo"))

	self.NextBtn_btn.onClick:AddListener(self:ToFunc("OnClick_NextFormation"))
	self.LastBtn_btn.onClick:AddListener(self:ToFunc("OnClick_LastFormation"))
	self.ChangeNameBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeFormationName"))
	
	self["AddBtn1_btn"].onClick:AddListener(function() self:OnAddRole(1) end)
	self["AddBtn2_btn"].onClick:AddListener(function() self:OnAddRole(2) end)
	self["AddBtn3_btn"].onClick:AddListener(function() self:OnAddRole(3) end)

	EventMgr.Instance:AddListener(EventName.FormationUpdate, self:ToFunc("UpdateFormation"))
end

function FormationWindow:__Create()
	self.formationNameInput = self.FormationName:GetComponent(TMP_InputField)
	self.formationNameInput.interactable = false
end

function FormationWindow:__delete()
	if self.selectPanel then
		self.selectPanel:Destroy()
	end

	for _, v in pairs(self.curShowList) do
		if v.modelRtView then
			v.modelRtView:DeleteMe()
		end
	end

	EventMgr.Instance:RemoveListener(EventName.FormationUpdate, self:ToFunc("UpdateFormation"))
end

function FormationWindow:__Show()
	self:UpdateFormation()
end

function FormationWindow:__Hide()
	for _, v in pairs(self.curShowList) do
		if v.modelRtView then
			v.modelRtView:Hide()
		end
	end
end

function FormationWindow:SetWindowVisible(visible, isQuick)
	self.TopLeft:SetActive(visible)
	self.BottomRight:SetActive(visible)
	
	--显示则显示，不显示则非快速编队时不显示
	local showFormation = isQuick or false
	self.Formation:SetActive(visible or showFormation)
end

function FormationWindow:UpdateFormation(forceUpdate)
	local curUseFormationId = mod.FormationCtrl:GetCurFormationId()
	if not self.curFormation then
		self.curFormation = mod.FormationCtrl:GetCurFormationInfo()
		self.curFormationId = self.curFormation.id
	elseif forceUpdate then
		self.curFormation = mod.FormationCtrl:GetFormationInfo(self.curFormationId)
	end

	local canGo = curUseFormationId ~= self.curFormationId
	if canGo then
		canGo = self.curFormation and next(self.curFormation)
	end
	
	self.formationNameInput.text = self.curFormation.name
	self.Go_btn.interactable = canGo
	self:UpdateRoleList()
end

-- TODO 属性没有同步 更新方法需要更改
function FormationWindow:UpdateRoleList()
	for i = 1, FormationConfig.MaxRoleNum do
		if self.curFormation.roleList[i] then
			self:ShowRole(i)
		else
			self:HideRole(i)
		end
	end
end

function FormationWindow:ShowRole(index)
	self["AddBtn"..index]:SetActive(false)
	self["ModelParent"..index]:SetActive(true)
	
	if self.curShowList and self.curShowList[index] then
		if self.curShowList[index].id == self.curFormation.roleList[index].id then
			return
		end
	else
		-- 临时
		if not self.curShowList then
			self.curShowList = {}
		end
		self.curShowList[index] = self:CreateBaseRole(index)
	end

	self:UpdateRoleData(index)
end

function FormationWindow:HideRole(index)
	self["AddBtn"..index]:SetActive(true)
	self["ModelParent"..index]:SetActive(false)
end

function FormationWindow:CreateBaseRole(index)
	local role = {}
	role.obj = GameObject.Instantiate(self.Role)
	role.obj.transform:SetParent(self["ModelParent"..index].transform)
	role.obj.transform.localScale = Vector3(1, 1, 1)
	role.obj.transform.localPosition = Vector3(0, -45, 0)
	role.obj:SetActive(true)

	role.node = UtilsUI.GetContainerObject(role.obj.transform)
	role.node.RoleBtn_btn.onClick:AddListener(function() self:OnAddRole(index) end)

	role.modelRtView = ModelRtView.New(role, role.node.RoleModel_rimg, true)
	role.modelRtView:SetCameraPosition(-0.07, 0.86, 1.65)

	return role
end

function FormationWindow:UpdateRoleData(index)
	local role = self.curShowList[index]

	role.id = self.curFormation.roleList[index].id
	role.data = self.curFormation.roleList[index]
	role.base = DataHero[self.curShowList[index].id]

	role.node.RoleName_txt.text = role.base.name

	local level = role.data and role.data.lev or 11
	role.node.LevelText_txt.text = level

	local path = AssetConfig.GetElementIcon(RoleConfig.Idx2Element[role.base.element])
	SingleIconLoader.Load(role.node.ElementIcon, path)

	if role.modelRtView then
		role.modelRtView:ShowHero(role.id)
		role.modelRtView:Show()
	end
end

function FormationWindow:OpenSubSelectPanel(index)
	if not self.selectPanel then
		self.selectPanel = FormationSelectPanel.New(self)
		self.selectPanel:SetCacheMode(UIDefine.CacheMode.hide)
	end

	--index为选的位置，如果没有则表明是多选逻辑
	local roleList = {}
	for i = 1, #self.curFormation.roleList do
		roleList[i] = self.curFormation.roleList[i].id
	end

	self.selectPanel:Show({roleList, index, self.curFormation.id})
end

function FormationWindow:OnAddRole(index)
	self:SetWindowVisible(false)
	self:OpenSubSelectPanel(index)
end

function FormationWindow:OnQuickFormate()
	self:SetWindowVisible(false, true)
	self:OpenSubSelectPanel()
end

function FormationWindow:OnBack()
	WindowManager.Instance:CloseWindow(FormationWindow)
end

function FormationWindow:OnHome()
	WindowManager.Instance:CloseAllWindow()
end

function FormationWindow:OnGo()
	mod.FormationCtrl:ReqUseFormation(self.curFormation.id)
end

function FormationWindow:OnClick_ChangeFormationName()
	if self.changingName then

	else
		-- self.changingName
	end
end

function FormationWindow:OnClick_NextFormation()
	if self.curFormationId >= 4 then
		return
	end

	self.curFormationId = self.curFormationId + 1
	self:UpdateFormation(true)
end

function FormationWindow:OnClick_LastFormation()
	if self.curFormationId <= 1 then
		return
	end

	self.curFormationId = self.curFormationId - 1
	self:UpdateFormation(true)
end