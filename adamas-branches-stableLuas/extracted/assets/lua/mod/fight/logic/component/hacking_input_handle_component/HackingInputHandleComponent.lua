---@class HackingInputHandleComponent
HackingInputHandleComponent = BaseClass("HackingInputHandleComponent", PoolBaseClass)

local HackingType2InputHandle = {
    [FightEnum.HackingType.Drone] = DroneInputHandle,
    [FightEnum.HackingType.Camera] = CameraInputHandle,
    [FightEnum.HackingType.Npc] = NpcInputHandle,
    [FightEnum.HackingType.Box] = BoxInputHandle,
    [FightEnum.HackingType.Other] = OtherInputHandle,
}

local HackingButtonType2HackingButtonBar = 
{
    [FightEnum.HackingButtonType.Click] = ClickHackingButtonBar,
    [FightEnum.HackingButtonType.Active] = ActiveHackingButtonBar,
}

function HackingInputHandleComponent:__init()
end

function HackingInputHandleComponent:Init(fight, entity)
    self.fight = fight
    self.entity = entity
    self.config = entity:GetComponentConfig(FightEnum.ComponentType.HackingInputHandle)
	
    self.upButtonBar = self.fight.objectPool:Get(HackingButtonType2HackingButtonBar[self.config.UpHackingButtonType or 0])
    self.upButtonBar:Init(fight, entity, self.config, "Up")

    self.rightButtonBar = self.fight.objectPool:Get(HackingButtonType2HackingButtonBar[self.config.RightHackingButtonType or 0])
    self.rightButtonBar:Init(fight, entity, self.config, "Right")

    self.downButtonBar = self.fight.objectPool:Get(HackingButtonType2HackingButtonBar[self.config.DownHackingButtonType or 0])
    self.downButtonBar:Init(fight, entity, self.config, "Down")

    self.leftButtonBar = self.fight.objectPool:Get(HackingButtonType2HackingButtonBar[self.config.LeftHackingButtonType or 0])
    self.leftButtonBar:Init(fight, entity, self.config, "Left")

    self.barMap = 
    {
        [HackingConfig.HackingKey.Up] = { bar = self.upButtonBar, active = true },
        [HackingConfig.HackingKey.Right] = { bar = self.rightButtonBar, active = true },
        [HackingConfig.HackingKey.Down] = { bar = self.downButtonBar, active = true },
        [HackingConfig.HackingKey.Left] = { bar = self.leftButtonBar, active = true },
    }

    self.inputHandle = self.fight.objectPool:Get(HackingType2InputHandle[self.config.HackingType])
    self.inputHandle:Init(fight, entity, self.config)
    self.inputHandle:__Init()

    self.effectType = self.config.EffectType or 0

	self.enable = true

    --是否处于激活状态
    self.isActiveState = false

    self.isActiveCostElectricityState = false

    self.activeCostElectricity = self.config.ActiveHackingCostElectricity or 0

    self.overrideButtonConfig = {}
end

function HackingInputHandleComponent:SetEnable(enable)
	if self.enable == enable then
		return 
	end
	
	self.enable = enable
	EventMgr.Instance:Fire(EventName.HackEntityEnable, self.entity.instanceId, enable)
end

function HackingInputHandleComponent:GetIsActiveState()
    return self.isActiveState
end

function HackingInputHandleComponent:SetIsActiveState(isActive)
    self.isActiveState = isActive

    self.upButtonBar:SetActiveState(self.isActiveState)
    self.rightButtonBar:SetActiveState(self.isActiveState)
    self.downButtonBar:SetActiveState(self.isActiveState)
    self.leftButtonBar:SetActiveState(self.isActiveState)
    EventMgr.Instance:Fire(EventName.HackEntityIsActiveStateUpdate, self.entity.instanceId)
end

function HackingInputHandleComponent:GetContinueCostElectricityState()
    return self.isActiveCostElectricityState
end

function HackingInputHandleComponent:SetContinueCostElectricityState(isActive)
    self.isActiveCostElectricityState = isActive
end

function HackingInputHandleComponent:SetContinueCostElectricityNum(num)
    self.activeCostElectricity = num
end


---获取骇入组件配置，包括类型和独特信息
function HackingInputHandleComponent:GetConfig()
    return self.config
end

function HackingInputHandleComponent:GetButtonConfig(hackingKey)
    if self.overrideButtonConfig[hackingKey] then
        return self.overrideButtonConfig[hackingKey]
    end
    if self.barMap[hackingKey].active then
        return self.barMap[hackingKey].bar:GetButtonConfig()
    else
        return HackingConfig.NullHackButtonConfig
    end
end

function HackingInputHandleComponent:SetOverrideButtonConfig(hackingKey, icon, Name, hackingRam, hackingDesc)
    self.overrideButtonConfig[hackingKey] = { icon = icon, Name = Name or "", hackingRam = hackingRam or 0, hackingDesc = hackingDesc or ""}

    EventMgr.Instance:Fire(EventName.HackEntityButtonInfoUpdate, self.entity.instanceId)
end

--程序用
function HackingInputHandleComponent:SetHackingButtonEnable(hackingKey, isEnable)
    self.barMap[hackingKey].bar:SetEnable(isEnable)
    EventMgr.Instance:Fire(EventName.HackEntityHackButtonEnableUpdate, self.entity.instanceId)
end

function HackingInputHandleComponent:SetHackingButtonActive(hackingKey, isActive)
    self.barMap[hackingKey].active = isActive
    EventMgr.Instance:Fire(EventName.HackEntityIsActiveStateUpdate, self.entity.instanceId)
end

function HackingInputHandleComponent:GetHackingButtonIsActive(hackingKey)
    return self.barMap[hackingKey].active
end

function HackingInputHandleComponent:HasUseButton()
    return self.config.UseSelfIcon
end

function HackingInputHandleComponent:Update()
    if self.isActiveCostElectricityState then
        if not self:CostElectricity(self.activeCostElectricity) then
            --电量不足
            self.fight.entityManager:CallBehaviorFun("LowHackingElectricity", self.entity.instanceId)
        end
    end
end

function HackingInputHandleComponent:Hacking()
    if not self.isHacking then
        self.isHacking = true
        self.fight.entityManager:CallBehaviorFun("Hacking", self.entity.instanceId)
        self.inputHandle:Hacking()
        self.onHackingPlayer = BehaviorFunctions.GetCtrlEntity()
    end
end

function HackingInputHandleComponent:StopHacking(nextHackId)
    if self.isHacking then
        self.isHacking = false
        self.fight.entityManager:CallBehaviorFun("StopHacking", self.entity.instanceId)
        self.inputHandle:StopHacking(nextHackId)
        self.onHackingPlayer = nil
    end
end

function HackingInputHandleComponent:ClickUp(down, notCostBattery)
    local barM = self.barMap[HackingConfig.HackingKey.Up]
    if (not barM.active) or (not barM.bar:GetEnable()) then
        return false, true
    end

    local overrideButtonInfo = self.overrideButtonConfig[HackingConfig.HackingKey.Up]

    if down and not notCostBattery then
        local costRam = self.upButtonBar:GetCostRam() or 0
        if overrideButtonInfo then
            costRam = overrideButtonInfo.hackingRam
        end
        local costElectricity = self.upButtonBar:GetCostElectricity() or 0
        if not self:CheckRam(costRam) then
            EventMgr.Instance:Fire(EventName.ShowHackingRamTips, false)
            return true, false
        end
        if not self:CheckElectricity(costElectricity) then
            MsgBoxManager.Instance:ShowTips(TI18N("电量不足"))
            return true, false
        end

        self:CostRam(costRam)
        self:CostElectricity(costElectricity)
        --EventMgr.Instance:Fire(EventName.HackBatteryLow, HackingConfig.HackingKey.Up)
    end
    if down then
        self.fight.entityManager:CallBehaviorFun("BegainHackingClickUp", self.entity.instanceId)
        self.fight.entityManager:CallBehaviorFun("HackingClickUp", self.entity.instanceId)
        self.upButtonBar:CallBehavior()
        self:OnPlayAnimation(self.config.UpPlayerAnimationName)
    end

    EventMgr.Instance:Fire(EventName.ShowHackingRamTips, true)

    self.inputHandle:ClickUp(down)

    return true, true
end

---@return boolean isContinue
function HackingInputHandleComponent:ClickDown(down, notCostBattery)
    local barM = self.barMap[HackingConfig.HackingKey.Down]
    if (not barM.active) or (not barM.bar:GetEnable()) then
        return false, true
    end

    local overrideButtonInfo = self.overrideButtonConfig[HackingConfig.HackingKey.Down]

    if down and not notCostBattery then
        local costRam = self.downButtonBar:GetCostRam() or 0
        if overrideButtonInfo then
            costRam = overrideButtonInfo.hackingRam
        end
        local costElectricity = self.downButtonBar:GetCostElectricity() or 0
        if not self:CheckRam(costRam) then
            EventMgr.Instance:Fire(EventName.ShowHackingRamTips, false)
            return true, false
        end
        if not self:CheckElectricity(costElectricity) then
            MsgBoxManager.Instance:ShowTips(TI18N("电量不足"))
            return true, false
        end

        self:CostRam(costRam)
        self:CostElectricity(costElectricity)
        --EventMgr.Instance:Fire(EventName.HackBatteryLow, HackingConfig.HackingKey.Down)
    end
    if down then
        self.fight.entityManager:CallBehaviorFun("BegainHackingClickDown", self.entity.instanceId)
        self.fight.entityManager:CallBehaviorFun("HackingClickDown", self.entity.instanceId)
        self.downButtonBar:CallBehavior()
        self:OnPlayAnimation(self.config.DownPlayerAnimationName)
    end

    EventMgr.Instance:Fire(EventName.ShowHackingRamTips, true)

    self.inputHandle:ClickDown(down)

    return true, true
end

function HackingInputHandleComponent:ClickLeft(down, notCostBattery)
    local barM = self.barMap[HackingConfig.HackingKey.Left]
    if (not barM.active) or (not barM.bar:GetEnable()) then
        return false, true
    end
    
    local overrideButtonInfo = self.overrideButtonConfig[HackingConfig.HackingKey.Left]

    if down and not notCostBattery then
        local costRam = self.leftButtonBar:GetCostRam() or 0
        if overrideButtonInfo then
            costRam = overrideButtonInfo.hackingRam
        end
        local costElectricity = self.leftButtonBar:GetCostElectricity() or 0
        if not self:CheckRam(costRam) then
            EventMgr.Instance:Fire(EventName.ShowHackingRamTips, false)
            return true, false
        end
        if not self:CheckElectricity(costElectricity) then
            MsgBoxManager.Instance:ShowTips(TI18N("电量不足"))
            return true, false
        end

        self:CostRam(costRam)
        self:CostElectricity(costElectricity)
        --EventMgr.Instance:Fire(EventName.HackBatteryLow, HackingConfig.HackingKey.Left)
    end
    if down then
        self.fight.entityManager:CallBehaviorFun("BegainHackingClickLeft", self.entity.instanceId)
        self.fight.entityManager:CallBehaviorFun("HackingClickLeft", self.entity.instanceId)
        self.leftButtonBar:CallBehavior()
        self:OnPlayAnimation(self.config.LeftPlayerAnimationName)
    end

    EventMgr.Instance:Fire(EventName.ShowHackingRamTips, true)

    self.inputHandle:ClickLeft(down)

    return true, true
end

function HackingInputHandleComponent:ClickRight(down, notCostBattery)
    local barM = self.barMap[HackingConfig.HackingKey.Right]
    if (not barM.active) or (not barM.bar:GetEnable()) then
        return false, true
    end

    local overrideButtonInfo = self.overrideButtonConfig[HackingConfig.HackingKey.Right]

    if down and not notCostBattery then
        local costRam = self.rightButtonBar:GetCostRam() or 0
        if overrideButtonInfo then
            costRam = overrideButtonInfo.hackingRam
        end
        local costElectricity = self.rightButtonBar:GetCostElectricity() or 0
        if not self:CheckRam(costRam) then
            EventMgr.Instance:Fire(EventName.ShowHackingRamTips, false)
            return true, false
        end
        if not self:CheckElectricity(costElectricity) then
            MsgBoxManager.Instance:ShowTips(TI18N("电量不足"))
            return true, false
        end
        
        self:CostRam(costRam)
        self:CostElectricity(costElectricity)
        --EventMgr.Instance:Fire(EventName.HackBatteryLow, HackingConfig.HackingKey.Right)
    end
    if down then
        self.fight.entityManager:CallBehaviorFun("BegainHackingClickRight", self.entity.instanceId)
        self.fight.entityManager:CallBehaviorFun("HackingClickRight", self.entity.instanceId)
        self.rightButtonBar:CallBehavior()
        self:OnPlayAnimation(self.config.RightPlayerAnimationName)
    end

    EventMgr.Instance:Fire(EventName.ShowHackingRamTips, true)

    self.inputHandle:ClickRight(down)

    return true, true
end

function HackingInputHandleComponent:GetUpOperateState()
    return self.inputHandle:GetUpOperateState()
end

function HackingInputHandleComponent:GetDownOperateState()
    return self.inputHandle:GetDownOperateState()
end

function HackingInputHandleComponent:GetLeftOperateState()
    return self.inputHandle:GetLeftOperateState()
end

function HackingInputHandleComponent:GetRightOperateState()
    return self.inputHandle:GetRightOperateState()
end

function HackingInputHandleComponent:CheckElectricity(costCount)
    if costCount == 0 then
		return true
	end
	costCount = costCount * (1 - BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.ElectricityCostPercent)/10000)
	costCount = costCount < 0 and 0 or costCount
	if BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurElectricityValue) >= costCount then
		return true
	end
	return false
end

function HackingInputHandleComponent:CheckRam(costCount)
    if costCount == 0 then
		return true
	end

	if BehaviorFunctions.GetPlayerAttrVal(FightEnum.PlayerAttr.CurRamValue) >= costCount then
		return true
	end

	return false
end

function HackingInputHandleComponent:CostElectricity(costCount)
    return BehaviorFunctions.CostPlayerElectricity(costCount)
end

function HackingInputHandleComponent:CostRam(costCount)
    return BehaviorFunctions.CastPlayerRam(costCount)
end

function HackingInputHandleComponent:OnPlayAnimation(AnimationName)
    if AnimationName ~= "" then
        local ctrlEntity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
        ctrlEntity.stateComponent:SetHackState(FightEnum.HackState.HackInput, AnimationName)
    end
end

function HackingInputHandleComponent:GetEffectType()
    return self.effectType
end

function HackingInputHandleComponent:SetEffectType(effectType)
    self.effectType = effectType
end

function HackingInputHandleComponent:OnCache()
    if self.inputHandle then
        self.inputHandle:OnCache()
        self.inputHandle = nil
    end
    self.fight.objectPool:Cache(HackingInputHandleComponent, self)

    if self.upButtonBar then
        self.upButtonBar:OnCache()
        self.upButtonBar = nil
    end
    if self.rightButtonBar then
        self.rightButtonBar:OnCache()
        self.rightButtonBar = nil
    end
    if self.downButtonBar then
        self.downButtonBar:OnCache()
        self.downButtonBar = nil
    end
    if self.leftButtonBar then
        self.leftButtonBar:OnCache()
        self.leftButtonBar = nil
    end
end

function HackingInputHandleComponent:__cache()
    self.fight = nil
    self.entity = nil
end

function HackingInputHandleComponent:__delete()
    if self.inputHandle then
        self.inputHandle:DeleteMe()
        self.inputHandle = nil
    end
    
    if self.upButtonBar then
        self.upButtonBar:DeleteMe()
        self.upButtonBar = nil
    end
    if self.rightButtonBar then
        self.rightButtonBar:DeleteMe()
        self.rightButtonBar = nil
    end
    if self.downButtonBar then
        self.downButtonBar:DeleteMe()
        self.downButtonBar = nil
    end
    if self.leftButtonBar then
        self.leftButtonBar:DeleteMe()
        self.leftButtonBar = nil
    end
end