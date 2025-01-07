LevelBehavior200506001 = BaseClass("LevelBehavior200506001",LevelBehaviorBase)
--超算挑战 - 难度1

function LevelBehavior200506001.GetGenerates()
	local generates = {790014000}
	return generates
end


function LevelBehavior200506001.GetMagics()
	local generates = {900000069,200000009}
	return generates
end


function LevelBehavior200506001:__init(fight)
	self.fight = fight
	self.missionState = 0
	self.frame = nil
	
	self.hasBuff = false
	self.canSet = true
	self.hasBehaviorBuff = false
	
	--关卡延迟加载buff判断参数
	self.isCount = false
	self.currenFrame = nil
	self.intervalTime = 15
	self.targetFrame = nil
	
	self.guidePosName = "lookAtPos"
	self.disCheckName = "disCheck"
	
	self.removeLevelDis = 50
	self.hastimer = false
	self.timerId = nil
	self.failTime = 120 --关卡失败时间
	
	self.totalCount = nil --总敌人数量
	self.deathCount = nil --总死亡数量
	self.currentTip = nil
	
	self.teachId = 20037
	
	self.missionCreated = false
	
	self.monsterList =
	{
		{id = 790014000 ,posName = "enemySpawn1" ,wave = 1},
		{id = 790014000 ,posName = "enemySpawn2" ,wave = 1},
		{id = 790014000 ,posName = "enemySpawn3" ,wave = 1},
	}
	
	--怪物状态判断
	self.monsterStateEnum =
	{
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.levelInfoList = 
	{
		{id = 790014000, instanceId = nil, posName = "enemySpawn1" ,wave = 1, state = self.monsterStateEnum.Default, tag = "enemy"},
		{id = 790014000, instanceId = nil, posName = "enemySpawn2" ,wave = 1, state = self.monsterStateEnum.Default, tag = "enemy"},
		{id = 790014000, instanceId = nil, posName = "enemySpawn3" ,wave = 1, state = self.monsterStateEnum.Default, tag = "enemy"},
	}
end


function LevelBehavior200506001:Init()
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
	
	self.totalCount = #self.monsterList
	self.deathCount = 0
end


function LevelBehavior200506001:Update()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行

	--检查玩家与卸载位置相距是否超过挑战距离 如果超过则算作失败移除关卡
	
	
	if self.missionCreated == false then

		if self.hastimer == false then
			--开启关卡
			self.LevelCommon:LevelStart()
			BehaviorFunctions.ShowLevelInstruction(200506001)
			--self:DisablePlayerInput(true,false)
			BehaviorFunctions.ShowCountDownPanel(3,self.levelId)
			--self.LevelCommon:LevelCameraLookAtPos(22002,60,nil,self.guidePosName,0.2,0.6)
			BehaviorFunctions.AddDelayCallByFrame(30,self.LevelCommon,self.LevelCommon.LevelCameraLookAtPos,22002,60,nil,self.guidePosName,0.2,0.6)
			BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionCreated",true)
			--self.missionCreated = true
			self.hastimer = true
		end
	else
		
		--检测玩家是否离开玩法区域 如果是则玩法失败
		local pos = BehaviorFunctions.GetTerrainPositionP(self.disCheckName,self.levelId)
		local myPos = BehaviorFunctions.GetPositionP(self.role)
		local disToCreate = Vec3.Distance(myPos, pos)
		if disToCreate >= self.removeLevelDis then
			self.missionState = 3
		end
		
		self:SetEnemyFightTarget()
		
		if self.missionState == 0 then
			--开启关卡
			self.LevelCommon:LevelStart()
			--创建怪物
			self:SpawnEnemy()
			--self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)
			--self.levelInfoList = self.monsterListInfo.list
			self:CreateBuff()
			self.hasBuff = true

			BehaviorFunctions.ShowCommonTitle(10,"在"..self.failTime.."秒内击败"..self.totalCount.."个敌人",true)
			
			----隐藏玩法占用区域
			--BehaviorFunctions.ShowMapArea(self.levelId, true)
			--BehaviorFunctions.ShowLevelEnemy(self.levelId, true)
			
			self:CreateStopBehaviorBuff()
			
			self.missionState = 1
		elseif self.missionState == 1 then

			--self.levelInfoList = self.monsterListInfo.list
			self:checkLimitState()
			--胜利条件：该怪物组内怪物都死亡
			if self.deathCount == self.totalCount then
				----隐藏玩法占用区域
				--BehaviorFunctions.ShowMapArea(self.levelId, false)
				--BehaviorFunctions.ShowLevelEnemy(self.levelId, false)
				self.missionState = 2
			end

			--挑战胜利
		elseif self.missionState == 2 then
			BehaviorFunctions.ShowCommonTitle(5,"挑战成功",true)
			BehaviorFunctions.StopLevelTimer(self.timerId)
			BehaviorFunctions.FinishLevel(self.levelId)
			self.missionState = 999

			--挑战失败
		elseif self.missionState == 3 then
			BehaviorFunctions.ShowCommonTitle(5,"挑战失败",false)
			BehaviorFunctions.StopLevelTimer(self.timerId)
			BehaviorFunctions.RemoveLevel(self.levelId)
			self.missionState = 999
		end
		
	end
end

--添加buff函数
function LevelBehavior200506001:CreateBuff()
	for i,v in ipairs(self.levelInfoList) do
		if v.instanceId then
			local cando1 = BehaviorFunctions.CheckEntity(v.instanceId)
			if cando1 then
				BehaviorFunctions.AddBuff(v.instanceId,v.instanceId,900000069)
			end
		end
	end
end

--移除buff函数
function LevelBehavior200506001:RemoveTheBuff()
	for i,v in ipairs(self.levelInfoList) do
		if v.instanceId then
			local cando2 = BehaviorFunctions.CheckEntity(v.instanceId)
			if cando2 then
				BehaviorFunctions.RemoveBuff(v.instanceId,900000069)
			end
		end
	end
end

--添加buff函数
function LevelBehavior200506001:CreateStopBehaviorBuff()
	for i,v in ipairs(self.levelInfoList) do
		if v.instanceId then
			local cando1 = BehaviorFunctions.CheckEntity(v.instanceId)
			if cando1 and not BehaviorFunctions.HasBuffKind(v.instanceId,200000009) then
				BehaviorFunctions.AddBuff(v.instanceId,v.instanceId,200000009)
			end
		end
	end
end

--移除buff函数
function LevelBehavior200506001:RemoveStopBehaviorBuff()
	for i,v in ipairs(self.levelInfoList) do
		if v.instanceId then
			local cando2 = BehaviorFunctions.CheckEntity(v.instanceId)
			if cando2 and BehaviorFunctions.HasBuffKind(v.instanceId,200000009) then
				BehaviorFunctions.RemoveBuff(v.instanceId,200000009)
			end
		end
	end
end


--判断当前是否可以移除敌人的减伤buff
function LevelBehavior200506001:checkLimitState()
	local isLimitState = BehaviorFunctions.CheckDodgeLimit()
	
	if isLimitState == true and self.hasBuff then
		self:RemoveTheBuff()
		--LogError("buffRemoved")
		--BehaviorFunctions.ShowTip(200506002)
		self.hasBuff = false
	end
	
	if self.hasBuff == false then
		if self.isCount == false then
			self.targetFrame = self.frame + self.intervalTime * 30
			self.isCount = true
		else
			if self.frame >= self.targetFrame then
				self:CreateBuff()
				--BehaviorFunctions.ShowTip(200506003)
				self.hasBuff = true
				self.isCount = false
				--LogError("hasBuff")
			end
		end
	end
end

--判断倒计时是否结束
function LevelBehavior200506001:OnCountDownFinishEvent(levelId)
	
	--self.missionCreated = true
	if levelId == self.levelId then
		--self:RemoveStopBehaviorBuff()
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.RemoveStopBehaviorBuff)
		--BehaviorFunctions.AddDelayCallByFrame(30,self,self.DisablePlayerInput,false,false)
		--self:DisablePlayerInput(true,true)
		
		--开始倒计时
		self.timerId = BehaviorFunctions.StartLevelTimer(self.failTime, 3)
		--关卡tips创建
		self.currentTip = BehaviorFunctions.AddLevelTips(200506004,self.levelId)
		BehaviorFunctions.ChangeLevelSubTips(self.currentTip,1,self.deathCount,self.totalCount)
		
	end
end

--禁用角色移动
function LevelBehavior200506001:DisablePlayerInput(isOpen,closeUI)
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

--检测死亡
function LevelBehavior200506001:Death(instanceId,isFormationRevive)
	for i,v in ipairs(self.levelInfoList) do
		if v.instanceId == instanceId and v.state == self.monsterStateEnum.Live then
			self.deathCount = self.deathCount + 1
			v.state = self.monsterStateEnum.Dead
			BehaviorFunctions.ChangeLevelSubTips(self.currentTip,1,self.deathCount,self.totalCount)
		end
	end
	
	if isFormationRevive then
		self.missionState = 3
	end
end


function LevelBehavior200506001:TimerCountFinish(timerId)
	if timerId == self.timerId and self.missionCreated == true then
		self.missionState = 3
	end
end

--赋值
function LevelBehavior200506001:Assignment(variable,value)
	self[variable] = value
end

--基于波次生成敌人
function LevelBehavior200506001:SpawnEnemy()
	for i,v in ipairs(self.levelInfoList) do
		if v.tag == "enemy" and v.state == self.monsterStateEnum.Default then
			local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
			local rot = BehaviorFunctions.GetTerrainRotationP(v.posName,self.levelId)
			v.instanceId = BehaviorFunctions.CreateEntity(v.id,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
			BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
			v.state = self.monsterStateEnum.Live
		end
	end
end

--控制敌人战斗目标
function LevelBehavior200506001:SetEnemyFightTarget()
	for i,v in ipairs(self.levelInfoList) do
		if v.state == self.monsterStateEnum.Live then
			--设置敌人攻击对象
			BehaviorFunctions.AddFightTarget(v.instanceId,self.role)
			BehaviorFunctions.SetEntityValue(v.instanceId,"haveWarn",false)
			BehaviorFunctions.SetEntityValue(v.instanceId,"battleTarget",self.role)
			--设置脱战范围
			BehaviorFunctions.SetEntityValue(v.instanceId,"ExitFightRange",40)
			--设置目标追踪范围
			BehaviorFunctions.SetEntityValue(v.instanceId,"targetMaxRange",40)
		end
	end
end