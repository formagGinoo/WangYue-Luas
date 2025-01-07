LevelBehavior101100901 = BaseClass("LevelBehavior101100901",LevelBehaviorBase)
--击败三名劫匪
function LevelBehavior101100901:__init(fight)
	self.fight = fight
end

function LevelBehavior101100901.GetGenerates()
	local generates = {900040,808011003}
	return generates
end

function LevelBehavior101100901.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101100901:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
		
	self.weakGuide =
	{
		[1] = {Id = 2225,state = false,Describe ="闪避回复日相指引",count = 0},
		[2] = {Id = 2226,state = false,Describe ="普攻积攒日相能量",count = 0},
		[3] = {Id = 2016,state = false,Describe ="",count = 0},
	}

	
	self.dialogList =
	{
		[1] = {Id = 101100901},--战斗开始timeline
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb1",entityId = 808011003},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb2",entityId = 808011003},
		--[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb3",entityId = 900040},
	}
	
	self.waveList =
	{
		[1] = {1,2}
	}
	
	self.monsterDead = 0
	
	self.time = 0
	self.timeStart = 0

	self.monLev = 1
end

function LevelBehavior101100901:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)
	
	--召唤怪物
	if self.missionState == 0 then
		--设置玩家黄点
		BehaviorFunctions.SetEntityAttr(self.role,1201,10000)
		--设置玩家进入战斗状态
		BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.FightIdle)
		local pos = BehaviorFunctions.GetTerrainPositionP("Task101100502Target02",10020005,"Task_main_01")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		self:LevelLookAtPos("Task101100901Lookat01","Task_main_01",22001,-1,"CameraTarget")
		
		--屏蔽任务追踪标
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		
		BehaviorFunctions.ActiveSceneObj("101100901AirWall",true,self.levelId)
		self:SummonMonster()
		self.missionState = 1
		
	--开场对话
	elseif self.missionState == 1 then
		----视角回正
		--BehaviorFunctions.CameraPosReduction(0)
		--变更目标：击败劫匪
		BehaviorFunctions.ShowTip(100000001,"击败劫匪")
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 2
		
	--敌人发动攻击
	elseif self.missionState == 3 then
		BehaviorFunctions.CastSkillByTarget(self.monsterList[2].Id,80002002,self.role)
		BehaviorFunctions.AddDelayCallByFrame(25,self,self.Assignment,"missionState",5)
		self.missionState = 4
		
	--引导玩家闪避
	elseif self.missionState == 5 then
		--设置玩家黄点
		BehaviorFunctions.SetEntityAttr(self.role,1201,10000)
		BehaviorFunctions.AddBuff(self.role,self.role,200000008)
		BehaviorFunctions.AddBuff(self.role,self.monsterList[2].Id,200000008)
		--开启角色输入
		self:DisablePlayerInput(false,false)
		--闪避弱引导
		if self.weakGuide[1].state == false then
			self:WeakGuide(self.weakGuide[1].Id)
			self.weakGuide[1].state = true
		end
		self.missionState = 6
		
	--玩家释放闪避
	elseif self.missionState == 6 then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) then
			BehaviorFunctions.RemoveEntity(self.empty)
			BehaviorFunctions.RemoveEntity(self.levelCam)
			self:RemoveWeakGuide()
			--禁用角色输入
			self:DisablePlayerInput(true,true)
			BehaviorFunctions.RemoveBuff(self.monsterList[2].Id,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",8)
			self.missionState = 7
		end
		
	--引导玩家释放小技能
	elseif self.missionState == 8 then
		BehaviorFunctions.AddBuff(self.role,self.role,200000008)
		BehaviorFunctions.AddBuff(self.role,self.monsterList[2].Id,200000008)
		--设置玩家技能点
		local yellowPower = BehaviorFunctions.GetEntityAttrVal(self.role,1201)
		if yellowPower < 20000 then
			BehaviorFunctions.SetEntityAttr(self.role,1201,20000)
		end
		--开启角色输入
		self:DisablePlayerInput(false,false)
		--开启小技能按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true)
		--小技能弱引导
		self:WeakGuide(self.weakGuide[2].Id)
		self.missionState = 9
		
	--玩家释放小技能
	elseif self.missionState == 9 then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.NormalSkill) then
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
			BehaviorFunctions.RemoveBuff(self.role,200000008)
		end
		self.missionState = 11
		
	--战斗过程中
	elseif self.missionState == 11 then 
		--弱引导普攻
		if self.weakGuide[3].state == false then
			self:WeakGuide(self.weakGuide[3].Id)
			self.weakGuide[3].state = true
		--else
			--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Attack) then
				--self:RemoveWeakGuide()
			--end
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
		--BehaviorFunctions.SendTaskProgress(101100901,1,1)
		BehaviorFunctions.FinishLevel(self.levelId)
		--关闭tips显示
		BehaviorFunctions.HideTip(100000001)
		--BehaviorFunctions.RemoveLevel(self.levelId)
		self.missionState = 13
	end
end

function LevelBehavior101100901:LevelLookAtPos(pos,logic,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,10020005,logic)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	----延迟移除目标和镜头
	--BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam, false)
	--BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	--BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior101100901:WeakGuide(guideId)
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
function LevelBehavior101100901:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function LevelBehavior101100901:OnGuideFinish(guideId,stage)
	--if guideId == self.weakGuide[1].Id then
		--self.missionState = 10
	--end
end


--死亡事件
function LevelBehavior101100901:Death(instanceId,isFormationRevive)
	if isFormationRevive then	
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		self:RemoveWeakGuide()
		BehaviorFunctions.HideTip()
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101100901AirWall",false,self.levelId)
		--移除关卡
		BehaviorFunctions.RemoveLevel(101100901)
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
				--BehaviorFunctions.ChangeTitleTipsDesc(101060801,self.monsterDead)
			end
		end
	end
end

function LevelBehavior101100901:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		----禁用角色输入
		--self:DisablePlayerInput(false,false)
		self.missionState = 3
	end
end

function LevelBehavior101100901:StoryStartEvent(dialogId)

end

--赋值
function LevelBehavior101100901:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior101100901:DisablePlayerInput(isOpen,closeUI)
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

function LevelBehavior101100901:SummonMonster()
	--召唤小怪
	for i,v in ipairs (self.waveList[1]) do
		local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,self.levelId)
		self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
		self.monsterList[v].state = self.monsterStateEnum.Live
		--设置怪物的战斗目标
		BehaviorFunctions.AddFightTarget(self.monsterList[v].Id,self.role)
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
		BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[v].Id,900000012)
	end
end
