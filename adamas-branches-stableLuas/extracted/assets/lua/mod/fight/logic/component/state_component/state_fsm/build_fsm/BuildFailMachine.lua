BuildFailMachine = BaseClass("BuildFailMachine", MachineBase)

local AnimatorNameConfig = Config.EntityCommonConfig.AnimatorNames

function BuildFailMachine:__init()

end

function BuildFailMachine:Init(fight, entity, buildFSM)
    self.fight = fight
    self.entity = entity
    self.buildFSM = buildFSM

    self.moveComponent = self.entity.moveComponent
    self.animatorComponent = self.entity.animatorComponent
end


function BuildFailMachine:OnEnter()
    self.remainChangeTime = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.BuildFail) or 0
    self.fight.entityManager:CallBehaviorFun("OnBuildStateChange", self.entity.instanceId, FightEnum.EntityBuildState.BuildFail)
end

function BuildFailMachine:LateInit()

end

function BuildFailMachine:Update()
end

function BuildFailMachine:OnLeave()
end

function BuildFailMachine:OnCache()
    self.fight.objectPool:Cache(BuildFailMachine,self)
end

function BuildFailMachine:__cache()
end

function BuildFailMachine:__delete()
end