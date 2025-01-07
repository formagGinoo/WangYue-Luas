LevelBehavior30000003 = BaseClass("LevelBehavior30000003",LevelBehaviorBase)
--限时击杀怪物玩法
function LevelBehavior30000003:__init(fight)
	self.fight = fight
end


function LevelBehavior30000003.GetGenerates()
	local generates = {900040,910040,2030401}
	return generates
end


function LevelBehavior30000003:Init()
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
		[1] = {state = self.monsterStateEnum.Default,wave = 1,bp = "mb1_1",entityId = 900040},
		[2] = {state = self.monsterStateEnum.Default,wave = 1,bp = "mb1_2",entityId = 900040},
		[3] = {state = self.monsterStateEnum.Default,wave = 1,bp = "mb1_3",entityId = 900040},
		[4] = {state = self.monsterStateEnum.Default,wave = 1,bp = "mb2_1",entityId = 900040},
		[5] = {state = self.monsterStateEnum.Default,wave = 1,bp = "mb2_2",entityId = 900040},
		[6] = {state = self.monsterStateEnum.Default,wave = 1,bp = "mb2_3",entityId = 900040},
		[7] = {state = self.monsterStateEnum.Default,wave = 1,bp = "Center",entityId = 910040},
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

function LevelBehavior30000003:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0  then
		--创建玩家出生点
		local pos = BehaviorFunctions.GetTerrainPositionP("characterBorn",30000003)
		BehaviorFunctions.DoSetPosition(self.role,pos.x,pos.y,pos.z)

		--关卡玩法引导
		BehaviorFunctions.ShowGuideImageTips(30003)
		
		local pos2 = BehaviorFunctions.GetTerrainPositionP("Center",30000003)
		self.robot = BehaviorFunctions.CreateEntity(2030401,nil,pos2.x,pos2.y,pos2.z)
		self.missionState = 1

	elseif self.missionState == 1 then
		--创建挑战指引实体
		local pos2 = BehaviorFunctions.GetTerrainPositionP("Center",30000003)
		self.guideMark = BehaviorFunctions.CreateEntity(200000108,nil,pos2.x,pos2.y,pos2.z)

		--玩家和镜头看向指引实体
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.guideMark)
		self:LevelLookAtPos("Center",22001,30,"CameraTarget")
		self.missionState = 2
	end

	--挑战开始
	if self.challengeStart == true and self.challengeSuccece == nil then
		--怪物仇恨
		self:ChangeTarget(self.monsterList)
		--自动补充怪物数量
		self:SummonMonster(self.monsterList,3)
		--如果返回true代表时间内挑战成功，如果返回false则代表时间超时
		local robothasBeenKilled = self:ProtectChallenge(self.robot)
		if robothasBeenKilled ~= false then
			BehaviorFunctions.ChangeSubTipsDesc(2,30000003,robothasBeenKilled/100 .. "%")
		else
			self.challengeSuccece = false
		end

		local result = self:TimeLimitChallange(self.startTime,self.timeLimit,robothasBeenKilled)
		if result == false then
			self.challengeSuccece = true
		elseif result == true then
			self.challengeSuccece = false
		end
	end

	--挑战结束
	if self.challengeSuccece ~= nil and self.challengeEnd == false then
		if self.challengeSuccece == true then
			self:ChallengeFinish("保护机器人入侵",true)
			self.challengeEnd = true
		elseif self.challengeSuccece == false then
			self:ChallengeFinish("保护机器人入侵",false)
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

function LevelBehavior30000003:ChangeTarget(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			if BehaviorFunctions.CheckEntity(self.robot) then
				BehaviorFunctions.SetEntityValue(monsterList[i].Id,"battleTarget",self.robot)
			else
				BehaviorFunctions.SetEntityValue(monsterList[i].Id,"battleTarget",self.role)
			end
		end
	end
end

--清理战场
function LevelBehavior30000003:ResetBattle(monsterList)
	for i,v in ipairs(monsterList) do
		if v.state == self.monsterStateEnum.Live then
			BehaviorFunctions.RemoveEntity(monsterList[i].Id)
		end
		v.state = self.monsterStateEnum.Default
	end
end

--召唤敌人
function LevelBehavior30000003:SummonMonster(monsterList,monsterNumLimit)
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
					local pos = BehaviorFunctions.GetTerrainPositionP(monsterList[i].bp,self.levelId)
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
function LevelBehavior30000003:ProtectChallenge(instanceId)
	local lifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(instanceId,1001)
	if lifeRatio == 0 then
		return false
	else
		return lifeRatio
	end
end

--时间限制检查（condition如果为true代表挑战内容成功）
function LevelBehavior30000003:TimeLimitChallange(startTime,timeLimit,condiTion)
	local time = BehaviorFunctions.GetFightFrame()
	local targetTime = startTime + timeLimit * 30 + self.bonusTime * 30
	local remainTime = math.ceil((targetTime - time) / 30)
	local duration = 100 - math.ceil((remainTime / timeLimit) * 100)
	--只要挑战条件还未达成就会一直检测
	if time >= targetTime then
		return false
	else
		--如果条件还未完成
		if condiTion == true then
			return true
		end
		BehaviorFunctions.ChangeSubTipsDesc(1,30000003,duration .. "%")
	end
end

--额外时长奖励
function LevelBehavior30000003:BounsTime(bonusTime)
	self.bonusTime = self.bonusTime + bonusTime
end

--挑战开始
function LevelBehavior30000003:ChallengeStart(challangeName)
	BehaviorFunctions.ShowCommonTitle(4,challangeName,true)
	BehaviorFunctions.ShowTip(30000003)
	BehaviorFunctions.ChangeSubTipsDesc(1,30000003,#self.monsterList)
end

--挑战结束
function LevelBehavior30000003:ChallengeFinish(challangeName,isSuccese)
	if isSuccese then
		BehaviorFunctions.ShowCommonTitle(5,challangeName,true)
	elseif not isSuccese then
		BehaviorFunctions.ShowCommonTitle(5,challangeName,false)
	end
end

function LevelBehavior30000003:Die(attackInstanceId,instanceId)
	for i,v in ipairs(self.monsterList) do
		if instanceId == v.Id then
			v.state = self.monsterStateEnum.Dead
			self.monsterDead = self.monsterDead + 1
			local totalMonster = #self.monsterList - self.monsterDead
			BehaviorFunctions.ChangeSubTipsDesc(1,30000003,totalMonster)
		end
	end
end

function LevelBehavior30000003:Death(instanceId,isFormationRevive)
	--角色死亡判负
	if isFormationRevive then
		self.challengeSuccece = false
	end
end

function LevelBehavior30000003:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.RemoveEntity(self.guideMark)
		self.startTime = BehaviorFunctions.GetFightFrame()
		self.challengeStart = true
		self:ChallengeStart("保护机器人入侵")
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId) --移除
	end
end


function LevelBehavior30000003:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return
	end

	self.isTrigger = triggerInstanceId == self.guideMark
	if not self.isTrigger then
		return
	end

	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Talk,nil,"开启入侵", 1)
end


function LevelBehavior30000003:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.guideMark then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

function LevelBehavior30000003:LevelLookAtPos(pos,type,frame,bindTransform)
	local fp1 = BehaviorFunctions.GetTerrainPositionP(pos,30000003)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end

--死亡事件
function LevelBehavior30000003:RemoveEntity(instanceId)

end


function LevelBehavior30000003:__delete()

end