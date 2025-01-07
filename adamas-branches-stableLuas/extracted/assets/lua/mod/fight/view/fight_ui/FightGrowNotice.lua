FightGrowNotice = BaseClass("FightGrowNotice", BasePanel)

local DataGrowNotice = Config.DataGrowNotice.Find
local DataGrowNoticeCommon = Config.DataGrowNoticeCommon.Find
local DataGrowNoticeBySystemId = Config.DataGrowNotice.FindbySystemId
local DataSystemOpen = Config.DataSystemOpen.data_system_open
local DataHeroStageUpgradeFindConditionInfo = Config.DataHeroStageUpgrade.FindConditionInfo
local DataWeaponStageUpgradeFindConditionIdInfo = Config.DataWeaponStageUpgrade.FindConditionIdInfo

local _tinsert = table.insert
local _tremove = table.remove
local _sformat = string.format

function FightGrowNotice:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightGrowNotice.prefab")
    self.mainView = mainView

    self.growNoticeId2CheckFunc = 
    {
        [GrowNoticeEnum.RoleState] = self.RoleStateCheck,
        [GrowNoticeEnum.Weapon] = self.WeaponCheck,
        [GrowNoticeEnum.WeaponState] = self.WeaponStateCheck,
        [GrowNoticeEnum.Partner] = self.PartnerCheck,
        [GrowNoticeEnum.RoleSkillUp] = self.RoleSkillUpCheck,
        [GrowNoticeEnum.RolePeriod] = self.RolePeriodCheck,
        [GrowNoticeEnum.RoleTalent] = self.RoleTalentCheck,
    }

    self.unlockGrowNoticeId = {}

    self.waitShowQueue = 
    {
        [GrowNoticeEnum.RoleState] = {},
        [GrowNoticeEnum.Weapon] = {},
        [GrowNoticeEnum.WeaponState] = {},
        [GrowNoticeEnum.Partner] = {},
        [GrowNoticeEnum.RoleSkillUp] = {},
        [GrowNoticeEnum.RolePeriod] = {},
        [GrowNoticeEnum.RoleTalent] = {},
    }

    self.growNoticeId2ShowFunc = 
    {
        [GrowNoticeEnum.RoleState] = self.RoleStateShow,
        [GrowNoticeEnum.Weapon] = self.WeaponShow,
        [GrowNoticeEnum.WeaponState] = self.WeaponStateShow,
        [GrowNoticeEnum.Partner] = self.PartnerShow,
        [GrowNoticeEnum.RoleSkillUp] = self.RoleSkillUpShow,
        [GrowNoticeEnum.RolePeriod] = self.RolePeriodShow,
        [GrowNoticeEnum.RoleTalent] = self.RoleTalentShow,
    }

    self.cacheTable = {}
end

function FightGrowNotice:__delete()
	EventMgr.Instance:RemoveListener(EventName.ItemRecv, self:ToFunc("OnItemRecv"))
	EventMgr.Instance:RemoveListener(EventName.GrowNoticeSummaryUpdate, self:ToFunc("OnGrowNoticeSummaryUpdate"))
	EventMgr.Instance:RemoveListener(EventName.GrowNoticeResumeShow, self:ToFunc("ResumeShow"))

    if self.commonItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.commonItem)
        self.commonItem = nil
    end
end

function FightGrowNotice:__BindListener()
    self.BriefNoticeBtn_btn.onClick:AddListener(self:ToFunc("OpenPhoneGrowNoticePanel"))
    self.SingleNoticeBtn_btn.onClick:AddListener(self:ToFunc("OpenPhoneGrowNoticePanel"))

	EventMgr.Instance:AddListener(EventName.ItemRecv, self:ToFunc("OnItemRecv"))
	EventMgr.Instance:AddListener(EventName.GrowNoticeSummaryUpdate, self:ToFunc("OnGrowNoticeSummaryUpdate"))
	EventMgr.Instance:AddListener(EventName.GrowNoticeResumeShow, self:ToFunc("ResumeShow"))
end

function FightGrowNotice:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)


end

function FightGrowNotice:__CacheObject()
	
end

function FightGrowNotice:__Show()
    self.conditionManager = Fight.Instance.conditionManager
    for k, v in pairs(DataGrowNoticeBySystemId) do
        local systemId = k
        if self.conditionManager:CheckSystemOpen(systemId) then
            for _, index in pairs(v) do
                self.unlockGrowNoticeId[index] = true
            end
        else
            if DataSystemOpen[systemId] then
                local conditionId = DataSystemOpen[systemId].condition
                local idList = v
                self.conditionManager:AddListener(conditionId, function (id)
                    for _, index in pairs(idList) do
                        self.unlockGrowNoticeId[index] = true
                    end
                end)
            else
                LogErrorf("没有找到系统表对应系统 %d", v.system_id)
            end
        end
    end

    self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") or CommonItem.New()

    self.fight = Fight.Instance
    self.singleGrowNoticeTime = DataGrowNoticeCommon["GrowNoticeTime"].double_val * 10000
    self.nextGrowNoticeTime = self.fight.time
    self.isShow = false
    self.isLogicShow = false
    self.isHoldShow = false

    self.animator = self.gameObject:GetComponent(Animator)
end

function FightGrowNotice:__ShowComplete()
    self:OnGrowNoticeSummaryUpdate()
    CustomUnityUtils.SetScreenBlur(true, 2, 2)

    UtilsUI.SetHideCallBack(self.SingleNoticeIn, self:ToFunc("OnShowSingleTipsEnd"))
    UtilsUI.SetHideCallBack(self.SingleNoticeOut, self:ToFunc("OnCloseSingleTipsEnd"))
end

function FightGrowNotice:OpenPhoneGrowNoticePanel()
	self.mainView:HideSelf(function ()
		WindowManager.Instance:OpenWindow(PhoneMenuWindow,{
            PanelType = InformationConfig.PanelType.GrowNotice
        })
	end)
end

function FightGrowNotice:OnGrowNoticeSummaryUpdate()
    local num = Fight.Instance.growNoticeManager:GetNoticeNum()
    self.BriefNoticeNum_txt.text = num
    if num == 0 then
        UtilsUI.SetActive(self.BriefNotice, false)
    else
        UtilsUI.SetActive(self.BriefNotice, true)
    end
end

function FightGrowNotice:WaitHide()
    if self.isLogicShow or self.isShow then
        self:CloseSingleTips(true)
    end

end

function FightGrowNotice:IsHoldTips()
    return self.isShow
end

function FightGrowNotice:LogicUpdate()
    if self.fight.time >= self.nextGrowNoticeTime then
        if self.isShow then
            if self.isLogicShow then
                self:CloseSingleTips()
            end
        else
            --检查是否弹出
            for index, v in pairs(self.waitShowQueue) do
                if #v > 0 then
                    self.growNoticeId2ShowFunc[index](self, v[1])
                    _tremove(v, 1)
                    break
                end
            end
        end
    end
end

function FightGrowNotice:CloseSingleTips(force)
    self.isHoldShow = false
    if force then
        self.isShow = false
        self.isLogicShow = false
    else
        self.isLogicShow = false
        self.animator:Play("UI_FightGrowNoticeDie")
    end
end

function FightGrowNotice:ShowSingleTips(force)
    self.isShow = true
    
    if force then
        UtilsUI.SetActive(self.SingleNotice, true)
        self.nextGrowNoticeTime = self.fight.time + self.singleGrowNoticeTime
        self.animator:CrossFade("UI_FightGrowNoticeShow", 0, -1, 0)
        self.isLogicShow = true
    else
        LuaTimerManager.Instance:AddTimer(1, 1, function ()
            UtilsUI.SetActive(self.SingleNotice, true)
            self.nextGrowNoticeTime = self.fight.time + self.singleGrowNoticeTime
            self.isLogicShow = true
            self.animator:CrossFade("UI_FightGrowNoticeShow", 0, -1, 0)
            self.animator:Update(0)
        end)
    end
end

function FightGrowNotice:OnShowSingleTipsEnd()
    self.isHoldShow = true
end

function FightGrowNotice:OnCloseSingleTipsEnd()
    self.isShow = false
    UtilsUI.SetActive(self.SingleNotice, false)
end

function FightGrowNotice:ResumeShow()
    if self.isLogicShow then
        self:ShowSingleTips(true)
        self.animator:Update(0)
    end
end

function FightGrowNotice:OnItemRecv(rewardList, rewardSrc)
    for _, v in pairs(rewardList) do
		local uniqueId = v.unique_id
        local templateId = v.template_id
        --奖励数量
        local rewardNum = v.count
        --当前数量
        local curNum = mod.BagCtrl:GetItemCountById(templateId)
        --获取奖励前的数量
        local lastNum = curNum - rewardNum
        
        for index, _ in pairs(self.unlockGrowNoticeId) do
            self.growNoticeId2CheckFunc[index](self, uniqueId, templateId, rewardNum, curNum, lastNum)
        end
	end
    self:CheckQueue()
end

function FightGrowNotice:CheckQueue()
    self:CheckQueueRoleState()
    self:CheckQueueWeapon()
    self:CheckQueueWeaponState()
    self:CheckQueuePartner()
    self:CheckQueueRoleSkillUp()
    self:CheckQueueRolePeriod()
    self:CheckQueueRoleTalent()
end

function FightGrowNotice:ClearQueue()
    for k, v in pairs(self.waitShowQueue) do
        TableUtils.ClearTable(v)
    end
    self:CloseSingleTips()
end

function FightGrowNotice:CheckQueueRoleState()
    TableUtils.ClearTable(self.cacheTable)
    if #self.waitShowQueue[GrowNoticeEnum.RoleState] > 0 then
        for index, v in ipairs(self.waitShowQueue[GrowNoticeEnum.RoleState]) do
            local roleId = v.roleId
            if not self.cacheTable[roleId] then
                self.cacheTable[roleId] = v
            end
        end

        TableUtils.ClearTable(self.waitShowQueue[GrowNoticeEnum.RoleState])
        for roleId, v in pairs(self.cacheTable) do
            _tinsert(self.waitShowQueue[GrowNoticeEnum.RoleState], v)
        end
    end
end

function FightGrowNotice:CheckQueueWeapon()
    TableUtils.ClearTable(self.cacheTable)
    if #self.waitShowQueue[GrowNoticeEnum.Weapon] > 0 then
        for index, v in ipairs(self.waitShowQueue[GrowNoticeEnum.Weapon]) do
            local roleId = v.roleId
            local cacheT = self.cacheTable[roleId]
            if not cacheT then
                self.cacheTable[roleId] = v
            else
                if v.weaponQuality > cacheT.weaponQuality then
                    self.cacheTable[roleId] = v
                elseif v.weaponQuality == cacheT.weaponQuality and v.criticalItemId > cacheT.criticalItemId then
                    self.cacheTable[roleId] = v
                end
            end
        end

        local cacheW = {}
        local deleteRole = {}
        for roleId, v in pairs(self.cacheTable) do
            if cacheW[v.criticalItemId] then
                deleteRole[roleId] = true
            else
                cacheW[v.criticalItemId] = true
            end
        end

        for roleId, v in pairs(deleteRole) do
            self.cacheTable[roleId] = nil
        end

        TableUtils.ClearTable(self.waitShowQueue[GrowNoticeEnum.Weapon])
        for roleId, v in pairs(self.cacheTable) do
            _tinsert(self.waitShowQueue[GrowNoticeEnum.Weapon], v)
        end
    end
end

function FightGrowNotice:CheckQueueWeaponState()
    TableUtils.ClearTable(self.cacheTable)
    if #self.waitShowQueue[GrowNoticeEnum.WeaponState] > 0 then
        for index, v in ipairs(self.waitShowQueue[GrowNoticeEnum.WeaponState]) do
            local roleId = v.roleId
            if not self.cacheTable[roleId] then
                self.cacheTable[roleId] = v
            end
        end

        TableUtils.ClearTable(self.waitShowQueue[GrowNoticeEnum.WeaponState])
        for roleId, v in pairs(self.cacheTable) do
            _tinsert(self.waitShowQueue[GrowNoticeEnum.WeaponState], v)
        end
    end
end

function FightGrowNotice:CheckQueuePartner()
    TableUtils.ClearTable(self.cacheTable)
    if #self.waitShowQueue[GrowNoticeEnum.Partner] > 0 then
        for index, v in ipairs(self.waitShowQueue[GrowNoticeEnum.Partner]) do
            local cacheT = self.cacheTable[1]
            if not cacheT then
                self.cacheTable[1] = v
            elseif cacheT.partnerQuality < v.partnerQuality or cacheT.partnerPriority < v.partnerPriority then
                self.cacheTable[1] = v
            end
        end

        TableUtils.ClearTable(self.waitShowQueue[GrowNoticeEnum.Partner])
        for roleId, v in pairs(self.cacheTable) do
            _tinsert(self.waitShowQueue[GrowNoticeEnum.Partner], v)
        end
    end
end

function FightGrowNotice:CheckQueueRoleSkillUp()
    TableUtils.ClearTable(self.cacheTable)
    if #self.waitShowQueue[GrowNoticeEnum.RoleSkillUp] > 0 then
        for index, v in ipairs(self.waitShowQueue[GrowNoticeEnum.RoleSkillUp]) do
            local roleId = v.roleId
            if not self.cacheTable[roleId] then
                self.cacheTable[roleId] = v
            end
        end

        TableUtils.ClearTable(self.waitShowQueue[GrowNoticeEnum.RoleSkillUp])
        for roleId, v in pairs(self.cacheTable) do
            _tinsert(self.waitShowQueue[GrowNoticeEnum.RoleSkillUp], v)
        end
    end
end

function FightGrowNotice:CheckQueueRolePeriod()
    TableUtils.ClearTable(self.cacheTable)
    if #self.waitShowQueue[GrowNoticeEnum.RolePeriod] > 0 then
        for index, v in ipairs(self.waitShowQueue[GrowNoticeEnum.RolePeriod]) do
            local roleId = v.roleId
            if not self.cacheTable[roleId] then
                self.cacheTable[roleId] = v
            end
        end

        TableUtils.ClearTable(self.waitShowQueue[GrowNoticeEnum.RolePeriod])
        for roleId, v in pairs(self.cacheTable) do
            _tinsert(self.waitShowQueue[GrowNoticeEnum.RolePeriod], v)
        end
    end
end

function FightGrowNotice:CheckQueueRoleTalent()
    TableUtils.ClearTable(self.cacheTable)
    if #self.waitShowQueue[GrowNoticeEnum.RoleTalent] > 0 then
        for index, v in ipairs(self.waitShowQueue[GrowNoticeEnum.RoleTalent]) do
            local cacheT = self.cacheTable[1]
            local criticalItemId = v.criticalItemId
            if not cacheT then
                self.cacheTable[1] = v
            elseif criticalItemId == 20503 and cacheT.criticalItemId ~= 20503 then
                self.cacheTable[1] = v
            end
        end

        TableUtils.ClearTable(self.waitShowQueue[GrowNoticeEnum.RoleTalent])
        for roleId, v in pairs(self.cacheTable) do
            _tinsert(self.waitShowQueue[GrowNoticeEnum.RoleTalent], v)
        end
    end
end

function FightGrowNotice:CheckItemIdInRange(rangeList, templateId)
    if rangeList then
        for k, v in pairs(rangeList) do
            local startId = v[1]
            local endId = v[2]
            if templateId >= startId and templateId <= endId then
                return true
            end
        end
    end
    return false
end

--角色突破
local DataGrowNoticeRoleState = DataGrowNotice[GrowNoticeEnum.RoleState]
local DataHeroStageUpgrade = Config.DataHeroStageUpgrade.Find
local DataHeroMain = Config.DataHeroMain.Find
function FightGrowNotice:RoleStateCheck(uniqueId, templateId, rewardNum, curNum, lastNum)
    local isRange = self:CheckItemIdInRange(DataGrowNoticeRoleState.judge_id_range, templateId)
    if not isRange then
        return
    end

    local coinNum = mod.BagCtrl:GetItemCountById(2)

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        local roleStage = roleData.stage
        local curStageData = DataHeroStageUpgrade[UtilsBase.GetStringKeys(roleData.id, roleStage)]
        if roleData.lev == curStageData.limit_hero_lev then
            local nextStageData = DataHeroStageUpgrade[UtilsBase.GetStringKeys(roleData.id, roleStage + 1)]
            if nextStageData and nextStageData.need_item and coinNum >= nextStageData.need_gold and self.conditionManager:CheckConditionByConfig(nextStageData.condition) then
                local waitQueue = false
                for _, v in pairs(nextStageData.need_item) do
                    local itemId = v[1]
                    local itemNeedNum = v[2]
                    if itemId == templateId then
                        if curNum >= itemNeedNum and lastNum < itemNeedNum then
                            waitQueue = true
                        else
                            waitQueue = false
                            break
                        end
                    else
                        local itemNum = mod.BagCtrl:GetItemCountById(itemId)
                        if itemNum < itemNeedNum then
                            waitQueue = false
                            break
                        end
                    end
                end

                if waitQueue then
                    -- TODO:入队
                    _tinsert(self.waitShowQueue[GrowNoticeEnum.RoleState], {roleId = roleId, curRoleState = roleStage, criticalItemId = templateId, dataRole = DataHeroMain[roleId]})
                end
            end
        end
    end
end

local commonItemDataSet = {template_id = nil, count = 0, scale = 0.73}

function FightGrowNotice:RoleStateShow(t)
    commonItemDataSet.template_id = t.roleId
    self.TipsTitle_txt.text = DataGrowNoticeRoleState.title
    self.TipsNotice_txt.text = _sformat(DataGrowNoticeRoleState.tip_text, t.dataRole.name)
    self.commonItem:InitItem(self.CommonItem, commonItemDataSet, true)
    self:ShowSingleTips()

    Fight.Instance.growNoticeManager:SetOverrideSort(GrowNoticeEnum.RoleState)
end

--武器替换
local DataGrowNoticeWeapon = DataGrowNotice[GrowNoticeEnum.Weapon]
local DataWeapon = Config.DataWeapon.Find
function FightGrowNotice:WeaponCheck(uniqueId, templateId, rewardNum, curNum, lastNum)
    local isRange = self:CheckItemIdInRange(DataGrowNoticeWeapon.judge_id_range, templateId)
    if not isRange then
        return
    end

    local rewardWeaponData = DataWeapon[templateId]
    if not rewardWeaponData then
        LogErrorf("%d 不是武器", templateId)
        return
    end

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        local dataRole = DataHeroMain[roleId]
        if dataRole.weapon_type == rewardWeaponData.type then
            local waitQueue = false
            if roleData.weapon_id == 0 then
                -- 没有装备武器
                waitQueue = true
            else
                -- 检查装备的武器品质
                local curWeaponData = mod.BagCtrl:GetItemByUniqueId(roleData.weapon_id, BagEnum.BagType.Weapon)
                curWeaponData = DataWeapon[curWeaponData.template_id]
    
                if rewardWeaponData.quality > curWeaponData.quality then
                    waitQueue = true
                end
            end
            if waitQueue then
                -- TODO:入队
                _tinsert(self.waitShowQueue[GrowNoticeEnum.Weapon], {
                    roleId = roleId,
                    curRoleWeaponUniqueId = roleData.weapon_id,
                    weaponUniqueId = uniqueId,
                    weaponQuality = rewardWeaponData.quality,
                    criticalItemId = templateId,
                    dataWeapon = rewardWeaponData})
            end
        end
    end
end

function FightGrowNotice:WeaponShow(t)
    commonItemDataSet.template_id = t.criticalItemId
    self.TipsTitle_txt.text = DataGrowNoticeWeapon.title
    self.TipsNotice_txt.text = _sformat(DataGrowNoticeWeapon.tip_text, t.dataWeapon.name)
    self.commonItem:InitItem(self.CommonItem, commonItemDataSet, true)
    self:ShowSingleTips()

    Fight.Instance.growNoticeManager:SetOverrideSort(GrowNoticeEnum.Weapon)
end

--武器突破
local DataGrowNoticeWeaponState = DataGrowNotice[GrowNoticeEnum.WeaponState]
function FightGrowNotice:WeaponStateCheck(uniqueId, templateId, rewardNum, curNum, lastNum)
    local isRange = self:CheckItemIdInRange(DataGrowNoticeWeaponState.judge_id_range, templateId)
    if not isRange then
        return
    end
    local coinNum = mod.BagCtrl:GetItemCountById(2)

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        if roleData.weapon_id ~= 0 then
            -- 检查装备的武器品质
            local curWeaponData = mod.BagCtrl:GetItemByUniqueId(roleData.weapon_id, BagEnum.BagType.Weapon)
            local curWeaponStage = curWeaponData.stage
            local curWeaponLev = curWeaponData.lev
            local levLimit = RoleConfig.GetStageConfig(curWeaponData.template_id, curWeaponStage).level_limit
            if curWeaponLev == levLimit then
                local nextDataWeapon = RoleConfig.GetStageConfig(curWeaponData.template_id, curWeaponStage + 1)
                if nextDataWeapon and nextDataWeapon.need_item and coinNum >= nextDataWeapon.need_gold then
                    local waitQueue = true
                    if nextDataWeapon.condition_id then
                        for _, conditionId in pairs(nextDataWeapon.condition_id) do
                            if not self.conditionManager:CheckConditionByConfig(conditionId) then
                                waitQueue = false
                                break
                            end
                        end
                    end
                    if waitQueue then
                        for _, v in pairs(nextDataWeapon.need_item) do
                            local itemId = v[1]
                            local itemNeedNum = v[2]
                            if itemId == templateId then
                                if curNum >= itemNeedNum and lastNum < itemNeedNum then
                                    waitQueue = true
                                else
                                    waitQueue = false
                                    break
                                end
                            else
                                local itemNum = mod.BagCtrl:GetItemCountById(itemId)
                                if itemNum < itemNeedNum then
                                    waitQueue = false
                                    break
                                end
                            end
                        end
    
                        if waitQueue then
                            -- TODO:入队
                            _tinsert(self.waitShowQueue[GrowNoticeEnum.WeaponState], {
                                roleId = roleId, 
                                curWeaponUniqueId = roleData.weapon_id, 
                                curWeaponStage = curWeaponStage, 
                                criticalItemId = templateId,
                                dataWeapon = DataWeapon[curWeaponData.template_id]})
                        end
                    end
                end
            end
        end
    end
end

function FightGrowNotice:WeaponStateShow(t)
    commonItemDataSet.template_id = t.dataWeapon.id
    self.TipsTitle_txt.text = DataGrowNoticeWeaponState.title
    self.TipsNotice_txt.text = _sformat(DataGrowNoticeWeaponState.tip_text, t.dataWeapon.name)
    self.commonItem:InitItem(self.CommonItem, commonItemDataSet, true)
    self:ShowSingleTips()
    
    Fight.Instance.growNoticeManager:SetOverrideSort(GrowNoticeEnum.WeaponState)
end

--月灵佩戴
local DataGrowNoticePartner = DataGrowNotice[GrowNoticeEnum.Partner]
function FightGrowNotice:PartnerCheck(uniqueId, templateId, rewardNum, curNum, lastNum)
    local isRange = self:CheckItemIdInRange(DataGrowNoticePartner.judge_id_range, templateId)
    if not isRange then
        return
    end
    
    local rewardPartnerData = RoleConfig.GetPartnerConfig(templateId)
    if not rewardPartnerData then
        LogErrorf("%d 不是月灵", templateId)
        return
    end

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        if roleData.partner_id == 0 then
            -- 没有装备月灵
            -- TODO:入队
            _tinsert(self.waitShowQueue[GrowNoticeEnum.Partner], {
                roleId = roleId, 
                partnerUniqueId = uniqueId, 
                partnerId = templateId, 
                partnerQuality = rewardPartnerData.quality,
                partnerPriority = rewardPartnerData.priority,
                dataPartner = rewardPartnerData})
        end
    end
end

function FightGrowNotice:PartnerShow(t)
    commonItemDataSet.template_id = t.partnerId
    self.TipsTitle_txt.text = DataGrowNoticePartner.title
    self.TipsNotice_txt.text = _sformat(DataGrowNoticePartner.tip_text, t.dataPartner.name)
    self.commonItem:InitItem(self.CommonItem, commonItemDataSet, true)
    self:ShowSingleTips()
    
    Fight.Instance.growNoticeManager:SetOverrideSort(GrowNoticeEnum.Partner)
end

--技能升级
local DataGrowNoticeRoleSkillUp = DataGrowNotice[GrowNoticeEnum.RoleSkillUp]
function FightGrowNotice:RoleSkillUpCheck(uniqueId, templateId, rewardNum, curNum, lastNum)
    local isRange = self:CheckItemIdInRange(DataGrowNoticeRoleSkillUp.judge_id_range, templateId)
    if not isRange then
        return
    end
    local coinNum = mod.BagCtrl:GetItemCountById(2)

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        local heroStateInfo = DataHeroStageUpgrade[UtilsBase.GetStringKeys(roleData.id, roleData.stage)]
        local heroSkillLevLimit = heroStateInfo.limit_hero_skill_lev

        for _, v in pairs(roleData.skill_list) do
            local skillLev = v.lev
            local skillId = v.order_id

            if skillLev < heroSkillLevLimit then
                local nextLevelInfo = RoleConfig.GetSkillLevelConfig(skillId, skillLev + 1)
                if nextLevelInfo and coinNum >= nextLevelInfo.need_gold and nextLevelInfo.need_item then
                    local waitQueue = false
                    for _, v in pairs(nextLevelInfo.need_item) do
                        local itemId = v[1]
                        local itemNeedNum = v[2]
                        if itemId == templateId then
                            if curNum >= itemNeedNum and lastNum < itemNeedNum then
                                waitQueue = true
                            else
                                waitQueue = false
                                break
                            end
                        else
                            local itemNum = mod.BagCtrl:GetItemCountById(itemId)
                            if itemNum < itemNeedNum then
                                waitQueue = false
                                break
                            end
                        end
                    end

                    if waitQueue then
                        -- TODO:入队
                        _tinsert(self.waitShowQueue[GrowNoticeEnum.RoleSkillUp], {roleId = roleId, skillId = skillId, curSkillLev = skillLev, criticalItemId = templateId, dataRole = DataHeroMain[roleId]})
                    end
                end
            end
        end
    end
end

function FightGrowNotice:RoleSkillUpShow(t)
    commonItemDataSet.template_id = t.roleId
    self.TipsTitle_txt.text = DataGrowNoticeRoleSkillUp.title
    self.TipsNotice_txt.text = _sformat(DataGrowNoticeRoleSkillUp.tip_text, t.dataRole.name)
    self.commonItem:InitItem(self.CommonItem, commonItemDataSet, true)
    self:ShowSingleTips()
    
    Fight.Instance.growNoticeManager:SetOverrideSort(GrowNoticeEnum.RoleSkillUp)
end

--脉象提升
local DataGrowNoticeRolePeriod = DataGrowNotice[GrowNoticeEnum.RolePeriod]
function FightGrowNotice:RolePeriodCheck(uniqueId, templateId, rewardNum, curNum, lastNum)
    local isRange = self:CheckItemIdInRange(DataGrowNoticeRolePeriod.judge_id_range, templateId)
    if not isRange then
        return
    end

    local roleList = mod.RoleCtrl:GetRoleList()
    for roleId, roleData in pairs(roleList) do
        if roleData.star ~= RoleConfig.MaxStar then
            local periodInfo = RoleConfig.GetRolePeriodInfo(roleId, roleData.star + 1)
            if periodInfo.item == templateId and curNum >= periodInfo.num and lastNum < periodInfo.num then
                -- TODO:入队
                _tinsert(self.waitShowQueue[GrowNoticeEnum.RolePeriod], {roleId = roleId, curPeriod = roleData.star, criticalItemId = templateId, dataRole = DataHeroMain[roleId]})
            end
        end
    end
end

function FightGrowNotice:RolePeriodShow(t)
    commonItemDataSet.template_id = t.roleId
    self.TipsTitle_txt.text = DataGrowNoticeRolePeriod.title
    self.TipsNotice_txt.text = _sformat(DataGrowNoticeRolePeriod.tip_text, t.dataRole.name)
    self.commonItem:InitItem(self.CommonItem, commonItemDataSet, true)
    self:ShowSingleTips()
    
    Fight.Instance.growNoticeManager:SetOverrideSort(GrowNoticeEnum.RolePeriod)
end

--玩家天赋
local DataGrowNoticeRoleTalent = DataGrowNotice[GrowNoticeEnum.RoleTalent]
function FightGrowNotice:RoleTalentCheck(uniqueId, templateId, rewardNum, curNum, lastNum)
    local isRange = self:CheckItemIdInRange(DataGrowNoticeRoleTalent.judge_id_range, templateId)
    if not isRange then
        return
    end
    -- TODO:入队
    _tinsert(self.waitShowQueue[GrowNoticeEnum.RoleTalent], {criticalItemId = templateId})
end

function FightGrowNotice:RoleTalentShow(t)
    commonItemDataSet.template_id = t.criticalItemId
    self.TipsTitle_txt.text = DataGrowNoticeRoleTalent.title
    self.TipsNotice_txt.text = DataGrowNoticeRoleTalent.tip_text
    self.commonItem:InitItem(self.CommonItem, commonItemDataSet, true)
    self:ShowSingleTips()
    
    Fight.Instance.growNoticeManager:SetOverrideSort(GrowNoticeEnum.RoleTalent)
end