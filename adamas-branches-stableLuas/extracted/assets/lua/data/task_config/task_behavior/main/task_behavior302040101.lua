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
	self.taskId = 302040101
	distance = 0
	self.defaultDistance = 0
	self.taskState = 0
	self.taskStateEnum = {
		Default = 0,
		Initial = 1,
		Dialog01 = 2,
	}
	self.dialogList = {
		[1] = {Id = 202050301},
		[2] = {Id = 202051201},
	}
	self.isTipShow = true
end

function TaskBehavior302040101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	local rolePos = BehaviorFunctions.GetPositionP(self.role)
	local targetPos = BehaviorFunctions.GetTerrainPositionP("MailingRunPos01",10020001,"LogicMailing")
	local KeyanrenyuanPos = BehaviorFunctions.GetTerrainPositionP("Keyanrenyuan01",10020001,"LogicNpc_Cunzhuang")
	local distance = BehaviorFunctions.GetDistanceFromPos(rolePos, targetPos)
	local targetDistance = BehaviorFunctions.GetDistanceFromPos(KeyanrenyuanPos, rolePos)
	self.roundedDistance = math.floor(distance)

	--显示距离
	if self.taskState == self.taskStateEnum.Default then
		self.defaultDistance = BehaviorFunctions.GetDistanceFromPos(rolePos, targetPos)
		BehaviorFunctions.ShowTip(302040101,self.roundedDistance)
		self.taskState = self.taskStateEnum.Initial
	end

	
	if (distance - self.defaultDistance == 1 or distance - self.defaultDistance == -1) and self.isTipShow then
		--BehaviorFunctions.HideTip(302040101)
		BehaviorFunctions.ShowTip(302040101,self.roundedDistance)
		--BehaviorFunctions.ChangeSubTipsDesc(1,302040101,roundedDistance)ww
	end

    --播放对话2
    if distance <= 40 and self.taskState == self.taskStateEnum.Initial then
        BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
        self.taskState = self.taskStateEnum.Dialog01
    end

	--靠近任务完成点，关闭tips
    if distance <= 5 then
		BehaviorFunctions.HideTip(302040101)
		self.isTipShowDistance = false
	end


    --距离过远提示
    if targetDistance >= 200 then
		BehaviorFunctions.HideTip(302040101)
		if not BehaviorFunctions.GetNowPlayingId then
			BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		end
        --self.isTipShow = false
    end

	--进入距离内
	if targetDistance <= 200 and self.isTipShow == false then
		self.isTipShow = true
	end

	--没有在追踪任务的话就别显示tip了，真的好烦
	if BehaviorFunctions.GetGuideTaskId() ~= self.taskId then
		BehaviorFunctions.HideTip(302040101)
	end
end
	