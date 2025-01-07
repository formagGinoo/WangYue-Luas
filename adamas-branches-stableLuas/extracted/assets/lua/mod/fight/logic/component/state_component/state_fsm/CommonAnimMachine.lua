CommonAnimMachine = BaseClass("CommonAnimMachine", MachineBase)

function CommonAnimMachine:__init()

end

function CommonAnimMachine:Init(fight, entity)
    self.fight = fight
    self.entity = entity

    self.commonAnimFSM = self.fight.objectPool:Get(CommonAnimFSM)
    self.commonAnimFSM:Init(fight,entity)
end

function CommonAnimMachine:LateInit()
    self.commonAnimFSM:LateInit()
end

function CommonAnimMachine:OnEnter(params, callback)
    self.commonAnimFSM:OnEnter(params, callback)
end

function CommonAnimMachine:OnLeave()
    self.commonAnimFSM:OnLeave()
end

function CommonAnimMachine:Update()
    self.commonAnimFSM:Update()
end

function CommonAnimMachine:CanMove()
    return self.commonAnimFSM:CanMove()
end

function CommonAnimMachine:CanJump()
    return false
end

function CommonAnimMachine:CanCastSkill()
    return false
end

function CommonAnimMachine:OnCache()
    if self.commonAnimFSM then
        self.commonAnimFSM:OnCache()
        self.commonAnimFSM = nil
    end
    self.fight.objectPool:Cache(CommonAnimMachine, self)
end

function CommonAnimMachine:__delete()
    if self.commonAnimFSM then
        self.commonAnimFSM:DeleteMe()
        self.commonAnimFSM = nil
    end
end