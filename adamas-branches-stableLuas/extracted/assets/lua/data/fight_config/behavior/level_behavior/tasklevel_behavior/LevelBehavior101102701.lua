LevelBehavior101102701 = BaseClass("LevelBehavior101102701",LevelBehaviorBase)
--击败工地顶层的敌人
function LevelBehavior101102701:__init(fight)
	self.fight = fight
end

function LevelBehavior101102701.GetGenerates()
	local generates = {900080,910040}
	return generates
end

function LevelBehavior101102701.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101102701:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0

	self.dialogList =
	{
		[1] = {Id = 101102601},--战斗开始timeline
	}

	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}

	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,entityId = 910040,bp = "Mb1"},

	}
	
	self.weakGuide =
	{
		[1] = {Id = 2227,state = false,Describe ="按Q使用佩从技能",count = 0},
	}
	
	self.guideSwitch = false

	self.waveList =
	{
		[1] = {1},
	}

	self.monsterDead = 0

	self.time = 0
	self.timeStart = 0

	self.monLev = 2
	
	self.imagTipsId = 20026 --佩从连携图文ID
	
	self.phase = 1
	
	self.phase2Skill = false
	
	self.congshiSkillList = {
		----挥锤挑飞
		{id = 91004001,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 102,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--横扫
		{id = 91004002,
			minDistance = 1,         --技能释放最小距离（有等号）
			maxDistance = 4,        --技能释放最大距离（无等号）
			angle = 30,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 84,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
		--恐怖胸炮攻击
		{id = 91004003,
			minDistance = 6,         --技能释放最小距离（有等号）
			maxDistance = 16,        --技能释放最大距离（无等号）
			angle = 80,              --技能释放角度
			cd = 15,                  --技能cd，单位：秒
			durationFrame = 135,      --技能持续帧数
			frame = 0,               --cd用帧数参数，默认为0，大于0相当于有单独的初始cd
			priority = 1,            --优先级，数值越大优先级越高
			isAuto = true,           --是否自动释放
			difficultyDegree = 0,    --难度系数，初始化会剔除大于预设难度的技能
			minLifeRatio = 0,        --技能释放最低生命万分比（有等号）
			maxLifeRatio = 10000     --技能释放最高生命万分比（无等号）
		},
	}
end

function LevelBehavior101102701:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)

	--召唤怪物
	if self.missionState == 0 then
		--设置玩家进入战斗状态
		BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.FightIdle)
		--屏蔽任务追踪标
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		--召唤敌人
		self:SummonMonster(self.waveList[1])
		BehaviorFunctions.SetEntityValue(self.monsterList[1].Id,"skillList",self.congshiSkillList)		
		--停止行为树
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[1].Id,900000012)
		self.missionState = 1

		--开场对话
	elseif self.missionState == 1 then
		self:PosLookAtPos("CamFollow01","CamLookat01",22007,60)
		----玩家看向怪物
		--self:LevelLookAtPos(pos,22002)
		--禁用角色输入
		self:DisablePlayerInput(true,true)
		BehaviorFunctions.AddDelayCallByFrame(20,self,self.Assignment,"missionState",2.1)
		BehaviorFunctions.AddDelayCallByFrame(51,self,self.Assignment,"missionState",3)
		self.missionState = 2
		
	elseif self.missionState == 2.1 then
		BehaviorFunctions.CastSkillBySelfPosition(self.monsterList[1].Id,91004092)
		self.missionState = 2.2
		
	--开场对话结束	
	elseif self.missionState == 3 then
		local pos = BehaviorFunctions.GetPositionP(self.monsterList[1].Id)
		--玩家看向怪物
		self:LevelLookAtPos(pos,22002)
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.missionState = 4

		--敌人开始行动
	elseif self.missionState == 5 then
		--变更目标：击败精英从士
		BehaviorFunctions.ShowTip(100000001,"击败精英从士")
		--移除停止行为树
		if BehaviorFunctions.HasBuffKind(self.monsterList[1].Id,900000012) then
			BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,900000012)
		end
		self:RemoveLevelLookAtPos()
		--开启角色输入
		self:DisablePlayerInput(false,false)
		BehaviorFunctions.ActiveSceneObj("101102701AirWall",true,self.levelId)
		self.missionState = 6

		--第一波战斗中
	elseif self.missionState == 6 then
		
		--佩从技能引导
		if not self.guideSwitch then
			local dis = BehaviorFunctions.GetDistanceFromTarget(self.role,self.monsterList[1].Id)
			local bluePowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1202)
			if self.weakGuide[1].state == false then
				if dis <= 5 and bluePowerRatio > 3000 then
					if self.weakGuide[1].state == false then
						self:WeakGuide(self.weakGuide[1].Id)--佩从技能引导
					end
				else
					self.weakGuide[1].state = false
				end
			else
				if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Partner) then
					self:RemoveWeakGuide()
					self.guideSwitch = true
				end
				if dis > 5 or bluePowerRatio <= 3000 then
					self:RemoveWeakGuide()
					self.weakGuide[1].state = false
				end
			end
		end
		
		if BehaviorFunctions.CheckEntity(self.monsterList[1].Id) then
			--生命值低至50进入第二阶段
			local lifeRaito = BehaviorFunctions.GetEntityAttrValueRatio(self.monsterList[1].Id,1001)
			if lifeRaito <= 5000 then
				if self.phase == 1 then
					if not BehaviorFunctions.HasBuffKind(self.monsterList[1].Id,900000007) then
						BehaviorFunctions.AddBuff(self.monsterList[1].Id,self.monsterList[1].Id,900000007)
						self.phase = 2
					end
				else
					if self.phase2Skill == false then
						if BehaviorFunctions.CanCastSkill(self.monsterList[1].Id) then
							BehaviorFunctions.CastSkillByTarget(self.monsterList[1].Id,91004092,self.role)
							BehaviorFunctions.AddDelayCallByFrame(80,self,self.SummonMonsterByTarget,900080,self.role)
							BehaviorFunctions.AddDelayCallByFrame(80,self,self.SummonMonsterByTarget,900080,self.role)
							BehaviorFunctions.AddDelayCallByFrame(150,BehaviorFunctions,BehaviorFunctions.RemoveBuff,self.monsterList[1].Id,900000007)
							self.phase2Skill = true
						end
					end
				end
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
					self.missionState = 999
				end
			end
		end

		--战斗结束
	elseif self.missionState == 999 then
		self:RemoveWeakGuide()
		--关闭tips显示
		BehaviorFunctions.HideTip(100000001)
		BehaviorFunctions.FinishLevel(self.levelId)
		--BehaviorFunctions.RemoveLevel(self.levelId)
		self.missionState = 1000
	end
end

--死亡事件
function LevelBehavior101102701:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		BehaviorFunctions.HideTip()
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101102701AirWall",false,self.levelId)
		--移除关卡
		BehaviorFunctions.RemoveLevel(101102701)
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
			end
		end
	end
end

function LevelBehavior101102701:StoryEndEvent(dialogId)
	if dialogId == self.dialogList[1].Id then
		self.missionState = 5
	end
end

function LevelBehavior101102701:StoryStartEvent(dialogId)

end

--赋值
function LevelBehavior101102701:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior101102701:DisablePlayerInput(isOpen,closeUI)
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

function LevelBehavior101102701:SummonMonster(waveList)
	--召唤小怪
	for i,v in ipairs (waveList) do
		local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,self.levelId)
		self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
		self.monsterList[v].state = self.monsterStateEnum.Live
		BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
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

function LevelBehavior101102701:LevelLookAtPos(pos,type,bindTransform)
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

function LevelBehavior101102701:RemoveLevelLookAtPos()
	BehaviorFunctions.RemoveEntity(self.levelCam)
	BehaviorFunctions.RemoveEntity(self.empty)
end

function LevelBehavior101102701:PosLookAtPos(follow,lookat,type,frame)
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

--关闭图片引导
function LevelBehavior101102701:OnGuideImageTips(tipsId,isOpen)
	--if tipsId == self.imagTipsId and isOpen == false then
		--self.missionState = 5
	--end
end

function LevelBehavior101102701:SummonMonsterByTarget(entityId,target)
	--召唤小怪
	local pos = self:ReturnPosition(self.role,6,0,360,0.5,true)
	local ins = BehaviorFunctions.CreateEntity(entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,self.monLev)
	BehaviorFunctions.DoLookAtTargetImmediately(ins,self.role)
	--关闭警戒
	BehaviorFunctions.SetEntityValue(ins,"haveWarn",false)
	--设置脱战范围
	BehaviorFunctions.SetEntityValue(ins,"ExitFightRange",200)
	--设置目标追踪范围
	BehaviorFunctions.SetEntityValue(ins,"targetMaxRange",200)
end

---返回范围内没有障碍的位置
function LevelBehavior101102701:ReturnPosition(target,distance,startAngel,endAngel,checkheight,returnFarthestPos)
	local posTable = {}
	local posTable2 = {}
	local farthestPos = nil
	for angel = startAngel,endAngel,5 do
		local pos = BehaviorFunctions.GetPositionOffsetBySelf(target,distance,angel)
		local targetPos = BehaviorFunctions.GetPositionP(target)
		--点位克隆
		local posClone = TableUtils.CopyTable(pos)
		local targetposClone = TableUtils.CopyTable(targetPos)
		--如果有检查高度则检查
		if checkheight then
			posClone.y = posClone.y + checkheight
			targetposClone.y = targetposClone.y + checkheight
		end
		--获取与该点的距离
		local dis = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,posClone,false)
		--获取与该障碍的距离
		if farthestPos then
			--选取最远的距离
			local dis2 = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,farthestPos,false)
			if dis > dis2 then
				farthestPos = posClone
				farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
			end
		else
			farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
		end
		--检测障碍：
		if not BehaviorFunctions.CheckObstaclesBetweenPos(targetposClone,posClone,false) then
			local layerHight,layer = BehaviorFunctions.CheckPosHeight(posClone)
			if layerHight <= 1 then
				if layer == FightEnum.Layer.Terrain or layer == FightEnum.Layer.Default then
					if self:CheckPosInCam(pos) then
						table.insert(posTable2,pos)
					end
					table.insert(posTable,pos)
				end
			end
		end
	end
	if #posTable2 ~= 0 then
		local randomPos = math.random(1,#posTable2)
		return posTable2[randomPos]
	else
		if #posTable ~= 0 then
			local randomPos = math.random(1,#posTable)
			return posTable[randomPos]
		else
			if not returnFarthestPos then
				return nil
			else
				--返回最远的点
				return farthestPos
			end
		end
	end
end

--检查坐标点是否处于画面中
function LevelBehavior101102701:CheckPosInCam(Position)
	local uiPos = UtilsBase.WorldToUIPointBase(Position.x,Position.y,Position.z)
	if uiPos.z > 0 and math.abs(uiPos.x) <= 640 and math.abs(uiPos.y) <= 360 then
		return true
	else
		return false
	end
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior101102701:WeakGuide(guideId)
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
function LevelBehavior101102701:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

