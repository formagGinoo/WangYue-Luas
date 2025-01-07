ActivityCtrl = BaseClass("ActivityCtrl",Controller)

function ActivityCtrl:__init()
	self.activitys = {}
	self.activityRpNodeList = {}
	self.activitysData = {}
	self.SignInfo = {}
    self.TaskInfo = {}
    EventMgr.Instance:AddListener(EventName.StartFight, self:ToFunc("UpdateLocalActivity"))
    EventMgr.Instance:AddListener(EventName.ActivitySignInUpdate, self:ToFunc("UpdateLocalActivity"))
    EventMgr.Instance:AddListener(EventName.AdventureChange, self:ToFunc("UpdateLocalActivity"))
	EventMgr.Instance:AddListener(EventName.SystemTaskFinished, self:ToFunc("UpdateLocalActivity"))
	EventMgr.Instance:AddListener(EventName.ActivityTaskUpdate, self:ToFunc("UpdateLocalActivity"))
	
end

function ActivityCtrl:__delete()
    EventMgr.Instance:RemoveListener(EventName.StartFight, self:ToFunc("UpdateLocalActivity"))
    EventMgr.Instance:RemoveListener(EventName.ActivitySignInUpdate, self:ToFunc("UpdateLocalActivity"))
    EventMgr.Instance:RemoveListener(EventName.AdventureChange, self:ToFunc("UpdateLocalActivity"))
	EventMgr.Instance:RemoveListener(EventName.SystemTaskFinished, self:ToFunc("UpdateLocalActivity"))
	EventMgr.Instance:RemoveListener(EventName.ActivityTaskUpdate, self:ToFunc("UpdateLocalActivity"))
end
-- 添加本地活动
function ActivityCtrl:UpdateLocalActivity()
    if not Fight.Instance then
        return
    end
	TableUtils.ClearTable(self.activitys)
    if Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.QianDao) and not self:CheckSignActivityFinish(101) then
        table.insert(self.activitys, { ActivityType = "SignIn", ActivityID = 101})
    end

    if Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.XinShouRenWu) and  not self:CheckTaskActivityFinishAll(1) then
        table.insert(self.activitys, { ActivityType = "Task", ActivityID = 1})
    end
    self:UpdateActivitysInfo()
end

-- 添加活动信息
function ActivityCtrl:UpdateActivitysInfo()
    
    local findAll = true
    for k, v in pairs(self.activitys) do
        if not self.activitysData[v.ActivityType .. v.ActivityID] then
            findAll = false
        end
    end
    local needRebuild = #self.activitys ~= TableUtils.GetTabelLen(self.activitysData) or not findAll

    

    if needRebuild then
        self.activitysData = {}
        for k, v in pairs(self.activitys) do
            if not self.activitysData[v.ActivityType .. v.ActivityID] then
                self.activitysData[v.ActivityType .. v.ActivityID] = self:CreatActivityData(v)
            end
        end

        self:RebuildRedPointTree()
	    EventMgr.Instance:Fire(EventName.ActivitysInfoChange)
    end
end

function ActivityCtrl:CheckHasActivityPlaying()
    return  #self.activitys > 0
end

function ActivityCtrl:CheckTaskDayComplete(taskList)
    local isCompleted = true
    for k, v in pairs(taskList) do
        -- 完成状态 1:未完成 2:完成未领取 3:已领取
        local progress, maxProgress = DailyActivityConfig.GetTaskProgress(v)
        local finishType = progress == -1 and 3 or 1
        if progress >= maxProgress then
            progress = maxProgress
            finishType = 2
        end

        if finishType ~= 3 then
            isCompleted = false
        end
    end 

	return isCompleted
end
function ActivityCtrl:CheckTaskDayCanGet(taskList)
    for k, v in pairs(taskList) do
        -- 完成状态 1:未完成 2:完成未领取 3:已领取
        local progress, maxProgress = DailyActivityConfig.GetTaskProgress(v)
        local finishType = progress == -1 and 3 or 1
        if progress >= maxProgress then
            progress = maxProgress
            finishType = 2
        end

        local canget = finishType == 2
        if canget then
            return true
        end
    end 

	return false
end
function ActivityCtrl:CheckTaskDayLock(id, dayNum)
    return self.TaskInfo[id].acc_times < dayNum
end

-- 构建活动红点树
function ActivityCtrl:RebuildRedPointTree()
    self.activityRPNode = self.activityRPNode or RedPointMgr.Instance:GetRedPointNode(RedPointName.SystemMenu,RedPointName.Activity)


    for i, v in ipairs(self.activityRpNodeList) do
        RedPointMgr.Instance:RemoveRedInfo(v)
    end
	self.activityRPNode:RemoveAllChild()
    self.activityRpNodeList = {}
    for k, v in pairs(self.activitys) do
        local point = RedPointNode.New()
        local pointKey = v.ActivityType .. v.ActivityID
        point:CreateNode(pointKey, self.activityRPNode, self:CreatActivityRPNode(v))
        table.insert(self.activityRpNodeList,pointKey)
        
    end
    self.activityRPNode:RefreshRedPoint()
end

-- 构建活动红点
function ActivityCtrl:CreatActivityRPNode(activity)
    if activity.ActivityType == "SignIn" then
        return {
            childs = {},
            eventList = {
                EventName.ActivitySignInUpdate
            }, 
            checkFunc = function()
				return self:CheckSignActivityRedPoint(activity.ActivityID)
            end
        }
    elseif activity.ActivityType == "Task" then
        return {
            childs = {},
            eventList = {
                EventName.SystemTaskFinish,
				EventName.SystemTaskChange,
				EventName.SystemTaskFinished,
				EventName.SystemTaskUpdate,
				EventName.ActivityTaskUpdate,
            }, 
            checkFunc = function()
                return self:CheckTaskActivityRedPoint(activity.ActivityID)
            end
        }
    end
end

function ActivityCtrl:CheckTaskUnlock( taskId)
    local config = ActivityConfig.GetTaskConfig(taskId)
    return Fight.Instance.conditionManager:CheckConditionByConfig(config.condition)
end

function ActivityCtrl:CheckSignActivityRedPoint(id)
    local result = false
	local info = mod.ActivityCtrl:GetSignInActData(id)
    if info then
        
        for k, v in pairs(info) do
            if v == 1 then
                result = true
            end
        end
    end
    return result
end

function ActivityCtrl:CheckSignActivityFinish(id)
    local result = true
	local info = self:GetSignInActData(id)
    
    local cfg = ActivityConfig.GetDataSignInReward(id)
    local finishCount = 0
    if info then
        for k, v in pairs(info) do
            if v == 2 then
                finishCount = finishCount + 1
            end
        end
		return finishCount == #cfg
	else
		return true
    end
end
-- 该id活动下所有task+进度条是否已完成领取
function ActivityCtrl:CheckTaskActivityFinishAll(id)
	if not self.TaskInfo[id] then return true end
    local taskGroupList = ActivityConfig.GetActivityTask(id)
    local finish = true
    for k, v in pairs(taskGroupList) do
        if not self:CheckTaskDayComplete(v) then
            finish = false
        end
    end
    finish = self:GetTaskSumRewardFinish(id) and finish
    return finish
end

-- 该id活动下所有task+进度条是否有没领取的
function ActivityCtrl:CheckTaskActivityRedPoint(id)
    local taskGroupList = ActivityConfig.GetActivityTask(id)
    local result = false
    for i, v in ipairs(taskGroupList) do
        if self:CheckTaskDayCanGet(v) then
            result = true
        end
    end
    result = self:GetTaskSumRewardRedPoint(id) or result
    return result
end

function ActivityCtrl:GetDefaultDay(id)
    local taskGroupList = ActivityConfig.GetActivityTask(id)
    local result = self.TaskInfo[id].acc_times
	result = result > #taskGroupList and #taskGroupList or result
	local catGetDay = nil
    for k, v in pairs(taskGroupList) do
        if self:CheckTaskDayCanGet(v) then
			catGetDay = k
        end
    end
    return catGetDay or result
end
function ActivityCtrl:GetActivity()
    return self.activitys
end

function ActivityCtrl:GetActivityDataList()
	return self.activitysData
end

function ActivityCtrl:CreatActivityData(activity)
    local activityData = {}
    activityData.actKey = activity.ActivityType .. activity.ActivityID

    if activity.ActivityType == "SignIn" then
        local signInfo = ActivityConfig.GetDataSignInMain(activity.ActivityID)
        activityData.name = signInfo.name
        activityData.id = signInfo.id
        activityData.banner = signInfo.tab_cover
        activityData.icon = signInfo.tab_subscript
        activityData.priority = signInfo.priority
        activityData.callback = function(parent, isSelect)
            if isSelect then
                parent.showPanel = parent:OpenPanel(ActivitySignInPanel,activityData)
            else
                parent:ClosePanel(ActivitySignInPanel)
            end
        end

    elseif activity.ActivityType == "Task" then
        local signInfo = ActivityConfig.GetDataNoviceTaskMain(activity.ActivityID)
        activityData.name = signInfo.name
        activityData.id = signInfo.id
        activityData.banner = signInfo.tab_cover
        activityData.icon = signInfo.tab_subscript
        activityData.priority = signInfo.priority
        activityData.system_task_group = signInfo.system_task_group
        activityData.callback = function(parent, isSelect)
            if isSelect then
                parent.showPanel = parent:OpenPanel(ActivityTaskPanel,activityData)
            else
                parent:ClosePanel(ActivityTaskPanel)
            end
        end
    end
    return activityData
end


function ActivityCtrl:UpdateTaskActivity(data)
	for k, v in pairs(data.novice_list) do
        self.TaskInfo[v.id] = v
    end
	EventMgr.Instance:Fire(EventName.ActivityTaskUpdate, self.TaskInfo)
end

function ActivityCtrl:UpdateSignInActivity(data)

    for k, v in pairs(data.daily_sign_in_list) do
        local signInStatus= {}
        for w, j in pairs(v.status_list) do
            signInStatus[j.nth_day] = j.status
        end
        self.SignInfo[v.id] = signInStatus
    end
    
	EventMgr.Instance:Fire(EventName.ActivitySignInUpdate, self.SignInfo)
end

function ActivityCtrl:ReceiveTaskSumReward(id,rewardKey)
    mod.ActivityFacade:SendMsg("novice_award", id, rewardKey)
end

function ActivityCtrl:GetTaskSumRewardInfo(id)
    if self.TaskInfo[id] then
        local gears = ActivityConfig:GetTaskGearArray(id)
        local reachIndex = 0
        local tempIndex = 0
        for i, v in ipairs(gears) do
            if self.TaskInfo[id].value >= v.num then
                reachIndex = i
            end
        end
        return self.TaskInfo[id].value , gears[#gears].num, reachIndex/#gears
    end
end

-- task进度条做完没
function ActivityCtrl:GetTaskSumRewardFinish(id)
    if self.TaskInfo[id] then
        local gears = ActivityConfig:GetTaskGearArray(id)
        return #self.TaskInfo[id].reward_value_list == #gears
    end
end

-- task进度条有没有没领的
function ActivityCtrl:GetTaskSumRewardRedPoint(id)
    if self.TaskInfo[id] then
        local gears = ActivityConfig:GetTaskGear(id)
        local canGetNum = 0
        for k, v in pairs(gears) do
            if self.TaskInfo[id].value >= v.num then
                canGetNum = canGetNum +1
            end
        end
        return canGetNum > #self.TaskInfo[id].reward_value_list
    end
end

function ActivityCtrl:GetTaskSumRewardStatus(id, rewardKey)
    if self.TaskInfo[id] then
        local rewarded = false
        for k, v in pairs(self.TaskInfo[id].reward_value_list) do
            if v == rewardKey then
                rewarded = true
            end
        end
        local gears = ActivityConfig:GetTaskGear(id)
        local canGet =  self.TaskInfo[id].value >= gears[rewardKey].num

        return rewarded and 2 or( canGet and 1 or 3)
    end
end

function ActivityCtrl:GetSignInActData(id)
    if self.SignInfo then
        return self.SignInfo[id]
    end
end

function ActivityCtrl:GetSignInReward(id, day)
    mod.ActivityFacade:SendMsg("daily_sign_in_award", id, day)
end
