MonsterWander = BaseClass("MonsterWander",EntityBehaviorBase)
--战斗游荡

function MonsterWander:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam

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
	self.hitSkillFrame = 0
	self.posCheck={}
	self.direactionDisable={}
end

function MonsterWander:Update()


	if self.MonsterCommonParam.inFight == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
		--前
		self.posCheck[1]=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,0)
		--右 
		self.posCheck[2]=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,90)
		--左
		self.posCheck[3]=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,270)
		--后
		self.posCheck[4]=BehaviorFunctions.GetPositionOffsetBySelf(self.MonsterCommonParam.me,2,180)
		for i=1,4 do
			self.posCheck[i].y =self.posCheck[i].y +0.2
			local hight,layer=BehaviorFunctions.CheckPosHeight(self.posCheck[i])
			if layer~=nil and hight~=nil and hight>3
				or layer==FightEnum.Layer.Water
				or layer==FightEnum.Layer.Marsh
				or layer==FightEnum.Layer.Lava
				or layer==FightEnum.Layer.Driftsand 
				or BehaviorFunctions.CheckObstaclesBetweenPos(self.MonsterCommonParam.myPos,self.posCheck[i]) then
				self.direactionDisable[i]=i --每帧判断不能行走的方向。
			else
				if self.direactionDisable[i]~=nil then
					self.direactionDisable[i]=nil  --用于把以前不能行走，现在可以行走的区域删掉。
				end

			end
		end
		--区域判断
		if self.MonsterCommonParam.battleTargetDistance < self.MonsterCommonParam.shortRange then
			self.battleRange = self.BattleRangeEnum.Short
		elseif self.MonsterCommonParam.battleTargetDistance > self.MonsterCommonParam.longRange and self.MonsterCommonParam.battleTargetDistance < self.MonsterCommonParam.maxRange then
			self.battleRange = self.BattleRangeEnum.Long
		elseif self.MonsterCommonParam.battleTargetDistance >=self.MonsterCommonParam.maxRange then
			self.battleRange = self.BattleRangeEnum.Far
		else
			self.battleRange = self.BattleRangeEnum.Mid
		end
		--游荡逻辑
		--没有技能可放，进入游荡
		if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default
			or self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.InCommonCd then
			if BehaviorFunctions.GetSkill(self.MonsterCommonParam.me) > 0 and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
				BehaviorFunctions.BreakSkill(self.MonsterCommonParam.me)
			end

			--角色实体坐标
			local battleTargetPos = BehaviorFunctions.GetPositionP(self.MonsterCommonParam.battleTarget)
			

			--检查怪物和角色之间是否存在障碍
			if BehaviorFunctions.CheckObstaclesBetweenEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,false)
				or (math.abs (self.MonsterCommonParam.myPos.y-battleTargetPos.y) > 2
					and BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) ~= FightEnum.EntityState.Jump) then
				self.MonsterCommonParam.cannotWander=true
				--不存在障碍
			else
				self.MonsterCommonParam.cannotWander= false
			end

			--当无障碍时，关闭寻路状态
			if self.MonsterCommonParam.cannotWander == false and self.MonsterCommonParam.pathFindKey==false then
				BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
				self.MonsterCommonParam.pathFindKey = true
			end

			if self.MonsterCommonParam.cannotWander == true
				and self.MonsterCommonParam.pathFindKey == true
				and self.MonsterCommonParam.inFight == true
				and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
				BehaviorFunctions.CancelLookAt(self.MonsterCommonParam.me)

				BehaviorFunctions.SetPathFollowEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)
				if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run then
					BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
				end
				self.MonsterCommonParam.pathFindKey = false
			end

			if self.MonsterCommonParam.cannotWander == false then
				--moveSubState设置
				if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
					if self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.WalkForward then
						if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Walk then
							BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Walk)
						end
					elseif self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.RunForward or self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.RunAndHit then
						if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.Run then
							BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Run)
						end
					elseif self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.WalkBack then
						if BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) ~= FightEnum.EntityMoveSubState.WalkBack then
							BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkBack)
						end
					elseif self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.Default then
						if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)~= FightEnum.EntityState.Idle then
							BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
						end
					end
				end


				--转向逻辑
				if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
					--在视野中
					if BehaviorFunctions.CompEntityLessAngle(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,self.MonsterCommonParam.visionAngle/2) then
						self.inVision = true
						--不在则进行转向
					else
						self.inVision = false
						--BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,60,-2)
					end
					if self.MonsterCommonParam.myState ==  FightEnum.EntityState.Move or self.inVision == false then
						BehaviorFunctions.DoLookAtTargetByLerp(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,true,0,180,-2)
					end
				end
				--处于超远距离，有跑步进入RunAndHit状态，无跑步向前走
				if self.battleRange == self.BattleRangeEnum.Far and self.MonsterCommonParam.myFrame >= self.walkSwitchFrame then
					if self.MonsterCommonParam.canRun then
						if self.MonsterCommonParam.haveRunAndHit
							and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunAndHit then
							self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.RunAndHit
						elseif self.MonsterCommonParam.haveRunAndHit == false
							and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunForward then
							self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.RunForward
						end
					elseif self.MonsterCommonParam.canRun == false and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.WalkForward then
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.WalkForward
					end
				end
				--处于远距离，有跑步，向前跑(RunForward)；无跑步，向前走(WalkForward)
				if self.battleRange == self.BattleRangeEnum.Long and self.MonsterCommonParam.myFrame >= self.walkSwitchFrame then
					if self.MonsterCommonParam.canRun
						and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunAndHit
						and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunForward then
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.RunForward
					elseif self.MonsterCommonParam.canRun == false and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.WalkForward then
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.WalkForward
					end
				end
				--处于中距离，左右游荡或发呆
				if self.battleRange == self.BattleRangeEnum.Mid then
					if self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.Wander
						and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunForward
						and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunAndHit then
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Wander
					end
					if self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.Wander and self.MonsterCommonParam.myFrame >= self.walkSwitchFrame then
						--判断角度，若在视野范围内则随机前、左、右移动或原地短暂发呆
						if self.MonsterCommonParam.canLRWalk == true then
							if self.inVision == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me)then
								local a={1,2,3,4}
								if self.direactionDisable[3]~=nil then
									a[1]=nil
								end
								if self.direactionDisable[2]~=nil then
									a[2]=nil
								end
								if self.direactionDisable[1]~=nil then
									a[4]=nil
								end
								local b={}
								for k,v in pairs(a) do
									if v~=nil then
										table.insert(b,v)
									end
								end
								local i=math.random(1,#b)
								local R=b[i]
								--左
								if R == 1 then
									BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
									self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
								--右	
								elseif R == 2 then
									BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
									self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
								--待机	
								elseif R == 3 then
									BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
									self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.walkDazeTime * 30
								--前	
								elseif R == 4 then
									BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Walk)
									self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
								end
								--不在视野范围内根据战斗目标位置决定左走或右走
							else
								if BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
									if BehaviorFunctions.CheckEntityAngleRange(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,180) then
										BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
										self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
									elseif BehaviorFunctions.CheckEntityAngleRange(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,180,360) then
										BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
										self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
									end
								end
							end
							--不能左右走就发呆或者往前走
						else
							local R = BehaviorFunctions.RandomSelect(1,2)
							if R == 1 then
								BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Walk)
								self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30

							elseif R == 2 then
								BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
								self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.walkDazeTime * 30
							end
						end
					end
				end
				--处于近距离，后退
				if self.battleRange == self.BattleRangeEnum.Short and self.MonsterCommonParam.myFrame > self.walkSwitchFrame then
					if self.direactionDisable[4]~=nil then
						if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)~= FightEnum.EntityState.Idle then
							BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
						end
					else
						if self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.WalkBack
							and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunForward
							and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunAndHit  then
							self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.WalkBack
							self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
						end
					end

				end
				--小于极限近身距离,放追击技能或后退
				if self.MonsterCommonParam.battleTargetDistance < self.MonsterCommonParam.minRange then
					if self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.RunAndHit then
						BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.defaultSkillId,self.MonsterCommonParam.battleTarget)
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
					else
						if self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.WalkBack then
							self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
						end
					end
				end

			end

		end
	end
end


function MonsterWander:PathFindingEnd(instanceId,result)
	if instanceId == self.MonsterCommonParam.me then
		if result == true then
			self:StopPathFind()
		else
			--因为异常结束
			self.MonsterCommonParam.pathFindKey = true
			local state = BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget)
			if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) ~= FightEnum.EntityState.Fall
				and BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) ~= FightEnum.EntityState.Jump then
				self:StopPathFind()
			end
			--当角色在跳的时候，寻路到角色脚下的点
			if BehaviorFunctions.SetPathFollowEntity(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget)==false
				and (BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) == FightEnum.EntityState.Fall
					or BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) == FightEnum.EntityState.Jump) then
				local pos =BehaviorFunctions.GetPositionP(self.MonsterCommonParam.battleTarget)
				local h,layer=BehaviorFunctions.CheckPosHeight(pos)
				local pos2 = {["x"]=pos.x,["y"]=pos.y-h,["z"]=pos.z}
				BehaviorFunctions.SetPathFollowPos(self.MonsterCommonParam.battleTarget,pos2)
			end
		end
	end
end

function MonsterWander:StopPathFind()
	BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
	BehaviorFunctions.ClearPathFinding(self.MonsterCommonParam.me)
	self.MonsterCommonParam.pathFindKey = true
end







