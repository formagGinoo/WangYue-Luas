Behavior20007 = BaseClass("Behavior20007",EntityBehaviorBase)
--竞速挑战
function Behavior20007.GetGenerates()
	local generates = {900040,910040}
	return generates
end

function Behavior20007:Init()
	self.me = self.instanceId
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
	self.timeLimit = 90		--关卡时间上限(秒)
	self.time = 0			--当前关卡时间
	self.bonusTime = 0		--奖励时间

	--怪物信息参数
	self.monsterList =
	{
		[1] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c1_mb1_1",entityId = 900040},
		[2] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c1_mb1_2",entityId = 900040},
		[3] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c1_mb1_3",entityId = 900040},
		[4] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c1_mb2_1",entityId = 900040},
		[5] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c1_mb2_2",entityId = 900040},
		[6] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c1_mb2_3",entityId = 900040},
		[7] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c1_Center",entityId = 910040},
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
	
	--显示路标
	self.showSelf = true
	
	--距离警告
	self.distanceWarning = false
	--距离范围
	self.warninDistance = 20
	--警告时间
	self.warningEndTime = nil
	--警告时长(秒)
	self.warningTime = 8
end


function Behavior20007:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--路牌的显隐
	if self.showSelf == false then
		if not BehaviorFunctions.HasBuffKind(self.me,200000101) then
			BehaviorFunctions.AddBuff(self.me,self.me,200000101)
		end
	else
		if BehaviorFunctions.HasBuffKind(self.me,200000101) then
			BehaviorFunctions.RemoveBuff(self.me,200000101)
		end
	end

	if self.missionState == 0  then

		self.missionState = 1

	elseif self.missionState == 1 then
		self.missionState = 2
	end

	--挑战过程中
	if self.challengeStart == true and self.challengeSuccece == nil then
		--自动补充怪物数量
		self:SummonMonster(self.monsterList,3)
		--如果返回true代表时间内挑战成功，如果返回false则代表时间超时
		local allMonsterHasBeenKilled = self:KillAllMonsterChallenge(self.monsterList)
		local result = self:TimeLimitChallange(self.startTime,self.timeLimit,allMonsterHasBeenKilled)
		if result == true then
			self.challengeSuccece = true
		elseif result == false then
			self.challengeSuccece = false
		end
		
		--检查距离是否卸载
		local dis = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
		if dis > self.warninDistance then
			if self.distanceWarning == false then
				BehaviorFunctions.ShowTip(31000000,self.warningTime)
				self.warningEndTime = BehaviorFunctions.GetFightFrame() + self.warningTime *30
				self.distanceWarning = true
			else
				local warningRemainFrame = self.warningEndTime - self.time
				if warningRemainFrame ~= 0 then
					local warningRemainSecond = math.ceil(warningRemainFrame/30)
					BehaviorFunctions.ShowTip(31000000,warningRemainSecond)
				else
					--挑战结束
					self.challengeSuccece = false
				end
			end
		else
			if self.distanceWarning == true then
				BehaviorFunctions.HideTip(31000000)
				BehaviorFunctions.ShowTip(30000001)
				BehaviorFunctions.ChangeSubTipsDesc(1,30000001,#self.monsterList - self.monsterDead)
				self.distanceWarning = false
			end
		end
	end

	--挑战结束
	if self.challengeSuccece ~= nil and self.challengeEnd == false then
		if self.challengeSuccece == true then
			BehaviorFunctions.InteractEntityHit(self.me, false)
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
		if self.distanceWarning == true then
			BehaviorFunctions.HideTip(31000000)
		end
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

function Behavior20007:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		self:ChallengeStart("击败所有敌人")
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId) --移除
	end
end

function Behavior20007:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.showSelf then
		if self.isTrigger then
			return
		end

		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end

		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Talk,nil,"开启挑战", 1)
	end
end


function Behavior20007:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.showSelf then
		if self.isTrigger and triggerInstanceId == self.me then
			self.isTrigger = false
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		end
	end
end

--清理战场
function Behavior20007:ResetBattle(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.RemoveEntity(monsterList[i].Id)
		end
		v.state = self.monsterStateEnum.Default
	end
end

--召唤敌人
function Behavior20007:SummonMonster(monsterList,monsterNumLimit)
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
function Behavior20007:KillAllMonsterChallenge(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state ~= self.monsterStateEnum.Dead then
			return false
		end
	end
	return true
end

--时间限制检查（condition如果为true代表挑战内容成功）
function Behavior20007:TimeLimitChallange(startTime,timeLimit,condiTion,showTimeRemain)
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
function Behavior20007:BounsTime(bonusTime)
	self.bonusTime = self.bonusTime + bonusTime
end

--挑战开始
function Behavior20007:ChallengeStart(challangeName)
	--开始挑战
	self.challengeStart = true
	self.startTime = BehaviorFunctions.GetFightFrame()
	self.showSelf = false
	BehaviorFunctions.ShowCommonTitle(4,challangeName,true)
	BehaviorFunctions.ShowTip(30000001)
	BehaviorFunctions.ChangeSubTipsDesc(1,30000001,#self.monsterList)
end

--挑战结束
function Behavior20007:ChallengeFinish(challangeName,isSuccese)
	BehaviorFunctions.HideTip()
	self.showSelf = true
	if isSuccese then
		BehaviorFunctions.ShowCommonTitle(5,challangeName,true)
	elseif not isSuccese then
		self.isTrigger = false
		BehaviorFunctions.ShowCommonTitle(5,challangeName,false)
	end
end

function Behavior20007:Die(attackInstanceId,instanceId)
	--for i,v in ipairs(self.monsterList) do
		--if instanceId == v.Id then
			--v.state = self.monsterStateEnum.Dead
			--self.monsterDead = self.monsterDead + 1
			--local totalMonster = #self.monsterList - self.monsterDead
			--BehaviorFunctions.ChangeSubTipsDesc(1,30000001,totalMonster)
		--end
	--end
end

function Behavior20007:Death(instanceId,isFormationRevive)
	--角色死亡判负
	if isFormationRevive then
		self.challengeSuccece = false
	end
	--怪物死亡计数
	for i,v in ipairs(self.monsterList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
			self.monsterDead = self.monsterDead + 1
			local totalMonster = #self.monsterList - self.monsterDead
			BehaviorFunctions.ChangeSubTipsDesc(1,30000001,totalMonster)
		end
	end
end

function Behavior20007:BeDodge(attackInstanceId,hitInstanceId,limit)
	if hitInstanceId == self.role and limit == true then
		self:BounsTime(3)
	end
end
