LevelBehavior200503002 = BaseClass("LevelBehavior200503002",LevelBehaviorBase)
--限时收集玩法2

function LevelBehavior200503002:__init(fight)
	self.fight = fight
end

function LevelBehavior200503002.GetGenerates()
	local generates = {8010008, 2080102, 2041201, 2041202, 2041203, 2041204, 2041205, 2080107}
	return generates
end

function LevelBehavior200503002:Init()

	self.missionState = 0


	----------实体参数----------

	--收集物是否处于控制状态开关
	self.collectionCtrlState = false
	--区域内收集物数量
	self.inareaNum = 0
	--关卡正式开始前保底
	self.ifCtrlState = false
	--用于承载和管理该关卡创建的buff，关卡卸载时移除
	self.levelController = BehaviorFunctions.CreateEntity(2001,nil,nil,nil,nil,nil,nil,nil,self.levelId)

	--收集物是否在目标区域状态
	self.collectionStateEnum = {
		default = 0,--默认状态
		inarea = 1,--在目标区域
		outarea = 2,--不在目标区域，但在任务区域内
		reset = 3,--在任务区域外
	}

	--收集物list
	self.collectionList = {
		[1] = {entityId = 2080107, bornPos = "shoujiwu1", state = self.collectionStateEnum.default, id = nil},
		[2] = {entityId = 2080107, bornPos = "shoujiwu2", state = self.collectionStateEnum.default, id = nil},
		[3] = {entityId = 2080107, bornPos = "shoujiwu3", state = self.collectionStateEnum.default, id = nil},
		[4] = {entityId = 2080107, bornPos = "shoujiwu4", state = self.collectionStateEnum.default, id = nil},
		[5] = {entityId = 2080107, bornPos = "shoujiwu5", state = self.collectionStateEnum.default, id = nil},
	}

	--空实体list
	self.lookAtList = {
		[1] = {entityId = 2001, bornPos = "npc",  id = nil},
		[2] = {entityId = 2001, bornPos = "tishi",  id = nil},
		[3] = {entityId = 2001, bornPos = "shoujiwu1",  id = nil},
		[4] = {entityId = 2001, bornPos = "player",  id = nil},
	}


	------------关卡时间参数----------

	----是否开启时间限制
	--self.timeLimit = false
	----时间限制当前时间
	--self.timeLimitCurrentTime = nil
	----时间限制结束时间
	--self.timeLimitEndTime = nil
	----时间限制剩余秒数
	--self.timeLimitSecond = 0


	----------交互列表参数----------


	--初次对话按钮开关
	self.firstSwitch = false
	--开始任务按钮开关
	self.startSwitch = false


	--你是觉醒者？拜托，可以帮我一个忙吗？
	self.firstInteractId = 601013501
	--本来我在用吊车卸箱子
	--self.wakeupInteractId = 601013502
	--本来我在用吊车卸箱子，不小心操作失误，箱子全倒下来了。
	self.appleInteractId = 601013502
	--全怪我，不该昨晚熬夜打游戏的，那么重要的时候竟然打瞌睡。
	self.tuoshouInteractId = 601013601
	
	--太感谢了！我，我会想尽办法报答你的！
	self.startInteractId = 601015201
	

	--惨了，这下要被开除……
	self.sorryInteractId = 601013503
	--觉醒者，能求你在工头回来前帮帮我，把箱子移回去吗？
	self.askInteractId = 601013701
	--好吧……我明白了，我自己承担责任吧
	self.cancelInteractId = 601013702

	--任务进行中按钮
	--时间不多了，得加快速度了！
	self.inProgressInteractId = 601013801
	--任务进行中重置按钮
	--好吧，但是要抓紧时间。
	--self.restartInteractId = 601013802
	--任务进行中放弃对话1
	--啊……这下完蛋了……
	self.interruptInteractId1 = 601013802
	--任务进行中放弃对话2
	--惨了，这下要被开除……
	self.interruptInteractId2 = 601014201

	--倒计时结束失败1
	self.timeOutInteractId1 = 601013901
	--倒计时结束失败2
	self.timeOutInteractId2 = 601013902
	--收集物超出范围失败对话1
	self.outAreaInteractId1 = 601014001
	--收集物超出范围失败对话2
	self.outAreaInteractId2 = 601014003
	--角色超出范围失败对话1
	self.distanceInteractId1 = 601014301
	--角色超出范围失败对话2
	self.distanceInteractId2 = 601014303

	--任务完成对话1
	self.successInteractId1 = 601014101
	--任务完成对话2
	self.successInteractId2 = 601014103

	----------引导参数----------

	self.guideSwitch = false
	self.guidePointer = 0
	self.GuideTypeEnum =
	{
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
		Jiujishou = FightEnum.GuideType.Map_Jiujishou,--究极手
	}
	--图文教学
	self.levelInstruction = 200503001
	self.flag = 0


	----------关卡参数----------

	self.logic = 200503002
	self.positionLevel = 200503002

	--关卡状态枚举
	self.levelStateEnum =
	{
		Default = 0,--默认状态
		Start = 1,--关卡开始状态
		Ongoing = 2,--关卡进行中
		LevelSuccess = 3,--关卡胜利
		LevelFail = 4,--关卡失败
		LevelEnd = 5,--关卡结束，进入移除
	}
	--关卡状态
	self.levelState = self.levelStateEnum.Default
	--关卡名称
	self.levelName = "在50秒内收集5个货箱"
	--关卡是否成功
	self.isSuccess = false

	----------失败条件----------
	
	--失败条件：超出距离
	self.distanceLimit1 = false
	self.distanceLimit2 = false
	--超过距离警告当前时间
	self.distanceWarningCurrentTime = nil
	--超过距离警告结束时间
	self.distanceWarningEndTime = nil
	--超过距离警告当前剩余秒数
	self.warningSecond = 0
	--主动取消任务
	self.cancelTask = false
	
	--失败条件：时间限制
	--是否开启时间限制
	self.timeLimit = false
	--时间限制计时器ID
	self.timeLimitTimer = nil
	--时间限制是否失败
	self.timeLimitFinish = false
	--时间限制剩余秒数
	self.timeLimitSecond = 0
	
	--警告倒计时计时器ID
	self.warningCountDownId = nil
	--警告倒计时剩余时间
	self.warningCountDownSecond = nil
	--警告倒计时是否完成
	self.warningCountDownFinish = false
end

function LevelBehavior200503002:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()
	--通用关卡逻辑
	--运行关卡状态机
	self:ChallengeLevelFSM()

	if self.missionState == 0  then
		--创建实体
		--Npc
		self.npc = BehaviorFunctions.CreateEntityByPosition(2041205, nil, self.lookAtList[1].bornPos, nil, self.levelId, self.levelId)
		--散落的收集物
		self:CreateActor(self.collectionList)
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Fue_loop")
		--头顶icon
		BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcHeadIcon,self.npc, "Textures/Icon/Single/FuncIcon/Map_jiujishou.png")
		--气泡对话
		BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"惨了，这下要被开除……",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		--关卡镜头的目标实体
		self:LookAtInstance()
		--交互列表
		--初次按钮开启
		self.firstSwitch = true
	
		--镜头过渡
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",1)
		BehaviorFunctions.SetVCCameraBlend("LevelCamera","**ANY CAMERA**",1)
		--npc转向箱子
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.lookAtList[3].id)

		self.missionState = 1
	end
	
	if self.missionState == 1 then
		--自动开始检测
		self:autoStart()
		--引导
		--self:guide()
	end	
	
	--点击开始
	if self.missionState == 2 then
		--关卡开启
		self:LevelStart()
		
		--目的地光圈
		self.tishi = BehaviorFunctions.CreateEntityByPosition(2041203, nil, self.lookAtList[2].bornPos, nil, self.levelId, self.levelId)
		--数量提前修改
		self.inareaNum = 0
		--关卡提示
		self.levelTips = BehaviorFunctions.AddLevelTips(200503002,self.levelId)
		--剩余数量提示
		BehaviorFunctions.ChangeLevelSubTips(self.levelTips,1,self.inareaNum)
		
		--创建引导
		self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.lookAtList[2].id,self.GuideTypeEnum.Jiujishou,0,false)

		self.missionState = 3
	end

	--全部物品收集完成判断
	if self.missionState == 3 then

		if self.levelState == self.levelStateEnum.Ongoing then
			--npc转向角色
			BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
			----------关卡失败条件----------

			--自定义失败条件1：倒计时结束
			local result1 = self:FailCondition_TimeLimit(50)
			--自定义失败条件2：角色超出距离限制
			local result2 = self:FailCondition_Distance(self.lookAtList[1].bornPos, 60, 80, 10)
			--自定义失败条件3：收集物超出距离限制
			local result3 = self:FailCondition_AutoReset(10)
			--自定义失败条件4：开始任务后主动取消
			local result4 = self.cancelTask

			self:LevelFailCondition(result1,result2,result3,result4)


			----------关卡成功条件----------

			--自定义成功条件1：完成5个收集物收集
			local result1 = self:SuccessCondition_Collection(5)

			self:LevelSuccessCondition(result1)
		end
	end
end


---------------------函数--------------------

--创建实体
function LevelBehavior200503002:CreateActor(list)
	for k,v in ipairs(list) do
		v.id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.bornPos, nil, self.levelId, self.levelId)
	end
end

--空实体创建
function LevelBehavior200503002:LookAtInstance()
	for k,v in ipairs(self.lookAtList) do
		--看向目标点略微抬升
		local pos = BehaviorFunctions.GetTerrainPositionP(self.lookAtList[k].bornPos,self.levelId)
		v.id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y+1.5,pos.z,nil,nil,nil,self.levelId)
	end
end

--移除收集物函数
function LevelBehavior200503002:ResetLevel()
	if self.collectionList then
		for k,v in ipairs(self.collectionList) do
			BehaviorFunctions.RemoveEntity(v.id)
		end
	end
	BehaviorFunctions.RemoveEntity(self.npc)
end

--黑幕移除物品
function LevelBehavior200503002:Black()
	BehaviorFunctions.ShowBlackCurtain(true,0.3)
	BehaviorFunctions.AddDelayCallByTime(0.4,self,self.ResetLevel)
	self.blackEnd = BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5)
end

----重置关卡时间
--function LevelBehavior200503002:ResetTime(timeLimit)
	----修改动作
	--BehaviorFunctions.PlayAnimation(self.npc,"CheerL_loop")
	--self.timeLimitCurrentTime = BehaviorFunctions.GetFightFrame()
	--self.timeLimitEndTime = self.timeLimitCurrentTime + timeLimit*30
	--self.timeLimitSecond = timeLimit
--end

--失败传送
function LevelBehavior200503002:FailTransfer(position,lookAtPos)
	local pp1 = BehaviorFunctions.GetTerrainPositionP(position,self.levelId)
	local lp1 = BehaviorFunctions.GetTerrainPositionP(lookAtPos,self.levelId)
	BehaviorFunctions.ShowBlackCurtain(true,0.1)
	BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.InMapTransport,pp1.x,pp1.y,pp1.z)
	BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.DoLookAtPositionImmediately,self.role,lp1.x,nil,lp1.z)

	--修改动作
	BehaviorFunctions.PlayAnimation(self.npc,"Motou_loop")

	--npc转向角色传送点
	BehaviorFunctions.AddDelayCallByTime(0.3, BehaviorFunctions, BehaviorFunctions.DoLookAtTargetImmediately, self.npc,self.lookAtList[4].id)
	--角色转向npc
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)
	--镜头调用 看向npc
	self:levelCamera(22002,self.LevCamera1,self.lookAtList[1].id)
	
	self.transferEnd = BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
end

--关卡自动开启
function LevelBehavior200503002:autoStart()
	self.collectionCtrlState = false
	if self.collectionList then
		for k,v in ipairs(self.collectionList) do
			if BehaviorFunctions.CheckEntityOnBuildControl(v.id) then
				self.collectionCtrlState = true
			end
		end
	end

	if self.ifCtrlState == false and self.collectionCtrlState == true and self.missionState == 1 then
		--传送
		self:FailTransfer(self.lookAtList[4].bornPos,self.lookAtList[1].bornPos)
		--开始对话
		BehaviorFunctions.StartStoryDialog(self.firstInteractId)
	end
end

--镜头调用
function LevelBehavior200503002:levelCamera(type,cameraInstanceId,target)
	if not cameraInstanceId then
		cameraInstanceId = BehaviorFunctions.CreateEntity(type)
	end
	BehaviorFunctions.CameraEntityFollowTarget(cameraInstanceId,self.role)--让关卡相机跟随玩家
	BehaviorFunctions.CameraEntityLockTarget(cameraInstanceId,target)--让关卡相机看向目标
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,target)--转向目标
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.RemoveEntity,cameraInstanceId)
end

--引导管理
function LevelBehavior200503002:guide()
	local characterPos = BehaviorFunctions.GetPositionP(self.role)
	local levelPos = BehaviorFunctions.GetTerrainPositionP(self.lookAtList[1].bornPos,self.levelId)
	local distanceBetweenPos = BehaviorFunctions.GetDistanceFromPos(characterPos,levelPos)
	if distanceBetweenPos > 40 then
		if self.guidePointer1 and self.guideSwitch == true then
			BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer1)
			self.guideSwitch = false
		end
	end
	if 10 < distanceBetweenPos and distanceBetweenPos <= 40 then
		if self.guideSwitch == false then
			--创建引导
			self.guidePointer1 = BehaviorFunctions.AddEntityGuidePointer(self.npc,self.GuideTypeEnum.Jiujishou,3.3,false)
			self.guideSwitch = true
		end
	end
	if distanceBetweenPos <= 10 then
		if self.guidePointer1 and self.guideSwitch == true then
			BehaviorFunctions.RemoveEntityGuidePointer(self.guidePointer1)
			self.guideSwitch = false
		end
	end
end

--关卡开始
function LevelBehavior200503002:LevelStart()
	if self.levelState == self.levelStateEnum.Default then
		self.levelState = self.levelStateEnum.Start
	end
end

--关卡胜利判断
function LevelBehavior200503002:LevelSuccessCondition(...)
	local condition = {...}
	local conditionTotalNum = #condition
	local conditionFinishNum = 0
	--计算完成条件的数量
	for i,v in ipairs(condition) do
		if v == true then
			conditionFinishNum = conditionFinishNum + 1
		end
	end
	--如果全部条件已经被完成
	if conditionFinishNum == conditionTotalNum then
		if self.levelState == self.levelStateEnum.Ongoing then
			--隐藏提示
			BehaviorFunctions.RemoveLevelTips(self.levelTips)
			--停止倒计时
			BehaviorFunctions.StopLevelTimer(self.timeLimitTimerId)
			--移除提示光圈
			BehaviorFunctions.RemoveEntity(self.tishi)
			--关卡状态改为胜利
			self.levelState = self.levelStateEnum.LevelSuccess
		end
	end
end

--自定义关卡胜利条件1：收集物全收集
function LevelBehavior200503002:SuccessCondition_Collection(num)
	--区域内收集物数量重置
	self.inareaNum = 0
	self.collectionCtrlState = false
	if self.collectionList then
		for k,v in ipairs(self.collectionList) do
			if v.state == self.collectionStateEnum.inarea then
				self.inareaNum = self.inareaNum + 1
				BehaviorFunctions.ChangeLevelSubTips(self.levelTips,1,self.inareaNum)
			end
			if v.state == self.collectionStateEnum.outarea then
					BehaviorFunctions.ChangeLevelSubTips(self.levelTips,1,self.inareaNum)
			end
			--任意收集物在控制状态时 状态开启
			if BehaviorFunctions.CheckEntityOnBuildControl(v.id) then
				self.collectionCtrlState = true
			end
		end
	end

	--检测收集物状态
	if self.collectionList then
		for k,v in ipairs(self.collectionList) do
			local distance = BehaviorFunctions.GetDistanceFromTarget(self.lookAtList[2].id,v.id)
			if distance then
				if distance <= 7 then
					v.state = self.collectionStateEnum.inarea
				end
				if distance > 7 and distance <= 30 then
					v.state = self.collectionStateEnum.outarea
				end
				if distance > 30 then
					v.state = self.collectionStateEnum.reset
				end
			end
		end
	end

	--区域内收集物数量达到目标数量且不处于控制状态时完成委托
	if	self.inareaNum == num and self.collectionCtrlState == false then
		--任务成功对话1
		BehaviorFunctions.StartStoryDialog(self.successInteractId1)
		return true
	else
		return false
	end
end

--关卡失败判断
function LevelBehavior200503002:LevelFailCondition(...)
	local condition = {...}
	--计算完成条件的数量
	for i,v in ipairs(condition) do
		if v == true then
			if self.levelState == self.levelStateEnum.Ongoing then
				--隐藏提示
				BehaviorFunctions.RemoveLevelTips(self.levelTips)
				--停止倒计时
				BehaviorFunctions.StopLevelTimer(self.timeLimitTimerId)
				--移除提示光圈
				BehaviorFunctions.RemoveEntity(self.tishi)
				--关卡状态改为失败
				self.levelState = self.levelStateEnum.LevelFail
			end
		end
	end
end

--自定义关卡失败条件1：时间限制
function LevelBehavior200503002:FailCondition_TimeLimit(timeLimit)
	if self.timeLimit == false then
		self.timeLimitTimerId = BehaviorFunctions.StartLevelTimer(timeLimit,FightEnum.DuplicateTimerType.FightTargetUI)
		self.timeLimit = true
	else
		if self.timeLimitFinish then
			----倒计时结束失败对话
			BehaviorFunctions.StartStoryDialog(self.timeOutInteractId1)
			----失败黑幕传送
			self:FailTransfer(self.lookAtList[4].bornPos,self.lookAtList[1].bornPos)
			return true
		else
			return false
		end
	end
end

----自定义关卡失败条件1：时间限制
--function LevelBehavior200503002:FailCondition_TimeLimit(timeLimit)
	--self.timeLimitCurrentTime = BehaviorFunctions.GetFightFrame()
	--if self.timeLimit == false then
		--self.timeLimitEndTime = self.timeLimitCurrentTime + timeLimit*30
		--self.timeLimitSecond = timeLimit
		--self.timeLimit = true
	--else
		--if self.timeLimitEndTime > self.timeLimitCurrentTime then
			--local second = math.ceil((self.timeLimitEndTime - self.timeLimitCurrentTime)/30)
			--if second < self.timeLimitSecond then
				--self.timeLimitSecond = second
				--BehaviorFunctions.ChangeLevelSubTips(self.levelTips,1,self.timeLimitSecond)
			--end
			--return false
		--else
			----倒计时结束失败对话
			--BehaviorFunctions.StartStoryDialog(self.timeOutInteractId1)
			----失败黑幕传送
			--self:FailTransfer(self.lookAtList[4].bornPos,self.lookAtList[1].bornPos)
			--return true
		--end
	--end
--end

--自定义关卡失败条件2：角色超出关卡距离一段时间
function LevelBehavior200503002:FailCondition_Distance(pos,warndistance,faildistance,timeLimit)
	local characterPos = BehaviorFunctions.GetPositionP(self.role)
	local levelPos = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId)
	local distanceBetweenPos = BehaviorFunctions.GetDistanceFromPos(characterPos,levelPos)
	if warndistance < distanceBetweenPos then
		if self.distanceLimit1 == false then
			self.distanceWarningCurrentTime = BehaviorFunctions.GetFightFrame()
			self.distanceWarningEndTime = self.distanceWarningCurrentTime + timeLimit*30
			self.warningSecond = timeLimit
			self.distanceLimit1 = true
		else
			self.distanceWarningCurrentTime = BehaviorFunctions.GetFightFrame()
			if self.distanceWarningEndTime > self.distanceWarningCurrentTime then
				local second = math.ceil((self.distanceWarningEndTime - self.distanceWarningCurrentTime)/30)
				if second < self.warningSecond then
					self.warningSecond = second
					self.levelFailTips = BehaviorFunctions.AddLevelTips(100000006,self.levelId,second)
				end
			else
				BehaviorFunctions.RemoveLevelTips(self.levelFailTips)
				--角色超出距离失败对话
				BehaviorFunctions.StartStoryDialog(self.distanceInteractId1)
				return true
			end
		end
	else
		if self.distanceLimit1 == true then
			self.distanceLimit1 = false
			BehaviorFunctions.RemoveLevelTips(self.levelFailTips)
		end
	end
	if faildistance < distanceBetweenPos then
		--角色超出距离失败对话
		BehaviorFunctions.StartStoryDialog(self.distanceInteractId1)
		return true
	end
	return false
end

--自定义关卡失败条件3：收集物品超出距离一段时间
function LevelBehavior200503002:FailCondition_AutoReset(timeLimit)
	--重置状态收集物计数
	self.resetNum = 0
	self.collectionCtrlState = false
	for k,v in ipairs(self.collectionList) do
		if v.state == self.collectionStateEnum.reset then
			self.resetNum = self.resetNum + 1
		end
	end

	if	self.resetNum > 0 then
		if self.distanceLimit2 == false then
			self.distanceWarningCurrentTime = BehaviorFunctions.GetFightFrame()
			self.distanceWarningEndTime = self.distanceWarningCurrentTime + timeLimit*30
			self.warningSecond = timeLimit
			self.distanceLimit2 = true
		else
			self.distanceWarningCurrentTime = BehaviorFunctions.GetFightFrame()
			if self.distanceWarningEndTime > self.distanceWarningCurrentTime then
				local second = math.ceil((self.distanceWarningEndTime - self.distanceWarningCurrentTime)/30)
				if second < self.warningSecond then
					self.warningSecond = second
					self.levelDistanceTips = BehaviorFunctions.AddLevelTips(200503003,self.levelId,second)
				end
			else
				--收集物超出距离失败对话
				BehaviorFunctions.StartStoryDialog(self.outAreaInteractId1)
				--失败传送
				self:FailTransfer(self.lookAtList[4].bornPos,self.lookAtList[1].bornPos)
				return true
			end
		end
	else
		if self.distanceLimit2 == true then
			self.distanceLimit2 = false
			BehaviorFunctions.RemoveLevelTips(self.levelDistanceTips)
		end
	end
	return false
end

--关卡状态机
function LevelBehavior200503002:ChallengeLevelFSM()
	--关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then

		--关卡处于开始状态
	elseif self.levelState == self.levelStateEnum.Start then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.ChallengeInfo,self.levelName,nil)
		self.levelState = self.levelStateEnum.Ongoing

		--关卡处于进行中状态
	elseif self.levelState == self.levelStateEnum.Ongoing then

		--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccess then
		self.isSuccess = true
		--	BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,true)
		--	self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		self.isSuccess = false
		--	BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		--	self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then

		if self.isSuccess == true then
			BehaviorFunctions.FinishLevel(self.levelId)
		else
			BehaviorFunctions.RemoveLevel(self.levelId)
		end
	end
end

--赋值
function LevelBehavior200503002:Assignment(variable,value)
	self[variable] = value
end


---------------------回调--------------------

--计时器结束回调
function LevelBehavior200503002:TimerCountFinish(timerId)
	--失败条件时间限制返回失败
	if timerId == self.timeLimitTimerId then
		self.timeLimitFinish = true
		--倒计时警告返回失败
	elseif timerId == self.warningCountDownId then
		self.warningCountDownFinish = true
	end
end


--教学关闭回调
function LevelBehavior200503002:LevelInstructionComplete(tipld)
	if tipld == self.levelInstruction then
		--任务开始
		--self.missionState = 2
		--开场倒计时
		BehaviorFunctions.ShowCountDownPanel(3, self.levelId)
	end
end

--开场倒计时结束回调
function LevelBehavior200503002:OnCountDownFinishEvent(levelId)
	if levelId == self.levelId then
		self.missionState = 2
	end
end

--提示光圈回调
function LevelBehavior200503002:EnterArea(triggerInstanceId, areaName)
	for k,v in ipairs(self.collectionList) do
		if triggerInstanceId == v.id and areaName == "InArea" then
			if self.missionState == 3 then
				--光圈提示特效
				BehaviorFunctions.CreateEntityByPosition(2041204, nil, self.lookAtList[2].bornPos, nil, self.levelId, self.levelId)
			end
		end
	end
end

--交互实体回调
function LevelBehavior200503002:WorldInteractClick(uniqueId,instanceId)
	--初次对话阶段按钮
	if  self.npc == instanceId and self.firstSwitch == true then
		--简单规则说明
		BehaviorFunctions.StartStoryDialog(self.firstInteractId)
		--self.firstSwitch = false
	end

	--任务开始阶段按钮
	if  self.npc == instanceId and self.startSwitch == true then
		--npc转向角色
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
		--任务开始后选项
		BehaviorFunctions.StartStoryDialog(self.inProgressInteractId)
		--修改交互列表
		--BehaviorFunctions.ChangeWorldInteractInfo(self.interactUniqueId, "Textures/Icon/Single/FuncIcon/Trigger_look.png", "关于委托")
	end
end

--对话镜头及事件
function LevelBehavior200503002:StoryPassEvent(dialogId)
	--关卡加载后初次交互
	if dialogId == self.firstInteractId then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Stanshou_loop")
		--npc转向角色
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
		--角色转向npc
		--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)
		--镜头调用 看向npc
		self:levelCamera(22002,self.LevCamera1,self.lookAtList[1].id)
		--如你所见，本来我在用吊车卸箱子
	--elseif	dialogId == self.wakeupInteractId then
		--修改动作
		--BehaviorFunctions.PlayAnimation(self.npc,"Schayao_loop")
		--镜头调用 看向npc
		--self:levelCamera(22002,self.LevCamera1,self.lookAtList[1].id)

		--不小心操作失误，箱子全倒下来了。
	elseif dialogId == self.appleInteractId then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Tuosai_loop")
		--npc转向箱子
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.lookAtList[3].id)
		--镜头调用 看向箱子
		self:levelCamera(22002,self.LevCamera2,self.lookAtList[3].id)

		--全怪我，不该昨晚熬夜打游戏的，那么重要的时候竟然打瞌睡。
	elseif dialogId == self.tuoshouInteractId then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Tuoshou_loop")

		--觉醒者，能求你在工头回来前帮帮我，把箱子移回去吗？
	elseif dialogId == self.askInteractId then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Stanshou_loop")
		--npc转向角色
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
		--角色转向npc
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)

		--惨了，这下要被开除……
	elseif dialogId == self.sorryInteractId then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Fue_loop")
		--黑幕重置
		--self:Black()
		--初次按钮开启
		self.firstSwitch = true

		--好吧……我明白了，我自己承担责任吧
	elseif dialogId == self.cancelInteractId then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Fue_loop")
		--初次按钮开启
		self.firstSwitch = true

		--开始任务按钮
	elseif dialogId == self.startInteractId then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"CheerR_loop")
		--气泡对话
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"加油啊！",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		
		--关闭其他按钮开关
		self.firstSwitch = false
		--开启任务阶段的交互按钮
		self.startSwitch = true
		--可以开搬
		self.ifCtrlState = true

		--任务中重置任务按钮
		--elseif dialogId == self.restartInteractId then
		----修改动作
		--BehaviorFunctions.PlayAnimation(self.npc,"Tuoshou_Loop")
		--BehaviorFunctions.ShowBlackCurtain(true,0.1)
		--BehaviorFunctions.AddDelayCallByTime(1,self,self.ResetLevel)
		--BehaviorFunctions.AddDelayCallByTime(1.5,self,self.CreateActor,self.collectionList)
		--BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,2)
		--self:ResetTime(50)

		--自定义成功条件1：收集物全收集对话
	elseif dialogId == self.successInteractId1 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Laugh")
		--镜头调用 看向npc
		self:levelCamera(22002,self.LevCamera1,self.lookAtList[1].id)

		--自定义成功条件1：收集物全收集对话
	elseif dialogId == self.successInteractId2 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Stanshou_loop")

		--自定义失败条件1：倒计时结束失败对话
	elseif dialogId == self.timeOutInteractId1 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"DodgeBack")

		--自定义失败条件1：倒计时结束失败对话
	elseif dialogId == self.timeOutInteractId2 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Fue_loop")

		--自定义失败条件2：角色超出距离失败对话
	elseif dialogId == self.distanceInteractId1 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Prevent_loop")

		--自定义失败条件2：角色超出距离失败对话
	elseif dialogId == self.distanceInteractId2 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Fue_loop")

		--自定义失败条件3：收集物超出距离限制
	elseif dialogId == self.outAreaInteractId2 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Motou_loop")

		--自定义失败条件4：任务中选择放弃任务按钮
	elseif dialogId == self.interruptInteractId1 then
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"Motou_loop")
		self.cancelTask = true

		--通过分句控制黑幕
	elseif dialogId == self.interruptInteractId2 then

	end
end

--节奏控制
function LevelBehavior200503002:StoryEndEvent(dialogId)
	--倒计时开始节点
	if dialogId == self.startInteractId then
		--图文教学
		BehaviorFunctions.ShowLevelInstruction(self.levelInstruction)

		--自定义失败条件1：倒计时结束失败对话
	elseif dialogId == self.timeOutInteractId1 then
		self:Black()
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)

		--自定义失败条件2：角色超出区域失败对话
	elseif dialogId == self.distanceInteractId1 then
		self:Black()
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)

		--自定义失败条件3：收集物超出区域失败对话
	elseif dialogId == self.outAreaInteractId1 then
		self:Black()
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)

		--自定义失败条件4：任务中选择放弃任务按钮
	elseif dialogId == self.interruptInteractId2 then
		self:Black()
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)

		--任务完成对话
	elseif dialogId == self.successInteractId1 then
		self:Black()
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,true)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)
	end
end