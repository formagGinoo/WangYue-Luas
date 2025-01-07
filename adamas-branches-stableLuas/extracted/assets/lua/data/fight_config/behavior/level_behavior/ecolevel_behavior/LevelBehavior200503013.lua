LevelBehavior200503013 = BaseClass("LevelBehavior200503013",LevelBehaviorBase)
--NPC搬运玩法1

function LevelBehavior200503013:__init(fight)
	self.fight = fight
end

function LevelBehavior200503013.GetGenerates()
	local generates = {808012004, 8011003, 2080109, 2080102, 2041201, 2041202, 2080103, 2080106, 2080107}
	return generates
end

function LevelBehavior200503013:Init()

	self.missionState = 0


	----------实体参数----------

	--NPC是否处于控制状态开关
	self.collectionCtrlState = false
	--区域内收集物数量
	self.inareaNum = 0

	--NPC区域状态
	self.collectionStateEnum = {
		default = 0,--默认状态
		inarea = 1,--在目标区域
		outarea = 2,--不在目标区域，但在任务区域内
		reset = 3,--在任务区域外
	}

	--搬运用NPC
	self.collectionList = {
		[1] = {entityId = 2080109, bornPos = "shoujiwu1", state = self.collectionStateEnum.default, id = nil},
	}

	--空实体list
	self.lookAtList = {
		[1] = {entityId = 2001, bornPos = "npc",  id = nil},
		[2] = {entityId = 2001, bornPos = "tishi",  id = nil},
		[3] = {entityId = 2001, bornPos = "shoujiwu1",  id = nil},
		[4] = {entityId = 2001, bornPos = "player",  id = nil},
	}


	----------交互列表参数----------


	--初次对话按钮开关
	self.firstSwitch = false
	--开始任务按钮开关
	self.startSwitch = false

	--首次交互对话
	self.firstInteractId = 601014401
	--唉……怎么办呢？
	self.cancelInteractId = 601014402
	--呜呜，那好吧，我在原地等等我的伙伴们。
	self.leavelInteractId = 601014504
	--真的呀，那就谢谢你啦！
	self.startInteractId = 601014502
	--我的伙伴们就在那个方向！
	self.friendInteractId = 601014503

	--任务进行中按钮
	self.inProgressInteractId = 601014601
	--任务进行中放弃对话
	self.interruptInteractId1 = 601014602
	--任务进行中放弃对话
	self.interruptInteractId2 = 601015101

	--角色/NPC超出范围失败对话
	self.outAreaInteractId = 601014901

	--角色断开连接失败对话1
	self.disconnectInteractId1 = 601014701
	--角色断开连接失败对话2
	self.disconnectInteractId2 = 601014801

	--任务完成对话
	self.successInteractId = 601015001




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
	self.levelInstruction = 200503011
	

	----------关卡参数----------

	self.logic = 200503012
	self.positionLevel = 200503012

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
	self.levelName = "将脉灵运送至目的地"
	--关卡是否成功
	self.isSuccess = false


	----------失败条件：超出距离----------

	--是否超出关卡极限距离
	--角色
	self.distanceLimit1 = false
	--NPC
	self.distanceLimit2 = false
	--材料
	self.distanceLimit3 = false
	--超过距离警告当前时间
	self.distanceWarningCurrentTime = nil
	--超过距离警告结束时间
	self.distanceWarningEndTime = nil
	--超过距离警告当前剩余秒数
	self.warningSecond = 0
	--主动取消任务
	self.cancelTask = false

	----------失败条件：NPC断开连接----------
	self.npcDisconnect = false

end

function LevelBehavior200503013:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()
	--通用关卡逻辑
	--运行关卡状态机
	self:ChallengeLevelFSM()

	if self.missionState == 0  then
		--创建实体
		--Npc
		self.npc = BehaviorFunctions.CreateEntityByPosition(808012004, nil, self.lookAtList[1].bornPos, nil, self.levelId, self.levelId)
		--修改动作
		BehaviorFunctions.PlayAnimation(self.npc,"ExceptionLoop")
		--头顶icon
		BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcHeadIcon,self.npc, "Textures/Icon/Single/FuncIcon/Map_jiujishou.png")
		--气泡对话
		BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"好想去到那里...",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		--交互列表
		--初次按钮开启
		self.firstSwitch = true
		--空交互实体
		--self.interactUniqueId = BehaviorFunctions.CreateEntityByPosition(200000101, nil, self.lookAtList[1].bornPos, nil, self.levelId, self.levelId)
		--修改交互列表
		--BehaviorFunctions.ChangeWorldInteractInfo(self.interactUniqueId, "Textures/Icon/Single/FuncIcon/Trigger_look.png", "对话")
		--镜头过渡
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",1.2)
		BehaviorFunctions.SetVCCameraBlend("LevelCamera","**ANY CAMERA**",1.2)
		--关卡镜头的目标实体
		self:LookAtInstance()

		self.missionState = 1
	end

	--npc转向
	if self.missionState == 1 then
		--npc转向角色
		if self.npc then
			BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
		end
		--引导
		--self:guide()
	end

	--点击开始
	if self.missionState == 2 then

		--关卡开启
		self:LevelStart()
		--移除交互列表
		BehaviorFunctions.RemoveEntity(self.interactUniqueId)
		--黑幕创建实体
		--搬运用Npc及建材
		self:BlackStart()

		--目的地光圈
		self.tishi = BehaviorFunctions.CreateEntityByPosition(2041201, nil, self.lookAtList[2].bornPos, nil, self.levelId, self.levelId)
		--关卡提示
		self.levelTips = BehaviorFunctions.AddLevelTips(200503011,self.levelId)
		--剩余数量提示
		BehaviorFunctions.ChangeLevelSubTips(self.levelTips,1,self.inareaNum)

		--创建引导
		self.guidePointer = BehaviorFunctions.AddEntityGuidePointer(self.lookAtList[2].id,self.GuideTypeEnum.Jiujishou,0,false)
		--镜头调用 看向目的地
		self:levelCamera(22002, self.LevCamera2, self.lookAtList[2].id)
		
		self.missionState = 3
	end

	--全部物品收集完成判断
	if self.missionState == 3 then

		if self.levelState == self.levelStateEnum.Ongoing then


			----------关卡失败条件----------

			--自定义失败条件1：角色超出距离限制
			local result1 = self:FailCondition_Distance1(self.lookAtList[2].bornPos, 80, 90, 10)
			--自定义失败条件2：NPC超出距离限制
			local result2 = self:FailCondition_Distance2(10)
			--自定义失败条件3：NPC倾斜超过一定角度
			--local result3 = self.npcDisconnect
			--自定义失败条件4：开始任务后主动取消
			local result4 = self.cancelTask

			self:LevelFailCondition(result1, result2, result4)


			----------关卡成功条件----------

			--自定义成功条件1：完成NPC运送
			local result1 = self:SuccessCondition_Collection(1)

			self:LevelSuccessCondition(result1)
		end
	end
end

--创建实体
function LevelBehavior200503013:CreateActor(list)
	for k,v in ipairs(list) do
		v.id = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.bornPos, nil, self.levelId, self.levelId)
	end
end

--空实体创建
function LevelBehavior200503013:LookAtInstance()
	for k,v in ipairs(self.lookAtList) do
		--看向目标点略微抬升
		local pos = BehaviorFunctions.GetTerrainPositionP(self.lookAtList[k].bornPos,self.levelId)
		v.id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	end
	--先创建一个空实体以供npc相机挂
	self.LevCameraPos = BehaviorFunctions.CreateEntityByPosition(2001, nil, "npcCamera", nil, self.levelId, self.levelId)
end

--移除收集物函数
function LevelBehavior200503013:ResetLevel()
	if self.collectionList then
		for k,v in ipairs(self.collectionList) do
			BehaviorFunctions.RemoveEntity(v.id)
		end
	end
end

--黑幕移除物品
function LevelBehavior200503013:Black()
	BehaviorFunctions.ShowBlackCurtain(true, 0.3)
	BehaviorFunctions.AddDelayCallByTime(0.4, self, self.ResetLevel)
	self.blackEnd = BehaviorFunctions.AddDelayCallByTime(0.5, BehaviorFunctions, BehaviorFunctions.ShowBlackCurtain, false, 0.5)
end

--黑幕移除物品
function LevelBehavior200503013:BlackStart()
	BehaviorFunctions.RemoveEntity(self.npc)
	self:CreateActor(self.collectionList)
	BehaviorFunctions.AddEntityGuidePointer(self.collectionList[1].id, FightEnum.GuideType.Map_Jiujishou,1.3,false,5)
	--BehaviorFunctions.ShowBlackCurtain(true,0.3)
	--BehaviorFunctions.AddDelayCallByTime(0.4, BehaviorFunctions, BehaviorFunctions.RemoveEntity, self.npc)
	--BehaviorFunctions.AddDelayCallByTime(0.4, self, self.CreateActor, self.collectionList)
	--self.blackEnd = BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5)
end

--失败传送
function LevelBehavior200503013:FailTransfer(position,lookAtPos)
	local pp1 = BehaviorFunctions.GetTerrainPositionP(position,self.levelId)
	local lp1 = BehaviorFunctions.GetTerrainPositionP(lookAtPos,self.levelId)
	BehaviorFunctions.ShowBlackCurtain(true,0.2)
	BehaviorFunctions.AddDelayCallByTime(0.3,BehaviorFunctions,BehaviorFunctions.InMapTransport,pp1.x,pp1.y,pp1.z)
	BehaviorFunctions.AddDelayCallByTime(0.3,BehaviorFunctions,BehaviorFunctions.DoLookAtPositionImmediately,self.role,lp1.x,nil,lp1.z)
	--初始相机朝向
	--BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.CameraPosReduction,0)
	self.transferEnd = BehaviorFunctions.AddDelayCallByTime(0.7,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
end

--镜头调用
function LevelBehavior200503013:levelCamera(type,cameraInstanceId,target)
	if not cameraInstanceId then
		cameraInstanceId = BehaviorFunctions.CreateEntity(type)
	end
	BehaviorFunctions.CameraEntityFollowTarget(cameraInstanceId,self.role)--让关卡相机跟随玩家
	BehaviorFunctions.CameraEntityLockTarget(cameraInstanceId,target)--让关卡相机看向目标
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,target)--转向目标
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.RemoveEntity,cameraInstanceId)
end

--引导管理
function LevelBehavior200503013:guide()
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
			self.guidePointer1 = BehaviorFunctions.AddEntityGuidePointer(self.npc,self.GuideTypeEnum.Jiujishou,2,false)
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
function LevelBehavior200503013:LevelStart()
	if self.levelState == self.levelStateEnum.Default then
		self.levelState = self.levelStateEnum.Start
	end
end

--关卡胜利判断
function LevelBehavior200503013:LevelSuccessCondition(...)
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
			BehaviorFunctions.RemoveLevelTips(200503011)
			--移除提示光圈
			BehaviorFunctions.RemoveEntity(self.tishi)
			--关卡状态改为胜利
			self.levelState = self.levelStateEnum.LevelSuccess
		end
	end
end

--自定义关卡胜利条件1：收集物全收集
function LevelBehavior200503013:SuccessCondition_Collection(num)
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

	--检测NPC状态
	if self.collectionList then
		for k,v in ipairs(self.collectionList) do
			local distance = BehaviorFunctions.GetDistanceFromTarget(self.lookAtList[2].id,v.id)
			if distance then
				if distance <= 5 then
					v.state = self.collectionStateEnum.inarea
				end
				if distance > 5 and distance <= 80 then
					v.state = self.collectionStateEnum.outarea
				end
				if distance > 80 then
					v.state = self.collectionStateEnum.reset
				end
			end
		end
	end

	--区域内收集物数量达到目标数量且不处于控制状态时完成委托
	if	self.inareaNum == num and self.collectionCtrlState == false then
		--任务成功对话1
		BehaviorFunctions.StartStoryDialog(self.successInteractId)
		return true
	else
		return false
	end
end

--关卡失败判断
function LevelBehavior200503013:LevelFailCondition(...)
	local condition = {...}
	--计算完成条件的数量
	for i,v in ipairs(condition) do
		if v == true then
			if self.levelState == self.levelStateEnum.Ongoing then
				--隐藏提示
				BehaviorFunctions.RemoveLevelTips(self.levelTips)
				--移除提示光圈
				BehaviorFunctions.RemoveEntity(self.tishi)
				--关卡状态改为失败
				self.levelState = self.levelStateEnum.LevelFail
			end
		end
	end
end

--自定义关卡失败条件1：角色超出关卡距离一段时间
function LevelBehavior200503013:FailCondition_Distance1(pos,warndistance,faildistance,timeLimit)
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
				BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd, self.levelName, false)
				self.levelState = self.levelStateEnum.LevelEnd
				--return true
			end
		end
	else
		if self.distanceLimit1 == true then
			self.distanceLimit1 = false
			BehaviorFunctions.RemoveLevelTips(self.levelFailTips)
		end
	end
	if faildistance < distanceBetweenPos then
		--return true
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd, self.levelName, false)
		self.levelState = self.levelStateEnum.LevelEnd
	end
	return false
end

--自定义关卡失败条件2：NPC超出距离一段时间
function LevelBehavior200503013:FailCondition_Distance2(timeLimit)
	--重置状态收集物计数
	self.resetNPCNum = 0
	self.collectionCtrlState = false
	for k,v in ipairs(self.collectionList) do
		if v.state == self.collectionStateEnum.reset then
			self.resetNPCNum = self.resetNPCNum + 1
		end
	end

	if	self.resetNPCNum > 0 then
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
					self.levelDistanceTips = BehaviorFunctions.AddLevelTips(200503012,self.levelId,second)
				end
			else
				--NPC超出距离失败对话
				BehaviorFunctions.StartStoryDialog(self.outAreaInteractId)
				--失败黑幕传送
				--self:FailTransfer(self.lookAtList[4].bornPos,self.lookAtList[1].bornPos)
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

--自定义关卡失败条件3：NPC倾斜断开连接
--function LevelBehavior200503013:OnBuildDisconnect(instanceId_1, instanceId_2, point1, point2, disconnectType)
	--if instanceId_1 == self.collectionList[1].id and disconnectType == 2 then
		--self.npcDisconnect = true
		--BehaviorFunctions.StartStoryDialog(self.disconnectInteractId1)
	--else
		--self.npcDisconnect = false
	--end
--end

--关卡状态机
function LevelBehavior200503013:ChallengeLevelFSM()
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
		--BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,true)
		--self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		--失败黑幕传送
		self.isSuccess = false
		--BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		--self.levelState = self.levelStateEnum.LevelEnd

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
function LevelBehavior200503013:Assignment(variable,value)
	self[variable] = value
end


---------------------回调--------------------

--提示光圈回调
function LevelBehavior200503013:EnterArea(triggerInstanceId, areaName)
	for k,v in ipairs(self.collectionList) do
		if triggerInstanceId == v.id and areaName == "InArea" then
			if self.missionState == 3 then
				--光圈提示特效
				BehaviorFunctions.CreateEntityByPosition(2041202, nil, self.lookAtList[2].bornPos, nil, self.levelId, self.levelId)
			end
		end
	end
end

--交互实体回调
function LevelBehavior200503013:WorldInteractClick(uniqueId,instanceId)
	--初次对话阶段按钮
	if  self.npc == instanceId and self.firstSwitch == true then
		BehaviorFunctions.StartStoryDialog(self.firstInteractId)
	end

	--任务开始阶段按钮
	if  self.collectionList[1].id == instanceId and self.startSwitch == true then
		BehaviorFunctions.StartStoryDialog(self.inProgressInteractId)
	end
end

--教学关闭回调
function LevelBehavior200503013:LevelInstructionComplete(tipld)
	if tipld == self.levelInstruction  then
		--任务开始
		self.missionState = 2
	end
end

--对话节点
function LevelBehavior200503013:StoryPassEvent(dialogId)
		--关卡加载后初次交互
	if dialogId == self.firstInteractId then
		--npc转向角色
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc, self.role)
		--角色转向npc
		BehaviorFunctions.DoLookAtTargetImmediately(self.role, self.npc)
		--镜头调用
		self.LevCamera1 = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.CameraEntityFollowTarget(self.LevCamera1,self.role)--让关卡相机跟随玩家
		BehaviorFunctions.CameraEntityLockTarget(self.LevCamera1,self.npc)--让关卡相机看向目标
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)--转向目标
	
		--唉……怎么办呢？
	elseif dialogId == self.cancelInteractId then
		--移除镜头
		BehaviorFunctions.RemoveEntity(self.LevCamera1)
	
		
	elseif dialogId ==self.leavelInteractId then
		--移除镜头
		BehaviorFunctions.RemoveEntity(self.LevCamera1)
		
		--真的呀，那就谢谢你啦！
	elseif dialogId == self.startInteractId then
		--移除镜头
		BehaviorFunctions.RemoveEntity(self.LevCamera1)
		--图文教学
		BehaviorFunctions.ShowLevelInstruction(self.levelInstruction)
		--关闭其他按钮开关
		self.firstSwitch = false
		--开启任务阶段的交互按钮
		self.startSwitch = true


		--我的伙伴们就在那个方向！
	elseif dialogId == self.friendInteractId then
		--镜头调用 看向目的地
		--self:levelCamera(22002, self.LevCamera2, self.lookAtList[2].id)

		--自定义失败条件2：NPC超出距离限制
	elseif dialogId == self.outAreaInteractId then
		--移除搬运用实体
		self:Black()
		--重新创建搬运实体
		--self:CreateActor(self.collectionList)
		--失败传送
		--self:FailTransfer(self.lookAtList[4].bornPos, self.lookAtList[1].bornPos)
		--镜头调用 看向npc
		--self:levelCamera(22002, self.LevCamera1, self.npc2)


		--自定义失败条件3：NPC倾斜超过一定角度
	elseif dialogId == self.disconnectInteractId2 then
		--移除搬运用实体
		self:ResetLevel()
		--重新创建npc
		self:CreateActor(self.collectionList)
		--失败传送
		self:FailTransfer(self.lookAtList[4].bornPos, self.lookAtList[1].bornPos)
		--创建Npc
		--self.npc2 = BehaviorFunctions.CreateEntityByPosition(808012004, nil, self.lookAtList[1].bornPos, nil, self.levelId, self.levelId)
		--npc看向玩家
		--BehaviorFunctions.AddDelayCallByTime(0.5, BehaviorFunctions, BehaviorFunctions.DoLookAtTargetImmediately, self.npc2, self.role)
		--镜头调用 看向npc
		--self:levelCamera(22002, self.LevCamera1, self.lookAtList[1].id)
		

		--自定义失败条件4：任务中选择放弃任务按钮a
	elseif dialogId == self.interruptInteractId1 then
		self.cancelTask = true
	end
end

--节奏控制
function LevelBehavior200503013:StoryEndEvent(dialogId)
	--自定义失败条件2：NPC超出距离限制
	if dialogId == self.outAreaInteractId then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)

		--自定义失败条件3：NPC倾斜超过一定角度
	elseif dialogId == self.disconnectInteractId2 then
		--BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		--BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)

		--自定义失败条件4：任务中选择放弃任务按钮
	elseif dialogId == self.interruptInteractId2 then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)

		--自定义关卡胜利条件1：收集物全收集
	elseif dialogId == self.successInteractId then
		self:Black()
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,true)
		BehaviorFunctions.AddDelayCallByTime(0.3,self,self.Assignment,"levelState",5)
	end
end

