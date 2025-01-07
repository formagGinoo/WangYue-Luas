TaskBehavior101101301 = BaseClass("TaskBehavior101101301")
--拿去商品或者离开茶馆

function TaskBehavior101101301.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101101301:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0	
	self.levelCam = nil
	
	self.imagTips = false
end

function TaskBehavior101101301:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		--将玩家传送到奖励附近
		BehaviorFunctions.ShowBlackCurtain(true,0)
		local pos = BehaviorFunctions.GetTerrainPositionP("Task101101301TP01",10020005,"Task_main_01")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		self:LevelLookAtPos("Task101101301Lookat01","Task_main_01",22001,10,"CameraTarget")
		BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.3)
		
		if BehaviorFunctions.GetNpcBubbleId(8101006) ~= 80102031  then
			BehaviorFunctions.ChangeNpcBubbleId(8101006,80102032)
		end
		
		local ins = BehaviorFunctions.GetNpcEntity(8101006)
		if ins then
			BehaviorFunctions.PlayAnimation(ins.instanceId,"Surprise")
		end
		self.missionState = 1
		
	elseif self.missionState == 1 then

		
	elseif self.missionState == 999 then

		self.missionState = 1000
	end
end

--function TaskBehavior101101301:ExitArea(triggerInstanceId, areaName, logicName)
	--if triggerInstanceId == self.role then
		--if logicName == "Task_main_01" then
			--if areaName == "Task101101301Area02" then
				--if not self.imagTips  then
					--BehaviorFunctions.ShowGuideImageTips(20014)
					--self.imagTips = true
				--end
			--end
		--end
	--end
--end

function TaskBehavior101101301:LevelLookAtPos(pos,logic,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId,logic)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam, false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end