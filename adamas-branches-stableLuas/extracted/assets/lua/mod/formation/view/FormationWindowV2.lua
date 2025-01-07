FormationWindowV2 = BaseClass("FormationWindowV2", BaseWindow)

local DataWeapon = Config.DataWeapon.Find
local DataPartnerMain = Config.DataPartnerMain.Find
local DataHeroMain = Config.DataHeroMain.Find

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
    EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    
end

function FormationWindowV2:__BindListener()
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("SelectRole"))
    EventMgr.Instance:AddListener(EventName.FormationRoleSubmit, self:ToFunc("SubmitRole"))
    EventMgr.Instance:AddListener(EventName.FormationSubmit, self:ToFunc("SubmitFormation"))
    EventMgr.Instance:AddListener(EventName.FormationListHide, self:ToFunc("RoleListClose"))
    EventMgr.Instance:AddListener(EventName.FormationUpdate, self:ToFunc("UpdateCurFormation"))
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))

    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
    self.SimpleFormation_btn.onClick:AddListener(self:ToFunc("OnClick_SimpleFormation"))
    self.FormationTemplate_btn.onClick:AddListener(self:ToFunc("OnClick_FormationTemplate"))
    self.EnterFight_btn.onClick:AddListener(self:ToFunc("OnClick_EnterFight"))
end

function FormationWindowV2:__BeforeExitAnim()
    CurtainManager.Instance:FadeIn(true, 0.3)
    LuaTimerManager.Instance:AddTimer(1,0.5,function()
        CurtainManager.Instance:FadeOut(0.3)
    end)
end

function FormationWindowV2:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(FormationWindowV2)
end

function FormationWindowV2:__Create()
    local tf = self:GetModelView():GetTargetTransform("Formation3DUI", true)
    self.part3D = UtilsUI.GetContainerObject(tf)
    self.part3D.object = tf.gameObject
    self.roleNodes = {}
    for i = 1, 3, 1 do
        self.roleNodes[i] = {}
        UtilsUI.GetContainerObject(self.part3D["Role"..i.."_rect"], self.roleNodes[i])
    end
end

function FormationWindowV2:__Show()
    self.part3D.object:SetActive(true)
    if self.args then
        self.fightData = self.args.fightData
    end
    self:UpdateFormationMode()
    self:UpdateBtnView()
    self:UpdateTipsView()
    
    --是否需要展示副本编队
    if self.fightData then
        self:ShowDupFormation()
    else
        self:ShowCurFormation()
    end
    mod.FormationCtrl:PauseUpdate(true)
end

function FormationWindowV2:__ShowComplete()
    if self.args and self.args.callback then
        self.args.callback()
        self.args.callback = nil
    end
end

function FormationWindowV2:UpdateFormationMode()
    if not self.fightData then return end 
    --设置编队类型
    if DuplicateConfig.dupFormation[self.fightData.team_type] then
        local roleList = {}
        if self.fightData.team_type == DuplicateConfig.formationType.limitHeroType then
            roleList = self.fightData.team_request_id
        end
        --如果是副本编队则，切换为副本编队模式
        mod.FormationCtrl:SetDupFormation(roleList)
    end
end

function FormationWindowV2:UpdateBtnView()
    self.EnterFight:SetActive(false)
    if not self.fightData then
        return
    end
    --根据编队类型，决定按钮表现
    local team_type = self.fightData.team_type
    --有编队类型的情况下，需要校验是否带有同id的机器人或角色
    local isShowEnterFight = self:IsShowEnterFightBtn(team_type)
    self.EnterFight:SetActive(isShowEnterFight)

    if team_type == DuplicateConfig.formationType.limitHeroType then --编队2
        self.SimpleFormation:SetActive(false)--快速编队
        self.FormationTemplate:SetActive(false)--队伍预设
    elseif team_type == DuplicateConfig.formationType.heroType then--编队3
        self.SimpleFormation:SetActive(true)--快速编队
        self.FormationTemplate:SetActive(false)--队伍预设
    else
        self.SimpleFormation:SetActive(true)--快速编队
        self.FormationTemplate:SetActive(true)--队伍预设
    end
end

function FormationWindowV2:IsShowEnterFightBtn(team_type)
    local isShow = true
    local curInfo = self:GetCurFormationInfo()
    local curList = {}
    for i, id in pairs(curInfo.roleList) do
        curList[id] = id
    end
    
    if team_type and team_type ~= 0 then
        local team_request_id = self.fightData.team_request_id
        for i = 1, 3 do
            local robotId = team_request_id[i]
            if robotId ~= 0 and robotId ~= -1 then--表示需要校验
                --这里需要校验俩个id
                local robotInfo = RobotConfig.GetRobotHeroCfgById(robotId)
                local roleId = robotInfo.hero_id
                if curList[robotId] or curList[roleId] then
                    goto continue
                else
                    return false
                end
            end
            ::continue::
        end
    else
        isShow = true
    end
    
    return isShow
end

function FormationWindowV2:UpdateTipsView()
    self.teamRequestText:SetActive(false)
    if not self.fightData then
        return
    end
    if self.fightData.team_type == 0 then
        self.teamRequestText:SetActive(false)
        return
    end
    
    local tips = TI18N("队伍中必须包含")
    local team_request_id = self.fightData.team_request_id
    if team_request_id then
        for i, robotId in pairs(team_request_id) do
            if robotId ~= 0 and robotId ~= -1 then
                local robotInfo = RobotConfig.GetRobotHeroCfgById(robotId)
                tips = tips.." "..DataHeroMain[robotInfo.hero_id].name
            end
        end
    end
    self.teamRequestText_txt.text = team_request_id and tips or ""
    self.teamRequestText:SetActive(true)
end

function FormationWindowV2:__Hide()
    self.part3D.object:SetActive(true)
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.Formation)
    mod.FormationCtrl:PauseUpdate(false)
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

function FormationWindowV2:ShowDupFormation()
    self:GetModelView():BlendToNewCamera(FormationConfig.CameraPos.Far.pos, FormationConfig.CameraPos.Far.rot)
    local curInfo = self:GetCurFormationInfo()
    -- 注意程序会有逻辑判定此处是默认上阵机器人还是使用玩家自身的角色 
    --机器人数据和角色数据比较
    self.oldFormation = TableUtils.CopyTable(curInfo.roleList)
    for i = 1, 3, 1 do
        local roleId = curInfo.roleList[i] or 0
        local finalId = curInfo.roleList[i] or 0
        local itemCfg = ItemConfig.GetItemConfig(roleId)
        if itemCfg then
            roleId = itemCfg.hero_id
        end
        --最后得出机器人id或者角色id
        finalId = self:CompareRoleAndRobot(roleId, finalId)
        self:ShowRoleInfo(i, finalId)
    end
end

function FormationWindowV2:CompareRoleAndRobot(roleId, robotId)
    local roleData = mod.RoleCtrl:GetRoleData(roleId)
    if not roleData then
        return robotId
    end
    
    local roleWeaponData = mod.BagCtrl:GetWeaponData(roleData.weapon_id)
    local rolePartnerData = mod.BagCtrl:GetPartnerData(roleData.partner_id)
    local roleDataBySort = {
        id = roleId,
        lev = roleData.lev,
        star = roleData.star,
        weapon_id = roleData.weapon_id,
        weapon_level = roleWeaponData and roleWeaponData.lev or 0,
        partner_id = roleData.partner_id,
        partner_level = rolePartnerData and rolePartnerData.lev or 0,
    }
    local robotCfg = RobotConfig.GetRobotHeroCfgById(robotId)
    local robotDataBySort = {
        id = robotId,
        lev = robotCfg.hero_level,
        star = robotCfg.hero_star,
        weapon_id = robotCfg.weapon_id,
        weapon_level = robotCfg.weapon_level,
        partner_id = robotCfg.partner_id,
        partner_level = robotCfg.partner_level,
    }
    
    local roleSortData = {}
    table.insert(roleSortData, roleDataBySort)
    table.insert(roleSortData, robotDataBySort)
    
    --比较，返回大的那个
    --成员等级高低
    --成员脉象等级高低
    --成员武器品质高低/成员武器等级高低
    --成员月灵品质高低/成员月灵等级高低
    --如果都一致，优先机器人
    
    ---等级
    local levelSortFun = function(a, b)
        if a.lev == b.lev then
            return "equal"
        elseif a.lev < b.lev then
            return true
        else
            return false
        end
    end
    --脉象
    local starSortFun = function(a, b)
        if a.star == b.star then
            return "equal"
        elseif a.star < b.star then
            return true
        else
            return false
        end
    end
    --成员武器品质 
    local weaponQualitySortFun = function(a, b)
        local aDataWeaponConfig = DataWeapon[a.weapon_id]
        local bDataWeaponConfig = DataWeapon[b.weapon_id]
        if aDataWeaponConfig.quality == bDataWeaponConfig.quality then
            return "equal"
        elseif aDataWeaponConfig.quality < bDataWeaponConfig.quality then
            return true
        else
            return false
        end
    end
    --成员武器等级
    local weaponLevSortFun = function(a, b)
        if a.weapon_level == b.weapon_level then
            return "equal"
        elseif a.weapon_level < b.weapon_level then
            return true
        else
            return false
        end
    end
    --月灵品质高低
    local partnerQualitySortFun = function(a, b)
        local aPartnerConfig = DataPartnerMain[a.partner_id]
        local bPartnerConfig = DataPartnerMain[b.partner_id]
        if aPartnerConfig.quality == bPartnerConfig.quality then
            return "equal"
        elseif aPartnerConfig.quality < bPartnerConfig.quality then
            return true
        else
            return false
        end
    end
    --月灵等级高低
    local partnerLvSortFun = function(a, b)
        if a.partner_level == b.partner_level then
            return "equal"
        elseif a.partner_level < b.partner_level then
            return true
        else
            return false
        end
    end
    
    local sortFunList = {
        levelSortFun,
        starSortFun,
        weaponQualitySortFun,
        weaponLevSortFun,
        partnerQualitySortFun,
        partnerLvSortFun
    }

    local roleSortResult = UtilsBase.BubbleSort(roleSortData, function(a, b)
        for i = 1, #sortFunList do
            local result = sortFunList[i](a, b)
            if result ~= "equal" then
                return result
            end
        end
        return true
    end)
    
    return roleSortResult[2].id
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
        if roleId ~= 0 and roleId ~= -1 then
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
    if roleId ~= -1 then
        self["Role"..index.."_btn"].onClick:AddListener(function ()
            self:OpenRoleSelect(index)
        end)
    end
    local node = self.roleNodes[index]
    node.Info:SetActive(roleId ~= 0 and roleId ~= -1)
    node.AddButton:SetActive(roleId == 0)
    if roleId == 0 then
        return
    end
    if roleId == -1 then
        return
    end
    local roleData = mod.RoleCtrl:GetRoleData(roleId)
    local realRoleId = 0
    --判断机器人
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        roleData = RobotConfig.GetRobotHeroCfgById(roleId)
        realRoleId = roleData.hero_id
        node.Level_txt.text = roleData.hero_level
        node.BGLevel_txt.text = roleData.hero_level
        --显示试用标签
        node.robotTips:SetActive(true)
    else
        node.robotTips:SetActive(false)
        realRoleId = roleId
        local attrMap = mod.RoleCtrl:GetRolePropertyMap(roleId)
        local instanceId = BehaviorFunctions.fight.playerManager:GetPlayer():GetInstanceIdByHeroId(roleId)
        if instanceId then
            local entity = BehaviorFunctions.GetEntity(instanceId)
            local curLife = entity.attrComponent:GetValue(FormationConfig.SyncProperty.CurLife)
            local maxLife = entity.attrComponent:GetValue(FormationConfig.SyncProperty.MaxLife)
            local value = curLife / maxLife
            node.LifeBar_img.fillAmount = value
            node.BGLifeBar_img.fillAmount = value
        elseif attrMap[FormationConfig.SyncProperty.CurLife] then
            local value = attrMap[FormationConfig.SyncProperty.CurLife] / attrMap[FormationConfig.SyncProperty.MaxLife]
            node.LifeBar_img.fillAmount = value
            node.BGLifeBar_img.fillAmount = value
        end
        node.Level_txt.text = roleData.lev
        node.BGLevel_txt.text = roleData.lev
    end
    local config = RoleConfig.GetRoleConfig(realRoleId)
    node.Name_txt.text = config.name
    node.BGName_txt.text = config.name
    local iconPath = RoleConfig.GetAElementIcon(config.element)
    SingleIconLoader.Load(node.Element, iconPath)
end

function FormationWindowV2:OpenRoleSelect(index)
    local curInfo = self:GetCurFormationInfo()
    self.oldFormation = curInfo.roleList
    if self.fightData and self.fightData.team_type == DuplicateConfig.formationType.heroType then
        if not next(curInfo.roleList) then
            --如果编队类型为3，当还没选择角色时，则相当于打开快速编队
            self:OnClick_SimpleFormation()
            return
        end
    end

    self.isNearState = true
    self.curIndex = index
    self.part3D.RoleRoot:SetActive(false)
    self.WindowBody:SetActive(false)
    for i = 1, 3, 1 do
        self:GetModelView():ShowModelRoot("FormationRoot_"..i, i == index)
    end
    if not self.oldFormation[self.curIndex] or self.oldFormation[self.curIndex] == 0 then
        self:GetModelView():ShowModelRoot("FormationRoot_"..index, false)
    end
    local config = {
        curIndex = self.curIndex,
        roleList = self.oldFormation,
        team_type = self.fightData and self.fightData.team_type,
        team_request_id = self.fightData and self.fightData.team_request_id
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
    self.part3D.RoleRoot:SetActive(false)
    self.WindowBody:SetActive(false)
    local curInfo = self:GetCurFormationInfo()
    self.oldFormation = curInfo.roleList
    local config = {
        curIndex = self.curIndex,
        roleList = self.oldFormation,
        selectMode = FormationConfig.SelectMode.Plural,
        team_type = self.fightData and self.fightData.team_type,
        team_request_id = self.fightData and self.fightData.team_request_id
    }
    self:OpenPanel(RoleListPanel,config)
end

function FormationWindowV2:OnClick_FormationTemplate()
    WindowManager.Instance:OpenWindow(FormationEditorWindow)
end

function FormationWindowV2:OnClick_EnterFight()
    if not self.fightData then return end
    self.enterFightClick = true
    
    if Fight.Instance then
        Fight.Instance.duplicateManager:EnterFightFunc(self.fightData.systemDuplicateId, self.fightData)
    end
    mod.FormationCtrl:ResetFormation()
end

--重写
function FormationWindowV2:CloseByCommand()
    self:OnClick_Close()
end

function FormationWindowV2:OnClick_Close()
    if mod.FormationCtrl:NeedReloadFormation() then
        CurtainManager.Instance:EnterWait(SystemConfig.WaitType.Immediately)
        mod.FormationCtrl:UpdateFightFormation(true, function()
            CurtainManager.Instance:ExitWait()
            self:PlayExitAnim()
        end)
    else
        self:PlayExitAnim()
    end
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
        local func = function ()
            local tip
            if oldId == 0 then
                tip = TI18N("上阵成功")
            else
                tip = TI18N("替换成功")
            end
            MsgBoxManager.Instance:ShowTips(tip)
        end
        if mod.FormationCtrl:ReqFormationUpdate(self:GetCurFormationId(), updateList, func) then
            self:ClosePanel(RoleListPanel)
        end
    end
end

function FormationWindowV2:SubmitFormation(roleList)
    local func = function ()
        MsgBoxManager.Instance:ShowTips(TI18N("替换成功"))
    end
    if mod.FormationCtrl:ReqFormationUpdate(self:GetCurFormationId(), roleList, func) then
        self:ClosePanel(RoleListPanel)
    end
end


function FormationWindowV2:RoleListClose()
    self.isNearState = false
    self.part3D.RoleRoot:SetActive(true)
    self.WindowBody:SetActive(true)
    local curInfo = self:GetCurFormationInfo()
    if not curInfo.roleList then
        curInfo.roleList = {}
    end
    for i = 1, 3, 1 do
        local roleId = curInfo.roleList[i] or 0
        local rot = FormationConfig.ModelPos["Far_"..i].rot
        self:GetModelView():ShowModelRoot("FormationRoot_"..i, true)
        if roleId ~= 0 and roleId ~= -1 then
            if not mod.FormationCtrl:IsUpdateing() then
                self:GetModelView():LoadModel("FormationRoot_"..i ,roleId)
            end
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
    self:UpdateBtnView()
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
    return mod.FormationCtrl:GetOriginalFormation(self:GetCurFormationId())
end

function FormationWindowV2:RoleInfoUpdate(idx, roleData)
    -- if not self.tempHide then return end
    self:CallActivePanelFunc("UpdateRoleData", roleData)
end

-- function FormationWindowV2:TempShowWindow()
--     self.tempHide = false
-- end

-- function FormationWindowV2:TempHideWindow()
--     self.tempHide = true
-- end

local isLoading = false
function FormationWindowV2.OpenWindow(params)
    if isLoading then
        if params.callback then
            params.callback()
        end
        return
    end
    
    local roleList = mod.FormationCtrl:GetFormationInfo(0).roleList
    if params and params.fightData then
        local team_type = params.fightData.team_type
        if team_type == DuplicateConfig.formationType.limitHeroType then
            roleList = params.fightData.team_request_id
		elseif team_type == DuplicateConfig.formationType.heroType then
            roleList = {}
        end
    end
    
    local mainUI = WindowManager.Instance:GetWindow("FightMainUIView")
    local panel = mainUI:GetPanel(FightFormationPanel)
    panel.entityList = {}

    isLoading = true
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.Formation, function ()
        Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.Formation):LoadScene(ModelViewConfig.Scene.Formation, function ()
            local loadCount = 1
            local onLoad = function ()
                loadCount = loadCount - 1
                if loadCount == 0 then
                    isLoading = false
                    WindowManager.Instance:OpenWindow(FormationWindowV2, params)
                    Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.Formation)
                end
            end
            for i = 1, #roleList, 1 do
                local roleId = roleList[i] or 0
                
                if roleId ~= 0 and roleId ~= -1 then
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