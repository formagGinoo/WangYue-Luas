LevelBehavior405010101 = BaseClass("LevelBehavior405010101",LevelBehaviorBase)
--肉鸽关卡:窃听识破揭露抽奖骗局

-- 通用物品创建——遍历列表创建
-- 确定一个坏人（读npcId）,让他显示，给他插对话
-- 确定各个节点，比如啥时候进战、啥时候失败成功
-- 确定一个怪物，让他变身

--准备支持但还没支持的功能：
--创建多个依盖队，或者多个npc变身

function LevelBehavior405010101:__init(fight)
	self.fight = fight
end

function LevelBehavior405010101.GetGenerates()
	local generates = {2070102,2030222,790014000}
	return generates
end


function LevelBehavior405010101:Init()
	self.me = self.instanceId
	self.role = nil
	self.rolePos = nil
	self.time = nil
	self.missionState = 0
	self.alreadyFailNode = false
	self.dialogState = 0
	self.hackNpc = false
	self.bubbleState = true

	-----状态定义---------------------------------------------------------------------------------------------------------------------------------------

	--关卡状态枚举
	self.levelStateEnum =
	{
		Default = 0,
		Ongoing = 1,
		LevelSuccess = 2,
		LevelFail = 3,
		LevelEnd = 4,
	}

	--骇入内容枚举
	self.HackContentEnum =
	{
		Mail = 1,
		Call = 2,
	}

	--关卡状态
	self.levelState = self.levelStateEnum.Default
	self.alreadyHack = false

	-----关卡配置参数---------------------------------------------------------------------------------------------------------------------------------------

	--关卡起始点位
	self.levelStartPos = nil

	--环境物品创建列表
	self.logicName = "RogueHackNpc"  --不填默认为关卡logic
	self.mapId = 10020005        --不填默认为用的关卡logic
	self.posList = {
		[1] = {posName = "table1", entityId = 2030222, instanceId = nil},
		[2] = {posName = "choujiangji1", entityId = 2070102, instanceId = nil},
		-- [3] = {posName = "Box", entityId = 2030229,},
		-- [4] = {posName = "Drink2", entityId = 2030230,},
	}

	--被骇入的npc列表
	self.npcInfo = {
		[1]= {id = 5881101, instanceId = nil, HackContent = 1,},--骇入内容，1短信2电话
	}

	--变身的怪物Id
	self.monsterList ={
		[1] = {entityId = 790014000, lev = nil, bindNpc = 1,},
	}

	self.dialogList = {
		Interact1 = 602010201,   --能发现正确球的第一次
		Interact2 = 602010101,   --不能发现正确球的第一次
		--Interact3 = 602010201,   --已被诈骗过，仍没发现真相
		--Interact4 = 602010201,   --已被诈骗过，已经发现真相
		--Interact5 = 602010201,   --之前选“再考虑考虑”，仍没发现真相
		--Interact6 = 602010201,   --之前选“再考虑考虑”，已经发现真相
		FightNode = 602010212,
		FailNode1 = 602010208,
		FailNode2 = 602010108,
		Success = 602010301,
		Question = 602010401,
	}

	self.weakGuide =
	{
		[1] = {Id = 2203,state = false,Describe ="使用箴石之劣",count = 0},
		[2] = {Id = 2208,state = false,Describe ="可以点击此处进行骇入操作",count = 0},
		[3] = {Id = 2209,state = false,Describe ="可以点击此处进行劫持操作",count = 0},
		[4] = {Id = 2210,state = false,Describe ="点击此处切换轮盘能力",count = 0},
		[5] = {Id = 2228,state = false,Describe ="装配骇入能力",count = 0},
	}

	--距离警告
	self.distanceWarning = false
	--距离范围
	self.warninDistance = 20
	--警告时间
	self.warningEndTime = nil
	--警告时长(秒)
	self.warningTime = 8
end

function LevelBehavior405010101:LateInit()

end

function LevelBehavior405010101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	--self:CheckNpc()

	--关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then
		--关卡创建点位获取
		self:GetRogueLevelPos()
		--物品创建
		self:CreateSceneObjects()
		--获取NPC实例id并处理状态
		self:GetNpcAndSetState()

	elseif self.levelState == self.levelStateEnum.Ongoing then
		--根据是窃听电话还是短信改对应的状态（每帧设置，大力出奇迹打败嘉元的通用ai）
		local npcEntity = BehaviorFunctions.GetNpcEntity(self.npcInfo[1].id)
		if npcEntity then
			self:SetNpcMailOrCallState()
			--每隔一段时间播气泡对话
			self:BubbleDialogLoop()
			--距离地点10米以内播旁白
			local distance = BehaviorFunctions.GetDistanceFromTarget(self.role, self.npcInfo[1].instanceId)
			if distance < 10 then
				if self.dialogState == 0 then
					--播自言自语旁白
					BehaviorFunctions.StartStoryDialog(self.dialogList.Question)
					self.dialogState = 1
				end
			end
		end
		--抽奖失败之后开启教学
		if self.alreadyFail == true and self.alreadyHack == false then
			--self:HackTutorial()
			BehaviorFunctions.AddDelayCallByTime(5,self,self.HackTutorial)
			--BehaviorFunctions.RemoveLevel(self.levelId)
		end

		--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccess then
		BehaviorFunctions.ShowCommonTitle(7,"清除城市威胁",true)
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,true)
		end
		self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		BehaviorFunctions.ShowTip(100000002,"没有成功揭发阴谋，合理运用骇入能力再试试吧")
		if self.rogueEventId then
			--BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,false)   --别传失败了，会被重置关卡
		end
		self.alreadyFail = true
		self.levelState = self.levelStateEnum.Ongoing

		--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then
		BehaviorFunctions.HideTip(100000001)
	end
end

function LevelBehavior405010101:Remove()
	BehaviorFunctions.ChangeEcoEntityCreateState(self.npcInfo[1].instanceId, false)
	BehaviorFunctions.HideTip(100000001)
end

------------------------函数-----------------------------------------------

--关卡创建点位获取
function LevelBehavior405010101:GetRogueLevelPos()
	if not self.levelStartPos then
		if self.rogueEventId then
			local posData = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
			self.levelStartPos = BehaviorFunctions.GetTerrainPositionP(posData.position, posData.positionId, posData.logicName)
		else
			--如果获取不到点位就在玩家身边创建
			self.levelStartPos = BehaviorFunctions.GetPositionP(self.role)
		end
	end
end

--物品创建
function LevelBehavior405010101:CreateSceneObjects()
	for i, v in ipairs(self.posList) do
		--BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.LogicName, self.mapId, self.levelId)
		if not v.instanceId then
			local pos = nil
			local rot = nil
			if self.logicName then
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.mapId, self.logicName)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.mapId, self.logicName)
			else
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.levelId)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.levelId)
			end
			if not v.instanceId then
				v.instanceId = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId, v.lev)
				BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
			end
		end
	end
	--给箱子加刚体
	BehaviorFunctions.SetEntityIsKinematic(self.posList[2].instanceId, false)
end

--获取NPC实例id并处理状态
function LevelBehavior405010101:GetNpcAndSetState()
	for i, v in ipairs(self.npcInfo) do
		BehaviorFunctions.ChangeEcoEntityCreateState(v.id, true)
		self.npcEntity = BehaviorFunctions.GetNpcEntity(v.id)
		if self.npcEntity then
			v.instanceId = self.npcEntity.instanceId
			if v.instanceId then
				--BehaviorFunctions.SetNpcHeadInfoVisible(v.id, false)      --这个会让气泡也不好使！
				self:SetNpcMailOrCallState()
				--加气泡对话(神秘代码初始化)
				BehaviorFunctions.fight.clientFight.headInfoManager:CreateHeadInfoObj(v.instanceId)
			end
			--给npc加指引标
			BehaviorFunctions.AddEntityGuidePointer(self.npcInfo[1].instanceId, FightEnum.GuideType.Rogue_Riddle,1.85)
			BehaviorFunctions.ShowTip(100000001,"利用骇入能力揭发周围的阴谋")
			self.levelState = self.levelStateEnum.Ongoing
		end
	end
end

--设置npc电话和短信状态
function LevelBehavior405010101:SetNpcMailOrCallState()
	for i, v in ipairs(self.npcInfo) do
		local npcEntity = BehaviorFunctions.GetNpcEntity(v.id)
		if npcEntity and v.instanceId and v.HackContent then
			if v.HackContent == self.HackContentEnum.Mail then
				BehaviorFunctions.SetNpcMailState(v.instanceId, true)
				--BehaviorFunctions.PlayAnimation(v.instanceId, "TextStand")
			elseif v.HackContent == self.HackContentEnum.Call then
				BehaviorFunctions.SetNpcCallState(v.instanceId, true)
				--BehaviorFunctions.PlayAnimation(v.instanceId, "PhoneStand")
			end
		end
	end
end

--气泡对话轮播
function LevelBehavior405010101:BubbleDialogLoop()
	if self.bubbleState == true then
		--每隔一段时间播气泡对话
		--BehaviorFunctions.ChangeNpcBubbleContent(self.npcInfo[1].instanceId,"幸运摇摇乐，有胆你就来！",6)
		BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.npcInfo[1].instanceId,"幸运摇摇乐，有胆你就来！",6)
		BehaviorFunctions.AddDelayCallByTime(1,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npcInfo[1].instanceId,true)
		BehaviorFunctions.AddDelayCallByTime(10,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.npcInfo[1].instanceId,"一等奖中奖率高达30%，动动手即可参与！",6)
		BehaviorFunctions.AddDelayCallByTime(10,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npcInfo[1].instanceId,true)
		BehaviorFunctions.AddDelayCallByTime(20,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.npcInfo[1].instanceId,"走过路过不要错过！走过路过不要错过！",6)
		BehaviorFunctions.AddDelayCallByTime(20,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npcInfo[1].instanceId,true)
		--BehaviorFunctions.SetNonNpcBubbleVisible(self.npcInfo[1].instanceId,true)
		self.bubbleState = false
		BehaviorFunctions.AddDelayCallByTime(30,self,self.Assignment,"bubbleState",true)
	end
end

--创建依盖队
function LevelBehavior405010101:CreateYigaidui()
	for i, v in ipairs(self.monsterList) do
		if v.bindNpc then
			local pos = BehaviorFunctions.GetPositionP(self.npcInfo[v.bindNpc].instanceId)
			BehaviorFunctions.SetEntityWorldInteractState(self.npcInfo[v.bindNpc].instanceId, false)   --关闭交互组件
			BehaviorFunctions.SetEntityShowState(self.npcInfo[v.bindNpc].instanceId, false)
			BehaviorFunctions.ShowCharacterHeadTips(self.npcInfo[v.bindNpc].instanceId, false)
			self.Yigaidui = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId, v.Lev)
		else
			--self.Yigaidui = BehaviorFunctions.CreateEntityByPosition(v.entityId, nil, v.posName, self.LogicName, self.mapId, self.levelId, v.lev)
		end
		if self.Yigaidui then
			BehaviorFunctions.SetEntityWorldInteractState(self.posList[2].instanceId, false)   --关闭交互组件
			BehaviorFunctions.DoLookAtTargetImmediately(self.Yigaidui, self.role)
		end
	end
end

--骇入指引封装
function LevelBehavior405010101:HackTutorial()
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

--开启弱引导，并且关闭其他弱引导
function LevelBehavior405010101:WeakGuide(guideId)
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
function LevelBehavior405010101:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

--赋值
function LevelBehavior405010101:Assignment(variable,value)
	self[variable] = value
end

------------------------回调-----------------------------------------------

--交互回调，和npc交互进行抽奖
function LevelBehavior405010101:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.posList[2].instanceId then
		return
	end
	if self.alreadyHack then
		BehaviorFunctions.StartNPCDialog(self.dialogList.Interact1)   --能有发现球的
	else
		BehaviorFunctions.StartNPCDialog(self.dialogList.Interact2)
	end
end

--死亡回调
function LevelBehavior405010101:Death(instanceId,isFormationRevive)
	--角色死亡判负（先直接走系统的全队死亡复活流程就好了，不进判负逻辑）
	if isFormationRevive then
		--self.levelState = self.levelStateEnum.LevelFail
	end
	--打死依盖队成功
	if instanceId == self.Yigaidui then
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		--self.levelState = self.levelStateEnum.LevelSuccess
		--播胜利对话
		BehaviorFunctions.StartStoryDialog(self.dialogList.Success)
	end
end

--回调，经过相关剧情
function LevelBehavior405010101:StoryPassEvent(dialogId)
	if dialogId == self.dialogList.FightNode then
		if not self.Yigaidui then
			self:CreateYigaidui()  --罗睺斩客
		end
	elseif dialogId == self.dialogList.FailNode1 or dialogId == self.dialogList.FailNode2 then
		self.alreadyFailNode = true
		--self.levelState = self.levelStateEnum.LevelFail
	end
end

--回调，完成相关剧情
function LevelBehavior405010101:StoryEndEvent(dialogId)
	if dialogId == self.dialogList.Success then   --播完成功后的对话
		self.levelState = self.levelStateEnum.LevelSuccess
		--播完没球的对话并经过失败节点
	elseif dialogId == self.dialogList.Interact2 and self.alreadyFailNode then
		self.levelState = self.levelStateEnum.LevelFail
	end
end

--受击回调，npc四散奔逃（视情况看用不用）
function LevelBehavior405010101:Hit(attackInstanceId,hitInstanceId,hitType,camp)
	if self.missionState == 0 then
		if attackInstanceId == self.role or hitInstanceId == self.role then
			BehaviorFunctions.SetBlackBoardValue(CustomFsmDataBlackBoardEnum.inCrime, self.levelStartPos)
			self.missionState = 1
		end
	end
end

--开始窃听回调
function LevelBehavior405010101:HackingClickUp(instanceId)
	if instanceId == self.npcInfo[1].instanceId and self.alreadyHack == false then   --暂时写死了是1号npc被窃听
		self.alreadyHack = true
		--BehaviorFunctions.ShowCommonTitle(7,"已拦截到关键信息",true)
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions, BehaviorFunctions.ShowCommonTitle, 7,"发现城市威胁",true)
		BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions, BehaviorFunctions.ShowTip,100000001,"上前抽奖拆穿阴谋")
	end
	self:RemoveWeakGuide()
end

--退出骇入回调
function LevelBehavior405010101:ExitHacking()
	if self.alreadyHack == true then
		BehaviorFunctions.ShowTip(100000001,"上前抽奖拆穿阴谋")
		--BehaviorFunctions.AddEntityGuidePointer(self.npcInfo[1].instanceId, FightEnum.GuideType.Rogue_Riddle,2)   --放在前面了
	end
	self:RemoveWeakGuide()
end

--骇入回调
function LevelBehavior405010101:Hacking(instanceId)
	if instanceId == self.npcInfo[1].instanceId then
		if self.alreadyFail == true and self.alreadyHack == false then
			--如果劫持引导还没触发或冷却CD完成
			if self.weakGuide[3].state == false then
				--播放劫持引导
				self:WeakGuide(self.weakGuide[3].Id)
				self.weakGuide[3].state = true
			end
		end
	end
end