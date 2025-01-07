---@class RoleCtrl : Controller
RoleCtrl = BaseClass("RoleCtrl", Controller)

local origin_skill_table = {}

function RoleCtrl:__init()
    self.roleList = {}
    self.roleIdList = {}
	self.ItemExpendCount = {}

    self.showRole = nil

    self.curUseRole = nil
    self.oldUseRole = nil

    self.totalDistance = 0
    self.itemObtainedCount = {}
end

function RoleCtrl:__delete()

end

function RoleCtrl:__Clear()
    -- -- if LoginCtrl.IsInGame() then
    	self.roleList = {}
    	self.roleIdList = {}
		self.ItemExpendCount = {}
    -- -- end
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
                self:ChangeMaxRoleLev(roleData.lev)
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
                    if not odlSkill or odlSkill.lev + odlSkill.ex_lev ~= roleData.skill_list[i].lev + roleData.skill_list[i].ex_lev then
                        EventMgr.Instance:Fire(EventName.SkillInfoChange, roleData.id, roleData.skill_list[i])
                    end
                end
            end
            self:SyncRoleBaseProperty(roleData.id)
        elseif not oldData then
            self:ChangeMaxRoleLev(roleData.lev)
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

function RoleCtrl:ChangeMaxRoleLev(lev)
    self.maxRoleLev = self.maxRoleLev or 1
    if lev > self.maxRoleLev then
        self.maxRoleLev = lev
        EventMgr.Instance:Fire(EventName.RoleMaxLevChange, lev)
    end
end

function RoleCtrl:GetMaxRoleLev()
    return self.maxRoleLev or 1
end

function RoleCtrl:SetRoleNewState(roleId)
    if self.roleList[roleId] and self.roleList[roleId].is_new == true then
        --self.roleList[roleId].is_new = false
        mod.RoleFacade:SendMsg("hero_del_red_point", roleId)
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
        --if value.is_new == true then return true end
        if self:CheckRedPointById(value.id) then
            return true
        end
    end
    return false
end

--检查该id是否是机器人
function RoleCtrl:CheckRoleIsRobot(roleId)
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        return true
    end
    return false
end

function RoleCtrl:CheckSkillRedPoint()
    local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.RoleSkill)
    if not isOpen then
        return false
    end
    if self.showRole then
        if self:CheckRoleIsRobot(self.showRole) then
            return false
        end
        for _, value in ipairs(self.roleList[self.showRole].skill_list) do
            if self:CanUpgradeSkill(value.order_id,value.lev + 1) then 
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
    if self.showRole then
        if self:CheckRoleIsRobot(self.showRole) then
            return false
        end
    end
    if self.showRole and self.roleList[self.showRole] and self.roleList[self.showRole].partner_id == 0 then 
        return self:CheckHasPartnerUnuse()
    end
    return false
end

function RoleCtrl:CheckPeriodRedPoint()
    if self.showRole then
        if self:CheckRoleIsRobot(self.showRole) then
            return false
        end
        local roleData = self.roleList[self.showRole]
        if roleData and self:CheckRoleCanUpStar(roleData.id) then
            return true
        end
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
    if self:CheckRoleCanUpStar(roleId) then
        return true
    end
    return false
end
function RoleCtrl:CheckRoleCanUpStar(roleId)
    local roleData = mod.RoleCtrl:GetRoleData(roleId)
    if roleData.star >= 6 then
        return false
    end
    local periodInfo = RoleConfig.GetRolePeriodInfo(roleId, roleData.star + 1)
    local itemCount = mod.BagCtrl:GetItemCountById(periodInfo.item)
    return itemCount > 0
end
function RoleCtrl:GetRoleData(roleId,uid)
    if uid then
        return mod.FriendCtrl:GetFriendRoleData(roleId,uid)
    end
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
        local roleAllSkillList = RoleConfig.GetRoleSkill(robotCfg.hero_id)
        local skillList = self:GetRoleSkillListByList(roleId, roleAllSkillList)
        local data = {
            id = robotCfg.hero_id,
            roleId = robotCfg.hero_id,
            partner_id = robotCfg.partner_id,
            stage = robotCfg.hero_grade,
            lev = robotCfg.hero_level,
            star = robotCfg.hero_star,
            skill_list = skillList, 
            exp = 0,
            isRobot = true
        }
        return data
    end
    return self.roleList[roleId] 
end

function RoleCtrl:GetRoleSkillListByList(robotId, list)
    local skillList = {}
    for i, id in pairs(list) do
        local lv, exLev = self:GetSkillInfoByRobotId(robotId, id)
        table.insert(skillList, {order_id = id, lev = lv, ex_lev = exLev})
    end
    
    return skillList
end

function RoleCtrl:GetRealRoleId(roleId)
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
        return robotCfg.hero_id
    end
    return roleId
end

function RoleCtrl:GetRoleList(uid)
    if uid then
        return mod.FriendCtrl:GetFriendRoleList(uid)
    end
    return self.roleList
end

function RoleCtrl:GetRoleIdList(uid)
    if uid then
        return mod.FriendCtrl:GetFriendRoleIdList(uid)
    end
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
    return self.curUISelectRole or self.curUseRole
end

function RoleCtrl:GetCurUseRole(uid)
    if uid then
        return mod.FriendCtrl:GetFirstShowRole(uid)
    end
    if mod.FormationCtrl.curMode == FormationConfig.Mode.Duplicate then
        local dupFormation = mod.FormationCtrl:GetOriginalFormation()
        for i, heroId in ipairs(dupFormation.roleList) do
            if heroId ~= 0 and heroId ~= -1 then 
                return heroId
            end
        end
    end
    return self.curUseRole
end

function RoleCtrl:GetOldUseRole()
    return self.oldUseRole
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

--同步不在编队中的角色属性
function RoleCtrl:SyncRoleBaseProperty(roleId)
    if roleId == 0 then
        return
    end
    local player = Fight.Instance.playerManager:GetPlayer()
    local oldAttrs = self:GetRolePropertyMap(roleId)
    if player:GetInstanceIdByHeroId(roleId) then
        return
    end
    local ratioInfo = {}
    for _, cur in pairs(FormationConfig.ConstantRatioAttr) do
        if oldAttrs[cur] and oldAttrs[cur - 1000] then
            ratioInfo[cur] = oldAttrs[cur] / oldAttrs[cur - 1000]
        else
            ratioInfo[cur] = 1
        end
	end
    local attrMap = self:GetstaticAttr(roleId)
    local tempList = {}
    local mark = false

    for _, type in pairs(FormationConfig.SyncProperty) do
        if ratioInfo[type] then
            attrMap[type] = math.floor(attrMap[type - 1000] * ratioInfo[type])
        end
    end

    for _, type in pairs(FormationConfig.SyncProperty) do
        attrMap[type] = attrMap[type] and math.floor(attrMap[type]) or 0
        if oldAttrs[type] ~= attrMap[type] then
            mark = true
            oldAttrs[type] = attrMap[type]
        end
        table.insert(tempList, {key = type, value = attrMap[type]})
    end

    if mark then
        LogTable("属性记录信息",tempList)
        self:SyncRoleProperty(roleId, tempList)
    end
end

--角色属性，武器属性，月灵属性，技能属性
function RoleCtrl:GetstaticAttr(roleId,uid)
    -- 完全版
    local finalAttrMap = {}
    -- 本体版(不含额外属性)
    local finalBaseAttrMap = {}
    -- 玩家基础部分
    local playerAttrMap = {}
    for k, attr in pairs(FightEnum.PlayerAttr) do
        playerAttrMap[attr] = playerAttrMap[attr] or 0 + BehaviorFunctions.GetPlayerAttrVal(attr)
    end

    -- 角色基础部分
    local attrMap = {}
    local roleInfo = self:GetRoleData(roleId,uid) --self.roleList[roleId]
    -- 角色升级 突破
    EntityAttrsConfig.GetHeroBaseAttr(roleId, roleInfo.lev, attrMap)
    EntityAttrsConfig.GetHeroStageAttr(roleId, roleInfo.stage, attrMap)
    -- 武器升级
    local weaponData = mod.BagCtrl:GetWeaponData(roleInfo.weapon_id,roleId,uid)
    RoleConfig.GetWeaponBaseAttrs(weaponData.template_id, weaponData.lev, weaponData.stage, attrMap)
    
    -- 月灵打书、巅峰盘、基础
    if roleInfo.partner_id ~= 0 then
        local partnerData = mod.BagCtrl:GetPartnerData(roleInfo.partner_id,uid, roleId)
        RoleConfig.GetPartnerBaseAttrs(partnerData.template_id, partnerData.lev, attrMap)
        RoleConfig.GetPartnerPlateAttr(partnerData, attrMap)
        RoleConfig.GetPartnerPassiveSkillAttr(partnerData, attrMap)
    end

    -- 脉象加成
    if roleInfo.star and roleInfo.star > 0 then
        for i = 1, roleInfo.star do
            local attrs = RoleConfig.GetRolePeriodSkillAttr(roleId, i)
            if attrs then
                for id, info in pairs(attrs) do
                    local attrId = info[1]
                    local attrValue = info[2]
                    attrMap[attrId] = (attrMap[attrId] or 0) + attrValue
                end
            end
        end
    
    end

    -- 组合(万分比、额外属性)
    for id, info in pairs(Config.DataPlayerAttrsDefine.Find) do
        if attrMap[id] then
            local ratioType = EntityAttrsConfig.Attr2AttrPercent[id]
            local extraTypes = EntityAttrsConfig.Totol2Attr[id]
            if info.overlay_type == FightEnum.AttrOverlayType.Additvie then
                local attrValue = ratioType and attrMap[ratioType] * 0.0001 or 0
                local playerAttrValue = ratioType and playerAttrMap[ratioType] * 0.0001 or 0
                finalAttrMap[id] = (attrMap[id] or 0 + playerAttrMap[id] or 0) * (1 + attrValue) + playerAttrValue
                
                if extraTypes then
                    for _, extraId in pairs(extraTypes) do
                        if extraId ~= id then
                            finalAttrMap[id] = finalAttrMap[id] + attrMap[extraId] + playerAttrMap[extraId]
                        end
                    end
                end
            end
    
            if info.overlay_type == FightEnum.AttrOverlayType.Max then
                local attrValue = ratioType and attrMap[ratioType] * 0.0001 or 0
                local playerAttrValue = ratioType and playerAttrMap[ratioType] * 0.0001 or 0
                finalAttrMap[id] = math.max(attrMap[id] or 0, playerAttrMap[id] or 0) * (1 + math.max(attrValue, playerAttrValue))
                
                if extraTypes then
                    for _, extraId in pairs(extraTypes) do
                        if extraId ~= id then
                            finalAttrMap[id] = finalAttrMap[id] + math.max(attrMap[extraId], playerAttrMap[extraId])
                        end
                    end  
                end
            end
        end
    end

    -- 组合(不加万分比、额外属性)
    for id, info in pairs(Config.DataPlayerAttrsDefine.Find) do
        if attrMap[id] then
            local extraTypes = EntityAttrsConfig.Totol2Attr[id]
            finalBaseAttrMap[id] = attrMap[id] or 0 + playerAttrMap[id] or 0
        end
    end

    return finalAttrMap, finalBaseAttrMap
end

--提交升级信息
function RoleCtrl:RoleUpgrade(heroId, itemList)
    local orderId, protoId = mod.RoleFacade:SendMsg("hero_lev_up", heroId, itemList)
    SystemConfig.WaitProcessing(orderId, protoId, function ()
        EventMgr.Instance:Fire(EventName.RoleLevUpEnd)
    end)
end

--提交突破信息
function RoleCtrl:RoleStageUp(heroId)
    local orderId, protoId = mod.RoleFacade:SendMsg("hero_stage_up", heroId)
    SystemConfig.WaitProcessing(orderId, protoId, function ()
        EventMgr.Instance:Fire(EventName.RoleStageUpEnd)
    end)
end

--#region 武器相关
function RoleCtrl:GetRoleWeapon(roleId,uid)
    if uid then 
        return mod.FriendCtrl:GetFriendRoleWeapon(roleId,uid)
    end

    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
        return robotCfg.weapon_id
    end

    if self.roleList[roleId] then
        return self.roleList[roleId].weapon_id
    else
        Log(string.format("没有激活角色：%s", roleId))
    end
end

function RoleCtrl:ReplaceWeapon(roleId, weaponId)
    local orderId, protoId = mod.RoleFacade:SendMsg("hero_change_weapon", roleId, weaponId)
    SystemConfig.WaitProcessing(orderId, protoId, function ()
        EventMgr.Instance:Fire(EventName.RoleWeaponChangeEnd)
    end)
end

function RoleCtrl:WeaponUpgrade(weapon_id, weapon_id_list,item_list)
    local orderId, protoId = mod.RoleFacade:SendMsg("weapon_lev_up", weapon_id, weapon_id_list, item_list)
    SystemConfig.WaitProcessing(orderId, protoId, function ()
        EventMgr.Instance:Fire(EventName.RoleWeaponLevUpEnd)
    end)
end

function RoleCtrl:WeaponStageUp(weapon_id)
    local orderId, protoId =     mod.RoleFacade:SendMsg("weapon_stage_up", weapon_id)
    SystemConfig.WaitProcessing(orderId, protoId, function ()
        EventMgr.Instance:Fire(EventName.RoleWeaponStageUpEnd)
    end)
end

function RoleCtrl:RefineWeapon(weapon_id, weaponList)
    mod.RoleFacade:SendMsg("weapon_refine", weapon_id, weaponList)
end

--#endregion

--#region 技能相关
function RoleCtrl:RoleSkillUpgrade(roleId, skillId)
    local orderId, protoId = mod.RoleFacade:SendMsg("hero_skill_lev_up", roleId, skillId)
    SystemConfig.WaitProcessing(orderId, protoId, function ()
        EventMgr.Instance:Fire(EventName.RoleSkillUpEnd)
    end)
end

-- 判断技能是否满足升级条件
function RoleCtrl:CanUpgradeSkill(skillId,level,uid)
    if uid then 
        return false
    end
    if not Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.RoleSkill) then 
        return false
    end
    local skillConfig = RoleConfig.GetSkillConfig(skillId)
    local roleData = mod.RoleCtrl:GetRoleData(skillConfig.role_id)
    if skillConfig.level_limit < level then
        return false
    end
    local skillLevelConfig = RoleConfig.GetSkillLevelConfig(skillId, level)
    if not skillLevelConfig then
        return false
    end

    local haveGold = 0
    local currency = mod.BagCtrl:GetBagByType(BagEnum.BagType.Currency)
    for k, info in pairs(currency) do
        if info.template_id == 2 then
            haveGold = info.count
        end
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

    if haveGold < skillLevelConfig.need_gold then 
        return false
    end

    local value = RoleConfig.GetRoleSkillLevelLimit(skillConfig.role_id, roleData.stage)
    if value and level > value then
        return false
    end

    return true
end

function RoleCtrl:GetSkillInfo(roleId,skillId,uid)
    if uid then
        return mod.FriendCtrl:GetFriendSkillInfo(roleId,skillId,uid)
    end

    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        local lev, ex_lev = self:GetSkillInfoByRobotId(roleId, skillId)
        return lev, ex_lev
    end
    if origin_skill_table[skillId] then
        return origin_skill_table[skillId].lev, origin_skill_table[skillId].ex_lev
    end
    return 0, 0
end

-- 获取符合等级和类型的所有技能
function RoleCtrl:GetAllEligibleSkills(level, type)
    if origin_skill_table == nil then
        return
    end
    
    local result = {}
    for skillId, skillData in pairs(origin_skill_table) do
        if type ~= nil then
            local skillType = RoleConfig.GetSkillUiConfig(skillId).skill_type
            if skillType ~= type then
                goto continue
            end
        end
        
        local currLevel = skillData.lev + skillData.ex_lev
        if currLevel >= level then
            table.insert(result, skillId)
        end
        
        ::continue::
    end
    
    return result
end

--获取机器人的技能等级
function RoleCtrl:GetSkillInfoByRobotId(roleId, skillId)
    --普通攻击id=角色id前4位后面接01，战技id=角色id前4位后面接02，大招id=角色id前4位后面接03  核心id=角色id前4位后面接04
    --判断skillId
    local lev = 1
    local ex_lev = 0
    local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
    if not robotCfg then
        return lev, ex_lev
    end
    local heroId = tonumber(string.sub(robotCfg.hero_id, 1, 4))
    if skillId == (heroId * 100) + 01 then
        lev = robotCfg.attack_level
    elseif skillId == (heroId * 100) + 02 then
        lev = robotCfg.skill_level
    elseif skillId == (heroId * 100) + 03 then
        lev = robotCfg.uniqueskill_level
    elseif skillId == (heroId * 100) + 04 then
        lev = robotCfg.coreskill_level
    end

    return lev, ex_lev
end
--#endregion

--#region 月灵相关
function RoleCtrl:GetRolePartner(roleId,uid)
    if uid then 
        return mod.FriendCtrl:GetFriendRolePartner(roleId,uid)
    end
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
        return robotCfg.partner_id
    end
    if self.roleList[roleId] then
        return self.roleList[roleId].partner_id or 0
    else
        Log(string.format("没有激活角色：%s", roleId))
        return 0
    end
end

function RoleCtrl:GetRolePartnerEntityId(roleId,uid)
    local uniqueId = self:GetRolePartner(roleId,uid)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,uid)
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        local robotCfg = RobotConfig.GetRobotHeroCfgById(roleId)
        partnerData = {}
		if robotCfg.partner_id ~= 0 then
            partnerData = {
                template_id = robotCfg.partner_id,
                skill_list = {},
                panel_list = {},
                passive_skill_list = {},
            }
            local skill_list = RoleConfig.GetPartnerSkillList(robotCfg.partner_id, robotCfg.partner_level)
            for i, skillId in ipairs(skill_list) do
                if skillId ~= 0 then
                    partnerData.skill_list[i] = { key = skillId, value = 1}
                end
            end
		end
    end
    local entityId, partnerId, skills, panelList, passiveList
    if partnerData then
        partnerId = partnerData.template_id
        skills = partnerData.skill_list
        panelList = partnerData.panel_list
        passiveList = partnerData.passive_skill_list
        entityId = RoleConfig.GetPartnerEntityId(partnerId)
    elseif uniqueId and uniqueId ~= 0 then
        entityId = uniqueId
    end

    return entityId, skills, panelList, passiveList
end

function RoleCtrl:SetDebugData(roleId, info)
    self.roleList[roleId] = info

    local star = info.star
    if star then
        for i = 1, star, 1 do
            local starData = RoleConfig.GetRolePeriodInfo(roleId, i)
            if starData ~= nil then
                origin_skill_table[starData.skill_id] = {ex_lev = 0, lev = 1, order_id = starData.skill_id}
            else
                LogError(string.format("角色 %d 没有 %d 脉象数据", roleId, i))
            end
            
        end
    end
        
end

function RoleCtrl:SetRolePartner(roleId, partnerId)
    if partnerId then
        --是否已经在资产内了，资产内不允许角色替换上
        local partnerData = mod.BagCtrl:GetPartnerData(partnerId)
        if partnerData and partnerData.work_info.asset_id ~= 0 then
            MsgBoxManager.Instance:ShowTips(TI18N("月灵在资产中，替换失败，请先将月灵移出资产"))
            return
        end
    end
    
    local func = function ()
        MsgBoxManager.Instance:ShowTips(TI18N("月灵替换成功"))
        EventMgr.Instance:Fire(EventName.RolePartnerChangeEnd)
    end
    local orderId, protoId
    if partnerId then
        orderId, protoId = mod.RoleFacade:SendMsg("hero_equip_partner", roleId, partnerId)
    else
        orderId, protoId = mod.RoleFacade:SendMsg("hero_unequip_partner", roleId)
    end
    SystemConfig.WaitProcessing(orderId, protoId, func)
end

function RoleCtrl:PartnerUpgrade(partnerId, partnerIdList, itemList)
    local orderId, protoId = mod.RoleFacade:SendMsg("partner_lev_up", partnerId, partnerIdList, itemList)
    SystemConfig.WaitProcessing(orderId, protoId)
end

function RoleCtrl:PartnerSkillLevUp(partnerId, skillId)
    mod.RoleFacade:SendMsg("partner_skill_lev_up", partnerId, skillId)
end

function RoleCtrl:SavePartnerPanel(partnerId,panelList,endFunc)
    local func = function(noticeCode)
        if noticeCode == 0 then
            local data = mod.BagCtrl:GetPartnerData(partnerId)
            local oldData = TableUtils.CopyTable(data)
            data.panel_list = panelList
            EventMgr.Instance:Fire(EventName.PartnerInfoChange, oldData, data)
            Fight.Instance.playerManager:GetPlayer():PartnerAttrChanged(data.hero_id, oldData, data)
            mod.RoleCtrl:SyncRoleBaseProperty(data.hero_id)
            if endFunc then endFunc(noticeCode) end
        end
    end

    local orderId, protoId = mod.RoleFacade:SendMsg("partner_panel", partnerId, panelList)
    SystemConfig.WaitProcessing(orderId, protoId, func)
end

function RoleCtrl:ResetPartnerPanel(partnerId, func)
    local orderId, protoId = mod.RoleFacade:SendMsg("partner_panel_reset", partnerId)
    SystemConfig.WaitProcessing(orderId, protoId, func)
end

--#endregion

function RoleCtrl:RoleStarUp(roleId)
    local orderId, protoId = mod.RoleFacade:SendMsg("hero_star_up", roleId)
    SystemConfig.WaitProcessing(orderId, protoId)
end

-- 更新累计类型数据
function RoleCtrl:SendStatisticClientData(data)
    local orderId, protoId = mod.RoleFacade:SendMsg("statistic_client_control_add", data.type, data.value)
    SystemConfig.WaitProcessing(orderId, protoId)
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
    elseif statisticType == RoleConfig.StatisticType.ItemGet then
        mod.BagCtrl:RecvItemObtainedCount(data.next)
    elseif statisticType == RoleConfig.StatisticType.Login then
        self:RecvLoginCount(data)
    elseif statisticType == RoleConfig.StatisticType.ItemExpend then
        self:RecvItemExpendCount(data.next)
    elseif statisticType == RoleConfig.StatisticType.TrafficTotalDistance then
        self:UpdateTrafficTotalDistance(data)
    elseif statisticType == RoleConfig.StatisticType.FeedMaiLing then
        mod.MailingCtrl:UpdateFeedMailingTime(data.value)
    elseif statisticType == RoleConfig.StatisticType.Rogue then
        -- RoguelikeCtrl中已通过其他协议更新数据
    elseif statisticType == RoleConfig.StatisticType.ShopGoods then
        mod.PurchaseCtrl:UpdateHistoryPurchaseData(data)
    end
end

-- 更新总行驶路程
function RoleCtrl:UpdateTrafficTotalDistance(_data)
    self.totalDistance = _data.value
    print("更新总行驶路程: " .. self.totalDistance)
end

function RoleCtrl:GetTrafficTotalDistance()
    return self.totalDistance
end

function RoleCtrl:GetItemExpendCount(itemId)
    return self.ItemExpendCount[itemId] or 0
end

function RoleCtrl:GetLoginCount()
    return self.LoginCount or 0
end

function RoleCtrl:RecvLoginCount(data)
    self.LoginCount = data.value
    --LogTable("道具获得历史次数", self.itemObtainedCount)
end

function RoleCtrl:RecvItemExpendCount(data)
    for _, v in ipairs(data) do
        local itemId = v.key
        local num = v.value
        
        self.ItemExpendCount[itemId] = num
    end
    --LogTable("道具获得历史次数", self.itemObtainedCount)
end

function RoleCtrl:GetItemExpendCount(_itemId)
    return self.ItemExpendCount[_itemId]
end

function RoleCtrl:ReSetOtherInfo()
    self.curUISelectRole = nil
    self.showRole = nil
    self.oldUseRole = nil
end

function RoleCtrl:UseSkillBook(partnerId, pos, bookItemId, successTips)
    local orderId, protoId = mod.RoleFacade:SendMsg("partner_use_skill_book", partnerId, pos, bookItemId)
    mod.LoginCtrl:AddClientCmdEvent(orderId, protoId, function(erro)
        if erro == 0 then -- 成功了
            local partnerInfo = UtilsBase.copytab(LOCAL_BAG[BagEnum.BagType.Partner][partnerId]) or {}
            local isMod = false
            for key, info in pairs(partnerInfo.passive_skill_list) do
                if info.key == pos then
                    isMod = true
                    info.value = bookItemId
                end
            end
            if isMod == false then
                table.insert(partnerInfo.passive_skill_list, {key = pos, value = bookItemId})
            end
            mod.BagCtrl:UpdateBag({
                add_list = {},
                mod_list = {partnerInfo},
                del_list = {}
            }, BagEnum.BagType.Partner)
            MsgBoxManager.Instance:ShowTips(successTips)
        end
    end)
end

function RoleCtrl:RecvPartnerConcludeInfo(data)
    self:UpdatePartnerConcludeInfo(data.golden_conclude_time)
end

function RoleCtrl:UpdatePartnerConcludeInfo(newTime)
    self.dailyGoldenConcludeNum = newTime
end

function RoleCtrl:GetDailyGoldenConcludeNum()
    return self.dailyGoldenConcludeNum
end

-- 当前装备的缔结道具Id
function RoleCtrl:GetEquipConcludeItemId()
    if not self.equipConcludeItemId or self.equipConcludeItemId == 0 then
        self:InitEquipConcludeItemId()
    end
    return self.equipConcludeItemId or 0
end

function RoleCtrl:InitEquipConcludeItemId()
    local equipConcludeItemId = mod.LoginCtrl:GetCacheListByKey("equipConcludeItemId")
    equipConcludeItemId = tonumber(equipConcludeItemId) or 0
    --self.equipConcludeItemId = equipConcludeItemId
	self:UpdateEquipConcludeItemId(equipConcludeItemId)
end

function RoleCtrl:UpdateEquipConcludeItemId(newItemId)
    local curInsId = BehaviorFunctions.GetCtrlEntity()
    local itemCfg = ItemConfig.GetItemConfig(newItemId)
    if not itemCfg then return end
    if not self.isFirstSet then
        self.isFirstSet = true
        BehaviorFunctions.SetFightUISkillBtnIcon(curInsId, FightEnum.KeyEvent.PartnerSkill, itemCfg.icon)
    end
    if newItemId == self.equipConcludeItemId then return end

    self.equipConcludeItemId = newItemId
    local data = {
        equipConcludeItemId = newItemId
    }
    EventMgr.Instance:Fire(EventName.ChangeConcludeItem, itemCfg.icon)
    mod.LoginCtrl:CacheClientData(data)
    BehaviorFunctions.SetFightUISkillBtnIcon(curInsId, FightEnum.KeyEvent.PartnerSkill, itemCfg.icon)
end

function RoleCtrl:RecvPartnerConclude(data)
    Fight.Instance.partnerManager:RecvUseConcludeItemData(data)
end