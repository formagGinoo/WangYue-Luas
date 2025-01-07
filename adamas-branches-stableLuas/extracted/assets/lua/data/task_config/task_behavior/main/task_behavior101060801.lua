TaskBehavior101060801 = BaseClass("TaskBehavior101060801")
--任务10：青乌结束了回忆，遇到精英从士

function TaskBehavior101060801.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101060801:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
	self.currentDialog = nil
	self.initSetting = false
	
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}

	self.dialogList =
	{

	}
	
	self.trace = false
	self.guideFinish = false
end

function TaskBehavior101060801:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--初始化设置
	if self.initSetting == false then
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		self.initSetting = true
	end
	
	--检查引导是否完成
	if BehaviorFunctions.CheckGuideFinish(1013) == true and self.guideFinish == false then
		self.guideFinish = true
	end
	
	--退出副本后
	if self.missionState == 0 then	
		--禁用角色输入
		self:DisablePlayerInput(true,false)
		----将玩家传送至场地内
		--local targetPos = BehaviorFunctions.GetTerrainPositionP("tp_Sword",10020001,"Logic10020001_6")
		--BehaviorFunctions.DoSetPosition(self.role,targetPos.x,targetPos.y,targetPos.z)
		--BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
		--BehaviorFunctions.InMapTransport(targetPos.x,targetPos.y,targetPos.z)
		----看向前方
		--self:LevelLookAtPos("Task1010608Mb1","Logic10020001_6",22001,10,"CameraTarget")
		self.missionState = 1
		
	--武器教程过完进入战斗
	elseif self.missionState == 1 then
		if self.guideFinish == true then
			BehaviorFunctions.AddLevel(101060801)
			self.missionState = 2
		end
	end
end

function TaskBehavior101060801:DisablePlayerInput(isOpen,closeUI)
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

--死亡事件
function TaskBehavior101060801:Death(instanceId,isFormationRevive)
	--玩家死亡重来
	if instanceId == self.role then
		if self.missionState == 1 then
			self.trace = false
			self.missionState = 0
		end
	end
end

function TaskBehavior101060801:Revive(instanceId, entityId)
	--玩家死亡重来
	if instanceId == self.role then
		if self.missionState == 1 then
			self.trace = false
			self.missionState = 0
		end
	end
end


function TaskBehavior101060801:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101060801:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end

function TaskBehavior101060801:LevelLookAtPos(pos,logic,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,10020001,logic)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam2, false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end