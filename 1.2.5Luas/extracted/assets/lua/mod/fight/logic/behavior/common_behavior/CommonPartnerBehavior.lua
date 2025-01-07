CommonPartnerBehavior = BaseClass("CommonPartnerBehavior",BehaviorBase)

local partnerState = {
    idle = 1,
    Level = 2,
    LevelEnd = 3
}

---@param fight Fight
---@param entity Entity
function CommonPartnerBehavior:InitConfig(fight, entity, enterTime, exitTime, exitStartFrame, exitEndTime)
    self.fight = fight
    self.entity = entity
    self.enterTime = enterTime
    self.exitTime = exitTime
    self.exitStartFrame = exitStartFrame
    self.exitEndTime = exitEndTime

    self.state = partnerState.idle
    self.time = 0
end

function CommonPartnerBehavior:Update()
    if self.state == partnerState.idle then
        return
    end

    local timeScale = self.entity.timeComponent:GetTimeScale() or 1
    if self.state == partnerState.Level then
        self.time = self.time - FightUtil.deltaTimeSecond * timeScale
        if self.time < 0 then
            Fight.Instance.entityManager:CallBehaviorFun("PartnerLeave", self.entity.instanceId)
            self.state = partnerState.LevelEnd
            self.time = self.exitEndTime
        end
    end

    if self.state == partnerState.LevelEnd then
        self.time = self.time - FightUtil.deltaTimeSecond * timeScale
        if self.time < 0 then
            Fight.Instance.entityManager:CallBehaviorFun("PartnerHide", self.entity.instanceId)
            self.state = partnerState.idle
            self.entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
        end
    end

end

function CommonPartnerBehavior:DoPartnerLeave()
    self.time = self.exitTime
    self.state = partnerState.Level
    self.entity.animatorComponent:PlayAnimation("PartnerLeave", self.StartFrame)
    Fight.Instance.entityManager:CallBehaviorFun("PartnerDeparture", self.entity.instanceId)
end

function CommonPartnerBehavior:StopPartnerLeave()
    self.state = partnerState.idle
    self.time = 0
end