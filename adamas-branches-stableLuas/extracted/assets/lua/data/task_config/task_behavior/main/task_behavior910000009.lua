TaskBehavior910000009 = BaseClass("TaskBehavior910000009")
--新版序章第二节开车环节车辆控制

function TaskBehavior910000009.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior910000009:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	
	self.carEcoId = 2003001010001
	self.carInstanceId = nil
	self.init = false
	
	self.taskState = false
    self.taskList = {
        start = 101110401, --上车       --101120101,  --把车开出停车场
        finish = 101120204,  --被截停
    }
	--临时复活点
	self.reviveTask = {
		start = 101120801,   --开打巡卫
		finish = 101130701,   --打负责人
		}
	
	self.posName = "CangkuOut"
	--开关
	self.progressIsSend = false
	self.carKey1 = false
	self.carKey2 = false
end

function TaskBehavior910000009:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local pos = BehaviorFunctions.GetTerrainPositionP(self.posName, 10020005, "Prologue02")

    if BehaviorFunctions.CheckTaskIsFinish(self.taskList.start) then
        self.carInstanceId = BehaviorFunctions.GetEcoEntityByEcoId(self.carEcoId)
        if self.carInstanceId and not self.carKey1  then
            BehaviorFunctions.SetDisableGetOffCar(self.carInstanceId, true)
			self.carKey1 = true
        end
    end

    if BehaviorFunctions.CheckTaskIsFinish(self.taskList.finish) then
        if self.carInstanceId and not self.carKey2 then
            BehaviorFunctions.SetDisableGetOffCar(self.carInstanceId, false)
			self.carKey2 = true
            --BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
        end
    end
	
	if BehaviorFunctions.CheckTaskIsFinish(self.reviveTask.start) then
		BehaviorFunctions.SetReviveTransportPos(pos.x, pos.y, pos.z)
	end
		
	if BehaviorFunctions.CheckTaskIsFinish(self.reviveTask.finish) and not self.progressIsSend then
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
		self.progressIsSend = true
	end
end

