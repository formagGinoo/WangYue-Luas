Behavior2030403 = BaseClass("Behavior2030403",EntityBehaviorBase)
--受击次数限制及闪避挑战

function Behavior2030403.GetGenerates()
	local generates = {900040,910040}
	return generates
end

function Behavior2030403:Init()
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
	self.damageTimes = 0   --受伤限制次数
	self.dodgeTimes = 0     --闪避成功次数
	
	--怪物信息参数
	self.monsterList =
	{
		[1] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c4_mb1_1",entityId = 900040},
		[2] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c4_mb1_2",entityId = 900040},
		[3] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c4_mb2_1",entityId = 900040},
		[4] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c4_mb2_2",entityId = 900040},
		[5] = {state = self.monsterStateEnum.Default,wave = 1,bp = "c4_mb3_1",entityId = 910040},
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
	--挑战是否成功
	self.challengeSuccece = nil
	
	--角色受击次数限制
	self.hitTimesLimit = 5
	
	--角色受击次数
	self.hitTimes = 0
	
	--角色闪避成功次数
	self.dodgeTimes = 0
	
	--角色闪避成功次数要求
	self.dodgeTimesCon = 1
	
	--显示路标
	self.showSelf = true
	
	--距离警告
	self.distanceWarning = false
	--距离范围
	self.warninDistance = 30
	--警告时间
	self.warningEndTime = nil
	--警告时长(秒)
	self.warningTime = 10
end


function Behavior2030403:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--路牌的显隐
	--if self.showSelf == false then
		--if not BehaviorFunctions.HasBuffKind(self.me,200000101) then
			--BehaviorFunctions.AddBuff(self.me,self.me,200000101)
		--end
	--else
		--if BehaviorFunctions.HasBuffKind(self.me,200000101) then
			--BehaviorFunctions.RemoveBuff(self.me,200000101)
		--end
	--end

	--if self.missionState == 0  then

		--self.missionState = 1

	--elseif self.missionState == 1 then
	
		--self.missionState = 2
	--end
	
	--挑战过程中
	if self.challengeStart == true and self.challengeSuccece == nil then
		--自动补充怪物数量
		self:SummonMonster(self.monsterList,3)
		
		--受击次数为0挑战失败
		if self.hitTimes >= self.hitTimesLimit then
			self.challengeSuccece = false
		end
		
		--击杀全部怪物后判断挑战成功/失败
		local allMonsterHasBeenKilled = self:KillAllMonsterChallenge(self.monsterList)
		if allMonsterHasBeenKilled == true then
			if self.dodgeTimes < self.dodgeTimesCon then
				self.challengeSuccece = false
			
			elseif self.hitTimes < self.hitTimesLimit and self.dodgeTimes >= self.dodgeTimesCon then
				self.challengeSuccece = true
			end
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
				BehaviorFunctions.ShowTip(30000005)
				BehaviorFunctions.ChangeSubTipsDesc(1,30000005,#self.monsterList - self.monsterDead)
				BehaviorFunctions.ChangeSubTipsDesc(3,30000005,self.hitTimes,self.hitTimesLimit)
				BehaviorFunctions.ChangeSubTipsDesc(4,30000005,self.dodgeTimes,self.dodgeTimesCon)
				self.distanceWarning = false
			end
		end
	end

	--挑战结束
	if self.challengeSuccece ~= nil and self.challengeEnd == false then
		if self.challengeSuccece == true then
			BehaviorFunctions.InteractEntityHit(self.me, false)
			self:ChallengeFinish("受击次数限制及闪避挑战",true)
			--挑战成功后创建宝箱
			BehaviorFunctions.ChangeEcoEntityCreateState(2002060084,true)
			self.challengeEnd = true
		elseif self.challengeSuccece == false then
			if self.hitTimes >= self.hitTimesLimit then
				self:ChallengeFinish("受击次数过多",false)
				self.challengeEnd = true
			elseif self.dodgeTimes < self.dodgeTimesCon then
				self:ChallengeFinish("闪避次数不足",false)
				self.challengeEnd = true
			end
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
		--重置怪物死亡数量
		self.monsterDead  = 0
		--重置受击次数
		self.hitTimes = 0
		--重置闪避成功次数
		self.dodgeTimes = 0
	end
end

function Behavior2030403:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		self:ChallengeStart("受击次数限制及闪避挑战")
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId) --移除
	end
end

function Behavior2030403:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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


function Behavior2030403:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.showSelf then
		if self.isTrigger and triggerInstanceId == self.me then
			self.isTrigger = false
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		end
	end
end

--清理战场
function Behavior2030403:ResetBattle(monsterList)
	for i,v in pairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.RemoveEntity(monsterList[i].Id)
		end
		v.state = self.monsterStateEnum.Default
	end
end

--召唤敌人
function Behavior2030403:SummonMonster(monsterList,monsterNumLimit)
	local currentMonsterNum = 0
	for i,v in pairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			currentMonsterNum = currentMonsterNum + 1
		end
	end
	if currentMonsterNum < monsterNumLimit then
		local needRefill = monsterNumLimit - currentMonsterNum
		for i = 1,needRefill do
			for i,v in pairs(monsterList) do
				if v.state == self.monsterStateEnum.Default then
					local pos = BehaviorFunctions.GetTerrainPositionP(monsterList[i].bp,self.levelId,"world10020001_shoujitiaozhan")
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

function Behavior2030403:Hit(attackInstanceId,hitInstanceId,hitType)
	--角色受伤计数
	if self.role == hitInstanceId then
		self.hitTimes = self.hitTimes + 1
		BehaviorFunctions.ChangeSubTipsDesc(3,30000005,self.hitTimes,self.hitTimesLimit)
	end
end

--击杀全部怪物挑战检查
function Behavior2030403:KillAllMonsterChallenge(monsterList)
	for i,v in pairs(monsterList) do
		if v.state ~= self.monsterStateEnum.Dead then
			return false
		end
	end
	return true
end

--挑战开始
function Behavior2030403:ChallengeStart(challangeName)
	--开始挑战
	self.challengeStart = true
	self.startTime = BehaviorFunctions.GetFightFrame()
	self.showSelf = false
	BehaviorFunctions.ShowCommonTitle(4,challangeName,true)
	BehaviorFunctions.ShowTip(30000005)
	BehaviorFunctions.ChangeSubTipsDesc(1,30000005,#self.monsterList)
	BehaviorFunctions.ChangeSubTipsDesc(3,30000005,self.hitTimes,self.hitTimesLimit)
	BehaviorFunctions.ChangeSubTipsDesc(4,30000005,self.dodgeTimes,self.dodgeTimesCon)
	--看向终点镜头
	local fp1 = BehaviorFunctions.GetTerrainPositionP("c4_mb1_2",10020001,"world10020001_shoujitiaozhan")
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22002)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

--挑战结束
function Behavior2030403:ChallengeFinish(challangeName,isSuccese)
	BehaviorFunctions.HideTip()
	self.showSelf = true
	if isSuccese then
		BehaviorFunctions.ShowCommonTitle(5,challangeName,true)
	elseif not isSuccese then
		self.isTrigger = false
		BehaviorFunctions.ShowCommonTitle(5,challangeName,false)
	end
end

function Behavior2030403:Die(attackInstanceId,instanceId)
	for i,v in pairs(self.monsterList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
			self.monsterDead = self.monsterDead + 1
			local totalMonster = #self.monsterList - self.monsterDead
			BehaviorFunctions.ChangeSubTipsDesc(1,30000005,totalMonster)
		end
	end
end

function Behavior2030403:Death(instanceId,isFormationRevive)
	--角色死亡判负
	if isFormationRevive then
		self.challengeSuccece = false
	end
end

function Behavior2030403:Dodge(attackInstanceId,hitInstanceId,limit)
	--角色闪避成功计数
	if self.dodgeTimes < self.dodgeTimesCon then
		if self.role == hitInstanceId then
			self.dodgeTimes = self.dodgeTimes + 1
			BehaviorFunctions.ChangeSubTipsDesc(4,30000005,self.dodgeTimes,self.dodgeTimesCon)
		end
	end
end