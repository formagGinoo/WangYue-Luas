LevelBehavior32000001 = BaseClass("LevelBehavior32000001")

--创建一个npc
function LevelBehavior32000001.GetGenerates()
	local generates = {900040,910040}
	return generates
end

function LevelBehavior32000001:__init(fight)
	self.fight = fight
end


function LevelBehavior32000001:Init()
	
	self.role = nil
	
	self.missionState = 0
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}

	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb1",entityId = 900040},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb3",entityId = 900040},
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb4",entityId = 900040},
		[4] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "mb2",entityId = 910040},
	}
	
	self.waveList =
	{
		[1] = {1},
		[2] = {2,3},
		[3] = {4}
	}
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}

	self.dialogList =
	{
		--提醒叙慕放新技能
		[1] = {Id = 102051001,state = self.dialogStateEnum.NotPlaying},
		--进入空洞打怪中途
		[2] = {Id = 102260801,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.weakGuide =
	{
		[1] = {Id = 2101,state = false,Describe ="使用技能积攒炎印",count = 0},
		[2] = {Id = 2102,state = false,Describe ="炎印的累计数量会显示在这里",count = 0},
		[3] = {Id = 2103,state = false,Describe ="长按普攻，释放信念技",count = 0},
		[4] = {Id = 2104,state = false,Describe ="获得的炎印会显示在这里",count = 0},
	}
	
	self.levelCamInfo = {}
	
	--核心被动开启记录
	self.coreSkillFinish = false
	
	--不使用小技能的时间计数
	self.skillNotUseFrame = nil
	self.skillNotUseLimitTime = 6
	
	--不使用核心技能的时间计数
	self.coreNotUseFrame = nil
	self.coreNotUseLimitTime = 6
	self.isFristTimeUseCore = false
	
	self.levelCam = nil
	self.empty = nil
	
	self.InteractionSwitch = false
	self.levelFinishInteractID = nil
	self.finishGuide = nil
	
	self.tipsGuide = false
	self.flameSignGuide = false
	
	self.monsterDieCount = 0
	
	self.wave2DelayCall = nil
	
	self.time = 0
end


function LevelBehavior32000001:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	--炎印弱指引逻辑
	if self.flameSignGuide == false and self.coreSkillFinish == true then
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204) >= 1 then
			BehaviorFunctions.SetCoreUIPosition(self.role,-120,10,true)
			self:WeakGuide(self.weakGuide[4].Id)
			self.flameSignGuide = true
			BehaviorFunctions.AddDelayCallByFrame(220,BehaviorFunctions,BehaviorFunctions.SetCoreUIPosition,self.role,-120,10,false)
		end
	end
	
	--自动回血保底
	local playerLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
	if playerLifeRatio <= 2000 then
		--回血magic
		BehaviorFunctions.DoMagic(self.role,self.role,200000014)
	end
	
	if self.missionState == 0 then
		BehaviorFunctions.AddDelayCallByFrame(60,self,self.Assignment,"missionState",0.11)
		self.missionState = 0.1
	end
	
	if self.missionState == 0.11 then
		--替换玩家队伍1号位为青乌
		self:ForceSwitchRoleCharacter(1001001)
		--副本Bgm
		BehaviorFunctions.SetActiveBGM("FALSE")
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.PlayBgmSound("Memory")
		
		BehaviorFunctions.SetTipsGuideState(false)--隐藏任务追踪
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		BehaviorFunctions.SetFightMainNodeVisible(2,"RoleGroup",false) --隐藏换人
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",false) --仲魔
		BehaviorFunctions.SetFightMainNodeVisible(2,"RightTop",false) --系统四件套
		--关闭玩家输入
		self:DisablePlayerInput(true,true)
		--玩家初始点位设置
		local bornPos = BehaviorFunctions.GetTerrainPositionP("pb1",self.levelId)
		BehaviorFunctions.InMapTransport(bornPos.x,bornPos.y,bornPos.z)
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.AddDelayCallByFrame(60,self,self.Assignment,"missionState",0.15)
		self.missionState = 0.12
		
	--走到第二个点停下
	elseif self.missionState == 0.15 then
		BehaviorFunctions.ShowBlackCurtain(false,0.2)
		--if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Idle  then
			--玩家看向场景中心
			self:LevelLookAtPos("center",22002,-1)
			BehaviorFunctions.DoSetMoveType(self.role,FightEnum.EntityMoveSubState.Walk)
			self.missionState = 0.2
		--end
		
	elseif self.missionState == 0.2 then
		local playerPos = BehaviorFunctions.GetPositionP(self.role)
		local targetPos = BehaviorFunctions.GetTerrainPositionP("center",self.levelId)
		if BehaviorFunctions.GetDistanceFromPos(playerPos,targetPos) <= 16.7 then
			BehaviorFunctions.DoSetMoveType(self.role,FightEnum.EntityMoveSubState.WalkEnd)
			self.missionState = 1
		else
			if BehaviorFunctions.GetSubMoveState(self.role) ~= FightEnum.EntityMoveSubState.Walk then
				local targetPos = BehaviorFunctions.GetTerrainPositionP("pb1",self.levelId)
				BehaviorFunctions.DoLookAtPositionImmediately(self.role,targetPos.x,targetPos.y,targetPos.z)
				BehaviorFunctions.DoSetMoveType(self.role,FightEnum.EntityMoveSubState.Walk)
			end
		end
		
	elseif self.missionState == 1 then
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.PlayBackGroundText,20000101)
		BehaviorFunctions.AddBuff(self.role,self.role,200000002)--角色锁血
		self.missionState = 2
		
	elseif self.missionState == 3 then
		--创造小怪
		self:CreatMonster(1)
		--停止行为树
		BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[1].Id,900000012)
		--怪物停止攻击
		BehaviorFunctions.SetEntityValue(self.monsterList[1].Id,"skillList",{})
		BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[1].Id,self.role)
		self.missionState = 4

	elseif self.missionState == 4 then	
		BehaviorFunctions.ShowCommonTitle(4,"核心被动挑战",true)
		--BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.ShowCommonTitle,4,"核心被动挑战",true)
		BehaviorFunctions.AddDelayCallByFrame(120,self,self.Assignment,"missionState",6)
		--BehaviorFunctions.AddDelayCallByFrame(50,BehaviorFunctions,BehaviorFunctions.PlayBackGroundText,1)
		--BehaviorFunctions.PlayBackGroundText(1)
		--BehaviorFunctions.ShowCommonTitle(1,"试炼之间",false)
		self.missionState = 5
	
	elseif self.missionState == 6 then
		----显示敌人剩余计数
		--BehaviorFunctions.ShowTopTarget(32000001)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		----更新关卡目标：击败敌人和特殊规则
		--BehaviorFunctions.ShowTip(32000001,0)
		--设置玩家能量条
		BehaviorFunctions.SetEntityAttr(self.role,1201,0)
		--打开核心UI
		BehaviorFunctions.SetCoreUIEnable(self.role,true)
		--开启玩家输入
		self:DisablePlayerInput(false,false)
		self:RemoveLevelCam(self.levelCam)
		if BehaviorFunctions.HasBuffKind(self.monsterList[1].Id,900000012) then
			BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveBuff,self.monsterList[1].Id,900000012)
		end
		self.missionState = 7
		
	elseif self.missionState == 8 then
		
		--如果释放过了核心被动
		if self.coreSkillFinish == true and self.flameSignGuide == true and self.tipsGuide == false then
			--更新关卡目标：击败敌人和特殊规则
			BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.ShowTip,32000001,0)
			--BehaviorFunctions.ShowTip(32000001,0)
			self.tipsGuide = true
		end
		
		----炎印弱指引逻辑
		--if self.flameSignGuide == false and self.coreSkillFinish == true then
			--if BehaviorFunctions.GetEntityAttrVal(self.role,1204) >= 1 then
				--BehaviorFunctions.SetCoreUIPosition(self.role,-120,10,true)
				--self:WeakGuide(self.weakGuide[4].Id)
				--self.flameSignGuide = true
				--BehaviorFunctions.AddDelayCallByFrame(220,BehaviorFunctions,BehaviorFunctions.SetCoreUIPosition,self.role,-120,10,false)
			--end
		--end

		--核心被动点数不够的时候提示通过技能获取能量
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204) < 3 then	
			--提示玩家可以通过小技能获取核心被动能量
			if self.weakGuide[1].state ~= true then
				if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201) >= 6667 then
					self:WeakGuide(self.weakGuide[1].Id)
					self.skillNotUseFrame = nil
				end
			else
				--小技能满足释放后如果很长时间没有使用则
				if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201) >= 6667 then
					if self.skillNotUseFrame == nil then
						self.skillNotUseFrame = self.time + self.skillNotUseLimitTime * 30
					else
						if self.time >= self.skillNotUseFrame and self.weakGuide[1].state == true then
							self.weakGuide[1].state = false
						end
					end
				end
			end		
			
			self:EnergyRestore(5)
		end
		
		--检查核心被动能量是否足够
		if self.weakGuide[3].state ~= true then
			--检查核心被动能量是否足够
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204) == 3 then
				self:WeakGuide(self.weakGuide[3].Id)
				self.coreNotUseFrame = nil
			end
		else
			--小技能满足释放后如果很长时间没有使用则
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204) == 3 then
				if self.coreNotUseFrame == nil then
					self.coreNotUseFrame = self.time + self.coreNotUseLimitTime * 30
				else
					if self.time >= self.coreNotUseFrame and self.weakGuide[3].state == true then
						BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
						self.weakGuide[3].state = false
					end
				end
			end
		end
		
	elseif self.missionState == 9 then
		--炎印和信念技教学
		BehaviorFunctions.ShowGuideImageTips(20023)
		self.wave2DelayCall = BehaviorFunctions.AddDelayCallByFrame(120,self,self.Assignment,"missionState",11)
		self.missionState = 10
		
	elseif self.missionState == 11 then
		self.coreNotUseFrame = nil
		self.skillNotUseFrame = nil
		BehaviorFunctions.SetTipsGuideState(false)--隐藏任务追踪
		BehaviorFunctions.HideTip()
		--创造小怪
		self:CreatMonster(3)
		BehaviorFunctions.AddDelayCallByFrame(40,self,self.CreatMonster,2)
		--展示怪物镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("wave2cam",self.levelId)
		self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
		local targetPos = BehaviorFunctions.GetTerrainPositionP("mb2",self.levelId)
		self.empty3 = BehaviorFunctions.CreateEntity(2001,nil,targetPos.x,targetPos.y,targetPos.z,nil,nil,nil,self.levelId)

		self.levelCam2 = BehaviorFunctions.CreateEntity(22005,nil,0,0,0,nil,nil,nil,self.levelId)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.empty2)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty3)
		
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty3)
		BehaviorFunctions.AddDelayCallByFrame(80,self,self.DisablePlayerInput,false,false)
		self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)

		--传送玩家到敌人面前
		local pos = BehaviorFunctions.GetTerrainPositionP("tp_wave2",self.levelId)
		BehaviorFunctions.DoSetPosition(self.role,pos.x,pos.y,pos.z)

		--禁用角色输入
		self:DisablePlayerInput(true,true)
		----显示敌人剩余计数
		--BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.ShowTopTarget,32000002)
		--更新关卡目标：击败敌人
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.ShowTip,32000002,0)
		self.missionState = 12
		
	elseif self.missionState == 12 then
		--核心被动点数不够的时候提示通过技能获取能量
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204) < 3 then
			--提示玩家可以通过小技能获取核心被动能量
			if self.weakGuide[1].state ~= true then
				if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201) >= 6667 then
					self:WeakGuide(self.weakGuide[1].Id)
					self.skillNotUseFrame = nil
				end
			else
				--小技能满足释放后如果很长时间没有使用则
				if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201) >= 6667 then
					if self.skillNotUseFrame == nil then
						self.skillNotUseFrame = self.time + self.skillNotUseLimitTime * 30
					else
						if self.time >= self.skillNotUseFrame and self.weakGuide[1].state == true then
							self.weakGuide[1].state = false
						end
					end
				end
			end

			self:EnergyRestore(5)
		end

		--检查核心被动能量是否足够
		if self.weakGuide[3].state ~= true then
			--检查核心被动能量是否足够
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204) == 3 then
				self:WeakGuide(self.weakGuide[3].Id)
				self.coreNotUseFrame = nil
			end
		else
			--小技能满足释放后如果很长时间没有使用则
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204) == 3 then
				if self.coreNotUseFrame == nil then
					self.coreNotUseFrame = self.time + self.coreNotUseLimitTime * 30
				else
					if self.time >= self.coreNotUseFrame and self.weakGuide[3].state == true then
						BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
						self.weakGuide[3].state = false
					end
				end
			end
		end

		--检查是否第二波敌人死亡
		local monsterList = self.waveList[2]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)
					--关闭所有引导
					self:RemoveWeakGuide()
					BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
					--BehaviorFunctions.AddDelayCallByFrame(60,self,self.Assignment,"missionState",13.5)
					self.missionState = 13
				end
			end
		end

	elseif self.missionState == 13.5 then
		self.coreNotUseFrame = nil
		self.skillNotUseFrame = nil
		BehaviorFunctions.HideTip()
		BehaviorFunctions.SetTipsGuideState(false)--隐藏任务追踪
		--创造精英从士
		self:CreatMonster(4)
		--BehaviorFunctions.AddDelayCallByFrame(30,self,self.CreatMonster,4)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.CastSkillBySelfPosition,self.monsterList[4].Id,91004091)
		--展示怪物镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("wave3cam",self.levelId)
		self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
		local targetPos = BehaviorFunctions.GetTerrainPositionP("mb2",self.levelId)
		self.empty3 = BehaviorFunctions.CreateEntity(2001,nil,targetPos.x,targetPos.y + 2,targetPos.z,nil,nil,nil,self.levelId)

		self.levelCam2 = BehaviorFunctions.CreateEntity(22005,nil,0,0,0,nil,nil,nil,self.levelId)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.empty2)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty3)

		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty3)
		BehaviorFunctions.AddDelayCallByFrame(80,self,self.DisablePlayerInput,false,false)
		self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)

		--传送玩家到敌人面前
		local pos = BehaviorFunctions.GetTerrainPositionP("tp_wave2",self.levelId)
		BehaviorFunctions.DoSetPosition(self.role,pos.x,pos.y,pos.z)
		
		--更新关卡目标：击败敌人
		BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.ShowTip,32000003,0)

		--禁用角色输入
		self:DisablePlayerInput(true,true)
		self.missionState = 14
		
	elseif self.missionState == 14 then
		--核心被动点数不够的时候提示通过技能获取能量
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204) < 3 then
			--提示玩家可以通过小技能获取核心被动能量
			if self.weakGuide[1].state ~= true then
				if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201) >= 6667 then
					self:WeakGuide(self.weakGuide[1].Id)
					self.skillNotUseFrame = nil
				end
			else
				--小技能满足释放后如果很长时间没有使用则
				if BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201) >= 6667 then
					if self.skillNotUseFrame == nil then
						self.skillNotUseFrame = self.time + self.skillNotUseLimitTime * 30
					else
						if self.time >= self.skillNotUseFrame and self.weakGuide[1].state == true then
							self.weakGuide[1].state = false
						end
					end
				end
			end

			self:EnergyRestore(5)
		end

		--检查核心被动能量是否足够
		if self.weakGuide[3].state ~= true then
			--检查核心被动能量是否足够
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204) == 3 then
				self:WeakGuide(self.weakGuide[3].Id)
				self.coreNotUseFrame = nil
			end
		else
			--小技能满足释放后如果很长时间没有使用则
			if BehaviorFunctions.GetEntityAttrVal(self.role,1204) == 3 then
				if self.coreNotUseFrame == nil then
					self.coreNotUseFrame = self.time + self.coreNotUseLimitTime * 30
				else
					if self.time >= self.coreNotUseFrame and self.weakGuide[3].state == true then
						BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
						self.weakGuide[3].state = false
					end
				end
			end
		end

		--检查是否第三波敌人死亡
		local monsterList = self.waveList[3]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)
					--关闭所有引导
					self:RemoveWeakGuide()
					self.missionState = 15
				end
			end
		end
		
		
	elseif self.missionState == 15 then
		BehaviorFunctions.RemoveBuff(self.role,200000002)--移除角色锁血
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0.5)
		local bornPos = BehaviorFunctions.GetTerrainPositionP("mb1",self.levelId)
		--BehaviorFunctions.InMapTransport(bornPos.x,bornPos.y,bornPos.z)
		BehaviorFunctions.AddDelayCallByFrame(15,BehaviorFunctions,BehaviorFunctions.InMapTransport,bornPos.x,bornPos.y,bornPos.z)
		BehaviorFunctions.AddDelayCallByTime(2,self,self.Assignment,"missionState",17)
		self.missionState = 16

		
	elseif self.missionState == 17 then
		BehaviorFunctions.ShowCommonTitle(5,"核心被动挑战",true)
		----炎印和信念技教学
		--BehaviorFunctions.ShowGuideImageTips(20023)
		--更新关卡目标：离开秘境
		BehaviorFunctions.ShowTip(32000004)
		--玩家看向场景中心
		local playerPos = BehaviorFunctions.GetPositionP(self.role)
		local targetPos = BehaviorFunctions.GetTerrainPositionP("center",self.levelId)
		if BehaviorFunctions.GetDistanceFromPos(playerPos,targetPos) >5 then
			self:LevelLookAtPos("center",22002,30)
		else
			self:LevelLookAtPos("center",22001,30,"CameraTarget")
		end
		local pos = BehaviorFunctions.GetTerrainPositionP("center",self.levelId)
		self.finishGuide = BehaviorFunctions.CreateEntity(200000108,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.finishGuide)
		self.missionState = 18
		
	elseif self.missionState == 999 then
		--关闭bgm
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.SetActiveBGM("TRUE")
		BehaviorFunctions.SetDuplicateResult(true)	
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",true) --仲魔
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",true) --显示地图
		BehaviorFunctions.SetFightMainNodeVisible(2,"RoleGroup",true) --恢复换人
		BehaviorFunctions.SetFightMainNodeVisible(2,"RightTop",true) --系统四件套
		BehaviorFunctions.HideTip()
		BehaviorFunctions.SetTipsGuideState(true)--显示任务追踪
		local hasTask = BehaviorFunctions.CheckTaskIsFinish(102050301)
		if not hasTask then
			--BehaviorFunctions.SendTaskProgress(102050301,1,1)
		end
		self.missionState = 1000
	end
end

function LevelBehavior32000001:EnergyRestore(time)
	local currentEnergy = BehaviorFunctions.GetEntityAttrVal(self.role,1201)
	local currentEnergyRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201) / 10000
	local maximaEnergyVal = currentEnergy / currentEnergyRatio
	--每帧回复多少
	local restoreEnergyPerFrame = maximaEnergyVal /( time*30)
	if currentEnergy < maximaEnergyVal then
		BehaviorFunctions.ChangeEntityAttr(self.role,1201,restoreEnergyPerFrame)
	end
end

function LevelBehavior32000001:CreatMonster(v)
	local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,self.levelId)
	local rot = BehaviorFunctions.GetTerrainRotationP(self.monsterList[v].bp,self.levelId)
	self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	self.monsterList[v].state = self.monsterStateEnum.Live
	BehaviorFunctions.SetEntityEuler(self.monsterList[v].Id,rot.x,rot.y,rot.z)
	--关闭警戒
	BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
	--设置脱战范围
	BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",500)
	--设置目标追踪范围
	BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",500)
end

function LevelBehavior32000001:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.monsterList[1].Id then
		BehaviorFunctions.ChangeTitleTipsDesc(32000001,1)
		self:RemoveWeakGuide()
		
	elseif dieInstanceId == self.monsterList[2].Id 
		or dieInstanceId == self.monsterList[3].Id then
		self.monsterDieCount = self.monsterDieCount + 1
		BehaviorFunctions.ChangeTitleTipsDesc(32000002,self.monsterDieCount)
		if self.monsterDieCount == #self.waveList[2] then
			BehaviorFunctions.TopTargetFinish(1,true)
		end
		
	elseif dieInstanceId == self.monsterList[4].Id then
		BehaviorFunctions.ChangeTitleTipsDesc(32000003,1)
		self:RemoveWeakGuide()
	end
end

--死亡事件
function LevelBehavior32000001:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		--关闭bgm
		BehaviorFunctions.StopBgmSound()
		BehaviorFunctions.SetActiveBGM("TRUE")
		BehaviorFunctions.SetDuplicateResult(false)
	end
	if instanceId == self.monsterList[1].Id then
		self.missionState = 9
	end
	for i,v in ipairs(self.monsterList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
		end
	end
end

--赋值
function LevelBehavior32000001:Assignment(variable,value)
	self[variable] = value
end

--关卡相机看向地点
function LevelBehavior32000001:LevelLookAtPos(pos,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	self.levelCam = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	if frame > 0 then
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam, false)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	end
	return self.levelCam
end

--关卡相机看向目标
function LevelBehavior32000001:LevelLookAtTarget(target,type,frame,bindTransform,targetTransform)
	self.levelCam = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,target)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	if targetTransform then
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,target,targetTransform)
	else
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,target)
	end
	if frame > 0 then
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	end
	return self.levelCam
end

--当前关卡相机更换目标地点
function LevelBehavior32000001:LevelCamChangeTargetPos(camera,pos)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId)
	local empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	BehaviorFunctions.CameraEntityLockTarget(camera,empty)
end

--移除当前关卡相机
function LevelBehavior32000001:RemoveLevelCam(camera)
	BehaviorFunctions.RemoveEntity(camera)
	BehaviorFunctions.RemoveEntity(self.empty)
end


function LevelBehavior32000001:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function LevelBehavior32000001:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then			
			if dialogId == self.dialogList[1].Id then
				if self.isFristTimeUseCore == false then
					--设置玩家核心被动能量
					BehaviorFunctions.SetEntityAttr(self.role,1204,3)
					self.isFristTimeUseCore = true
				end
				if self.missionState == 7 then
					self.missionState = 8
				end
			elseif dialogId == self.dialogList[2].Id then
				self.missionState = 13.5
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior32000001:StoryPassEvent(dialogId)
	if dialogId == 102050304 then
		--创造小怪
		self:CreatMonster(1)
		--停止行为树
		BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[1].Id,900000012)
		--怪物停止攻击
		BehaviorFunctions.SetEntityValue(self.monsterList[1].Id,"skillList",{})
	end
end

--图片引导开启/关闭检测
function LevelBehavior32000001:OnGuideImageTips(tipsId,isOpen)
	if tipsId == 20023 and isOpen == false then
		BehaviorFunctions.ResetDelayCallByFrame(self.wave2DelayCall,30)
		--BehaviorFunctions.AddDelayCallByFrame(90,self,self.Assignment,"missionState",11)
	end
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior32000001:WeakGuide(guideId)
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
function LevelBehavior32000001:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function LevelBehavior32000001:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
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

--释放技能
function LevelBehavior32000001:CastSkill(instanceId,skillId,skillSign,skillType)
	if instanceId == self.role and self.coreSkillFinish == false and skillId == 1001044 then
		self:RemoveWeakGuide()
		self.coreSkillFinish = true
	end
	
	if skillId == 1001044 then
		self.coreNotUseFrame = nil
	end
	
	if skillId == 1001010
	or skillId == 1001011 
	or skillId == 1001012 then
		self.skillNotUseFrame = nil
	end
end

--受击
function LevelBehavior32000001:Collide(attackInstanceId,hitInstanceId)
	--不是核心被动的情况下无法受到伤害
	if attackInstanceId == self.role then
		local skillId = BehaviorFunctions.GetSkill(self.role)
		if skillId == 1001044 then
			BehaviorFunctions.RemoveBuff(hitInstanceId,900000023)
		else
			BehaviorFunctions.DoMagic(self.role,hitInstanceId,900000023)
		end
	end
end

--造成伤害
function LevelBehavior32000001:Damage(InstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal,attackType,partType,damageInfo,attackInstanceId,isCirt)
	if self.missionState >= 12 then
		if magicId == 1001040
		or magicId == 1001041 then
			local totalLife = BehaviorFunctions.GetEntityAttrVal(hitInstanceId,1) --获取生命最大值
		--造成额外10%最大生命值伤害
			BehaviorFunctions.ChangeEntityAttr(hitInstanceId,1001,-(totalLife*0.1))
		end
	end
end

function LevelBehavior32000001:WorldInteractClick(uniqueId)
	if uniqueId == self.levelFinishInteractID then
		BehaviorFunctions.WorldInteractRemove(self.finishGuide,self.levelFinishInteractID)
		self.missionState = 999
		self.InteractionSwitch = false
	end
end

function LevelBehavior32000001:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.finishGuide and self.InteractionSwitch == false then
		self.levelFinishInteractID = BehaviorFunctions.WorldInteractActive(self.finishGuide,WorldEnum.InteractType.Talk,nil,"退出副本",1)
		self.InteractionSwitch = true
	end
end

function LevelBehavior32000001:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId == self.finishGuide and self.InteractionSwitch == true then
		BehaviorFunctions.WorldInteractRemove(self.finishGuide,self.levelFinishInteractID)
		self.InteractionSwitch = false
	end
end

function LevelBehavior32000001:BackGroundEnd(GroupID)
	if GroupID == 20000101 then
		self.missionState = 3
	end
end

function LevelBehavior32000001:ForceSwitchRoleCharacter(RoleEntityID)
	--替换玩家队伍1号位为目标
	local currentFormation = BehaviorFunctions.GetCurFormationRoleList()--获取当前队伍人物
	local targetFormation = TableUtils.CopyTable(currentFormation)	
	
	for i,v in ipairs(targetFormation.roleList) do
		if v == RoleEntityID then
			local currentRole = BehaviorFunctions.GetCtrlEntity()
			if BehaviorFunctions.GetEntityTemplateId(currentRole) + 1000000 ~= RoleEntityID then
				local curFormationIns = BehaviorFunctions.GetCurFormationEntities()
				for i2,v2 in ipairs(curFormationIns) do
					local entityID = BehaviorFunctions.GetEntityTemplateId(v2)
					if entityID + 1000000 == RoleEntityID then
						BehaviorFunctions.CallBehaviorFuncByEntityEx(Behavior1000001,"ChangeRole",1,currentRole,v2)
						break
					end
				end
			end
			break
		end
	end
end









