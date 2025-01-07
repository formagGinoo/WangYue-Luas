FormationEditorWindow = BaseClass("FormationEditorWindow", BaseWindow)

function FormationEditorWindow:__init()
    self:SetAsset("Prefabs/UI/Formation/FormationEditorWindow.prefab")
end

function FormationEditorWindow:__Create()
    self.TeamObjMap = {}
    self.roleObjMap = {}
    for i = 1, 10, 1 do
        local teamObj = self:PopUITmpObject("TeamObj")
        teamObj.objectTransform:SetParent(self.TeamList_rect)
        teamObj.objectTransform:ResetAttr()
        self.TeamObjMap[i] = teamObj
        self.roleObjMap[i] = {}
        for j = 1, 3, 1 do
            self.roleObjMap[i][j] = {}
            UtilsUI.GetContainerObject(teamObj["Role"..j.."_rect"], self.roleObjMap[i][j])
            teamObj["Role"..j.."_btn"].onClick:AddListener(function ()
                local params = {
                    callback = function ()
                        local window = WindowManager.Instance:GetWindow("FormationWindowV2")
                        window:SetCurFormationId(i)
                        window:OpenRoleSelect(j)
                    end
                }
                FormationWindowV2.OpenWindow(params)
            end)
        end

        teamObj.SimpleFormation_btn.onClick:AddListener(function ()
            local params = {
                callback = function ()
                    local window = WindowManager.Instance:GetWindow("FormationWindowV2")
                    window:SetCurFormationId(i)
                    window:OnClick_SimpleFormation()
                end
            }
            FormationWindowV2.OpenWindow(params)
        end)
        teamObj.SelectButton_btn.onClick:AddListener(function ()
            self:SelectTemplate(i)
        end)
        --特殊情况隐藏覆盖按钮 todo 
        teamObj.CoverButton_btn.onClick:AddListener(function ()
            self:CoverTemplate(i)
        end)
        teamObj.Rename_btn.onClick:AddListener(function ()
            self:RenameFormation(i)
        end)
        teamObj.Clear_btn.onClick:AddListener(function ()
            self:ClearFormation(i)
        end)
    end


end

function FormationEditorWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.FormationUpdate, self:ToFunc("ShowTeamById"))
end

function FormationEditorWindow:__BindListener()
    EventMgr.Instance:AddListener(EventName.FormationUpdate, self:ToFunc("ShowTeamById"))
    self.CloseButton_btn.onClick:AddListener(self:ToFunc("OnClick_CloseButton"))

    self.scroll = self.TeamGroup:GetComponent(ScrollRect)
    self.TeamGroup_hcb.ActiveAction:AddListener(function ()
        self.scroll.enabled = false
        LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
            if self.scroll then
                self.scroll.enabled = true
            end
        end)
    end)
end

function FormationEditorWindow:__Show()
    if self.args and self.args.closeParent then
        self.closeParent = self.args.closeParent
    end
    self.formationState = {}
    for i = 1, 10, 1 do
        self:ShowTeamById(i)
    end
end

function FormationEditorWindow:__Hide()
    local window = WindowManager.Instance:GetWindow("FormationWindowV2")
    if window then
        window:SetCurFormationId(0)
    end
end

function FormationEditorWindow:ShowTeamById(id)
    if id == 0 then
        return
    end
    local curInfo = mod.FormationCtrl:GetFormationInfo(id)
    local roleList = curInfo.roleList
    local teamObj = self.TeamObjMap[id]
    if curInfo.name == "" or not curInfo.name then
        teamObj.Name_txt.text = string.format(TI18N("编队%d"),id)
    else
        teamObj.Name_txt.text = curInfo.name
    end

    local dirty = false
    for i = 1, 3, 1 do
        local roleId = roleList[i] or 0
        local config = ItemConfig.GetItemConfig(roleId)

        local roleObj = self.roleObjMap[id][i]
        roleObj.Add:SetActive(roleId == 0)
        roleObj.RoleDetailItem:SetActive(roleId ~= 0)
        if roleId ~= 0 then
            dirty = true
            roleObj.roleDetailItem = roleObj.roleDetailItem or RoleDetailItem.New()
            roleObj.roleDetailItem:InitItem(roleObj.RoleDetailItem, roleId)   
            roleObj.roleDetailItem:SetRedPoint(false)   
        end
    end

    self.formationState[id] = dirty
    if #self.formationState == 10 then
        local count = 0
        for k, v in pairs(self.formationState) do
            if v then
                count = count + 1
            end
        end
        --self.TeamCount_txt.text = string.format("%s/10", count)
    end
end

function FormationEditorWindow:SelectTemplate(id)
    local curInfo = mod.FormationCtrl:GetFormationInfo(id)
    if mod.FormationCtrl:ReqFormationUpdate(0, curInfo.roleList) then
        local closeParent = self.closeParent
        WindowManager.Instance:CloseWindow(self)
        self:CloseParent(closeParent)
    end
    EventMgr.Instance:Fire(EventName.FormationEditorSelect, curInfo.roleList)
end

function FormationEditorWindow:CoverTemplate(id)
    PanelManager.Instance:OpenPanel(FormationCoverPanel,{curId = id})
end

function FormationEditorWindow:RenameFormation(id)
    PanelManager.Instance:OpenPanel(FormationNameEditorPanel,{formationId = id})
end

function FormationEditorWindow:ClearFormation(id)
    local roleList = {0,0,0}
    MsgBoxManager.Instance:ShowTextMsgBox(TI18N("是否确定清除该预设队伍?"),function ()
        mod.FormationCtrl:ReqFormationUpdate(id, roleList)
    end)
end

function FormationEditorWindow:OnClick_CloseButton()
    local closeParent = self.closeParent
    WindowManager.Instance:CloseWindow(self)
    self:CloseParent(closeParent)
end

function FormationEditorWindow:CloseParent(closeParent)
    --如果需要在关闭该界面时，同时关闭父界面
    if closeParent then
        local window = WindowManager.Instance:GetWindow("FormationWindowV2")
        if window then
            WindowManager.Instance:CloseWindow(FormationWindowV2)
        end
    end
end