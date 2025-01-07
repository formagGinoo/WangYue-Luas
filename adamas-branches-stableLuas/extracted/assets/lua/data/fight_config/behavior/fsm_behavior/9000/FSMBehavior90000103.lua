FSMBehavior90000103 = BaseClass("FSMBehavior90000103",FSMBehaviorBase)
--出生初始化状态

function FSMBehavior90000103:Init()
	self.initialState = 0                    --出生初始化状态进度
	self.InitialStateEnum = {                --出生初始化状态进度枚举
		Default = 0,
		EffectDone = 1,
		InitialDone = 2,
	}
	self.dazeFrame = 0
end

function FSMBehavior90000103:Update()
	if self.initialState == self.InitialStateEnum.Default then
		--通用出生特效(小怪、精英)
		if BehaviorFunctions.GetNpcType(self.MainBehavior.me) == FightEnum.EntityNpcTag.Monster
			or BehaviorFunctions.GetNpcType(self.MainBehavior.me) == FightEnum.EntityNpcTag.Elite then
			BehaviorFunctions.CreateEntity(self.ParentBehavior.bornEffectId,self.MainBehavior.me)
		end
		self.initialState = self.InitialStateEnum.EffectDone
	end
	

	if self.initialState == self.InitialStateEnum.EffectDone then
		--发呆时间初始化
		if self.dazeFrame == 0 and self.MainBehavior.initialDazeTime ~= 0 then
			self.dazeFrame = self.MainBehavior.myFrame + self.MainBehavior.initialDazeTime * 30
		end
		--发呆结束
		if self.MainBehavior.myFrame > self.dazeFrame
			and BehaviorFunctions.CanCtrl(self.MainBehavior.me) then
			--有技能放技能
			if self.MainBehavior.bornSkillId then
				BehaviorFunctions.CastSkillBySelfPosition(self.MainBehavior.me,self.MainBehavior.bornSkillId)
			end
			self.initialState = self.InitialStateEnum.InitialDone
			self.ParentBehavior.isBorned = true
			BehaviorFunctions.CustomFSMTryChangeState(self.MainBehavior.me)
		end
	end	
end