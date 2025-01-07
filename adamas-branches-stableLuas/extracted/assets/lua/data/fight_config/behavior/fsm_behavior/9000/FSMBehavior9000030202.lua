FSMBehavior9000030202 = BaseClass("FSMBehavior9000030202",FSMBehaviorBase)



function FSMBehavior9000030202.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior9000030202:Init()

end

function FSMBehavior9000030202:Update()
	BehaviorFunctions.DoLookAtTargetByLerp(self.MainBehavior.me,self.MainBehavior.battleTarget,true,0,240,-2)
	if BehaviorFunctions.CompEntityLessAngle(self.MainBehavior.me,self.MainBehavior.battleTarget,self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].angle) then
		self.ParentBehavior.ParentBehavior.skillState = self.ParentBehavior.ParentBehavior.skillStateEnum.Ready
		BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
	end
end