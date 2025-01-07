TaskBehavior101130201 = BaseClass("TaskBehavior101130201")
--骇入摄像头发现东西

function TaskBehavior101130201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101130201:__init(taskInfo)
	self.taskInfo = taskInfo
    self.taskId = taskInfo.taskId
	self.role = nil
	self.taskState = 0
    self.monitorEcoId = 2008001010001
    self.dialogId = {
		101111501
    }
    self.dialogState = 0
	self.hackCamera = false
	self.hackNpc = false
	self.npcLouluoId = {
		5001006, 5001007,
		}

	self.weakGuide =
	{
		[1] = {Id = 2203,state = false,Describe ="使用箴石之劣",count = 0},
		[2] = {Id = 2208,state = false,Describe ="可以点击此处进行骇入操作",count = 0},
		[3] = {Id = 2209,state = false,Describe ="可以点击此处进行劫持操作",count = 0},
		[4] = {Id = 2210,state = false,Describe ="点击此处切换轮盘能力",count = 0},
		[5] = {Id = 2228,state = false,Describe ="装配骇入能力",count = 0},
	}
	--对话是否结束
	self.dialogEnd = false
	self.distance = nil
	
end

function TaskBehavior101130201:Update()
    self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.monitor then
        self.monitor = BehaviorFunctions.GetEcoEntityByEcoId(self.monitorEcoId)
    end
	
	--获取NPC实例id
	self.npcEntity01 = BehaviorFunctions.GetNpcEntity(self.npcLouluoId[1])
	self.npcEntity02 = BehaviorFunctions.GetNpcEntity(self.npcLouluoId[2])
	if self.npcEntity01 then
		self.npcInstanceId01 = self.npcEntity01.instanceId
		self.distance = BehaviorFunctions.GetDistanceFromTarget(self.role, self.npcInstanceId01)
	end
	if self.npcEntity02 then
		self.npcInstanceId02 = self.npcEntity02.instanceId
	end
	if self.distance then
		if self.dialogEnd == true and self.distance < 50 then
			self:HackTutorial()
		end
	end
	
end

function TaskBehavior101130201:HackTutorial()
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

--退出骇入，任务结束(保底)
function TaskBehavior101130201:ExitHacking()
    if self.hackCamera == true then
		self:RemoveWeakGuide()
        BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
    end
end

function TaskBehavior101130201:CameraHack(instanceId,hacking)
	if instanceId == self.monitor and self.hackCamera == false then
		self.hackCamera = true
		self:RemoveWeakGuide()
		BehaviorFunctions.ShowCommonTitle(7,"通过该视野探查仓库情况",true)
	end
end

--准星对准npc
function TaskBehavior101130201:Hacking(instanceId)
	if instanceId == self.npcInstanceId01 or instanceId == self.npcInstanceId02 then
		if self.hackNpc == false then
			BehaviorFunctions.ShowCommonTitle(7,"已探查到关键信息",true)
			--BehaviorFunctions.SendTaskProgress(self.taskId, 1, 1)
			BehaviorFunctions.StartStoryDialog(self.dialogId[1])
			BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions, BehaviorFunctions.ShowTip,100000001,"退出骇入界面")
			--BehaviorFunctions.ShowTip(100000001,"上前抽奖拆穿阴谋")
			self.hackNpc = true
		end
	end
	--如果是摄像头，引导进行劫持
	if instanceId == self.monitor then
		--如果劫持引导还没触发或冷却CD完成
		if self.weakGuide[3].state == false then
			--播放劫持引导
			self:WeakGuide(self.weakGuide[3].Id)
		end
	end
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101130201:WeakGuide(guideId)
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

--对话结束回调
function TaskBehavior101130201:StoryEndEvent(dialogId)
    if dialogId == self.dialogId[1] then
        self.dialogEnd = true
    end
end

--关闭所有弱引导
function TaskBehavior101130201:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end