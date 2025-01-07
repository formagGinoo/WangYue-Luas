MonsterBorn = BaseClass("MonsterBorn",EntityBehaviorBase)



function MonsterBorn.GetGenerates()
	local generates = {}
	return generates
end
--怪物出生
function MonsterBorn:Init()
	
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
	self.bornEffectId = 900000104
end

function MonsterBorn:Update()
	--有技能放技能，有特殊逻辑给Special标记,不控制出生
	if self.MonsterCommonParam.haveSpecialBornLogic 
		and self.MonsterCommonParam.initialState ~= self.MonsterCommonParam.InitialStateEnum.Special
		and self.MonsterCommonParam.initialState ~= self.MonsterCommonParam.InitialStateEnum.Done then
		self.MonsterCommonParam.initialState = self.MonsterCommonParam.InitialStateEnum.Special
	elseif self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Default then
		if self.MonsterCommonParam.inInitial == false then
			--通用出生特效(小怪、精英)
			if BehaviorFunctions.GetNpcType(self.MonsterCommonParam.me) == FightEnum.EntityNpcTag.Monster
				or BehaviorFunctions.GetNpcType(self.MonsterCommonParam.me) == FightEnum.EntityNpcTag.Elite then
				BehaviorFunctions.CreateEntity(self.bornEffectId,self.MonsterCommonParam.me)
			end
			self.MonsterCommonParam.inInitial = true
			self.MonsterCommonParam.initialState = self.MonsterCommonParam.InitialStateEnum.Initial
		end
	end
	--发呆结束
	if self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Initial 
		and self.MonsterCommonParam.myFrame > self.MonsterCommonParam.dazeFrame 
		and BehaviorFunctions.CanCtrl(self.MonsterCommonParam.me) then
		--有技能放技能
		if self.MonsterCommonParam.bornSkillId then
			BehaviorFunctions.CastSkillBySelfPosition(self.MonsterCommonParam.me,self.MonsterCommonParam.bornSkillId)
		end
		self.MonsterCommonParam.initialState = self.MonsterCommonParam.InitialStateEnum.Done
		self.MonsterCommonParam.inInitial = false
	end
end