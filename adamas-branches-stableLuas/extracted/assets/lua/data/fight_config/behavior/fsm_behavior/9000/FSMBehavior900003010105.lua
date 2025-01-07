FSMBehavior900003010105 = BaseClass("FSMBehavior900003010105",FSMBehaviorBase)
--战斗游荡中距离游荡状态


function FSMBehavior900003010105.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900003010105:Init()
	self.posCheck={}
	self.direactionDisable={}
end

function FSMBehavior900003010105:Update()
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		--前
		self.posCheck[1]=BehaviorFunctions.GetPositionOffsetBySelf(self.MainBehavior.me,2,0)
		--右
		self.posCheck[2]=BehaviorFunctions.GetPositionOffsetBySelf(self.MainBehavior.me,2,90)
		--左
		self.posCheck[3]=BehaviorFunctions.GetPositionOffsetBySelf(self.MainBehavior.me,2,270)
		--后
		self.posCheck[4]=BehaviorFunctions.GetPositionOffsetBySelf(self.MainBehavior.me,2,180)
		for i=1,4 do
			self.posCheck[i].y =self.posCheck[i].y +0.2
			local hight,layer=BehaviorFunctions.CheckPosHeight(self.posCheck[i])

			--怪物左右移动后如果会进入别的怪物领域，那么该方向不可行走(临时参数比较多，写的比较丑，待优化)
			local monsterList = BehaviorFunctions.GetAllFightTarget()
			if monsterList and next(monsterList) then
				--倒序遍历，提前删除掉已经死掉的实体
				for k = #monsterList, 1, -1 do
					if not BehaviorFunctions.CheckEntity(monsterList[k]) then
						table.remove(monsterList, k)
					end
				end
				local isInOtherRange = 0
				for k = 1, #monsterList do
					if monsterList[k] ~= self.MainBehavior.me then
						local monsterDistance = BehaviorFunctions.GetDistanceFromPos(self.posCheck[i],BehaviorFunctions.GetPositionP(monsterList[k]))
						local otherMonsterRangeRadius = BehaviorFunctions.GetEntityValue(monsterList[k],"monsterRangeRadius")
						if monsterDistance and otherMonsterRangeRadius and monsterDistance <= otherMonsterRangeRadius and (i == 2 or i == 3) then
							isInOtherRange = 1
							break
						end
					end
				end
			end

			local isOutOfCamera = 0
			--如果怪物在相机内，会走出相机外，则该方向不可行走
			if (math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MainBehavior.me))) <= 30
					and math.abs(BehaviorFunctions.GetPosAngleWithCamera(self.posCheck[i].x, self.posCheck[i].y, self.posCheck[i].z)) > 30) then
				if i == 2 or i == 3 then
					----如果怪物在相机外，会更远离相机朝向，则该方向不可行走
					--or (math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MainBehavior.me))) > 22.5
					--and math.abs(BehaviorFunctions.GetPosAngleWithCamera(self.posCheck[i].x, self.posCheck[i].y, self.posCheck[i].z)) > math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MainBehavior.me)))) then
					isOutOfCamera = 1
				end
			end

			local isAwayFromCamera = 0
			--如果怪物在相机外，如果在左边，那不能右走；如果在右边，那不能左走
			if math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MainBehavior.me))) > 30 then
				--在左边
				if BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MainBehavior.me)) < 0 then
					if i == 2 then
						isAwayFromCamera = 1
					end
					--在右边
				elseif BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MainBehavior.me)) > 0 then
					if i == 3 then
						isAwayFromCamera = 1
					end
				end
			end

			if not self.MainBehavior.isFly and layer~=nil and hight~=nil and hight>3
				or layer==FightEnum.Layer.Water
				or layer==FightEnum.Layer.Marsh
				or BehaviorFunctions.CheckObstaclesBetweenPos(self.MainBehavior.myPos,self.posCheck[i])
				or isInOtherRange == 1
				or isOutOfCamera == 1
				or isAwayFromCamera == 1 then
				self.direactionDisable[i]=i --每帧判断不能行走的方向。
			else
				if self.direactionDisable[i]~=nil then
					self.direactionDisable[i]=nil  --用于把以前不能行走，现在可以行走的区域删掉。
				end
			end

		end

		--攻击性决定游荡范围,目前只处理近战怪物，远程先搁置看效果需求
		--记录下怪物初始的游荡范围
		if self.MainBehavior.initialShortRange == 0 then
			self.MainBehavior.initialShortRange = self.MainBehavior.shortRange
		end
		if self.MainBehavior.initialLongRange == 0 then
			self.MainBehavior.initialLongRange = self.MainBehavior.longRange
		end

		if self.MainBehavior.attackRange == 1 then
			if self.MainBehavior.isAggressive == 1 then
				self.MainBehavior.shortRange = self.MainBehavior.initialShortRange
				self.MainBehavior.longRange = self.MainBehavior.initialLongRange
			elseif self.MainBehavior.isAggressive == 0 then
				self.MainBehavior.shortRange = 8
				self.MainBehavior.longRange = 12
			end
			--elseif self.MainBehavior.attackRange == 2 then
			--if self.MainBehavior.isAggressive == 1 then
			--self.MainBehavior.shortRange = 8
			--self.MainBehavior.longRange = 12
			--self.MainBehavior.minRange = 6
			--elseif self.MainBehavior.isAggressive == 0 then
			--self.MainBehavior.shortRange = 15
			--self.MainBehavior.longRange = 20
			--end
		end
		
		--发呆时敌方脱离视野
		if BehaviorFunctions.GetEntityState(self.MainBehavior.me) == FightEnum.EntityState.Idle then
			if self.ParentBehavior.inVision == false and BehaviorFunctions.CanCtrl(self.MainBehavior.me) then

				--近中距离根据角度选择左走或者右走
				--if self.battleRange == self.ParentBehavior.BattleRangeEnum.Mid or self.battleRange == self.ParentBehavior.BattleRangeEnum.Short then
				if BehaviorFunctions.CheckEntityAngleRange(self.MainBehavior.me,self.MainBehavior.battleTarget,0,180) then
					BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkLeft)
					self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
				elseif BehaviorFunctions.CheckEntityAngleRange(self.MainBehavior.me,self.MainBehavior.battleTarget,180,360) then
					BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkRight)
					self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
				end
				--end
				--发呆时敌方在视野内
			--elseif self.ParentBehavior.inVision == true and BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
				----近距离后退
				--if self.MainBehavior.battleTargetDistance < self.MainBehavior.minRange then
					--self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.WalkBack
					--self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.switchDelayTime * 30
					----远距离就跑步追击
				--elseif self.battleRange == self.ParentBehavior.BattleRangeEnum.Long then
					--if self.MainBehavior.canRun then
						--if self.MainBehavior.haveRunAndHit
							--and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunAndHit then
							--self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.RunAndHit
						--elseif self.MainBehavior.haveRunAndHit == false
							--and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunForward then
							--self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.RunForward
						--end
					--elseif self.MainBehavior.canRun == false and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.WalkForward then
						--self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.WalkForward
					--end
				--end
			end
		end
		
		
		--处于中距离，左右游荡或发呆
		if self.ParentBehavior.battleRange == self.ParentBehavior.BattleRangeEnum.Mid then
			if self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.Wander then
				----如果一个怪没有攻击性，那么跑到中距离必须切游荡，如果有攻击性，则可以持续奔跑
				--and ((self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunForward
				--and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunAndHit)
				--or self.MainBehavior.isAggressive == 0) then
				--注意！！！临时处理，因为现在怪物跑到近距离有瞬移bug，所以临时改成只要进游荡范围必然游荡
				self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.Wander
				self.RunToWander = true
			end

			if self.ParentBehavior.moveState == self.ParentBehavior.MoveStateEnum.Wander and self.MainBehavior.myFrame >= self.ParentBehavior.walkSwitchFrame then
				if self:skilljudge() and self.MainBehavior.isAggressive == 1 and self.MainBehavior.CanCastSkill then
					if self.ParentBehavior.inVision == true and BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
						--要放的技能在前面就往前走
						self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.WalkForward
						self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.switchDelayTime * 30

					end
				else

					--判断角度，若在视野范围内则随机前、左、右移动或原地短暂发呆
					if self.MainBehavior.canLRWalk == true then
						if self.ParentBehavior.inVision == true and BehaviorFunctions.CanCtrl(self.MainBehavior.me)then
							local a={1,2,3}  --,4
							if self.direactionDisable[3]~=nil or BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) == 6 then
								a[1]=nil
							end
							if self.direactionDisable[2]~=nil or BehaviorFunctions.GetSubMoveState(self.MainBehavior.me) == 7 then
								a[2]=nil
							end
							if self.direactionDisable[1]~=nil or self:skilljudge() == false then
								a[4]=nil
							end
							--如果是通过追击/跑步进来的，无法待机或前走
							if self.RunToWander == true or BehaviorFunctions.GetEntityState(self.MainBehavior.me) == FightEnum.EntityState.Idle then
								if not (a[1]==nil and a[2]==nil) then
									a[3]=nil
								end
								--a[4]=nil
								self.RunToWander = false
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
								BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkLeft)
								self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
								--右
							elseif R == 2 then
								BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkRight)
								self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
								--待机
							elseif R == 3 then
								if BehaviorFunctions.GetEntityState(self.MainBehavior.me)~= FightEnum.EntityState.Idle then
									BehaviorFunctions.DoSetEntityState(self.MainBehavior.me,FightEnum.EntityState.Idle)
								end
								self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.walkDazeTime * 30
								--前
								--elseif R == 4 then
								--BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.Walk)
								--self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.switchDelayTime * 30
								--end
								--不在视野范围内根据战斗目标位置决定左走或右走
							else
								if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
									if BehaviorFunctions.CheckEntityAngleRange(self.MainBehavior.me,self.MainBehavior.battleTarget,0,180) then
										BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkLeft)
										self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
									elseif BehaviorFunctions.CheckEntityAngleRange(self.MainBehavior.me,self.MainBehavior.battleTarget,180,360) then
										BehaviorFunctions.DoSetMoveType(self.MainBehavior.me,FightEnum.EntityMoveSubState.WalkRight)
										self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.LRWalkSwitchTime * 30
									end
								end
							end
						else
							--不能左右走就发呆
							if BehaviorFunctions.GetEntityState(self.MainBehavior.me)~= FightEnum.EntityState.Idle then
								BehaviorFunctions.DoSetEntityState(self.MainBehavior.me,FightEnum.EntityState.Idle)
							end
							self.ParentBehavior.walkSwitchFrame = self.MainBehavior.myFrame + self.MainBehavior.walkDazeTime * 30

						end
					end
				end
			end
		end
		BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
	end
end

--中近距离是否有技能可放
function FSMBehavior900003010105:skilljudge()
	if self.MainBehavior.currentSkillList and next(self.MainBehavior.currentSkillList)
		and self.MainBehavior.CanCastSkill == true then
		--判断有没有技能可以释放

		for num = 1,#self.MainBehavior.currentSkillList,1 do
			local judgeState = 0
			--条件1：是否自动释放
			if judgeState == 0 then
				if self.MainBehavior.currentSkillList[num].isAuto == true then
					judgeState = 1
				end
			end
			--条件2：CD判断
			if judgeState == 1 then
				if self.MainBehavior.currentSkillList[num].frame < self.MainBehavior.myFrame then
					judgeState = 2
				end
			end
			--条件3：距离判断
			if judgeState == 2 then
				--向前走可以放技能
				if self.MainBehavior.battleTargetDistance > self.MainBehavior.currentSkillList[num].minDistance
					and self.MainBehavior.battleTargetDistance > self.MainBehavior.currentSkillList[num].maxDistance then
					--if self.judgeDis == 2 then
					--self.judgeDis = 3
					--elseif self.judgeDis == nil then
					--self.judgeDis = 1
					--end
					judgeState = 3
				end

			end
			--条件4：血量判断
			if judgeState == 3 then
				if self.MainBehavior.haveSkillLifeRatio then
					if self.MainBehavior.LifeRatio > self.MainBehavior.currentSkillList[num].minLifeRatio and
						self.MainBehavior.LifeRatio <= self.MainBehavior.currentSkillList[num].maxLifeRatio then
						judgeState = 4
					end
				else
					judgeState = 4
				end
			end
			--条件5：目标受击判断
			if judgeState == 4  then
				if self.MainBehavior.currentSkillList[num].canCastSkillWhenTargetInHit == true then
					judgeState = 5
				else
					if self.MainBehavior.targetInHit == false then
						judgeState = 5
					end
				end
			end
			--条件6：特殊条件判断
			if judgeState == 5  then
				if not self.MainBehavior.mySpecialState
					or (self.MainBehavior.mySpecialState
						and self.MainBehavior.currentSkillList[num].specialState==self.MainBehavior.mySpecialState) then
					judgeState = 6
					self.judge = true
				end
			end

			if num == #self.MainBehavior.currentSkillList then
				if self.judge == true then
					if self.ParentBehavior.ParentBehavior.ParentBehavior.skillState == self.ParentBehavior.ParentBehavior.ParentBehavior.skillStateEnum.Default then
						self.judge = false
						return true
					else
						self.judge = false
						--self.judgeDis = nil
						return false
					end
				else
					self.judge = false
					--self.judgeDis = nil
					return false
				end
			end
		end
	else
		self.judge = false
		return false
	end
end