LevelBehavior101102202 = BaseClass("LevelBehavior101102202",LevelBehaviorBase)
--击败工地战斗区域2的敌人
function LevelBehavior101102202:__init(fight)
	self.fight = fight
end

function LevelBehavior101102202.GetGenerates()
	local generates = {790008002}
	return generates
end

function LevelBehavior101102202.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101102202:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	
	self.dialogList =
	{
		[1] = {Id = 101104501},--战斗开始timeline
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,entityId = 790008002,bp = "Mon1",bornDis = 7},

	}
	
	self.waveList =
	{
		[1] = {1},
	}
	
	self.monsterDead = 0
	
	self.time = 0
	self.timeStart = 0

	self.monLev = 2
end

function LevelBehavior101102202:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)
	
	--召唤怪物
	if self.missionState == 0 then
		--屏蔽任务追踪标
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		--召唤敌人
		self:SummonMonster(self.waveList[1])
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		self:PosLookAtPos("CamFollow01","CamLookat01",22007,80)
		--传送玩家
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerTp01",self.levelId)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		--停止怪物行为树
		BehaviorFunctions.AddDelayCallByFrame(20,self,self.StopMonsterBeha,self.monsterList,true)
		--怪物警告动作
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",1.1)
		--开场垃圾话
		BehaviorFunctions.AddDelayCallByFrame(71,self,self.Assignment,"missionState",2)
		self.missionState = 1
		
	elseif self.missionState == 1.1 then
		BehaviorFunctions.CastSkillBySelfPosition(self.monsterList[1].Id,900080010)
		self.missionState = 1.2
		
	--开场对话
	elseif self.missionState == 2 then
		local pos = BehaviorFunctions.GetPositionP(self.monsterList[1].Id)
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
		--玩家看向怪物
		self:LevelLookAtPos(pos,22002)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 3
		
	--敌人开始行动
	elseif self.missionState == 4 then
		--变更目标：击败箴石之劣
		BehaviorFunctions.ShowTip(100000001,"击败箴石之劣")
		self:StopMonsterBeha(self.monsterList,false)
		self:RemoveLevelLookAtPos()
		--开启角色输入
		self:DisablePlayerInput(false,false)
		BehaviorFunctions.ActiveSceneObj("101102202AirWall",true,self.levelId)
		self.missionState = 5
		
	--第一波战斗中
	elseif self.missionState == 5 then
		--检查敌人是否死完
		local monsterList = self.waveList[1]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					self.missionState = 999
				end
			end
		end

	--战斗结束
	elseif self.missionState == 999 then
		BehaviorFunctions.HideTip()	
		BehaviorFunctions.FinishLevel(self.levelId)
		--BehaviorFunctions.RemoveLevel(self.levelId)
		self.missionState = 1000
	end
end

--死亡事件
function LevelBehavior101102202:Death(instanceId,isFormationRevive)
	if isFormationRevive then	
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		BehaviorFunctions.HideTip()
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101102202AirWall",false,self.levelId)
		--移除关卡
		BehaviorFunctions.RemoveLevel(101102202)
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
			end
		end
	end
end

function LevelBehavior101102202:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		self.missionState = 4
	end
end

function LevelBehavior101102202:StoryStartEvent(dialogId)

end

--赋值
function LevelBehavior101102202:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior101102202:DisablePlayerInput(isOpen,closeUI)
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

function LevelBehavior101102202:SummonMonster(waveList)
	--召唤小怪
	for i,v in ipairs (waveList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,self.levelId)
		local posR = BehaviorFunctions.GetTerrainRotationP(self.monsterList[v].bp,self.levelId)
		--local pos = self:ReturnPosition(self.role,self.monsterList[v].bornDis,0,360,0.5,true)
		self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
		BehaviorFunctions.SetEntityEuler(self.monsterList[v].Id,posR.x,posR.y,posR.z)
		self.monsterList[v].state = self.monsterStateEnum.Live
		--BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
		--设置怪物的战斗目标
		BehaviorFunctions.AddFightTarget(self.monsterList[v].Id,self.role)
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id, "battleTarget", self.role)
		--关闭警戒
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
		--设置脱战范围
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",200)
		--设置目标追踪范围
		BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",200)
	end
end

function LevelBehavior101102202:LevelLookAtPos(pos,type,bindTransform)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z)
	self.levelCam = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
end

function LevelBehavior101102202:RemoveLevelLookAtPos()
	BehaviorFunctions.RemoveEntity(self.levelCam)
	BehaviorFunctions.RemoveEntity(self.empty)
end

function LevelBehavior101102202:PosLookAtPos(follow,lookat,type,frame)
	local pos1 = BehaviorFunctions.GetTerrainPositionP(follow,self.levelId)
	local pos2 = BehaviorFunctions.GetTerrainPositionP(lookat,self.levelId)
	self.empty1 = BehaviorFunctions.CreateEntity(2001,nil,pos1.x,pos1.y,pos1.z)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,pos2.x,pos2.y,pos2.z)
	self.levelCam = BehaviorFunctions.CreateEntity(type)

	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.empty1)
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam, false)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty1)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end

function LevelBehavior101102202:StopMonsterBeha(monsterList,bool)
	--关闭怪物行为树暂停
	for i,v in ipairs (monsterList) do
		if v.Id then
			if BehaviorFunctions.CheckEntity(v.Id) then
				if bool == true then
					--添加暂停行为树
					BehaviorFunctions.AddBuff(self.role,v.Id,900000012)
				else
					--移除停止行为树
					if BehaviorFunctions.HasBuffKind(v.Id,900000012) then
						BehaviorFunctions.RemoveBuff(v.Id,900000012)
					end
				end
			end
		end
	end
end

