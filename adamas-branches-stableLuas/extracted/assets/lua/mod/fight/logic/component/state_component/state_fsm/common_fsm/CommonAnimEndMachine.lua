CommonAnimEndMachine = BaseClass("CommonAnimEndMachine", MachineBase)

function CommonAnimEndMachine:__init()

end

function CommonAnimEndMachine:Init(fight, entity, commonAnimFSM)
    self.fight = fight
    self.entity = entity
    self.commonAnimFSM = commonAnimFSM
end

function CommonAnimEndMachine:OnEnter(pramas, callback)
    self.callback = callback
    self.time = 2.5
    self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames[pramas.EndBehaviorAnim.m_heroAnimName])
    self.commonAnimFSM:SetCanMove(false)
end

function CommonAnimEndMachine:Update()
    local timeScale = self.entity.timeComponent:GetTimeScale()
    self.time = (self.time - FightUtil.deltaTimeSecond) * timeScale

    --local moveEvent = self.fight.operationManager:GetMoveEvent()
    if self.time <= 0 then
        if self.callback then
            self.callback()
        end
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
end

function CommonAnimEndMachine:OnLeave()

end

function CommonAnimEndMachine:CanMove()
    return self.commonAnimFSM.canMove
end

function CommonAnimEndMachine:OnCache()

end

function CommonAnimEndMachine:__cache()

end

function CommonAnimEndMachine:__delete()

end