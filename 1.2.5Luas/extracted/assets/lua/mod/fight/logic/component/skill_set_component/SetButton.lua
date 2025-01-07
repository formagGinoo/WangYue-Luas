SetButton = BaseClass("SetButton",PoolBaseClass)

--保存每个按钮信息,相应的逻辑

function SetButton:__init()
    
end

function SetButton:__cache()
    
end

function SetButton:OnCache()
    TableUtils.ClearTable(self.skill)
    self.disableButton = nil
    self:RemoveEvent()
    self.fight.objectPool:Cache(SetButton,self)
end

function SetButton:Init(fight, entity, config, skillId)
    self.fight = fight
    self.entity = entity
    self.skillId = skillId
    self.relevanceEntity = {}
    self:ChangeTemplate(config)
    self:BindEvent()
end

function SetButton:ChangeTemplate(config)
    self.config = config
    self:AnalyseConfig()
    self:SetSkill()
end

function SetButton:BindEvent()
    EventMgr.Instance:AddListener(EventName.DodgeValueChange,self:ToFunc("ChangeSkillCdByDodge"))
    EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
    EventMgr.Instance:AddListener(EventName.SkillPointChangeAfter, self:ToFunc("SkillPointChangeAfter"))
end

function SetButton:RemoveEvent()
    EventMgr.Instance:RemoveListener(EventName.DodgeValueChange,self:ToFunc("ChangeSkillCdByDodge"))
    EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
    EventMgr.Instance:RemoveListener(EventName.SkillPointChangeAfter, self:ToFunc("SkillPointChangeAfter"))
end

--分析配置
function SetButton:AnalyseConfig()
    local config = self.config
    local layerConfig = config.LayerConfig or 0
    local behaviorConfig = config.BehaviorConfig or 0
    config.ShowCD = layerConfig >> 0 & 1 == 1
    config.SkillCDMask = layerConfig >> 1 & 1 == 1
    config.PowerMask = layerConfig >> 2 & 1 == 1
    config.RoundPowerMask = layerConfig >> 3 & 1 == 1
    config.Charge = layerConfig >> 4 & 1 == 1
    config.ReadyEffect = layerConfig >> 5 & 1 == 1
    config.IsLoop = layerConfig >> 6 & 1 == 1
    config.CastEffect = layerConfig >> 7 & 1 == 1
    config.DodgeEffect = layerConfig >> 8 & 1 == 1
    config.PowerCircle = layerConfig >> 9 & 1 == 1
    config.PowerPoint = layerConfig >> 10 & 1 == 1

    config.SkillCdPart = behaviorConfig >> 0 & 1 == 1
    config.SkillCostPart = behaviorConfig >> 1 & 1 == 1
    config.SkillCdChargePart = behaviorConfig >> 2 & 1 == 1
    config.SkillCostChargePart = behaviorConfig >> 3 & 1 == 1
    config.SkillIconPart = behaviorConfig >> 4 & 1 == 1
    config.SkillEffectPart = behaviorConfig >> 5 & 1 == 1
    config.DodgeCdPart = behaviorConfig >> 6 & 1 == 1
    --默认配置一定是合理的
    --self:ConfigCheck()
end

--配置合理性检测
function SetButton:ConfigCheck()
    local config = self.config
    if not (config.SkillCdPart or config.DodgeCdPart) then
        if not config.DodgeCdPart then
            config.DodgeEffect = false
        end
        config.ShowCD = false
        config.SkillCDMask = false
    end
    if not config.SkillCostPart then
        config.PowerMask = false
        config.RoundPowerMask = false
    end
    if not (config.SkillCdChargePart or config.SkillCostChargePart) then
        config.Charge = false
    end
    if not config.SkillEffectPart then
        config.ReadyEffect = false
        config.IsLoop = false
        config.CastEffect = false
    end
end

--设置技能对象基本属性
function SetButton:SetSkill()
    local config = self:GetConfig()
    local skill = self.skill or {}

    if config and config.SkillCdPart and not config.IgnoreSkillCD then
        skill.maxCDtime = config.CDtime * 10000
        skill.curCDtime = skill.curCDtime or 0
    elseif config and config.DodgeCdPart then
        local dodgeComponent = self.entity.dodgeComponent
        skill.curCDtime = dodgeComponent.limNowCoolingTime
        skill.maxCDtime = dodgeComponent.limMaxCoolingTime
    end

    if config and config.SkillCdChargePart then
        --skill.curChargeTimes = skill.curChargeTimes or 0
        if config.ChargeMode == SetButtonEnum.ChargeMode.AloneCD then
            skill.curChargeCd = skill.curChargeCd or config.ChargeCdTime * 10000
            skill.maxChargeCd = config.ChargeCdTime * 10000
            if skill.curChargeCd > skill.maxChargeCd then
                skill.curChargeCd = skill.maxChargeCd
            end
        end
        if config.RecoverType == SetButtonEnum.AssetType.ChargePoint then
            skill.curChargeTimes = skill.curChargeTimes or 0
            if skill.curChargeTimes > config.ChargeTimes then
                self:ChangeChargePoint(config.ChargeTimes - skill.curChargeTimes)
            end
        end
        skill.maxChargeTimes = config.ChargeTimes
    end

    self.skill = skill
end

function SetButton:Update()
    local skill = self.skill
    local config = self.config
    if not skill or not config then
        return
    end

    local isChanged = false
    if config.SkillCdPart then
        isChanged = isChanged or self:SkillCdPart(skill, config)
    end

    if config.SkillCdChargePart then
        isChanged = isChanged or self:SkillCdChargePart(skill, config)
    end

    if isChanged then
        self:UpdateBtnShow()
    end

end

--#region 技能状态变化

function SetButton:SkillCdPart(skill, config)
    if not config.IgnoreSkillCD and config.AutoReduceSkillCD and skill.curCDtime > 0 then
        local deltaTime = FightUtil.deltaTime
        skill.curCDtime = skill.curCDtime - deltaTime
        if skill.curCDtime <= 0 then
            --技能冷却完成
            self:CDReadyFinsh()
        end
        return true
    end
end

function SetButton:SkillCdChargePart(skill, config)
    if config.ChargeMode == SetButtonEnum.ChargeMode.AloneCD and config.AutoReduceChargeCD then --独立计算cd
        local curChargeTimes, maxChargeTimes = self:GetChargePoint()
        if skill.curChargeCd < 0 then
            if curChargeTimes < maxChargeTimes or config.AlwaysReduceChargeCD then
                skill.curChargeCd = skill.maxChargeCd
            end
        end
        if skill.curChargeCd >= 0 then
            local deltaTime = FightUtil.deltaTime
            skill.curChargeCd = skill.curChargeCd - deltaTime
            if skill.curChargeCd <= 0 then
                self:ChangeChargePoint()
            end
            return true
        end
    end
end

function SetButton:EntityAttrChange(costType, entity, oldValue, curValue)
    if entity.instanceId == self.entity.instanceId then
        --如果改变的是充能资源
        local needUpdate = false
        local config = self.config
        if config.SkillCdChargePart and config.RecoverType == SetButtonEnum.AssetType.EntityCost and config.RecoverCostType == costType then
            self:ChargeChanged(oldValue, curValue, costType)
            needUpdate = true
        end
        if config.SkillCostPart then
            if config.UseCostMode == SetButtonEnum.UseCostMode.EntityCost then
                if config.UseCostType == costType then
                    needUpdate = true
                end
            elseif config.UseCostMode == SetButtonEnum.UseCostMode.ChargePoint then
                if costType == self:GetChargePointCostType() then
                    needUpdate = true
                end
            end
        end
        if needUpdate then
            self:UpdateBtnShow()
        end
    end
end

function SetButton:SkillPointChangeAfter(instanceId, type, oldValue, newValue)
    if instanceId == self.entity.instanceId then
        local config = self.config
        if config.SkillCostPart then
            if config.UseCostMode == SetButtonEnum.UseCostMode.SkillPoint then
                self:UpdateBtnShow()
            end
        end
    end
end

--#endregion

--#region 充能点相关

function SetButton:ChangeChargePoint(addValue)
    local config = self.config
    if config.SkillCdChargePart then
        local curValue, maxValue = self:GetChargePoint()
        addValue = math.min(addValue or config.RecoverCount)
		--Log(self.skillId .. "增加充能点"..addValue)
        self:SetChargePoint(curValue + addValue)
    end
end

function SetButton:SetChargePoint(value)
    local config = self.config
    if config.SkillCdChargePart then
        local curValue, maxValue = self:GetChargePoint()
        self.targetChargeValue = value
        local keyEvent = self.entity.skillSetComponent:GetKeyEventBySkillId(self.skillId)
        local attrType = self:GetChargePointCostType()
        self:RecordCommond(true)
        BehaviorFunctions.fight.entityManager:CallBehaviorFun("ChargeBeforeChange", self.entity.instanceId, curValue, value - curValue, keyEvent, attrType)
        --BehaviorFunctions.CancelChargeChange(self.entity.instanceId, self.entity.skillSetComponent:GetKeyEventBySkillId(self.skillId))
        self:ApplyChargeChange()
    end
end

function SetButton:RecordCommond(value)
    self.isApplyChargeChange = value
end

function SetButton:GetRecordCommond()
    return self.isApplyChargeChange
end

function SetButton:ApplyChargeChange()
    if not self:GetRecordCommond() then
        self:RecordCommond(true)
        return
    end
    local config = self.config
    local value = self.targetChargeValue
    if config.SkillCdChargePart and value then
        local oldValue, maxValue = self:GetChargePoint()
        value = math.min(value, maxValue)
        value = math.max(value, 0)
        if config.RecoverType == SetButtonEnum.AssetType.ChargePoint then
            self:GetSkill().curChargeTimes = value
            self:ChargeChanged(oldValue, value)
        elseif config.RecoverType == SetButtonEnum.AssetType.EntityCost then
            self.entity.attrComponent:SetValue(config.RecoverCostType, value)
        end
        self:UpdateBtnShow()
    end
    self.targetChargeValue = nil
end

function SetButton:ChargeChanged(oldValue, curValue, attrType)
    --Log(oldValue,curValue)
    if not oldValue or not curValue then
        return
    end
    local addValue = curValue - oldValue
    local keyEvent = self.entity.skillSetComponent:GetKeyEventBySkillId(self.skillId)
    if addValue ~= 0  and keyEvent then
        BehaviorFunctions.fight.entityManager:CallBehaviorFun("ChargeChanged", self.entity.instanceId, oldValue, curValue, addValue, keyEvent, attrType)
    end
    
end

--#endregion

--可以是实体资源，充能点, 复合资源（五行能量)
function SetButton:GetCostValue()
    local config = self.config
    if config.SkillCostPart then
        if config.UseCostMode == SetButtonEnum.UseCostMode.EntityCost then
            local curValue = self.entity.attrComponent:GetValue(config.UseCostType)
            return curValue, config.UseCostValue, config.MaxUseCostValue, config.UseCostType
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.ChargePoint then
            local curValue = self:GetChargePoint()
            return curValue, config.UseCostValue, config.MaxUseCostValue, self:GetChargePointCostType()
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.SkillPoint then
            local allPoint, ex, normal = self:GetSkillPointCost()
            return allPoint, config.UseCostValue, config.MaxUseCostValue, SetButtonEnum.UseCostMode.SkillPoint
        end
    end
end

function SetButton:GetSkillCostType()
    local config = self.config
    if config.SkillCostPart then
        if config.UseCostMode == SetButtonEnum.UseCostMode.EntityCost then
            return config.UseCostType
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.ChargePoint then
            return self:GetChargePointCostType()
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.SkillPoint then
            return FightEnum.RoleSkillPoint.Ex, FightEnum.RoleSkillPoint.Normal
        end
    end
end

--可以是虚构的充能点，也可以是绑定的实体资源
function SetButton:GetChargePoint()
    local config = self.config
    local maxChargeTimes = self.skill.maxChargeTimes
    if config.SkillCdChargePart then
        if config.RecoverType == SetButtonEnum.AssetType.ChargePoint then
            return self.skill.curChargeTimes or 0, maxChargeTimes or 0
        elseif config.RecoverType == SetButtonEnum.AssetType.EntityCost then
            local curValue, maxValue = self.entity.attrComponent:GetValueAndMaxValue(config.RecoverCostType)
            maxValue = math.min(maxValue, maxChargeTimes)
            return curValue, maxValue
        end
    end
end

function SetButton:GetChargePointCostType()
    local config = self.config
    if config.SkillCdChargePart and config.RecoverType == SetButtonEnum.AssetType.EntityCost then
        return config.RecoverCostType or 0
    end
end

function SetButton:GetShowCD()
    local config = self.config
    local skill = self.skill
    if config.SkillCdPart and not config.IgnoreSkillCD then
        return skill.curCDtime or 0, skill.maxCDtime or 0
    end

    if config.DodgeCdPart then
        return skill.curCDtime or 0, skill.maxCDtime or 0
    end

    if config.SkillCdChargePart and config.ChargeMode == SetButtonEnum.ChargeMode.AloneCD then
        return skill.curChargeCd or 0, skill.maxChargeCd
    end
end

function SetButton:ChangeSkillCdByDodge()
    if not self.config.DodgeCdPart then
        return
    end
    local dodgeComponent = self.entity.dodgeComponent
    local skill = self.skill
    if dodgeComponent then
        skill.curCDtime = dodgeComponent.limNowCoolingTime
        skill.maxCDtime = dodgeComponent.limMaxCoolingTime
        if skill.curCDtime <= 0 then
            self:CDReadyFinsh()
        end
        self:UpdateBtnShow()
    end
end

function SetButton:ChangeConfig(key, value)
    self.config[key] = value
    self:ConfigCheck()
    if FightEnum.SkillBehaviorConfig[key] then
        self:SetSkill()
    end
end

function SetButton:SetSkillBaseInfo(useCostType, useCostValue, maxChargeTimes, maxCDtime)
    local skill = self.skill
    local config = self.config
    if useCostType and config.UseCostType then
        config.UseCostType = useCostType
    end
    if useCostValue and config.UseCostValue then
        config.UseCostValue = useCostValue
    end
    if maxChargeTimes and skill.maxChargeTimes then
        skill.maxChargeTimes = maxChargeTimes
    end
    if maxCDtime and skill.maxCDtime then
        skill.maxCDtime = maxCDtime
    end
end

function SetButton:DisableButton(disable)
    if self.disableButton == disable then
        return
    end
    self.disableButton = disable
    self:UpdateBtnShow()
end

--TODO showEffect 是为了能让策划调用时特定动效
function SetButton:CheckUseSkill(showEffect)
    if self.disableButton then
        return false
    end
    local skill = self.skill
    local config = self.config

    if config.SkillCdPart then
        if not config.IgnoreSkillCD and skill.curCDtime > 0 then
            return false
        end
    end

    if config.SkillCostPart then
        local keyEvent = self.entity.skillSetComponent:GetKeyEventBySkillId(self.skillId)
        local KeyEvent2Btn, btnName = FightEnum.KeyEvent2Btn, nil
        if keyEvent then
            btnName = KeyEvent2Btn[keyEvent]
        end
        if config.UseCostMode == SetButtonEnum.UseCostMode.EntityCost then
            if not self.entity.attrComponent:CheckCost(config.UseCostType, config.UseCostValue) then
                if showEffect and btnName then
                    BehaviorFunctions.StopSkillUIEffect("22066", btnName)
                    BehaviorFunctions.PlaySkillUIEffect("22066", btnName, false)
                end
                return false
            end
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.ChargePoint then
            if self:GetChargePoint() < config.UseCostValue then
                if showEffect and btnName then
                    BehaviorFunctions.StopSkillUIEffect("22066", btnName)
                    BehaviorFunctions.PlaySkillUIEffect("22066", btnName, false)
                end
                return false
            end
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.SkillPoint then
            if self:GetSkillPointCost() < config.UseCostValue then
                if showEffect then
                    if btnName then
                        BehaviorFunctions.StopSkillUIEffect("22066", btnName)
                        BehaviorFunctions.PlaySkillUIEffect("22066", btnName, false)
                    end
                    BehaviorFunctions.StopFightUIEffect("22067", "PowerGroupBG")
                    BehaviorFunctions.PlayFightUIEffect("22067", "PowerGroupBG")
                end
                return false
            end
        end
    end
    
    return true
end

--判断是否能使用极限闪避
function SetButton:CheckUseDodge()
    local skill = self.skill
    local config = self.config
    if config.DodgeCdPart then
        if skill.curCDtime <= 0 then
            return true
        end
    end
    return false
end

function SetButton:SetBtnSkillCDTime(cdTime)
    local skill = self.skill
    local config = self.config
    if config.SkillCdPart and not config.IgnoreSkillCD then
        if cdTime == -1 then
            skill.curCDtime = skill.maxCDtime
        else
            skill.curCDtime = cdTime
        end
        if skill.curCDtime <= 0 then
            self:CDReadyFinsh()
        else
            self:EnterCooling()
        end
        self:UpdateBtnShow()
    end
end

function SetButton:ChangeBtnSkillCDTime(cdTime)
    local config = self.config
    local skill = self.skill

    if config.SkillCdPart and not config.IgnoreSkillCD and skill.curCDtime > 0 then
        cdTime = cdTime * 10000
        skill.curCDtime = skill.curCDtime + cdTime
        if skill.curCDtime < 0 then
            skill.curCDtime = 0
        end
        if skill.curCDtime <= 0 then
            self:CDReadyFinsh()
        else
            self:EnterCooling()
        end
        self:UpdateBtnShow()
    end
end

function SetButton:ChangeChargeCD(cdTime)
    local config = self.config
    local skill = self.skill

    if config.SkillCdChargePart then
        local curChargePoint, maxChargePoint = self:GetChargePoint()
        if curChargePoint >= maxChargePoint and not config.AlwaysReduceChargeCD then
            return
        end
        cdTime = cdTime * 10000
        skill.curChargeCd = skill.curChargeCd + cdTime
        if skill.curChargeCd <= 0 then
            local overflow = 0 - skill.curChargeCd
            self:ChangeChargePoint()
            curChargePoint, maxChargePoint = self:GetChargePoint()
            if curChargePoint == maxChargePoint and not config.AlwaysReduceChargeCD then
                skill.curChargeCd = 0
            else
                skill.curChargeCd = skill.maxChargeCd
                if config.UseOverflow then
                    skill.curChargeCd = skill.curChargeCd - overflow
                end
            end
        end
        self:UpdateBtnShow()
    end
end

function SetButton:SetChargeCD(cdTime)
    local config = self.config
    local skill = self.skill
    if config.SkillCdChargePart then
        local curChargePoint, maxChargePoint = self:GetChargePoint()
        if curChargePoint >= maxChargePoint then
            return
        end
        cdTime = cdTime * 10000
        cdTime = math.min(cdTime,skill.maxChargeTimes)
        skill.curChargeCd = cdTime
        if skill.curChargeCd <= 0 then
            self:ChangeChargePoint()
            curChargePoint, maxChargePoint = self:GetChargePoint()
            if curChargePoint == maxChargePoint then
                skill.curChargeCd = 0
            else
                skill.curChargeCd = skill.maxChargeCd
            end
        end
        self:UpdateBtnShow()
    end
end

function SetButton:CastSkillCost()
    local config = self.config
    local skill = self.skill
    if config.SkillCostPart then
        if config.UseCostMode == SetButtonEnum.UseCostMode.EntityCost then
            local curAttrValue = self.entity.attrComponent:GetValue(config.UseCostType)
            curAttrValue = math.min(curAttrValue or 0, config.MaxUseCostValue or 0)
            self.entity.attrComponent:AddValue(config.UseCostType, - curAttrValue)
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.ChargePoint then
            self:ChangeChargePoint(- config.MaxUseCostValue or 0)
        elseif config.UseCostMode == SetButtonEnum.UseCostMode.SkillPoint then
            local allPoint, exPoint, normalPoint, exPointValue, normalPointValue = self:GetSkillPointCost()
            local needNormalPoint = config.MaxUseCostValue - exPoint
            local exValue = exPoint * exPointValue
            local needNormalValue = needNormalPoint * normalPointValue
            if needNormalPoint > 0 then
			    BehaviorFunctions.fight.entityManager:CallBehaviorFun("CastSkillCostBefore", self.entity.instanceId, self.skillId, exPoint, needNormalPoint, exPoint, normalPoint, exPoint + needNormalPoint)
                self.entity.attrComponent:AddValue(FightEnum.RoleSkillPoint.Ex, - exValue)
                self.entity.attrComponent:AddValue(FightEnum.RoleSkillPoint.Normal, - needNormalValue)
            else
                BehaviorFunctions.fight.entityManager:CallBehaviorFun("CastSkillCostBefore", self.entity.instanceId, self.skillId, config.MaxUseCostValue, 0, exPoint, normalPoint, config.MaxUseCostValue)
                self.entity.attrComponent:AddValue(FightEnum.RoleSkillPoint.Ex, - config.MaxUseCostValue * exPointValue)
            end
            local all, ex, normal = self:GetSkillPointCost()
            BehaviorFunctions.fight.entityManager:CallBehaviorFun("CastSkillCostAfter", self.entity.instanceId, self.skillId, exPoint - ex, normalPoint - normal, ex, normal, allPoint)
        end
    end
    if config.SkillCdPart and not config.IgnoreSkillCD then
        skill.curCDtime = skill.maxCDtime
        if skill.curCDtime > 0 then
            self:EnterCooling()
        end
    end
    if config.SkillCdChargePart then
        if config.ChargeMode == SetButtonEnum.ChargeMode.AloneCD and not config.AutoReduceChargeCD then
            if skill.curChargeCd <= 0 then
                skill.curChargeCd = skill.maxChargeCd
            end
        end
    end

    self.entity.skillSetComponent:CastCostComplete(self.skillId, self.entity.instanceId)
    for key, instanceId in pairs(self.relevanceEntity) do
        local entity = BehaviorFunctions.GetEntity(instanceId)
        if entity and entity.skillSetComponent then
            entity.skillSetComponent:CastCostComplete(self.skillId, self.entity.instanceId)
        end
    end

    EventMgr.Instance:Fire(EventName.CastSkillCost, self.skillId, self.entity.instanceId)

    self:UpdateBtnShow()
end

function SetButton:CDReadyFinsh()
    self.isCooling = false
    local config = self.config
    if config.SkillCostPart and config.CoolingNotGetCost then
        if config.UseCostMode == SetButtonEnum.UseCostMode.EntityCost then
            local costType = config.UseCostType
            self.entity.attrComponent:LockAttr(costType, false)
        end
    end
end

function SetButton:EnterCooling()
    self.isCooling = true
    local config = self.config
    if config.SkillCostPart and config.CoolingNotGetCost then
        if config.UseCostMode == SetButtonEnum.UseCostMode.EntityCost then
            local costType = config.UseCostType
            self.entity.attrComponent:LockAttr(costType, true)
        end
    end
end

function SetButton:GetSkillPointCost()
    return self.entity.skillSetComponent:GetSkillPointCost()
end

function SetButton:GetSkill()
    return self.skill
end

function SetButton:GetConfig()
    return self.config
end

function SetButton:SetRelevanceEntity(instanceId, isAdd)
    if isAdd then
        self.relevanceEntity[instanceId] = instanceId
    else
        self.relevanceEntity[instanceId] = nil
    end
end

function SetButton:UpdateBtnShow()
    self.entity.skillSetComponent:UpdateBtnShow(self.skillId, self.entity.instanceId)
    for key, instanceId in pairs(self.relevanceEntity) do
        local entity = BehaviorFunctions.GetEntity(instanceId)
        if entity and entity.skillSetComponent then
            entity.skillSetComponent:UpdateBtnShow(self.skillId, self.entity.instanceId)
        end
    end
end