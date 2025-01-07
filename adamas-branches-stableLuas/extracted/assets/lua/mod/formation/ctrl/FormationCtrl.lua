---@class FormationCtrl : Controller
FormationCtrl = BaseClass("FormationCtrl",Controller)

local Max_Formation_Num = 10

function FormationCtrl:__init()
    self.formationList = {}
    for i = 0, Max_Formation_Num do
        self.formationList[i] = {id = i, name = "", roleList = {}}
    end
    self.curFormationId = 0
    self.curMode = FormationConfig.Mode.Default --编队模式
    self.curTeamType = nil --编队类型
end

function FormationCtrl:__delete()

end

function FormationCtrl:__InitComplete()

end

function FormationCtrl:SetTeamType(type)
    if type == 0 then
        type = nil
    end
    self.curTeamType = type
end

function FormationCtrl:GetTeamType()
    return self.curTeamType 
end

function FormationCtrl:ResetTeamType()
    self.curTeamType = nil
end

function FormationCtrl:SetMode(mode)
    self.curMode = mode
end

function FormationCtrl:UpdateAllFormation(data)
    for i = 1, #data.formation_list do
        local formation = data.formation_list[i]
        local id = formation.id
        local roleList = {}
        if type(formation.hero_id_list) == "number" then
            roleList[1] = formation.hero_id_list
        else
            roleList = formation.hero_id_list
        end
        self.formationList[id] = { id = id, name = formation.name, roleList = roleList }
        if self.curMode == FormationConfig.Mode.Default then
            self:UpdateFightFormationInfo(self:GetFormationInfo(0), true)
        end
    end
end


-- 更新单个编队信息
function FormationCtrl:UpdateFormation(id, roleList)
    if not self.formationList[id] then
        self.formationList[id] = {}
    end

    -- local detailList = {}
    -- for i = 1, #roleList do
    --     detailList[i] = mod.RoleCtrl:GetRoleData(roleList[i])
    -- end

    self.formationList[id].roleList = roleList
    EventMgr.Instance:Fire(EventName.FormationUpdate,id)

    if self.curFormationId == id then
        self:SetMode(FormationConfig.Mode.Default)
        self:UpdateFightFormationInfo(self:GetFormationInfo(0), true)
    end
end

function FormationCtrl:UpdateFightFormationInfo(curInfo, reload)
    self.fightFormation = self.fightFormation or {}
    self.fightFormation.roleList = self.fightFormation.roleList or {}
    TableUtils.ClearTable(self.fightFormation.roleList)
    for i = 1, 3, 1 do
        if curInfo.roleList[i] and curInfo.roleList[i] ~= 0 and curInfo.roleList[i] ~= -1 then
            table.insert(self.fightFormation.roleList, curInfo.roleList[i])
        end
    end
    if Fight.Instance and reload then
        if self.pause then
            self.isReloadFormation = true
            return
        else
            self:UpdateFightFormation(true)
        end
    end
end

function FormationCtrl:PauseUpdate(pause)
    self.pause = pause
end

function FormationCtrl:NeedReloadFormation()
    return self.isReloadFormation
end

function FormationCtrl:UpdateFightFormation(reload, callback)
    reload = reload or self.isReloadFormation
    self.isReloadFormation = false
    
    if reload then
        Fight.Instance.playerManager:GetPlayer():ChangeHeroList(self.fightFormation.roleList, callback)
    end
end

function FormationCtrl:UpdateFormationName(id, name)
    if not self.formationList[id] then
        self.formationList[id] = {}
    end

    self.formationList[id].name = name
    EventMgr.Instance:Fire(EventName.FormationUpdate,id)
end

function FormationCtrl:GetFormationInfo(id)
    if not self.formationList or not self.formationList[id] then
        return
    end

    return self.formationList[id]
end

function FormationCtrl:SetDebugFormation(roleList)
    self.debugFormation = {
        roleList = roleList
    }
    self:SetMode(FormationConfig.Mode.Debug)
    self:UpdateFightFormationInfo(self.debugFormation)
end

--副本内编队（副本专用）
function FormationCtrl:SetDupFormation(roleList)
    self.dupFormation = {
        roleList = roleList
    }
    self:SetMode(FormationConfig.Mode.Duplicate)
    self:UpdateFightFormationInfo(self.dupFormation)
end

function FormationCtrl:ResetFormation(reload)
    self:SetMode(FormationConfig.Mode.Default)
    self:UpdateFightFormationInfo(self:GetFormationInfo(0), reload)
end

function FormationCtrl:GetCurFormationInfo()
    local formation = self.fightFormation
	-- if not formation or not next(formation) or #formation.roleList == 0 then
    --     --TODO 旧账号用的还是编队1
	-- 	formation = self:GetFormationInfo(1)
	-- end

    return formation
end

function FormationCtrl:GetOriginalFormation(id)
    if self.curMode == FormationConfig.Mode.Default then
        return self:GetFormationInfo(id or 0)
    elseif self.curMode == FormationConfig.Mode.Debug then
        return self.debugFormation
    elseif self.curMode == FormationConfig.Mode.Duplicate then
        return self.dupFormation
    end
end

function FormationCtrl:ReqFormationUpdate(id, updateList, func)
    if self.curMode == FormationConfig.Mode.Duplicate then
        self:SetDupFormation(updateList)
        return true
    end
    if not self:CheckFormation(id, updateList) then
        return false
    end

    local data = {id = id, hero_id_list = updateList}
    self.isUpdateing = true
    CurtainManager.Instance:EnterWait()
    local id, cmd = mod.FormationFacade:SendMsg("formation_update", data)  
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function ()
        CurtainManager.Instance:ExitWait()
        self.isUpdateing = false
        if func then
            func()
        end
    end) 
    return true
end

function FormationCtrl:IsUpdateing()
    return self.isUpdateing
end

function FormationCtrl:CheckFormation(id, roleList)
    if id ~= 0 then
        return true
    end
    local roleCount = 0
    local useCount = 0
    for key, roleId in pairs(roleList) do
        if roleId ~= 0 then
            local attrs = mod.RoleCtrl:GetRolePropertyMap(roleId)
            local curLife = attrs[FormationConfig.SyncProperty.CurLife]
            local instanceId = BehaviorFunctions.fight.playerManager:GetPlayer():GetInstanceIdByHeroId(roleId)
            roleCount = roleCount + 1
            if not curLife or curLife > 0 then
                useCount = useCount + 1
            end
        end
    end

    if roleCount == 0 then
        MsgBoxManager.Instance:ShowTips(TI18N("队伍中需至少一个可行动的角色"))
    elseif useCount == 0 then
        MsgBoxManager.Instance:ShowTips(TI18N("队伍中需至少一个可行动的角色"))
    end

    return useCount ~= 0
end

function FormationCtrl:ReqUpdateFormationName(id, name)
    mod.FormationFacade:SendMsg("formation_name", id, name)
end

function FormationCtrl:ReqUseFormation(id)
    mod.FormationFacade:SendMsg("formation_use", id)
end

local PropertyList = {}
function FormationCtrl:SyncServerProperty(instanceId)
    if self.curMode == FormationConfig.Mode.Duplicate then return end
    local entity = BehaviorFunctions.GetEntity(instanceId)
    if not entity then
        return
    end
    
    local roleId = entity.masterId
    if not roleId or not LoginCtrl.IsInGame() then
        return
    end
    TableUtils.ClearTable(PropertyList)

    local attrMap = mod.RoleCtrl:GetRolePropertyMap(roleId)

    for _, attrKey in pairs(FormationConfig.SyncProperty) do
        local value = entity.attrComponent:GetValue(attrKey)
        value = math.floor(value)
        table.insert(PropertyList, {key = attrKey, value = value})
        attrMap[attrKey] = value
    end
    if entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player  then
        mod.RoleCtrl:SyncRoleProperty(roleId, PropertyList)
    end
end