PartnerManager = BaseClass("PartnerManager")
local _tinsert = table.insert
function PartnerManager:__init(fight)
	self.fight = fight
    self.clientFight = fight.clientFight
    self.roleCtrl = mod.RoleCtrl
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))

    self.concludeMap = {}
    self.showTipQueueMap = {}
    self:TimeingAsyncEntityState()
end

function PartnerManager:BindListener()

end

function PartnerManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function PartnerManager:Update()

end

function PartnerManager:GetUseConcludeItem(lastId)
    local itemMap = PartnerConfig.GetAllPartnerBallItem()
    local startQuality = 1
    if lastId then
	    local cfg = PartnerConfig.GetPartnerBallCfg(lastId)
        startQuality = cfg.quality
    end

    local checkCB = function(id, isNotCheckQuality)
        local cfg = PartnerConfig.GetPartnerBallCfg(id)
        if cfg.quality >= startQuality or isNotCheckQuality then
            local itemNum = mod.BagCtrl:GetItemCountById(id)
            if itemNum > 0 then
                return true, id
            end
        end
    end

    for i = 1, #itemMap do
        local data = itemMap[i]
        local id = data.id
        if checkCB(id) then
            return id
        end
    end

    if startQuality <= 1  then return end
    for i = 1, startQuality - 1 do
        local data = itemMap[i]
        local id = data.id
        if checkCB(id, true) then
            return id
        end
    end
end

function PartnerManager:OnActionInput(key, value)
    if key == FightEnum.ActionToKeyEvent.ChangeConcludeItem then

        local curAbilityId = mod.AbilityWheelCtrl:GetCurSelectWheelAbilityId()
        if curAbilityId == AbilityWheelConfig.PartnerConcludeId then
            self:OnClickChangeConcludeItemBtn()
        end
    end
end

-- 点击切换按钮
function PartnerManager:OnClickChangeConcludeItemBtn()
    local curEquipItem = self.roleCtrl:GetEquipConcludeItemId()
    local cfg = PartnerConfig.GetPartnerBallCfg(curEquipItem)
    if not cfg then return end
    local curQuality = cfg.quality
    local itemMap = PartnerConfig.GetAllPartnerBallItem()
    local selectIdx = curQuality + 1
    if curQuality >= #itemMap then
        selectIdx = 1
    end
    
    local selectItem
    for _, v in ipairs(itemMap) do
        local cfg = PartnerConfig.GetPartnerBallCfg(v.id)
        local quality = cfg.quality
        if quality > curQuality then
            selectItem = v
            break
        end
    end

    if not selectItem then
        selectItem = itemMap[1] or {id = curEquipItem}
    end

    self.roleCtrl:UpdateEquipConcludeItemId(selectItem.id)
end

-- 点击缔结按钮
function PartnerManager:OnClikcConcludeBtn()
    -- 缔结技能检测
    if not BehaviorFunctions.CheckAbilityCanUse(401) then return end

    local curEquipItem = self.roleCtrl:GetEquipConcludeItemId()
    if not curEquipItem or curEquipItem == 0 then
        curEquipItem = self:GetUseConcludeItem()
        if curEquipItem then
            self.roleCtrl:UpdateEquipConcludeItemId(curEquipItem)
        else
            return
        end
    end

    local itemNum = mod.BagCtrl:GetItemCountById(curEquipItem)
    if itemNum <= 0 then 
        curEquipItem = self:GetUseConcludeItem(curEquipItem)
        if not curEquipItem then
            return
        else
            self.roleCtrl:UpdateEquipConcludeItemId(curEquipItem)
        end
    end
    local cfg = PartnerConfig.GetPartnerBallCfg(curEquipItem)
    if not cfg then return end
    self.roleCtrl:UpdateEquipConcludeItemId(curEquipItem)
    -- 通知策划点击了按钮
    self.fight.entityManager:CallBehaviorFun("ConcludePartner", cfg.quality)
    return true
end

-- 检查是否能够使用缔结道具
function PartnerManager:CheckUseConcludeItem()
    local itemMap = PartnerConfig.GetAllPartnerBallItem()
    for i = 1, #itemMap do
        local data = itemMap[i]
        local id = data.id
        local itemNum = mod.BagCtrl:GetItemCountById(id)
        if itemNum > 0 then
            return true, id
        end
    end
    return false
end

function PartnerManager:CheckUseCurConcludeItem()
    local curEquipItem = self.roleCtrl:GetEquipConcludeItemId()
    local itemNum = mod.BagCtrl:GetItemCountById(curEquipItem)
    return curEquipItem or 0, itemNum
end


function PartnerManager:GetEntityByEcoId(ecoId)
    local insId = BehaviorFunctions.GetEcoEntityByEcoId(ecoId)
    local targetEntity = BehaviorFunctions.GetEntity(insId)
    return targetEntity
end

-- 使用成功回调
function PartnerManager:UseConcludeItem(itemId, targetEcoId)
    local itemNum = mod.BagCtrl:GetItemCountById(itemId)
    if itemNum <= 0 then
		LogError("缺少道具")
		return
	end

    local targetEntity = self:GetEntityByEcoId(targetEcoId)
    
    local attrComponent = targetEntity.attrComponent
    if not attrComponent then return end
    local val, maxVal = attrComponent:GetValueAndMaxValue(EntityAttrsConfig.AttrType.Life)
    local percent = val / maxVal

    local isConcludeElementBreak = targetEntity:IsConcludeElementBreakState()
    self.cacheUseItemId = itemId
    -- 发送协议
    mod.RoleFacade:SendMsg("partner_conclude", itemId, targetEcoId, math.floor(percent * 10000), isConcludeElementBreak)

    -- 记录所有添加了缔结buff的怪物Id
    self.concludeMap[targetEcoId] = {}
end

-- 缔结成功后端返回概率
function PartnerManager:RecvUseConcludeItemData(data)
    if not self.concludeMap[data.ecosystem_id] then
        LogError("出现了管理外的实体")
        return
    end
    local concludeData = self.concludeMap[data.ecosystem_id]
    concludeData.probability = data.probability

    local lastUseId = self.cacheUseItemId or 0
    local itemCfg = ItemConfig.GetItemConfig(lastUseId)
    local quality = itemCfg and itemCfg.quality or 1
	-- 加buff由策划加
    self.fight.entityManager:CallBehaviorFun("RecvConcludeProbability", data.probability, data.result, quality)
    -- 这里刷新一下概率
    local entity = self:GetEntityByEcoId(data.ecosystem_id)
    if entity then
        entity:UpdateCatchPrecent(data.probability)
    end
end

-- 定时同步状态，心跳包
function PartnerManager:TimeingAsyncEntityState()
    if self.heartTime then
        LuaTimerManager.Instance:RemoveTimer(self.heartTime)
        self.heartTime = nil
    end
    self.heartTime = LuaTimerManager.Instance:AddTimer(1, 5, function()
        for ecoId, v in pairs(self.concludeMap) do
            mod.RoleFacade:SendMsg("partner_conclude_heart", ecoId)
        end
    end)
end

-- 当前队伍全部阵亡
function PartnerManager:TeamAllDie()
    -- 清除buff
    -- 同步状态
    self:ClearConcludeData()
end

-- 脱战
function PartnerManager:DetachmentWar(insId, isHitEnd)
    local ecoId = BehaviorFunctions.GetEntityEcoId(insId)
    if not ecoId then return end
    -- 放到交互结束的时候清楚
    if self.concludeMap[ecoId] and not isHitEnd then return end

    self.concludeMap[ecoId] = nil
    local entity = BehaviorFunctions.GetEntity(insId)
    if not entity then return end
    entity:RemoveConcludeBuffState()

    local inFight = BehaviorFunctions.CheckPlayerInFight()
    if not inFight then
        self:ClearConcludeData()
    end
end

function PartnerManager:ClearConcludeData(fixedEcoId)
    -- TODO 暂时屏蔽
    do
        return
    end

    if fixedEcoId then
        mod.RoleFacade:SendMsg("partner_conclude_reset", fixedEcoId)
        return
    end
    for ecoId, v in pairs(self.concludeMap) do
        mod.RoleFacade:SendMsg("partner_conclude_reset", ecoId)
    end
    self.concludeMap = {}
end

function PartnerManager:ShowCatchDeathEffect(entity, isSuc)
    local deathReason = entity.stateComponent:GetDeathReason()
    if deathReason ~= FightEnum.DeathReason.CatchDeath then
        return
    end

    local catchDeath = entity.stateComponent.stateFSM:GetCatchDeathState()
    catchDeath:CatchEffect(isSuc)
end

-- 交互完成,获取月灵
function PartnerManager:PartnerConcludeHitEnd(data, entity)
	if not data then return end
    local dropId = data.partner_id
    local newGoldenTime = data.golden_conclude_time
    if not dropId or dropId == 0 then
        -- 缔结失败
        self:ShowCatchDeathEffect(entity, false)
        return
    end

    mod.RoleCtrl:UpdatePartnerConcludeInfo(newGoldenTime)
    local partnerCfg = PartnerConfig.GetPartnerConfig(dropId)
    if not partnerCfg then return end

    local isNew = mod.BagCtrl:CheckPartnerIsFirstShow(dropId)
    data.isNew = isNew

    table.insert(self.showTipQueueMap, data)
    -- 缔结成功
    self:ShowCatchDeathEffect(entity, true)
end

function PartnerManager:CheckShowTipQueue()
    if #self.showTipQueueMap == 0 then
        mod.BagCtrl:CheckPartnerShowPanel()
        return
    end
    for _, data in pairs(self.showTipQueueMap) do
        -- 添加队列
        BehaviorFunctions.fight.noticeManger:AddConcludePartnerPanel(data.partner_id, data.isNew)
    end
    -- 展示月灵的界面
    mod.BagCtrl:CheckPartnerShowPanel()
    self.showTipQueueMap = {}
end
