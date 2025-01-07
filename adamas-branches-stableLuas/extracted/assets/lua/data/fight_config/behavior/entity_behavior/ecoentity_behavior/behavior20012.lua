Behavior20012 = BaseClass("Behavior20012",EntityBehaviorBase)
--输出窗口挑战

function Behavior20012.GetGenerates()
	local generates = {900040,910040}
	return generates
end

function Behavior20012:Init()
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
	self.buffTime = 3
	self.damageCycle = 15
	
	--关卡控制参数
	self.flag1 = true
	self.delayCallId = 0
	--怪物信息参数
	self.monsterList =
	{
		[1] = {Id = nil,state = self.monsterStateEnum.Default,effectId = nil,bp = "c6_mb1_1",entityId = 900040},
		[2] = {Id = nil,state = self.monsterStateEnum.Default,effectId = nil,bp = "c6_mb1_2",entityId = 900040},
		[3] = {Id = nil,state = self.monsterStateEnum.Default,effectId = nil,bp = "c6_mb1_3",entityId = 900040},
		[4] = {Id = nil,state = self.monsterStateEnum.Default,effectId = nil,bp = "c6_mb2_1",entityId = 900040},
		[5] = {Id = nil,state = self.monsterStateEnum.Default,effectId = nil,bp = "c6_mb2_3",entityId = 910040},
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


function Behavior20012:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0  then

		self.missionState = 1

	elseif self.missionState == 1 then
		self.missionState = 2
	end
	
	--挑战过程中
	if self.challengeStart == true and self.challengeSuccece == nil then
		--自动补充怪物数量
		self:SummonMonster(self.monsterList,3)
		
		--周期执行遍历怪物列表加无敌
		if self.flag1 == true then
			self.flag1 = false
			local alivemon = 0
			for i,v in pairs(self.monsterList) do	
				if v.state == self.monsterStateEnum.Live then
					alivemon = alivemon + 1
				end
			end
			if alivemon > 0 then
				self.delayCallId = BehaviorFunctions.AddDelayCallByTime(self.damageCycle,self,self.CycleBuff,self.monsterList)
			end
		end
		
		--击杀全部怪物则挑战成功
		local allMonsterHasBeenKilled = self:KillAllMonsterChallenge(self.monsterList)
		if allMonsterHasBeenKilled == true then
			self.challengeSuccece = true
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
				BehaviorFunctions.ShowTip(30000006)
				BehaviorFunctions.ChangeSubTipsDesc(1,30000006,#self.monsterList - self.monsterDead)
				self.distanceWarning = false
			end
		end
	end

	--挑战结束
	if self.challengeSuccece ~= nil and self.challengeEnd == false then
		BehaviorFunctions.RemoveDelayCall(self.delayCallId)
		if self.challengeSuccece == true then
			BehaviorFunctions.InteractEntityHit(self.me, false)
			self:ChallengeFinish("输出窗口挑战",true)
			--挑战成功后创建宝箱
			BehaviorFunctions.ChangeEcoEntityCreateState(2002060004,true)
			self.challengeEnd = true
		elseif self.challengeSuccece == false then
			self:ChallengeFinish("输出窗口挑战",false)
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
		--重置怪物死亡数量
		self.monsterDead  = 0
		--重置受击次数
		self.hitTimes = self.hitTimesLimit
		--重置闪避成功次数
		self.dodgeTimes = 0
		--重置周期执行开关
		self.flag1 = true
	end
end

function Behavior20012:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		self:ChallengeStart("输出窗口挑战")
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId) --移除
	end
end

function Behavior20012:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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


function Behavior20012:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.showSelf then
		if self.isTrigger and triggerInstanceId == self.me then
			self.isTrigger = false
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		end
	end
end

--清理战场
function Behavior20012:ResetBattle(monsterList)
	for i,v in pairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.RemoveEntity(monsterList[i].Id)
		end
		v.state = self.monsterStateEnum.Default
	end
end

--召唤敌人
function Behavior20012:SummonMonster(monsterList,monsterNumLimit)
	local currentMonsterNum = 0
	--local flag = false
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
					local pos = BehaviorFunctions.GetTerrainPositionP(monsterList[i].bp,self.levelId,"World10020001_WoOChallenge")
					monsterList[i].Id = BehaviorFunctions.CreateEntity(monsterList[i].entityId,nil,pos.x,pos.y,pos.z)
					monsterList[i].state = self.monsterStateEnum.Live
					BehaviorFunctions.DoLookAtTargetImmediately(monsterList[i].Id,self.role)
					--关闭警戒
					BehaviorFunctions.SetEntityValue(monsterList[i].Id,"haveWarn",false)
					break
				end
			end
		end
		----无法完成时挑战失败
		--for i,v in pairs(monsterList) do
			--if v.state == self.monsterStateEnum.Default then
				--flag = true
				--break
			--end
		--end
		----无法补怪、怪物数量小于3时仍未完成则失败
		--if not flag and currentMonsterNum < 3 and self.aoeTimes < self.aoeTimesCon then
			--self.challengeSuccece = false
		--end
	end
end

--击杀全部怪物挑战检查
function Behavior20012:KillAllMonsterChallenge(monsterList)
	for i,v in pairs(monsterList) do
		if v.state ~= self.monsterStateEnum.Dead then
			return false
		end
	end
	return true
end

--挑战开始
function Behavior20012:ChallengeStart(challangeName)
	--开始挑战
	self.challengeStart = true
	self.startTime = BehaviorFunctions.GetFightFrame()
	self.showSelf = false
	BehaviorFunctions.ShowCommonTitle(4,challangeName,true)
	BehaviorFunctions.ShowTip(30000006)
	BehaviorFunctions.ChangeSubTipsDesc(1,30000006,#self.monsterList)
	--看向终点镜头
	local fp1 = BehaviorFunctions.GetTerrainPositionP("c6_mb1_1",10020001,"World10020001_WoOChallenge")
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam = BehaviorFunctions.CreateEntity(22002)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	--延时移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
	BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
end

--挑战结束
function Behavior20012:ChallengeFinish(challangeName,isSuccese)
	BehaviorFunctions.HideTip()
	self.showSelf = true
	if isSuccese then
		BehaviorFunctions.ShowCommonTitle(5,challangeName,true)
	elseif not isSuccese then
		self.isTrigger = false
		BehaviorFunctions.ShowCommonTitle(5,challangeName,false)
	end
end

function Behavior20012:Die(attackInstanceId,instanceId)
	for i,v in pairs(self.monsterList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
			self.monsterDead = self.monsterDead + 1
			local totalMonster = #self.monsterList - self.monsterDead
			BehaviorFunctions.ChangeSubTipsDesc(1,30000006,totalMonster)
		end
	end
end

function Behavior20012:Death(instanceId,isFormationRevive)
	--角色死亡判负
	if isFormationRevive then
		self.challengeSuccece = false
	end
end
			
function Behavior20012:CycleBuff(monsterList)
	for i,v in pairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.AddBuff(v.Id,v.Id,900000023)
			monsterList[i].effectId = BehaviorFunctions.CreateEntity(900000110,v.Id)
			BehaviorFunctions.AddDelayCallByTime(self.buffTime,BehaviorFunctions,BehaviorFunctions.RemoveBuff,v.Id,900000023)
			BehaviorFunctions.AddDelayCallByTime(self.buffTime,BehaviorFunctions,BehaviorFunctions.RemoveEntity,v.effectId)
		end
	end
	self.flag1 = true
end