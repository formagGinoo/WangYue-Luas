LevelBehavior102630101 = BaseClass("LevelBehavior102630101",LevelBehaviorBase)
--石龙钻洞帮助天狐恋

function LevelBehavior102630101.GetGenerates()
	local generates = {200000101}
	return generates
end


function LevelBehavior102630101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskState = 0
	
	self.hasButton = false
	self.button = nil
	self.missionObj = nil
end


function LevelBehavior102630101:Update()
	if self.taskState == 0 then
		local pos = BehaviorFunctions.GetTerrainPositionP("interactPos1",self.levelId)
		self.missionObj = BehaviorFunctions.CreateEntity(200000101,nil,pos.x,pos.y,pos.z)
		self.taskState = 1
		
	end
	
	if self.taskState == 2 then
		
		
	end
	
end