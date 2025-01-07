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
	if not BehaviorFunctions.CheckEntity(self.MonsterCommonParam.battleTarget) or BehaviorFunctions.HasBuffKind(self.MonsterCommonParam.me,5003) then
		return
	end

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
					if monsterList[k] ~= self.MonsterCommonParam.me then
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
			if (math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MonsterCommonParam.me))) <= 30
					and math.abs(BehaviorFunctions.GetPosAngleWithCamera(self.posCheck[i].x, self.posCheck[i].y, self.posCheck[i].z)) > 30) then
				if i == 2 or i == 3 then
				----如果怪物在相机外，会更远离相机朝向，则该方向不可行走
				--or (math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MonsterCommonParam.me))) > 22.5
				--and math.abs(BehaviorFunctions.GetPosAngleWithCamera(self.posCheck[i].x, self.posCheck[i].y, self.posCheck[i].z)) > math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MonsterCommonParam.me)))) then
					isOutOfCamera = 1
				end
			end
				
			local isAwayFromCamera = 0
			--如果怪物在相机外，如果在左边，那不能右走；如果在右边，那不能左走
			if math.abs(BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MonsterCommonParam.me))) > 30 then
				--在左边
				if BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MonsterCommonParam.me)) < 0 then
					if i == 2 then
						isAwayFromCamera = 1
					end
				--在右边
				elseif BehaviorFunctions.GetPosAngleWithCamera(BehaviorFunctions.GetPosition(self.MonsterCommonParam.me)) > 0 then
					if i == 3 then
						isAwayFromCamera = 1
					end
				end	
			end
	
			if not self.MonsterCommonParam.isFly and layer~=nil and hight~=nil and hight>3
				or layer==FightEnum.Layer.Water
				or layer==FightEnum.Layer.Marsh
				or BehaviorFunctions.CheckObstaclesBetweenPos(self.MonsterCommonParam.myPos,self.posCheck[i])
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
		if self.MonsterCommonParam.initialShortRange == 0 then
			self.MonsterCommonParam.initialShortRange = self.MonsterCommonParam.shortRange
		end
		if self.MonsterCommonParam.initialLongRange == 0 then
			self.MonsterCommonParam.initialLongRange = self.MonsterCommonParam.longRange
		end
		
		if self.MonsterCommonParam.attackRange == 1 then
			if self.MonsterCommonParam.isAggressive == 1 then
				self.MonsterCommonParam.shortRange = self.MonsterCommonParam.initialShortRange
				self.MonsterCommonParam.longRange = self.MonsterCommonParam.initialLongRange
			elseif self.MonsterCommonParam.isAggressive == 0 then
				self.MonsterCommonParam.shortRange = 8
				self.MonsterCommonParam.longRange = 12
			end
			--elseif self.MonsterCommonParam.attackRange == 2 then
			--if self.MonsterCommonParam.isAggressive == 1 then
			--self.MonsterCommonParam.shortRange = 8
			--self.MonsterCommonParam.longRange = 12
			--self.MonsterCommonParam.minRange = 6
			--elseif self.MonsterCommonParam.isAggressive == 0 then
			--self.MonsterCommonParam.shortRange = 15
			--self.MonsterCommonParam.longRange = 20
			--end
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
				or (math.abs (self.MonsterCommonParam.myPos.y-battleTargetPos.y) > self.MonsterCommonParam.warnLimitHeight
					and BehaviorFunctions.GetEntityState(self.MonsterCommonParam.battleTarget) ~= FightEnum.EntityState.Jump)
				and not self.MonsterCommonParam.isFly then
				self.MonsterCommonParam.cannotWander=true
				--不存在障碍
			else
				self.MonsterCommonParam.cannotWander= false
				--无障碍时，给移动组件设置目标位置
				if self.MonsterCommonParam.battleTarget and BehaviorFunctions.IsFlyEntity(self.MonsterCommonParam.me) then
					BehaviorFunctions.SetFlyMoveTarget(self.MonsterCommonParam.me, self.MonsterCommonParam.battleTarget)
				end
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


			--发呆时敌方脱离视野
			if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) == FightEnum.EntityState.Idle
				and self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.Wander then
				if self.inVision == false and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then

					--近中距离根据角度选择左走或者右走
					--if self.battleRange == self.BattleRangeEnum.Mid or self.battleRange == self.BattleRangeEnum.Short then
					if BehaviorFunctions.CheckEntityAngleRange(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,180) then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
					elseif BehaviorFunctions.CheckEntityAngleRange(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,180,360) then
						BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
					end
					--end
					--发呆时敌方在视野内
				elseif self.inVision == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
					--近距离后退
					if self.MonsterCommonParam.battleTargetDistance < self.MonsterCommonParam.minRange then
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.WalkBack
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
						--远距离就跑步追击
					elseif self.battleRange == self.BattleRangeEnum.Long then
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
				end
				
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
					if self.MonsterCommonParam.myState ==  FightEnum.EntityState.Move then --and self.inVision == false
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
						--针对怪物稍微走出一点点中距离，就马上往前走几帧又切wander的抽搐表现，暂时用前走的cd来进行保护，最好独立定义一个时间by李伟越
						self.walkSwitchFrame = self.MonsterCommonParam.myFrame + 0.5 * 30
				end
				--处于中距离，左右游荡或发呆
				if self.battleRange == self.BattleRangeEnum.Mid then
					if self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.Wander 
						--如果一个怪没有攻击性，或没有技能可释放，那么跑到中距离必须切游荡，如果有攻击性，且有技能可释放
						and ((self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunForward
						and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunAndHit)
						or self:skilljudge() == false
						or self.MonsterCommonParam.isAggressive == 0) then
						self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Wander
						self.RunToWander = true
					end

					if self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.Wander and self.MonsterCommonParam.myFrame >= self.walkSwitchFrame then 
						if self:skilljudge() and self.MonsterCommonParam.isAggressive == 1 and self.MonsterCommonParam.CanCastSkill then
							if self.inVision == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
								--要放的技能在前面就往前走
								self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.WalkForward
								self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30

							end
						else

							--判断角度，若在视野范围内则随机前、左、右移动或原地短暂发呆
							if self.MonsterCommonParam.canLRWalk == true then
								if self.inVision == true and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me)then
									local a={1,2,3}  --,4
									if self.direactionDisable[3]~=nil or BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) == 6 then
										a[1]=nil
									end
									if self.direactionDisable[2]~=nil or BehaviorFunctions.GetSubMoveState(self.MonsterCommonParam.me) == 7 then
										a[2]=nil
									end
									if self.direactionDisable[1]~=nil or self:skilljudge() == false then
										a[4]=nil
									end
									--如果是通过追击/跑步进来的，无法待机或前走
									if self.RunToWander == true or BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me) == FightEnum.EntityState.Idle then
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
										BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
										self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
										--右
									elseif R == 2 then
										BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
										self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
										--待机
									elseif R == 3 then
										if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)~= FightEnum.EntityState.Idle then
											BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
										end
										self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.walkDazeTime * 30
										--前
										--elseif R == 4 then
										--BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.Walk)
										--self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.switchDelayTime * 30
										--end
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
								else
									--不能左右走就发呆
									if BehaviorFunctions.GetEntityState(self.MonsterCommonParam.me)~= FightEnum.EntityState.Idle then
										BehaviorFunctions.DoSetEntityState(self.MonsterCommonParam.me,FightEnum.EntityState.Idle)
									end
									self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.walkDazeTime * 30

								end
							end
						end
					end
				end
				--处于近距离，后退
				if self.battleRange == self.BattleRangeEnum.Short and self.MonsterCommonParam.myFrame > self.walkSwitchFrame and self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.RunAndHit then
					--如果后面被堵住就待机
					if self.direactionDisable[4] ~= nil then
						if self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.Default then
							self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
						elseif 	self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.Default and self.inVision == false then
							if BehaviorFunctions.CheckEntityAngleRange(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,0,180) then
								BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkLeft)
								self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
								self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Wander
							elseif BehaviorFunctions.CheckEntityAngleRange(self.MonsterCommonParam.me,self.MonsterCommonParam.battleTarget,180,360) then
								BehaviorFunctions.DoSetMoveType(self.MonsterCommonParam.me,FightEnum.EntityMoveSubState.WalkRight)
								self.walkSwitchFrame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.LRWalkSwitchTime * 30
								self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Wander
							end	
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
				--走/跑进极限近身距离,放追击技能或后退
				if self.MonsterCommonParam.battleTargetDistance < self.MonsterCommonParam.minRange then
					if self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.RunAndHit or self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.WalkForward
						or self.MonsterCommonParam.moveState == self.MonsterCommonParam.MoveStateEnum.RunForward then
						--有CD就放追击技能
						local skill = self:SerchSkillList(self.MonsterCommonParam.defaultSkillId,self.MonsterCommonParam.currentSkillList)
						if skill and self.MonsterCommonParam.currentSkillList[skill].frame < self.MonsterCommonParam.myFrame and self.MonsterCommonParam.haveRunAndHit then
							BehaviorFunctions.CastSkillByTarget(self.MonsterCommonParam.me,self.MonsterCommonParam.defaultSkillId,self.MonsterCommonParam.battleTarget) --放追杀技能
							self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default --切换回默认状态
							self:SetSkillFrame(self.MonsterCommonParam.defaultSkillId) --加默认技能CD
						else
							if self.MonsterCommonParam.moveState ~= self.MonsterCommonParam.MoveStateEnum.WalkBack and self.direactionDisable[4] ~= nil then
								self.MonsterCommonParam.moveState = self.MonsterCommonParam.MoveStateEnum.Default
							end
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

--根据id查找列表中对应id的技能的列表下标
function MonsterWander:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--修改技能frame值
function MonsterWander:SetSkillFrame(skillId)
	--找到这个技能
	local i = self:SerchSkillList(skillId,self.MonsterCommonParam.currentSkillList)
	--修改frame值4
	self.MonsterCommonParam.currentSkillList[i].frame = self.MonsterCommonParam.myFrame + self.MonsterCommonParam.initialSkillList[i].cd*30
end

--中近距离是否有技能可放
function MonsterWander:skilljudge()
	if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default
		and self.MonsterCommonParam.currentSkillList and next(self.MonsterCommonParam.currentSkillList) 
		and self.MonsterCommonParam.CanCastSkill == true then
		--判断有没有技能可以释放

		for num = 1,#self.MonsterCommonParam.currentSkillList,1 do
			local judgeState = 0
			--条件1：是否自动释放
			if judgeState == 0 then
				if self.MonsterCommonParam.currentSkillList[num].isAuto == true then
					judgeState = 1
				end
			end
			--条件2：CD判断
			if judgeState == 1 then
				if self.MonsterCommonParam.currentSkillList[num].frame < self.MonsterCommonParam.myFrame then
					judgeState = 2
				end
			end
			--条件3：距离判断
			if judgeState == 2 then
				--向前走可以放技能
				if self.MonsterCommonParam.battleTargetDistance > self.MonsterCommonParam.currentSkillList[num].minDistance
					and self.MonsterCommonParam.battleTargetDistance > self.MonsterCommonParam.currentSkillList[num].maxDistance then
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
				if self.MonsterCommonParam.haveSkillLifeRatio then
					if self.MonsterCommonParam.LifeRatio > self.MonsterCommonParam.currentSkillList[num].minLifeRatio and
						self.MonsterCommonParam.LifeRatio <= self.MonsterCommonParam.currentSkillList[num].maxLifeRatio then
						judgeState = 4
					end
				else
					judgeState = 4
				end
			end
			--条件5：目标受击判断
			if judgeState == 4  then
				if self.MonsterCommonParam.currentSkillList[num].canCastSkillWhenTargetInHit == true then
					judgeState = 5
				else
					if self.MonsterCommonParam.targetInHit == false then
						judgeState = 5
					end
				end
			end
			--条件6：特殊条件判断
			if judgeState == 5  then
				if not self.MonsterCommonParam.mySpecialState
					or (self.MonsterCommonParam.mySpecialState
						and self.MonsterCommonParam.currentSkillList[num].specialState==self.MonsterCommonParam.mySpecialState) then
					judgeState = 6
				end
			end
			--条件7：分级技能判断，属于群组ai
			if judgeState == 6 then
				--处理配置为空的保底
				if not self.MonsterCommonParam.currentSkillList[num].grade then
					self.MonsterCommonParam.currentSkillList[num].grade = 1
				end
				--为低等级技能，或者高等级技能但是不在公共冷却，可以释放
				if self.MonsterCommonParam.currentSkillList[num].grade <= 9
					or (self.MonsterCommonParam.currentSkillList[num].grade > 9 and not BehaviorFunctions.HasEntitySign(1,10000034)) then
					judgeState = 7
					self.judge = true
				end
			end
			----条件8：所有近战怪物共同的释放冷却，属于群组ai
			--if judgeState == 7 then
				----为非战斗技能，或者是战斗技能但是不在共同冷却，可以释放
				--if self.MonsterCommonParam.currentSkillList[num].grade <= 4
					--or (self.MonsterCommonParam.currentSkillList[num].grade > 4 and not BehaviorFunctions.HasEntitySign(1,10000038)) then
					--judgeState = 8
					--self.judge = true
				--end
			--end

			if num == #self.MonsterCommonParam.currentSkillList then
				if self.judge == true then
					if self.MonsterCommonParam.skillState == self.MonsterCommonParam.SkillStateEnum.Default then
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