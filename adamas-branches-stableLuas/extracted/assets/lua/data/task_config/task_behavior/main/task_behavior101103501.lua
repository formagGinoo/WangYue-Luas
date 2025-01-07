TaskBehavior101103501 = BaseClass("TaskBehavior101103501")
--与电箱进行交互

function TaskBehavior101103501.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101103501:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	self.missionState = 0	
	
	self.dialogList =
	{
		[1] = {Id = 101103501},--第一个电箱timeline
		[2] = {Id = 101103601},--第二个电箱timeline
	}
	
	self.weakGuide =
	{
		[1] = {Id = 2203,state = false,Describe ="使用箴石之劣",count = 0},
		[2] = {Id = 2208,state = false,Describe ="可以点击此处进行骇入操作",count = 0},
		[3] = {Id = 2209,state = false,Describe ="可以点击此处进行劫持操作",count = 0},
		[4] = {Id = 0 ,state = false,Describe ="Tips占位用",count = 0}
	}
	
	self.dianxiang = 
	{
		[1] = {insId = nil , ecoId = 2003001010003 , beenHit = nil ,inArea = false},
		--[2] = {insId = nil , ecoId = 2003001010003 , beenHit = nil ,inArea = false}
	}
	
	--相机控制和延时
	self.cameraControl = false
	self.camDelaycall = nil
	
	self.interactCount = 0
	
	self.inArea = nil
end

function TaskBehavior101103501:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--任务开始时检查玩家是否处于Area内
	--if self.inArea == nil then
		--if BehaviorFunctions.CheckEntityInArea(self.role,"Task_main_01","Task101103501Area01")
		--or	BehaviorFunctions.CheckEntityInArea(self.role,"Task_main_01","Task101103501Area02") then
		if BehaviorFunctions.CheckEntityInArea(self.role,"Task_main_01","Task101103501Area02")then
			self.inArea = true
		else
			self.inArea = false
		end
	--end
	
	for i,v in ipairs(self.dianxiang) do
		v.insId = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
		local hitResult = BehaviorFunctions.GetEcoEntityState(v.ecoId)
		if hitResult == 0 then
			v.beenHit = false
		else
			v.beenHit = true
		end
		if v.beenHit == true and self.missionState == 0 then
			self:RemoveWeakGuide()
			BehaviorFunctions.StopHackingMode()
			--电箱通电提示
			BehaviorFunctions.ShowTip(101103502)
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			--开启两个电梯的交互
			BehaviorFunctions.SetEcoEntityState(2003001010004,1)
			BehaviorFunctions.SetEcoEntityState(2003001010005,1)
			BehaviorFunctions.SendTaskProgress(self.taskId,self.taskStepId,1,1)
			self.missionState = 1
		end
	end
		
	
	----检查电箱实体是否被交互
	--for i,v in ipairs(self.dianxiang) do
		----开始获得这两个实体的当前交互状态
		--if v.beenHit == nil then
			--local hitResult = BehaviorFunctions.GetEcoEntityState(v.ecoId)
			--if hitResult == 0 then
				--v.beenHit = false
			--else
				--v.beenHit = true
				--self.interactCount = self.interactCount + 1
			--end
		--end
		
		--if v.beenHit == false then
			----仅检查尚未被交互电箱
			--v.insId = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
			--local hitResult = BehaviorFunctions.GetEcoEntityState(v.ecoId)
			--if hitResult == 1 then
				--self.interactCount = self.interactCount + 1
				--if self.interactCount == 1 then
					--BehaviorFunctions.StopHackingMode()
					----电箱通电提示
					--BehaviorFunctions.ShowTip(101103502)
					--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
				----elseif self.interactCount == 2 then
					----BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
				--end
				--if v.ecoId == 2003001010002 then
					----BehaviorFunctions.SendTaskProgress(101103501,1,1)
				--elseif v.ecoId == 2003001010003 then
					----BehaviorFunctions.SendTaskProgress(101103501,2,1)
					--BehaviorFunctions.SendTaskProgress(101103501,1,1)
				--end
				--v.beenHit = true
			--end
		--end
	--end
	
	--进入区域后触发按键引导
	for i,v in ipairs(self.dianxiang) do
		if v.inArea == true and  v.beenHit == false then
			self:HackTutorial()
		end
	end
end


--进入区域
function TaskBehavior101103501:EnterArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if logicName == "Task_main_01" then
			if areaName == "Task101103501Area01" 
			or areaName == "Task101103501Area02" then
				self.inArea = true
				if areaName == "Task101103501Area02" then
					self.dianxiang[1].inArea = true
				--elseif areaName == "Task101103501Area02" then
					--self.dianxiang[2].inArea = true
				end
			end
		end
	end
end

--退出区域
function TaskBehavior101103501:ExitArea(triggerInstanceId, areaName, logicName)
	if triggerInstanceId == self.role then
		if logicName == "Task_main_01" then
			if areaName == "Task101103501Area02" then
			--or areaName == "Task101103501Area02" then
				--关闭两个按键提示
				self.weakGuide[1].state = false
				self.weakGuide[2].state = false
				self.weakGuide[3].state = false
				self.weakGuide[4].state = false
				self.inArea = false
				
				if areaName == "Task101103501Area02" then
					self.dianxiang[1].inArea = false
				--elseif areaName == "Task101103501Area02" then
					--self.dianxiang[2].inArea = false
				end
			end
		end
	end
end

--进入骇入模式
function TaskBehavior101103501:Hacking(instanceId)
	--如果骇入对象是电箱实体则
	--if instanceId == self.dianxiang[1].insId or
		--instanceId == self.dianxiang[2].insId then
	if instanceId == self.dianxiang[1].insId then
		if self.camDelaycall then
			BehaviorFunctions.RemoveDelayCall(self.camDelaycall)
			self.camDelaycall = nil
		end
		--如果劫持引导还没触发或冷却CD完成
		if self.weakGuide[3].state == false then
			--播放劫持引导
			self:WeakGuide(self.weakGuide[3].Id)
		end
	end
end

--退出骇入模式
function TaskBehavior101103501:StopHacking(instanceId)
	--如果骇入对象是电箱实体则
	--if instanceId == self.dianxiang[1].insId or
		--instanceId == self.dianxiang[2].insId then
	if instanceId == self.dianxiang[1].insId then
		self:RemoveWeakGuide()
		self.weakGuide[1].state = false
		self.weakGuide[2].state = false
		self.weakGuide[3].state = false
		self.weakGuide[4].state = false
		
		if self.cameraControl == true then
			self.camDelaycall = BehaviorFunctions.AddDelayCallByFrame(90,self,self.Assignment,"cameraControl",false)
		end		
	end
end

function TaskBehavior101103501:HackTutorial()
	----先获取当前角色的对应仲魔
	--local partnerIns = BehaviorFunctions.GetPartnerInstanceId(self.role)
	----如果玩家当前有仲魔
	--if partnerIns then
		----检查玩家当前仲魔是否是箴石之劣
		--local partnerEntity = BehaviorFunctions.GetEntityTemplateId(partnerIns)
		----如果装备了箴石之劣
		--if partnerEntity == 600080 then
			--如果玩家处于骇入模式下
			local hackMode = BehaviorFunctions.GetHackMode()
			--如果处于骇入模式下
			if hackMode == 10000 then
				--如果骇入引导还没触发或冷却CD完成
				if self.weakGuide[3].state == false then
					if self.cameraControl == false then
						--镜头强制看向电箱
						BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.5)
						if self.dianxiang[1].inArea == true then
							self:LevelLookAtInstance(self.dianxiang[1].insId,22001,60,"CameraTarget","HackPoint")
							self.cameraControl = true
						--elseif self.dianxiang[2].inArea == true then
							--self:LevelLookAtInstance(self.dianxiang[2].insId,22001,30,"CameraTarget","HackPoint")
							self.cameraControl = true
						end
					end
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
		----如果是其他仲魔
		--else
			--if self.weakGuide[4].state == false then
				----当前未装备箴石之劣，请装备箴石之劣
				--BehaviorFunctions.ShowTip(101103501)
				--self.weakGuide[4].state = true
			--end
		--end
	----如果当前没有装备仲魔
	--else
		--if self.weakGuide[4].state == false then
			----当前未装备箴石之劣，请装备箴石之劣
			--BehaviorFunctions.ShowTip(101103501)
			--self.weakGuide[4].state = true
		--end
	--end
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101103501:WeakGuide(guideId)
	local result = false
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
		if v.Id == guideId then
			v.state = true
			result = true
		else
			v.state = false
		end
	end
	if result == true then
		BehaviorFunctions.PlayGuide(guideId,1,1)
	end
end

--关闭所有弱引导
function TaskBehavior101103501:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

--关卡看向实体相机
function TaskBehavior101103501:LevelLookAtInstance(instanceId,type,frame,bindTransform,targetbindTransform)
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

--赋值
function TaskBehavior101103501:Assignment(variable,value)
	self[variable] = value
end
