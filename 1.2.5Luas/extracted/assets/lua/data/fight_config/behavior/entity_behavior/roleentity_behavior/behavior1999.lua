Behavior1999 = BaseClass("Behavior1999",EntityBehaviorBase)

local BF = BehaviorFunctions
local FEESI = FightEnum.EntityState.Idle
local FEESH = FightEnum.EntityState.Hit
local FEESS = FightEnum.EntityState.Skill

function Behavior1999:Init()
	self.xxxx = 1 -- 开启xxx
	--技能相关参数

	self.SkillGroup1Id = {1999001,1999002}	--技能组1编号
	self.SkillGroup1Distance = {2,2}		--技能组1释放距离
	self.SkillGroup1Angle = {15,20}			--技能组1释放角度
	self.SkillGroup1Cd = {6,7}				--技能组1冷却时间
	self.SkillGroup1CdFrame = {30,15}		--技能组1冷却帧数
	self.SkillGroup1Frame = {40,40}			--技能组1技能时间
	self.SkillGroup1Count = 2				--技能组1技能总数

	self.SkillGroup2Id = {1999003,1999004}	--技能组2编号
	self.SkillGroup2Distance = {0,2}		--技能组2释放距离
	self.SkillGroup2Angle = {15,20}			--技能组2释放角度
	self.SkillGroup2Cd = {7,8}				--技能组2冷却时间
	self.SkillGroup2CdFrame = {99999,60}	--技能组2冷却帧数
	self.SkillGroup2Frame = {40,40}			--技能组2技能时间
	self.SkillGroup2Count = 2				--技能组2技能总数

	self.GlobalSkillGroupId = {self.SkillGroup1Id,self.SkillGroup2Id}
	self.GlobalSkillGroupDistance = {self.SkillGroup1Distance,self.SkillGroup2Distance}
	self.GlobalSkillGroupAngle	= {self.SkillGroup1Angle,self.SkillGroup2Angle}
	self.GlobalSkillGroupCd = {self.SkillGroup1Cd,self.SkillGroup2Cd}
	self.GlobalSkillGroupCdFrame = {self.SkillGroup1CdFrame,self.SkillGroup2CdFrame}
	self.GlobalSkillGroupCount = {self.SkillGroup1Count,self.SkillGroup2Count}
	self.GlobalSkillGroupFrame = {self.SkillGroup1Frame,self.SkillGroup2Frame}
	self.GlobalSkillGroupSize = {2,2} 
	self.GlobalSkillForNum1 = 1
	self.GlobalSkillForNum2 = 1
	
	--自身各类参数、记录参数
	self.Me = self.instanceId							--自身
	self.BattleTarget = 0								--战斗目标
	self.RealFrame = BehaviorFunctions.GetFightFrame()	--世界帧数
	self.MyFrame = 0									--自身帧数

	--技能相关参数
	self.CurrentSkillId = 0				--记录当前释放中技能，否则为0
	self.InitialSkillCd = 3				--初始技能冷却时间
	self.CommonSkillCd = 0				--通用技能冷却时间
	self.CommonSkillCdFrame = self.RealFrame + self.InitialSkillCd * 30	--(初始)技能公共冷却帧数

	--发呆、跟随、游荡、移动相关参数
	self.BattleTargetDistance = 0		--战斗目标与自身的距离
	self.BattleTargetAngle = 0			--战斗目标与自身正前方向量的角度

	self.InitialBemusedTime = 1			--初始发呆时间
	self.AfterSkillBemusedTime = 2		--释放技能后的发呆时间
	self.MoveBemusedTime = 0.5			--游荡移动的发呆时间
	self.BemusedFrame = self.RealFrame + self.InitialBemusedTime * 30	--(初始)发呆帧数
	self.FightIdleTime = 1				--战斗待机时间
	self.FightIdleFrame = 0				--战斗待机帧数

	self.FollowDistance = 6				--距离过远跟随距离，超出距离进行跟随
	self.FollowCancelDistance = 4		--取消跟随距离，跟随状态接近目标后取消

	self.WalkBackDistance = 1			--距离过近后退距离，过于接近进行后退
	self.WalkBackCancelDistance = 2		--取消后退距离，后退状态远离目标后取消

	self.MoveDirectionChangeTime = 3	--移动方向切换时间
	self.MoveDirectionChangeFrame = 0	--移动方向切换帧数

	self.SkillId = 0 --临时技能Id

	self.MyState = 0					--自身状态
	self.MyMoveState = 0				--自身移动状态
	self.MoveSign = 0					--移动选择信号，0一般，1跟随，4后撤

	self.SkillSign = 0					--技能信号，0没有预备技能，1进行攻击条件适配
	self.BattleSign = 0					--攻击信号，0攻击条件不符，1攻击条件符合开始释放技能

	Log("温馨提示：点击U键可以强制让AI释放技能")
	Log("温馨提示：点击U键可以强制让AI释放技能")
	Log("温馨提示：点击U键可以强制让AI释放技能")
end

function Behavior1999:Update()
	----do return  end
	----if not BehaviorFunctions.HasBuffKind(self.Me,9001004) then
		----BehaviorFunctions.AddBuff(self.Me,self.Me,9001004,1)
	----end

	----Log(self.MyState)
	----临时记录战斗目标、每帧记录自身与战斗目标的距离、自身状态
	--self.BattleTarget = BehaviorFunctions.GetCtrlEntity()
	--self.BattleTargetDistance = BehaviorFunctions.GetDistanceFromTarget(self.Me,self.BattleTarget)
	----self.BattleTargetAngle = BehaviorFunctions.GetAngleFromTarget(self.Me,self.BattleTarget)

	----记录世界帧数、自身帧数、自身状态
	--self.RealFrame = BehaviorFunctions.GetFightFrame()
	--self.MyFrame = BehaviorFunctions.GetEntityFrame(self.Me)
	--self.MyState = BehaviorFunctions.GetEntityState(self.Me)
	--self.MyPosition = BehaviorFunctions.GetPositionP(self.Me)

	----当发呆帧数结束后执行后续逻辑
	--if self.BemusedFrame < self.RealFrame and self.MyState ~= FightEnum.EntityState.Die then

		----非技能公共冷却状态且没有已选择技能，则进行技能选择
		--if self.CommonSkillCdFrame < self.RealFrame and self.SkillSign == 0 then
			--for N1 = 1,#self.GlobalSkillGroupSize,1 do
				--for N2 = 1,self.GlobalSkillGroupSize[N1],1 do
					--if self.GlobalSkillGroupCdFrame[N1][N2] < self.RealFrame then
						--self.SkillSign = 1
						--self.GlobalSkillForNum1 = N1
						--self.GlobalSkillForNum2 = N2
						----Log(self.GlobalSkillForNum1.."  "..self.GlobalSkillForNum2)
						--break
					--end
				--end
				--if self.SkillSign == 1 then
					--break
				--end
			--end
		--end

		----游荡移动模块，公共冷却状态且没有预备技能时进行游荡
		--if BehaviorFunctions.CanCastSkill(self.Me) and self.SkillSign == 0 then

			----战斗目标距离过远时进行跟随移动，并在接近一定距离后停止跟随状态
			--if self.FollowDistance < self.BattleTargetDistance and self.MoveSign ~=1 then
				--self.MoveSign = 1
				--BehaviorFunctions.DoSetEntityState(self.Me,FightEnum.EntityState.Move)
				--BehaviorFunctions.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.Run) --Run
			--elseif self.FollowCancelDistance > self.BattleTargetDistance and self.MoveSign == 1 then
				--self.MoveSign = 0
			--end

			----战斗目标距离过近时进行后退移动，并在远离一定距离后停止后退状态
			--if self.WalkBackDistance > self.BattleTargetDistance and self.MoveSign ~= 4 then
				--self.MoveSign = 4
				--BehaviorFunctions.DoSetEntityState(self.Me,FightEnum.EntityState.Move)
				--BehaviorFunctions.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.WalkBack)
			--elseif self.WalkBackCancelDistance < self.BattleTargetDistance and self.MoveSign == 4 then
				--self.MoveSign = 0
			--end

			--if self.MoveSign == 1 or self.MoveSign == 4 or self.MoveSign == 0 then
				--BehaviorFunctions.DoLookAtTargetImmediately(self.Me,self.BattleTarget)
			--end

			----战斗目标在合适距离范围内时，自身进行4个移动方向逻辑或短暂发呆
			--if self.FollowDistance > self.BattleTargetDistance and self.MoveSign == 0
				--and self.WalkBackDistance < self.BattleTargetDistance then
				--if self.MyState ~= FightEnum.EntityState.Move then
					--BehaviorFunctions.DoSetEntityState(self.Me,FightEnum.EntityState.Move)
				--end
				--if self.MoveDirectionChangeFrame < self.RealFrame then
					--local R = math.random(1,10000)

					--if R < 0 then
						--BehaviorFunctions.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.WalkBack)
						--self.MoveDirectionChangeFrame = self.RealFrame + self.MoveDirectionChangeTime * 30

					--elseif R >0 and R <= 3333 then
						--BehaviorFunctions.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.WalkLeft)
						--self.MoveDirectionChangeFrame = self.RealFrame + self.MoveDirectionChangeTime * 30

					--elseif R >3333 and R <= 6666 then
						--BehaviorFunctions.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.WalkRight)
						--self.MoveDirectionChangeFrame = self.RealFrame + self.MoveDirectionChangeTime * 30

					--elseif R > 6666 then
						--self.BemusedFrame = self.RealFrame + self.MoveBemusedTime * 30
						----self.FightIdleFrame = self.RealFrame + self.FightIdleTime * 30
					--end
				--end
			--end
		--end

		----攻击条件模块，检测有预备技能则进行攻击条件的适配
		--if BehaviorFunctions.CanCastSkill(self.Me) and self.SkillSign == 1 and self.BattleSign == 0 then
			--if self.GlobalSkillGroupDistance[self.GlobalSkillForNum1][self.GlobalSkillForNum2] < self.BattleTargetDistance
				----or GlobalSkillGroupAngle[self.GlobalSkillForNum1][self.GlobalSkillForNum2] < self.BattleTargetAngle
				--then
				----Log(self.GlobalSkillGroupDistance[self.GlobalSkillForNum1][self.GlobalSkillForNum2].."  "..self.BattleTargetDistance)
				--BehaviorFunctions.DoLookAtTargetImmediately(self.Me,self.BattleTarget)
				--if self.MyState ~= FightEnum.EntityState.Move then
					--BehaviorFunctions.DoSetEntityState(self.Me,FightEnum.EntityState.Move)
				--end
				--if self.MoveSign ~= 2 then --FightEnum.EntityMoveSubState.Run then
					--BehaviorFunctions.DoSetMoveType(self.Me,FightEnum.EntityMoveSubState.Walk)
					--self.MoveSign = 2
				--end
			--else
				--self.BattleSign = 1
				--self.MoveSign = 0
			--end
		--end
		----Log(self.BattleSign)
		----攻击模块，检测可攻击状态且攻击信号为1时进行攻击
		--if BehaviorFunctions.CanCastSkill(self.Me) and self.SkillSign == 1 and self.BattleSign == 1 then
			--if self.MyState == FightEnum.EntityState.Move then
				--BehaviorFunctions.StopMove(self.Me)
			--end
			--BehaviorFunctions.DoLookAtTargetImmediately(self.Me,self.BattleTarget)
			----Log("小怪攻击")
			--BehaviorFunctions.CastSkillByTarget ( self.Me,self.GlobalSkillGroupId[self.GlobalSkillForNum1][self.GlobalSkillForNum2],self.BattleTarget )


			----Log("~~~~~"..self.GlobalSkillForNum1.."  "..self.GlobalSkillForNum2)
			--self.GlobalSkillGroupCdFrame[self.GlobalSkillForNum1][self.GlobalSkillForNum2] = self.RealFrame +
			--self.GlobalSkillGroupCd[self.GlobalSkillForNum1][self.GlobalSkillForNum2] * 30

			--self.CommonSkillCdFrame = self.RealFrame + self.CommonSkillCd * 30

			--local R = math.random(1,10000)
			--if R <= 0 then
				--self.BemusedFrame = self.RealFrame + self.AfterSkillBemusedTime * 30
				----self.FightIdleFrame = self.RealFrame + self.FightIdleTime * 30
			--end

			--self.BattleSign = 0
			--self.SkillSign = 0
		--end

	--elseif self.BemusedFrame >= self.RealFrame and self.FightIdleFrame < self.RealFrame and BehaviorFunctions.CanCastSkill(self.Me)
		--and self.MyState ~= FightEnum.EntityState.Born and self.MyState ~= FightEnum.EntityState.Hit
		--and self.MyState ~= FightEnum.EntityState.Die and self.MyState ~= FightEnum.EntityState.Death then
		--BehaviorFunctions.DoSetEntityState(self.Me,FightEnum.EntityState.FightIdle)

	--elseif self.BemusedFrame >= self.RealFrame and self.FightIdleFrame >= self.RealFrame and BehaviorFunctions.CanCastSkill(self.Me)
		--and self.MyState ~= FightEnum.EntityState.Born and self.MyState ~= FightEnum.EntityState.Hit
		--and self.MyState ~= FightEnum.EntityState.Die and self.MyState ~= FightEnum.EntityState.Death then
		--BehaviorFunctions.DoSetEntityState(self.Me,FightEnum.EntityState.FightIdle)
	--end

	--检测玩家点击交互按钮
	if BF.CheckKeyDown(FightEnum.KeyEvent.Interaction) and BehaviorFunctions.CanCastSkill(self.Me) then
		--if BehaviorFunctions.CheckEntityState(self.Me,FightEnum.EntityState.Skill) then
			--BehaviorFunctions.BreakSkill(self.Me)
		--end
		--self.SkillId = 1999000 + math.random(1,4)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.Me,self.BattleTarget)
		--BehaviorFunctions.CastSkillByTarget ( self.Me,self.SkillId,self.BattleTarget )
		local r = BF.GetCtrlEntity()
		if not BehaviorFunctions.CheckPlayerInFight() then
			BF.AddFightTarget(self.Me,r)
		else
			BF.RemoveFightTarget(self.Me,r)
		end
	end
end

function Behavior1999:Collide(attackInstanceId,hitInstanceId)
	--if hitInstanceId == self.Me and BF.Probability(8000) 
		--and ((BF.CheckEntityState(self.Me,FEESS) and self.CurrentSkillId == 1999003) or BF.CheckEntityState(self.Me,FEESH)
			--or BF.CheckEntityState(self.Me,FEESI)) then
		--BF.DoSetEntityState(self.Me,FEESI)
		--BF.DoLookAtTargetImmediately(self.Me,self.BattleTarget)
		--BF.CastSkillByTarget (self.Me,1999003,self.BattleTarget)
		--BF.CreateEntity(100400102, self.Me, self.MyPosition.x, self.MyPosition.y+0.8, self.MyPosition.z)
		--BF.DoMagic(self.Me,self.Me,1999902,1)
		----Log("888888888")
	--end
end