FSMBehavior90000202 = BaseClass("FSMBehavior90000202",FSMBehaviorBase)



function FSMBehavior90000202.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior90000202:Init()

end

function FSMBehavior90000202:Update()
	BehaviorFunctions.AddFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
	self.ParentBehavior.nowAlertnessValue = 0  --警戒值清零
	--添加叹号（会直接顶掉问号，不用单独移除）
	if self.ParentBehavior.UIState ~= self.ParentBehavior.UIStateEnum.WarnOn then
		--BehaviorFunctions.ShowQuestionAlertnessUI(self.MainBehavior.me, false)   --隐藏问号
		BehaviorFunctions.CreateWarnAlertnessUI(self.MainBehavior.me, self.MainBehavior.alertUIOffset, self.MainBehavior.alertUIPoint)
		BehaviorFunctions.ShowWarnAlertnessUI(self.MainBehavior.me, true)
		BehaviorFunctions.AddDelayCallByFrame(31, BehaviorFunctions, BehaviorFunctions.ShowWarnAlertnessUI, self.MainBehavior.me, false)
		self.ParentBehavior.nowAlertnessValue = 0
		self.ParentBehavior.UIState = self.ParentBehavior.UIStateEnum.WarnOn
	end
	--释放警戒技能
	if BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
		if self.MainBehavior.warnSkillId then
			BehaviorFunctions.DoLookAtTargetImmediately(self.MainBehavior.me,self.MainBehavior.battleTarget)
			BehaviorFunctions.CastSkillByTarget(self.MainBehavior.me,self.MainBehavior.warnSkillId,self.MainBehavior.battleTarget)
		end
	end
	self.ParentBehavior.warnState = self.ParentBehavior.warnStateEnum.WarnDone
	self.ParentBehavior.UIState = self.ParentBehavior.UIStateEnum.Off
	self.ParentBehavior.isQuestionShow = false
	if BehaviorFunctions.CheckEcoEntityGroup(self.MainBehavior.ecoMe)
		and BehaviorFunctions.CheckEcoEntityGroup(self.MainBehavior.ecoMe) == true then  --有组的时候警告别人哦，没组的时候没用
		self.MainBehavior.inPeace = false  --警戒状态的标记
		--被警告的怪物，在走到警告行为的时候，不再传值。
		if BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"monsterBeWarned")==nil then --没走被警告的怪物
			BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"warnOthers",true) --警告别人
		elseif BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"monsterBeWarned")==true then
			BehaviorFunctions.SetEntityValue(self.MainBehavior.me,"monsterBeWarned",nil)
		end
	end
	self.MainBehavior.inFight = true
	if BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me) then
		return true
	end
end