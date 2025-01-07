Behavior999999 = BaseClass("Behavior999999",EntityBehaviorBase)
--资源预加载
function Behavior999999.GetGenerates()
	local generates = {}
	return generates
end



--声明怪物
function Behavior999999:Init()

	self.myState = 0
	self.me = self.instanceId
	self.timeStart = 0
	self.frame = 0
	self.RanderFrame = 0
	self.cd = 0
	self.FightState = 0


	--状态入口管理
	self.SkillState = 0
	self.WanderLRState = 0
	self.WanderFState = 0
	self.WanderBState = 0
	self.WalkState = 0
	self.RanderTime = 2.5
	self.RanderBTime = 2
	self.RanderBFrame = 2
	self.RanderSwitchTime = 1
	self.RanderSwitchState = 0
	self.RanderTFrame = 0	
	self.RanderSwitch = 0
	self.num = 0
end



function Behavior999999:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.angle = BehaviorFunctions.GetEntityAngle(self.me,self.role)
	self.myState = BehaviorFunctions.GetEntityState(self.me)
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.MoveState = BehaviorFunctions.GetSubMoveState(self.me)
	self.SkillId = BehaviorFunctions.GetSkill(self.role)
	--是否正在踱步
	if self.time > self.RanderFrame then
		self.WanderLRState = 0
	else
		self.WanderLRState = 1
	end
	

	self.distance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role,false)
	--if self.myState ~= FightEnum.EntityState.Idle then
		--if self.angle <= 90 and self.angle >= 270 then
			--BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.role,0,30,0,-2)
		--else
			--BehaviorFunctions.DoLookAtTargetByLerp(self.me,self.role,0,120,0,-2)
		--end
	--end
	--BehaviorFunctions.DoMagic(self.me,self.me,900000007)

	--if self.myState ~= FightEnum.EntityState.Idle then
		--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.Idle)
	--end
	--if BehaviorFunctions.GetSkillSign(self.me,92003010) then
		--BehaviorFunctions.CastSkillByTarget(self.me,92003003,self.role)
	--end
	if BehaviorFunctions.CanCtrl(self.me) then
		if self.SkillId == 1001030 or self.SkillId == 1001031 then
			BehaviorFunctions.CastSkillByTarget(self.me,92003216,self.role)
			
		end
		
		

		
		if self.distance < 15 then
				
				if self.myState ~= FightEnum.EntityState.FightIdle then
				  BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
				end
			
		--elseif self.distance < 5 and self.distance > 3 then
			
			
			--if self.MoveState ~= FightEnum.EntityMoveSubState.WalkBack then
			--BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkBack)
			--end
			
		--elseif self.distance <= 8 and self.distance > 5 then	
			--if self.time > self.RanderFrame then
				----self.RanderSwitch = 0
				----if self.RanderCheck == 0 then
					--local direction = math.random(3)
					--if direction == 1 then
						--BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
						--self.RanderFrame = self.time + self.RanderTime * 30
						----self.RanderSwitch = 1
					--elseif direction == 2 then
						--BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkLeft)
						--self.RanderFrame = self.time + self.RanderTime * 30
						----self.RanderSwitch = 2
					--elseif direction == 3 then
						--BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
						--self.RanderFrame = self.time + 30
				----else
					----if self.myState ~= FightEnum.EntityState.Idle then
						----BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
					----end
					--end
				--end
			----end
		--elseif self.distance <= 12 and self.distance > 8 then
			
			
			--if self.MoveState ~= FightEnum.EntityMoveSubState.Walk then
				--BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Walk)
			--end
			----if self.MoveState ~= FightEnum.EntityMoveSubState.WalkRight then
				----BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.WalkRight)
			----end
			
			
			----if self.myState ~= FightEnum.EntityState.FightIdle then
				----BehaviorFunctions.DoSetEntityState(self.me,FightEnum.EntityState.FightIdle)
			----end
		--elseif self.distance >= 12 then
		
			--if self.MoveState ~= FightEnum.EntityMoveSubState.Run then
				--BehaviorFunctions.DoSetMoveType(self.me,FightEnum.EntityMoveSubState.Run)
			
			--end
		--end
	end
	end
end

function Behavior999999:Collide()
		
end

function Behavior999999:DeathEnter(instanceId,isFormationRevive)
	if instanceId==self.me then
		BehaviorFunctions.DoMagic(instanceId,instanceId,900000008)
	end
end