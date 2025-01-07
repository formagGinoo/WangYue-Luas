FormationWindowV2 = BaseClass("FormationWindowV2", BaseWindow)

function FormationWindowV2:__init()
    self:SetAsset("Prefabs/UI/Formation/FormationWindowV2.prefab")
    self.selectMap = self.selectMap or {}
    self.curFormationId = 0
end

function FormationWindowV2:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeShowRole, self:ToFunc("SelectRole"))
    EventMgr.Instance:RemoveListener(EventName.FormationRoleSubmit, self:ToFunc("SubmitRole"))
    EventMgr.Instance:RemoveListener(EventName.FormationSubmit, self:ToFunc("SubmitFormation"))
    EventMgr.Instance:RemoveListener(EventName.FormationListHide, self:ToFunc("RoleListClose"))
    EventMgr.Instance:RemoveListener(EventName.FormationUpdate, self:ToFunc("UpdateCurFormation"))
    
end

function FormationWindowV2:__BindListener()
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("SelectRole"))
    EventMgr.Instance:AddListener(EventName.FormationRoleSubmit, self:ToFunc("SubmitRole"))
    EventMgr.Instance:AddListener(EventName.FormationSubmit, self:ToFunc("SubmitFormation"))
    EventMgr.Instance:AddListener(EventName.FormationListHide, self:ToFunc("RoleListClose"))
    EventMgr.Instance:AddListener(EventName.FormationUpdate, self:ToFunc("UpdateCurFormation"))

    --self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close"))
    self.SimpleFormation_btn.onClick:AddListener(self:ToFunc("OnClick_SimpleFormation"))
    self.FormationTemplate_btn.onClick:AddListener(self:ToFunc("OnClick_FormationTemplate"))
end

function FormationWindowV2:__Create()
    self.roleNodes = {}
    for i = 1, 3, 1 do
        self.roleNodes[i] = {}
        UtilsUI.GetContainerObject(self["Role"..i.."_rect"], self.roleNodes[i])
    end
end

function FormationWindowV2:__Show()
    self:ShowCurFormation()
    self.exist = true
end

function FormationWindowV2:__Hide()
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Formation)
    mod.FormationCtrl:UpdateFightFormation()
    self.exist = false
end

function FormationWindowV2:CheckActive()
    return self.exist
end

function FormationWindowV2:ShowCurFormation()
    self:GetModelView():BlendToNewCamera(FormationConfig.CameraPos.Far.pos, FormationConfig.CameraPos.Far.rot)
    local curInfo = self:GetCurFormationInfo()
    self.oldFormation = TableUtils.CopyTable(curInfo.roleList)
    for i = 1, 3, 1 do
        local roleId = curInfo.roleList[i] or 0
        self:ShowRoleInfo(i, roleId)
    end
end

function FormationWindowV2:UpdateCurFormation(id)
    if id ~= self:GetCurFormationId() then
        return
    end
    local curInfo = self:GetCurFormationInfo()
    for i = 1, 3, 1 do
        -- local oldId = self.oldFormation[i] or 0
        local roleId = curInfo.roleList[i] or 0
        self:GetModelView():ShowModelRoot("FormationRoot_"..i, false)
        if roleId ~= 0 then
            self:GetModelView():ShowModelRoot("FormationRoot_"..i, true)
            self:GetModelView():LoadModel("FormationRoot_"..i ,roleId)
        end
        if self.curIndex then
            if i == self.curIndex then
                self:GetModelView():ShowModelRoot("FormationRoot_"..i, true)
            else
                self:GetModelView():ShowModelRoot("FormationRoot_"..i, false)
                self:ShowRoleInfo(i, roleId)
            end
        else
            self:ShowRoleInfo(i, roleId)
        end
    end
    self.oldFormation = curInfo.roleList
    self:CallPanelFunc("UpdateFormation", self.oldFormation)
end

function FormationWindowV2:ShowRoleInfo(index, roleId)
    --self["Role"..index]:SetActive(roleId ~= 0)
    self["Role"..index.."_btn"].onClick:RemoveAllListeners()
    self["Role"..index.."_btn"].onClick:AddListener(function ()
        self:OpenRoleSelect(index)
    end)
    local node = self.roleNodes[index]
    node.Info:SetActive(roleId ~= 0)
    node.AddButton:SetActive(roleId == 0)
    if roleId == 0 then
        return
    end
    local roleData = mod.RoleCtrl:GetRoleData(roleId)
    local config = RoleConfig.GetRoleConfig(roleId)

    local iconPath = RoleConfig.GetAElementIcon(config.element)
    SingleIconLoader.Load(node.Element, iconPath)
    local attrMap = mod.RoleCtrl:GetRolePropertyMap(roleId)
    local instanceId = BehaviorFunctions.fight.playerManager:GetPlayer():GetInstanceIdByHeroId(roleId)
    if instanceId then
        local entity = BehaviorFunctions.GetEntity(instanceId)
        local curLife = entity.attrComponent:GetValue(FormationConfig.SyncProperty.CurLife)
        local maxLife = entity.attrComponent:GetValue(FormationConfig.SyncProperty.MaxLife)
        local value = curLife / maxLife
        node.LifeBar_img.fillAmount = value
    elseif attrMap[FormationConfig.SyncProperty.CurLife] then
        local value = attrMap[FormationConfig.SyncProperty.CurLife] / attrMap[FormationConfig.SyncProperty.MaxLife]
        node.LifeBar_img.fillAmount = value
    end
    node.Level_txt.text = roleData.lev
    node.Name_txt.text = config.name
end

function FormationWindowV2:OpenRoleSelect(index)
    self.isNearState = true
    self.curIndex = index
    self.WindowBody:SetActive(false)
    for i = 1, 3, 1 do
        self:GetModelView():ShowModelRoot("FormationRoot_"..i, i == index)
    end
    if not self.oldFormation[self.curIndex] or self.oldFormation[self.curIndex] == 0 then
        self:GetModelView():ShowModelRoot("FormationRoot_"..index, false)
    end
    local config = {
        curIndex = self.curIndex,
        roleList = self.oldFormation
    }

    local roleId = config.roleList[config.curIndex]
    local cfg = RoleConfig.GetRoleCameraConfig(roleId, RoleConfig.PageCameraType["FormationN"..self.curIndex])
    self:GetModelView():BlendToNewCamera(cfg.camera_position, cfg.camera_rotation)
    self:GetModelView():SetModelRootRotation("FormationRoot_"..index, cfg.model_rotation)
    self:GetModelView():PlayModelAnim("FormationRoot_"..index, cfg.anim, 0.5)

    self.selectMap[self.curIndex] = self.oldFormation[self.curIndex]
    self:OpenPanel(RoleListPanel,config)
end

function FormationWindowV2:OnClick_SimpleFormation()
    self.WindowBody:SetActive(false)
    local config = {
        curIndex = self.curIndex,
        roleList = self.oldFormation,
        selectMode = FormationConfig.SelectMode.Plural
    }
    self:OpenPanel(RoleListPanel,config)
end

function FormationWindowV2:OnClick_FormationTemplate()
    WindowManager.Instance:OpenWindow(FormationEditorWindow)
end

function FormationWindowV2:SelectRole(id)
    local curInfo = self:GetCurFormationInfo()
    local roleId = self.selectMap[self.curIndex] or curInfo.roleList[self.curIndex] or 0
    if roleId == id then
        return
    end
    self.selectMap[self.curIndex] = id
    self:GetModelView():LoadModel("FormationRoot_"..self.curIndex, id, function ()
        self:GetModelView():ShowModelRoot("FormationRoot_"..self.curIndex, true)
        local cfg = RoleConfig.GetRoleCameraConfig(id, RoleConfig.PageCameraType["FormationN"..self.curIndex])
        self:GetModelView():BlendToNewCamera(cfg.camera_position, cfg.camera_rotation)
        self:GetModelView():SetModelRootRotation("FormationRoot_"..self.curIndex, cfg.model_rotation)
        self:GetModelView():PlayModelAnim("FormationRoot_"..self.curIndex, cfg.anim, 0.5)
    end)
end

function FormationWindowV2:SubmitRole(id)
    local curInfo = self:GetCurFormationInfo()
    local oldId = curInfo.roleList[self.curIndex] or 0
    if oldId == id then
        local updateList = TableUtils.CopyTable(curInfo.roleList)
        updateList[self.curIndex] = 0
        if mod.FormationCtrl:ReqFormationUpdate(self:GetCurFormationId(), updateList) then
            self:ClosePanel(RoleListPanel)
        end
    else
        local updateList = TableUtils.CopyTable(curInfo.roleList) or {}
        for key, value in pairs(updateList) do
            if value == id and key ~= self.curIndex then
                updateList[key] = oldId
            end
        end
        updateList[self.curIndex] = id
        for i = 1, 3, 1 do
            if not updateList[i] then
                updateList[i] = 0
            end
        end
        if mod.FormationCtrl:ReqFormationUpdate(self:GetCurFormationId(), updateList) then
            self:ClosePanel(RoleListPanel)
        end
    end
end

function FormationWindowV2:SubmitFormation(roleList)
    if mod.FormationCtrl:ReqFormationUpdate(self:GetCurFormationId(), roleList) then
        self:ClosePanel(RoleListPanel)
    end
end


function FormationWindowV2:RoleListClose()
    self.isNearState = false
    self.WindowBody:SetActive(true)
    local curInfo = self:GetCurFormationInfo()
    for i = 1, 3, 1 do
        local roleId = curInfo.roleList[i] or 0
        local rot = FormationConfig.ModelPos["Far_"..i].rot
        self:GetModelView():ShowModelRoot("FormationRoot_"..i, true)
        if roleId ~= 0 then
            self:GetModelView():LoadModel("FormationRoot_"..i ,roleId)
        else
            self:GetModelView():ShowModelRoot("FormationRoot_"..i, false)
        end
        self:GetModelView():SetModelRootRotation("FormationRoot_"..i, rot)
        self:ShowRoleInfo(i, roleId)
    end
    self.curIndex = nil
    TableUtils.ClearTable(self.selectMap)
    self:GetModelView():BlendToNewCamera(FormationConfig.CameraPos.Far.pos, FormationConfig.CameraPos.Far.rot)
    if self:GetCurFormationId() ~= 0 then
        WindowManager.Instance:OpenWindow(FormationEditorWindow)
    end
end

function FormationWindowV2:Close()
    WindowManager.Instance:CloseWindow(self)
end

function FormationWindowV2:UpdateRoleList(...)
    self:CallPanelFunc("UpdateRoleList", ...)
end

function FormationWindowV2:RefreshItemList(...)
    self:CallPanelFunc("RefreshItemList", ...)
end

function FormationWindowV2:GetModelView()
    return Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Formation)
end

function FormationWindowV2:SetCurFormationId(id)
    self.curFormationId = id
    self:UpdateCurFormation(id)
end

function FormationWindowV2:GetCurFormationId()
    return self.curFormationId or 0
end

function FormationWindowV2:GetCurFormationInfo()
    return mod.FormationCtrl:GetFormationInfo(self:GetCurFormationId())
end
local isLoading = false
function FormationWindowV2.OpenWindow()
    local roleList = mod.FormationCtrl:GetFormationInfo(0).roleList
    if isLoading then
        return
    end
    isLoading = true
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.Formation, function ()
        Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Formation):LoadScene(ModelViewConfig.Scene.Formation, function ()
            local loadCount = 1
            local onLoad = function ()
                loadCount = loadCount - 1
                if loadCount == 0 then
                    isLoading = false
                    WindowManager.Instance:OpenWindow(FormationWindowV2)
                    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Formation)
                end
            end
            for i = 1, #roleList, 1 do
                local roleId = roleList[i] or 0
                if roleId ~= 0 then
                    loadCount = loadCount + 1
                    Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Formation):ShowModelRoot("FormationRoot_"..i, true)
                    Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Formation):LoadModel("FormationRoot_"..i, roleId, onLoad)
                else
                    Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Formation):ShowModelRoot("FormationRoot_"..i, false)
                end
                local rot = FormationConfig.ModelPos["Far_"..i].rot
                Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Formation):SetModelRootRotation("FormationRoot_"..i, rot)
            end
            onLoad()
        end)
    end)
end