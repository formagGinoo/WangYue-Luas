LevelBehavior102540202 = BaseClass("LevelBehavior102540202",LevelBehaviorBase)
--拍照教学

function LevelBehavior102540202.GetGenerates()
	local generates = {20410010101}
	return generates
end


function LevelBehavior102540202:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.photoTarget = nil
	
	self.photoTargetList = {
		[1] = {bp = "photoTarget1", id = nil},
		[2] = {bp = "photoTarget2", id = nil},
		[3] = {bp = "photoTarget3", id = nil},
		[4] = {bp = "photoTarget4", id = nil},
		[5] = {bp = "photoTarget5", id = nil},
		[6] = {bp = "photoTarget6", id = nil},
		[7] = {bp = "photoTarget7", id = nil},
		[8] = {bp = "photoTarget8", id = nil},
		[9] = {bp = "photoTarget9", id = nil},
		[10] = {bp = "photoTarget10", id = nil},
		[11] = {bp = "photoTarget11", id = nil},
		[12] = {bp = "photoTarget12", id = nil},
		[13] = {bp = "photoTarget13", id = nil},
		[14] = {bp = "photoTarget14", id = nil},
		[15] = {bp = "photoTarget15", id = nil},
		[16] = {bp = "photoTarget16", id = nil},
		[17] = {bp = "photoTarget17", id = nil},
		[18] = {bp = "photoTarget18", id = nil},
		[19] = {bp = "photoTarget19", id = nil},
		[20] = {bp = "photoTarget20", id = nil},
		[21] = {bp = "photoTarget21", id = nil},
		[22] = {bp = "photoTarget22", id = nil},
		[23] = {bp = "photoTarget23", id = nil},
		[24] = {bp = "photoTarget24", id = nil},
		[25] = {bp = "photoTarget25", id = nil},
		[26] = {bp = "photoTarget26", id = nil},
		}
	
	self.signalImage = nil
	self.missionState = 0
	
	self.isSighted = false
	self.taken = false
end


function LevelBehavior102540202:Update()
	if self.missionState == 0 then
		self:photoTargetSpawn()
		local pos = BehaviorFunctions.GetTerrainPositionP("towerPos",self.levelId)
		self.signalImage = BehaviorFunctions.CreateEntity(20410010101,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		if self.isSighted == true then
			--LogError("true")
			BehaviorFunctions.PlayGuide(2214,1,1)
			self.missionState = 2
		end
	end
end


function LevelBehavior102540202:photoTargetSpawn()
	for i,v in ipairs(self.photoTargetList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,self.levelId)
		v.id = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil)
	end
end


function LevelBehavior102540202:EntryPhotoFrame(entityInstanceId)
	for i,v in ipairs(self.photoTargetList) do		
		if entityInstanceId == v.id then
			self.isSighted = true
		end
	end
end


function LevelBehavior102540202:ExitPhotoFrame(entityInstanceId)
	if entityInstanceId == self.photoTarget then
		self.isSighted = false
	end
end


function LevelBehavior102540202:OnPhotoClick()
	self.taken = true
end