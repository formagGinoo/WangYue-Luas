CommonNoneMachine = BaseClass("CommonNoneMachine", MachineBase)

function CommonNoneMachine:__init()

end

function CommonNoneMachine:Init(fight, entity, commonAnimFSM)
    self.fight = fight
    self.entity = entity
    self.commonAnimFSM = commonAnimFSM
end

function CommonNoneMachine:OnEnter(params)
    self.params = params
end

function CommonNoneMachine:Update()
    local moveEvent = self.fight.operationManager:GetMoveEvent()
    if moveEvent then
		self:OnLeave()
        Fight.Instance.entityManager:CallBehaviorFun("OnStopCommonDrive", self.params.targetInstanceId)
    end
end

function CommonNoneMachine:OnLeave()

end

function CommonNoneMachine:OnCache()

end

function CommonNoneMachine:__cache()

end

function CommonNoneMachine:__delete()

end