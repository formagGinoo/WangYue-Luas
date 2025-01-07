LevelBehavior101200301 = BaseClass("LevelBehavior101200301",LevelBehaviorBase)
--击败两只噬脉生物
function LevelBehavior101200301:__init(fight)
	self.fight = fight
end

function LevelBehavior101200301.GetGenerates()
	local generates = {900080}
	return generates
end

function LevelBehavior101200301.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101200301:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
		
	self.weakGuide =
	{
		[1] = {Id = 2015,state = false,Describe ="点击按钮使用普通攻击",count = 0},
		[2] = {Id = 2016,state = false,Describe ="普攻积攒日相能量",count = 0},
		[3] = {Id = 2017,state = false,Describe ="消耗日相能量释放技能",count = 0},
		[4] = {Id = 2018,state = false,Describe ="点击按钮释放绝技",count = 0},
		[5] = {Id = 2019,state = false,Describe ="消耗日相能量释放技能",count = 0},
		[6] = {Id = 2009,state = false,Describe ="在受到红眼攻击前，按下闪避键将进入异质空间",count = 0},
	}

	
	self.dialogList =
	{
		[1] = {Id = 101200201},--战斗开始timeline
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb2",entityId = 790008001},
		--[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb2",entityId = 790008001},
	}
	
	self.waveList =
	{
		[1] = {1}
	}
	
	self.monsterDead = 0
	
	self.time = 0
	self.timeStart = 0

	self.monLev = 1
	self.playerLifeRatio = 0
	
	self.enemyDeathPos = nil
	self.YupeiEco = 3003001000001
end

function LevelBehavior101200301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)
	local test = BehaviorFunctions.GetEntityState(self.role)

	self.playerLifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
	if self.playerLifeRatio <= 1000 then
		--100%回血magic
		BehaviorFunctions.DoMagic(self.role,self.role,200000016)
	end

	--召唤怪物
	if self.missionState == 0 then	
		CurtainManager.Instance:FadeOut(0.5)
		--设置玩家进入战斗状态
		BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.FightIdle)
		--玩家不死回血保底
		if not BehaviorFunctions.HasBuffKind(self.role,200000002) then
			BehaviorFunctions.AddBuff(self.role,self.role,200000002)
		end
		--开场给玩家回满血
		BehaviorFunctions.DoMagic(self.role,self.role,200000016)
		--关闭小技能按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",false)	
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerTp01",self.levelId)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		local rotate = BehaviorFunctions.GetTerrainRotationP("PlayerTp01",self.levelId)
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)
		local pos2 = BehaviorFunctions.GetTerrainPositionP("CamLookat01",self.levelId)
		--视角回正
		BehaviorFunctions.CameraPosReduction(0)
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		self:LevelLookAtPos(pos2,22008,-1,"Bip001")

		--屏蔽任务追踪标
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)		
		BehaviorFunctions.ActiveSceneObj("101200301AirWall",true,self.levelId)
		self:SummonMonster()
		self.missionState = 1

	--开场对话
	elseif self.missionState == 1 then
		-- 让怪物跑一帧行为再停止行为树
		for k, v in ipairs(self.monsterList) do
			BehaviorFunctions.AddBuff(self.role, v.Id, 900000012)
		end
		--变更目标：击败噬脉生物
		BehaviorFunctions.ShowTip(100000001,"击败噬脉生物")
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",true,1)--显示能量条
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 2
		
	elseif self.missionState == 2.1 then
		--恢复角色输入
		self:DisablePlayerInput(false,false)
		--弱引导普攻
		if self.weakGuide[2].state == false then
			self:WeakGuide(self.weakGuide[2].Id)
			self.weakGuide[2].state = true
		else
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) then
				BehaviorFunctions.AddDelayCallByFrame(60,self,self.Assignment,"missionState",3)
				BehaviorFunctions.RemoveEntity(self.empty)
				BehaviorFunctions.RemoveEntity(self.levelCam)
				self.missionState = 2.2
				self:RemoveWeakGuide()
			end
		end
		
		
	--敌人发动攻击
	elseif self.missionState == 3 then
		BehaviorFunctions.AddBuff(self.monsterList[1].Id,self.monsterList[1].Id,900000045)
		BehaviorFunctions.CastSkillByTarget(self.monsterList[1].Id,900080002,self.role)
		BehaviorFunctions.AddDelayCallByFrame(25,self,self.Assignment,"missionState",5)
		self.missionState = 4
		
	--引导玩家闪避
	elseif self.missionState == 5 then
		--BehaviorFunctions.SetEntityAttr(self.role,1201,10000)
		BehaviorFunctions.AddBuff(self.role,self.role,200000008)
		BehaviorFunctions.AddBuff(self.monsterList[1].Id,self.monsterList[1].Id,200000008)
		--开启角色输入
		self:DisablePlayerInput(false,false)
		--闪避弱引导
		if self.weakGuide[6].state == false then
			self:WeakGuide(self.weakGuide[6].Id)
			self.weakGuide[6].state = true
		end
		self.missionState = 6
		
	--玩家释放闪避
	elseif self.missionState == 6 then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) then
			--禁用角色输入
			self:DisablePlayerInput(true,true)
			----大招前定格相机
			--BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
			--self.levelCam = BehaviorFunctions.CreateEntity(22008)
			--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"Bip001")
			--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.monsterList[1].Id)
			
			BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,900000045)
			BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			
			BehaviorFunctions.AddBuff(self.role,self.role,200000007)
			BehaviorFunctions.AddBuff(self.role,self.monsterList[1].Id,200000007)
			
			BehaviorFunctions.AddDelayCallByFrame(10,self,self.Assignment,"missionState",7.1)
			
			BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",8)
			self.missionState = 7
		end
		
	elseif self.missionState == 7.1 then
		--定格相机
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		self.levelCam = BehaviorFunctions.CreateEntity(22008)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"Bip001")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.monsterList[1].Id)

		self.missionState = 7.2
		
	--引导玩家释放小技能
	elseif self.missionState == 8 then	
		BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,200000007)
		BehaviorFunctions.RemoveBuff(self.role,200000007)	
		BehaviorFunctions.AddBuff(self.role,self.role,200000008)
		BehaviorFunctions.AddBuff(self.role,self.monsterList[1].Id,200000008)
		local yellowPower = BehaviorFunctions.GetEntityAttrVal(self.role,1201)
		if yellowPower < 20000 then
			BehaviorFunctions.SetEntityAttr(self.role,1201,20000)
		end
		--开启角色输入
		self:DisablePlayerInput(false,false)
		--开启小技能按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)
		--小技能弱引导
		self:WeakGuide(self.weakGuide[3].Id)
		self.missionState = 9
		
	--玩家释放小技能
	elseif self.missionState == 9 then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.NormalSkill) then
			BehaviorFunctions.RemoveEntity(self.levelCam)
			self:RemoveWeakGuide()
			self.missionState = 10
		end
		
	--解除行为树暂停
	elseif self.missionState == 10 then
		--关闭怪物行为树暂停
		for i,v in ipairs (self.waveList[1]) do
			--移除停止行为树
			if BehaviorFunctions.HasBuffKind(self.monsterList[v].Id,900000012) then
				BehaviorFunctions.RemoveBuff(self.monsterList[v].Id,900000012)
			end
			--恢复暂停时间
			BehaviorFunctions.RemoveBuff(self.monsterList[v].Id,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)
		end
		--开启普攻按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true)
		self.missionState = 11
		
	--战斗过程中
	elseif self.missionState == 11 then 
		--弱引导普攻
		if self.weakGuide[2].state == false then
			self:WeakGuide(self.weakGuide[2].Id)
			self.weakGuide[2].state = true
		else
			if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) then
				self:RemoveWeakGuide()
			end
		end
		
		--检查敌人是否死完
		local monsterList = self.waveList[1]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					--关闭所有引导
					self:RemoveWeakGuide()
					self.missionState = 12
				end
			end
		end

	--战斗结束
	elseif self.missionState == 12 then	
		local ins = BehaviorFunctions.GetEcoEntityByEcoId(self.YupeiEco)
		if ins then
			BehaviorFunctions.DoSetPositionP(ins,self.enemyDeathPos)
			--去除玩家不死回血保底
			BehaviorFunctions.RemoveBuff(self.role,200000002)
			BehaviorFunctions.SendTaskProgress(1010101,2,1,1)
			--关闭tips显示
			BehaviorFunctions.HideTip(100000001)
			BehaviorFunctions.RemoveLevel(self.levelId)
			self.missionState = 13
		end
	end
end

function LevelBehavior101200301:LevelLookAtPos(pos,type,frame,bindTransform)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
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
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior101200301:WeakGuide(guideId)
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
function LevelBehavior101200301:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function LevelBehavior101200301:OnGuideFinish(guideId,stage)
	if guideId == self.weakGuide[1].Id then
		self.missionState = 10
	end
end

--死亡事件
function LevelBehavior101200301:Death(instanceId,isFormationRevive)
	if isFormationRevive then	
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		self:RemoveWeakGuide()
		BehaviorFunctions.HideTip()
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101200301AirWall",false,self.levelId)
		--移除关卡
		BehaviorFunctions.RemoveLevel(101200301)
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				if instanceId == self.monsterList[1].Id then
					BehaviorFunctions.ChangeEcoEntityCreateState(self.YupeiEco,true)
					self.enemyDeathPos = TableUtils.CopyTable(BehaviorFunctions.GetPositionP(self.monsterList[1].Id))
				end
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
				--BehaviorFunctions.ChangeTitleTipsDesc(101060801,self.monsterDead)
			end
		end
	end
end

function LevelBehavior101200301:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		self.missionState = 2.1
	end
end

function LevelBehavior101200301:StoryStartEvent(dialogId)

end

--赋值
function LevelBehavior101200301:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior101200301:DisablePlayerInput(isOpen,closeUI)
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

function LevelBehavior101200301:SummonMonster()
	--召唤小怪
	for i,v in ipairs (self.waveList[1]) do
		local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,self.levelId)
		self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
		self.monsterList[v].state = self.monsterStateEnum.Live
		-- 设置怪物的战斗目标
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id, "battleTarget", self.role)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
		--关闭警戒
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
		--设置脱战范围
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",200)
		--设置目标追踪范围
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",200)
		--元素累积相关处理
		--隐藏元素条
		BehaviorFunctions.ShowEntityLifeBarElementBar(self.monsterList[v].Id,false)
		--锁住元素条
		BehaviorFunctions.EnableEntityElementStateRuning(self.monsterList[v].Id, FightEnum.ElementState.Accumulation, false,-1)
		--停止行为树
		 --BehaviorFunctions.AddBuff(self.role,self.monsterList[v].Id,900000012)
		--BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[v].Id,900000012)
	end
end
