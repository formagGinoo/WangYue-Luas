Behavior1000000002 = BaseClass("Behavior1000000002",EntityBehaviorBase)

local BF = BehaviorFunctions

--缔约连线实体逻辑
function Behavior1000000002:Init()
	--变量声明
	self.Me = self.instanceId		--记录自己
	self.FirstTarget = 0
	self.SecondTarget = 0
	self.Relation = false
end

function Behavior1000000002:Update()
	
	self.FirstTarget = BF.GetEntityValue(self.Me,"FirstTarget")
	self.SecondTarget = BF.GetEntityValue(self.Me,"SecondTarget")
	
	--检查第1和第2目标的存在且在场、不存在隐身Buff
	if BF.CheckEntity(self.FirstTarget) and BF.CheckEntityForeground(self.FirstTarget)
		and BF.CheckEntity(self.SecondTarget) and BF.CheckEntityForeground(self.SecondTarget) 
		and not BF.HasBuffKind(self.FirstTarget,1001) and not BF.HasBuffKind(self.SecondTarget,1001) then
		if self.Relation == false then
			BF.ClientEffectRelation(self.Me,self.FirstTarget,self.SecondTarget,0.65)
			self.Relation = true
		end
	--否则判断链接断开(隐藏)
	else
		if self.Relation == true then
			BF.ClientEffectRemoveRelation(self.Me)
			self.Relation = false
		end
	end
end