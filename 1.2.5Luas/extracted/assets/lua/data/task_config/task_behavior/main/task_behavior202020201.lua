TaskBehavior202020201 = BaseClass("TaskBehavior202020201")

--和npc对话

function TaskBehavior202020201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior202020201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.missionState=0
	self.levelId=202020201
end

function TaskBehavior202020201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local Vector1=BehaviorFunctions.GetPositionP(self.role)
	local Vector2=BehaviorFunctions.GetTerrainPositionP("Position_Npc",10020001,"Logic202020101")
	self.distance=BehaviorFunctions.GetDistanceFromPos(Vector1,Vector2)
	if self.distance<10 then
		if self.missionState==0 then
			BehaviorFunctions.AddLevel(self.levelId)
			self.missionState=1
		end
	end
	if self.missionState == 1 and BehaviorFunctions.CheckLevelIsCreate(self.levelId) then
		self.missionState = 2
	end
	if self.missionState == 2 and not BehaviorFunctions.CheckLevelIsCreate(self.levelId) then
		self.missionState = 0
	end
	if self.distance>15 
		and self.missionState==1 then
		
	end
end



