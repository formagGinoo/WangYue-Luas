StateFSM = BaseClass("StateFSM",FSM)
local EntityState = FightEnum.EntityState
function StateFSM:__init()
end

function StateFSM:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self:InitStates()
end

function StateFSM:InitStates()
	local objectPool = self.fight.objectPool
	self:AddState(EntityState.None, objectPool:Get(MoveNoneMachine))
	self:AddState(EntityState.Born, objectPool:Get(BornMachine))
	self:AddState(EntityState.Idle, objectPool:Get(IdleMachine))
	self:AddState(EntityState.FightIdle, objectPool:Get(FightIdleMachine))
	self:AddState(EntityState.Move, objectPool:Get(MoveMachine))
	self:AddState(EntityState.Jump, objectPool:Get(JumpMachine))
	self:AddState(EntityState.Pathfinding, objectPool:Get(PathfindingMachine))
	self:AddState(EntityState.Skill, objectPool:Get(SkillMachine))
	self:AddState(EntityState.Hit, objectPool:Get(HitMachine))
	self:AddState(EntityState.Fall, objectPool:Get(FallMachine))
	self:AddState(EntityState.Immobilize, objectPool:Get(ImmobilizeMachine))
	self:AddState(EntityState.Perform, objectPool:Get(PerformMachine))
	self:AddState(EntityState.Death, objectPool:Get(DeathMachine))
	self:AddState(EntityState.Stun, objectPool:Get(StunMachine))
	self:AddState(EntityState.Slide, objectPool:Get(SlideMachine))
	self:AddState(EntityState.Aim, objectPool:Get(AimMachine))
	self:AddState(EntityState.Climb, objectPool:Get(ClimbMachine))
	self:AddState(EntityState.Swim, objectPool:Get(SwimMachine))
	self:AddState(EntityState.CloseMenu, objectPool:Get(CloseMenuMachine))
	self:AddState(EntityState.Revive, objectPool:Get(ReviveMachine))
	self:AddState(EntityState.Glide, objectPool:Get(GlideMachine))
	self:AddState(EntityState.Hack, objectPool:Get(HackMachine))
	self:AddState(EntityState.OpenDoor, objectPool:Get(OpenDoorMachine))
	self:AddState(EntityState.CommonAnim, objectPool:Get(CommonAnimMachine))
	self:AddState(EntityState.Build, objectPool:Get(BuildMachine))
	for k, v in pairs(self.states) do
		v:Init(self.fight,self.entity)
	end
	--self:SwitchState(EntityState.Born)
end

function StateFSM:LateInit()
	for k, v in pairs(self.states) do
		if v.LateInit then
			v:LateInit()
		end
	end
end

-- IDLE和FightIdle的加入是为了解决切人再切回来不会正确播放待机动作的问题
local statesCanSwitchSelf = { EntityState.Idle, EntityState.FightIdle, EntityState.Hit, EntityState.Move, EntityState.Jump, EntityState.Swim, EntityState.Climb, EntityState.CloseMenu, EntityState.OpenDoor}
function StateFSM:TrySwitchState(state,...)
	if (self:IsState(EntityState.Death) and state ~= EntityState.Revive) and self:CheckDeathAnimState() then
		return
	end

	local canCallBehavior = true
	if self.curState == state then
		canCallBehavior = false
		for i = 1, #statesCanSwitchSelf do
			if state == statesCanSwitchSelf[i] then break end
			if i == #statesCanSwitchSelf then return end
		end
	end
	self:SwitchState(state,...)
	
	if canCallBehavior then
		self.fight.entityManager:CallBehaviorFun("EntityStateChange", self.entity.instanceId, state)
	end
end

function StateFSM:OnChildFsmSwitch(stateId)
end

function StateFSM:CanMove()
	return self.statesMachine:CanMove()
end

function StateFSM:CanFall()
	if self.statesMachine.CanFall then
		return self.statesMachine:CanFall()
	end

	return true
end

function StateFSM:CanCastSkill()
	return self.statesMachine:CanCastSkill()
end

function StateFSM:CanIngoreLandHurt()
	if not self.statesMachine.CanIngoreLandHurt then
		return false
	end

	return self.statesMachine:CanIngoreLandHurt()
end

function StateFSM:CanStun()
	return self.statesMachine:CanStun()
end

function StateFSM:CanJump()
	return self.statesMachine:CanJump()
end

function StateFSM:CanClimb()
	return self.statesMachine:CanClimb()
end

function StateFSM:CanPush()
	return self.statesMachine:CanPush()
end

function StateFSM:CanChangeRole()
	if self.statesMachine.CanChangeRole then
		return self.statesMachine:CanChangeRole()
	end

	return true
end

function StateFSM:IsSubMoveState(subState)
	if not self:IsState(EntityState.Move) then return end
	return self.states[EntityState.Move].moveFSM:IsState(subState)
end

function StateFSM:IsSubSwimState(subState)
	if not self:IsState(EntityState.Swim) then return end
	return self.states[EntityState.Swim].swimFSM:IsState(subState)
end

function StateFSM:IsSubClimbState(subState)
	if not self:IsState(EntityState.Climb) then return end
	return self.states[EntityState.Climb].climbFSM:IsState(subState)
end

function StateFSM:IsSubBuildState(subState)
	if not self:IsState(EntityState.Build) then return end
	return self.states[EntityState.Build].buildFSM:IsState(subState)
end

-- 搜索状态机下一层状态
function StateFSM:GetSubState()
	return self.statesMachine:GetSubState()
end

function StateFSM:GetSubMoveState()
	if not self:IsState(EntityState.Move) then
		return FightEnum.EntityMoveSubState.None
	end

	return self.states[EntityState.Move].moveFSM:GetState()
end

function StateFSM:GetSubSwimState()
	if not self:IsState(EntityState.Swim) then
		return FightEnum.EntitySwimState.None
	end

	return self.states[EntityState.Swim].swimFSM:GetState()
end

function StateFSM:GetSubClimbState()
	if not self:IsState(EntityState.Climb) then
		return FightEnum.EntityClimbState.None
	end

	return self.states[EntityState.Climb].climbFSM:GetState()
end

function StateFSM:GetSubGlideState()
	if not self:IsState(EntityState.Glide) then
		return FightEnum.GlideState.None
	end

	return self.states[EntityState.Glide].glideFSM:GetState()
end

function StateFSM:GetSubJumpState()
	if not self:IsState(EntityState.Jump) then
		return FightEnum.EntityJumpState.None
	end

	return self.states[EntityState.Jump].jumpFSM:GetState()
end

function StateFSM:CheckDeathAnimState()
	if not self:IsState(EntityState.Death) then
		return false
	end

	local curState = self.states[EntityState.Death].deathFSM:GetState()
	return curState ~= FightEnum.DeathState.None and curState ~= FightEnum.DeathState.Death
end

function StateFSM:GetDeathReason()
	if not self:IsState(EntityState.Death) then
		return
	end

	return self.states[EntityState.Death].deathFSM.deathReason
end

function StateFSM:GetCatchDeathState()
	if not self:IsState(EntityState.Death) then
		return
	end
	local deathFsm = self.states[EntityState.Death].deathFSM
	return deathFsm:GetCatchDeathState()
end

function StateFSM:OnCache()
	self:CacheStates()
	self.fight.objectPool:Cache(StateFSM,self)
end

function StateFSM:__cache()
end

function StateFSM:__delete()
end
