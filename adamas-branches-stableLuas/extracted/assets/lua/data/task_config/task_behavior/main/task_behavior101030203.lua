TaskBehavior101030203 = BaseClass("TaskBehavior101030203")
--调查昏迷人员

function TaskBehavior101030203.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030203:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	
	self.weakGuide =
	{
		[1] = {Id = 2219,state = false,Describe ="拖拽进度条调整调查模式进度",count = 0},
		[2] = {Id = 2220,state = false,Describe ="在调查模式中旋转视角",count = 0},
		[3] = {Id = 2221,state = false,Describe ="在调查模式中长按F收集线索",count = 0},
		[4] = {Id = 2222,state = false,Describe ="退出调查模式",count = 0},
		[5] = {Id = 2223,state = false,Describe ="点击骇入对准脉灵",count = 0},
		[6] = {Id = 2224,state = false,Describe ="按下同调与脉灵同调",count = 0},
	}
	
	self.inArea = false
	self.inDetectMode = false
	
	self.clueInSign = false
	self.inClueArea = false
end

function TaskBehavior101030203:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if BehaviorFunctions.CheckEntityInArea(self.role,"Task1010302Area01","Task_main_00")then
		self.inArea = true
	else
		self.inArea = false
	end
	
	if self.inArea and not self.inDetectMode then
		self:HackTutorial()
	elseif self.inDetectMode and self.missionState < 2 then
		self:DetectTutorial()
	elseif not self.inArea then
		self:RemoveWeakGuide()
	end
end

--进入区域
function TaskBehavior101030203:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if logicName == "Task_main_00" then
			if areaName == "Task1010302Area01" then
				self.inArea = true
			end
		end
	end
end

--退出区域
function TaskBehavior101030203:ExitArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if logicName == "Task_main_00" then
			if areaName == "Task1010302Area01" then
				self.inArea = false
			end
		end
	end
end

--进入调查模式回调
function TaskBehavior101030203:ExploreStartEvent(dialogId)
	if dialogId == 101204701 then
		self:RemoveWeakGuide()
		if self.missionState == 0 then
			if self.weakGuide[1].state == false then
				self:WeakGuide(self.weakGuide[1].Id)
			end
		end
		self.inDetectMode = true
	end
end

--退出调查模式回调
function TaskBehavior101030203:ExploreEndEvent(dialogId)
	if dialogId == 101204701 then
		self:RemoveWeakGuide()
		self.inDetectMode = false
	end
end

--线索完成回调
function TaskBehavior101030203:ClueUnlock(dialogId,clueId)
	if dialogId == 101204701 then
		self:RemoveWeakGuide()
		self.missionState = 1
	end
end

--游标进入线索区域
function TaskBehavior101030203:EnterClueArea(dialogId,clueId,isInArea,isFinish)
	if dialogId == 101204701 then
		if isInArea == true and isFinish == false and clueId ~= 1004 then
			self.inClueArea = true
		elseif isInArea == false then
			self.inClueArea = false
		end
	end
end

--线索进入视野
function TaskBehavior101030203:ClueEnterView(dialogId,clueId,isInSign,unlock)
	if dialogId == 101204701 then
		if isInSign == true and unlock == false then
			self.clueInSign = true
		elseif isInSign == false then
			self.clueInSign = false
		end
	end
end

--线索全解锁
function TaskBehavior101030203:ClueFullUnlock(dialogId)
	if dialogId == 101204701 then
		self.missionState = 2
		if self.weakGuide[4].state == false then
			self:WeakGuide(self.weakGuide[4].Id)
		end
		BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		BehaviorFunctions.AddDelayCallByTime(3.5,BehaviorFunctions,BehaviorFunctions.ShowTip,100000002,"所有线索已调查完成")
		BehaviorFunctions.AddDelayCallByTime(6,BehaviorFunctions,BehaviorFunctions.ForceExitStory)
	end
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101030203:WeakGuide(guideId)
	local result = false
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
		if v.Id == guideId then
			v.state = true
			result = true
		else
			v.state = false
		end
	end
	if result == true then
		BehaviorFunctions.PlayGuide(guideId,1,1)
	end
end

--关闭所有弱引导
function TaskBehavior101030203:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
		if v.state == true then
			v.state = false
		end
	end
end

function TaskBehavior101030203:DetectTutorial()
	if not self.inClueArea then
		if self.weakGuide[1].state == false then
			self:WeakGuide(self.weakGuide[1].Id)
		end
	else
		if not self.clueInSign then
			if self.weakGuide[2].state == false then
				self:WeakGuide(self.weakGuide[2].Id)
			end
		else
			if self.weakGuide[3].state == false then
				self:WeakGuide(self.weakGuide[3].Id)
			end
		end
	end
end

function TaskBehavior101030203:HackTutorial()
	local hackMode = BehaviorFunctions.GetHackMode()
	--如果玩家不处于骇入模式下
	if hackMode == nil and self.weakGuide[5].state == false then
		self:WeakGuide(self.weakGuide[5].Id)
	--处于骇入模式下
	elseif hackMode == 10000 and self.weakGuide[6].state == false then
		self:WeakGuide(self.weakGuide[6].Id)
	end
end

