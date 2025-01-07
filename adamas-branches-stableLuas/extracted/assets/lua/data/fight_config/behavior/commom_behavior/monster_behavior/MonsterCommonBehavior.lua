MonsterCommonBehavior = BaseClass("MonsterCommonBehavior",EntityBehaviorBase)

--怪物组合合集
function MonsterCommonBehavior:Init()
	self.MonsterBorn = BehaviorFunctions.CreateBehavior("MonsterBorn",self)
	self.MonsterPeace = BehaviorFunctions.CreateBehavior("MonsterPeace",self)
	self.MonsterWarn = BehaviorFunctions.CreateBehavior("MonsterWarn",self)
	self.MonsterWander = BehaviorFunctions.CreateBehavior("MonsterWander",self)
	self.MonsterCastSkill = BehaviorFunctions.CreateBehavior("MonsterCastSkill",self)
	self.MonsterExitFight = BehaviorFunctions.CreateBehavior("MonsterExitFight",self)
	self.MonsterGroup = BehaviorFunctions.CreateBehavior("MonsterGroup",self)
	self.MonsterMercenaryChase = BehaviorFunctions.CreateBehavior("MonsterMercenaryChase",self)
end

function MonsterCommonBehavior:LateInit()
	self.MonsterPeace = BehaviorFunctions.CreateBehavior("MonsterPeace",self)

end



function MonsterCommonBehavior:Update()
	
end