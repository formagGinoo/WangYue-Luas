LevelBehavior200501002 = BaseClass("LevelBehavior200501002",LevelBehaviorBase)


function LevelBehavior200501002.GetGenerates()
	local generates = {203040201,203040202}
	return generates
end


function LevelBehavior200501002:__init(fight)
	self.fight = fight
	self.missionState = 0

	self.isCount = false
	self.targetFrame = nil
	self.intervalTime = 3

	self.time = nil
	self.frame = nil
	self.role = nil


	self.monsterList =
	{
		{id = 203040201 ,posName = "qiQiu1" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu2" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu3" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu4" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu5" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu6" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu7" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu8" ,wave = 1},
		{id = 203040201 ,posName = "qiQiu9" ,wave = 1},
	}
end


function LevelBehavior200501002:Init()
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
end


function LevelBehavior200501002:Update()

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
		--开启剩余敌人数量显示
		self.LevelCommon:ShowEnemyRemainTips(true)

		self.missionState = 1
	elseif self.missionState == 1 then
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


--function LevelBehavior200501002:LevelStartCountDown()
--if self.isCount == false then
--self.targetFrame = self.frame + self.intervalTime * 8
--self.isCount = true
--else
--if self.frame < self.targetFrame then
--local remainTime = (self.targetFrame - self.frame) / 30
--local realVal = math.floor(remainTime)
--local remainTimeText = "倒计时："..realVal.."秒"
--LogError("remainTimeText")
--else
--LogError("挑战开始")
--self.LevelCommon:LevelStart()

--local pos = BehaviorFunctions.GetTerrainPositionP("lookAtPos",self.levelId)
--self.LevelCommon:LevelCameraLookAtPos(22002,30,nil,"lookAtPos",0.3,0.1)
----创建怪物
--self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)
----开启剩余敌人数量显示
--self.LevelCommon:ShowEnemyRemainTips(true)

--self.missionState = 1
--end
--end
--end