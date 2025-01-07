TaskBehavior101101601 = BaseClass("TaskBehavior101101601")
--上车点火

function TaskBehavior101101601.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101101601:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.dialogList =
	{
		[1] = {Id = 101101501,isPlayed = false},--靠近车辆timeline
		[2] = {Id = 101101601,isPlayed = false},--开车熄火timeline
	}
	
	self.xumuCarEcoId = 2003001010001
	self.xumuCarIns = nil
	self.imagTips = false
end

function TaskBehavior101101601:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	local xumuCarIns = BehaviorFunctions.GetEcoEntityByEcoId(self.xumuCarEcoId)
	
	if not self.xumuCarIns and xumuCarIns then
 
		self.xumuCarIns = xumuCarIns
	elseif self.xumuCarIns and not xumuCarIns then
		self.xumuCarIns = nil
	end

	--生态车显示
	if self.missionState == 0 then
		--BehaviorFunctions.ChangeEcoEntityCreateState(self.xumuCarEcoId,true)
		self.missionState = 1
		
	--播放熄火timeline
	elseif self.missionState == 2 then
		BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		self.missionState = 3
		
	--熄火timeline结束
	elseif self.missionState == 4 then
		BehaviorFunctions.GetOffCar(self.xumuCarIns)
		self.missionState = 999
		
	elseif self.missionState == 999 then

		self.missionState = 1000
	end
end

function TaskBehavior101101601:WorldInteractClick(uniqueId,instanceId)
	if instanceId == self.xumuCarIns then
		self.missionState = 2
	end
end

function TaskBehavior101101601:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[2].Id then
		self.missionState = 4
	end
end