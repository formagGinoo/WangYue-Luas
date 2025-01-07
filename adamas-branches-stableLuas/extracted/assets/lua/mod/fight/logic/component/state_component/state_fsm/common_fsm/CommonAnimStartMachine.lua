CommonAnimStartMachine = BaseClass("CommonAnimStartMachine", MachineBase)

function CommonAnimStartMachine:__init()

end

function CommonAnimStartMachine:Init(fight, entity, commonAnimFSM)
    self.fight = fight
    self.entity = entity
    self.commonAnimFSM = commonAnimFSM
end

function CommonAnimStartMachine:OnEnter(params, callback)
	self.callback = callback
	self.params = params
	self.time = 2.5
	self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames[params.StartBehaviorAnim.m_heroAnimName])
	self.commonAnimFSM:SetCanMove(false)
end

function CommonAnimStartMachine:Update()
	local timeScale = self.entity.timeComponent:GetTimeScale()
	self.time = (self.time - FightUtil.deltaTimeSecond) * timeScale
	if self.time <= 0 then
		if self.callback then
			self.callback()
		end
		self.commonAnimFSM:SwitchState(FightEnum.CommonAnimState.None, self.params)
	end
end

function CommonAnimStartMachine:CanMove()
	return self.commonAnimFSM.canMove
end

function CommonAnimStartMachine:CanJump()
	return false
end

function CommonAnimStartMachine:CanClimb()
	return false
end

function CommonAnimStartMachine:CanCastSkill()
	return false
end

function CommonAnimStartMachine:OnLeave()

end

function CommonAnimStartMachine:OnCache()

end

function CommonAnimStartMachine:__cache()

end

function CommonAnimStartMachine:__delete()

end