--打败悬天组织的小喽啰
TaskBehavior101130501 = BaseClass("TaskBehavior101130501")

function TaskBehavior101130501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101130501:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {

    }
    --功能判断
    self.isAddLevel = true
end

function TaskBehavior101130501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then
        if self.isAddLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId) then
            BehaviorFunctions.AddLevel(self.taskId)
        end
    self.taskState = 1
    end
end