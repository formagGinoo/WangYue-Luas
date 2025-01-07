TaskBehavior105010101 = BaseClass("TaskBehavior105010101")
--第四章开头回到维安司

function TaskBehavior105010101.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior105010101:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
	self.dialogId = {102290501}

    --功能判断
    self.isDialog = true
end

function TaskBehavior105010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    if self.taskState == 0 then       
        if self.isDialog then
            BehaviorFunctions.StartStoryDialog(self.dialogId[1])
            BehaviorFunctions.AddDelayCallByFrame(6,BehaviorFunctions,BehaviorFunctions.DoMagic,self.PartnerAllParm.role,self.PartnerAllParm.role,1000048)
        end
    self.taskState = 1
    end
end