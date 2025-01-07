TaskBehavior202030101 = BaseClass("TaskBehavior202030101")

--和警察对话

function TaskBehavior202030101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior202030101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.ClickKey=true
	--self.npc=BehaviorFunctions.GetNpcEntity(8010228)
	self.dialogId=202030101
	self.missionState=0
	self.progressNum=0
	

end

function TaskBehavior202030101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position_Police",10020001,"Logic202030101")
	self.distance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)

	
	if self.progressNum==0
		and self.distance<100 then
		self.zhixianGuide=BehaviorFunctions.CreateEntity(20600,nil,Vector2.x,Vector2.y,Vector2.z)
		self.progressNum=1
	end
end


function TaskBehavior202030101:StoryStartEvent(dialogId)
	if dialogId==self.dialogId then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		if self.zhixianGuide
			and BehaviorFunctions.CheckEntity(self.zhixianGuide) then
			BehaviorFunctions.RemoveEntity(self.zhixianGuide)
		end
	end
end




function TaskBehavior202030101:StoryEndEvent(dialogId)
	if dialogId==self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end	
end


function TaskBehavior202030101:Death(instanceId,isFormationRevive)
	if instanceId==self.role then
		if isFormationRevive==true then
			if self.zhixianGuide
				and BehaviorFunctions.CheckEntity(self.zhixianGuide) then
				BehaviorFunctions.RemoveEntity(self.zhixianGuide)
			end
			self.progressNum=0
		end
	end
end