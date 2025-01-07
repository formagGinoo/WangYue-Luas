CommonPartnerBehavior = BaseClass("CommonPartnerBehavior",BehaviorBase)

local partnerState = {
    idle = 1,
    Show = 2,
    Leave = 3,
    LeaveEnd = 4
}

---@param fight Fight
---@param entity Entity
function CommonPartnerBehavior:InitConfig(fight, entity, showTime, exitTime, exitStartFrame, exitEndTime, showMagicId)
    self.fight = fight
    self.entity = entity
    self.showTime = showTime
    self.exitTime = exitTime
    self.exitStartFrame = exitStartFrame
    self.exitEndTime = exitEndTime
    self.showMagicId = showMagicId

    self.commonBehaviorComponent = entity.commonBehaviorComponent

    self.state = partnerState.idle
    self.time = 0

    self.player = fight.playerManager:GetPlayer()
    self.role = entity.root
end

function CommonPartnerBehavior:Update()
    local timeScale = self.entity.timeComponent:GetTimeScale() or 1
    local passTime = FightUtil.deltaTimeSecond * timeScale

    if self.partnerHenshinTime and self.partnerHenshinTime > 0 then
        self.partnerHenshinTime = self.partnerHenshinTime - passTime
        if self.partnerHenshinTime <= 0 then
            self.partnerHenshinTime = nil
            self:PartnerHenshinShow()
        end
    end

    if self.playerHenshinTime and self.playerHenshinTime > 0 then
        self.playerHenshinTime = self.playerHenshinTime - passTime
        if self.playerHenshinTime <= 0 then
            self.playerHenshinTime = nil
            self:RoleHenshinShow()
        end
    end

    if self.partnerOutTimer and self.partnerOutTimer > 0 then
        self.partnerOutTimer = self.partnerOutTimer - passTime
        if self.partnerOutTimer <= 0 then
            self.partnerOutTimer = nil
            -- 隐藏配从
            BehaviorFunctions.ShowPartner(self.role.instanceId, false)
        end
    end

    if self.playerOutTimer and self.playerOutTimer > 0 then
        self.playerOutTimer = self.playerOutTimer - passTime
        if self.playerOutTimer <= 0 then
            self.playerOutTimer = nil
            -- 隐藏配从
            BehaviorFunctions.DoMagic(self.role.instanceId, self.role.instanceId, 1000048)
        end
    end

    if self.state == partnerState.idle then
        return
    end

    if self.state == partnerState.Show then
        self.time = self.time - passTime
        if self.time < 0 then
            Fight.Instance.entityManager:CallBehaviorFun("PartnerShow", self.entity.instanceId)
            self.state = partnerState.idle
            if self.showMagicId ~= 0 then
                BehaviorFunctions.RemoveBuff(self.entity.instanceId, self.showMagicId)
            end
        end
    end

    if self.state == partnerState.Leave then
        self.time = self.time - passTime
        if self.time < 0 then
            Fight.Instance.entityManager:CallBehaviorFun("PartnerLeave", self.entity.instanceId)
            self.state = partnerState.LeaveEnd
            self.time = self.exitEndTime
        end
    end

    if self.state == partnerState.LeaveEnd then
        self.time = self.time - passTime
        if self.time < 0 then
            self.state = partnerState.idle
            self.entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
            Fight.Instance.entityManager:CallBehaviorFun("PartnerHide", self.entity.instanceId)
        end
    end
end

function CommonPartnerBehavior:DoPartnerShow()
    self.time = self.showTime
    self.state = partnerState.Show
    if self.showMagicId ~= 0 then
        BehaviorFunctions.DoMagic(self.entity.instanceId, self.entity.instanceId, self.showMagicId)
    end
    self.entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Foreground)
end

function CommonPartnerBehavior:StopPartnerShow()
    self.state = partnerState.idle
    self.time = 0
end

function CommonPartnerBehavior:DoPartnerLeave()
    self.time = self.exitTime
    self.state = partnerState.Leave
    self.entity.animatorComponent:PlayAnimation("PartnerLeave", self.StartFrame)
    Fight.Instance.entityManager:CallBehaviorFun("PartnerDeparture", self.entity.instanceId)
end

function CommonPartnerBehavior:StopPartnerLeave()
    self.state = partnerState.idle
    self.time = 0
end

-- 配从变身的逻辑
function CommonPartnerBehavior:StartHenshin(position)
    local isChangeBtn = self.commonBehaviorComponent.config.m_SwitchBtn
    local partnerInstance = self.entity.instanceId
    local playerInstance = self.role.instanceId

    -- 设置配从变身状态
    self.player:SetPartnerHenshinState(playerInstance, FightEnum.PartnerHenshinState.Show)

    -- 切换技能轮盘
    if isChangeBtn then
        BehaviorFunctions.SwitchUIRoulette(partnerInstance, 1)
    end

    local henshinPos = position or self.role.transformComponent:GetPosition()
    -- 同步角色位置和旋转
    BehaviorFunctions.DoSetPositionP(partnerInstance, henshinPos)
    BehaviorFunctions.CopyEntityRotate(playerInstance, partnerInstance)

    -- 角色消失特效延迟时间
    self.playerOutTimer = self.commonBehaviorComponent.config.m_PlayerOTime or 0.6

    -- 角色变身特效
    local playerEffect = self.commonBehaviorComponent.config.m_RoleOutEffect
    if playerEffect then
        BehaviorFunctions.DoMagic(playerInstance, playerInstance, playerEffect)
    end

    -- 隐藏角色
    -- BehaviorFunctions.DoMagic(playerInstance, playerInstance, 1000048)

    -- 没有delay立即播放
    local delayTime = self.commonBehaviorComponent.config.m_PartnerHShowTime
    if delayTime and delayTime <= 0 then
        self:PartnerHenshinShow()
    else
        self.partnerHenshinTime = delayTime
    end
end

function CommonPartnerBehavior:StopHenshin(position, immediate)
    if self.partnerHenshinTime then
        self.partnerHenshinTime = nil
    end

    local isChangeBtn = self.commonBehaviorComponent.config.m_SwitchBtn
    local partnerInstance = self.entity.instanceId
    local playerInstance = self.role.instanceId

    -- 取消配从变身状态
    self.player:SetPartnerHenshinState(playerInstance, FightEnum.PartnerHenshinState.Out)

    -- 切换技能轮盘
	if isChangeBtn then
        BehaviorFunctions.SwitchUIRoulette(playerInstance, 1)
    end

    -- 切换相机锁定为角色
    BehaviorFunctions.SetMainTarget(playerInstance)

    -- 如果有配从离场特效
    local partnerEffect = self.commonBehaviorComponent.config.m_PartnerOutEffect
    if partnerEffect then
        BehaviorFunctions.DoMagic(partnerInstance, partnerInstance, partnerEffect)
    end

    -- 配从消失特效延迟时间
    self.partnerOutTimer = self.commonBehaviorComponent.config.m_PartnerOTime or 0.6
    -- -- 隐藏配从
    -- BehaviorFunctions.ShowPartner(playerInstance, false)

    local henshinPos = position or self.entity.transformComponent:GetPosition()
    BehaviorFunctions.DoSetPositionP(playerInstance, henshinPos)
    BehaviorFunctions.CopyEntityRotate(partnerInstance, playerInstance)

    local delayTime = immediate and 0 or self.commonBehaviorComponent.config.m_RoleHShowTime
    if delayTime and delayTime <= 0 then
        self:RoleHenshinShow()
    else
        self.playerHenshinTime = delayTime
    end
end

function CommonPartnerBehavior:PartnerHenshinShow(instanceId)
    if instanceId ~= self.entity.instanceId then
        return
    end

    local partnerInstance = self.entity.instanceId
    local playerInstance = self.role.instanceId
    -- 切换相机锁定为配从
    BehaviorFunctions.SetMainTarget(partnerInstance)
    -- 如果有配从出场特效
    local partnerEffect = self.commonBehaviorComponent.config.m_PartnerInEffect
    if partnerEffect then
        BehaviorFunctions.DoMagic(partnerInstance, partnerInstance, partnerEffect)
    end
    -- 配从出场
    BehaviorFunctions.ShowPartner(playerInstance, true)
    self.player:SetPartnerHenshinState(playerInstance, FightEnum.PartnerHenshinState.Henshin)
    self.fight.entityManager:CallBehaviorFun("PartnerHenshinStart", partnerInstance, playerInstance)
end

function CommonPartnerBehavior:RoleHenshinShow()
    local partnerInstance = self.entity.instanceId
    local playerInstance = self.role.instanceId
    -- 切换相机锁定为角色
    BehaviorFunctions.SetMainTarget(playerInstance)
    -- 显示角色
    BehaviorFunctions.RemoveBuff(playerInstance, 1000048)
    -- 角色变身特效
    local playerEffect = self.commonBehaviorComponent.config.m_RoleInEffect
    if playerEffect then
        BehaviorFunctions.DoMagic(playerInstance, playerInstance, playerEffect)
    end
    self.player:SetPartnerHenshinState(playerInstance, FightEnum.PartnerHenshinState.None)
    self.fight.entityManager:CallBehaviorFun("PartnerHenshinStop", partnerInstance, playerInstance)
end

-- TODO 可能是要和于畅对一下的
function CommonPartnerBehavior:ChangeBattleTarget()

end