TaskBehavior304010105 = BaseClass("TaskBehavior304010105")

function TaskBehavior304010105.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior304010105:__init(taskInfo)
	
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0
	self.dialogId = nil
	self.camNpc = 0
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点
	self.NPCpos = nil
end

function TaskBehavior304010105:Update()
	--print("TaskBehavior3040105初始化")
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	
	if self.missionState == 0 then
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerBorn",10020005,"TaskLogicBlueprint")
		local rotate = BehaviorFunctions.GetTerrainRotationP("PlayerBorn",10020005,"TaskLogicBlueprint")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)

		--print("传送玩家")
	
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.AddDelayCallByFrame(20,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.8)
		--BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",2)
		--print("传送黑幕")

		--镜头转向
		if self.camNpc == 0 then
			self.NPCpos = BehaviorFunctions.GetTerrainPositionP("Mon101", 10020005, "TaskLogicBlueprint")
			self.camNpc = 1
		-- else self.camNpc = 1
		end
		self.missionState = 1
	elseif self.missionState == 1 then
		--设置该波的看向点
		if self.currentWaveLookAtPos == nil then
			self.currentWaveLookAtPos = self.NPCpos
		end
		self:SetLevelCamera()
		BehaviorFunctions.AddDelayCallByFrame(40,BehaviorFunctions,BehaviorFunctions.SendTaskProgress,3040101,5,1,1)
		-- BehaviorFunctions.SendTaskProgress(3040101,5,1,1)
		self.missionState = 3
		--print("任务结束")
	end
end

--设置关卡相机函数
function TaskBehavior304010105:SetLevelCamera()
	self.empty = BehaviorFunctions.CreateEntity(2001, nil, self.currentWaveLookAtPos.x, self.currentWaveLookAtPos.y + 1, self.currentWaveLookAtPos.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22001)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	--看向目标
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

----赋值
--function TaskBehavior101200401:Assignment(variable,value)
	--self[variable] = value
--end
	
	--if self.missionState == 0 then
	--BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1)         --先直接完成


		----设置关卡内玩家的坐标--
		--local bornPos = BehaviorFunctions.GetTerrainPositionP("playerBorn",3040105,"Logic_Level3040105")
		--BehaviorFunctions.InMapTransport(bornPos.x,bornPos.y,bornPos.z)
		----local bornRos = BehaviorFunctions.GetTerrainPositionR(self.bornPos,self.levelId)
		----BehaviorFunctions.SetPlayerBorn(bornPos.x,bornPos.y,bornPos.z)	--设置角色出生点
		
		--BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
		--self.missionState = 999

	--end