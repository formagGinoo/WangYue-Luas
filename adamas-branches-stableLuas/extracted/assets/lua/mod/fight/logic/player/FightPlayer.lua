FightPlayer = BaseClass("FightPlayer")

local DataPlayerAttrsDefine = Config.DataPlayerAttrsDefine.Find
local PlayerAttrToAttrPercent = FightEnum.PlayerAttrToAttrPercent
local PlayerAttrPercentToAttr = FightEnum.PlayerAttrPercentToAttr
local PlayerAttrToMaxType = FightEnum.PlayerAttrToMaxType
local DataAttrsDefine = Config.DataAttrsDefine.Find
local PlayerAttrType = FightEnum.PlayerAttr
local PlayerAttrPropertyValue = FightEnum.PlayerAttrPropertyValue
local PlayerSyncAttr = FightEnum.PlayerSyncAttr
local AttrValueType = FightEnum.AttrValueType
local _tinsert = table.insert

function FightPlayer:__init()
end

---@param player Player
function FightPlayer:Init(player)
    self.player = player
    self.fight = player.fight

    self.fightTargets = {}

    --极限闪避时间
    self.dodgeLimit = {
        startTime = 0,
        endTime = 0,
    }

    self.lastCostElectricityFrame = 0
    self.lastCostRamFrame = 0

    self.isStaminaOverdrawn = false
    self.staminaOverdrawnFrame = 0
    self.staminaRecoverDelay = 0

    self.updatePlayerInfoTime = 0

    self.buffIds = {}
    self.buffIdsByEntity = {}
end

function FightPlayer:InitTalent()
    self:InitPlayerAttr()
    self:ActivePlayerTalent()
    EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
    EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("onTalentUpdate"))
    EventMgr.Instance:AddListener(EventName.PlayerPropertyChange, self:ToFunc("onPlayerPropertyChange"))
end

function FightPlayer:onPlayerPropertyChange()
    for k, v in pairs(PlayerAttrPropertyValue) do
        if not PlayerSyncAttr[k] then
            self.baseAttrs[k] = 0
            local attrDefine = DataPlayerAttrsDefine[k]
            if attrDefine then
                self.baseAttrs[k] = attrDefine.value
            end
            if attrDefine and attrDefine.value_type == AttrValueType.Percent then
                self.baseAttrs[k] = attrDefine.value * 0.0001
            end
            self.baseAttrs[k] = self.baseAttrs[k] + mod.LoginCtrl:GetPlayerPropertyValueById(v)
            self.attrs[k] = self.baseAttrs[k]
        end
    end
end

function FightPlayer:InitPlayerAttr()
    self.baseAttrs = {}
    -- 结果值不能直接修改
    self.attrs = {}

    for k, v in pairs(PlayerAttrType) do
        self.baseAttrs[v] = 0
    end
    for k, v in pairs(DataPlayerAttrsDefine) do
        if v.value_type == AttrValueType.Percent then
            self.baseAttrs[k] = v.value * 0.0001
        else
            self.baseAttrs[k] = v.value
        end
    end

    for k, attrType in pairs(PlayerAttrType) do
        self.attrs[attrType] = self:CalcFinalTotalAttrValue(attrType)
    end

    -- 设置默认当前值
    self:SetAttrValue(PlayerAttrType.CurStaminaValue, self:GetAttrValue(PlayerAttrType.MaxStamina))
    self:SetAttrValue(PlayerAttrType.CurElectricityValue, self:GetAttrValue(PlayerAttrType.MaxElectricity))
    self:SetAttrValue(PlayerAttrType.CurRamValue, self:GetAttrValue(PlayerAttrType.MaxRam))
 
    for k, v in pairs(PlayerAttrPropertyValue) do
        if PlayerSyncAttr[k] then
            self:SetAttrValue(k, mod.LoginCtrl:GetPlayerPropertyValueById(v))
        else
            self:SetAttrValue(k, self.baseAttrs[k] + mod.LoginCtrl:GetPlayerPropertyValueById(v))
        end
    end

    mod.LoginCtrl:SetIsLogin(true)
end

function FightPlayer:IsFightTarget(instanceId)
    return self.fightTargets[instanceId]
end

function FightPlayer:AddFightTarget(instanceId)
    if not BehaviorFunctions.CheckEntity(instanceId) then
        return
    end

    for k, v in pairs(self.fightTargets) do
        if k == instanceId then
            return
        end
    end

    self.fightTargets[instanceId] = -1

    if ctx then
        local entity = Fight.Instance.entityManager:GetEntity(instanceId)
        local setting = { hideOnSee = true }
        local fightGuidePointerManager = Fight.Instance.clientFight.fightGuidePointerManager
        local FightTarget = FightEnum.GuideType.FightTarget
        local guideIndex = fightGuidePointerManager:AddGuideEntity(entity, setting, FightTarget)
        self.fightTargets[instanceId] = guideIndex
    end

    Fight.Instance.mercenaryHuntManager:PlayerAddTarget(instanceId)

    Fight.Instance.entityManager:CallBehaviorFun("OnEnemyFirstInFight", instanceId)
    BgmManager.Instance:SetBgmState("GamePlayType", "Combat")
    Fight.Instance.entityManager:FireTriggerEntityInteract()
end

function FightPlayer:RemoveFightTarget(instanceId)
    if ctx and self.fightTargets[instanceId] ~= -1 then
        Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.fightTargets[instanceId])
    end

    self.fightTargets[instanceId] = nil
    Fight.Instance.mercenaryHuntManager:PlayerRemoveTarget(instanceId)

    -- 通知月灵管理器
    Fight.Instance.partnerManager:DetachmentWar(instanceId)

    if not next(self.fightTargets) then
        BgmManager.Instance:SetBgmState("GamePlayType", "Explore")
        Fight.Instance.entityManager:FireTriggerEntityInteract()
    end
end

--脱战接口
function FightPlayer:RemoveAllFightTarget()
	local entityManager = self.fight.entityManager
	for k, v in pairs(self.fightTargets) do
		self:RemoveFightTarget(k)
		entityManager:CallBehaviorFun("LeaveFighting", k)
	end
end

function FightPlayer:InFight()
    return self.fightTargets and next(self.fightTargets) ~= nil
end

function FightPlayer:GetFightTarget()
    if not self:InFight() then return end
    for k, v in pairs(self.fightTargets) do
		return k
	end
end

function FightPlayer:GetAllFightTarget()
    if not self:InFight() then return end
    local map = {}
    for k, v in pairs(self.fightTargets) do
		_tinsert(map, k)
	end
    return map
end

function FightPlayer:Update()
    for k, v in pairs(self.fightTargets) do
        if not BehaviorFunctions.CheckEntity(k) then
            self:RemoveFightTarget(k)
        end
    end

    --距离上一次消耗电量过去0.5s，开始恢复
    if self.fight.fightFrame - self.lastCostElectricityFrame > 15 then
        self:AddAttrValue(PlayerAttrType.CurElectricityValue, self:GetAttrValue(PlayerAttrType.ElectricityRecoveryRate))
    end

    if self.fight.fightFrame - self.lastCostRamFrame > self:GetAttrValue(PlayerAttrType.RamResponseTimeUnit) then
        self:AddAttrValue(PlayerAttrType.CurRamValue, self:GetAttrValue(PlayerAttrType.RamResponseUnit))
        self.lastCostRamFrame = self.fight.fightFrame
    end
    self.updatePlayerInfoTime = self.updatePlayerInfoTime + 1
    if self.updatePlayerInfoTime < 150 then return end
    self.updatePlayerInfoTime  = 0
	-- 同步玩家属性
    mod.LoginCtrl:SetPlayerSyncPropery()
end

function FightPlayer:AfterUpdate()
    if self.isStaminaOverdrawn then
        self.staminaOverdrawnFrame = self.staminaOverdrawnFrame + 1
        if self.staminaOverdrawnFrame >= 90 then
            self.isStaminaOverdrawn = false
            self.staminaOverdrawnFrame = 0
        end
    end

    if self.staminaRecoverDelay > 0 then
        self.staminaRecoverDelay = self.staminaRecoverDelay - 1
    end
end

function FightPlayer:SetDodgeLimitTime(time)
    self.dodgeLimit.startTime = self.fight.fightFrame
    self.dodgeLimit.endTime = self.fight.fightFrame + time * FightUtil.logicTargetFrameRate
end

function FightPlayer:InDodgeLimit()
    return self.fight.fightFrame >= self.dodgeLimit.startTime and
            self.fight.fightFrame <= self.dodgeLimit.endTime
end

function FightPlayer:SetAttrValue(attrType, value)
    if DataPlayerAttrsDefine[attrType] and DataPlayerAttrsDefine[attrType].value_type == AttrValueType.Percent then
        value = value * 0.0001
    end

    local maxType = PlayerAttrToMaxType[attrType]
    if maxType then
        self.baseAttrs[attrType] = math.min(value, self.attrs[maxType])
    else
        self.baseAttrs[attrType] = value
    end

    self:OnChangeAttrValue(attrType)
end

function FightPlayer:AddAttrValue(attrType, value)
    if DataPlayerAttrsDefine[attrType] and DataPlayerAttrsDefine[attrType].value_type == AttrValueType.Percent then
        value = value * 0.0001
    end
    value = value or 0 -- 临时

    --体力值特殊逻辑,允许透支，但会进入恢复惩罚期
    if attrType == PlayerAttrType.CurStaminaValue then
        if value < 0 then
            self.staminaRecoverDelay = 30
            if self.attrs[attrType] > 0 and -value >= self.attrs[attrType] then
                value = -self.attrs[attrType]
                --设置体力透支惩罚状态
                self.isStaminaOverdrawn = true
                self.fight.entityManager:CallBehaviorFun("OnStaminaOverdrawn")
            end
        else
            value = value * (1 + self.attrs[PlayerAttrType.StaminaRecoverPercent])
        end
    end

    local setValue = 0
    local maxType = PlayerAttrToMaxType[attrType]
    if maxType then
        setValue = MathX.Clamp(self.baseAttrs[attrType] + value, 0, self.attrs[maxType])
    else
        setValue = self.baseAttrs[attrType] + value
    end

    if self.baseAttrs[attrType] == setValue then
        return
    end
    self.baseAttrs[attrType] = setValue

    if attrType == PlayerAttrType.CurElectricityValue and value < 0 then
        self.lastCostElectricityFrame = self.fight.fightFrame
    end

    if attrType == PlayerAttrType.CurRamValue and value < 0 then
        self.lastCostRamFrame = self.fight.fightFrame
    end

    self:OnChangeAttrValue(attrType)
end

function FightPlayer:GetAttrValue(attrType)
    return self.attrs[attrType]
end

function FightPlayer:GetBaseAttrValue(attrType)
    return self.baseAttrs[attrType]
end

function FightPlayer:GetMaxValue(attrType)
    local maxValue = 0
    local maxType = PlayerAttrToMaxType[attrType]
    if maxType then
        maxValue = self.attrs[maxType]
    end
    return maxValue
end

function FightPlayer:GetValueAndMaxValue(attrType)
    local maxValue = 0
    local maxType = PlayerAttrToMaxType[attrType]
    if maxType then
        maxValue = self.attrs[maxType]
    end
    if not self.attrs[attrType] then
        LogError(string.format("玩家不存在属性[%s],但是在尝试获取它", attrType))
    end
    return self.attrs[attrType], maxValue
end

function FightPlayer:GetAttrValueRatio(attrType)
    if attrType > 1000 then
        return self.attrs[attrType] / self.attrs[attrType - 1000]
    end
    return 0
end

function FightPlayer:CheckCost(attrType, costValue)
    return self.attrs[attrType] and self.attrs[attrType] >= costValue
end

function FightPlayer:OnChangeAttrValue(attrType)
    local baseValue = self.baseAttrs[attrType]
    if not baseValue then
        return
    end

    local oldValue = self.attrs[attrType]
    local resultValue = self:CalcFinalTotalAttrValue(attrType)
    self.attrs[attrType] = resultValue

    EventMgr.Instance:Fire(EventName.PlayerAttrChange, attrType, resultValue, oldValue)
    if DataAttrsDefine[attrType] then
        ---更新当前所有角色的属性组件
        for _, entity in pairs(self.player:GetEntityList()) do
            if entity and entity.attrComponent then
                local oldValue = entity.attrComponent:GetValue(attrType)
                entity.attrComponent:OnChangeAttrValue(attrType, oldValue)
            end
        end
    end

    if PlayerAttrPercentToAttr[attrType] then
        self:OnChangeAttrValue(PlayerAttrPercentToAttr[attrType])
    end
end

function FightPlayer:CalcFinalTotalAttrValue(attrType)
    local baseValue = self.baseAttrs[attrType]

    local resultValue
    if PlayerAttrToAttrPercent[attrType] then
        baseValue = math.floor(baseValue * (1 + self.baseAttrs[PlayerAttrToAttrPercent[attrType]]))
        resultValue = baseValue
    else
        resultValue = baseValue
    end

    local maxType = PlayerAttrToMaxType[attrType]
    if maxType then
        resultValue = math.min(resultValue, self.attrs[maxType] or 0)
    end
    resultValue = EntityAttrsConfig.GetPlayAttrValue(attrType, resultValue)
    return resultValue
end


function FightPlayer:ActivePlayerTalent()
    for _, types in pairs(mod.TalentCtrl:GetAllTalent()) do
        for talent_id, info in pairs(types) do
            if info.lv and info.lv > 0 then
                self:ActiveTalent(talent_id, info.lv)
            end
        end
    end
end

function FightPlayer:onTalentUpdate(type, talent_id, level)
    ---删除旧的天赋效果
    if level > 1 then
        self:ActiveTalent(talent_id, level - 1, true)
    end
    ---应用新的天赋效果
    self:ActiveTalent(talent_id, level)
end

function FightPlayer:ActiveTalent(talent_id, level, unActive)
    local config = TalentConfig.GetUpgradeConfig(talent_id, level)
    --属性值加成
    if next(config.attr_bonus) then
        for _, v in pairs(config.attr_bonus) do
            if DataPlayerAttrsDefine[v[1]] then
                if unActive then
                    self:AddAttrValue(v[1], -v[2])
                else
                    self:AddAttrValue(v[1], v[2])
                end
            end
        end
    end
    --附加标记
    if next(config.tag) then
        for _, v in pairs(config.tag) do
            if v ~= 0 then
                if unActive then
                    BehaviorFunctions.RemoveEntitySign(1, v)
                else
                    BehaviorFunctions.AddEntitySign(1, v, -1)
                end
            end
        end
    end
    --附加magic
    if next(config.tag) then
        local entity = BehaviorFunctions.GetEntity(1)
        for _, v in pairs(config.buff) do
            if v ~= 0 then
                if unActive then
                    entity.buffComponent:RemoveBuffByBuffId(v)
                else
                    entity.buffComponent:AddBuff(entity, v, 1, nil, FightEnum.MagicConfigFormType.Level)
                end
            end
        end
    end
end

function FightPlayer:IsStaminaOverdrawn()
    return self.isStaminaOverdrawn
end

function FightPlayer:IsStaminaRecoveryDelayed()
    return self.staminaRecoverDelay > 0
end

function FightPlayer:AddBuff(instanceId, buffId, level)
    if not self.buffIds[buffId] then
        self.buffIds[buffId] = 0
    end

    local entityInstanceId = instanceId or 1
    local worldCtrl = self.fight.entityManager:GetEntity(entityInstanceId)
    if not worldCtrl then
        return
    end

    self.buffIds[buffId] = self.buffIds[buffId] + 1
    for k, v in pairs(self.player.entityInfos) do
        local entity = self.fight.entityManager:GetEntity(v.InstanceId)
        if not entity or not entity.buffComponent then
            goto continue
        end

        if not self.buffIdsByEntity[entity.instanceId] then
            self.buffIdsByEntity[entity.instanceId] = {}
        end

        if not self.buffIdsByEntity[entity.instanceId][buffId] then
            self.buffIdsByEntity[entity.instanceId][buffId] = {}
        end

        local buff = entity.buffComponent:AddBuff(worldCtrl, buffId, level)
        if buff then
            table.insert(self.buffIdsByEntity[entity.instanceId][buffId], buff.instanceId)
        end

        ::continue::
    end
end

function FightPlayer:RemoveBuff(buffId)
    if not self.buffIds or self.buffIds[buffId] <= 0 then
        return
    end

    self.buffIds[buffId] = self.buffIds[buffId] - 1
    if self.buffIds[buffId] == 0 then
        self.buffIds[buffId] = nil
    end

    for k, v in pairs(self.player.entityInfos) do
        local entity = self.fight.entityManager:GetEntity(v.InstanceId)
        if not entity or not entity.buffComponent then
            goto continue
        end

        if not self.buffIdsByEntity[entity.instanceId] then
            goto continue
        end

        if not self.buffIdsByEntity[entity.instanceId][buffId] then
            goto continue
        end

        local instance = table.remove(self.buffIdsByEntity[entity.instanceId][buffId])
        if not next(self.buffIdsByEntity[entity.instanceId][buffId]) then
            self.buffIdsByEntity[entity.instanceId][buffId] = nil
        end
        entity.buffComponent:RemoveBuffByInstacneId(instance)

        ::continue::
    end
end

function FightPlayer:UpdateEntityInfos()
    if not self.buffIds or not next(self.buffIds) then
        return
    end

    local worldCtrl = self.fight.entityManager:GetEntity(1)
    if not worldCtrl then
        return
    end

    for buffId, count in pairs(self.buffIds) do
        for k, v in pairs(self.player.entityInfos) do
            local entity = self.fight.entityManager:GetEntity(v.InstanceId)
            if not entity or not entity.buffComponent then
                goto continue
            end

            if not self.buffIdsByEntity[entity.instanceId] then
                self.buffIdsByEntity[entity.instanceId] = {}
            end

            if not self.buffIdsByEntity[entity.instanceId][buffId] then
                self.buffIdsByEntity[entity.instanceId][buffId] = {}
            end

            local curCount = #self.buffIdsByEntity[entity.instanceId][buffId]
            if curCount >= count then
                goto continue
            end

            for i = 1, count - curCount do
                local buff = entity.buffComponent:AddBuff(worldCtrl, buffId, level)
                if buff then
                    table.insert(self.buffIdsByEntity[entity.instanceId][buffId], buff.instanceId)
                end
            end

            ::continue::
        end
    end
end

function FightPlayer:OnRemoveEntity(instanceId)
    if not self.buffIdsByEntity or not self.buffIdsByEntity[instanceId] or not next(self.buffIdsByEntity[instanceId]) then
        return
    end

    TableUtils.ClearTable(self.buffIdsByEntity[instanceId])
end

function FightPlayer:__delete()
    EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnRemoveEntity"))
    EventMgr.Instance:RemoveListener(EventName.UpdateTalentData, self:ToFunc("onTalentUpdate"))
    EventMgr.Instance:RemoveListener(EventName.PlayerPropertyChange, self:ToFunc("onPlayerPropertyChange"))
end