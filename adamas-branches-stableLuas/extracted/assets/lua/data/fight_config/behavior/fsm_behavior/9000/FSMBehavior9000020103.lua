FSMBehavior9000020103 = BaseClass("FSMBehavior9000020103",FSMBehaviorBase)
--和平生态表演状态


function FSMBehavior9000020103.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior9000020103:Init()

end

function FSMBehavior9000020103:LateInit()
	self.actPerformance=self.ParentBehavior.list["actPerformance"][1]
end

function FSMBehavior9000020103:Update()
	
	--表演获取
	if  self.actPerformance==nil then
		self.actPerformance=BehaviorFunctions.GetEntityValue(self.MainBehavior.me,"actPerformance")
	end
	--演出状态，播演出技能
	if self.actPerformance and self.MainBehavior.actKey==true then
		BehaviorFunctions.PlayAnimation(self.MainBehavior.me,self.actPerformance)
		self.MainBehavior.actKey = false
	end
end

