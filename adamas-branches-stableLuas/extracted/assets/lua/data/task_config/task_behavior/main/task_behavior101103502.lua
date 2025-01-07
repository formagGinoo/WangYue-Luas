TaskBehavior101103502 = BaseClass("TaskBehavior101103502")
--与电箱进行交互

function TaskBehavior101103502.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101103502:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
	
	self.dialogList =
	{
		[1] = {Id = 101103601},--第二个电箱timeline
	}
	
	self.weakGuide =
	{
		[1] = {Id = 2203,state = false,Describe ="使用箴石之劣",count = 0},
		[2] = {Id = 2208,state = false,Describe ="可以点击此处进行骇入操作",count = 0},
		[3] = {Id = 2209,state = false,Describe ="可以点击此处进行劫持操作",count = 0},
	}

	self.dianxiangEco = 2003001010003
	self.dianxiangIns = nil
	
	self.inArea = false
end

function TaskBehavior101103502:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	local dianxiangIns = BehaviorFunctions.GetEcoEntityByEcoId(self.dianxiangEco)

	if not self.dianxiangIns and dianxiangIns then
		self.dianxiangIns = dianxiangIns
	elseif self.dianxiangIns and not dianxiangIns then
		self.dianxiangIns = nil
	end
	
	--进入区域后触发按键引导
	if self.inArea then
		self:HackTutorial()
	end
end

--上方骇入按钮被点击
function TaskBehavior101103502:HackingClickUp(instanceId)
	if instanceId == self.dianxiangIns then
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		BehaviorFunctions.InteractEntityHit(self.dianxiangIns,false)
		BehaviorFunctions.SendTaskProgress(101103502,1,1)
	end
end

--进入区域
function TaskBehavior101103502:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if logicName == "Task_main_01" then
			if areaName == "Task101103501Area02" then
				self.inArea = true
			end
		end
	end
end

--退出区域
function TaskBehavior101103502:ExitArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if logicName == "Task_main_01" then
			if areaName == "Task101103501Area02" then
				--关闭两个按键提示
				self.weakGuide[1].state = false
				self.weakGuide[2].state = false
				self.inArea = false
			end
		end
	end
end

--进入骇入模式
function TaskBehavior101103502:Hacking(instanceId)
	--如果骇入对象是电箱实体则
	if instanceId == self.dianxiangIns then
		--如果劫持引导还没触发或冷却CD完成
		if self.weakGuide[3].state == false then
			--播放劫持引导
			self:WeakGuide(self.weakGuide[3].Id)
		end
	end
end

--退出骇入模式
function TaskBehavior101103502:StopHacking(instanceId)
	--如果骇入对象是电箱实体则
	if instanceId == self.dianxiangIns then
		--镜头强制看向电箱
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.2)
		self:LevelLookAtInstance(self.dianxiangIns,22001,15,"CameraTarget","HackPoint")
		self.weakGuide[3].state = false
	end
end

function TaskBehavior101103502:HackTutorial()
	--先获取当前角色的对应仲魔
	local partnerIns = BehaviorFunctions.GetPartnerInstanceId(self.role)
	local partnerEntity = BehaviorFunctions.GetEntityTemplateId(partnerIns)
	if partnerEntity == 600080 then
		--如果玩家处于骇入模式下
		local hackMode = BehaviorFunctions.GetHackMode()
		--如果处于骇入模式下
		if hackMode == 10000 then
			--如果骇入引导还没触发或冷却CD完成
			if self.weakGuide[3].state == false then
				--镜头强制看向电箱
				BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.2)
				self:LevelLookAtInstance(self.dianxiangIns,22001,15,"CameraTarget","HackPoint")
			end
			--如果没进入骇入模式
		elseif hackMode == nil then
			--如果使用箴石之劣引导还没触发或冷却CD完成
			if self.weakGuide[1].state == false then
				--播放箴石之劣引导
				self:WeakGuide(self.weakGuide[1].Id)
			end
			--处于其他模式的情况下
		else
			--如果骇入模式引导还没触发或冷却CD完成
			if self.weakGuide[2].state == false then
				--播放骇入模式引导
				self:WeakGuide(self.weakGuide[2].Id)
			end
		end
	end
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101103502:WeakGuide(guideId)
	local result = false
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
		if v.Id == guideId then
			v.state = true
			result = true
		end
	end
	if result == true then
		BehaviorFunctions.PlayGuide(guideId,1,1)
	end
end

--关闭所有弱引导
function TaskBehavior101103502:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

--关卡看向实体相机
function TaskBehavior101103502:LevelLookAtInstance(instanceId,type,frame,bindTransform,targetbindTransform)
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
