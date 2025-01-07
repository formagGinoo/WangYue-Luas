TaskBehavior302040101 = BaseClass("TaskBehavior302040101")
--支线任务组：寻找脉灵
--子任务1：根据距离信息提示，找到脉灵出没的区域
--完成条件：距离判断

function TaskBehavior302040101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior302040101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
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
	self.dialogList = {
		[1] = {Id = 202050201},
		[2] = {Id = 202050301},
		[3] = {Id = 202051201},
	}
	self.taskState = 0
end

function TaskBehavior302040101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	local rolePos = BehaviorFunctions.GetPositionP(self.role)
	local TargetPos = BehaviorFunctions.GetTerrainPositionP("MailingRunPos01",10020001,"LogicMailing")
	self.distance = BehaviorFunctions.GetDistanceFromPos(rolePos, TargetPos)

	--显示距离
	if self.taskState == 0 then
		self.defaultDistance = BehaviorFunctions.GetDistanceFromPos(rolePos, TargetPos)
		BehaviorFunctions.ShowTip(302040101)
		--BehaviorFunctions.ShowTopTarget(302040101)
		self.taskState = 1
	end

	if self.distance - self.defaultDistance == 1 or -1 then
		local roundedDistance = math.floor(self.distance)
		BehaviorFunctions.ChangeSubTipsDesc(1,302040101,roundedDistance)
		--BehaviorFunctions.ChangeTopTargetDesc(1,302040101,roundedDistance)
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
		--BehaviorFunctions.TopTargetFinish(302040101)
	end

    --距离过远提示
    if self.distance >= 200 and not self.dialogStateEnum.TooFar then
        BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
        self.dialogState = self.dialogStateEnum.TooFar
    end
end