TaskBehavior101030204 = BaseClass("TaskBehavior101030204")
--检查是否退出调查timeline，如果是则进入下一条任务

function TaskBehavior101030204.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101030204:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
end

function TaskBehavior101030204:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.missionState == 0 then
		if not BehaviorFunctions.GetNowPlayingId() then
			--视角回正
			--BehaviorFunctions.CameraPosReduction(0)
			BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
			local pos = BehaviorFunctions.GetTerrainPositionP("Task101030204TP01",10020005,"Task_main_00")
			BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
			self:DisablePlayerInput(true,true)
			local ins = BehaviorFunctions.GetNpcEntity(8102101)
			self:LevelLookAtInstance(ins.instanceId,22002,25)
			BehaviorFunctions.AddDelayCallByFrame(25,self,self.DisablePlayerInput,false,false)
			BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)
			self.missionState = 1
		end
	end
end

--关卡看向实体相机
function TaskBehavior101030204:LevelLookAtInstance(instanceId,type,frame,bindTransform,targetbindTransform)
	self.levelCam = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,instanceId)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,instanceId,targetbindTransform)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam, false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
end

--禁用玩家输入
function TaskBehavior101030204:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end
