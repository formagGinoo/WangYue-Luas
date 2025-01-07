TaskBehavior102040202 = BaseClass("TaskBehavior102040202")
--大世界任务组3：去城镇
--子任务2：进城
--完成条件：到达城镇

--村口遇见神荼后关卡

function TaskBehavior102040202.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102040202:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.levelState = 0
	self.dialogId1 = 102220101  --往熙来飞播
	self.dialogId2 = 102220201  --熙来门口timeline
end

function TaskBehavior102040202:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	--创建村口关卡
	if self.levelState == 0 then
		if not BehaviorFunctions.CheckLevelIsCreate(102040202) then
			BehaviorFunctions.AddLevel(102040202)
		end
		self.levelState = 1
	end
end