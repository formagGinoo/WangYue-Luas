LevelBehavior101130101 = BaseClass("LevelBehavior101130101",LevelBehaviorBase)
--击败三名恐怖分子
function LevelBehavior101130101:__init(fight)
	self.fight = fight
end

function LevelBehavior101130101.GetGenerates()
	local generates = {900140,808011005,808011006}
	return generates
end

function LevelBehavior101130101.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101130101:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	
	self.dialogList =
	{
		[1] = {Id = 101202701},--战斗开始timeline
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb1",entityId = 808011006},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb2",entityId = 790014000},
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Mb3",entityId = 808011005},
	}
	
	self.waveList =
	{
		[1] = {1,2,3}
	}
	
	self.monsterDead = 0
	
	self.time = 0
	self.timeStart = 0

	self.monLev = 1
	self.playerLife = 0
end

function LevelBehavior101130101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)
	local test = BehaviorFunctions.GetEntityState(self.role)
	
	--召唤怪物
	if self.missionState == 0 then	
		--设置玩家进入战斗状态
		BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.FightIdle)
		--视角回正
		BehaviorFunctions.CameraPosReduction(0)
		--开场给玩家回满血
		BehaviorFunctions.DoMagic(self.role,self.role,200000016)
		--玩家不死回血保底
		if not BehaviorFunctions.HasBuffKind(self.role,200000002) then
			BehaviorFunctions.AddBuff(self.role,self.role,200000002)
		end	
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerTp01",self.levelId)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		local rotate = BehaviorFunctions.GetTerrainRotationP("PlayerTp01",self.levelId)
		BehaviorFunctions.SetEntityEuler(self.role,rotate.x,rotate.y,rotate.z)
		local pos2 = BehaviorFunctions.GetTerrainPositionP("CamLookat01",self.levelId)
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		--self:LevelLookAtPos(pos2,22008,-1,"Bip001")
		
		--屏蔽任务追踪标
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)		
		BehaviorFunctions.ActiveSceneObj("101130101AirWall",true,self.levelId)
		self:SummonMonster()
		self.missionState = 1
		
	--开场对话
	elseif self.missionState == 1 then
		--变更目标：击败恐怖分子
		BehaviorFunctions.ShowTip(100000001,"击败恐怖分子")
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 2
		
	--战斗过程中
	elseif self.missionState == 3 then 	
		--检查玩家是否濒死
		self.playerLife = BehaviorFunctions.GetEntityAttrVal(self.role,1001)
		if self.playerLife <= 1 then
			self.missionState = 5
		end	
		--检查敌人是否死完
		local monsterList = self.waveList[1]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					self.missionState = 4
				end
			end
		end

	--战斗胜利
	elseif self.missionState == 4 then	
		BehaviorFunctions.SendTaskProgress(1011302,1,1,1)
		self.missionState = 6
		
	--战斗失败
	elseif self.missionState == 5 then
		--发送战斗失败
		BehaviorFunctions.SendTaskProgress(1011303,1,1,1)
		self.missionState = 6
		
	--战斗结束
	elseif self.missionState == 6 then
		--去除玩家不死回血保底
		BehaviorFunctions.RemoveBuff(self.role,200000002)
		--给玩家回满血
		BehaviorFunctions.DoMagic(self.role,self.role,200000016)
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101130101AirWall",false,self.levelId)
		--关闭tips显示
		BehaviorFunctions.HideTip(100000001)
		--发送关卡完成
		BehaviorFunctions.FinishLevel(self.levelId)
		self.missionState = 7
	end
end

function LevelBehavior101130101:LevelLookAtPos(pos,type,frame,bindTransform)
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


--死亡事件
function LevelBehavior101130101:Death(instanceId,isFormationRevive)
	if isFormationRevive then	
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
			end
		end
	end
end

function LevelBehavior101130101:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		self.missionState = 3
	end
end

function LevelBehavior101130101:StoryStartEvent(dialogId)

end

--赋值
function LevelBehavior101130101:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior101130101:DisablePlayerInput(isOpen,closeUI)
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

function LevelBehavior101130101:SummonMonster()
	--召唤小怪
	for i,v in ipairs (self.waveList[1]) do
		local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,self.levelId)
		self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
		self.monsterList[v].state = self.monsterStateEnum.Live
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
		----停止行为树
		--BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[v].Id,900000012)
	end
end
