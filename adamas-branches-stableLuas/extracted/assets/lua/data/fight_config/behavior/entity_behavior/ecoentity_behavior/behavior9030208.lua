Behavior9030208 = BaseClass("Behavior9030208",EntityBehaviorBase)
--可破坏花遗迹临时管理器
function Behavior9030208.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior9030208:Init()
	self.me = self.instanceId
	
end


function Behavior9030208:Update()
	if BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) then
		self.monsterGroup=BehaviorFunctions.GetEcoEntityGroup(nil,nil,self.me) --每帧都需要修改自己的组内成员
	end

	if self.monsterGroup then
		for n,m in pairs(self.monsterGroup) do
			if BehaviorFunctions.CheckEntity(m.instanceId)==true
				and  BehaviorFunctions.GetEntityTemplateId(m.instanceId)==2030208 then
				self.ruin=m.instanceId
			end
		end
	end

	if self.ruin and BehaviorFunctions.GetEntityValue(self.ruin,"death") then
		BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Death)
		BehaviorFunctions.RemoveEntity(self.me)
	end
end

