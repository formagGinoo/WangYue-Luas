TaskBehavior200100109 = BaseClass("TaskBehavior200100109")

function TaskBehavior200100109:__init(taskInfo)
	self.taskInfo = taskInfo
	self.checkPos = {x = 157, z = 117}
	self.checkRadius = 999
	self.testPos = {x=160,y=0,z=127}
	self.testStage = 0
end

function TaskBehavior200100109:Update()
	-- 测试

		self.role = BehaviorFunctions.GetCtrlEntity()
		if self.role then
			local position = BehaviorFunctions.GetPositionP(self.role)
			if BehaviorFunctions.GetDistanceFromPos(position, self.checkPos) < self.checkRadius then
				if self.testStage == 0 then
					BehaviorFunctions.SetGuide(1001,self.testPos.x,self.testPos.y,self.testPos.z)
					self.testStage = 1
				end
				if self.testStage == 1 and BehaviorFunctions.GetDistanceFromPos(position,self.testPos)<3 then
					Log("创建关卡")
					BehaviorFunctions.AddLevel(10010003)
					BehaviorFunctions.CancelGuide()
					self.testStage = 2
				end
			end
		end

end

function TaskBehavior200100109:RemoveTask()

end