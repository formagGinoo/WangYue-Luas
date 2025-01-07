TaskBehavior101120205 = BaseClass("TaskBehavior101120205")
--截停,播对话


function TaskBehavior101120205.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101120205:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.stepId = taskInfo.stepId
	self.role = nil
	self.taskState = 0
    self.carEcoId = 2003001010001
    self.dialogId = {
        101112501  --巡卫叫停
    }
    self.dialogState = 0
end

function TaskBehavior101120205:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
    --获得车的实体
    if not self.car then
        self.car = BehaviorFunctions.GetEcoEntityByEcoId(self.carEcoId)
    end
    if self.taskState == 0 then
		if self.car then
	        BehaviorFunctions.CarBrake(self.car, true)   
		end
        --BehaviorFunctions.StartStoryDialog(self.dialogId[1])
		--BehaviorFunctions.GetOffCar(self.car, self.role)
		--BehaviorFunctions.SendTaskProgress(self.taskId, self.stepId, 1)
        BehaviorFunctions.AddDelayCallByTime(1, BehaviorFunctions, BehaviorFunctions.SendTaskProgress, self.taskId, self.stepId, 1)
        self.taskState = 1
    end
    --local carSpeed = BehaviorFunctions.GetEntitySpeed(self.car)
	----print(carSpeed)
    --if carSpeed < 0.1 then
        ----BehaviorFunctions.GetOffCar(self.car, self.role)
        ----BehaviorFunctions.SendTaskProgress(self.taskId, 5, 1)
    --end
end