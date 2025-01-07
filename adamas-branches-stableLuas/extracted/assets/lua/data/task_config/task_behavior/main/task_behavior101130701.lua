--打败悬天组织的负责人
TaskBehavior101130701 = BaseClass("TaskBehavior101130701")

function TaskBehavior101130701.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101130701:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {

    }
    --功能判断
    self.isAddLevel = true
end

function TaskBehavior101130701:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then
        if self.isAddLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId) then
            BehaviorFunctions.AddLevel(self.taskId)
        end
    self.taskState = 1
    end
end
