LevelBehavior200507007 = BaseClass("LevelBehavior200507007",LevelBehaviorBase)
--关卡测试关
function LevelBehavior200507007:__init(fight)
	self.fight = fight
end


function LevelBehavior200507007.GetGenerates()
	local generates = {900060,808011003,80801000301,790006000}
	return generates
end

function LevelBehavior200507007.GetMagics()
	local generates = {8080100030101,8080100030102}
	return generates
end

function LevelBehavior200507007:Init()
	--通用参数---------------------------------------------------------------------------------------------------------------------
	self.role = nil --当前操控角色
	
	--需要配置的内容------------------------------------------
	--self.npcEntity = 80801000301 --月灵大师npc作为怪物的实体id
	--self.yuelingEntity = 900080 --月灵的实体id*
	self.stopBuff = 200000017 --暂停实体行为逻辑的buff
	self.showSwitch = false --是否开启月灵表演
	self.showFrameCd = 60--进入副本后，月灵登场表演需要的帧数
	self.cameraFrameCd = 80
	self.commonTilteFrameCd = 0 --顶部标题出现的帧数cd
	self.tipFrameCd = 10 --tips延迟出现的帧数cd
	self.bubbleFrameCd = 120 --气泡延迟出现的帧数
	
	self.monsterDieFrameCd = 75 --怪物死亡后的延迟帧数，延迟一下出现任务成功的提示
	self.endShowFrameCD = 40 --完成目标之后延迟多少帧完成关卡
	self.yuelingShowAni = "Alert"
	self.yuelingShowEndAni = "Stand1"
	self.monsterList = {
		{id = 80801000301, posName = "mon1", wave = 1},
		{id = 790006000,posName = "mon2", wave = 1}
		}
	----------------------------------------------------------
	
	--副本内的参数-----------------------------------------------------------------------------------------------------------------
	self.missionInState = 0 --副本内的关卡状态
	self.missionInStateEnum = {default = 0, start = 1, ongoing = 2, success = 3, fail = 4} --副本内的关卡状态枚举
	
	self.npcMon = nil --月灵大师npc作为怪物的实例id
	self.yuelingMon = nil --月灵怪物的实例id
	self.monsterListNow = nil
	
	self.posNpcMon = nil --月灵大师的位置
	self.posYuelingMon = nil --月灵的位置

	self.frame = nil --游戏帧数
	self.cameraFrameNext = 0
	self.showFinish = false --是否表演完成
	self.commonTilteFrameNext = 0 --顶部标题出现的时间
	self.commonTilteFrameShow = false
	self.tipFrameNext = 0 --侧边栏tips出现的时间
	self.tipFrameShow = false
	self.bubbleFrameNext = 0 --气泡出现的时间
	self.bubbleFrameShow = false
	self.monsterDieFrameNext = 0 --怪物死亡后的延迟到的帧数
	self.endShowFrameNext = 0
	self.endShowStart = false
	
	
	
	self.npcDead = false --npc是否死亡
	self.yuelingDead = false --月灵是否死亡
	self.npcNum = 0
	self.yuelingNum = 0
	self.tip = nil --是否击败npc和月灵的tip提示
	
	self.gameLeftTime = false --副本剩余时间
	self.gameClear = false
	
	
	
	self.countDownFrameNext = 0
	self.countDownFrameCD = 30
	self.countDownStart = false
	self.countDownEnd = false
	
	--通用行为树
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self) --创建关卡通用行为树
	self.LevelCommon.levelId = self.levelId --将关卡ID赋值给关卡通用行为树
	
end

function LevelBehavior200507007:Update()
	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行
	self.role = BehaviorFunctions.GetCtrlEntity() --获得当前操控角色
	self.frame = BehaviorFunctions.GetFightFrame() --获取当前游戏帧数
	--self.state = BehaviorFunctions.GetEcoEntityState(self.npcEcoId) --获取npc的生态状态
	--self.npc = BehaviorFunctions.GetEcoEntityByEcoId(self.npcEcoId)
	
	--创建npc和月灵
	if self.missionInState == 0 then
		self.posNpcMon = BehaviorFunctions.GetTerrainPositionP("mon1",self.levelId) --获得npc的生成位置
		self.posYuelingMon = BehaviorFunctions.GetTerrainPositionP("mon2",self.levelId) --获得月灵的生成位置
		self.posCharacter = BehaviorFunctions.GetTerrainPositionP("born",self.levelId) --获得角色的生成位置
		----设置玩家位置
		--if self.posCharacter and self.posYuelingMon then
			--self.LevelCommon:SetPlayerPos("born","mon2")
		--end
		
		--创建怪物
		if self.monsterListNow == nil then
			self.monsterListNow = self.LevelCommon:LevelCreateMonster(self.monsterList)
		end
		
		if self.monsterListNow then
			if next(self.monsterListNow) then
				self.npcMon = self.monsterListNow.list[1].instanceId
				self.yuelingMon = self.monsterListNow.list[2].instanceId
				if self.npcMon and self.yuelingMon and self.role then
					BehaviorFunctions.ShowCharacterHeadTips(self.npcMon,true)
					BehaviorFunctions.DoLookAtTargetImmediately(self.npcMon,self.role)
					BehaviorFunctions.DoLookAtTargetImmediately(self.yuelingMon,self.role)
				end
			end
		end
		----创建月灵和npc
		--if self.posNpcMon and self.posYuelingMon then
			--self.npcMon = BehaviorFunctions.CreateEntity(self.npcEntity,nil,self.posNpcMon.x,self.posNpcMon.y,self.posNpcMon.z,self.posNpcMon.rotX,self.posNpcMon.rotY,self.posNpcMon.rotZ)
			--self.yuelingMon = BehaviorFunctions.CreateEntity(self.yuelingEntity,nil,self.posYuelingMon.x,self.posYuelingMon.y,self.posYuelingMon.z,self.posYuelingMon.rotX,self.posYuelingMon.rotY,self.posYuelingMon.rotZ)
			----气泡
			--BehaviorFunctions.ShowCharacterHeadTips(self.npcMon,true)
		--end
		
		if self.showSwitch == true then
			--暂停逻辑，方便做表演
			if self.yuelingMon and self.npcMon then
				BehaviorFunctions.DoLookAtTargetImmediately(self.npcMon,self.role)
				BehaviorFunctions.SetEntityValue(self.npcMon,"haveWarn",true) --开启警戒
				BehaviorFunctions.DoLookAtTargetImmediately(self.yuelingMon,self.role)
				BehaviorFunctions.SetEntityValue(self.yuelingMon,"haveWarn",true) --开启警戒

				BehaviorFunctions.AddBuff(self.npcMon,self.npcMon,self.stopBuff) --增加暂停行为逻辑的buff
				BehaviorFunctions.AddBuff(self.yuelingMon,self.yuelingMon,self.stopBuff) --增加暂停行为逻辑的buff
				
				
				
				self.frameNext = self.frame + self.showFrameCd--计算出场表演结束的时间
			end
		end
		
		BehaviorFunctions.AddBuff(self.npcMon,self.npcMon,self.stopBuff) --增加暂停行为逻辑的buff
		BehaviorFunctions.AddBuff(self.yuelingMon,self.yuelingMon,self.stopBuff) --增加暂停行为逻辑的buff
		
		----空气墙
		--BehaviorFunctions.ActiveSceneObj("airWall1",true,self.levelId)
		--BehaviorFunctions.ActiveSceneObj("airWall2",true,self.levelId)
		--BehaviorFunctions.ActiveSceneObj("airWall3",true,self.levelId)
		--BehaviorFunctions.ActiveSceneObj("airWall4",true,self.levelId)
		
		--self.posRole = BehaviorFunctions.GetEntityPositionOffset(self.npcMon, 0, 0, 5)
		--if self.posRole then
			--BehaviorFunctions.InMapTransport(self.posRole.x,self.posRole.y, self.posRole.z, false)
		--end
		self.dis = BehaviorFunctions.GetDistanceFromTargetWithY(self.role,self.npcMon)
		if self.dis > 5 then
			----相机过度
			--self.monCamera = self.LevelCommon:LevelCameraLookAtInstance(22003,-1,"Bip001",self.npcMon,nil,0)
			--self.LevelCommon:DisablePlayerInput(true,true)
		end
		
		--if self.yuelingMon then
			--if BehaviorFunctions.CheckEntity(self.yuelingMon) then
				--BehaviorFunctions.PlayAnimation(self.yuelingMon,self.yuelingShowAni)
			--end
		--end
		
		----开启副本倒计时
		--BehaviorFunctions.OpenDuplicateCountdown(true)
		
		if self.countDownStart == false then
			self.countDownStart = true
			BehaviorFunctions.ShowCountDownPanel(3,self.levelId)
			--BehaviorFunctions.ShowCommonTitle(10,"击败月灵大师和月灵")
		end
		
		if self.countDownStart == true and self.countDownEnd == true then
			self.cameraFrameNext = self.frame + self.cameraFrameCd
			--self.LevelCommon:DisablePlayerInput(true,false)
			self.missionInState = 1 --转换到表演阶段
		end
		
		
		
	--npc和月灵表演的阶段
	elseif self.missionInState == 1 then
		
		if self.showSwitch then
			--判断是否表演结束
			if self.frame > self.frameNext then
				--BehaviorFunctions.PlayAnimation(self.yuelingMon,self.yuelingShowEndAni)
				self.showFinish = true
				--self.LevelCommon:DisablePlayerInput(false,false)
			end


			if self.frame > self.cameraFrameNext then
				if self.monCamera then
					self.LevelCommon:RemoveLevelCamera(self.monCamera)
					self.monCamera = nil
				end
			end
		end
		

		--表演结束，关闭警戒状态
		if self.showFinish == true or self.showSwitch == false then
			--表演结束，关闭警戒
			BehaviorFunctions.DoLookAtTargetImmediately(self.npcMon,self.role)
			BehaviorFunctions.SetEntityValue(self.npcMon,"haveWarn",false) --关闭警戒
			BehaviorFunctions.DoLookAtTargetImmediately(self.yuelingMon,self.role)
			BehaviorFunctions.SetEntityValue(self.yuelingMon,"haveWarn",false) --关闭警戒
			
			self.commonTilteFrameNext = self.frame + self.commonTilteFrameCd
			self.tipFrameNext = self.frame + self.tipFrameCd
			self.bubbleFrameNext = self.frame + self.bubbleFrameCd
			
			--self.LevelCommon:DisablePlayerInput(false,false)
			
			self.missionInState = 2
		end

	--表演结束，进入战斗
	elseif self.missionInState == 2 then
		--展示通用标题——告诉玩家击败月灵
		if self.frame > self.commonTilteFrameNext and self.commonTilteFrameShow == false then
			self.commonTilteFrameShow = true
			--展示通用标题
			BehaviorFunctions.ShowCommonTitle(10,"击败月灵大师和月灵")
		end
		--展示侧边栏——任务目标
		if self.frame > self.tipFrameNext and self.tipFrameShow == false then
			self.tipFrameShow = true
			--增加侧边栏tips
			if self.tip == nil then
				self.tip = BehaviorFunctions.AddLevelTips(200507001,self.levelId)
			end
			if self.tip then
				BehaviorFunctions.ChangeLevelSubTips(self.tip,1,self.npcNum)
				BehaviorFunctions.ChangeLevelSubTips(self.tip,2,self.yuelingNum)
			end
		end
		
		if self.frame > self.bubbleFrameNext and self.bubbleFrameShow == false then
			self.bubbleFrameShow = true
			--气泡
			BehaviorFunctions.ChangeNpcBubbleContent(self.npcMon,"让你见识一下我和月灵的羁绊吧！",8)
			--BehaviorFunctions.SetNonNpcBubbleVisible(self.npcMon,true)
		end
		
		
		
		
		
		if self.npcMon ~= nil then
			if BehaviorFunctions.HasBuffKind(self.npcMon,self.stopBuff) then
				BehaviorFunctions.RemoveBuff(self.npcMon,self.stopBuff) --移除暂停行为逻辑buff
			end
		end

		if self.yuelingMon ~= nil then
			if BehaviorFunctions.HasBuffKind(self.yuelingMon,self.stopBuff) then
				BehaviorFunctions.RemoveBuff(self.yuelingMon,self.stopBuff) --移除暂停行为逻辑buff
			end
		end
		
		--当npc和怪物都死亡的时候，进入阶段3
		if self.npcDead == true and self.yuelingDead == true then
			self.monsterDieFrameNext = self.frame + self.monsterDieFrameCd
			self.missionInState = 3
		end
		
	--结束战斗，进入结束表演----------------------------------------------------------------------------------------------------------------------
	elseif self.missionInState == 3 then
		if self.frame >  self.monsterDieFrameNext then
			if self.endShowStart == false then
				self.endShowStart = true
				--显示通用标题
				BehaviorFunctions.ShowCommonTitle(5,"战斗胜利",true)
				self.endShowFrameNext = self.frame + self.endShowFrameCD
			end
		end
		
		--出现通用标题提示战斗胜利后的时间
		if self.frame > self.endShowFrameNext and self.endShowStart == true then
			self.missionInState = 4
		end
		

		
		--BehaviorFunctions.ExitDuplicate()
	--结束战斗表演，退出关卡------------------------------------------------------------------------------------------------------------------
	elseif self.missionInState == 4 then
		--空气墙
		BehaviorFunctions.ActiveSceneObj("airWall1",false,self.levelId)
		BehaviorFunctions.ActiveSceneObj("airWall2",false,self.levelId)
		BehaviorFunctions.ActiveSceneObj("airWall3",false,self.levelId)
		BehaviorFunctions.ActiveSceneObj("airWall4",false,self.levelId)
		BehaviorFunctions.FinishLevel(self.levelId)
		
		self.missionInState = 5
	end
end


function LevelBehavior200507007:Death(instanceId,isFormationRevive)
	--if instanceId == self.npcMon  then
		--self.npcDead = true
		--self.npcMon = nil
		--self.npcNum = self.npcNum+1
		--BehaviorFunctions.ChangeLevelSubTips(self.tip,1,self.npcNum)
	--elseif instanceId == self.yuelingMon then
		--self.yuelingDead = true
		--self.yuelingMon = nil
		--self.yuelingNum = self.yuelingNum + 1
		--BehaviorFunctions.ChangeLevelSubTips(self.tip,2,self.yuelingNum)
	--end
	--队伍全灭
	if instanceId == self.role and isFormationRevive then
		if self.npcMon then
			if BehaviorFunctions.CheckEntity(self.npcMon) then
				BehaviorFunctions.RemoveEntity(self.npcMon)
				self.npcMon = nil
			end
		end
		if self.yuelingMon then
			if BehaviorFunctions.CheckEntity(self.yuelingMon) then
				BehaviorFunctions.RemoveEntity(self.yuelingMon)
				self.yuelingMon = nil
			end
		end
	end
end


function LevelBehavior200507007:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.npcMon  then
		self.npcDead = true
		self.npcMon = nil
		self.npcNum = self.npcNum+1
		if self.tip then
			BehaviorFunctions.ChangeLevelSubTips(self.tip,1,self.npcNum)
			BehaviorFunctions.ChangeLevelSubTipsState(self.tip,1,true)
		end
		
	elseif dieInstanceId == self.yuelingMon then
		self.yuelingDead = true
		self.yuelingMon = nil
		self.yuelingNum = self.yuelingNum + 1
		if self.tip then
			BehaviorFunctions.ChangeLevelSubTips(self.tip,2,self.yuelingNum)
			BehaviorFunctions.ChangeLevelSubTipsState(self.tip,2,true)
		end
		
	end
end


function LevelBehavior200507007:DuplicateCountdownFinish()
	if self.npcDead == false or self.yuelingDead == false then
		--self.gameLeftTime = BehaviorFunctions.ReturnDuplicateCountdownRemain()
		--if self.gameLeftTime <= 0 then
			BehaviorFunctions.SetDuplicateResult(false)
		--end
	end
end

function LevelBehavior200507007:TimerCountFinish(timerId)
	if self.npcDead == false or self.yuelingDead == false then
		--self.gameLeftTime = BehaviorFunctions.ReturnDuplicateCountdownRemain()
		--if self.gameLeftTime <= 0 then
		BehaviorFunctions.SetDuplicateResult(false)
		--end
	end
end

function LevelBehavior200507007:OnCountDownFinishEvent(levelId)
	if levelId == self.levelId then
		if self.countDownEnd == false then
			self.countDownEnd = true
		end
	end
end
