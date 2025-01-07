DailyActivityCtrl = BaseClass("DailyActivityCtrl",Controller)

function DailyActivityCtrl:__init()
	self.info = nil
	self.fullActivation = false
end


function DailyActivityCtrl:UpdateInfo(data)
	self.info = data
	--是否满活跃
	self.fullActivation = self.info.value >= DailyActivityConfig.GetMaxActivation(self.info.control_id)
	
	EventMgr.Instance:Fire(EventName.UpdateDailyActivity, self.info, self.fullActivation)
end

function DailyActivityCtrl:GetInfo()
	return self.info
end

function DailyActivityCtrl:ReceiveActivityReward(activation)
	mod.DailyActivityFacade:SendMsg("activity_award", activation)
end

function DailyActivityCtrl:IsFullActivation()
	return self.fullActivation
end

function DailyActivityCtrl:OnGetAwardResult(data)
	--if data.error_code == 0 then
		--return 
	--end
	--EventMgr.Instance:Fire(EventName.UpdateDailyRewardType, data.award_value)
	print(data.error_code, data.award_value)
end

function DailyActivityCtrl:CheckCanGetReward()
	if not self.info then
		return false
	end
	
	local canGet = self.info.can_get
	if not canGet then
		return false
	end
	
	return #canGet > 0
end

function DailyActivityCtrl:CheckTaskCanFinish()
	if self.fullActivation then
		return false
	end
	
	if not self.info then
		return false
	end
	
	local taskList = self.info.task_list
	if not taskList then
		return false
	end
	
	for _, v in pairs(taskList) do
		if mod.SystemTaskCtrl:CheckTaskCanFinish(v.task_id) then
			return true
		end
	end
	
	return false
end