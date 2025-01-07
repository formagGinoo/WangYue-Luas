TaskBehavior101120701 = BaseClass("TaskBehavior101120701")
--结束骇入巡卫完成任务

function TaskBehavior101120701.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101120701:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.xunweiNpcId = 5001005
    self.dialogId = {
        
    }
    self.dialogState = 0
	self.hackMail = false
	self.distance = nil

	self.weakGuide =
	{
		[1] = {Id = 2203,state = false,Describe ="使用箴石之劣",count = 0},
		[2] = {Id = 2208,state = false,Describe ="可以点击此处进行骇入操作",count = 0},
		[3] = {Id = 2209,state = false,Describe ="可以点击此处进行劫持操作",count = 0},
		[4] = {Id = 2210,state = false,Describe ="点击此处切换轮盘能力",count = 0},
		[5] = {Id = 2228,state = false,Describe ="装配骇入能力",count = 0},
	}
end

function TaskBehavior101120701:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
    self.npcEntity = BehaviorFunctions.GetNpcEntity(self.xunweiNpcId)
    if self.npcEntity then
        self.npcInstanceId = self.npcEntity.instanceId
		BehaviorFunctions.SetNpcMailState(self.npcInstanceId, true)
		self.distance = BehaviorFunctions.GetDistanceFromTarget(self.role, self.npcInstanceId)
    end
	if self.distance then
		if self.distance < 30 then
			self:HackTutorial()
		end
	end
end

function TaskBehavior101120701:HackTutorial()
	local CurAbility = BehaviorFunctions.GetCurAbility()
	--如果轮盘上有能力
	if CurAbility then
		--如果玩家轮盘装备了骇入
		if CurAbility == 101 then
			--获取骇入模式
			local hackMode = BehaviorFunctions.GetHackMode()
			--如果处于骇入模式下
			if hackMode == 10000 then 
				--如果骇入引导还没触发或冷却CD完成
				if self.weakGuide[3].state == false then
					--看需不需要加强制引导镜头
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
			--如果是其他能力
		else
			if self.weakGuide[4].state == false then
				--当前未将轮盘切换到骇入能力，请切换
				self:WeakGuide(self.weakGuide[4].Id)
				--BehaviorFunctions.ShowTip(101103501)
				self.weakGuide[4].state = true
			end
		end
	else
		if self.weakGuide[5].state == false then
			--当前未在轮盘装备骇入能力，请装备
			self:WeakGuide(self.weakGuide[5].Id)
			--BehaviorFunctions.ShowTip(100000002, "请先装配骇入能力到轮盘上")
			self.weakGuide[5].state = true
		end
	end
end

function TaskBehavior101120701:ExitHacking()
	if self.hackMail == true then
		self:RemoveWeakGuide()
		BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
	end
end

--进入窃听中
function TaskBehavior101120701:HackingClickUp(instanceId)
	if instanceId == self.npcInstanceId and self.hackMail == false then
		self.hackMail = true
		self:RemoveWeakGuide()
		--BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
		--BehaviorFunctions.ShowCommonTitle(7,"已拦截到关键信息",true)
		--BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions, BehaviorFunctions.SendTaskProgress, self.taskId, 1, 1)
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions, BehaviorFunctions.ShowCommonTitle, 7,"已拦截到关键信息",true)
	end
end

--进入骇入模式
function TaskBehavior101120701:Hacking(instanceId)
	--如果骇入对象是巡卫则
	if instanceId == self.npcInstanceId then
		--如果劫持引导还没触发或冷却CD完成
		if self.weakGuide[3].state == false then
			--播放劫持引导
			self:WeakGuide(self.weakGuide[3].Id)
		end
	end
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101120701:WeakGuide(guideId)
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
function TaskBehavior101120701:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end