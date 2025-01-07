LevelBehavior301010404 = BaseClass("LevelBehavior301010404",LevelBehaviorBase)


function LevelBehavior301010404.GetGenerates()
	local generates = {200000101}
	return generates
end


function LevelBehavior301010404:__init(fight)
	----关卡参数----
	self.fight = fight
	self.role = nil
	self.frame = nil
	self.carEcoId = 2003001030002
	self.taskLevelId = 301010404

	self.button = nil
	self.buttonUIId = nil
	self.hasButton = false
	----关卡进度参数----
	self.missionState = 0
end


function LevelBehavior301010404:init()

end


function LevelBehavior301010404:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--获得车的实体
	if not self.car then
		self.car = BehaviorFunctions.GetEcoEntityByEcoId(self.carEcoId)
	end
	
	if self.missionState == 0 then
		local pos = BehaviorFunctions.GetTerrainPositionP("InteractPos1",self.levelId)
		self.button = BehaviorFunctions.CreateEntity(200000101,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		self.missionState = 1
	end

	if self.missionState == 1 then

	end

	if self.missionState == 2 then
		BehaviorFunctions.SendTaskProgress(301010404,1,1)
		self.missionState = 999
		BehaviorFunctions.RemoveLevel(self.levelId)
	end
end


function LevelBehavior301010404:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.button and self.hasButton == false then
		self.buttonUIId = BehaviorFunctions.WorldInteractActive(self.button,1,nil,"查看",1)
		self.hasButton = true
	end
end


function LevelBehavior301010404:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.button and self.hasButton == true then
		BehaviorFunctions.WorldInteractRemove(self.button,self.buttonUIId)
		self.buttonUIId = nil
		self.hasButton = false
	end
end


function LevelBehavior301010404:WorldInteractClick(uniqueId,instanceId)
	if uniqueId == self.buttonUIId then
		BehaviorFunctions.WorldInteractRemove(self.button,self.buttonUIId)
		self.missionState = 2
		self.button = nil
		self.hasButton = false
	end
end