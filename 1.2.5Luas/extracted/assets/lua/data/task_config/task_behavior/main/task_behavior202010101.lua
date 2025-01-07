TaskBehavior202010101 = BaseClass("TaskBehavior202010101")

--和npc对话

function TaskBehavior202010101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior202010101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.ClickKey=true
	--self.npc=BehaviorFunctions.GetNpcEntity(8010228)
	self.dialogId=202010101
	self.dialogList = {
		[1]={Id=202010101},
		[2]={Id=202010201},
		[3]={Id=202010301},
		}
	self.missionState=0
	

end

function TaskBehavior202010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position0",10020001,"Logic202010101")
	self.distance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)
	if self.missionState==0 then
		if self.distance<100 then
			BehaviorFunctions.AddLevel(202010101)
			self.missionState=1
		end
	end

	
end





function TaskBehavior202010101:Death(instanceId,isFormationRevive)
	if instanceId==self.role then
		if isFormationRevive==true then
			BehaviorFunctions.RemoveLevel(202010101)
			self.missionState=0
		end
	end
end


