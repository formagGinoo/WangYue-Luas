FightPlayer = BaseClass("FightPlayer")

local DataPlayerAttrsDefine = Config.DataPlayerAttrsDefine.Find
local PlayerAttrToAttrPercent = FightEnum.PlayerAttrToAttrPercent
local PlayerAttrPercentToAttr = FightEnum.PlayerAttrPercentToAttr
local PlayerAttrToMaxType = FightEnum.PlayerAttrToMaxType
local DataAttrsDefine = Config.DataAttrsDefine.Find
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
end

function FightPlayer:InitTalent()
    self:InitPlayerAttr()
    self:ActivePlayerTalent()
    EventMgr.Instance:AddListener(EventName.UpdateTalentData, self:ToFunc("onTalentUpdate"))
end

function FightPlayer:InitPlayerAttr()
    self.baseAttrs = {}
    -- 结果值不能直接修改
    self.attrs = {}
    for k, v in pairs(DataPlayerAttrsDefine) do
        self.baseAttrs[k] = v.value
    end

    for attrType, value in pairs(self.baseAttrs) do
        if DataPlayerAttrsDefine[attrType] and DataPlayerAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
            self.baseAttrs[attrType] = value * 0.0001
        end
    end

    for attrType, attrPercentType in pairs(FightEnum.PlayerAttrToAttrPercent) do
        self.attrs[attrType] = math.floor(self.baseAttrs[attrType] * (1 + self.baseAttrs[attrPercentType]))
    end
    self.baseAttrs[FightEnum.PlayerAttr.CurStaminaValue] = self.attrs[FightEnum.PlayerAttr.MaxStamina]

    for k, v in pairs(self.baseAttrs) do
        if not FightEnum.PlayerAttrToAttrPercent[k] then
            self.attrs[k] = v
        end
    end
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
        local guideIndex = Fight.Instance.clientFight.fightGuidePointerManager:AddGuideEntity(entity, setting, FightEnum.GuideType.FightTarget)
        self.fightTargets[instanceId] = guideIndex
    end

    Fight.Instance.mercenaryHuntManager:PlayerAddTarget(instanceId)

    BgmManager.Instance:SetBgmState("GamePlayType", "Combat")
end

function FightPlayer:RemoveFightTarget(instanceId)
    if ctx and self.fightTargets[instanceId] ~= -1 then
        Fight.Instance.clientFight.fightGuidePointerManager:RemoveGuide(self.fightTargets[instanceId])
    end

    self.fightTargets[instanceId] = nil
    Fight.Instance.mercenaryHuntManager:PlayerRemoveTarget(instanceId)

    if not next(self.fightTargets) then
        BgmManager.Instance:SetBgmState("GamePlayType", "Explore")
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

function FightPlayer:Update()
    for k, v in pairs(self.fightTargets) do
        if not BehaviorFunctions.CheckEntity(k) then
            self:RemoveFightTarget(k)
        end
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
    if DataPlayerAttrsDefine[attrType] and DataPlayerAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
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
    if DataPlayerAttrsDefine[attrType] and DataPlayerAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
        value = value * 0.0001
    end
    value = value or 0 -- 临时

    local setValue = 0
    if value < 0 then
        setValue = math.max(0, self.baseAttrs[attrType] + value)
    else
        local maxType = PlayerAttrToMaxType[attrType]
        if maxType then
            setValue = math.min(self.baseAttrs[attrType] + value, self.attrs[maxType])
        else
            setValue = self.baseAttrs[attrType] + value
        end
    end

    if self.baseAttrs[attrType] == setValue then
        return
    end
    self.baseAttrs[attrType] = setValue

    self:OnChangeAttrValue(attrType)
end

function FightPlayer:GetAttrValue(attrType)
    return self.attrs[attrType]
end

function FightPlayer:GetBaseAttrValue(attrType)
    return self.baseAttrs[attrType]
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

--只有角色ai会用到，但目前角色AI未使用
function FightPlayer:GetAttrValueRatio(attrType)
    if attrType > 1000 then
        return self.attrs[attrType] / (self:GetAttrValue(FightEnum.PlayerAttr.MaxStamina) * self:GetAttrValue(FightEnum.PlayerAttr.MaxStaminaPercent) / 10000)
    end
    return 0
end

function FightPlayer:OnChangeAttrValue(attrType)
    local baseValue = self.baseAttrs[attrType]
    if not baseValue then
        return
    end

    local resultValue
    if PlayerAttrToAttrPercent[attrType] then
        baseValue = math.floor(baseValue * (1 + self.baseAttrs[PlayerAttrToAttrPercent[attrType]]))
        resultValue = baseValue
    else
        resultValue = baseValue
    end

    local maxType = PlayerAttrToMaxType[attrType]
    if maxType then
        resultValue = math.min(resultValue, self.attrs[maxType])
    end
    self.attrs[attrType] = resultValue
    if PlayerAttrPercentToAttr[attrType] then
        self.attrs[attrType] = resultValue
        self.attrs[PlayerAttrPercentToAttr[attrType]] = baseValue
    else
        self.attrs[attrType] = resultValue
    end

    if PlayerAttrPercentToAttr[attrType] then
        self.attrs[attrType] = resultValue
        self.attrs[PlayerAttrPercentToAttr[attrType]] = math.floor(self.baseAttrs[PlayerAttrPercentToAttr[attrType]] * (1 + resultValue))
    else
        self.attrs[attrType] = resultValue
    end

    if DataAttrsDefine[attrType] then
        ---更新当前所有角色的属性组件
        for _, entity in pairs(self.player:GetEntityList()) do
            if entity and entity.attrComponent then
                local oldValue = entity.attrComponent:GetValue(attrType)
                entity.attrComponent:OnChangeAttrValue(attrType, oldValue)
            end
        end
    end
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