LevelBehavior302040802 = BaseClass("LevelBehavior302040802",LevelBehaviorBase)

function LevelBehavior302040802:__init(fight)
	self.fight = fight
	self.rogueData = nil --------rogue事件数据集
	self.roguePosName = nil -----rogue生成点位名称

	----肉鸽关卡开启参数--------------------------------------------------------------------------------------------------------------------------------
	self.missionStartDis = 30 ---挑战开始距离
	self.missionStartPos = nil --挑战开始位置
	self.missionCreate = false --检查关卡是否加载
	self.missionDistance = nil --操作角色与挑战关卡的距离
	-- self.eventId = nil ----------rogue事件ID
	self.missionUnloadDis = 90 --肉鸽玩法未开始的卸载距离
	self.unloaded = false

	------追踪标--------------------------------------------------------------------------------------------------------
	self.guideEmptyEntityId = 2041101		--追中图标用空实体
	self.guide = nil
	self.guideEntity = nil
	self.guideDistance = 40
	self.guidePos = nil
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
		Attacking = FightEnum.GuideType.Map_Attacking,
	}
	--怪物死亡数量
	self.monsterDead  = 0

	--对话
	self.EndDialogId = 602190101
end

function LevelBehavior302040802.GetGenerates()
	local generates = {790012000,2041101,808011001}
	return generates
end

function LevelBehavior302040802.GetMagics()
	local generates = {}
	return generates
end

function LevelBehavior302040802:Init()
	--肉鸽事件信息获取
	-- self.eventId = self.rogueEventId
	-- self.rogueData = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
	-- self.roguePosName = self.rogueData.position

	----可修改参数 ↓-----
	self.npcid = 808011001
	self.monsterentityid = 790012000
	self.mapname = Logic_Level302040801
	self.mappositionid = 302040802
	self.wave = 1                        --总波次
	----可修改参数 ↑-----

	self.me = self.instanceId
	self.role = nil
	self.dialog = 601010701
	self.Over = false
	self.dieCount = 0
	self.allDie = false
	self.challengeSuccece = nil
	self.npcState = 0
	self.npcEntity = nil
	self.animation = false
	self.aniId =nil
	self.aniTime = 0
	self.aniFrame = 0
	self.npchelpBob = 0
	self.choose = nil
	self.helpTime = 0				--npc救命时间
	self.createnpc = 0				--是否创建NPC
	self.npcend = false
	self.npchurt = false
	self.deathCount = 0           --死亡计数
	self.currentWaveLookAtPos = nil       --当前波次关卡相机朝向点
	self.currentWave = 1          --当前波次
	self.currentWaveNum = 0       --当前波次怪物总数
	self.isWarn = true                    --是否开启警戒
	self.transPos = nil                   --设置玩家位置
	self.imageTipId = nil                 --图文教学
	self.guidecamera = false				--指引镜头
	self.range = 0							--玩家和事件距离,1近距离,2中距离,3远距离
	self.tipsstate = false					--城市威胁tips是否发送
	self.npcSquat = 0						--npc是否下蹲
	self.missionFinished = false			--判断是否进入战斗区域
	self.playerPos = nil					--玩家当前位置
	self.npcvictory = false
	self.npcidlist = {
		[1] = {entityId = self.npcid}		--npc信息
	}
	self.npc01 = nil

	self.ShowCommonTitleDis = 70	--城市威胁提示

	--tips
	self.showTipsCheck = false

	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monsterList = {
		--第一波
		[1] = {instanceId = nil , state = self.monsterStateEnum.Default ,posName = "monster1" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid ,patrolList = {"monster1","monster1return"}},  --1猎手
		[2] = {instanceId = nil , state = self.monsterStateEnum.Default ,posName = "monster2" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid ,patrolList = {"monster2","monster2return"}},  --1猎手
		[3] = {instanceId = nil , state = self.monsterStateEnum.Default ,posName = "monster3" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid ,patrolList = {"monster3","monster3return"}},  --1猎手
	}
	self.missionState = 0
	self.missionCreate = false
	self.monPatrolCheck = false

	self.RemoveFire = false
	self.levelWin = false

	self.timeAddCheck = false
	self.timeCheck = false
	self.timeAdd = 0

	--延时调用
	self.delayCallList = {}
	--当前延时数量
	self.currentdelayCallNum = 0

	self.combatTips = 102670127
	self.combatTipsId = false
	self.updatecombTips = 0
	self.AllcombTips = 3
	self.PlayerNpcDistance = false
	self.checkNpcdialog = false

	--通用行为树
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self) --创建关卡通用行为树
	self.LevelCommon.levelId = self.levelId --将关卡ID赋值给关卡通用行为树
	self.monCamera = nil
end

function LevelBehavior302040802:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetFightFrame()
	self.realtime = BehaviorFunctions.GetFightFrame()/30
	self.missionStartPos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)	--关卡坐标点

	--创建追中图标
	if self.missionState ~= 999 then
		self:GuidePointer(self.missionStartPos,self.guideDistance,self.missionStartDis,self.GuideTypeEnum.Attacking)	--调用关卡追踪标 函数
	end

	if self.playerPos == nil then
		self.playerPos = BehaviorFunctions.GetPositionP(self.role)										--获取玩家的坐标
	end
	self.missionDistance = BehaviorFunctions.GetDistanceFromPos(self.playerPos,self.missionStartPos)		--获取玩家和肉鸽的距离
	if self.missionCreate == false then			--判断关卡是否加载
		--关卡追踪标				--关卡追踪标和追踪标函数是通用写法
		if self.guidePos == nil then
			local pos = BehaviorFunctions.GetTerrainPositionP("TreasureBox",self.levelId,self.logicName)		--获取肉鸽和玩家的距离

			self:RogueGuidePointer(pos,self.guideDistance,self.GuideTypeEnum.Attacking)											--调用关卡追踪标 函数
			self.missionCreate = true
		else
			if self.rogueEventId then
				self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
			end
		end
	end

	--近距离
	if self.missionDistance <= self.missionStartDis then	--玩家距离 < 30
		--玩家在小范围内，开启tips
		if self.tipsstate == false then
			self.combatTipsId = BehaviorFunctions.AddLevelTips(self.combatTips,self.levelId)
			BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,1,self.deathCount, #self.monsterList)
			self.tipsstate = true
		end
	end

	--城市威胁提示
	if self.missionDistance <= self.ShowCommonTitleDis then
		if self.showTipsCheck == false then
			BehaviorFunctions.ShowCommonTitle(7,"发现城市威胁",true)
			self.showTipsCheck = true
		end
	end

	--如果距离超出则卸载距离
	if self.missionDistance >= self.missionUnloadDis and self.unloaded == false then				--玩家距离 < 90, self.missionUnloadDis是init里面自定义的数值60
		-- self:Leave()
		self.unloaded = true
	end

	--根据感谢对话和胜利条件播放结算内容
	if self.npcend == true and self.missionState ~= 999 then
		if self.timeAddCheck == false then
			self.timeAdd =  self.time
			self.timeAddCheck = true
		end
		if self.time >= (self.timeAdd + 1) and self.time < (self.timeAdd + 30) then
			if self.levelWin == false then
				BehaviorFunctions.ShowBlackCurtain(true,0.5)	--黑幕
				self.levelWin = true
			end
		end
		if self.time >= (self.timeAdd + 30) and self.time < (self.timeAdd + 35) then
			if self.RemoveFire == false then
				self:DisablePlayerInput(false,false)
				self:Leave()
				BehaviorFunctions.ShowBlackCurtain(false,0.5)	--黑幕
				BehaviorFunctions.FinishLevel(self.levelId)
				self.missionState = 999
				self.RemoveFire = true
			end
		end
	end

	if self.missionCreate == true then
		if self.missionState == 0 then
			--开场自定义功能
			if self.createnpc == 0 then
				if self.npcSquat == 0 then
					local npcpos = BehaviorFunctions.GetTerrainPositionP("Npc",self.mappositionid)
					self.npc01 =  BehaviorFunctions.CreateEntity(self.npcid,nil,npcpos.x,npcpos.y,npcpos.z, nil, nil, nil, self.levelId)
					BehaviorFunctions.fight.clientFight.headInfoManager:CreateHeadInfoObj(self.npc01)
					if self.npcSquat == 0 then
						BehaviorFunctions.PlayAnimation(self.npc01,"Squat_loop")
						BehaviorFunctions.SetPartEnableHit(self.npc01, "Body", false)
							self.npcSquat = 1
					end
					self.createnpc = 1
				end
			end
			--self:CustomLevelFunctions()
			self.missionState = 1
			--第一波刷怪
		elseif self.missionState == 1 then
			self:CreateMonster(self.currentWave)
			self.missionState = 2
			--判断是否还有波次
		elseif self.missionState == self.currentWave + 1 then
			--当前波怪物全死时
			if self.currentWaveAllDie == true then
				--如果仍有后续波次
				if self.wave > self.currentWave then
					self.currentWave = self.currentWave + 1
					self.currentWaveAllDie = false
					--成功击杀所有怪
				elseif self.wave == self.currentWave then
				end
			end
			--后续波次刷怪
		elseif self.missionState == self.currentWave and self.missionState ~= 1 then
			self:CreateMonster(self.currentWave)
		end
	end

	if self.missionState ~= 999 then

		for i, v in ipairs(self.monsterList) do			--怪物在场时，Npc求救
			if v.instanceId ~= nil then
				if 	self.monPatrolCheck == false then
					self:MonsterPatrol(self.monsterList)
					self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowLevelEnemy,self.levelId, true)
					self:AddLevelDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowMapArea,self.levelId, true)
					--Npc气泡对话
					BehaviorFunctions.ChangeNpcBubbleContent(self.npc01,"救命！谁来帮帮我！",999999)
					BehaviorFunctions.SetNonNpcBubbleVisible(self.npc01,true)
					self.monPatrolCheck = true
				end
			end
		end
	end

	--怪物死亡重置玩家位置点
	if self.deathCount == self.AllcombTips then
		if self.npcvictory == false then
			--胜利行为
			if self.combatTipsId ~= nil then
				BehaviorFunctions.ChangeLevelSubTipsState(self.combatTipsId,1,true)
			end
			self:DisablePlayerInput(true,true)
			BehaviorFunctions.SetNonNpcBubbleVisible(self.npc01,false)
			BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
			BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
			self.npcvictory = true
		end
		if self.PlayerNpcDistance == false then
			local player = BehaviorFunctions.GetPositionP(self.role)
			local NpcPos = BehaviorFunctions.GetTerrainPositionP("Npc",self.levelId,self.logicName)
			local playerPos = BehaviorFunctions.GetTerrainPositionP("Player",self.levelId,self.logicName)
			BehaviorFunctions.InMapTransport(playerPos.x, playerPos.y, playerPos.z, false)
			self.PlayerNpcDistance = true
		end

		if self.PlayerNpcDistance == true then
			if self.checkNpcdialog == false then
				self:LevelLookAtPos("Npclook",self.mapname,22002,nil,0,0)
				BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.npc01)
				--移除恐惧表演
				BehaviorFunctions.PlayAnimation(self.npc01,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
				--播对话
				BehaviorFunctions.DoLookAtTargetImmediately(self.npc01,self.role)
				BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,self.EndDialogId)
				self.checkNpcdialog = true
			end
		end
	end

end

function LevelBehavior302040802:__delete()
end

---------------------回调----------------------------------
--结尾对话播放完毕
function LevelBehavior302040802:StoryEndEvent(dialogId)
	if dialogId == self.EndDialogId then
		self.npcend = true
	end
end

--死亡回调
function LevelBehavior302040802:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		self:Fail()
	end
	for i, v in pairs(self.monsterList) do
		if instanceId == v.instanceId and v.isDead == false then
			self.deathCount = self.deathCount + 1
			v.isDead = true
			BehaviorFunctions.ChangeLevelSubTips(self.combatTipsId,1,self.deathCount, #self.monsterList)
		end
	end
end

-------------------------函数--------------------------------

--创怪函数
function LevelBehavior302040802:CreateMonster(wave)
	for i, v in pairs(self.monsterList) do
		--创该波的怪
		local pos = nil
		local rot = nil
		if v.wave == wave then
			--获取怪物位置信息，写成通用逻辑
			if self.logicName then
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.mapId, self.logicName)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.mapId, self.logicName)
			else
				pos = BehaviorFunctions.GetTerrainPositionP(v.posName, self.levelId)
				rot = BehaviorFunctions.GetTerrainRotationP(v.posName, self.levelId)
			end
			--创建怪物，从self.monsterList中获取信息
			v.instanceId = BehaviorFunctions.CreateEntity(v.entityId, nil, pos.x, pos.y, pos.z, nil, nil, nil, self.levelId)
			BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
			self.currentWaveNum = self.currentWaveNum + 1	--根据怪物列表的信息，记录创建怪物的数量
			--看向npc
			-- BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId, self.npc01)
			--如果要关闭警戒
			if not self.isWarn then
				BehaviorFunctions.SetEntityValue(v.instanceId,"haveWarn",false)   --关闭警戒
			end
		end
	end
	self.missionState = self.missionState + 1
	--self:SetLevelCamera()			肉鸽暂时不创建转向相机
end

--卸载内容
function LevelBehavior302040802:Leave()
	self:RemoveAllLevelDelayCall()
	-- BehaviorFunctions.HideTip(32000007)
	BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
	--移除相机
	BehaviorFunctions.RemoveEntity(self.levelCam)
	BehaviorFunctions.RemoveEntity(self.empty)
	--移除怪物
	if next(self.monsterList) ~= nil then
		for i,v in ipairs(self.monsterList) do
			if v.Id then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
	end
	self.monsterList = {
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "monster1" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "monster2" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,posName = "monster3" ,wave = 1 ,lev = 0 ,isDead = false ,entityId = self.monsterentityid},  --1猎手
	}
	self.dieCount = 0
	self.allDie = false
	self.missionState = 0
	self.Over = false
	self.animation = false
end

--设置攻击目标
function LevelBehavior302040802:ChangeTarget(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			if BehaviorFunctions.CheckEntity(self.npc01) then
				BehaviorFunctions.SetEntityValue(monsterList[i].Id,"battleTarget",self.npc01)
			end
		end
	end
end

--关卡胜利表现
function LevelBehavior302040802:Victory()
	-- if self.tipsstate == true then
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc01,false)
		BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
		BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		if self.PlayerNpcDistance == false then
			local player = BehaviorFunctions.GetPositionP(self.role)
			local NpcPos = BehaviorFunctions.GetTerrainPositionP("Npc",self.levelId,self.logicName)
			local playerPos = BehaviorFunctions.GetTerrainPositionP("Player",self.levelId,self.logicName)
			BehaviorFunctions.InMapTransport(playerPos.x, playerPos.y, playerPos.z, false)
			self.PlayerNpcDistance = true
		end
		if self.PlayerNpcDistance == true then
			self:LevelLookAtPos("Npclook",self.mapname,22002,nil,0,0)
			--移除恐惧表演
			BehaviorFunctions.PlayAnimation(self.npc01,"Squat_out",FightEnum.AnimationLayer.PerformLayer)
			--播对话
			BehaviorFunctions.DoLookAtTargetImmediately(self.npc01,self.role)
			BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,self.EndDialogId)
			self:DisablePlayerInput(true,true)
		end
	-- end
end

--关卡失败表现
function LevelBehavior302040802:Fail()
	-- BehaviorFunctions.HideTip(32000007) --隐藏敌人数量的tips
	BehaviorFunctions.RemoveLevelTips(self.combatTipsId)
	-- BehaviorFunctions.SetRoguelikeEventCompleteState(self.eventId,false)
	self.missionState = 999 --由于与后端有关，只告诉服务端一次就好
	self:Leave()
end

--任务前置肉鸽追踪指标，以封装函数，不管
function LevelBehavior302040802:RogueGuidePointer(guidePos,guideDistance,guideType)
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

--追踪指标
function LevelBehavior302040802:GuidePointer(guidePos,guideDistance,minDistance,guideType)
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,guidePos)
	if distance <= guideDistance and distance > minDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(self.guideEmptyEntityId,nil,guidePos.x,guidePos.y,guidePos.z,nil,nil,nil,self.levelId)
			self.guide =BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	elseif distance > guideDistance then
		--移除追踪标空实体
		if self.guideEntity ~= nil and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	elseif distance <= minDistance then
		--移除追踪标空实体
		if self.guideEntity ~= nil and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

--怪物巡逻
function LevelBehavior302040802:MonsterPatrol(monsterList)
	for i,v in ipairs (monsterList) do
		if v.instanceId ~= nil then
			if v.patrolList then
				local patrolPosList = {}
				for index,posName in ipairs(v.patrolList) do
					local pos = BehaviorFunctions.GetTerrainPositionP(posName,self.levelId,self.logicName)
					table.insert(patrolPosList,pos)
				end
				BehaviorFunctions.SetEntityValue(v.instanceId,"peaceState",1) --设置为巡逻
				BehaviorFunctions.SetEntityValue(v.instanceId,"patrolPositionList",patrolPosList)--传入巡逻列表
				BehaviorFunctions.SetEntityValue(v.instanceId,"canReturn",true)--往返设置
			end
		end
	end
end

--相机函数
function LevelBehavior302040802:LevelLookAtPos(pos,logic,type,bindTransform,blendInTime,blendOutTime)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId,logic)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	self.levelCam = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil,nil,nil,nil,self.level)
	--设置镜头过渡
	if blendInTime then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",blendInTime)
	end
	if blendOutTime then
		BehaviorFunctions.SetVCCameraBlend("LevelCamera","**ANY CAMERA**",blendOutTime)
	end
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
end

--屏蔽按键
function LevelBehavior302040802:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelBehavior302040802:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function LevelBehavior302040802:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end
