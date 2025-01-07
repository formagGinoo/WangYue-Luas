TaskBehavior202020101 = BaseClass("TaskBehavior202020101")

--和npc对话

function TaskBehavior202020101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior202020101:init(taskInfo)
	self.taskInfo = taskInfo
	self.ClickKey=true
	--self.npc=BehaviorFunctions.GetNpcEntity(8010228)
	self.dialogId=202020401
	self.missionState=0
	
	Log("7787")

end

function TaskBehavior202020101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position_Npc",10020001,"Logic202020101")
	self.distance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)
	if self.distance<100 then
		if self.missionState==0 then
			--self.zhixianGuide=BehaviorFunctions.CreateEntity(20600,nil,Vector2.x,Vector2.y,Vector2.z)
			
			self.missionState=1
		end
	end
	

end

function TaskBehavior202020101:StoryStartEvent(dialogId)
	if dialogId==self.dialogId then
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		
		--if self.zhixianGuide
			--and BehaviorFunctions.CheckEntity(self.zhixianGuide) then
			--BehaviorFunctions.RemoveEntity(self.zhixianGuide)
		--end		
	end
end

function TaskBehavior202020101:StoryEndEvent(dialogId)
	if dialogId==self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		
	end	
end



function TaskBehavior202020101:Death(instanceId,isFormationRevive)
	if instanceId==self.role then
		if isFormationRevive==true then
			--if self.zhixianGuide
				--and BehaviorFunctions.CheckEntity(self.zhixianGuide) then
				--BehaviorFunctions.RemoveEntity(self.zhixianGuide)
			--end
			self.missionState=0
			
		end
	end
end
