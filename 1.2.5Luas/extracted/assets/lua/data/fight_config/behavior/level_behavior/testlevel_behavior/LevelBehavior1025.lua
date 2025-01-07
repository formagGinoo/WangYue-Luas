LevelBehavior1025 = BaseClass("LevelBehavior1025",LevelBehaviorBase)
--fight初始化
function LevelBehavior1025:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior1025.GetGenerates()
	local generates = {900020,900021,900022,900023,910024,910025,900010}
	return generates
end

--参数初始化
function LevelBehavior1025:Init()
	self.role = 0           --当前角色
	self.Missionstate = 0   --关卡流程
	self.wave = 0
	self.Monsters = {
		Count = 0
	}
	self.MonstersGroup = {}
	self.GroupTime = {}

	self.time = 0		    --世界时间
	self.timestart = 0      --记录时间
end
	

--帧事件
function LevelBehavior1025:Update()
	--记录角色切换
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	self.time = BehaviorFunctions.GetFightFrame()
	--初始化，角色出生点
	if  self.Missionstate == 0 then
		self.entites = {}   --初始化self.entites表
		local pb1 = BehaviorFunctions.GetTerrainPositionP("PB1")
		BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)   --角色位置
		--BehaviorFunctions.DoSetPosition(self.role,28.97,21.6,16.42)   --角色位置
		
		self.timestart =BehaviorFunctions.GetFightFrame()

		self.Missionstate = 1
	end

	--关卡开始
	if self.Missionstate == 1 and self.time - self.timestart >= 90 then
		self.timestart =BehaviorFunctions.GetFightFrame()
		
		local mb1 = BehaviorFunctions.GetTerrainPositionP("MB1")
		
		local mon1 = BehaviorFunctions.CreateEntity(900020)
		self.Monsters[mon1] = mon1
		BehaviorFunctions .DoSetPosition(mon1,mb1.x,mb1.y,mb1.z)
		--BehaviorFunctions .DoSetPosition(mon1,30.38,21.03,4.58)
		
		self.Monsters.Count = self.Monsters.Count + 1
		
		
		self.Missionstate = 20
		
	end

	--战斗阶段
	if self.Missionstate == 20  and self.Monsters.Count ~= 0 then

	end
	
	if self.Missionstate == 20 and self.Monsters.Count == 0 then	
		BehaviorFunctions.SetFightResult(true)
		self.Missionstate = 30
	end
		
end

--死亡事件
function LevelBehavior1025:Death(instanceId)
	if self.Monsters[instanceId] then
		self.Monsters[instanceId] = nil
		self.Monsters.Count = self.Monsters.Count - 1
		self:CheckGroup(self.MonstersGroup)
	end
	
	if instanceId == self.role then
		BehaviorFunctions.SetFightResult(false)
	end
end


function LevelBehavior1025:__delete()

end

function LevelBehavior1025:CreatMonster(...)
	--MonsterNum,Monster1Id,Monster1PosX,Monster1PosY,Monster1PosZ,Monster2Id,Monster2PosX,Monster2PosY,Monster2PosZ...
	local i = 0
	local v = 0
	local MonsterIdnPos = {}
	local MId = 2
	local MPosX = 3
	local MPosY = 4
	local MPosZ = 5
	for i,v in ipairs{...} do
		MonsterIdnPos[i] = v
	end
	for a = 1,MonsterIdnPos[1] do
		local MonsterId = BehaviorFunctions.CreateEntity(MonsterIdnPos[MId])      --召怪,返回怪物实体id
		self.Monsters[MonsterId] = MonsterId
		BehaviorFunctions.DoSetPosition(MonsterId,MonsterIdnPos[MPosX],MonsterIdnPos[MPosY],MonsterIdnPos[MPosZ])
		MId = MId + 4
		MPosX = MPosX + 4
		MPosY = MPosY + 4
		MPosZ = MPosZ + 4
		--BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,1)
	end
	return MonsterIdnPos[1]
end

--创造怪物组
function LevelBehavior1025:MonsterGroup(MonsterGroup,GroupID,...)
	if MonsterGroup then
		if GroupID then
			local GroupMember = {}
			for i ,v in ipairs{...} do
				GroupMember[i] = v
				MonsterGroup[GroupID] = GroupMember
				--所有成员进入待命状态
				BehaviorFunctions.SetEntityValue(v,"GroupSkill",0)
				self.GroupTime[GroupID] = {Mark = 0 , Time = 0}
			end
		elseif GroupID == nil then
			LogError("[警告]至少需要输入一个组ID")
		end
	elseif MonsterGroup == nil then
		LogError("[警告]至少需要输入一个怪物组和组ID")
	end
end

--给组中的怪物发送信号
function LevelBehavior1025:MonsterGroupAttack(MonsterGroup,GroupID,Frequency,AttackNum)
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
				local Index = 0
				if self.GroupTime[GroupID].Mark ~= 0 then
					self.GroupTime[GroupID].Time = BehaviorFunctions.GetFightFrame()
					self.GroupTime[GroupID].Mark = 0
				end
				--若所填的数量超过组内怪物最大数量，则按最大数量进行攻击
				if AttackNum > MonNum then
					AttackNum = MonNum
				end
				--将目前允许组攻击的怪物清点出来
				for i,v in ipairs(MonsterGroup[GroupID]) do
					if BehaviorFunctions.GetEntityValue(v,"canGroup") == true  then
						Index = Index + 1
						MonInGroup[Index] = v
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
					if self.time - self.GroupTime[GroupID].Time >= Frequency*30 then
						--给允许攻击的怪物发送可攻击信号
						for i,v in ipairs(Attackers)  do
							if BehaviorFunctions.CheckEntity(v) ~= false then
								BehaviorFunctions.SetEntityValue(v,"GroupSkill",1)
								self.GroupTime[GroupID].Mark = 1
							--LogError("GroupID",GroupID,"Attacker InstanID:",v)
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
function LevelBehavior1025:CheckGroup(MonsterGroup)
	local GroupNum = 0
	--检查分组数量
	for i,v in ipairs(MonsterGroup) do
		GroupNum = GroupNum + 1
	end
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
function LevelBehavior1025:CheckGroupAttackState(MonsterGroup,GroupID)
	local GMGSstate = {}
	local Search = 0
	local GSstate = 0
	if MonsterGroup[GroupID] == nil then
		LogError("怪物组编号:"..GroupID..",为一个不存在的编号组，请检查该组是否存在")
	elseif MonsterGroup[GroupID] ~= nil then
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
end	

