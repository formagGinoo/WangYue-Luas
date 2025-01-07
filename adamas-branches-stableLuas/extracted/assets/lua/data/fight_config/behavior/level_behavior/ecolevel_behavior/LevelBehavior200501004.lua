LevelBehavior200501004 = BaseClass("LevelBehavior200501004",LevelBehaviorBase)


function LevelBehavior200501004.GetGenerates()
	local generates = {203040201,203040202}
	return generates
end


function LevelBehavior200501004:__init(fight)
	self.fight = fight
	self.missionState = 0

	self.isCount = false
	self.targetFrame = nil
	self.intervalTime = 3

	self.time = nil
	self.frame = nil
	self.role = nil
	self.monsterListInfo = nil

	self.monsterList =
	{
		{id = 203040201 ,posName = "qiQiu1" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu2" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu3" ,wave = 1},
	}
	
	self.ballonList =
	{
		{instanceId = nil, id = 203040201 ,posName = "qiQiu1" ,wave = 1, patrolListName = {"qiQiu1","qiQiu1End"}, patrolList = {}, isMove = false, speed = 2, targetPos = nil, index = 1},
		{instanceId = nil, id = 203040201 ,posName = "qiQiu2" ,wave = 1, patrolListName = {"qiQiu2","qiQiu2End"}, patrolList = {}, isMove = false, speed = 2, targetPos = nil, index = 1},
		{instanceId = nil, id = 203040201 ,posName = "qiQiu3" ,wave = 1, patrolListName = {"qiQiu3","qiQiu3End"}, patrolList = {}, isMove = false, speed = 2, targetPos = nil, index = 1},
	}
end


function LevelBehavior200501004:Init()
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
end


function LevelBehavior200501004:Update()

	self.time = BehaviorFunctions.GetFightFrame()/30
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	self.LevelCommon:Update() --执行关卡通用行为树的每帧运行

	if self.missionState == 0 then

		self.LevelCommon:SetAsChallengeLevel("射击挑战")
		--开启关卡倒计时
		--self:LevelStartCountDown()
		self.LevelCommon:LevelStart()
		self.LevelCommon:LevelCameraLookAtPos(22002,30,nil,"lookAtPos",0.3,0.1)
		--创建怪物
		self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)
		 
		
		for i,v in ipairs(self.monsterListInfo.list) do
			LogError(v.instanceId)
			for j,k in ipairs(self.ballonList) do
				if v.posName == k.posName then
					k.instanceId = v.instanceId
				end
			end
		end
		
		
		for i,v in ipairs(self.ballonList) do
			if v.patrolListName then
				local patrolPosList = {}
				for j,k in ipairs(v.patrolListName) do
					local pos = BehaviorFunctions.GetTerrainPositionP(k,self.levelId)
					table.insert(patrolPosList,pos)
				end
				v.patrolList = patrolPosList
			end
		end
		
		--开启剩余敌人数量显示
		self.LevelCommon:ShowEnemyRemainTips(true)

		self.missionState = 1
	elseif self.missionState == 1 then
		
		self:BallonMoveTo()
		
		--胜利条件：该怪物组内怪物都死亡
		local result1 = self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo)
		--将上述条件作为胜利条件
		self.LevelCommon:LevelSuccessCondition(result1)
		--失败条件：超出时间限制
		local result3 = self.LevelCommon:FailCondition_TimeLimit(60)

		--将上述条件作为失败条件
		self.LevelCommon:LevelFailCondition(result3)
	end
end


function LevelBehavior200501004:BallonMoveTo()
	--检查下个点的距离
		for i,v in ipairs(self.ballonList) do
		local hasEntity = BehaviorFunctions.CheckEntity(v.instanceId)
			if v.patrolList and hasEntity then
				for x,y in ipairs(v.patrolList) do
				--如果没有点位则选择列表中第二个作为目标点
					if v.targetPos == nil then
						v.targetPos = v.patrolList[v.index+1]
						BehaviorFunctions.DoPreciseMoveToPositionBySpeed(v.instanceId, v.targetPos.x, v.targetPos.y, v.targetPos.z, v.speed)
					--如果有点位则检查距离该点位的距离
					else
					
						local currentPos = BehaviorFunctions.GetPositionP(v.instanceId)
						--local dis = BehaviorFunctions.GetDistanceFromPos(currentPos,v.targetPos)
						local dis = Vec3.Distance(currentPos, v.targetPos)
						print("dis = "..dis)
						--如果距离小于0.1，切换到下一个移动的点
						if dis < 0.1 then
							--如果有下一个点，则切换到下一个点
							if next(v.patrolList,v.index) then
							    v.index = v.index + 1
							else
								v.index = 1								
							end
							v.targetPos = v.patrolList[v.index]
							--移动至下一个点
							BehaviorFunctions.DoPreciseMoveToPositionBySpeed(v.instanceId, v.targetPos.x, v.targetPos.y, v.targetPos.z, v.speed)
						else
							BehaviorFunctions.DoPreciseMoveToPositionBySpeed(v.instanceId, v.targetPos.x, v.targetPos.y, v.targetPos.z, v.speed)
						end
					end
				end
			end
		end
end