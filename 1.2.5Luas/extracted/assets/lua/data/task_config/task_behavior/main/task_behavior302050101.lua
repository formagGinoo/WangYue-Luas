TaskBehavior302050101 = BaseClass("TaskBehavior302050101")
--支线任务组：卫道者说
--子任务1：前往
--完成条件：完成对话

--需要用到，tips，和2个居民对话，每次获取到相应的对话id结束（用相关回调来写）

function TaskBehavior302050101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior302050101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.levelId = 202030201
	self.time = nil
	self.distance = 0
	self.defaultDistance = 0
	self.dialogState = 0
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Play01 = 2,
		Play02 = 3,
        TooFar = 4,
	}
	self.dialogList =
	{
		[1] = {Id = 202050201},
		[2] = {Id = 202050301},
	}
	self.taskState = 0
end

function TaskBehavior302050101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	local rolePos = BehaviorFunctions.GetPositionP(self.role)
	local TargetPos = BehaviorFunctions.GetTerrainPositionP("MailingRunPos01",10020001,"LogicMailing")
	self.distance = BehaviorFunctions.GetDistanceFromPos(rolePos, TargetPos)

	--显示距离
	if self.taskState == 0 then
		self.defaultDistance = BehaviorFunctions.GetDistanceFromPos(rolePos, TargetPos)
		BehaviorFunctions.ShowTip(302040101)
		self.taskState = 1
	end

	if self.distance - self.defaultDistance == 1 or -1 then
		local roundedDistance = math.floor(self.distance)
		BehaviorFunctions.ChangeSubTipsDesc(1,302040101,roundedDistance)
	end

	if self.dialogState == self.dialogStateEnum.Default then
		self.dialogState = self.dialogStateEnum.NotPlaying
	end
	
	--[[播放对话1
    if self.dialogState == self.dialogStateEnum.NotPlaying then
        BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
        self.dialogState = self.dialogStateEnum.Play01
    end
    --]]

    --播放对话2
    if self.distance <= 40 and  not self.dialogState == self.dialogStateEnum.Play02 then
        BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
        self.dialogState = self.dialogStateEnum.Play02
    end

    if self.distance <= 5 then  
		BehaviorFunctions.HideTip(302040101)
	end

    --距离过远提示
    if self.distance >= 200 and not self.dialogStateEnum.TooFar then
        BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
        self.dialogState = self.dialogStateEnum.TooFar
    end



    --[[完成任务4
    if self.distance <= 0 and not self.isTaskCompleted then
        BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId, 1, 1)
        self.isTaskCompleted = true
    end
	]]
end


function TaskBehavior102060301:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end