LevelBehavior101060801 = BaseClass("LevelBehavior101060801",LevelBehaviorBase)
--击败一只从士
function LevelBehavior101060801:__init(fight)
	self.fight = fight
end

function LevelBehavior101060801.GetGenerates()
	local generates = {910040,2030202}
	return generates
end

function LevelBehavior101060801.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior101060801.NeedBlackCurtain()
	return true, 0
end

function LevelBehavior101060801:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	
	self.weakGuide =
	{
		[1] = {Id = 2011,state = false,Describe ="推动摇杆进行移动",count = 0},
		[2] = {Id = 2012,state = false,Describe ="长按进入跑步状态",count = 0},
		[3] = {Id = 2013,state = false,Describe ="连续点击2次跳跃可二段跳",count = 0},
		[4] = {Id = 2014,state = false,Describe ="长按在墙面上奔跑",count = 0},
		[5] = {Id = 2015,state = false,Describe ="点击按钮使用普通攻击",count = 0},
		[6] = {Id = 2016,state = false,Describe ="普攻积攒日相能量",count = 0},
		[7] = {Id = 2017,state = false,Describe ="消耗日相能量释放技能",count = 0},
		[8] = {Id = 2018,state = false,Describe ="点击按钮释放绝技",count = 0},
		[9] = {Id = 2019,state = false,Describe ="消耗日相能量释放技能",count = 0},
		[10] = {Id = 2009,state = false,Describe ="在受到红眼攻击前，按下闪避键将进入异质空间",count = 0},
		[11] = {Id = 2008,state = false,Describe ="当敌人释放黄圈攻击时，按下跳跃键可触发跳跃反击。",count = 0},
	}
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	
	self.dialogList =
	{
		[1] = {Id = 101064101,state = self.dialogStateEnum.NotPlaying},--出现精英从士时
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010608Mb1",entityId = 910040},
	}
	
	self.monLev = 2

	self.waveList = 
	{
		[1] = {1}
	}
	
	self.monsterDead = 0
	self.time = 0
	self.timeStart = 0
	self.blockInf = 
	{
		[1] = {Id = nil ,bp = "Task1010608Wall1",entityId = 2030202},
	}
	self.gate1EcoId = 2001001020001
	
	self.timeStart = 0
	self.time = 0
	
	self.jumpCounterGuide = false
end

function LevelBehavior101060801:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		--关掉关卡进度
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		BehaviorFunctions.SetTipsGuideState(false)
		--关闭按键显示
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
		BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false) --摇杆
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --普攻
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --疾跑
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
		BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --核心被动条
		BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",false,1)--隐藏能量条
		self.missionState = 2
	end
	
	--创建怪物
	if self.missionState == 2  then
		--将玩家传送至场地内
		local targetPos = BehaviorFunctions.GetTerrainPositionP("tp_Sword",10020001,"Logic10020001_6")
		
		BehaviorFunctions.InMapTransport(targetPos.x,targetPos.y,targetPos.z)

		--创建花墙
		self:CreateWall(self.blockInf)
		--召唤精英从士
		for i,v in ipairs (self.waveList[1]) do
			local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,10020001,"Logic10020001_6")
			self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
			self.monsterList[v].state = self.monsterStateEnum.Live
			--立刻朝向玩家
			BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
			--关闭怪物警戒
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
			--设置脱战范围
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",500)
			--设置目标追踪范围
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",500)
		end
		--停止行为树
		BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[1].Id,900000012)
		--看向怪物镜头
		self.levelCam = BehaviorFunctions.CreateEntity(22002,nil,0,0,0,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.monsterList[1].Id)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.monsterList[1].Id,"HitCase")
		--播放垃圾话
		if self.dialogList[1].state ~= self.dialogStateEnum.Playing then
			BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			self.dialogList[1].state = self.dialogStateEnum.Playing
		end 
		--角色战斗待机动作
		BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.FightIdle)
		self.missionState = 2.1
	end
	
	--移除停止行为树
	if self.missionState == 2.2 then
		--移除停止行为树
		if BehaviorFunctions.HasBuffKind(self.monsterList[1].Id,900000012) then
			BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,900000012)
		end
		if self.jumpCounterGuide == false then
			if self.time - self.timeStart == 36 then
				BehaviorFunctions.AddBuff(self.role,self.role,200000008)
				BehaviorFunctions.AddBuff(self.role,self.monsterList[1].Id,200000008)
				--打开跳跃按钮
				BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃
				--打开跳反引导
				--BehaviorFunctions.PlayGuide(2020,1,1)
				if self.weakGuide[11].state == false then
					self:WeakGuide(self.weakGuide[11].Id)
					self.weakGuide[11].state = true
				end
				self.jumpCounterGuide = true
				self.missionState = 2.3
			end
		end
	end
	
	--解除跳砸的时停
	if self.missionState == 2.3 then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump) then
			BehaviorFunctions.RemoveEntity(self.levelCam)
			BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)			
			--恢复目标
			BehaviorFunctions.ShowTip(101060801,0)
			--恢复按键
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true) --摇杆
			BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --普攻
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --疾跑
			BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招
			BehaviorFunctions.SetFightMainNodeVisible(2,"Core",true) --核心被动条
			BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",true,1)--隐藏能量条
			self.missionState = 2.4
		end
	end
	
	--检查怪物死没死
	if self.missionState == 2.4 then
		--local result = BehaviorFunctions.GetEntityState(self.monsterList[1].Id)
		local listLenth = #self.waveList[1]
		local count = 0
		for i,v in ipairs (self.waveList[1]) do
			if BehaviorFunctions.CheckEntity(self.monsterList[v].Id) == true then
			end
			--如果击杀了怪物
			if self.monsterList[v].state == self.monsterStateEnum.Dead then
				count = count + 1
				if count == listLenth then
					self.missionState = 4
				end
			end
		end
	end
	
	if self.missionState == 4 then
		BehaviorFunctions.HideTip()
		--移除花墙
		self:RemoveWall(self.blockInf)
		--打开庭院的门
		local ins = BehaviorFunctions.GetEcoEntityByEcoId(self.gate1EcoId)
		if ins ~= nil then
			local result = BehaviorFunctions.CheckEntity(ins)
			if result == true then
				BehaviorFunctions.SetEntityValue(ins,"Remove",true)
			end
		end
		BehaviorFunctions.SendTaskProgress(101060801,1,1)
		self.missionState = 5
	end
	
	--移除关卡
	if self.missionState == 6 then
		--任务成功移除关卡
		BehaviorFunctions.RemoveLevel(101060801)
	end
end

--释放技能检查
function LevelBehavior101060801:CastSkill(instanceId,skillId,skillSign,skillType)
	if self.jumpCounterGuide == false then
		if instanceId == self.monsterList[1].Id and skillId == 91004005 then
			self.timeStart = BehaviorFunctions.GetFightFrame()
		end
	end
end

--创建墙体
function LevelBehavior101060801:CreateWall(list)
	for i,v in ipairs (list) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,10020001,"Logic10020001_6")
		local rotate = BehaviorFunctions.GetTerrainRotationP(v.bp,10020001,"Logic10020001_6")
		v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoMagic(v.Id,v.Id,900000007)
		BehaviorFunctions.SetEntityEuler(v.Id,rotate.x,rotate.y,rotate.z)
	end
end

--移除墙体
function LevelBehavior101060801:RemoveWall(list)
	for i,v in ipairs (list) do
		if v.Id ~= nil then
			local result = BehaviorFunctions.CheckEntity(v.Id)
			if result == true then
				BehaviorFunctions.SetEntityAttr(v.Id,1001,0)
			end
		end
	end
end

function LevelBehavior101060801:DisablePlayerInput(isOpen,closeUI)
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

--死亡事件
function LevelBehavior101060801:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		self:RemoveWall(self.blockInf)
		BehaviorFunctions.HideTip()
		--任务成功移除关卡
		BehaviorFunctions.RemoveLevel(101060801)
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
				--BehaviorFunctions.ShowTip(101060801,self.monsterDead)
				BehaviorFunctions.ChangeTitleTipsDesc(101060801,self.monsterDead)
			end
		end
	end
	--花墙死亡后移除关卡
	if instanceId == self.blockInf[1].Id then
		self.missionState = 6
	end
end

function LevelBehavior101060801:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[1].Id then
				self.missionState = 2.2
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior101060801:StoryStartEvent(dialogId)
	
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior101060801:WeakGuide(guideId)
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
function LevelBehavior101060801:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end