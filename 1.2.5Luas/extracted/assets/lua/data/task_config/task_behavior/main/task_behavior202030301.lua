TaskBehavior202030301 = BaseClass("TaskBehavior202030301")

--和坏人对话

function TaskBehavior202030301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior202030301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.ClickKey=true
	--self.npc=BehaviorFunctions.GetNpcEntity(8010228)
	self.missionState=0
	self.levelId=202030301

end

function TaskBehavior202030301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position_Npc",10020001,"Logic202030101")
	self.distance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)

	
	--创建关卡
	if self.missionState==0 then
		if self.distance<50 then
			BehaviorFunctions.AddLevel(self.levelId)
			self.missionState=1
		end
		
	end
	

end




function TaskBehavior202030301:Death(instanceId,isFormationRevive)
	if instanceId==self.role then
		if isFormationRevive==true then
			BehaviorFunctions.RemoveLevel(self.levelId)
			self.missionState=0
		end
	end
end


