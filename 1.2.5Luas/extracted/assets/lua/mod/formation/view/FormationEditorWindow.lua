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
                WindowManager.Instance:OpenWindow(FormationWindowV2)
                local window = WindowManager.Instance:GetWindow("FormationWindowV2")
                window:SetCurFormationId(i)
                window:OpenRoleSelect(j)
            end)
        end

        teamObj.SimpleFormation_btn.onClick:AddListener(function ()
            WindowManager.Instance:OpenWindow(FormationWindowV2)
            local window = WindowManager.Instance:GetWindow("FormationWindowV2")
            window:SetCurFormationId(i)
            window:OnClick_SimpleFormation()
        end)
        teamObj.SelectButton_btn.onClick:AddListener(function ()
            self:SelectTemplate(i)
        end)
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
end

function FormationEditorWindow:__Show()
    for i = 1, 10, 1 do
        self:ShowTeamById(i)
    end
end

function FormationEditorWindow:__Hide()
    local window = WindowManager.Instance:GetWindow("FormationWindowV2")
    window:SetCurFormationId(0)
end

function FormationEditorWindow:ShowTeamById(id)
    if id == 0 then
        return
    end
    local curInfo = mod.FormationCtrl:GetFormationInfo(id)
    local roleList = curInfo.roleList
    local teamObj = self.TeamObjMap[id]
    if curInfo.name == "" or not curInfo.name then
        teamObj.Name_txt.text = TI18N("编队"..id)
    else
        teamObj.Name_txt.text = curInfo.name
    end

    for i = 1, 3, 1 do
        local roleId = roleList[i] or 0
        local config = ItemConfig.GetItemConfig(roleId)
        local roleObj = self.roleObjMap[id][i]
        roleObj.Add:SetActive(roleId == 0)
        roleObj.RoleInfo:SetActive(roleId ~= 0)
        if roleId ~= 0 then
            local frontImg, backImg = ItemManager.GetItemColorImg(config.quality)
            local backPath = AssetConfig.GetQualityIcon(backImg)
            --SingleIconLoader.Load(itemObj.QualityFront, frontPath)
            local path = RoleConfig.GetAElementIcon(config.element)
            SingleIconLoader.Load(roleObj.Element, path)
            SingleIconLoader.Load(roleObj.Quality, backPath)
            local roleData = mod.RoleCtrl:GetRoleData(roleId)
            roleObj.Name = config.Name
            roleObj.Level_txt.text = "Lv."..roleData.lev
            SingleIconLoader.Load(roleObj.Icon,config.rhead_icon)
        end
    end
end

function FormationEditorWindow:SelectTemplate(id)
    local curInfo = mod.FormationCtrl:GetFormationInfo(id)
    if mod.FormationCtrl:ReqFormationUpdate(0, curInfo.roleList) then
        WindowManager.Instance:CloseWindow(self)
    end
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
    WindowManager.Instance:CloseWindow(self)
end