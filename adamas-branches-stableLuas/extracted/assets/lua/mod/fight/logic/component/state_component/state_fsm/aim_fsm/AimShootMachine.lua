AimShootMachine = BaseClass("AimShootMachine",MachineBase)

function AimShootMachine:__init()

end

function AimShootMachine:Init(fight,entity,aimFSM)
	self.fight = fight
	self.entity = entity
	self.aimFSM = aimFSM
end

function AimShootMachine:LateInit()

end

function AimShootMachine:OnEnter()
	self:PlayAnimation()
end

function AimShootMachine:PlayAnimation()
	-- self.aimFSM:CreateShootEffect()
	-- local clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.AimShoot, 0, self.aimFSM.aimLayer)
	self.entity.animatorComponent:Update()
end

function AimShootMachine:Update()

end

function AimShootMachine:OnLeave()

end

function AimShootMachine:OnCache()
	self.fight.objectPool:Cache(AimShootMachine,self)
end

function AimShootMachine:__cache()

end

function AimShootMachine:__delete()

end