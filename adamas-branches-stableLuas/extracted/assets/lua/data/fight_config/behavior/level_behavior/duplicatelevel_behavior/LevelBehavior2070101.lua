LevelBehavior2070101 = BaseClass("LevelBehavior2070101",EntityBehaviorBase) 
--摄像头玩法关卡1
function LevelBehavior2070101:__init(fight)
	self.fight = fight
end

function LevelBehavior2070101.GetGenerates()
	local generates = {200000108,2030503,2030504,2030505,2030510,2030513,2030514,2020605,900070,2040903,2040905,2050402,8011011,8010005}
	return generates
end

function LevelBehavior2070101:Init()
	self.me = self.instanceId
	self.role = nil
	self.missionState = -1
	self.fileNum = 0
	
	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	

	self.cameraList = {
		[1] = {bp = "Camera1", Id = nil , entityId = 2030504}, --室内1
		[2] = {bp = "Camera2", Id = nil , entityId = 2030504}, --室内2
		[3] = {bp = "Camera3", Id = nil , entityId = 2030504}, --室内3
		[4] = {bp = "Camera4", Id = nil , entityId = 2030505}, --室外1
		[5] = {bp = "Camera5", Id = nil , entityId = 2030504}, --室内4
	}
	
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

	
	self.role = BehaviorFunctions.GetCtrlEntity()
	--self.time = BehaviorFunctions.GetFightFrame()

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
	
end

function LevelBehavior2070101:Update()	

	--关卡处于默认状态时
	if self.missionState == -1 then
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
	end
		
	--创建npc,接任务
	if self.missionState == 0 then
		--创建npc
		self.npc = BehaviorFunctions.CreateEntityByPosition(8011011,nil,"npc","Rogue_hackmonitor",nil,self.levelId)
		--要先用showheadtips，并且和改变气泡内容及显隐不能在同一帧跑
		BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		--BehaviorFunctions.AddEntityGuidePointer(self.npc,4,5,false) --设置引导标
		--创建门
		self.door = BehaviorFunctions.CreateEntityByPosition(2020605,nil,"Door","Rogue_hackmonitor",nil,self.levelId)
		--创建摄像头
		for i,v in ipairs(self.cameraList) do
			if v.Id == nil then
				v.Id = BehaviorFunctions.CreateEntityByPosition(v.entityId,nil,v.bp,"Rogue_hackmonitor",nil,self.levelId)
			end
		end
		--给基站增加引导
		BehaviorFunctions.AddEntityGuidePointer(self.cameraList[4].Id,FightEnum.GuideType.Rogue_Police,0,false)
		BehaviorFunctions.AddBuff(self.cameraList[4].Id,self.cameraList[4].Id,200001103)
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		--呼救气泡,播动作
		if not self.GetMission then
			BehaviorFunctions.PlayAnimation(self.npc,"PhoneStand_loop")
			BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.ChangeNpcBubbleContent,self.npc,"都怪我一时糊涂，闯了这么大的祸...",999999)
			BehaviorFunctions.AddDelayCallByFrame(5,BehaviorFunctions,BehaviorFunctions.SetNonNpcBubbleVisible,self.npc,true)
			--BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"都怪我一时糊涂，闯了这么大的祸...",999999)
			--BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
			self.GetMission = true
		end
		--靠近播对话
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc)
		if distance < 5 and self.inDialog1 ~= true then
			self.inDialog1 = true
			--播对话
			--BehaviorFunctions.PlayAnimation(self.npc,"PhoneStand_out")
			BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc)
			BehaviorFunctions.SetNonNpcBubbleVisible(self.hurtnpc,false)
			--BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,601012001)
			self.missionState = 2
			--BehaviorFunctions.AddDelayCallByTime(0,BehaviorFunctions,BehaviorFunctions.StartNPCDialog,601012001)
			BehaviorFunctions.StartNPCDialog(601012001,self.npc)
		end
	end
	
	--挑战开始，创建怪物、道具等
	if self.missionState == 2 then
		--创建
		
		--守卫
		self.guard1 = BehaviorFunctions.CreateEntityByPosition(900070,nil,"Luohou1","Rogue_hackmonitor",nil,self.levelId)--看门
		self.guard2 = BehaviorFunctions.CreateEntityByPosition(8010005,nil,"Luohou2","Rogue_hackmonitor",nil,self.levelId)--看守电脑1
		self.guard3 = BehaviorFunctions.CreateEntityByPosition(900070,nil,"Luohou3","Rogue_hackmonitor",nil,self.levelId)--看守电脑2
		--self.guard4 = BehaviorFunctions.CreateEntityByPosition(900070,nil,"Luohou4","Rogue_hackmonitor",nil,self.levelId)
		--锁怪
		if self.guard1 then
			BehaviorFunctions.DoMagic(1,self.guard1,900000012)--发呆
		end
		
		--创建电网
		--self.dianWang = BehaviorFunctions.CreateEntityByPosition(2030503,nil,"DianWang1","Rogue_hackmonitor",nil,self.levelId)
		--创建电脑
		self.computer1 = BehaviorFunctions.CreateEntityByPosition(2030513,nil,"Computer1","Rogue_hackmonitor",nil,self.levelId)--大房间电脑
		self.computer2 = BehaviorFunctions.CreateEntityByPosition(2030513,nil,"Computer2","Rogue_hackmonitor",nil,self.levelId)--小房间电脑
		BehaviorFunctions.AddBuff(self.computer1,self.computer1,200001103)
		BehaviorFunctions.AddBuff(self.computer2,self.computer2,200001103)
		BehaviorFunctions.AddEntityGuidePointer(self.computer1,FightEnum.GuideType.Rogue_Police,0,false)
		BehaviorFunctions.AddEntityGuidePointer(self.computer2,FightEnum.GuideType.Rogue_Police,0,false)
		if self.computer1 and self.computer2 then
			--BehaviorFunctions.AddEntityGuidePointer(self.computer1,2,1,false) --设置引导标
			--BehaviorFunctions.AddEntityGuidePointer(self.computer2,2,1,false) --设置引导标
		end
		--创建音响
		self.audio = BehaviorFunctions.CreateEntityByPosition(2030514,nil,"Audio","Rogue_hackmonitor",nil,self.levelId)
		
		----创建通风口
		--self.TFK1 = BehaviorFunctions.CreateEntityByPosition(2040903,nil,"TFK1","Rogue_hackmonitor",nil,self.levelId)
		--self.TFK2 = BehaviorFunctions.CreateEntityByPosition(2040905,nil,"TFK2","Rogue_hackmonitor",nil,self.levelId)
		--self.TFKZ = BehaviorFunctions.CreateEntityByPosition(2050402,nil,"TFK1","Rogue_hackmonitor",nil,self.levelId)
		

		--if self.TFK1 and self.TFK2 then
			--self.AtomizeConfig = {
				--{
					--instanceId = self.TFK1,
				--},

				--{
					--instanceId = self.TFK2,
				--},
			--}
		
		--BehaviorFunctions.SetEntityValue(self.TFK1,"AtomizeConfig",self.AtomizeConfig)	
		--BehaviorFunctions.SetEntityValue(self.TFK2,"AtomizeConfig",self.AtomizeConfig)
		--end	
			
		self.missionState = 3
	end
	
	--关卡流程
	if self.missionState == 3 then
		
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.npc)
		--移除罗睺发呆，显示门交互按钮
		if distance > 8 and self.success and not self.removeFaDai then
			BehaviorFunctions.RemoveBuff(self.guard1,900000012)
			BehaviorFunctions.SetEntityWorldInteractState(self.door,true)
			self.removeFaDai = true
		end
		--self.missionState = 2
	--end
	
	--if self.missionState == 2 then
		
		--开门，罗睺怼脸镜头
		--检查开门
		local isOpen = BehaviorFunctions.GetEntityValue(self.door,"isOpen")
		if isOpen == true and self.inDialog2 ~= true then
			self.inDialog2 = true
			BehaviorFunctions.StartStoryDialog(601012101)
		end
		
		--获取小电脑1有没有被看管
		self:ComputerByGuard(self.computer1,self.guard2)
		--获取音响，开了就吸引敌人
		self.isAudioOpen = BehaviorFunctions.GetEntityValue(self.audio,"audioOpen")
		if self.isAudioOpen == true then 
			local distance = BehaviorFunctions.GetDistanceFromTarget(self.guard2,self.audio)
			if distance > 1.5 then
				BehaviorFunctions.SetPathFollowEntity(self.guard2,self.audio)
				BehaviorFunctions.DoLookAtTargetImmediately(self.guard2,self.audio)
				if BehaviorFunctions.GetEntityState(self.guard2) ~= FightEnum.EntityState.Move then
					BehaviorFunctions.DoSetEntityState(self.guard2,FightEnum.EntityState.Move)
					--BehaviorFunctions.DoSetMoveType(self.guard2,FightEnum.EntityMoveSubState.Walk)
				end
			else
				if not self.dance then
					BehaviorFunctions.StopMove(self.guard2)
					BehaviorFunctions.ClearPathFinding(self.guard2)
					BehaviorFunctions.DoLookAtTargetImmediately(self.guard2,self.audio)
					BehaviorFunctions.PlayAnimation(self.guard2,"Exercise1")
					self.dance = true
				end
			end
		end
		
		--给小电脑2上锁
		self:LockComputer(self.computer2)
		
		--目标tip
		BehaviorFunctions.ChangeTitleTipsDesc(20305135,self.fileNum)
		self.goal1 = BehaviorFunctions.GetEntityValue(self.computer1,"GetFile")
		self.goal2 = BehaviorFunctions.GetEntityValue(self.computer2,"GetFile")
		if self.goal1 and self.goal2 and not self.success then
			BehaviorFunctions.ChangeTitleTipsDesc(20305135,self.fileNum)
			self.fileNum = 2
			BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
			BehaviorFunctions.HideTip(20305135)
			self.success = true
		elseif self.goal1 or self.goal2 and not self.half then
			self.fileNum = 1
			self.half = true
			--BehaviorFunctions.StartStoryDialog(601012201)--旁白，等旁白功能ok以后加上
		end
		
		----管理通风管解锁开启
		--if self.TFKZ then
			--self.isOpen = BehaviorFunctions.GetEntityValue(self.TFKZ,"isOpen")
			--if self.isOpen == true then
				--BehaviorFunctions.SetEntityValue(self.TFK2,"isOpen",true)
			--end
		--end
	end
end

--肉鸽追踪
function LevelBehavior2070101:RogueGuidePointer(guidePos,guideDistance,guideType)
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
function LevelBehavior2070101:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			self.levelFlagInteractionId = BehaviorFunctions.WorldInteractActive(self.levelFlag,WorldEnum.InteractType.Talk,nil,"开始挑战",1)
		end
	end
end

--退出实体范围
function LevelBehavior2070101:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if roleInstanceId == self.role then
		if triggerInstanceId == self.levelFlag then
			BehaviorFunctions.WorldInteractRemove(self.levelFlag,self.levelFlagInteractionId)
		end
	end
end

--实体按钮交互
function LevelBehavior2070101:WorldInteractClick(uniqueId,instanceId)
	if uniqueId == self.levelFlagInteractionId and instanceId == self.levelFlag then
		self.missionState = 0
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
end	
	


--检查电脑有没有被看管
function LevelBehavior2070101:ComputerByGuard(computerId,guardId)
	local distance = BehaviorFunctions.GetDistanceFromTarget(computerId,guardId)
	if distance < 3 then
		BehaviorFunctions.SetEntityValue(computerId,"isGuard",true)
	else
		BehaviorFunctions.SetEntityValue(computerId,"isGuard",false)
	end
end

--给电脑上锁
function LevelBehavior2070101:LockComputer(computerId)
	if ( not self.computerLock) and computerId then
		--BehaviorFunctions.SetEntityValue(computerId,"isLock",true)
		self.computerLock = false
	end
end


function LevelBehavior2070101:StoryPassEvent(dialogId)
	
	--罗睺开门杀
	if dialogId == 601012101 and not self.inCloseUp then
		--进对话时角色转身
		BehaviorFunctions.DoLookAtTargetImmediately(self.guard1,self.role)
		self.inCloseUp = true
		--选项怼脸镜头（StoryPassEvent会重复进所以要加开关）
		--怼脸特写
		--设置关卡相机
		--self.lookupCamera = BehaviorFunctions.CreateEntity(22006)
		--BehaviorFunctions.CameraEntityFollowTarget(self.lookupCamera,self.guard1,"CloseUpFollow1")
		--BehaviorFunctions.CameraEntityLockTarget(self.lookupCamera,self.guard1,"CloseUpLookat1")

	end
	--播动作
	if dialogId == 601012102 then
		if not self.Alert then
			--BehaviorFunctions.CameraEntityFollowTarget(self.lookupCamera,self.guard1,"CloseUpFollow2")
			--BehaviorFunctions.CameraEntityLockTarget(self.lookupCamera,self.guard1,"CloseUpLookat2")
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

function LevelBehavior2070101:StoryEndEvent(dialogId)
	if dialogId == 601012101 then
		--BehaviorFunctions.RemoveEntity(self.lookupCamera)
		BehaviorFunctions.SetEntityValue(self.door,"lock",true)
		
	elseif dialogId == 601012001 then
		BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"但愿这位年轻人靠谱点...",999999)
		--目标tips
		BehaviorFunctions.ShowTip(20305135,0)
		BehaviorFunctions.ChangeTitleTipsDesc(20305135,self.fileNum)
	end
	
end


function LevelBehavior2070101:Death(instanceId,isFormationRevive)
	if instanceId == self.guard2 then
		if self.guard2 then
			self.guard2 = nil
		end
	end
end

--重置关卡
function LevelBehavior2070101:Remark()
end


function LevelBehavior2070101:HackingClickUp(instanceId)
	if instanceId == self.cameraList[4].Id then
		BehaviorFunctions.DoHackInputKey(self.cameraList[1].Id,FightEnum.KeyEvent.HackUpButton , FightEnum.KeyInputStatus.Down)
	end
end