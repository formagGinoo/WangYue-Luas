FlyFallRecoverMachine = BaseClass("FlyFallRecoverMachine",MachineBase)

function FlyFallRecoverMachine:__init()

end

function FlyFallRecoverMachine:Init(fight,entity,hitFSM)
    self.fight = fight
    self.entity = entity
    self.hitFSM = hitFSM
    self.hitTime = hitFSM.hitTime
    self.transformComponent = self.entity.transformComponent
    self.hitName = Config.EntityCommonConfig.AnimatorNames.HitNames[FightEnum.EntityHitState.HitFlyFallRecover]
end

function FlyFallRecoverMachine:OnEnter()
    self.remainChangeTime = self.hitTime[FightEnum.EntityHitState.HitFlyFallRecover].Time
    self.entity.animatorComponent:PlayAnimation(self.hitName)
    self.hitFSM.speedZ = 0
end

function FlyFallRecoverMachine:Update()
    local time = FightUtil.deltaTimeSecond * self.entity.timeComponent:GetTimeScale()
    self.remainChangeTime = self.remainChangeTime - time
    --if self.entity.moveComponent.isAloft then
    --    self.hitFSM:OnLand()
    --    return
    --end

    if self.remainChangeTime <= 0 then
        self.hitFSM:HitStateEnd()
    end
end

function FlyFallRecoverMachine:OnLeave()

end

function FlyFallRecoverMachine:CanMove()
    return false
end

function FlyFallRecoverMachine:CanHit()
    return true
end

function FlyFallRecoverMachine:CanCastSkill()
    return false
end

function FlyFallRecoverMachine:CanChangeRole()
    return false
end

function FlyFallRecoverMachine:OnCache()
    self.fight.objectPool:Cache(FlyFallRecoverMachine,self)
end

function FlyFallRecoverMachine:__cache()

end

function FlyFallRecoverMachine:__delete()

end