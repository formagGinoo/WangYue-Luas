---@class RoleCtrl : Controller
RoleCtrl = BaseClass("RoleCtrl", Controller)

local origin_skill_table = {}

function RoleCtrl:__init()
    self.roleList = {}
    self.roleIdList = {}

    self.showRole = nil

    self.curUseRole = nil
    self.oldUseRole = nil
end

function RoleCtrl:__delete()

end

function RoleCtrl:__InitComplete()

end

-- 数据是增量的
-- 到等级上限且未突破，再升级会推送但内容不变
function RoleCtrl:UpdateRoleList(heroList)
    for _, roleData in pairs(heroList) do
        local oldData = self.roleList[roleData.id]
        self.roleList[roleData.id] = roleData

        if Fight.Instance and oldData then
            if oldData.lev < roleData.lev or oldData.stage ~= roleData.stage then
                Fight.Instance.playerManager:GetPlayer():onHeroUpgrade(roleData.id, oldData.lev, roleData.lev)
            end
            if oldData.stage < roleData.stage then
                Fight.Instance.playerManager:GetPlayer():onHeroStageUp(roleData.id, oldData.stage, roleData.stage)
            end
            if oldData.weapon_id ~=  roleData.weapon_id then
                Fight.Instance.playerManager:GetPlayer():HeroWeaponChanged(roleData.id, oldData.weapon_id, roleData.weapon_id)
                EventMgr.Instance:Fire(EventName.RoleWeaponChange, roleData.id, oldData.weapon_id, roleData.weapon_id)
            end
            if oldData.partner_id ~= roleData.partner_id then
                Fight.Instance.playerManager:GetPlayer():HeroPartnerChanged(roleData.id, oldData.partner_id, roleData.partner_id)
            end
            if roleData.skill_list then
                for i = 1, #roleData.skill_list, 1 do
                    local odlSkill = origin_skill_table[roleData.skill_list[i].order_id]
                    if not odlSkill
                            or odlSkill.lev + odlSkill.ex_lev ~= roleData.skill_list[i].lev + roleData.skill_list[i].ex_lev then
                        EventMgr.Instance:Fire(EventName.SkillInfoChange, roleData.id, roleData.skill_list[i])
                    end
                end
            end
        end

        if roleData.skill_list then
            for i = 1, #roleData.skill_list, 1 do
                origin_skill_table[roleData.skill_list[i].order_id] = roleData.skill_list[i]
            end
        end

        local idx = self:GetIdIndex(roleData.id)
        if not idx then
            table.insert(self.roleIdList, roleData.id)
			EventMgr.Instance:Fire(EventName.GetRole, roleData.id)
        else
            EventMgr.Instance:Fire(EventName.RoleInfoUpdate, idx, roleData, oldData)
        end
    end
end

function RoleCtrl:ChangeShowRole(roleId)
    self.showRole = roleId
end

function RoleCtrl:CheckRoleListRedPoint()
    for key,_ in pairs(self.roleList) do
        if self:CheckRedPointById(key) then return true end
    end
    return false
end

function RoleCtrl:CheckRoleRedPoint()
    for _,value in pairs(self.roleList) do
        if value.is_new == true then return true end
    end
    return false
end

function RoleCtrl:CheckSkillRedPoint()
    local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.RoleSkill)
    if not isOpen then 
        return false
    end
    if self.showRole then 
        for _, value in ipairs(self.roleList[self.showRole].skill_list) do
            if self:CanUpgradeSkill(value.order_id,value.lev) then 
                return true
            end
        end
    end
    return false
end

function RoleCtrl:CheckPartnerRedPoint()
    local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.Partner)
    if not isOpen then 
        return false
    end
    if self.showRole and self.roleList[self.showRole].partner_id == 0 then 
        return self:CheckHasPartnerUnuse()
    end
    return false
end

function RoleCtrl:CheckHasPartnerUnuse()
    local partnerList = mod.BagCtrl:GetBagByType(BagEnum.BagType.Partner)
    for _, value in ipairs(partnerList) do
        if value.hero_id == 0 then 
            return true
        end
    end
    return false
end

function RoleCtrl:CheckRedPointById(roleId)
    if self.roleList[roleId] == nil or self.roleList[roleId].skill_list == nil then return false end
    if self.roleList[roleId].is_new == true then return true end 
    if self.roleList[roleId].partner_id == 0 and self:CheckHasPartnerUnuse() then return true end
    for _, value in ipairs(self.roleList[roleId].skill_list) do
        if self:CanUpgradeSkill(value.order_id,value.lev + 1) then
            return true
        end
    end
    return false
end

function RoleCtrl:GetRoleData(roleId)
    return self.roleList[roleId]
end

function RoleCtrl:GetRoleList()
    return self.roleList
end

function RoleCtrl:GetRoleIdList()
    return self.roleIdList
end

function RoleCtrl:GetIdIndex(roleId)
    for k, v in pairs(self.roleIdList) do
        if v == roleId then
            return k
        end
    end
end

function RoleCtrl:GetRoleIdListByElement(element)
    local elementRoleIdList = {}
    for _, v in pairs(self.roleIdList) do
        if RoleConfig.HeroBaseInfo[v].element == element then
            table.insert(elementRoleIdList, v)
        end
    end
    return elementRoleIdList
end

function RoleCtrl:SetCurUseRole(entityId)
    if self.curUseRole then
        self.oldUseRole = self.curUseRole
    end

    self.curUseRole = entityId
end

function RoleCtrl:SetCurUISelectRole(roleId)
    self.curUISelectRole = roleId
end

function RoleCtrl:GetCurUISelectRole()
    return self.curUISelectRole or 1001001
end

function RoleCtrl:GetCurUseRole()
    return self.curUseRole
end

function RoleCtrl:GetOldUseRole()
    return self.oldUseRole
end

function RoleCtrl:GetSkillInfo(roleId,skillId)
    if origin_skill_table[skillId] then
        return origin_skill_table[skillId].lev, origin_skill_table[skillId].ex_lev
    end
    return 0, 0
end

function RoleCtrl:GetRolePropertyMap(role)
    local roleInfo = self.roleList[role]
    if roleInfo then
        if roleInfo.propertyMap then
            return roleInfo.propertyMap
        end
        roleInfo.propertyMap = {}
        roleInfo.property_list = roleInfo.property_list or {}
        for _, property in pairs(roleInfo.property_list) do
            roleInfo.propertyMap[property.key] = property.value
        end
        return roleInfo.propertyMap
    end

    return {}
end

function RoleCtrl:SyncRoleProperty(roleId, propertyList)
    mod.RoleFacade:SendMsg("hero_sync_property", roleId, propertyList)
end

--提交升级信息
function RoleCtrl:RoleUpgrade(heroId, itemList)
    CurtainManager.Instance:EnterWait()
    local id, cmd = mod.RoleFacade:SendMsg("hero_lev_up", heroId, itemList)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function ()
        CurtainManager.Instance:ExitWait()
    end)
end

--提交突破信息
function RoleCtrl:RoleStageUp(heroId)
    CurtainManager.Instance:EnterWait()
    local id, cmd = mod.RoleFacade:SendMsg("hero_stage_up", heroId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function ()
        CurtainManager.Instance:ExitWait()
    end)
end

--#region 武器相关
function RoleCtrl:GetRoleWeapon(roleId)
    if self.roleList[roleId] then
        return self.roleList[roleId].weapon_id
    else
        Log(string.format("没有激活角色：%s", roleId))
    end
end

function RoleCtrl:ReplaceWeapon(roleId, weaponId)
    mod.RoleFacade:SendMsg("hero_change_weapon", roleId, weaponId)
end

function RoleCtrl:WeaponUpgrade(weapon_id, weapon_id_list,item_list)
    mod.RoleFacade:SendMsg("weapon_lev_up", weapon_id, weapon_id_list, item_list)
end

function RoleCtrl:WeaponStageUp(weapon_id)
    mod.RoleFacade:SendMsg("weapon_stage_up", weapon_id)
end

function RoleCtrl:RefineWeapon(weapon_id, weaponList)
    mod.RoleFacade:SendMsg("weapon_refine", weapon_id, weaponList)
end

--#endregion

--#region 技能相关相关
function RoleCtrl:RoleSkillUpgrade(roleId, skillId)
    mod.RoleFacade:SendMsg("hero_skill_lev_up", roleId, skillId)
end

-- 判断技能是否满足升级条件
function RoleCtrl:CanUpgradeSkill(skillId,level)
    local skillConfig = RoleConfig.GetSkillConfig(skillId)
    local roleData = mod.RoleCtrl:GetRoleData(skillConfig.role_id)
    if skillConfig.level_limit < level then
        return false
    end
    local skillLevelConfig = RoleConfig.GetSkillLevelConfig(skillId, level)
    if not skillLevelConfig then
        return false
    end

    if not skillLevelConfig.need_item or #skillLevelConfig.need_item == 0 then
        return false
    else
        for i = 1, #skillLevelConfig.need_item, 1 do
            local itemId = skillLevelConfig.need_item[i][1]
            local needCount = skillLevelConfig.need_item[i][2]
            local curCount = mod.BagCtrl:GetItemCountById(itemId)
            if curCount < needCount then
                return false
            end
        end
    end

    local value = RoleConfig.GetRoleSkillLevelLimit(skillConfig.role_id, roleData.stage)
    if value and level > value then
        return false
    end

    return true
end
--#endregion

--#region 佩从相关
function RoleCtrl:GetRolePartner(roleId)
    if self.roleList[roleId] then
        return self.roleList[roleId].partner_id or 0
    else
        Log(string.format("没有激活角色：%s", roleId))
        return 0
    end
end

function RoleCtrl:GetRolePartnerEntityId(roleId)
    local uniqueId = self:GetRolePartner(roleId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local entityId, partnerId, skills
    if partnerData then
        partnerId = partnerData.template_id
        skills = partnerData.skill_list
        entityId = RoleConfig.GetPartnerEntityId(partnerId)
    elseif uniqueId and uniqueId ~= 0 then
        entityId = uniqueId
    end

    return entityId, skills
end

function RoleCtrl:SetDebugData(roleId, info)
    self.roleList[roleId] = info
end

function RoleCtrl:SetRolePartner(roleId, partnerId)
    if partnerId then
        mod.RoleFacade:SendMsg("hero_equip_partner", roleId, partnerId)
    else
        mod.RoleFacade:SendMsg("hero_unequip_partner", roleId)
    end
    --TODO
    -- self:SetTestPartner(roleId, partnerId)
end

function RoleCtrl:PartnerUpgrade(partnerId, partnerIdList)
    mod.RoleFacade:SendMsg("partner_lev_up", partnerId, partnerIdList)
end

function RoleCtrl:PartnerSkillLevUp(partnerId, skillId)
    mod.RoleFacade:SendMsg("partner_skill_lev_up", partnerId, skillId)
end

function RoleCtrl:RecvStatisticData(Alldata)
    local map = Alldata.statistic_info.next
    for _, data in pairs(map) do
        local type = data.key
        self:AllotDataByType(type, data)
    end
end

function RoleCtrl:AllotDataByType(statisticType, data)
    if statisticType == RoleConfig.StatisticType.Teach then
        mod.TeachCtrl:RecvTeachData(data.next)
    elseif statisticType == RoleConfig.StatisticType.PartnerGet then
        mod.BagCtrl:RecvPartnerData(data.next)
    end
end

--#endregion