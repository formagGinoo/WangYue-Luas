AimEndMachine = BaseClass("AimEndMachine",MachineBase)

function AimEndMachine:__init()

end

function AimEndMachine:Init(fight,entity,aimFSM)
	self.fight = fight
	self.entity = entity
	self.aimFSM = aimFSM
	self.moveComponent = self.entity.moveComponent
	self.transformComponent = self.entity.transformComponent
	self.changeFrame = 0
end

function AimEndMachine:LateInit()

end

function AimEndMachine:OnEnter()
	self.startSpeed = self.transformComponent:GetSpeed()
	self.changeFrame = self.entity.animatorComponent.fusionFrame
	self:PlayAnimation()
end


function AimEndMachine:PlayAnimation()
	-- local clientAnimatorComponent = self.entity.clientEntity.clientAnimatorComponent
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.AimDown, 0, self.aimFSM.aimLayer)
	self.entity.animatorComponent:Update()
	-- clientAnimatorComponent:SetLayerWeight(self.aimFSM.aimLayer, 1, 0, 0.2)
 --    clientAnimatorComponent:SetLayerWeight(self.aimFSM.walkLayer, 1, 0, 0.2) 
end

function AimEndMachine:Update()

end

function AimEndMachine:OnLeave()
	
end

function AimEndMachine:OnCache()
	self.fight.objectPool:Cache(AimEndMachine,self)
end

function AimEndMachine:__cache()

end

function AimEndMachine:__delete()

end