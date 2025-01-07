TaskBehavior101120801 = BaseClass("TaskBehavior101120801")
--一开打就播对话，打败后完成任务


function TaskBehavior101120801.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101120801:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.xunweiNpcId = 5001005
    self.dialogId = {
        
    }
    self.dialogState = 0

    --创建关卡
    self.isAddLevel = true
end

function TaskBehavior101120801:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    if not self.xunwei then
        self.npcEntity = BehaviorFunctions.GetNpcEntity(self.xunweiNpcId)
        if self.npcEntity then
            self.xunwei = self.npcEntity.instanceId
        end
		if self.xunwei then
	        BehaviorFunctions.SetEntityShowState(self.xunwei, false)
			BehaviorFunctions.ShowCharacterHeadTips(self.xunwei, false)
		end
    end

    if self.taskState == 0 then
        if self.isAddLevel and not BehaviorFunctions.CheckLevelIsCreate(self.taskId) then
            BehaviorFunctions.AddLevel(self.taskId)
        end
    self.taskState = 1
    end
end