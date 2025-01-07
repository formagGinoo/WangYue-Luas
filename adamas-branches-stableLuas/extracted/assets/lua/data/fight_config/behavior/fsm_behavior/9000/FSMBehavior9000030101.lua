FSMBehavior9000030101 = BaseClass("FSMBehavior9000030101",FSMBehaviorBase)
--战斗游荡状态


function FSMBehavior9000030101.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior9000030101:Init()
	self.inVision = false                                                   --是否在视野内
	self.battleRange = 0 			                                        --游荡分区
	self.BattleRangeEnum = {                                                --游荡分区枚举
		Default = 0,
		Short = 1,
		Mid = 2,
		Long = 3,
		Far = 4
	}
	self.walkSwitchFrame = 0

	self.moveState = 0                                                      --移动状态
	self.MoveStateEnum = {                                                  --移动状态枚举
		Default = 0,--默认
		Wander = 1,--游荡
		WalkForward = 2,--远距离前走
		RunForward = 3,--远距离前跑
		WalkBack = 4,--近距离后退
		RunAndHit = 5,--超远距离跑打
	}
	self.cannotWander = false
	self.canWalkBack = false
end

function FSMBehavior9000030101:Update()
	if not BehaviorFunctions.CheckEntity(self.MainBehavior.battleTarget) or BehaviorFunctions.HasBuffKind(self.MainBehavior.me,5003) then
		return
	end
	
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		
		local backPos = BehaviorFunctions.GetPositionOffsetBySelf(self.MainBehavior.me,2,180)
		backPos.y = backPos.y +0.2
		local hight,layer=BehaviorFunctions.CheckPosHeight(backPos)
		if not self.MainBehavior.isFly and layer~=nil and hight~=nil and hight>3
			or layer==FightEnum.Layer.Water
			or layer==FightEnum.Layer.Marsh
			or BehaviorFunctions.CheckObstaclesBetweenPos(self.MainBehavior.myPos,backPos) then
			self.canWalkBack = false
		else
			self.canWalkBack = true
		end
		
		--区域判断
		if self.MainBehavior.battleTargetDistance < self.MainBehavior.shortRange then
			self.battleRange = self.BattleRangeEnum.Short
		elseif self.MainBehavior.battleTargetDistance > self.MainBehavior.longRange and self.MainBehavior.battleTargetDistance < self.MainBehavior.maxRange then
			self.battleRange = self.BattleRangeEnum.Long
		elseif self.MainBehavior.battleTargetDistance >=self.MainBehavior.maxRange then
			self.battleRange = self.BattleRangeEnum.Far
		else
			self.battleRange = self.BattleRangeEnum.Mid
		end
		
		--游荡逻辑
		--没有技能可放，进入游荡
		if BehaviorFunctions.GetSkill(self.MainBehavior.me) > 0 and BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
			BehaviorFunctions.BreakSkill(self.MainBehavior.me)
		end
			
		--角色实体坐标
		local battleTargetPos = BehaviorFunctions.GetPositionP(self.MainBehavior.battleTarget)
		
		--检查怪物和角色之间是否存在障碍
		if BehaviorFunctions.CheckObstaclesBetweenEntity(self.MainBehavior.me,self.MainBehavior.battleTarget,false)
			or (math.abs (self.MainBehavior.myPos.y-battleTargetPos.y) > self.MainBehavior.warnLimitHeight
				and BehaviorFunctions.GetEntityState(self.MainBehavior.battleTarget) ~= FightEnum.EntityState.Jump)
			and not self.MainBehavior.isFly then
			self.cannotWander=true
			--不存在障碍
		else
			self.cannotWander= false
			--无障碍时，给移动组件设置目标位置
			if self.MainBehavior.battleTarget and BehaviorFunctions.IsFlyEntity(self.MainBehavior.me) then
				BehaviorFunctions.SetFlyMoveTarget(self.MainBehavior.me, self.MainBehavior.battleTarget)
			end
		end
			
		--当无障碍时，关闭寻路状态
		if self.cannotWander == false and self.MainBehavior.pathFindKey==false then
			BehaviorFunctions.ClearPathFinding(self.MainBehavior.me)
			self.MainBehavior.pathFindKey = true
		end
		
		if self.cannotWander == false then
			--moveSubState设置
			if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
				if self.moveState == self.MoveStateEnum.WalkForward then
					if BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) ~= FightEnum.EntityMoveSubState.Walk then
						BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Walk)
					end
				elseif self.moveState == self.MoveStateEnum.RunForward or self.moveState == self.MoveStateEnum.RunAndHit then
					if BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) ~= FightEnum.EntityMoveSubState.Run then
						BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Run)
					end
				elseif self.moveState == self.MoveStateEnum.WalkBack then
					if BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) ~= FightEnum.EntityMoveSubState.WalkBack then
						BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkBack)
					end
				elseif self.moveState == self.MoveStateEnum.Default then
					if BehaviorFunctions.GetEntityState(self.MainBehavior.me)~= FightEnum.EntityState.Idle then
						BehaviorFunctions.DoSetEntityState(self.MainBehavior.me,FightEnum.EntityState.Idle)
					end
				end
			end
			
			--转向逻辑
			if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
				--在视野中
				if BehaviorFunctions.CompEntityLessAngle(self.MainBehavior.me,self.MainBehavior.battleTarget,self.MainBehavior.visionAngle/2) then
					self.inVision = true
					--不在则进行转向
				else
					self.inVision = false
					--BehaviorFunctions.DoLookAtTargetByLerp(self.MainBehavior.me,self.MainBehavior.battleTarget,true,0,60,-2)
				end
				if self.MainBehavior.myState ==  FightEnum.EntityState.Move then --and self.inVision == false
					BehaviorFunctions.DoLookAtTargetByLerp(self.MainBehavior.me,self.MainBehavior.battleTarget,true,0,180,-2)
				end
			end
		end
	end		
end