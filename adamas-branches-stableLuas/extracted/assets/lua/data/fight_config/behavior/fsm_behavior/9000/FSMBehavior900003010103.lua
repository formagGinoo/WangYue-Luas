FSMBehavior900003010103 = BaseClass("FSMBehavior900003010103",FSMBehaviorBase)
--战斗游荡状态


function FSMBehavior900003010103.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900003010103:Init()

end

function FSMBehavior900003010103:Update()
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		--处于超远距离，有跑步进入RunAndHit状态，无跑步向前走
		if self.ParentBehavior.battleRange == self.ParentBehavior.BattleRangeEnum.Far then
			if self.MainBehavior.canRun then
				if self.MainBehavior.haveRunAndHit
					and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunAndHit then
					self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.RunAndHit
				elseif self.MainBehavior.haveRunAndHit == false
					and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.RunForward then
					self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.RunForward
				end
			elseif self.MainBehavior.canRun == false and self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.WalkForward then
				self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.WalkForward
			end
		end
		--走/跑进极限近身距离,放追击技能或后退
		if self.MainBehavior.battleTargetDistance < self.MainBehavior.minRange then
			if self.ParentBehavior.moveState == self.ParentBehavior.MoveStateEnum.RunAndHit or self.ParentBehavior.moveState == self.ParentBehavior.MoveStateEnum.WalkForward
				or self.ParentBehavior.moveState == self.ParentBehavior.MoveStateEnum.RunForward then
				--有CD就放追击技能
				local skill = self:SerchSkillList(self.MainBehavior.defaultSkillId,self.MainBehavior.currentSkillList)
				if skill and self.MainBehavior.currentSkillList[skill].frame < self.MainBehavior.myFrame and self.MainBehavior.haveRunAndHit then
					BehaviorFunctions.CastSkillByTarget(self.MainBehavior.me,self.MainBehavior.defaultSkillId,self.MainBehavior.battleTarget) --放追杀技能
					self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.Default --切换回默认状态
					self:SetSkillFrame(self.MainBehavior.defaultSkillId) --加默认技能CD
				else
					if self.ParentBehavior.moveState ~= self.ParentBehavior.MoveStateEnum.WalkBack and self.ParentBehavior.canWalkBack == false then
						self.ParentBehavior.moveState = self.ParentBehavior.MoveStateEnum.Default
					end
				end
			end
		end
		BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
	end
end

--根据id查找列表中对应id的技能的列表下标
function FSMBehavior900003010103:SerchSkillList(skillid,table)
	for i = 1,#table do
		if skillid == table[i].id then
			return i
		end
	end
end

--修改技能frame值
function FSMBehavior900003010103:SetSkillFrame(skillId)
	--找到这个技能
	local i = self:SerchSkillList(skillId,self.MainBehavior.currentSkillList)
	--修改frame值4
	self.MainBehavior.currentSkillList[i].frame = self.MainBehavior.myFrame + self.MainBehavior.initialSkillList[i].cd*30
end