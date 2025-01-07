GrowNoticeManager = BaseClass("GrowNoticeManager")

local _tinsert = table.insert
local _tremove = table.remove
local _tsort = table.sort
local _sformat = string.format

local DataGrowNotice = Config.DataGrowNotice.Find
local DataGrowNoticeBySystemId = Config.DataGrowNotice.FindbySystemId
local DataSystemOpen = Config.DataSystemOpen.data_system_open
local DataHeroStageUpgradeFindConditionInfo = Config.DataHeroStageUpgrade.FindConditionInfo
local DataWeaponStageUpgradeFindConditionIdInfo = Config.DataWeaponStageUpgrade.FindConditionIdInfo

function GrowNoticeManager:__init(fight)
    self.fight = fight
    self.overrideSort = {}
end

function GrowNoticeManager:__delete()
	for index, v in pairs(GrowNoticeConfig.NoticeMap) do
        local eventList = v.eventList
        local checkFunc = v.checkFunc
        for _, eventId in pairs(eventList) do
            EventMgr.Instance:RemoveListener(eventId, checkFunc)
        end
    end
end

function GrowNoticeManager:StartFight()
    for _, v in pairs(DataGrowNotice) do
        self.overrideSort[v.id] = 0
    end
    self.accumulateSortNum = 1
    
    self.toDoItems = {
        [GrowNoticeEnum.RoleState] = { index = GrowNoticeEnum.RoleState, showRoleId = nil, waitStageRoleNum = 0, isShow = false },
        [GrowNoticeEnum.Weapon] = { index = GrowNoticeEnum.Weapon, showWeaponId = nil, showWeaponUniqueId = 0, isShow = false, waitChangeRoleNum = 0, jumpToRoleId = nil },
        [GrowNoticeEnum.WeaponState] = { index = GrowNoticeEnum.WeaponState, showWeaponId = nil, showWeaponUniqueId = 0, isShow = false, waitWeaponUpStageNum = 0, jumpToRoleId = nil },
        [GrowNoticeEnum.Partner] = { index = GrowNoticeEnum.Partner, isShow = false, showPartnerId = nil, showPartnerUniqueId = nil, waitLoadPartnerRoleNum = 0, jumpToRoleId = nil },
        [GrowNoticeEnum.RoleSkillUp] = { index = GrowNoticeEnum.RoleSkillUp, isShow = false, showRoleId = 0, waitRoleSkillUpNum = nil },
        [GrowNoticeEnum.RolePeriod] = { index = GrowNoticeEnum.RolePeriod, isShow = false, showRoleId = 0, waitRolePeriodNum = 0 },
        [GrowNoticeEnum.RoleTalent] = { index = GrowNoticeEnum.RoleTalent, isShow = false, showItem = nil },
    }

    self.conditionManager = Fight.Instance.conditionManager
    local conditionManager = self.conditionManager
	for index, v in pairs(GrowNoticeConfig.NoticeMap) do
        local eventList = v.eventList
        local checkFunc = v.checkFunc
        local systemId = DataGrowNotice[index].system_id
        local isOpen = true
        if systemId then
            if not conditionManager:CheckSystemOpen(systemId) then
                isOpen = false
            end
        end
        if isOpen then
            for _, eventId in pairs(eventList) do
                EventMgr.Instance:AddListener(eventId, checkFunc)
            end
            checkFunc()
        else
            local conditionId = DataSystemOpen[systemId].condition
            conditionManager:AddListener(conditionId, function (id)
                for _, eventId in pairs(eventList) do
                    EventMgr.Instance:AddListener(eventId, checkFunc)
                end
                checkFunc()
            end) 
        end
    end

    self:InitRoleState()
    self:InitWeaponState()
end

function GrowNoticeManager:InitRoleState()
    local conditionManager = Fight.Instance.conditionManager

    local roleStateSystemId = DataGrowNotice[GrowNoticeEnum.RoleState].system_id
    if (not roleStateSystemId) or conditionManager:CheckSystemOpen(roleStateSystemId) then
        local checkFunc = GrowNoticeConfig.NoticeMap[GrowNoticeEnum.RoleState].checkFunc
        if checkFunc then
            for conditionId, v in pairs(DataHeroStageUpgradeFindConditionInfo) do
                conditionManager:AddListener(conditionId, function (id)
                    checkFunc()
                end)
            end
        end
    else
        local conditionId = DataSystemOpen[roleStateSystemId].condition
        if conditionId then
            local checkFunc = GrowNoticeConfig.NoticeMap[GrowNoticeEnum.RoleState].checkFunc
            if checkFunc then
                conditionManager:AddListener(conditionId, function (id)
                    for conditionId, v in pairs(DataHeroStageUpgradeFindConditionInfo) do
                        conditionManager:AddListener(conditionId, function (id)
                            checkFunc()
                        end)
                    end
                end)
            end
        end
    end

end

function GrowNoticeManager:InitWeaponState()
    local conditionManager = Fight.Instance.conditionManager

    local roleStateSystemId = DataGrowNotice[GrowNoticeEnum.WeaponState].system_id
    if (not roleStateSystemId) or conditionManager:CheckSystemOpen(roleStateSystemId) then
        local checkFunc = GrowNoticeConfig.NoticeMap[GrowNoticeEnum.WeaponState].checkFunc
        if checkFunc then
            for conditionId, v in pairs(DataWeaponStageUpgradeFindConditionIdInfo) do
                conditionManager:AddListener(conditionId, function (id)
                    checkFunc()
                end)
            end
        end
    else
        local conditionId = DataSystemOpen[roleStateSystemId].condition
        if conditionId then
            local checkFunc = GrowNoticeConfig.NoticeMap[GrowNoticeEnum.WeaponState].checkFunc
            if checkFunc then
                conditionManager:AddListener(conditionId, function (id)
                    for conditionId, v in pairs(DataWeaponStageUpgradeFindConditionIdInfo) do
                        conditionManager:AddListener(conditionId, function (id)
                            checkFunc()
                        end)
                    end
                end)
            end
        end
    end

end

function GrowNoticeManager:EnterFight()

end

function GrowNoticeManager:SetOverrideSort(index)
    self.overrideSort[index] = self.accumulateSortNum
    self.accumulateSortNum = self.accumulateSortNum + 1
    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end

function GrowNoticeManager:GetOverrideSort(index)
    return self.overrideSort[index or 0] or 0
end

function GrowNoticeManager:GetNoticeNum()
    local num = 0

    for index, v in pairs(self.toDoItems) do
        if v.isShow then
            num = num + 1
        end
    end
    return num
end

function GrowNoticeManager:GetNotice(type)
    return self.toDoItems[type]
end

function GrowNoticeManager:GetAllNotice()
    return self.toDoItems
end

--角色突破
local DataGrowNoticeRoleState = DataGrowNotice[GrowNoticeEnum.RoleState]
local DataHeroStageUpgrade = Config.DataHeroStageUpgrade.Find
local DataHeroMain = Config.DataHeroMain.Find
function GrowNoticeManager:UpdateRoleState()
    local roleStateShowTb = self.toDoItems[GrowNoticeEnum.RoleState]
    roleStateShowTb.isShow = false
    roleStateShowTb.index = GrowNoticeEnum.RoleState

    local coinNum = mod.BagCtrl:GetItemCountById(2)

    local curRoleId = nil
    local curRoleQuality = -1
    local curPriority = -1
    local num = 0

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        local roleStage = roleData.stage
        if roleStage then
            local curStageData = DataHeroStageUpgrade[UtilsBase.GetStringKeys(roleData.id, roleStage)]
            if roleData.lev == curStageData.limit_hero_lev then
                local nextStageData = DataHeroStageUpgrade[UtilsBase.GetStringKeys(roleData.id, roleStage + 1)]
                if nextStageData and nextStageData.need_item and coinNum >= nextStageData.need_gold then
                    local waitQueue = true
                    if nextStageData.condition and not self.conditionManager:CheckConditionByConfig(nextStageData.condition) then
                        waitQueue = false
                        break
                    end

                    for _, v in pairs(nextStageData.need_item) do
                        local itemId = v[1]
                        local itemNeedNum = v[2]
                        local itemNum = mod.BagCtrl:GetItemCountById(itemId)
                        if itemNum < itemNeedNum then
                            waitQueue = false
                            break
                        end
                    end
    
                    if waitQueue then
                        num = num + 1
                        local dataRole = DataHeroMain[roleId]
                        if curRoleQuality < dataRole.quality then
                            curRoleId = roleId
                            curRoleQuality = dataRole.quality
                            curPriority = dataRole.priority
                        elseif curRoleQuality == dataRole.quality and curPriority < dataRole.priority then
                            curRoleId = roleId
                            curRoleQuality = dataRole.quality
                            curPriority = dataRole.priority
                        end
                    end
                end
            end
        end
    end

    if curRoleId then
        roleStateShowTb.isShow = true
        roleStateShowTb.showRoleId = curRoleId
        roleStateShowTb.waitStageRoleNum = num

        roleStateShowTb.showItem = curRoleId
        roleStateShowTb.showTitle = DataGrowNoticeRoleState.title
        roleStateShowTb.showNoticeText = _sformat(DataGrowNoticeRoleState.notice_text, num)
        roleStateShowTb.clickFunc = function ()
            RoleMainWindow.OpenWindow(curRoleId, {_jump = {RoleConfig.PageType.Attribute}, isOpenUpgradeWindow = true})
        end
    end

    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end

local weaponDataCache = {}

--武器替换
local DataGrowNoticeWeapon = DataGrowNotice[GrowNoticeEnum.Weapon]
local DataWeapon = Config.DataWeapon.Find
function GrowNoticeManager:UpdateWeapon()
    local weaponShowTb = self.toDoItems[GrowNoticeEnum.Weapon]
    weaponShowTb.isShow = false
    weaponShowTb.index = GrowNoticeEnum.Weapon

	TableUtils.ClearTable(weaponDataCache)

    local weapons = mod.BagCtrl:GetWeaponsData()
    if not weapons then
        return
    end
    for weaponType, v in pairs(weaponDataCache) do
        TableUtils.ClearTable(v)
    end

    for k, weaponData in pairs(weapons) do
        --未被佩戴
        if weaponData.hero_id == 0 then
            local weaponId = weaponData.template_id
            local dataWeapon = DataWeapon[weaponId]
            local cache = weaponDataCache[dataWeapon.type]
            if not weaponDataCache[dataWeapon.type] then
                weaponDataCache[dataWeapon.type] = {}
                cache = weaponDataCache[dataWeapon.type]
            end
            if not cache.quality or cache.quality < dataWeapon.quality then
                cache.weaponId = weaponId
                cache.uniqueId = weaponData.unique_id
                cache.quality = dataWeapon.quality
                cache.priority = dataWeapon.order_id
            elseif not cache.priority or cache.priority < dataWeapon.order_id then
                cache.weaponId = weaponId
                cache.uniqueId = weaponData.unique_id
                cache.quality = dataWeapon.quality
                cache.priority = dataWeapon.order_id
            end
        end
    end

    local curWeaponId = nil
    local curWeaponQuality = -1
    local curWeaponUniqueId = -1
    local curPriority = -1
    local curRoleId = nil
    local num = 0

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        local dataRole = DataHeroMain[roleId]
        local weaponType = dataRole.weapon_type
        -- 有备选
        if weaponDataCache[weaponType] and weaponDataCache[weaponType].uniqueId then
            local waitQueue = false
            if roleData.weapon_id == 0 then
                -- 没有装备武器
                waitQueue = true
            else
                -- 检查装备的武器品质
                local curWeaponData = mod.BagCtrl:GetItemByUniqueId(roleData.weapon_id, BagEnum.BagType.Weapon)
                curWeaponData = DataWeapon[curWeaponData.template_id]
            
                if curWeaponData.quality < ((weaponDataCache[weaponType] and weaponDataCache[weaponType].quality) or -1) then
                    waitQueue = true
                end
            end

            if waitQueue then
                -- TODO:入队
                num = num + 1
                local cache = weaponDataCache[weaponType]
                local weaponId = cache.weaponId
                local weaponUniqueId = cache.uniqueId
                local weaponQuality = cache.quality
                local weaponPriority = cache.priority

                if curWeaponQuality < weaponQuality then
                    curWeaponId = weaponId
                    curWeaponQuality = weaponQuality
                    curWeaponUniqueId = weaponUniqueId
                    curPriority = weaponPriority
                    curRoleId = roleId
                elseif curWeaponQuality == weaponQuality then
                    if curPriority < weaponPriority then
                        curWeaponId = weaponId
                        curWeaponQuality = weaponQuality
                        curWeaponUniqueId = weaponUniqueId
                        curPriority = weaponPriority
                        curRoleId = roleId
                    elseif curPriority == weaponPriority then
                        local curTmpDataRole = DataHeroMain[curRoleId]
                        local tmpDataRole = DataHeroMain[roleId]
                        if curTmpDataRole.quality < tmpDataRole.quality then
                            curRoleId = roleId
                        elseif curTmpDataRole.quality == tmpDataRole.quality and curTmpDataRole.priority < tmpDataRole.priority then
                            curRoleId = roleId
                        end
                    end
                    curWeaponId = weaponId
                    curWeaponQuality = weaponQuality
                    curWeaponUniqueId = weaponUniqueId
                    curPriority = weaponPriority
                    curRoleId = roleId
                end
            end
        end
    end

    if curWeaponId then
        weaponShowTb.isShow = true
        weaponShowTb.showWeaponId = curWeaponId
        weaponShowTb.showWeaponUniqueId = curWeaponUniqueId
        weaponShowTb.waitChangeRoleNum = num
        weaponShowTb.jumpToRoleId = curRoleId

        weaponShowTb.showItem = curWeaponId
        weaponShowTb.showTitle = DataGrowNoticeWeapon.title
        weaponShowTb.showNoticeText = _sformat(DataGrowNoticeWeapon.notice_text, num)
        weaponShowTb.clickFunc = function ()
            RoleMainWindow.OpenWindow(curRoleId, {_jump = {RoleConfig.PageType.Weapon, curWeaponUniqueId}})
        end
    end

    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end

--武器突破
local DataGrowNoticeWeaponState = DataGrowNotice[GrowNoticeEnum.WeaponState]
function GrowNoticeManager:UpdateWeaponState()
	TableUtils.ClearTable(self.toDoItems[GrowNoticeEnum.WeaponState])
    local weaponStateShowTb = self.toDoItems[GrowNoticeEnum.WeaponState]
    weaponStateShowTb.isShow = false
    weaponStateShowTb.index = GrowNoticeEnum.WeaponState

    local coinNum = mod.BagCtrl:GetItemCountById(2)

    local curWeaponId = nil
    local curWeaponQuality = -1
    local curWeaponUniqueId = -1
    local curPriority = -1
    local curRoleId = nil
    local num = 0

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        if roleData.weapon_id ~= 0 then
            -- 检查装备的武器品质
            local curWeaponData = mod.BagCtrl:GetItemByUniqueId(roleData.weapon_id, BagEnum.BagType.Weapon)
            if curWeaponData then
                local dataWeapon = DataWeapon[curWeaponData.template_id]
                local curWeaponStage = curWeaponData.stage
                local curWeaponLev = curWeaponData.lev
                local levLimit = RoleConfig.GetStageConfig(curWeaponData.template_id, curWeaponStage).level_limit
                if curWeaponLev == levLimit then
                    local nextDataWeapon = RoleConfig.GetStageConfig(curWeaponData.template_id, curWeaponStage + 1)
                    if nextDataWeapon and nextDataWeapon.need_item and coinNum >= nextDataWeapon.need_gold then
                        local waitQueue = true
                        if nextDataWeapon.condition_id and next(nextDataWeapon.condition_id) and not self.conditionManager:CheckConditionByConfig(nextDataWeapon.condition_id[1]) then
                            waitQueue = false
                            break
                        end
    
                        for _, v in pairs(nextDataWeapon.need_item) do
                            local itemId = v[1]
                            local itemNeedNum = v[2]
                            local itemNum = mod.BagCtrl:GetItemCountById(itemId)
                            if itemNum < itemNeedNum then
                                waitQueue = false
                                break
                            end
                        end
    
                        if waitQueue then
                            num = num + 1
                            if curWeaponQuality < dataWeapon.quality then
                                curWeaponId = dataWeapon.id
                                curWeaponQuality = dataWeapon.quality
                                curWeaponUniqueId = roleData.weapon_id
                                curPriority = dataWeapon.order_id
                                curRoleId = roleId
                            elseif curWeaponQuality == dataWeapon.quality then
                                if curPriority < dataWeapon.order_id then
                                    curWeaponId = dataWeapon.id
                                    curWeaponQuality = dataWeapon.quality
                                    curWeaponUniqueId = roleData.weapon_id
                                    curPriority = dataWeapon.order_id
                                    curRoleId = roleId
                                elseif curPriority == dataWeapon.order_id then
                                    local curTmpDataRole = DataHeroMain[curRoleId]
                                    local tmpDataRole = DataHeroMain[roleId]
                                    if curTmpDataRole.quality < tmpDataRole.quality then
                                        curRoleId = roleId
                                    elseif curTmpDataRole.quality == tmpDataRole.quality and
                                           curTmpDataRole.priority < tmpDataRole.priority then
                                        curRoleId = roleId
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if curWeaponId then
        weaponStateShowTb.isShow = true
        weaponStateShowTb.showWeaponId = curWeaponId
        weaponStateShowTb.showWeaponUniqueId = curWeaponUniqueId
        weaponStateShowTb.waitWeaponUpStageNum = num
        weaponStateShowTb.jumpToRoleId = curRoleId

        weaponStateShowTb.showItem = curWeaponId
        weaponStateShowTb.showTitle = DataGrowNoticeWeaponState.title
        weaponStateShowTb.showNoticeText = _sformat(DataGrowNoticeWeaponState.notice_text, num)
        weaponStateShowTb.clickFunc = function ()
            RoleMainWindow.OpenWindow(curRoleId, {_jump = {RoleConfig.PageType.Weapon}})
        end
    end

    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end

--月灵佩戴
local DataGrowNoticePartner = DataGrowNotice[GrowNoticeEnum.Partner]
function GrowNoticeManager:UpdatePartner()
    local partnerShowTb = self.toDoItems[GrowNoticeEnum.Partner]
    partnerShowTb.isShow = false
    partnerShowTb.index = GrowNoticeEnum.Partner

    local curPartnerId = nil
    local curPartnerUniqueId = nil
    local curPartnerQuality = -1
    local curPartnerPriority = -1

    local checkPartner = 0
    local partners = mod.BagCtrl:GetPartnersData()
    if not partners then
        return
    end
    for _, partnerData in pairs(partners) do
        --未被佩戴且不在资产中
        if partnerData.hero_id == 0 and partnerData.work_info.asset_id == 0 then
            checkPartner = checkPartner + 1
            local partnerId = partnerData.template_id
            local dataPartner = RoleConfig.GetPartnerConfig(partnerId)
            if curPartnerQuality < dataPartner.quality then
                curPartnerId = partnerId
                curPartnerUniqueId = partnerData.unique_id
                curPartnerQuality = dataPartner.quality
                curPartnerPriority = dataPartner.order_id
            elseif curPartnerQuality == dataPartner.quality and curPartnerPriority < dataPartner.order_id then
                curPartnerId = partnerId
                curPartnerUniqueId = partnerData.unique_id
                curPartnerQuality = dataPartner.quality
                curPartnerPriority = dataPartner.order_id
            end
        end
    end

    local curRoleId = nil
    local curRoleQuality = -1
    local curRolePriority = -1
    local checkRole = 0
    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        if roleData.partner_id == 0 then
            checkRole = checkRole + 1
            local dataRole = DataHeroMain[roleId]
            if curRoleQuality < dataRole.quality then
                curRoleId = roleId
                curRoleQuality = dataRole.quality
                curRolePriority = dataRole.priority
            elseif curRoleQuality == dataRole.quality and curRolePriority < dataRole.priority then
                curRoleId = roleId
                curRoleQuality = dataRole.quality
                curRolePriority = dataRole.priority
            end
        end
    end

    if checkRole ~= 0 and checkPartner ~= 0 then
        partnerShowTb.isShow = true
        partnerShowTb.showPartnerId = curPartnerId
        partnerShowTb.showPartnerUniqueId = curPartnerUniqueId
        partnerShowTb.waitLoadPartnerRoleNum = math.min(checkRole, checkPartner)
        partnerShowTb.jumpToRoleId = curRoleId

        partnerShowTb.showItem = curPartnerId
        partnerShowTb.showTitle = DataGrowNoticePartner.title
        partnerShowTb.showNoticeText = _sformat(DataGrowNoticePartner.notice_text, partnerShowTb.waitLoadPartnerRoleNum)
        partnerShowTb.clickFunc = function ()
            RoleMainWindow.OpenWindow(curRoleId, {_jump = {RoleConfig.PageType.ZhongMo, curPartnerUniqueId}})
        end
    end

    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end

--技能升级
local DataGrowNoticeRoleSkillUp = DataGrowNotice[GrowNoticeEnum.RoleSkillUp]
function GrowNoticeManager:UpdateRoleSkillUp()
    local roleSkillUpShowTb = self.toDoItems[GrowNoticeEnum.RoleSkillUp]
    roleSkillUpShowTb.isShow = false
    roleSkillUpShowTb.index = GrowNoticeEnum.RoleSkillUp

    local curRoleId = nil
    local curRoleQuality = -1
    local curPriority = -1
    local num = 0
    local coinNum = mod.BagCtrl:GetItemCountById(2)

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        local heroStateInfo = DataHeroStageUpgrade[UtilsBase.GetStringKeys(roleData.id, roleData.stage)]
        if heroStateInfo then
            local heroSkillLevLimit = heroStateInfo.limit_hero_skill_lev

            for _, v in pairs(roleData.skill_list) do
                local skillLev = v.lev
                local skillId = v.order_id
    
                if skillLev < heroSkillLevLimit then
                    local nextLevelInfo = RoleConfig.GetSkillLevelConfig(skillId, skillLev + 1)
                    if nextLevelInfo and coinNum >= nextLevelInfo.need_gold and nextLevelInfo.need_item then
                        local waitQueue = true
                        for _, v in pairs(nextLevelInfo.need_item) do
                            local itemId = v[1]
                            local itemNeedNum = v[2]
                            local itemNum = mod.BagCtrl:GetItemCountById(itemId)
                            if itemNum < itemNeedNum then
                                waitQueue = false
                                break
                            end
                        end
    
                        if waitQueue then
                            -- TODO:入队
                            num = num + 1
                            local dataRole = DataHeroMain[roleId]
                            if curRoleQuality < dataRole.quality then
                                curRoleId = roleId
                                curRoleQuality = dataRole.quality
                                curPriority = dataRole.priority
                            elseif curRoleQuality == dataRole.quality and curPriority < dataRole.priority then
                                curRoleId = roleId
                                curRoleQuality = dataRole.quality
                                curPriority = dataRole.priority
                            end
                            break
                        end
                    end
                end
            end
        end
    end

    if curRoleId then
        roleSkillUpShowTb.isShow = true
        roleSkillUpShowTb.showRoleId = curRoleId
        roleSkillUpShowTb.waitRoleSkillUpNum = num

        roleSkillUpShowTb.showItem = curRoleId
        roleSkillUpShowTb.showTitle = DataGrowNoticeRoleSkillUp.title
        roleSkillUpShowTb.showNoticeText = _sformat(DataGrowNoticeRoleSkillUp.notice_text, num)
        roleSkillUpShowTb.clickFunc = function ()
            RoleMainWindow.OpenWindow(curRoleId, {_jump = {RoleConfig.PageType.Skill}})
        end
    end

    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end

--脉象提升
local DataGrowNoticeRolePeriod = DataGrowNotice[GrowNoticeEnum.RolePeriod]
function GrowNoticeManager:UpdateRolePeriod()
    local rolePeriodShowTb = self.toDoItems[GrowNoticeEnum.RolePeriod]
    rolePeriodShowTb.isShow = false
    rolePeriodShowTb.index = GrowNoticeEnum.RolePeriod

    local curRoleId = nil
    local curRoleQuality = -1
    local curPriority = -1
    local num = 0

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        if roleData.star ~= RoleConfig.MaxStar then
            local periodInfo = RoleConfig.GetRolePeriodInfo(roleId, roleData.star + 1)
            if periodInfo then
                local periodNum = mod.BagCtrl:GetItemCountById(periodInfo.item)
                if periodNum >= periodInfo.num then
                    num = num + 1
                    local dataRole = DataHeroMain[roleId]
                    if curRoleQuality < dataRole.quality then
                        curRoleId = roleId
                        curRoleQuality = dataRole.quality
                        curPriority = dataRole.priority
                    elseif curRoleQuality == dataRole.quality and curPriority < dataRole.priority then
                        curRoleId = roleId
                        curRoleQuality = dataRole.quality
                        curPriority = dataRole.priority
                    end
                end
            end
        end
    end

    if curRoleId then
        rolePeriodShowTb.isShow = true
        rolePeriodShowTb.showRoleId = curRoleId
        rolePeriodShowTb.waitRolePeriodNum = num

        rolePeriodShowTb.showItem = curRoleId
        rolePeriodShowTb.showTitle = DataGrowNoticeRolePeriod.title
        rolePeriodShowTb.showNoticeText = _sformat(DataGrowNoticeRolePeriod.notice_text, num)
        rolePeriodShowTb.clickFunc = function ()
            RoleMainWindow.OpenWindow(curRoleId, {_jump = {RoleConfig.PageType.Mai}})
        end
    end

    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end

--玩家天赋
local DataGrowNoticeRoleTalent = DataGrowNotice[GrowNoticeEnum.RoleTalent]
function GrowNoticeManager:UpdateRoleTalent()
	TableUtils.ClearTable(self.toDoItems[GrowNoticeEnum.RoleTalent])
    local roleTalentShowTb = self.toDoItems[GrowNoticeEnum.RoleTalent]
    roleTalentShowTb.isShow = false
    roleTalentShowTb.index = GrowNoticeEnum.RoleTalent
    
    for i, itemId in ipairs(DataGrowNoticeRoleTalent.param) do
        local num = mod.BagCtrl:GetItemCountById(itemId)
        if num > 0 then
            roleTalentShowTb.isShow = true
            roleTalentShowTb.showItem = itemId
            break
        end
    end

    if roleTalentShowTb.isShow then
        roleTalentShowTb.showTitle = DataGrowNoticeRoleTalent.title
        roleTalentShowTb.showNoticeText = DataGrowNoticeRoleTalent.notice_text
        roleTalentShowTb.clickFunc = function ()
            MsgBoxManager.Instance:ShowTips(TI18N("敬请期待"))
        end
    end

    EventMgr.Instance:Fire(EventName.GrowNoticeSummaryUpdate)
end