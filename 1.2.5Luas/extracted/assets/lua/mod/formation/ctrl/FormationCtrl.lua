---@class FormationCtrl : Controller
FormationCtrl = BaseClass("FormationCtrl",Controller)

local Max_Formation_Num = 10

function FormationCtrl:__init()
    self.formationList = {}
    for i = 0, Max_Formation_Num do
        self.formationList[i] = {id = i, name = "", roleList = {}}
    end
    self.curFormationId = 0
end

function FormationCtrl:__delete()

end

function FormationCtrl:__InitComplete()

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
        self:UpdateFightFormationInfo()
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
        self:UpdateFightFormationInfo()
    end
end

function FormationCtrl:UpdateFightFormationInfo()
    self.fightFormation = self.fightFormation or {}
    self.fightFormation.roleList = self.fightFormation.roleList or {}
    TableUtils.ClearTable(self.fightFormation.roleList)
    local curInfo = self:GetFormationInfo(0) or {}
    for i = 1, 3, 1 do
        if curInfo.roleList[i] and curInfo.roleList[i] ~= 0 then
            table.insert(self.fightFormation.roleList, curInfo.roleList[i])
        end
    end
    if Fight.Instance then
        local window = WindowManager.Instance:GetWindow("FormationWindowV2")
        if window and window:CheckActive() then
            self.isReloadFormation = true
            return
        else
            self:UpdateFightFormation(true)
        end
    end
end

function FormationCtrl:UpdateFightFormation(reload)
    reload = reload or self.isReloadFormation
    self.isReloadFormation = false
    if reload then
        Fight.Instance.playerManager:GetPlayer():ChangeHeroList(self.fightFormation.roleList)
    end
end

function FormationCtrl:UpdateFormationName(id, name)
    if not self.formationList[id] then
        self.formationList[id] = {}
    end

    self.formationList[id].name = name
    EventMgr.Instance:Fire(EventName.FormationUpdate,id)
end

--#region 已弃用

-- function FormationCtrl:UpdateCurFormation(id)
--     self.curFormationId = id
--     if Fight.Instance then
--         local entityIds = {}
--         local roleList = self.formationList[self.curFormationId].roleList
--         for i = 1, #roleList do
--             entityIds[i] = type(roleList[i]) == "number" and roleList[i] or roleList[i].id
--         end
--         Fight.Instance.playerManager:GetPlayer():ChangeHeroList(entityIds)
--     end
-- end


-- function FormationCtrl:GetCurFormationId()
--     return self.curFormationId
-- end

-- 更新编队详细信息
-- function FormationCtrl:UpdateAllFormationExtraInfo()
--     for k, v in pairs(self.formationList) do
--         if v.roleList and next(v.roleList) then
--             for i = 1, #v.roleList do
--                 local roleInfo = mod.RoleCtrl:GetRoleData(v.roleList[i])
--                 v.roleList[i] = roleInfo
--             end
--         end
--     end
-- end

--#endregion

function FormationCtrl:GetFormationInfo(id)
    if not self.formationList or not self.formationList[id] then
        return
    end

    return self.formationList[id]
end

function FormationCtrl:GetCurFormationInfo()
    local formation = self.fightFormation or self:GetFormationInfo(1)
	if not formation or not next(formation) or #formation.roleList == 0 then
        --TODO 旧账号用的还是编队1
		formation = self:GetFormationInfo(1)
	end

    if not formation or not next(formation) or #formation.roleList == 0 then
        formation = {}
        formation.roleList = Fight.Instance:GetDebugFormation()
    end

    return formation
end

function FormationCtrl:ReqFormationUpdate(id, updateList)
    if not self:CheckFormation(id, updateList) then
        return false
    end

    local data = {id = id, hero_id_list = updateList}
    mod.FormationFacade:SendMsg("formation_update", data)
    return true
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
    self.updatePropertyTime = 0
    local entity = BehaviorFunctions.GetEntity(instanceId)
    local roleId = entity.masterId
    if not roleId then
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
    mod.RoleCtrl:SyncRoleProperty(roleId, PropertyList)
end