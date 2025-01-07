LevelMonstersGroup = BaseClass("LevelMonstersGroup",LevelBehaviorBase)
--fight初始化
function LevelMonstersGroup:__init(fight)
	self.fight = fight
end

--预加载
function LevelMonstersGroup.GetGenerates()
	local generates = {}
	return generates
end

--参数初始化
function LevelMonstersGroup:Init()
	self.monstersGroup = {}
	self.groupTime = {}
	self.time = 0
end

--帧事件
function LevelMonstersGroup:Update()

end

--创造怪物组
function LevelMonstersGroup:MonsterGroup(MonsterGroup,GroupID,...)
	if MonsterGroup then
		if GroupID then
			local GroupMember = {}
			for i ,v in ipairs{...} do
				GroupMember[i] = v
				MonsterGroup[GroupID] = GroupMember
				--所有成员进入待命状态
				BehaviorFunctions.SetEntityValue(v,"GroupSkill",0)
				self.groupTime[GroupID] = {Mark = 0 , Time = 0}
			end
		elseif GroupID == nil then
			LogError("[警告]至少需要输入一个组ID")
		end
	elseif MonsterGroup == nil then
		LogError("[警告]至少需要输入一个怪物组和组ID")
	end
end

--给组中的怪物发送信号
function LevelMonstersGroup:MonsterGroupAttack(MonsterGroup,GroupID,Frequency,AttackNum)
	--怪物组，组ID，频率（多少秒攻击一次），同时攻击数量
	--频率和数量为可缺省参数,默认5秒一次
	
	--记录世界时间
	self.time = BehaviorFunctions.GetFightFrame()
	
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
			--if state == true then
				local MonInGroup = {}
				local MonInGroupNum = 0
				local MonNum = #MonsterGroup[GroupID]
				local Attackers = {}
				local Index = 0
				if self.groupTime[GroupID].Mark ~= 0 then
					self.groupTime[GroupID].Time = BehaviorFunctions.GetFightFrame()
					self.groupTime[GroupID].Mark = 0
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

					if self.time - self.groupTime[GroupID].Time >= Frequency*30 then
						--给允许攻击的怪物发送可攻击信号
						for i,v in ipairs(Attackers)  do
							if BehaviorFunctions.CheckEntity(v) ~= false then
								BehaviorFunctions.SetEntityValue(v,"GroupSkill",1)
								self.groupTime[GroupID].Mark = 1
								--LogError("GroupID",GroupID,"Attacker InstanID:",v)
							end
						end
					end
				end
			--end
		elseif GroupID == nil then
			LogError("[警告]至少需要输入一个组ID")
		end
	elseif MonsterGroup == nil then
		LogError("[警告]至少需要输入一个怪物组和组ID")
	end
end

--检测实体的生死状态
function LevelMonstersGroup:CheckGroup(MonsterGroup)
	local GroupNum = 0
	local MemberNum = 0
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
			MemberNum = MemberNum + 1
		end
		--倒序检查
		for i = MemberNum,1,-1 do
			if BehaviorFunctions.CheckEntity(CurrentGroup[i]) == false then
				table.remove(MonsterGroup[GroupIndex],i)
			end
		end
	end
end

--检测实体的组攻击状态
function LevelMonstersGroup:CheckGroupAttackState(MonsterGroup,GroupID)
	local GMGSstate = {}
	local Search = 0
	local GSstate = 0
	local AttMark = true
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
			--检查是否有攻击者
			for i,v in pairs(GMGSstate) do
				if v == 1 then
					AttMark = false
					--return false
				end
			end
			--若有攻击者，则返回组攻击状态
			if AttMark == false then
				return false
			elseif AttMark == true then
				return  true
			end
		end
	end
end

--挑出目前处于攻击状态的攻击者
function LevelMonstersGroup:GetGroupAttacker(MonsterGroup,GroupID)
	local GroupMonster = {}
	local GroupMonsterState = 0
	local AttackerList = {}
	for i,v in pairs(MonsterGroup[GroupID]) do
		if BehaviorFunctions.CheckEntity(v) ~= false then
			GroupMonsterState = BehaviorFunctions.GetEntityValue(v,"GroupSkill")
			GroupMonster[v] = GroupMonsterState
			if GroupMonsterState == 1 then
				table.insert(AttackerList,v)
			end	
		end
	end
	return AttackerList
end


