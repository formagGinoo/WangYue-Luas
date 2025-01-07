TaskBehavior105030501 = BaseClass("TaskBehavior105030501")
--钻烟囱

function TaskBehavior105030501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105030501:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.yancongId = {
		2040901,2040902,2040903,2040904
		}
	self.dialogId = {
        102320801
    }

    --功能判断
    self.isAddLevel = true
    self.isDialog = true
end

function TaskBehavior105030501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    
    if self.taskState == 0 then
        
        if self.isDialog then
            BehaviorFunctions.StartStoryDialog(self.dialogId[1])
        end

        --中间需要接入钻烟囱图文教程，未做

        --下一任务中楼顶刷怪关卡
        if self.isAddLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId) then
			BehaviorFunctions.AddLevel(self.taskId)
        end
        self.taskState = 1
    end

end

function TaskBehavior105030501:WorldInteractClick(uniqueId,instanceId)
	if BehaviorFunctions.GetEntityEcoId(instanceId) == 2201001010004 then
		BehaviorFunctions.SendTaskProgress(self.taskId,1,1)
	end
end