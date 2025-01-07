LevelBehavior102540203 = BaseClass("LevelBehavior102540203",LevelBehaviorBase)
--多拍几张或直接离开区域

function LevelBehavior102540203.GetGenerates()
	local generates = {20410010101}
	return generates
end


function LevelBehavior102540203:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.photoTarget = nil

	self.photoTargetList = {
		[1] = {isInSight = false,bp = "photoTarget1", id = nil},
		[2] = {isInSight = false,bp = "photoTarget2", id = nil},
		[3] = {isInSight = false,bp = "photoTarget3", id = nil},
		[4] = {isInSight = false,bp = "photoTarget4", id = nil},
		[5] = {isInSight = false,bp = "photoTarget5", id = nil},
		[6] = {isInSight = false,bp = "photoTarget6", id = nil},
		[7] = {isInSight = false,bp = "photoTarget7", id = nil},
		[8] = {isInSight = false,bp = "photoTarget8", id = nil},
		[9] = {isInSight = false,bp = "photoTarget9", id = nil},
		[10] = {isInSight = false,bp = "photoTarget10", id = nil},
		[11] = {isInSight = false,bp = "photoTarget11", id = nil},
		[12] = {isInSight = false,bp = "photoTarget12", id = nil},
		[13] = {isInSight = false,bp = "photoTarget13", id = nil},
		[14] = {isInSight = false,bp = "photoTarget14", id = nil},
		[15] = {isInSight = false,bp = "photoTarget15", id = nil},
		[16] = {isInSight = false,bp = "photoTarget16", id = nil},
		[17] = {isInSight = false,bp = "photoTarget17", id = nil},
		[18] = {isInSight = false,bp = "photoTarget18", id = nil},
		[19] = {isInSight = false,bp = "photoTarget19", id = nil},
		[20] = {isInSight = false,bp = "photoTarget20", id = nil},
		[21] = {isInSight = false,bp = "photoTarget21", id = nil},
		[22] = {isInSight = false,bp = "photoTarget22", id = nil},
		[23] = {isInSight = false,bp = "photoTarget23", id = nil},
		[24] = {isInSight = false,bp = "photoTarget24", id = nil},
		[25] = {isInSight = false,bp = "photoTarget25", id = nil},
		[26] = {isInSight = false,bp = "photoTarget26", id = nil},
	}

	self.signalImage = nil
	self.missionState = 0

	self.isSighted = false
	self.taken = false
	
	self.count = 0
	self.maxCount = 3
	self.maxRange = 20
end


function LevelBehavior102540203:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		self:photoTargetSpawn()
		local pos = BehaviorFunctions.GetTerrainPositionP("towerPos",self.levelId)
		self.signalImage = BehaviorFunctions.CreateEntity(20410010101,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		self.missionState = 1
	end

	if self.missionState == 1 then
		if self.count >=self.maxCount then
			self.missionState = 2
		end
	end
	
	self:DistanceCheck()
	
end


function LevelBehavior102540203:photoTargetSpawn()
	for i,v in ipairs(self.photoTargetList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,self.levelId)
		v.id = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	end
end


function LevelBehavior102540203:EntryPhotoFrame(entityInstanceId)
	for i,v in ipairs(self.photoTargetList) do
		if entityInstanceId == v.id then
			v.isInSight = true
		end
	end
end


function LevelBehavior102540203:ExitPhotoFrame(entityInstanceId)
	for i,v in ipairs(self.photoTargetList) do
		if entityInstanceId == v.id then
			v.isInSight = false
		end
	end
end


function LevelBehavior102540203:OnPhotoClick()
	for i,v in ipairs(self.photoTargetList) do
		if v.isInSight == true then
			self.isSighted = true
			break
		else
			self.isSighted = false
		end
	end
	
	if self.isSighted == true then
		self.count = self.count + 1
		self.isSighted = false
		--LogError("self.count"..self.count)
	end
end

function LevelBehavior102540203:DistanceCheck()
	local exitPos = BehaviorFunctions.GetTerrainPositionP("ExitPos1",self.levelId)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distanceBetween = BehaviorFunctions.GetDistanceFromPos(exitPos,playerPos)
	
	if distanceBetween > self.maxRange then
		BehaviorFunctions.ClosePhotoPanel()
		BehaviorFunctions.FinishLevel(self.levelId)
	end
end


function LevelBehavior102540203:OnPhotoClickEnd()
	if self.missionState == 2 then
		BehaviorFunctions.ClosePhotoPanel()
		BehaviorFunctions.FinishLevel(self.levelId)
		self.missionState = 999
	end
end