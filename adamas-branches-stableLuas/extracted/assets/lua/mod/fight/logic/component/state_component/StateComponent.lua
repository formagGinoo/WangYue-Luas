---@class StateComponent
StateComponent = BaseClass("StateComponent",PoolBaseClass)

local EntityState = FightEnum.EntityState

function StateComponent:__init()
	self.backstage = FightEnum.Backstage.Foreground
	--self.stateSigns = {}
	self.buffStates = {}
	--self.removesState = {}
end

function StateComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.entity.stateComponent = self
	self.stateFSM = self.fight.objectPool:Get(StateFSM)
	self.stateFSM:Init(fight,entity)
	self.allowDoubleJump = false --是否允许二段跳
end

function StateComponent:LateInit()
	self.stateFSM:LateInit()
end

function StateComponent:Update()
	self.stateFSM:Update()
	--self:UpdateStateSigns()
end

function StateComponent:AfterUpdate()
	self.incomeHitType = nil
end

function StateComponent:UpdateIgnoreTimeScale()
	--self:UpdateSignStates()
end

function StateComponent:SetState(state,...)
	--LogError("切换状态：" ..  state)
	self.stateFSM:TrySwitchState(state,...)
end

function StateComponent:IsState(state)
	return self.stateFSM:IsState(state)
end
function StateComponent:GetState()
	return self.stateFSM.curState ,self.stateFSM:GetSubState() or 0
end

function StateComponent:StartMove()
	local statesMachine = self.stateFSM.statesMachine
	if statesMachine.StartMove then
		statesMachine:StartMove()
	end
	if (not self:IsState(FightEnum.EntityState.Aim) and not self:IsState(EntityState.Hack) and not self:IsState(EntityState.Build))  and
		not self.stateFSM:IsSubMoveState(FightEnum.EntityMoveSubState.RunStart)
		and not self.stateFSM:IsSubMoveState(FightEnum.EntityMoveSubState.Run) then
		self:SetState(FightEnum.EntityState.Move)
	end
end

function StateComponent:StopMove()
	local statesMachine = self.stateFSM.statesMachine
	if statesMachine.StopMove then
		statesMachine:StopMove()
	end
end

function StateComponent:StartSwim()
	local statesMachine = self.stateFSM.statesMachine
	self:SetState(FightEnum.EntityState.Swim)
end

function StateComponent:StopSwim()
	local statesMachine = self.stateFSM.statesMachine
	if statesMachine.StopSwim then
		statesMachine:StopSwim()
	end
end

function StateComponent:StartClimb()
	local statesMachine = self.stateFSM.statesMachine
	self:SetState(FightEnum.EntityState.Climb)
end

function StateComponent:StopClimb()
	local statesMachine = self.stateFSM.statesMachine
	if statesMachine.StopClimb then
		statesMachine:StopClimb()
	end
end

function StateComponent:CanMove()
	if self:IsState(FightEnum.EntityState.Stun) then
		return false
	end

	if self:IsState(FightEnum.EntityState.ClimbLand) then
		return false
	end

	if self.entity.moveComponent.isAloft then
		return false
	end

	return self.stateFSM:CanMove()
end

function StateComponent:CanFall()
	local tagComponent = self.entity.tagComponent
	if not tagComponent or tagComponent.tag ~= FightEnum.EntityTag.Npc then
		return true
	end

	if self.entity.moveComponent and self.entity.moveComponent.isAloft and not tagComponent:IsMonster() then
		-- LogError("掉下去了 entityId = "..self.entity.entityId)
		return true
	end

	return self.stateFSM:CanFall()
end

function StateComponent:CanCastSkill()
	if self:IsState(FightEnum.EntityState.Stun) then
		return false
	end

	return self.stateFSM:CanCastSkill()
end

function StateComponent:CanGlide()
	local curstate = self.stateFSM:GetSubGlideState()
	return curstate >= FightEnum.GlideState.GlideStart and curstate < FightEnum.GlideState.GlideLand
end

function StateComponent:CanIngoreLandHurt()
	return self.stateFSM:CanIngoreLandHurt()
end

local canChangeState = {
	FightEnum.EntityState.Idle,
	FightEnum.EntityState.FightIdle,
	FightEnum.EntityState.Move,
	FightEnum.EntityState.Skill,
	FightEnum.EntityState.Hit,
	FightEnum.EntityState.Glide,
	FightEnum.EntityState.Jump,
	FightEnum.EntityState.Swim,
	FightEnum.EntityState.Climb,
}
function StateComponent:CanChangeRole()
	local canChangeRole = false
	for i = 1, #canChangeState do
		if self:IsState(canChangeState[i]) then
			canChangeRole = true
			break
		end
	end

	if not canChangeRole then
		return false
	end

	if not self.stateFSM:CanChangeRole() then
		return false
	end

	return true
end

function StateComponent:ChangeRole_GetSubState()
	local state = self.stateFSM:GetState()
	if state == EntityState.Move then
		return self.stateFSM:GetSubMoveState()
	elseif state == EntityState.Swim then
		return self.stateFSM:GetSubSwimState()
	elseif state == EntityState.Climb then
		return self.stateFSM:GetSubClimbState()
	elseif state == EntityState.Jump then
		return self.stateFSM:GetSubJumpState()
	elseif state == EntityState.Glide then
		return self.stateFSM:GetSubGlideState()
	end
end

-- 滑翔是为了跳过开伞阶段
function StateComponent:ChangeRole_SetSubState(mainState, subState)
	local curState = self.stateFSM:GetState()
	if curState ~= mainState then
		if mainState ~= EntityState.Glide then
			self.stateFSM:SwitchState(mainState)
		else
			self.stateFSM:SwitchState(mainState, true)
		end
	end

	if mainState == EntityState.Move then
		if subState == FightEnum.EntityMoveSubState.Sprint then
			self:SetSprintState(true)
		elseif subState == FightEnum.EntityMoveSubState.SprintEnd then
			self:SetSprintState(false)
		end

		self:SetMoveType(subState)
	elseif mainState == EntityState.Swim then
		self:SetFastSwimming(subState == FightEnum.EntitySwimState.FastSwimming)
		
	elseif mainState == EntityState.Climb then
		if subState == FightEnum.EntityClimbState.ClimbingRun then
			self:SetClimbingRun(true)
		elseif subState == FightEnum.EntityClimbState.ClimbingRunEnd then
			self:SetClimbingRun(false)
		end
		self:SetClimbState(subState)
		
	elseif mainState == EntityState.Jump then
		self.stateFSM.states[EntityState.Jump].jumpFSM:SwitchState(subState)
	elseif mainState == EntityState.Glide then
		self.stateFSM.states[EntityState.Glide].glideFSM:SwitchState(subState)
	end
end

function StateComponent:CanStun()
	if BehaviorFunctions.CheckBuffState(self.entity.instanceId, FightEnum.EntityBuffState.ImmuneStun) then
		return false
	end
	return self.stateFSM:CanStun()
end

function StateComponent:SetHitType(...)
	self:SetState(EntityState.Hit,...)
end

function StateComponent:CheckHitType(hitType)
	if not self:IsState(FightEnum.EntityState.Hit) then
		return false
	end

	return self.stateFSM.states[FightEnum.EntityState.Hit].hitFSM.curState == hitType
end

function StateComponent:SetIncomingHitType(type)
	self.incomeHitType = type
end

function StateComponent:GetIncomingHitType()
	return self.incomeHitType
end

function StateComponent:SetMoveType(type)
	if self:IsState(EntityState.Jump) then return end
	if not self:IsState(EntityState.Move) then
		if self.entity.moveComponent.isAloft then
			self.entity.moveComponent:SetAloft(false)
		end
		
		-- 不执行StartMove避免和下面SetMoveType同时进入两个相同machine让动画播两次导致融合失效
		self:SetState(EntityState.Move,true)
	end
	self.stateFSM.states[EntityState.Move].moveFSM:SetMoveType(type)
end

function StateComponent:SetMoveMode(mode)
	self.stateFSM.states[EntityState.Move].moveFSM:SetMoveMode(mode)
end

function StateComponent:SetSprintState(state)
	self.stateFSM.states[EntityState.Move].moveFSM:SetSprintState(state)
end

function StateComponent:SetFastSwimming(state)
	self.stateFSM.states[EntityState.Swim].swimFSM:SetFastSwimming(state)
end

-- region 攀爬模块
function StateComponent:SetClimbState(state)
	self.stateFSM.states[EntityState.Climb].climbFSM:SetClimbState(state)
end

function StateComponent:SetClimbingRun(state)
	self.stateFSM.states[EntityState.Climb].climbFSM:SetClimbingRun(state)
end

function StateComponent:SetForceLeaveClimb()
	self.stateFSM.states[EntityState.Climb].climbFSM:ForceLeaveClimb()
end

function StateComponent:IsClimbState(state)
	return self.stateFSM:IsSubClimbState(state)
end

function StateComponent:IsClimbingRun()
	return self.stateFSM.states[EntityState.Climb].climbFSM.climbRun
end

function StateComponent:CanClimb()
	return self.stateFSM:CanClimb()
end
	
--- endregion

function StateComponent:SetHackState(type, ...)
	if not self:IsState(EntityState.Hack) then
		return
	end

	self.stateFSM.states[EntityState.Hack].hackFSM:SwitchState(type, ...)
end

function StateComponent:SetOpenDoorState(type, ...)
	self.stateFSM.states[EntityState.OpenDoor].openDoorFSM:SwitchState(type, ...)
end

function StateComponent:SetCommonAnimState(type, ...)
	self.stateFSM.states[EntityState.CommonAnim].commonAnimFSM:SwitchState(type, ...)
end

function StateComponent:SetBuildState(type, ...)
	self.stateFSM.states[EntityState.Build].buildFSM:SwitchState(type, ...)
end

function StateComponent:IsHacking()
	if not self:IsState(EntityState.Hack) then
		return false
	end

	if self.stateFSM.states[EntityState.Hack].hackFSM.curState == FightEnum.HackState.Hacking then
		return true
	end

	return false
end

function StateComponent:SetHackingType(hackingType)
	if not self:IsState(EntityState.Hack) then
		return
	end

	self.stateFSM.states[EntityState.Hack].hackFSM:SetHackingType(hackingType)
end

function StateComponent:GetHackingType()
	if not self:IsState(EntityState.Hack) then
		return
	end

	return self.stateFSM.states[EntityState.Hack].hackFSM:GetHackingType()
end

function StateComponent:SetHackingMoveState(canMove)
	if not self:IsState(EntityState.Hack) then
		return
	end

	self.stateFSM.states[EntityState.Hack].hackFSM:SetCanMove(canMove)
end

function StateComponent:IsSprint()
	return self.stateFSM.states[EntityState.Move].moveFSM.isSprint
end

function StateComponent:IsFastSwimming()
	return self.stateFSM.states[EntityState.Swim].swimFSM.fastSwimming
end

function StateComponent:GetMoveMode()
	return self.stateFSM.states[EntityState.Move].moveFSM.moveMode
end

function StateComponent:SetAimState(type)
	if not self:IsState(EntityState.Aim) then
		return
	end

	self.stateFSM.states[EntityState.Aim].aimFSM:SwitchState(type)
end

function StateComponent:SetAimShootSingle()
	self.stateFSM.states[EntityState.Aim].aimFSM:SetShootSingle(true)
end

function StateComponent:GetJumpState()
	if not self:IsState(EntityState.Jump) then
		return FightEnum.EntityJumpState.None
	end

	return self.stateFSM.states[EntityState.Jump].jumpFSM.curState
end

function StateComponent:GetBuildDisableHorizontalMove(disableLeft, disableRight)
	if not self:IsState(EntityState.Build) then
		return
	end

	return self.stateFSM.states[EntityState.Build].buildFSM:SetDisableHorizontalMove(disableLeft, disableRight)
end

function StateComponent:CanJump()
	return self.stateFSM:CanJump()
end
  
function StateComponent:CanPush()
	return self.stateFSM:CanPush()
end

function StateComponent:AllowDoubleJump()
	return self.allowDoubleJump
end

function StateComponent:SetAllowDoubleJump(allow)
	self.allowDoubleJump = allow
end

function StateComponent:ChangeBackstage(backstage)
	self.backstage = backstage
	local player = Fight.Instance.playerManager:GetPlayer()
	if self.backstage == FightEnum.Backstage.Foreground	then
		self.fight.entityManager:CallBehaviorFun("ChangeForeground",self.entity.instanceId, player:IsRoleFirstAppear(self.entity.instanceId))
	else
		if self.entity.instanceId == player.ctrlId then
			self.entity.timeComponent:RemoveCanBreakPauseFrame()
			self.fight.entityManager.commonTimeScaleManager:RemoveCanBreakPauseFrame()
			BehaviorFunctions.RemoveBuffByKind(self.entity.instanceId,1008)
		end
		self.fight.entityManager:CallBehaviorFun("ChangeBackground",self.entity.instanceId)
	end

	if ctx then
		self.entity.clientTransformComponent:SetActive(self.backstage == FightEnum.Backstage.Foreground)
		if self.entity.clientTransformComponent.kCCCharacterProxy then
			self.entity.clientTransformComponent.kCCCharacterProxy:SetActive(self.backstage == FightEnum.Backstage.Foreground)
		end
		self.entity.clientEntity.clientBuffComponent:SetActivity(self.backstage == FightEnum.Backstage.Foreground)
	end

	self.entity.partComponent:SetLogicVisible(backstage == FightEnum.Backstage.Foreground)
end

function StateComponent:GetBackstage()
	return self.backstage
end

--[[
function StateComponent:AddSignState(state,lastFrame,ignoreTimeScale)
	local sign = self.stateSigns[state]
	if not sign then
		sign = self.fight.objectPool:Get(StateSign)
		sign:Init(self.fight,self.entity,lastFrame,ignoreTimeScale,self.fight.fightFrame,self.entity.timeComponent.frame)
		self.stateSigns[state] = sign
	end
	sign:Refresh(lastFrame,ignoreTimeScale,self.fight.fightFrame,self.entity.timeComponent.frame)

	self.fight.entityManager:CallBehaviorFun("AddEntitySign", self.entity.instanceId, state)
end
]]
--[[
function StateComponent:GetSignInfo(sign)
	local stateSign = self.stateSigns[sign]
	if not stateSign then
		LogError(" sign is nil, sign = "..sign)
	end
	return stateSign
end
]]
--[[
function StateComponent:RemoveSignState(sign)
	local stateSign = self.stateSigns[sign]
	if stateSign then
		self.fight.objectPool:Cache(StateSign,stateSign)
		self.stateSigns[sign] = nil
		self.fight.entityManager:CallBehaviorFun("RemoveEntitySign", self.entity.instanceId, sign)
	end
end
]]
function StateComponent:CheckDeathAnimationPlaying()
	return self.stateFSM:CheckDeathAnimState()
end

function StateComponent:GetDeathReason()
	return self.stateFSM:GetDeathReason()
end

-- TODO 做到分层状态机里面去
function StateComponent:SetPerformMoveState(state)
	self.performMoveState = state
end

function StateComponent:CheckPerformMoveState()
	if not self:IsState(EntityState.Perform) then
		return false
	end

	return self.performMoveState
end

--[[
function StateComponent:HasSignState(sign)
	local stateSign = self.stateSigns[sign]
	if not stateSign then
		return false
	else
		if stateSign:IsValid() then
			return true
		else
			return false
		end
	end
end
]]
--[[
function StateComponent:UpdateStateSigns()
	for sign, stateSign in pairs(self.stateSigns) do
		if not stateSign:IsValid() then
			table.insert(self.removesState, sign)
		end
	end

	for _, sign in pairs(self.removesState) do
		if self.stateSigns[sign] then
			self.fight.objectPool:Cache(StateSign, self.stateSigns[sign])
			self.stateSigns[sign] = nil
			self.fight.entityManager:CallBehaviorFun("RemoveEntitySign",self.entity.instanceId, sign)
		end
	end
	self.removesState = {}
end
]]

function StateComponent:OnCache()
	if self.stateFSM then
		self.stateFSM:OnCache()
		self.stateFSM = nil
	end

	self.backstage = FightEnum.Backstage.Foreground
	TableUtils.ClearTable(self.buffStates)
--[[
	for k, v in pairs(self.stateSigns) do
		self.fight.objectPool:Cache(StateSign,v)
		self.stateSigns[k] = nil
	end
]]
	self.fight.objectPool:Cache(StateComponent,self)
end

function StateComponent:__delete()
	if self.stateFSM then
		self.stateFSM:DeleteMe()
		self.stateFSM = nil
	end
end