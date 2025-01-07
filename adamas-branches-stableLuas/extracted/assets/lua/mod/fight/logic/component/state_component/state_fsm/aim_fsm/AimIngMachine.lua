AimIngMachine = BaseClass("AimIngMachine",MachineBase)

local MissileCreateTime = 0.2

function AimIngMachine:__init()

end

function AimIngMachine:Init(fight,entity,aimFSM)
	self.fight = fight
	self.entity = entity
	self.aimFSM = aimFSM
end

function AimIngMachine:LateInit()

end

function AimIngMachine:OnEnter()
	self:PlayAnimation()
end

function AimIngMachine:PlayAnimation()
	-- self.chargeEnd = false
	-- self.aimFSM:CreateChargeEffect()
	-- local clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Aiming, 0, self.aimFSM.aimLayer)
	self.entity.animatorComponent:Update()
end

function AimIngMachine:Update()

end

function AimIngMachine:OnLeave()

end

function AimIngMachine:OnCache()
	self.fight.objectPool:Cache(AimIngMachine,self)
end

function AimIngMachine:__cache()

end

function AimIngMachine:__delete()

end