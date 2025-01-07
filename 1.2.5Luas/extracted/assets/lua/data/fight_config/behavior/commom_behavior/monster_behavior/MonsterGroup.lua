MonsterGroup = BaseClass("MonsterGroup",EntityBehaviorBase)

function MonsterGroup:Init()
	self.MonsterCommonBehavior = self.ParentBehavior
	self.MonsterCommonParam = self.MainBehavior.MonsterCommonParam
end

function MonsterGroup:Update()
	--出生完成，获取分组信息
	if self.MonsterCommonParam.initialState == self.MonsterCommonParam.InitialStateEnum.Done then
		self.MonsterCommonParam.groupSkillSign = BehaviorFunctions.GetEntityValue(self.MonsterCommonParam.me,"GroupSkill")
	end
	--分组逻辑
	if self.MonsterCommonParam.groupSkillSign == 0 then
		self.MonsterCommonParam.skillIsAuto = false
		self.MonsterCommonParam.skillState = self.MonsterCommonParam.SkillStateEnum.Default
	elseif self.MonsterCommonParam.groupSkillSign == 1 then
		self.MonsterCommonParam.skillIsAuto = true
		if self.MonsterCommonParam.groupSkillFrame < self.MonsterCommonParam.myFrame and self.MonsterCommonParam.groupSkillFrame ~= 0 and self.MonsterCommonParam.groupSkillNum ~= 0 then
			self.MonsterCommonParam.groupSkillFrame = self.MonsterCommonParam.myFrame - self.MonsterCommonParam.groupSkillFrame
			self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.groupSkillNum].frame = self.MonsterCommonParam.currentSkillList[self.MonsterCommonParam.groupSkillNum].frame + self.MonsterCommonParam.groupSkillFrame
			self.MonsterCommonParam.groupSkillNum = 0
		end
	else
		self.MonsterCommonParam.skillIsAuto = true
	end
end