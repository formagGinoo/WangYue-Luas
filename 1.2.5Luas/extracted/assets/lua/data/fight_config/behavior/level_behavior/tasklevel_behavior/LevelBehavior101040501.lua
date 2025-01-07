LevelBehavior101040501 = BaseClass("LevelBehavior101040501",LevelBehaviorBase)
--击败三名从士
function LevelBehavior101040501:__init(fight)
	self.fight = fight
end

function LevelBehavior101040501.GetGenerates()
	local generates = {900040,2030202}
	return generates
end

function LevelBehavior101040501.GetStorys()
	local storys = {101040501}
	return storys
end


function LevelBehavior101040501:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	
	self.weakGuide =
	{
		[1] = {Id = 2011,state = false,Describe ="推动摇杆进行移动"},
		[2] = {Id = 2012,state = false,Describe ="长按进入跑步状态"},
		[3] = {Id = 2013,state = false,Describe ="连续点击2次跳跃可二段跳"},
		[4] = {Id = 2014,state = false,Describe ="长按在墙面上奔跑"},
		[5] = {Id = 2015,state = false,Describe ="点击按钮使用普通攻击"},
		[6] = {Id = 2016,state = false,Describe ="普攻积攒日相能量"},
		[7] = {Id = 2017,state = false,Describe ="消耗日相能量释放技能"},
		[8] = {Id = 2018,state = false,Describe ="点击按钮释放绝技"},
		[9] = {Id = 2019,state = false,Describe ="消耗日相能量释放技能"},
	}
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	
	self.dialogList =
	{
		[1] = {Id = 101040501,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010405Mb1",entityId = 900040},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010405Mb2",entityId = 900040},
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010405Mb3",entityId = 900040},
		[4] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010405Mb4",entityId = 900040},
	}
	
	self.waveList =
	{
		[1] = {4},
		[2] = {2,3}
	}
	
	self.monsterDead = 0
	
	self.time = 0
	self.timeStart = 0
	self.blockInf =
	{
		[1] = {Id = nil ,bp = "Task1010405Wall1",entityId = 2030202},
	}

	self.watchPos = "watchPosition2"
	
	self.juejiWeakGuide = false
	
	self.juejiImagGuide = false
	
	self.firstJueji = false
	
	self.imagTipsFinish = false
	
	self.value = nil
	
	self.guideSwitch = false
	
	self.firstJuejiEnd = false
end

function LevelBehavior101040501:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)
	
	--屏蔽核心被动
	if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
		BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
	end
	
	--if self.missionState == 0 then	
		----展示怪物镜头
		--local fp1 = BehaviorFunctions.GetTerrainPositionP("watchPosition3",10020001,"Logic10020001_6")
		--self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
		--local fp2 = BehaviorFunctions.GetTerrainPositionP("Task1010405Mb4",10020001,"Logic10020001_6")
		--self.empty3 = BehaviorFunctions.CreateEntity(2001,nil,fp2.x,fp2.y,fp2.z)
		
		--BehaviorFunctions.ShowBlackCurtain(true,0)
		
		--self.levelCam2 = BehaviorFunctions.CreateEntity(22005)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.empty2)
		--BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty3)
		----延迟移除目标和镜头
		--BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
		--BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
		--BehaviorFunctions.AddDelayCallByFrame(100,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty3)
		--self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)
		
		----传送玩家到敌人面前
		--local pos = BehaviorFunctions.GetTerrainPositionP("tp_101040501",10020001,"Logic10020001_6")
		--BehaviorFunctions.Transport(10020001,pos.x,pos.y,pos.z)

		----禁用角色输入
		--self:DisablePlayerInput(true,true)
		--self.missionState = 0.5
	--end
	
	--if self.missionState == 0.5 and self.time - self.timeStart == 20 then
		--BehaviorFunctions.ShowBlackCurtain(false,0)
	--end
	
	--if self.missionState == 0.5 and self.time - self.timeStart >= 25 then
		----创建花墙
		--self:CreateWall(self.blockInf)
		----替换关卡进度
		--BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		--BehaviorFunctions.ShowTip(101060801,0)
		----召唤战斗区域2的1只小怪
		--for i,v in ipairs (self.waveList[1]) do
			--local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,10020001,"Logic10020001_6")
			--self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z)
			--self.monsterList[v].state = self.monsterStateEnum.Live
			----BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
			----关闭警戒
			--BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
			----设置脱战范围
			--BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",100)
			----设置目标追踪范围
			--BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",100)
			------停止行为树
			----BehaviorFunctions.AddBuff(self.monsterList[v].Id,self.monsterList[v].Id,900000012)
			
			----威吓技能
			--BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.CastSkillBySelfPosition,self.monsterList[v].Id,90004005)
			--BehaviorFunctions.AddDelayCallByFrame(50,BehaviorFunctions,BehaviorFunctions.AddBuff,self.monsterList[v].Id,self.monsterList[v].Id,900000012)
			----显示元素条
			--BehaviorFunctions.ShowEntityLifeBarElementBar(self.monsterList[v].Id,true)
		--end
		
		----BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[4].Id,self.role)
		--local pos = BehaviorFunctions.GetTerrainPositionP("tp_101040501",10020001,"Logic10020001_6")
		--BehaviorFunctions.DoLookAtPositionImmediately(self.monsterList[4].Id,pos.x,pos.y,pos.z,true)
		--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		--self.dialogList[1].state = self.dialogStateEnum.Playing
		
		--self.missionState = 1
	--end
	
	--if self.missionState == 1 then
		--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.monsterList[4].Id)
	--end
	
	--if self.missionState == 1.5 then
		--if BehaviorFunctions.CheckEntity(self.levelCam2) then
			--BehaviorFunctions.RemoveEntity(self.levelCam2)
		--end
		------日相视频引导
		----BehaviorFunctions.ShowGuideImageTips(20021)
		----self.missionState = 1.7
		--self.missionState = 2
	--end
	
	----播放完第一段timeline
	--if self.missionState == 2 then
		----开启角色输入
		--self:DisablePlayerInput(false,false)
		----解除小怪的停止行为树
		--if BehaviorFunctions.HasBuffKind(self.monsterList[4].Id,900000012) then
			--BehaviorFunctions.RemoveBuff(self.monsterList[4].Id,900000012)
		--end
		----按键逻辑
		--BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能
		--BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --普攻
		--BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
		--BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --疾跑
		--BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
		--BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --核心被动条
		--BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",true,1)--隐藏能量条
		----补全玩家能量
		--local yellowPowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201)
		--if yellowPowerRatio < 7000 then
			--BehaviorFunctions.SetEntityAttr(self.role,1201,7000)
		--end
		----开启技能使用弱引导
		--self:WeakGuide(self.weakGuide[7].Id)
		----角色时停
		--BehaviorFunctions.AddBuff(self.role,self.role,200000008)
		--BehaviorFunctions.AddBuff(self.role,self.role,200000009)
		----怪物时停
		--for i,v in ipairs (self.waveList[1]) do
			--BehaviorFunctions.AddBuff(self.monsterList[v].Id,self.monsterList[v].Id,200000008)
			--BehaviorFunctions.AddBuff(self.monsterList[v].Id,self.monsterList[v].Id,200000009)
		--end	
		
		--self.missionState = 3
	--end
	
	----检查技能引导结束
	--if self.missionState == 3 then
		--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.NormalSkill) then
			----记录黄点能量值
			--local yellowPowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201)
			--self.value = yellowPowerRatio
			----解除按键显隐
			--BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --普攻
			--BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃
			--BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --疾跑
			----解除角色时停
			--BehaviorFunctions.RemoveBuff(self.role,200000008)
			--BehaviorFunctions.RemoveBuff(self.role,200000009)
			----解除怪物时停
			--for i,v in ipairs (self.waveList[1]) do
				--BehaviorFunctions.RemoveBuff(self.monsterList[v].Id,200000008)
				--BehaviorFunctions.RemoveBuff(self.monsterList[v].Id,200000009)
			--end
			--self.missionState = 4
		--end
	--end
	
	--if self.missionState == 4 then
		--local yellowPowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201)
		--if yellowPowerRatio < self.value then
			--self.missionState = 5
		--end
	--end
	
	----普攻获取日相能量教学阶段
	--if self.missionState == 5 then
		----弱引导普攻获取日相能量
		--if self.weakGuide[6].state == false then
			--self:WeakGuide(self.weakGuide[6].Id)
			--self.weakGuide[6].state = true
		--end
		--local yellowPowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201)
		--local monsterLife = BehaviorFunctions.GetEntityAttrValueRatio(self.monsterList[4].Id,1001)
		----小怪生命值低于一定水平则暗箱下一阶段
		--if monsterLife <= 5000 then
			--if yellowPowerRatio < 7000 then
				--BehaviorFunctions.SetEntityAttr(self.role,1201,7000)
			--end
			--self.missionState = 6		
		--end
		----玩家黄点能量足够则下一阶段
		--if yellowPowerRatio >= 7000 then
			--self.missionState = 6
		--end
	--end
	
	--if self.missionState >= 6 then
		----引导第二次技能释放
		--if self.guideSwitch == false then
			----开启技能使用弱引导
			--self:WeakGuide(self.weakGuide[9].Id)
			--self.guideSwitch = true
		--end
		
		--if self.juejiWeakGuide == false then
			----生命值检测若低于20%则充满弱点槽
			--if BehaviorFunctions.CheckEntity(self.monsterList[4].Id) then
				--local monsterLife = BehaviorFunctions.GetEntityAttrValueRatio(self.monsterList[4].Id,1001)
				--if monsterLife <= 2000 then
					--local currentElementRatio = BehaviorFunctions.GetEntityElementStateAccumulationRatio(self.monsterList[4].Id,-1)
					--if currentElementRatio < 10000 then
						--BehaviorFunctions.SetEntityElementStateAccumulation(self.monsterList[4].Id,self.monsterList[4].Id,5,149)
						--self.juejiWeakGuide = true
					--end
				--end
			--end
		--end
	--end
	
	----五行绝技引导
	--if self.juejiWeakGuide == false then
		--if BehaviorFunctions.HasEntitySign(1,10000028) then
			--self.juejiWeakGuide = true
		--end
	--end
	
	----首次绝技完成
	--if self.firstJuejiEnd == true and self.juejiImagGuide == false then
		--self:RemoveWeakGuide()
		----图片引导五行绝技和月相概念
		--BehaviorFunctions.ShowGuideImageTips(20020)
		--self.juejiImagGuide = true
	--end
	
	--if self.missionState == 8 then
		--if self.firstJueji == true then
			--if self.imagTipsFinish == true then
				--self.missionState = 8.1
			--end
		--else 
			--self.missionState = 8.1
		--end
	--end
	
	--if self.missionState == 8.1 then
	
	----如果玩家在战斗过程中离开战斗区域，则重置
	--if self.missionState >= 1 then
		--local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010405","Logic10020001_6")
		--if not inArea then
			--for i,v in ipairs(self.monsterList) do
				--if BehaviorFunctions.CheckEntity(v.Id) then
					--BehaviorFunctions.RemoveEntity(v.Id)
				--end
			--end
			----关闭空气墙
			--BehaviorFunctions.ActiveSceneObj("101040501Airwall",false,self.levelId)
			--self:RemoveWall(self.blockInf)
			--self:RemoveWeakGuide()
			--BehaviorFunctions.HideTip()
			----黑幕隐藏过程
			--BehaviorFunctions.ShowBlackCurtain(true,0,false)
			--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,0,false)
			----移除关卡
			--BehaviorFunctions.RemoveLevel(101040501)
		--end
	--end
	
	if self.missionState == 0 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能
		--创建花墙
		self:CreateWall(self.blockInf)
		--展示怪物镜头
		local fp1 = BehaviorFunctions.GetTerrainPositionP("watchPosition4",10020001,"Logic10020001_6")
		self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)

		self.levelCam2 = BehaviorFunctions.CreateEntity(22005,nil,0,0,0,nil,nil,nil,self.levelId)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.empty2)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.blockInf[1].Id)
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(110,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
		BehaviorFunctions.AddDelayCallByFrame(110,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
		self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)

		--传送玩家到敌人面前
		local pos = BehaviorFunctions.GetTerrainPositionP("tp_101040502",10020001,"Logic10020001_6")
		BehaviorFunctions.Transport(10020001,pos.x,pos.y,pos.z)

		--禁用角色输入
		self:DisablePlayerInput(true,true)
		--开启空气墙
		BehaviorFunctions.ActiveSceneObj("101040501Airwall",true,self.levelId)
		self.missionState = 8.2
	end
	
	if self.missionState == 8.2 and self.time - self.timeStart == 30 then
		--玩家看向怪物方向
		local pos = BehaviorFunctions.GetTerrainPositionP("Task1010405Mb2",10020001,"Logic10020001_6")
		BehaviorFunctions.DoLookAtPositionImmediately(self.role,pos.x,pos.y,pos.z,true)
		--召唤战斗区域2的3只小怪
		self:CreatMonster(2)
		--BehaviorFunctions.AddDelayCallByFrame(20,self,self.CreatMonster,1)
		BehaviorFunctions.AddDelayCallByFrame(20,self,self.CreatMonster,3)
		self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)
		self.missionState = 8.5
	end
	
	if self.missionState == 8.5 and self.time - self.timeStart == 80 then
		--开启角色输入
		self:DisablePlayerInput(false,false)
		--替换关卡进度
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		BehaviorFunctions.ShowTip(101040501,0)
		self.missionState = 9
	end
	
	--处于战斗状态下
	if self.missionState == 9 then
		if self.juejiWeakGuide == false then
			local monsterList = self.waveList[2]
			local listLenth = #monsterList
			for i,v in ipairs (monsterList) do
				--生命值检测若低于20%则充满弱点槽
				local test = BehaviorFunctions.CheckEntity(self.monsterList[v].Id)
				if BehaviorFunctions.CheckEntity(self.monsterList[v].Id) then
					local monsterLife = BehaviorFunctions.GetEntityAttrValueRatio(self.monsterList[v].Id,1001)
					if monsterLife <= 2000 then
						local currentElementRatio = BehaviorFunctions.GetEntityElementStateAccumulationRatio(self.monsterList[v].Id,-1)
						if currentElementRatio < 10000 then
							BehaviorFunctions.SetEntityElementStateAccumulation(self.monsterList[v].Id,self.monsterList[v].Id,5,149)
							self.juejiWeakGuide = true
						end
					end
				end
			end
		else
			local monsterList = self.waveList[2]
			local listLenth = #monsterList
			for i,v in ipairs (monsterList) do
				--生命值检测若低于20%则充满弱点槽
				local test = BehaviorFunctions.CheckEntity(self.monsterList[v].Id)
				if BehaviorFunctions.CheckEntity(self.monsterList[v].Id) then
					local monsterLife = BehaviorFunctions.GetEntityAttrValueRatio(self.monsterList[v].Id,1001)
					if monsterLife > 2000 then
						BehaviorFunctions.SetEntityAttr(self.monsterList[v].Id,1001,100)
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
					self.missionState = 10
				end
			end
		end
	end
	
	----五行绝技引导
	--if self.juejiWeakGuide == false then
		--if BehaviorFunctions.HasEntitySign(1,10000028) then
			--self.juejiWeakGuide = true
			----local monsterList = self.waveList[2]
			----local listLenth = #monsterList
			----for i,v in ipairs (monsterList) do
				----if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
					------BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.SetEntityAttr,self.monsterList[v].Id,1001,0)
					----BehaviorFunctions.SetEntityAttr(self.monsterList[v].Id,1001,0)
				----end
			----end
		--end
	--end

	--首次绝技完成
	if self.firstJuejiEnd == true and self.juejiImagGuide == false and self.missionState == 10 and self.time - self.timeStart >= 30 then
		self:RemoveWeakGuide()
		--图片引导五行绝技和月相概念
		BehaviorFunctions.ShowGuideImageTips(20020)
		local monsterList = self.waveList[2]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				BehaviorFunctions.SetEntityAttr(self.monsterList[v].Id,1001,0)
			end
		end
		self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)
		self.juejiImagGuide = true
	end
	
	
	--战斗结束
	if self.missionState == 10 and self.imagTipsFinish == true then
		BehaviorFunctions.HideTip()
		--发送任务完成
		BehaviorFunctions.SendTaskProgress(101040501,1,1)
		if self.blockInf[1].Id ~= nil then
			if BehaviorFunctions.CheckEntity(self.blockInf[1].Id) then
				--玩家看着花墙消失
				local pos = BehaviorFunctions.GetTerrainPositionP(self.watchPos,10020001,"Logic10020001_6")
				self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
				self.levelCam = BehaviorFunctions.CreateEntity(22001,nil,0,0,0,nil,nil,nil,self.levelId)
				BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.empty)
				BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.blockInf[1].Id)
				BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
				BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
				BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.blockInf[1].Id)
				BehaviorFunctions.SetEntityAttr(self.blockInf[1].Id,1001,0)
				--BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.SetEntityAttr,self.blockInf[1].Id,1001,0)
			end
		end
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101040501Airwall",false,self.levelId)
		self.missionState = 11
	end
	
	--清空实体后移除关卡
	if self.missionState == 12 then
		--任务成功移除关卡
		BehaviorFunctions.RemoveLevel(101040501)
	end

end
	
function LevelBehavior101040501:CreatMonster(v)
	local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,10020001,"Logic10020001_6")
	local rot = BehaviorFunctions.GetTerrainRotationP(self.monsterList[v].bp,10020001,"Logic10020001_6")
	self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	self.monsterList[v].state = self.monsterStateEnum.Live
	BehaviorFunctions.SetEntityEuler(self.monsterList[v].Id,rot.x,rot.y,rot.z)
	--关闭警戒
	BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
	--设置脱战范围
	BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",100)
	--设置目标追踪范围
	BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",100)
end

function LevelBehavior101040501:DisablePlayerInput(isOpen,closeUI)
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

function LevelBehavior101040501:LevelLookAtPos(pos,logic,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,10020001,logic)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z,nil,nil,nil,self.levelId)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end

--技能循环引导
function LevelBehavior101040501:SkillGuide()
	--逻辑：蓝点能放先放蓝点，黄点能放先放黄点，不能放就放普攻
	local yellowPowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201)
	local bluePowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1202)
	if bluePowerRatio >= 6665 then
		if self.weakGuide[8].state == false then
			--普攻弱引导重开
			self.weakGuide[6].state = false
			--日相技能弱引导重开
			self.weakGuide[7].state = false
			self:WeakGuide(self.weakGuide[8].Id)
		end
	else
		if yellowPowerRatio < 7000 then
			--弱引导普攻
			if self.weakGuide[6].state == false then
				--日相技能弱引导重开
				self.weakGuide[7].state = false
				--月相技能弱引导重开
				self.weakGuide[8].state = false
				self:WeakGuide(self.weakGuide[6].Id)
			end
		elseif yellowPowerRatio >= 7000 then
			if self.weakGuide[7].state == false then
				--普攻弱引导重开
				self.weakGuide[6].state = false
				--月相技能弱引导重开
				self.weakGuide[8].state = false
				self:WeakGuide(self.weakGuide[7].Id)
			end
		end
	end
end

function LevelBehavior101040501:CastSkill(instanceId,skillId,skillType)
	if instanceId == self.role then
		if skillId == 1001051 then
			self.firstJueji = true
		end
	end
end

--技能结束
function LevelBehavior101040501:FinishSkill(instanceId,skillId,skillType)
	if instanceId == self.role then
		if skillId == 1001051 then
			self.firstJuejiEnd = true
		end
	end
end

--技能中断
function LevelBehavior101040501:BreakSkill(instanceId,skillId,skillType)
	if instanceId == self.role then
		if skillId == 1001051 then
			self.firstJuejiEnd = true
		end
	end
end

function LevelBehavior101040501:ClearSkill(instanceId,skillId,skillType)
	if instanceId == self.role then
		if skillId == 1001051 then
			self.firstJuejiEnd = true
		end
	end
end

--图片引导开启/关闭检测
function LevelBehavior101040501:OnGuideImageTips(tipsId,isOpen)
	--if tipsId == 20021 and isOpen == false then
		--self.missionState = 2
	--end
	if tipsId == 20020 and isOpen == false then
		self.imagTipsFinish = true
	end
end

--创建墙体
function LevelBehavior101040501:CreateWall(list)
	for i,v in ipairs (list) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,10020001,"Logic10020001_6")
		local rotate = BehaviorFunctions.GetTerrainRotationP(v.bp,10020001,"Logic10020001_6")
		v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoMagic(v.Id,v.Id,900000007)
		BehaviorFunctions.SetEntityEuler(v.Id,rotate.x,rotate.y,rotate.z)
	end
end

--移除墙体
function LevelBehavior101040501:RemoveWall(list)
	for i,v in ipairs (list) do
		if v.Id ~= nil then
			local result = BehaviorFunctions.CheckEntity(v.Id)
			if result == true then
				BehaviorFunctions.SetEntityAttr(v.Id,1001,0)
			end
		end
	end
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior101040501:WeakGuide(guideId)
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
function LevelBehavior101040501:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

--濒死事件
function LevelBehavior101040501:Die(attackInstanceId,dieInstanceId)
	for i,v in ipairs(self.monsterList) do
		if dieInstanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
			--self.monsterDead = self.monsterDead + 1
			if self.missionState == 9 then
				self.monsterDead = self.monsterDead + 1
				--BehaviorFunctions.ShowTip(101040501,self.monsterDead)
				BehaviorFunctions.ChangeTitleTipsDesc(101040501,self.monsterDead)
			end
		end
	end
	if dieInstanceId == self.monsterList[4].Id then
		self.firstJuejiEnd = true
		--BehaviorFunctions.ShowTip(101060801,1)
		BehaviorFunctions.ChangeTitleTipsDesc(101060801,1)
		self.missionState = 8
	end
end

--死亡事件
function LevelBehavior101040501:Death(instanceId,isFormationRevive)
	if isFormationRevive then	
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		self:RemoveWeakGuide()
		self:RemoveWall(self.blockInf)
		BehaviorFunctions.HideTip()
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101040501Airwall",false,self.levelId)
		--玩家死亡移除关卡
		BehaviorFunctions.RemoveLevel(101040501)
	end
	--花墙死亡后移除关卡
	if instanceId == self.blockInf[1].Id then
		self.missionState = 12
	end
end

function LevelBehavior101040501:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				self.missionState = 1.5
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior101040501:StoryStartEvent(dialogId)

end