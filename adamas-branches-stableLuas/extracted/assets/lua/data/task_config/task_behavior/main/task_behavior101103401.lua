TaskBehavior101103401 = BaseClass("TaskBehavior101103401")
--装备真实之裂

function TaskBehavior101103401.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101103401:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil

	self.dialogList =
	{
		[1] = {Id = 101103401},--战斗开始timeline
	}
	
	self.YupeiEco = 3003001010001
end

function TaskBehavior101103401:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		BehaviorFunctions.ChangeEcoEntityCreateState(self.YupeiEco,true)
		self.missionState = 1
	elseif self.missionState == 1 then
		if CheckEntityInArea(self.role,"Task101102202BattleArea01","Task_main_01") then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.missionState = 2
		end
	end
end

function TaskBehavior101103401:CatchPartnerEnd()
	BehaviorFunctions.SendTaskProgress(101103401,1,1)
end