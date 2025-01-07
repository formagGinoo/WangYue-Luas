FSMBehavior9000030203 = BaseClass("FSMBehavior9000030203",FSMBehaviorBase)
--释放技能释放技能中状态


function FSMBehavior9000030203.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior9000030203:Init()
	self.FightTargetArrowEffect = false		--红标箭头
	self.warnSign = 0
end

function FSMBehavior9000030203:Update()
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		if self.ParentBehavior.ParentBehavior.skillState == self.ParentBehavior.ParentBehavior.skillStateEnum.Ready then
			BehaviorFunctions.CancelLookAt(self.MainBehavior.me)
			BehaviorFunctions.CastSkillByTarget(self.MainBehavior.me,self.MainBehavior.currentSkillId,self.MainBehavior.battleTarget)
			self.FightTargetArrowEffect=true
			--技能cd
			self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].frame = self.MainBehavior.myFrame + self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].cd * 30
			--公共cd帧数=当前帧数+公共cd*30+持续帧数
			self.skillCastingFrame = self.MainBehavior.myFrame + self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].durationFrame
			if self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].ignoreCommonSkillCd == true then
				self.MainBehavior.commonSkillCdFrame = self.MainBehavior.myFrame + self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].durationFrame
			else
				self.MainBehavior.commonSkillCdFrame = self.MainBehavior.myFrame + self.MainBehavior.commonSkillCd * 30 + self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].durationFrame
			end
			self.ParentBehavior.ParentBehavior.skillState = self.ParentBehavior.ParentBehavior.skillStateEnum.CastingSkill
		
			--判断释放的技能分级，大于指定分级系数则添加公共cd标记
			if self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].grade > self.ParentBehavior.ParentBehavior.grade then
				BehaviorFunctions.AddEntitySign(1,10000034,-1,false)
			end
		end
	
		--技能释放计时
		if self.ParentBehavior.ParentBehavior.skillState == self.ParentBehavior.ParentBehavior.skillStateEnum.CastingSkill
			and (self.MainBehavior.myFrame >= self.skillCastingFrame
			or BehaviorFunctions.GetSkill(self.MainBehavior.me) == 0) then
			self.ParentBehavior.ParentBehavior.skillState = self.ParentBehavior.ParentBehavior.skillStateEnum.InCommonCd
			self.ParentBehavior.skillDone = true
		end
	end
	
	--检查是否有标记。如果有标记，且暂无攻击特效，则显示。否则不显示。
	if BehaviorFunctions.GetSkillSign(self.MainBehavior.me,9999)
		and self.FightTargetArrowEffect==true and self.warnSign ~= 1 and BehaviorFunctions.GetDistanceFromTarget(self.MainBehavior.me,self.MainBehavior.battleTarget,false) < 8 then
		if not BehaviorFunctions.CheckFightTargetArrowEffect(self.MainBehavior.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MainBehavior.me,true)
		end
	elseif not BehaviorFunctions.GetSkillSign(self.MainBehavior.me,9999) and self.warnSign ~= 1 then
		if BehaviorFunctions.CheckFightTargetArrowEffect(self.MainBehavior.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MainBehavior.me,false)
		end
	end
	
end

function FSMBehavior9000030203:Collide(attackInstanceId,hitInstanceId)
	--受击后提前驱除闪烁标记
	if attackInstanceId==self.MainBehavior.me
		and hitInstanceId==self.MainBehavior.battleTarget then
		--检查是否有标记。如果有标记，且暂无攻击特效，则显示。否则不显示。
		self.FightTargetArrowEffect=false
	end

	--播放霸体特效
	if hitInstanceId == self.MainBehavior.me then
		--播放霸体受击特效
		if BehaviorFunctions.HasBuffKind(hitInstanceId,900000040) and self.MainBehavior.hitEffectFrame < self.MainBehavior.myFrame then
			BehaviorFunctions.DoMagic(1,self.MainBehavior.me,900000052)
			self.MainBehavior.hitEffectFrame = self.MainBehavior.myFrame + 8
		end
	end
end

function FSMBehavior9000030203:FinishSkill(instanceId,skillId,skillType)
	if instanceId==self.MainBehavior.me
		and BehaviorFunctions.CheckFightTargetArrowEffect(self.MainBehavior.me) then
		self.FightTargetArrowEffect=false
	end
end

function FSMBehavior9000030203:BreakSkill(instanceId,skillId,skillType)
	if instanceId==self.MainBehavior.me
		and BehaviorFunctions.CheckFightTargetArrowEffect(self.MainBehavior.me) then
		self.FightTargetArrowEffect=false
	end
end

function FSMBehavior9000030203:Warning(instance, targetInstance, sign ,isEnd)
	if instance == self.MainBehavior.me and sign == 900050 and BehaviorFunctions.GetDistanceFromTarget(instance,targetInstance,false) >= 8 and isEnd == nil then
		self.warnSign = 1
		if not BehaviorFunctions.CheckFightTargetArrowEffect(self.MainBehavior.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MainBehavior.me,true)
		end
	end
	if instance == self.MainBehavior.me and sign == 900050 and isEnd == true then
		if BehaviorFunctions.CheckFightTargetArrowEffect(self.MainBehavior.me) then
			BehaviorFunctions.PlayFightTargetArrowEffect(self.MainBehavior.me,false)
			self.warnSign = 0
		end
	end
end