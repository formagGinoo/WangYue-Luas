LevelBehavior200100106 = BaseClass("LevelBehavior200100106",LevelBehaviorBase)
--fight初始化
function LevelBehavior200100106:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior200100106.GetGenerates()
	local generates = {910024,910025,900020,900021,900022,900023}
	return generates
end

--UI预加载
function LevelBehavior200100106.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior200100106:Init()
	self.monsters = {}
	self.missionState = 0   --关卡流程
	self.wave = 0           --波数计数
	self.time = 0		    --世界时间
	self.timeStart = 0      --记录时间
	--关卡流程初始化
	self:LevelInit()
	--分组参数
	self.monstersGroup = {}
	self.groupTime = { Time = 0 , Mark = 0 }
end
--帧事件
function LevelBehavior200100106:Update()
	self.wave1Count = self:WaveCount(1)
	self.wave2Count = self:WaveCount(2)
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetFightFrame()
	if self.missionState == 0 and self.time > 9*30 then
		self:CreatMonster({
				{id = 910024 ,posName = "mb301",lookatposName = "s3",wave = 1},
			})
		self.timeStart = self.time
		local posP = BehaviorFunctions.GetTerrainPositionP("mb301")
		BehaviorFunctions.SetGuide(10010502,posP.x,posP.y,posP.z)
		self.missionState = 5
	end	
	if self.missionState == 5 then
		if BehaviorFunctions.GetDistanceFromTarget(self.role,self.monsters[1].instanceId) < 5 then
			BehaviorFunctions.CancelGuide()
			BehaviorFunctions.ShowTip(1003001)
			self:CreatMonster({
					{id = 910025 ,posName = "mb302",lookatposName = "s3",wave = 1},
				})
			--self:MonsterGroup(self.monstersGroup,1,self.monsters[2].instanceId,self.monsters[1].instanceId)
			self.missionState = 10
		end
	end
	
	if self.missionState == 10 and self.time - self.timeStart >= 3*30 then
		--self:MonsterGroupAttack(self.monstersGroup,1,5,1)
		if self.wave1Count == 0 then
			self.missionState = 20
		end
	end
	if self.missionState == 20 then

			self.missionState = 30
		self.timeStart =self.time
	end
	
	if self.missionState == 30 and self.time - self.timeStart >=1*30 then
		local canshu = 3
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 31
	end
	if self.missionState == 31 and self.time - self.timeStart >=1*30 then
		local canshu = 2
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 32
	end
	if self.missionState == 32 and self.time - self.timeStart >=1*30 then
		local canshu = 1
		BehaviorFunctions.ShowTip(1106,canshu)
		self.timeStart =self.time
		self.missionState = 33
	end
	if self.missionState == 33 and self.time - self.timeStart >=1*30 then
		BehaviorFunctions.SetFightResult(true)
		self.missionState = 999
	end
end



--死亡事件
function LevelBehavior200100106:Death(instanceId)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
		end
	end
	if instanceId == self.role then
		BehaviorFunctions.SetFightResult(false)
	end
end

--刷怪
function LevelBehavior200100106:CreatMonster(monsterList)
	local MonsterId = 0
	for a = #monsterList,1,-1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z)
			table.insert(self.monsters,{wave =monsterList[a].wave,instanceId =MonsterId})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName)
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
			table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId})
		end
	end
	table.sort(self.monsters,function(a,b)
			if a.wave < b.wave then
				return true
			elseif a.wave == b.wave then
				if a.instanceId < b.instanceId then
					return true
				end
			end
		end)
end

function LevelBehavior200100106:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--关卡初始化
function LevelBehavior200100106:LevelInit()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local Born2 = BehaviorFunctions.GetTerrainPositionP("Born2")
	local s1 = BehaviorFunctions.GetTerrainPositionP("s1")
	BehaviorFunctions.SetPlayerBorn(Born2.x,Born2.y,Born2.z)	--角色位置
	BehaviorFunctions.DoLookAtPositionImmediately(self.role,s1.x,nil,s1.z)
	BehaviorFunctions.InitCameraAngle(0)
end


function LevelBehavior200100106:__delete()

end


--创造怪物组
function LevelBehavior200100106:MonsterGroup(MonsterGroup,GroupID,...)
	if MonsterGroup then
		if GroupID then
			local GroupMember = {}
			for i ,v in ipairs{...} do
				GroupMember[i] = v
				MonsterGroup[GroupID] = GroupMember
				--所有成员进入待命状态
				BehaviorFunctions.SetEntityValue(v,"GroupSkill",0)
			end
		elseif GroupID == nil then
			LogError("[警告]至少需要输入一个组ID")
		end
	elseif MonsterGroup == nil then
		LogError("[警告]至少需要输入一个怪物组和组ID")
	end
end

--给组中的怪物发送信号
function LevelBehavior200100106:MonsterGroupAttack(MonsterGroup,GroupID,Frequency,AttackNum)
	--怪物组，组ID，频率（多少秒攻击一次），同时攻击数量
	--频率和数量为可缺省参数,默认5秒一次
	if Frequency == nil then
		Frequency = 5
	end
	if AttackNum == nil then
		AttackNum = 1
	end
	if MonsterGroup then
		if GroupID then
			self:CheckGroup(MonsterGroup)
			local state = self:CheckGroupAttackState(MonsterGroup,GroupID)
			--检测所有人是否处于待命状态，若是
			if state == true then
				local MonInGroup = {}
				local MonInGroupNum = 0
				local MonNum = #MonsterGroup[GroupID]
				local Attackers = {}
				if self.groupTime.Mark ~= 0 then
					self.groupTime.Time = BehaviorFunctions.GetFightFrame()
					self.groupTime.Mark = 0
				end
				--若所填的数量超过组内怪物最大数量，则按最大数量进行攻击
				if AttackNum > MonNum then
					AttackNum = MonNum
				end
				--将目前允许组攻击的怪物清点出来
				for i,v in ipairs(MonsterGroup[GroupID]) do
					if BehaviorFunctions.GetEntityValue(v,"canGroup") == true  then
						MonInGroup[i] = v
					end
				end
				MonInGroupNum = #MonInGroup
				if MonInGroupNum ~= 0 then
					--随机选出组内本次进行攻击的怪物
					for i = 1, AttackNum do
						local MonInGroupNum = #MonInGroup
						local RandomM = MonInGroup[math.random(1,MonInGroupNum)]
						Attackers[i] = RandomM
					end
					if self.time - self.groupTime.Time >= Frequency*30 then
						--给允许攻击的怪物发送可攻击信号
						for i,v in ipairs(Attackers)  do
							if BehaviorFunctions.CheckEntity(v) ~= false then
								BehaviorFunctions.SetEntityValue(v,"GroupSkill",1)
								self.groupTime.Mark = 1
								--LogError("Attacker InstanID:",v)
							end
						end
					end
				end
			end
		elseif GroupID == nil then
			LogError("[警告]至少需要输入一个组ID")
		end
	elseif MonsterGroup == nil then
		LogError("[警告]至少需要输入一个怪物组和组ID")
	end
end

--检测实体的生死状态
function LevelBehavior200100106:CheckGroup(MonsterGroup)
	local GroupNum = #MonsterGroup
	--检测怪物组总量，检测组总量内的实体总量
	for GroupIndex = 1, GroupNum do
		local CurrentGroup = MonsterGroup[GroupIndex]
		local AttackState = 0
		--若实体检查不到，则移除出去
		for Index,MonIns in pairs(CurrentGroup) do
			if BehaviorFunctions.CheckEntity(MonIns) == false then
				table.remove(MonsterGroup[GroupIndex],Index)
			end
		end
	end
end

--检测实体的组攻击状态
function LevelBehavior200100106:CheckGroupAttackState(MonsterGroup,GroupID)
	local GMGSstate = {}
	local Search = 0
	local GSstate = 0
	if Search == 0 then
		for i,v in pairs(MonsterGroup[GroupID]) do
			if BehaviorFunctions.CheckEntity(v) ~= false then
				GSstate = BehaviorFunctions.GetEntityValue(v,"GroupSkill")
				GMGSstate[i] = GSstate
			end
		end
		Search = 1
	end
	if Search == 1 then
		for i,v in pairs(GMGSstate) do
			if v == 1 then
				return false
			end
		end
		return true
	end
end