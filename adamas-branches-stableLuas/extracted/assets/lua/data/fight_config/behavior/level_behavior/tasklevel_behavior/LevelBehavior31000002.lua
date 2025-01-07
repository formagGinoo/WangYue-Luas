LevelBehavior31000002 = BaseClass("LevelBehavior31000002",LevelBehaviorBase)
--限时击杀怪物玩法
function LevelBehavior31000002:__init(fight)
	self.fight = fight
end


function LevelBehavior31000002.GetGenerates()
	local generates = {900040,910040}
	return generates
end


function LevelBehavior31000002:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	
	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	--关卡挑战参数	
	--关卡时间参数
	self.timeLimit = 70		--关卡时间上限(秒)
	self.time = 0			--当前关卡时间
	self.bonusTime = 0		--奖励时间
	
	--怪物信息参数
	self.monsterList = 
	{
		[1] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c2_mb1_1",entityId = 900040},
		[2] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c2_mb1_2",entityId = 900040},
		[3] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c2_mb1_3",entityId = 900040},
		[4] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c2_mb2_1",entityId = 900040},
		[5] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c2_mb2_2",entityId = 900040},
		[6] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c2_mb2_3",entityId = 900040},
		[7] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c2_Center",entityId = 910040},
	}
	
	--怪物死亡数量
	self.monsterDead  = 0
	--自动填充怪物上限
	self.monsterLimit = 3
	--挑战引导标志
	self.guideMark = nil
	--交互实体ID
	self.interactUniqueId = nil
	--交互是否开启
	self.isTrigger = nil
	--挑战是否开启
	self.challengeStart = false
	--挑战是否结束
	self.challengeEnd = false
	--记录挑战开始的时间
	self.startTime = nil
	--挑战是否成功
	self.challengeSuccece = nil
end

function LevelBehavior31000002:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0  then

		self.missionState = 1
		
	elseif self.missionState == 1 then
		--开始挑战
		self.challengeStart = true
		self.missionState = 2
	end
	
	--挑战开始
	if self.challengeStart == true and self.challengeSuccece == nil then
		--自动补充怪物数量
		self:SummonMonster(self.monsterList,3)
		--如果返回true代表时间内挑战成功，如果返回false则代表时间超时
		local allMonsterHasBeenKilled = self:KillAllMonsterChallenge(self.monsterList)
		local result = self:TimeLimitChallange(self.startTime,self.timeLimit,allMonsterHasBeenKilled,true)
		if result == true then
			self.challengeSuccece = true
		elseif result == false then
			self.challengeSuccece = false
		end
	end
	
	--挑战结束
	if self.challengeSuccece ~= nil and self.challengeEnd == false then
		if self.challengeSuccece == true then
			self:ChallengeFinish("限时击杀敌人",true)
			self.challengeEnd = true
		elseif self.challengeSuccece == false then
			self:ChallengeFinish("限时击杀敌人",false)
			self.challengeEnd = true
		end		
	end
	
	--重置挑战
	if self.challengeEnd == true then
		self:ResetBattle(self.monsterList)
		self.missionState = 1
		BehaviorFunctions.HideTip()
		--挑战是否开启
		self.challengeStart = false
		--挑战是否结束
		self.challengeEnd = false
		--重置挑战结果
		self.challengeSuccece = nil
		--重置bonusTime
		self.bonusTime = 0
		--重置怪物死亡数量
		self.monsterDead  = 0
	end
end

--清理战场
function LevelBehavior31000002:ResetBattle(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.RemoveEntity(monsterList[i].Id)
		end
		v.state = self.monsterStateEnum.Default
	end
end

--召唤敌人
function LevelBehavior31000002:SummonMonster(monsterList,monsterNumLimit)
	local currentMonsterNum = 0
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			currentMonsterNum = currentMonsterNum + 1
		end
	end
	if currentMonsterNum < monsterNumLimit then
		local needRefill = monsterNumLimit - currentMonsterNum
		for i = 1,needRefill do
			for i,v in ipairs(monsterList) do
				if v.state == self.monsterStateEnum.Default then
					local pos = BehaviorFunctions.GetTerrainPositionP(monsterList[i].bp,self.levelId,"Logic10020001_Eco1")
					monsterList[i].Id = BehaviorFunctions.CreateEntity(monsterList[i].entityId,nil,pos.x,pos.y,pos.z)
					monsterList[i].state = self.monsterStateEnum.Live
					BehaviorFunctions.DoLookAtTargetImmediately(monsterList[i].Id,self.role)
					--关闭警戒
					BehaviorFunctions.SetEntityValue(monsterList[i].Id,"haveWarn",false)
					break
				end
			end
		end
	end
end

--击杀全部怪物挑战检查
function LevelBehavior31000002:KillAllMonsterChallenge(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state ~= self.monsterStateEnum.Dead then
			return false
		end
	end
	return true
end

--时间限制检查（condition如果为true代表挑战内容成功）
function LevelBehavior31000002:TimeLimitChallange(startTime,timeLimit,condiTion,showTimeRemain)
	local time = BehaviorFunctions.GetFightFrame()
	local targetTime = startTime + timeLimit * 30 + self.bonusTime * 30
	local remainTime = math.ceil((targetTime - time) / 30)
	--只要挑战条件还未达成就会一直检测
	if time >= targetTime then
		return false
	else
		--如果条件还未完成
		if condiTion == true then
			return true
		end
		BehaviorFunctions.ChangeSubTipsDesc(2,30000001,remainTime)
		if showTimeRemain == true then
			BehaviorFunctions.ShowTip(30000000,remainTime)
		end
	end
end

--额外时长奖励
function LevelBehavior31000002:BounsTime(bonusTime)
	self.bonusTime = self.bonusTime + bonusTime
end

--挑战开始
function LevelBehavior31000002:ChallengeStart(challangeName)
	BehaviorFunctions.ShowCommonTitle(4,challangeName,true)
	BehaviorFunctions.ShowTip(30000001)
	BehaviorFunctions.ChangeSubTipsDesc(1,30000001,#self.monsterList)
end

--挑战结束
function LevelBehavior31000002:ChallengeFinish(challangeName,isSuccese)
	if isSuccese then
		BehaviorFunctions.ShowCommonTitle(5,challangeName,true)
	elseif not isSuccese then
		BehaviorFunctions.ShowCommonTitle(5,challangeName,false)
	end
end

function LevelBehavior31000002:Die(attackInstanceId,instanceId)
	for i,v in ipairs(self.monsterList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
			self.monsterDead = self.monsterDead + 1
			local totalMonster = #self.monsterList - self.monsterDead
			BehaviorFunctions.ChangeSubTipsDesc(1,30000001,totalMonster)
		end
	end
end

function LevelBehavior31000002:Death(instanceId,isFormationRevive)
	--角色死亡判负
	if isFormationRevive then
		self.challengeSuccece = false
	end
end

function LevelBehavior31000002:BeDodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.role and limit == true then
		self:BounsTime(3)
	end
end

--死亡事件
function LevelBehavior31000002:RemoveEntity(instanceId)

end


function LevelBehavior31000002:__delete()

end