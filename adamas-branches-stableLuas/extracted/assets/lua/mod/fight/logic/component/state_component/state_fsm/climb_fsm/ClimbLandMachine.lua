ClimbLandMachine = BaseClass("ClimbLandMachine",MachineBase)

function ClimbLandMachine:__init()

end

function ClimbLandMachine:Init(fight,entity,climbFSM)
    self.fight = fight
    self.entity = entity
    self.climbFSM = climbFSM
end

function ClimbLandMachine:OnEnter()
    self.entity.logicMove = false
    self.time = 27 * FightUtil.deltaTimeSecond      -- 动画帧数
	self.switchableTime = 12 * FightUtil.deltaTimeSecond
    self.entity.moveComponent.yMoveComponent:OnLand()
    if self.entity.animatorComponent then
        self.time = self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.ClimbLand)
        --print("ClimbLandMachine")
    end
end

function ClimbLandMachine:Update()
    self.time = self.time - FightUtil.deltaTimeSecond
	self.switchableTime = self.switchableTime - FightUtil.deltaTimeSecond
    self.entity.climbComponent:SetForceCheckDirection(0, -1, 0)
    if self.time <= 0 then
        self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end
	
	if self.switchableTime <= 0 and self.fight.operationManager:CheckMove() then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Move)
	end
end

function ClimbLandMachine:OnLeave()
    self.entity.logicMove = true
end

function ClimbLandMachine:OnCache()
    self.fight.objectPool:Cache(ClimbLandMachine,self)
end

function ClimbLandMachine:__cache()

end

function ClimbLandMachine:__delete()

end