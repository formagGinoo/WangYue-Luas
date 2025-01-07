Behavior2030530 = BaseClass("Behavior2030530",EntityBehaviorBase)

local BF = BehaviorFunctions
local FES = FightEnum.EntityState
local FK = FightEnum.KeyEvent
local FE = FightEnum
local FEAS = FightEnum.EntityAimState
local FEET = FightEnum.ElementType
local FEAET = FightEnum.AnimEventType
--电压陷阱
function Behavior2030530.GetGenerates()
	 local generates = {}
	 return generates
end

function Behavior2030530:Init()
	self.me = self.instanceId
end


function Behavior2030530:LateInit()
	BehaviorFunctions.AddBuff(self.me,self.me,200001180)
	BehaviorFunctions.AddBuff(self.me,self.me,200001181)
	BehaviorFunctions.AddBuff(self.me,self.me,200001182)
end
	

function Behavior2030530:Update()

	
end

--点击下侧按钮,爆炸
function Behavior2030530:HackingClickDown(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.SetEntityValue(self.me,"follow_200001180",true) --摧毁前清除周围敌人的寻路
		BehaviorFunctions.SetEntityValue(self.me,"level_200001181",3)
		BehaviorFunctions.SetEntityValue(self.me,"active_200001181",true)

	end
end

--点击右侧按钮,电磁场
function Behavior2030530:HackingClickRight(instanceId)
	if instanceId == self.me then

		if BehaviorFunctions.GetEntityValue(self.me,"active_200001182") == true then
			BehaviorFunctions.SetEntityValue(self.me,"active_200001182",false)
			BehaviorFunctions.SetEntityHackActiveState(self.me, false)
		else
			BehaviorFunctions.SetEntityValue(self.me,"active_200001182",true)
			BehaviorFunctions.SetEntityHackActiveState(self.me, true)
		end

	end
end

--点击左侧按钮，吸引敌人
function Behavior2030530:HackingClickLeft(instanceId)
	if instanceId == self.me then
		BehaviorFunctions.SetEntityValue(self.me,"active_200001180",true)
	end
end