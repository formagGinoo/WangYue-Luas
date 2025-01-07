LevelBehavior405010414 = BaseClass("LevelBehavior405010414",EntityBehaviorBase)
--摄像头玩法关卡1
function LevelBehavior405010414:__init(fight)
	self.fight = fight
end

function LevelBehavior405010414.GetGenerates()
	local generates = {200000108,2030503,2030504,2030505,2030510,2030513,2030514,2020605,900070,2040903,2040905,2050402,8010005,8011010,2030529,2020606}
	return generates
end

function LevelBehavior405010414:Init()
	self.me = self.instanceId
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.rolePos = BehaviorFunctions.GetPositionP(self.role)
	self.time = nil
	
	self.me = self.instanceId
	self.missionState = -1
	self.fileNum = 0

	------追踪标--- -----------------------------------------------------------------------------------------------------
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 50
	self.guidePos = nil
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}


	-----状态定义---------------------------------------------------------------------------------------------------------------------------------------

	--怪物状态枚举
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	--关卡状态枚举
	self.levelStateEnum =
	{
		Default = 0,
		Ongoing = 1,
		LevelSuccess = 2,
		LevelFail = 3,
		LevelEnd = 4,
	}
	--关卡状态
	self.levelState = self.levelStateEnum.Default

	--关卡开启标状态枚举
	self.levelFlagStateEnum =
	{
		Default = 0,
		Showing = 1,
	}
	--关卡开启标状态
	self.levelFlagState = self.levelFlagStateEnum.Default

	--关卡开启标志
	self.levelFlag = nil
	self.levelFlagInteractionId = nil

	-----关卡配置参数---------------------------------------------------------------------------------------------------------------------------------------

	self.logic = "RogueHackMonitor" --生态预制体的名字
	self.levelId = 405010414 --所属地图
	self.positionLevel = 10020005
	self.npc = "npc041" --创建的npc的position名字
	self.door = "Door041" --创建的门的position名字
	self.door2 = "Door042" --创建的门的position名字
	
	self.cameraList = {
		[1] = {bp = "Camera041", Id = nil , entityId = 2030504}, --室内1
		[2] = {bp = "Camera042", Id = nil , entityId = 2030504}, --室内2
		[3] = {bp = "Camera043", Id = nil , entityId = 2030504}, --室内3
		[4] = {bp = "Camera044", Id = nil , entityId = 2030529}, --室外1
		[5] = {bp = "Camera045", Id = nil , entityId = 2030504}, --室内4
		[6] = {bp = "Camera046", Id = nil , entityId = 2030504}, --室内4
	}
	
	
	self.monsterList = {
		[1] = {bp = "Luohou041", Id = nil , entityId = 900070}, --小怪1
		[2] = {bp = "Luohou042", Id = nil , entityId = 8010005}, --小怪2
		[3] = {bp = "Luohou043", Id = nil , entityId = 900070}, --小怪3
		[4] = {bp = "Luohou044", Id = nil , entityId = 900070}, --小怪4
	}
	
	
	self.missionList = {
		[1] = {bp = "Computer041", Id = nil , entityId = 2030513}, --任务道具1
		[2] = {bp = "Computer042", Id = nil , entityId = 2030513}, --任务道具2
		[3] = {bp = "Audio041", Id = nil , entityId = 2030514}, --任务道具3
		[4] = {bp = "Computer043", Id = nil , entityId = 2030513}, --任务道具2
	}
	
	
	
	self.watchangle = 90
	self.success = false
	self.removeFaDai = false
	
	self.doorOpen = false
	
	self.sucFrame = 0
	
	self.isAudioOpen = false
	
	self.goalNum = 0
	self.successNum = 3
	
end

function LevelBehavior405010414:LateInit()
	
	
end

function LevelBehavior405010414:Update()
	self.time = BehaviorFunctions.GetFightFrame() --获得游戏当前帧数
	self.role = BehaviorFunctions.GetCtrlEntity() --获得当前操控角色


	--关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then
		if not self.levelStartPos then
			if self.rogueEventId then
				--获取Rogue_Event表中配置的点位信息
				local pos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
				self.levelStartPos = BehaviorFunctions.GetTerrainPositionP(pos.position,pos.positionId,pos.logicName)
			else
				--如果获取不到点位就在玩家身边创建
				self.levelStartPos = BehaviorFunctions.GetPositionP(self.role)
			end
		end

		--创建关卡开启路牌
		if self.levelFlagState == self.levelFlagStateEnum.Default then
			self.levelFlag = BehaviorFunctions.CreateEntity(200000108,nil,self.levelStartPos.x,self.levelStartPos.y,self.levelStartPos.z,nil,nil,nil,self.levelId)
			self.levelFlagState = self.levelFlagStateEnum.Showing
		end

		--关卡追踪标
		if self.guidePos then
			local pos = BehaviorFunctions.GetTerrainPositionP(self.guidePos.position,self.guidePos.positionId,self.guidePos.logicName)
			self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Police)
		else
			if self.rogueEventId then
				self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
			end
		end


		--关卡处于开始状态
	elseif self.levelState == self.levelStateEnum.Start then
		
		--创建npc
		self.npc = BehaviorFunctions.CreateEntityByPosition(8011010,nil,self.npc,self.logic,self.positionLevel,self.levelId)
		--要先用showheadtips，并且和改变气泡内容及显隐不能在同一帧跑
		BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		self.npcTip = BehaviorFunctions.AddEntityGuidePointer(self.npc,FightEnum.GuideType.Rogue_Police,0,false) --设置引导标
		BehaviorFunctions.ShowTip(20305138) --修改任务提示
		--创建门
		self.door = BehaviorFunctions.CreateEntityByPosition(2020605,nil,self.door,self.logic,self.positionLevel,self.levelId)
		--创建后门
		self.door2 = BehaviorFunctions.CreateEntityByPosition(2020606,nil,self.door2,self.logic,self.positionLevel,self.levelId)
		--创建摄像头
		for i,v in ipairs(self.cameraList) do
			if v.Id == nil then
				v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId,nil,v.bp,self.logic,self.positionLevel,self.levelId)
			end
		end
		--把基站（电脑4）设置成任务目标
		BehaviorFunctions.SetEntityHackEffectIsTask(self.cameraList[4].Id, true)
		
		
		--呼救气泡,播动作
		if not self.GetMission then
			BehaviorFunctions.PlayAnimation(self.npc,"PhoneStand_loop")
			BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.npc,"都怪我一时糊涂，闯了这么大的祸...",999999)
			BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npc,true)
			self.GetMission = true
		end

		--创建怪物道具守卫等
		--守卫
		for i,v in ipairs(self.monsterList) do
			if v.Id == nil then
				v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId,nil,v.bp,self.logic,self.positionLevel,self.levelId)
			end
		end
		
		--赋值
		self.guard1 = self.monsterList[1].Id--看门
		self.guard2 = self.monsterList[2].Id--看守电脑1
		self.guard3 = self.monsterList[3].Id--看守电脑2
		self.guard4 = self.monsterList[4].Id
		
		--把收音机互动npc设置成不可骇入
		BehaviorFunctions.SetEntityHackEnable(self.guard2,false)
		
		--锁怪，让大门口的npc无法行动
		if self.guard1 then
			BehaviorFunctions.DoMagic(1,self.guard1,900000012)--发呆
		end
		
		--创建电脑和音响的任务道具
		for i,v in ipairs(self.missionList) do
			if v.Id == nil then
				v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId,nil,v.bp,self.logic,self.positionLevel,self.levelId)
			end
		end
		
		--赋值，获得大小房间的电脑id
		self.computer1 = self.missionList[1].Id--大房间电脑
		self.computer2 = self.missionList[2].Id--小房间电脑
		self.computer3 = self.missionList[4].Id--小房间电脑


		--把电脑设置成任务目标（骇入）
		if self.computer1 and self.computer2 then

			BehaviorFunctions.SetEntityHackEffectIsTask(self.computer1, true)
			BehaviorFunctions.SetEntityHackEffectIsTask(self.computer2, true)
			BehaviorFunctions.SetEntityHackEffectIsTask(self.computer3, true)
		end
		
		--音响赋值
		self.audio = self.missionList[3].Id
		
		
		
		self.levelState = self.levelStateEnum.Ongoing

		--若关卡处于进行中状态
	elseif self.levelState == self.levelStateEnum.Ongoing then
		if self.success == false then
			--接近npc，了解情况，接任务
			if (not self.GetMissionOn) and self.npc and BehaviorFunctions.CheckEntity(self.npc) then
				--靠近播对话
				local distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc)
				if distance < 3 and self.inDialog1 ~= true then
					self.inDialog1 = true
					
					self.GetMissionOn =true
					--播对话
					BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
					BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)
					BehaviorFunctions.SetNonNpcBubbleVisible(self.hurtnpc,false)
					BehaviorFunctions.StartNPCDialog(601012001,self.npc)
				end
			end
			
			--如果电脑1存在，且守卫2存在，则获取小电脑的看管情况
			if self.computer1 and self.guard2  and BehaviorFunctions.CheckEntity(self.computer1) and BehaviorFunctions.CheckEntity(self.guard2) then
				--获取小电脑1有没有被看管
				self:ComputerByGuard(self.computer1,self.guard2,self.watchangle)

			end
			
			
			--音响交互
			if self.isAudioOpen == true and self.guard2 and self.audio  then
				if BehaviorFunctions.CheckEntity(self.audio) and BehaviorFunctions.CheckEntity(self.guard2) then
					local distance2 = BehaviorFunctions.GetDistanceFromTarget(self.guard2,self.audio)
					if distance2 > 2 then
						BehaviorFunctions.SetPathFollowEntity(self.guard2,self.audio)
						BehaviorFunctions.DoLookAtTargetImmediately(self.guard2,self.audio)
						if BehaviorFunctions.GetEntityState(self.guard2) ~= FightEnum.EntityState.Move then
							BehaviorFunctions.DoSetEntityState(self.guard2,FightEnum.EntityState.Move)
							--BehaviorFunctions.DoSetMoveType(self.guard2,FightEnum.EntityMoveSubState.Walk)
						end
					else
						if not self.dance  then
							BehaviorFunctions.StopMove(self.guard2)
							BehaviorFunctions.ClearPathFinding(self.guard2)
							BehaviorFunctions.DoLookAtTargetImmediately(self.guard2,self.audio)
							--BehaviorFunctions.PlayAnimation(self.guard2,"Motou_loop")
							self.dance = true
							self.isAudioOpen = false
						end
					end
				end
			end
			
			--如果骇入了目标数量的电脑
			if self.goalNum >= self.successNum then
				BehaviorFunctions.ExitHackingMode()
				BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
				BehaviorFunctions.HideTip(20305135)
				self.success = true
			end

		else
			self.levelState = self.levelStateEnum.LevelSuccess
		end

		
		
		

		--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccess then
		
		if self.rogueEventId then
			local Frame = BehaviorFunctions.GetFightFrame()
			if self.sucFrame == 0 then
				self.sucFrame = BehaviorFunctions.GetFightFrame()+30
			end

			if Frame > self.sucFrame then
				BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,true)
				self.levelState = self.levelStateEnum.LevelEnd
			end
			
		end

		--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		
		if self.rogueEventId then
			BehaviorFunctions.SetRoguelikeEventCompleteState(self.rogueEventId,false)
		end
		
		self.levelState = self.levelStateEnum.LevelEnd
		--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then
	end
	
	

-----------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------	
	


		----管理通风管解锁开启
		--if self.TFKZ then
		--self.isOpen = BehaviorFunctions.GetEntityValue(self.TFKZ,"isOpen")
		--if self.isOpen == true then
		--BehaviorFunctions.SetEntityValue(self.TFK2,"isOpen",true)
		--end
		--end

end

--肉鸽追踪
function LevelBehavior405010414:RogueGuidePointer(guidePos,guideDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide =BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	else
		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

--进入实体范围
function LevelBehavior405010414:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			self.levelFlagInteractionId = BehaviorFunctions.WorldInteractActive(self.levelFlag,WorldEnum.InteractType.Talk,nil,"开始挑战",1)
		end
		
		--进入门的交互范围，增加门的交互
		if triggerInstanceId == self.door then
			if self.doorInteractUniqueId == nil  and self.doorOpen == false and self.levelState == self.levelStateEnum.Ongoing then
				self.doorInteractUniqueId = BehaviorFunctions.WorldInteractActive(self.door,WorldEnum.InteractType.OpenDoor, nil, "开门", 1)
			end
			
		end
		
	end
end

--退出实体范围
function LevelBehavior405010414:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			BehaviorFunctions.WorldInteractRemove(self.levelFlag,self.levelFlagInteractionId)
		end
		
		--退出门的交互范围，移除门的交互
		if triggerInstanceId == self.door and self.doorInteractUniqueId then
			BehaviorFunctions.WorldInteractRemove(self.door,self.doorInteractUniqueId)
		end
	end
end

--实体按钮交互
function LevelBehavior405010414:WorldInteractClick(uniqueId,instanceId)
	if uniqueId == self.levelFlagInteractionId and instanceId == self.levelFlag then
		self.levelState = self.levelStateEnum.Start
		BehaviorFunctions.WorldInteractRemove(self.levelFlag,self.levelFlagInteractionId)
		BehaviorFunctions.RemoveEntity(self.levelFlag)

		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
	
	--与门交互
	if uniqueId == self.doorInteractUniqueId and instanceId == self.door then
		BehaviorFunctions.PlayAnimation(self.door, "Opening")
		BehaviorFunctions.StartStoryDialog(601012101)
		self.doorOpen = true
	end
	
	
	--if instanceId == self.door then
		--BehaviorFunctions.PlayAnimation(self.door, "Opening")
	--end
	
	
	
end



--检查电脑有没有被看管
function LevelBehavior405010414:ComputerByGuard(computerId,guardId,watchangle)

	local angle = BehaviorFunctions.GetEntityAngle(guardId,computerId)
	
	if angle < watchangle or angle > (360-watchangle) then
		BehaviorFunctions.SetEntityValue(computerId,"isGuard",true)
		self.lockComputer = true
	else
		BehaviorFunctions.SetEntityValue(computerId,"isGuard",false)
		self.lockComputer = false
	end
	
end

--给电脑上锁
function LevelBehavior405010414:LockComputer(computerId)
	if ( not self.computerLock) and computerId then
		--BehaviorFunctions.SetEntityValue(computerId,"isLock",true)
		self.computerLock = false
	end
end


function LevelBehavior405010414:StoryPassEvent(dialogId)

	--罗睺开门杀
	if dialogId == 601012101 and not self.inCloseUp then
		--进对话时角色转身
		BehaviorFunctions.DoLookAtTargetImmediately(self.guard1,self.role)
		self.inCloseUp = true
	end

	--播动作
	if dialogId == 601012102 then
		if not self.Alert then
			BehaviorFunctions.PlayAnimation(self.guard1,"Alert",FightEnum.AnimationLayer.BaseLayer)
			self.Alert = true
		end
	end

	--npc播动作
	if dialogId == 601012001 and not self.inDialog3 then
		BehaviorFunctions.PlayAnimation(self.npc,"Motou_in")
		self.inDialog3 = true
	end
	
	if dialogId == 601012002 and not self.inDialog4 then
		BehaviorFunctions.PlayAnimation(self.npc,"Motou_loop")
		self.inDialog4 = true
	end
	
	if dialogId == 601012003 and not self.inDialog5 then
		BehaviorFunctions.PlayAnimation(self.npc,"Fuxiong_in")
		self.inDialog5 = true
	end
	
	if dialogId == 601012004 and not self.inDialog6 then
		BehaviorFunctions.PlayAnimation(self.npc,"Schayao_in")
		self.inDialog6 = true
	end
end

function LevelBehavior405010414:StoryEndEvent(dialogId)
	--结束罗睺的警告动画之后
	if dialogId == 601012101 then
		
		--给电脑基站增加引导
		self.cameraStation = BehaviorFunctions.AddEntityGuidePointer(self.cameraList[4].Id,FightEnum.GuideType.Rogue_Police,0,false)
		--移除门的任务标志
		BehaviorFunctions.RemoveEntityGuidePointer(self.doorTip)
		self.doorTip = nil
		--修改任务提示，改成“骇入基站”
		BehaviorFunctions.HideTip(20305136)
		BehaviorFunctions.ShowTip(20305137)
		--如果现在是开门，则播放关门动画，移除与门互动的标志
		if self.doorOpen == true then
			-- 移除标记
			BehaviorFunctions.WorldInteractRemove(self.door,self.doorInteractUniqueId)
			-- 播关门动画
			BehaviorFunctions.PlayAnimation(self.door, "Closing")
		end


	elseif dialogId == 601012001 then
		--移除npc的标志
		BehaviorFunctions.RemoveEntityGuidePointer(self.npcTip)
		self.npcTip = nil
		--显示任务目标
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"但愿这位年轻人靠谱点...",999999)
		--修改任务介绍
		BehaviorFunctions.HideTip(20305138)
		BehaviorFunctions.ShowTip(20305136)
		--给门增加指引
		self.doorTip = BehaviorFunctions.AddEntityGuidePointer(self.door,FightEnum.GuideType.Rogue_Police,0,false)
		
	end

end


--function LevelBehavior405010414:Death(instanceId,isFormationRevive)
	--if instanceId == self.guard2 then
		--if self.guard2 then
			--self.guard2 = nil
		--end
	--end
--end

----重置关卡
--function LevelBehavior405010414:Remark()
--end

--点击骇入按钮的上键
function LevelBehavior405010414:HackingClickUp(instanceId)
	
	--骇入基站，转接到另一个摄像头的视角
	if instanceId == self.cameraList[4].Id then
		--转到摄像头视角
		BehaviorFunctions.DoHackInputKey(self.cameraList[1].Id,FightEnum.KeyEvent.HackUpButton , FightEnum.KeyInputStatus.Down)
		--移除对基站的引导
		BehaviorFunctions.RemoveEntityGuidePointer(self.cameraStation)
		self.cameraStation = nil
		--修改任务目标，改成窃取两份资料
		BehaviorFunctions.HideTip(20305137)
		BehaviorFunctions.ShowTip(20305135,self.goalNum,self.successNum)
		BehaviorFunctions.ChangeTitleTipsDesc(20305135,self.goalNum)
		
		--给电脑增加引导标
		self.computer1tip = BehaviorFunctions.AddEntityGuidePointer(self.computer1,FightEnum.GuideType.Rogue_Police,0,false)
		self.computer2tip = BehaviorFunctions.AddEntityGuidePointer(self.computer2,FightEnum.GuideType.Rogue_Police,0,false)
		self.computer3tip = BehaviorFunctions.AddEntityGuidePointer(self.computer3,FightEnum.GuideType.Rogue_Police,0,false)
	end

	--若骇入小电脑1
	if instanceId == self.computer1 and self.lockComputer == false then
		--移除追踪标
		--BehaviorFunctions.RemoveEntityGuidePointer(self.computer1)
		BehaviorFunctions.RemoveEntityGuidePointer(self.computer1tip)
		BehaviorFunctions.SetEntityHackEffectIsTask(self.computer1 ,false)
		
		--激活ui显示
		BehaviorFunctions.ShowTip(20305131)
		BehaviorFunctions.SetEntityHackEnable(self.me,false)
		
		self.goalNum = self.goalNum +1
		BehaviorFunctions.ChangeTitleTipsDesc(20305135,self.goalNum)
		
		self.goal1 = true
		
	elseif instanceId == self.computer1 and self.lockComputer == true then
		--被看管无法激活ui显示
		BehaviorFunctions.ShowTip(20305132)
	end

	--若骇入小电脑2
	if instanceId == self.computer2 then
		--移除追踪标
		--BehaviorFunctions.RemoveEntityGuidePointer(self.computer2)
		BehaviorFunctions.RemoveEntityGuidePointer(self.computer2tip)
		self.computer2tip = nil
		BehaviorFunctions.SetEntityHackEffectIsTask(self.computer2 ,false)
		
		--if not self.goal1 then
			--BehaviorFunctions.StartStoryDialog(601012201)
		--end
		
		self.goalNum = self.goalNum +1
		BehaviorFunctions.ChangeTitleTipsDesc(20305135,self.goalNum)

	end
	
	--若骇入小电脑3
	if instanceId == self.computer3 then
		--移除追踪标
		--BehaviorFunctions.RemoveEntityGuidePointer(self.computer2)
		BehaviorFunctions.RemoveEntityGuidePointer(self.computer3tip)
		self.computer3tip = nil
		BehaviorFunctions.SetEntityHackEffectIsTask(self.computer3 ,false)

		--if not self.goal1 then
		--BehaviorFunctions.StartStoryDialog(601012201)
		--end

		self.goalNum = self.goalNum +1
		BehaviorFunctions.ChangeTitleTipsDesc(20305135,self.goalNum)

	end
	
	
	--若骇入音响
	if instanceId == self.audio then
		BehaviorFunctions.ShowTip(20305141)
		BehaviorFunctions.SetEntityHackEnable(self.me,false)
		self.isAudioOpen = true
		
	end


end