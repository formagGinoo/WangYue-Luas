LevelBehavior101102201 = BaseClass("LevelBehavior101102201",LevelBehaviorBase)
--击败工地战斗区域1的敌人
function LevelBehavior101102201:__init(fight)
	self.fight = fight
end

function LevelBehavior101102201.GetGenerates()
	local generates = {900120,900130}
	return generates
end

function LevelBehavior101102201.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101102201:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
		
	self.weakGuide =
	{
		[1] = {Id = 2018,state = false,Describe ="点击按钮释放绝技",count = 0},
	}

	
	self.dialogList =
	{
		[1] = {Id = 101102201},--战斗开始timeline
		[2] = {Id = 101102301},--大招前timeline
		[3] = {Id = 101104401},--战斗结束timeline
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,entityId = 790012000,bp = "Mon1",bornDis = 7},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,entityId = 790013000,bp = "Mon2",bornDis = 10},
	}
	
	self.waveList =
	{
		[1] = {1,2},
	}
	
	self.summonList = 
	{
		[1] = {2},
		[2] = {1},
	}
	
	self.monsterDead = 0
	self.tagedMonster = nil
	
	self.time = 0
	self.timeStart = 0

	self.monLev = 1
	
	self.juejiWeakGuide = false
end

function LevelBehavior101102201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)
	
	--召唤怪物
	if self.missionState == 0 then
		--设置玩家进入战斗状态
		BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.FightIdle)
		--清空玩家大招
		if BehaviorFunctions.GetPlayerAttrVal(1653) >= 1 then
			BehaviorFunctions.SetPlayerAttr(1653,0)
		end
		--屏蔽任务追踪标
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		self:SummonMonster(self.summonList[1])
		BehaviorFunctions.AddDelayCallByFrame(20,self,self.SummonMonster,self.summonList[2])
		local pos = BehaviorFunctions.GetTerrainPositionP("PlayerTp01",self.levelId)
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		self:PosLookAtPos("CamFollow01","CamLookat01",22007,80)
		--停止怪物行为树
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.StopMonsterBeha,self.monsterList,true)
		--怪物警告动作
		BehaviorFunctions.AddDelayCallByFrame(40,self,self.Assignment,"missionState",1.1)
		
		BehaviorFunctions.AddDelayCallByFrame(81,self,self.Assignment,"missionState",2)
		self.missionState = 1
		
	elseif self.missionState == 1.1 then
		--BehaviorFunctions.CastSkillBySelfPosition(self.monsterList[1].Id,900070901)
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
		
		--变更目标：击败噬脉生物
		BehaviorFunctions.ShowTip(100000001,"击败噬脉生物")
		self:StopMonsterBeha(self.monsterList,false)
		self:RemoveLevelLookAtPos()
		--开启角色输入
		self:DisablePlayerInput(false,false)
		BehaviorFunctions.ActiveSceneObj("101102201AirWall",true,self.levelId)
		self.missionState = 5
		
	--第一波战斗中
	elseif self.missionState == 5 then
		if self.juejiWeakGuide == false and self.weakGuide[1].state == false then
			local monsterList = self.waveList[1]
			local listLenth = #monsterList
			for i,v in ipairs (monsterList) do
				--生命值检测若低于30%则充满弱点槽
				local test = BehaviorFunctions.CheckEntity(self.monsterList[i].Id)
				if BehaviorFunctions.CheckEntity(self.monsterList[i].Id) then
					local monsterLife = BehaviorFunctions.GetEntityAttrValueRatio(self.monsterList[i].Id,1001)
					if monsterLife <= 3000 then
						local currentElementRatio = BehaviorFunctions.GetEntityElementStateAccumulationRatio(self.monsterList[i].Id,-1)
						if currentElementRatio < 10000 then
							--BehaviorFunctions.SetEntityElementStateAccumulation(self.role,self.monsterList[i].Id,nil,149000)
							BehaviorFunctions.AddEntityElementStateAccumulation(self.role,self.monsterList[i].Id,nil,149000)
							self.juejiWeakGuide = true
						end
					end
				end
			end
		end
		
		--检查是否有大招资源
		if BehaviorFunctions.GetPlayerAttrVal(1653) >= 1 then
			--大招引导
			if self.weakGuide[1].state == false then
				self:DisablePlayerInput(false,false)
				--大招前定格相机
				BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
				self.levelCam = BehaviorFunctions.CreateEntity(22008)
				BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"Bip001")
				BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.tagedMonster)
				--临时修改关卡相机参数
				BehaviorFunctions.SetLevelCamera(self.levelCam)
				local param2 = BehaviorFunctions.GetLevelCameraParamTable()
				BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招开启
				local monsterList = self.waveList[1]
				local listLenth = #monsterList
				for i,v in ipairs (monsterList) do
					--暂停敌人时间
					BehaviorFunctions.AddBuff(self.role,self.monsterList[i].Id,200000008)
				end
				--暂停玩家时间
				BehaviorFunctions.AddBuff(self.role,self.role,200000008)
				self:WeakGuide(self.weakGuide[1].Id)
				self.weakGuide[1].state = true
			end
		elseif BehaviorFunctions.GetPlayerAttrVal(1653) == 0 then
			if self.weakGuide[1].state == true then
				self:RemoveWeakGuide()
			end
		end	
		
		--检查敌人是否死完
		local monsterList = self.waveList[1]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[i].state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					self.missionState = 999
				end
			end
		end
		
	----召唤第二波敌人
	--elseif self.missionState == 6 then
		----禁用角色输入
		--self:DisablePlayerInput(true,true)
		--self:SummonMonster(self.summonList[3])
		--BehaviorFunctions.AddDelayCallByFrame(20,self,self.SummonMonster,self.summonList[4])
		--BehaviorFunctions.AddDelayCallByFrame(30,self,self.SummonMonster,self.summonList[5])
		----传送玩家
		--local pos = BehaviorFunctions.GetTerrainPositionP("PlayerTp02",self.levelId)
		--BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		--BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
		--self:PosLookAtPos("CamFollow02","CamLookat02",22007,80)
		
		--BehaviorFunctions.AddDelayCallByFrame(81,self,self.Assignment,"missionState",7.1)		
		----停止怪物行为树
		--BehaviorFunctions.AddDelayCallByFrame(40,self,self.StopMonsterBeha,self.monsterList,true)

		--self.missionState = 7
		
	----第二波开场垃圾话
	--elseif self.missionState == 7.1 then
		--local pos = BehaviorFunctions.GetPositionP(self.monsterList[4].Id)
		--BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.2)
		----玩家看向怪物
		--self:LevelLookAtPos(pos,22002)
		--BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		--self.missionState = 7.2
		
	----引导玩家释放大招
	--elseif self.missionState == 8 then
		--self:RemoveLevelLookAtPos()
		----添加时间暂停
		--BehaviorFunctions.AddBuff(self.role,self.monsterList[3].Id,200000008)
		----恢复角色输入
		--self:DisablePlayerInput(false,false)
		--BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招
		--BehaviorFunctions.SetEntityAttr(self.role,1653,1,1)
		--self:WeakGuide(self.weakGuide[1].Id)
		--self.missionState = 9	
		
	----玩家释放大招
	--elseif self.missionState == 9 then		
		--if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.UltimateSkill) then
			----移除时间暂停
			--BehaviorFunctions.RemoveBuff(self.monsterList[3].Id,200000008)
			----恢复怪物行为树
			--self:StopMonsterBeha(self.monsterList,false)
			--self:RemoveLevelLookAtPos()
			--self:RemoveWeakGuide()
			--self.missionState = 10
		--end
		
	----第二波战斗过程中
	--elseif self.missionState == 10 then 
		----检查敌人是否死完
		--local monsterList = self.waveList[2]
		--local listLenth = #monsterList
		--for i,v in ipairs (monsterList) do
			--if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				--return
			--else
				--if i == listLenth then
					----关闭所有引导
					--self:RemoveWeakGuide()
					--self.missionState = 999
				--end
			--end
		--end

	--战斗结束
	elseif self.missionState == 999 then
		--图片引导五行绝技和月相概念
		BehaviorFunctions.ShowGuideImageTips(20011)	
		BehaviorFunctions.HideTip()
		BehaviorFunctions.StartStoryDialog(self.dialogList[3].Id)
		BehaviorFunctions.FinishLevel(self.levelId)
		--BehaviorFunctions.RemoveLevel(self.levelId)
		self.missionState = 1000
	end
end

function LevelBehavior101102201:EnterElementStateReady(atkInstanceId, instanceId, element)
	--大招引导
	if self.weakGuide[1].state == false then
		self:DisablePlayerInput(true,true)
		BehaviorFunctions.CastSkillByTarget(atkInstanceId,1001031,instanceId)
		self.tagedMonster = instanceId
	end
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior101102201:WeakGuide(guideId)
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
function LevelBehavior101102201:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end


--死亡事件
function LevelBehavior101102201:Death(instanceId,isFormationRevive)
	if isFormationRevive then	
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		self:RemoveWeakGuide()
		BehaviorFunctions.HideTip()
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101102201AirWall",false,self.levelId)
		--移除关卡
		BehaviorFunctions.RemoveLevel(101102201)
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
			end
		end
	end
end

function LevelBehavior101102201:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		self.missionState = 4
	elseif dialogId == self.dialogList[2].Id then
		self.missionState = 8
	end
end

function LevelBehavior101102201:StoryStartEvent(dialogId)

end

--赋值
function LevelBehavior101102201:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior101102201:DisablePlayerInput(isOpen,closeUI)
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

function LevelBehavior101102201:SummonMonster(waveList)
	--召唤小怪
	for i,v in ipairs (waveList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,self.levelId)
		local posR = BehaviorFunctions.GetTerrainRotationP(self.monsterList[v].bp,self.levelId)
		--local pos = self:ReturnPosition(self.role,self.monsterList[v].bornDis,0,360,0.5,true)
		self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
		BehaviorFunctions.SetEntityEuler(self.monsterList[v].Id,posR.x,posR.y,posR.z)
		self.monsterList[v].state = self.monsterStateEnum.Live
		
		--BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"skillList",self.luohouSkillList)
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

function LevelBehavior101102201:LevelLookAtPos(pos,type,bindTransform)
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

function LevelBehavior101102201:PosLookAtPos(follow,lookat,type,frame)
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

function LevelBehavior101102201:RemoveLevelLookAtPos()
	if BehaviorFunctions.CheckEntity(self.levelCam) then
		BehaviorFunctions.RemoveEntity(self.levelCam)
	end
	if BehaviorFunctions.CheckEntity(self.empty) then
		BehaviorFunctions.RemoveEntity(self.empty)
	end
end

function LevelBehavior101102201:StopMonsterBeha(monsterList,bool)
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

function LevelBehavior101102201:OnGuideFinish(guideId,stage)
	if guideId == self.weakGuide[1].Id then
		--恢复暂停时间
		BehaviorFunctions.RemoveBuff(self.role,200000008)

		local monsterList = self.waveList[1]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			--恢复暂停时间
			BehaviorFunctions.RemoveBuff(self.monsterList[v].Id,200000008)
		end
		self:RemoveLevelLookAtPos()
	end
end