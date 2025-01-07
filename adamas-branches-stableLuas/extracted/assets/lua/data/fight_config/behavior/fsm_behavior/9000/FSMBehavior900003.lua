FSMBehavior900003 = BaseClass("FSMBehavior900003",FSMBehaviorBase)
--战斗总状态


function FSMBehavior900003.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900003:Init()
	--技能相关参数
	self.skillState = 0	                                                    --技能状态
	self.skillStateEnum = {                                                 --技能状态枚举
		Default = 0,
		Initial = 1,
		PrepareSkill = 2,
		HaveSkill = 3,
		Ready = 4,
		CastingSkill = 5,
		InCommonCd = 6
	}
	self.grade = 9												--分级系数，大于这个分级系数的技能会进入群组公共冷却
	
	--脱战相关参数
	self.battleTargetDistance3D = 0
end

function FSMBehavior900003:Update()
	--公共CD计时
	if self.skillState == self.skillStateEnum.InCommonCd and self.MainBehavior.myFrame >=self.MainBehavior.commonSkillCdFrame then
		self.skillState = self.skillStateEnum.Default
		self.MainBehavior.currentSkillId = 0
		--分组处理
		if self.MainBehavior.groupSkillSign == 1 then
			BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"GroupSkill",0)
			self.MainBehavior.groupSkillFrame = self.MainBehavior.myFrame
			self.MainBehavior.groupSkillNum = self.MainBehavior.currentSkillListNum
		end
	end
	
	
	--脱战逻辑判断
	if self.MainBehavior.canExitFight == true  and BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		self.MainBehavior.bornDistance = BehaviorFunctions.GetDistanceFromPos(self.MainBehavior.myPos,self.MainBehavior.bornPosition)
		--脱战逻辑
		--获取与目标的三维坐标距离
		self.battleTargetDistance3D = BehaviorFunctions.GetDistanceFromTargetWithY(self.MainBehavior.me,self.MainBehavior.battleTarget)
		--距离过远 或 战斗目标距离大于游荡超远距离
		if (self.MainBehavior.bornDistance >= self.MainBehavior.ExitFightRange --距离出生点太远
				or (self.MainBehavior.targetMaxRange > 0 and self.battleTargetDistance3D >= self.MainBehavior.targetMaxRange)) --距离（3维）超过最大游荡范围
			or BehaviorFunctions.GetCurAlivePlayerEntityCount() == 0	then	--灭队脱战
			self.MainBehavior.inFight = false
			BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
		end
	end

end

--理论上仅用于脱战
function FSMBehavior900003:OnLeaveState()
	BehaviorFunctions.RemoveFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
	if self.MainBehavior.pathFindKey == false then
		BehaviorFunctions.ClearPathFinding(self.MainBehavior.me)
		self.MainBehavior.pathFindKey = true
	end
	if not BehaviorFunctions.HasBuffKind(self.MainBehavior.me,900000007) then
		BehaviorFunctions.DoMagic(1,self.MainBehavior.me,900000007)
	end
	BehaviorFunctions.EnableEntityElementStateRuning(self.MainBehavior.me, FightEnum.ElementState.Accumulation, false,-1)
	
	--传值
	BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"MonsterExitFight",true)
	BehaviorFunctions.RemoveFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
	--返回出生点
	--BehaviorFunctions.DoLookAtPositionImmediately(self.MonsterCommonParam.me,self.MonsterCommonParam.bornPosition.x,nil,self.MonsterCommonParam.bornPosition.z)
	BehaviorFunctions.CancelLookAt(self.MainBehavior.me)
end