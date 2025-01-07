TaskBehavior10050001 = BaseClass("TaskBehavior10050001")
--出生演出
function TaskBehavior10050001:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	self.tip1State = 0
end

function TaskBehavior10050001:Update()
	--self.role = BehaviorFunctions.GetCtrlEntity()
	--if self.taskState == 0 then
		--BehaviorFunctions.ActiveUI(FightEnum.UIActiveType.Main,false)
		--local pos = BehaviorFunctions.GetTerrainPositionP("des2",10020001)
		--BehaviorFunctions.DoLookAtPositionImmediately(self.role,pos.x,pos.z)
		--BehaviorFunctions.ActiveSceneObj("BlackCurtain",true,10020001)
		--BehaviorFunctions.AddDelayCallByTime(8,BehaviorFunctions,BehaviorFunctions.ActiveSceneObj,"Vcam1",true,10020001)
		--BehaviorFunctions.AddDelayCallByTime(15,BehaviorFunctions,BehaviorFunctions.ShowTip,3002001)
		--BehaviorFunctions.AddDelayCallByTime(19,BehaviorFunctions,BehaviorFunctions.ActiveUI,FightEnum.UIActiveType.Main,true)
		--BehaviorFunctions.AddDelayCallByTime(19,BehaviorFunctions,BehaviorFunctions.SendGmExec,"task_finish", {"10050001"})
		--self.taskState = 1
	--end
end

function TaskBehavior10050001:RemoveTask()
	
end