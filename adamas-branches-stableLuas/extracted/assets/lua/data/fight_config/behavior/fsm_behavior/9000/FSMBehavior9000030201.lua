FSMBehavior9000030201 = BaseClass("FSMBehavior9000030201",FSMBehaviorBase)



function FSMBehavior9000030201.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior9000030201:Init()

end

function FSMBehavior9000030201:Update()
	--取消移动
	if self.MainBehavior.myState == FightEnum.EntityState.Move then
		BehaviorFunctions.StopMove(self.MainBehavior.me)
		--self.MainBehavior.moveState = self.MainBehavior.MoveStateEnum.Default
	end
	
	--角度判断
	if BehaviorFunctions.CompEntityLessAngle(self.MainBehavior.me,self.MainBehavior.battleTarget,self.MainBehavior.currentSkillList[self.MainBehavior.currentSkillListNum].angle) then
		self.ParentBehavior.ParentBehavior.skillState = self.ParentBehavior.ParentBehavior.skillStateEnum.Ready
	end
	BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
end