TaskBehavior303030103 = BaseClass("TaskBehavior303030103")

function TaskBehavior303030103.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior303030103:__init(taskInfo)
	
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
	self.dialogId = nil
	self.currentWaveLookAtPos = "Ruying"       --当前波次关卡相机朝向点
end

function TaskBehavior303030103:Update()
	-- print("TaskBehavior303030103初始化")
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	
	if self.missionState == 0 then

		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerRuy2",10020005,"TaskSubRacing")
		local rotate = BehaviorFunctions.GetTerrainRotationP("PlayerRuy2",10020005,"TaskSubRacing")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)
		-- print("303030105传送玩家")
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
		--BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",2)
		-- print("303030105传送黑幕")

		--镜头转向
		if not self.currentWaveLookAtPos then
			local NPCpos = BehaviorFunctions.GetTerrainPositionP("Ruying2",10020005,"TaskSubRacing")
			self.currentWaveLookAtPos = NPCpos
		end

		self.missionState = 1
	elseif self.missionState == 1 then
		BehaviorFunctions.SendTaskProgress(3030501,2,1,1)
		self.missionState = 3
		-- print("303030105任务结束")
	end
end

--设置关卡相机函数
function TaskBehavior303030103:SetLevelCamera()
	self.empty = BehaviorFunctions.CreateEntity(2001, nil, self.currentWaveLookAtPos.x, self.currentWaveLookAtPos.y + 1, self.currentWaveLookAtPos.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22001)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end