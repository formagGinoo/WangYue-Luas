TaskBehavior900000004 = BaseClass("TaskBehavior900000004")
--首次低血量提醒使用药物引导

function TaskBehavior900000004.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior900000004:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.tipsOpen = false
	self.tipsFinish = false
end

function TaskBehavior900000004:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.tipsOpen == false then
		local lifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
		local playerState = BehaviorFunctions.GetEntityState(self.role)
		if lifeRatio <= 5000 and lifeRatio > 0 then
			--使用药物引导
			BehaviorFunctions.ShowGuideImageTips(20014)
			self.tipsOpen = true
		end
	else
		if self.tipsFinish == false then
			BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
			self.tipsFinish = true
		end
	end
end
