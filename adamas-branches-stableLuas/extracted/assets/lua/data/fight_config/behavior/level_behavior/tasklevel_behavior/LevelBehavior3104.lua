LevelBehavior3104 = BaseClass("LevelBehavior3104",LevelBehaviorBase)

function LevelBehavior3104.GetGenerates()
	local generates = {900040,910040}
	return generates
end

function LevelBehavior3104:__init(fight)
	self.fight = fight
end

function LevelBehavior3104:Init()	
	
-------------------基础参数----------------------
	self.role = nil	
	self.missionState = 0	
	self.monsterListInfo = {}

-------------------刷怪列表----------------------
	self.monsterList =
	{
		{id = 900040 ,posName = "Mb1" ,wave = 1},
		{id = 900040 ,posName = "Mb1" ,wave = 1},
		{id = 910040 ,posName = "Mb1" ,wave = 2},
	}

-------------------通用关卡函数引用----------------------
	self.LevelCommon = BehaviorFunctions.CreateBehavior("LevelCommonFunction",self)
	self.LevelCommon.levelId = self.levelId
	
	--怪物世界等级偏移
	self.LevelCommon.monsterLevelBias =
	{
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
end

function LevelBehavior3104:LateInit()
	
end
	
function LevelBehavior3104:Update()
	self.LevelCommon:Update()
	
	if self.missionState == 0 then
		self.cam = self.LevelCommon:LevelCameraLookAtPos(22002,-1,nil,"Mb1",10,10)
		----设置为挑战关卡
		--self.LevelCommon:SetAsChallengeLevel("击败所有怪物")				
		----开启关卡
		--self.LevelCommon:LevelStart()
		----创建怪物
		--self.monsterListInfo = self.LevelCommon:LevelCreateMonster(self.monsterList)
		----开启剩余敌人数量显示
		--self.LevelCommon:ShowEnemyRemainTips(true)
		----开启敌人波数显示
		--self.LevelCommon:ShowWaveTips(true)	
		self.missionState = 1
		
	elseif self.missionState == 1 then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Jump) then
			self.LevelCommon:RemoveLevelCamera(self.cam)
		end
		
		----获取该怪物组内怪物是否都死亡
		--local result1 = self.LevelCommon:SuccessCondition_DefeatAllEnemy(self.monsterListInfo)		
		----获取自定义胜利条件是否满足
		--local result2 = self:CustomSuccessCondition1()
		----将上述条件作为胜利条件
		--self.LevelCommon:LevelSucceceCondition(result1,result2)
		
		----失败条件：超出距离
		--local result2 = self.LevelCommon:FailCondition_Distance("Mb1",10,10)
		----失败条件：超出时间限制
		--local result3 = self.LevelCommon:FailCondition_TimeLimit(10)
		----将上述条件作为失败条件
		--self.LevelCommon:LevelFailCondition(result2,result3)
	end 
end

----自定义胜利条件
--function LevelBehavior3104:CustomSuccessCondition1()
	--if 达成条件 then
		--return true
	--elseif 没有达成条件
		--return false
	--end
--end

----自定义失败条件
--function LevelBehavior3104:CustomSuccessCondition2()
	--if 达成条件 then
		--return true
	--elseif 没有达成条件
		--return false
	--end
--end








