LevelBehavior200100105 = BaseClass("LevelBehavior200100105",LevelBehaviorBase)
--fight初始化
function LevelBehavior200100105:__init(fight)
	self.fight = fight
end

--预加载
function LevelBehavior200100105.GetGenerates()
	local generates = {900010,900000102}
	return generates
end

--UI预加载
function LevelBehavior200100105.GetUIGenerates()
	local generates = {
		FightEnum.PreLoadUI.FightTips--中间横幅和底部横幅
	}
	return generates
end

--参数初始化
function LevelBehavior200100105:Init()
	self.role = 0           --当前角色
	self.missionstate = 0   --关卡流程

	self.wave = 0           --波数计数
	self.waveLimit = 4      --波数上限
	self.time = 0		    --世界时间
	self.timeStart = 0      --记录时间
	self.monsters = { Count = 0 }      --怪物的instance和其总数
	self.battleArea1 = false--是否处于战斗区域1
	self.battleArea2 = false--是否处于战斗区域2
	self.battleArea3 = false--是否处于战斗区域3
	self.battleArea4 = false--是否处于战斗区域4
	self.fallingArea = false--是否处于下坠区域
	self.tutorial = 0
	self.pressCheck = 0
	self.pressTime = 0

	self.tutoMon = 0

	self.monstersGroup = {}
	self.groupTime = { Time = 0 , Mark = 0 }
	self.mark = 0
	
	self.roadSign = 0
	
	--创建相机行为树
	self.levelCam = BehaviorFunctions.CreateBehavior("LevelCamera",self)

end

--帧事件
function LevelBehavior200100105:Update()
	--每帧获得当前角色
	self.role = BehaviorFunctions.GetCtrlEntity()
	--获取时间，区域
	self.time = BehaviorFunctions.GetFightFrame()
	--检测玩家是否处于战斗区域内
	self.battleArea1 = BehaviorFunctions.GetInAreaById("BattleArea1",self.role)
	self.battleArea2 = BehaviorFunctions.GetInAreaById("BattleArea2",self.role)
	self.battleArea3 = BehaviorFunctions.GetInAreaById("BattleArea3",self.role)
	self.battleArea4 = BehaviorFunctions.GetInAreaById("BattleArea4",self.role)
	self.battleArea5 = BehaviorFunctions.GetInAreaById("BattleArea5",self.role)

	--初始化，角色出生点
	if  self.missionstate == 0 then
		self.entites = {}   --初始化self.entites表
		--获取地点
		local pb1 = BehaviorFunctions.GetTerrainPositionP("pb3")
		--BehaviorFunctions.DoSetPosition(self.role,pb1.x,pb1.y,pb1.z)   --角色位置
		BehaviorFunctions.SetPlayerBorn(pb1.x,pb1.y,pb1.z)	--角色位置
		self.timeStart =BehaviorFunctions.GetFightFrame()
		--BehaviorFunctions.InitCameraAngle(180)
		--local mp1 = BehaviorFunctions.GetTerrainPositionP("mb11")
		--BehaviorFunctions.DoLookAtPositionImmediately(self.role,mp1.x,mp1.y)

		----初始化关掉所有空气墙
		--BehaviorFunctions.SetWallEnable("AW1",true)
		--BehaviorFunctions.SetWallEnable("AW2",true)
		--BehaviorFunctions.SetWallEnable("AW3",false)
		--BehaviorFunctions.SetWallEnable("AW4",true)
		--BehaviorFunctions.SetWallEnable("AW6",false)
		self.missionstate = 1
		self.timeStart = BehaviorFunctions.GetFightFrame()
		
		--按键隐藏
		--BehaviorFunctions.SetFightMainNodeVisible(2,"QTE",false)	--QTE隐藏

	end
	
	if self.missionstate == 1 and self.time - self.timeStart >= 30 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"JoystickArea",false)	--摇杆隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",false) 	--按键隐藏
		BehaviorFunctions.SetFightMainNodeVisible(2,"QTE",false) 			--QTE隐藏
	end

	--开启技能辅助轮
	self:SkillTips()

	--关卡流程
	if self.missionstate == 1 and self.time - self.timeStart >= 90 then
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.OpenRemoteDialog(100401)						--开场通讯
		self.missionstate = 2

	end

	if self.missionstate == 2 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common1)
		or self.missionstate == 2 and BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Common2) then
		
		BehaviorFunctions.SetFightMainNodeVisible(2,"JoystickArea",true)	--摇杆显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true) 	--按键显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"QTE",true) 			--QTE显示
		
		BehaviorFunctions.SetWallEnable("AW3",false)     				--关闭战斗区域墙
		self.roadSign = BehaviorFunctions.CreateEntity(900000102)
		local mp2 = BehaviorFunctions.GetTerrainPositionP("mb35")
		BehaviorFunctions.SetGuide(100108,mp2.x,mp2.y+2,mp2.z)			--设置前往目标点
		BehaviorFunctions.DoSetPosition(self.roadSign,mp2.x,mp2.y-0.5,mp2.z)--设置路牌
		
		self.missionstate = 5
	end
		
	if self.missionstate == 5 and self.battleArea3 == true then
		BehaviorFunctions.SetWallEnable("AW3",true)     				--开启战斗区域墙
		BehaviorFunctions.RemoveEntity(self.roadSign)
	end
	
	if self.missionstate == 10 then
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionstate = 15
	end
		
	if self.missionstate == 20 then			
		BehaviorFunctions.SetWallEnable("AW6",false)     				--关闭战斗区域墙
		self.roadSign = BehaviorFunctions.CreateEntity(900000102)
		local mp2 = BehaviorFunctions.GetTerrainPositionP("mb21")
		BehaviorFunctions.DoSetPosition(self.roadSign,mp2.x,mp2.y-0.5,mp2.z)	
		BehaviorFunctions.SetGuide(100108,mp2.x,mp2.y+2,mp2.z)			--设置前往目标点
		self.levelCam:Position_Camera(self.role,mp2,1)				--玩家看向目标点
		self.missionstate = 25		
	end
		
	if self.missionstate == 25 and self.battleArea5 == true then
		BehaviorFunctions.SetWallEnable("AW6",true)     				--开启战斗区域墙
		BehaviorFunctions.RemoveEntity(self.roadSign)
	end
	
	if self.missionstate == 30 then
		self.timeStart = BehaviorFunctions.GetFightFrame()
		self.missionstate = 35
	end



	--关卡退出倒计时
	if self.missionstate == 40  and self.wave == self.waveLimit then
		self.timeStart =BehaviorFunctions.GetFightFrame()
		BehaviorFunctions.ShowTip(1029)
		self.missionstate = 41

	elseif self.missionstate == 41  and self.time - self.timeStart == 30 then
		BehaviorFunctions.ShowTip(1030)
		self.missionstate = 42

	elseif self.missionstate == 42  and self.time - self.timeStart == 60 then
		BehaviorFunctions.ShowTip(1031)
		self.missionstate = 43

	elseif self.missionstate == 43  and self.time - self.timeStart == 90 then
		BehaviorFunctions.ShowTip(1032)
		self.missionstate = 44

	elseif self.missionstate == 44  and self.time - self.timeStart == 120 then
		BehaviorFunctions.ShowTip(1033)
		self.missionstate = 45
	end

	if self.missionstate == 45 and self.time - self.timeStart == 150 then
		BehaviorFunctions.SetFightResult(true)
	end

	--分组攻击命令
	if self.missionstate >= 5 and self.monsters.Count ~= 0 then
		
		if self.wave == 1 then
			self:MonsterGroupAttack(self.monstersGroup,1,5,1)
		end

		if self.wave == 2 then
			self:MonsterGroupAttack(self.monstersGroup,2,5,1)
		end

		if self.wave == 3 then
			self:MonsterGroupAttack(self.monstersGroup,3,5,1)
		end
		
		if self.wave == 4 then
			self:MonsterGroupAttack(self.monstersGroup,4,5,1)
		end
	end

	--召怪流程
	if self.missionstate >= 5 and self.monsters.Count == 0  then
			
		if self.wave == 0 and self.battleArea3 == true then

			local mp1 = BehaviorFunctions.GetTerrainPositionP("mb34")
			local mp2 = BehaviorFunctions.GetTerrainPositionP("mb35")
			local mp3 = BehaviorFunctions.GetTerrainPositionP("mb36")
			
			local Mon1 = BehaviorFunctions.CreateEntity(900010)
			self.monsters[Mon1] = Mon1
			BehaviorFunctions.SetEntityValue(Mon1,"idle",0)
			BehaviorFunctions.DoSetPosition(Mon1,mp1.x,mp1.y,mp1.z)

			local Mon2 = BehaviorFunctions.CreateEntity(900010)
			self.monsters[Mon2] = Mon2
			BehaviorFunctions.SetEntityValue(Mon2,"idle",0)
			BehaviorFunctions.DoSetPosition(Mon2,mp2.x,mp2.y,mp2.z)

			local Mon3 = BehaviorFunctions.CreateEntity(900010)
			self.monsters[Mon3] = Mon3
			BehaviorFunctions.SetEntityValue(Mon3,"idle",0)
			BehaviorFunctions.DoSetPosition(Mon3,mp3.x,mp3.y,mp3.z)
			
			self.monsters.Count = self.monsters.Count + 3

			self:MonsterGroup(self.monstersGroup,1,Mon1,Mon2,Mon3)

			BehaviorFunctions.DoLookAtTargetImmediately(Mon1,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(Mon2,self.role)
			BehaviorFunctions.DoLookAtTargetImmediately(Mon3,self.role)
			
			--指引敌人
			BehaviorFunctions.SetGuide(100402,mp1.x,mp1.y,mp1.z)
			BehaviorFunctions.SetGuideState(false)
			BehaviorFunctions.HideGuidePointState()
			BehaviorFunctions.ShowTip(1002001)

			--玩家看向怪物
			self.levelCam:Position_Camera(self.role,mp2,1)				--玩家看向目标点

			self.wave = self.wave + 1

		elseif self.wave == 1  and self.missionstate == 15 then

			if self.time - self.timeStart == 90 then

				local mp1 = BehaviorFunctions.GetTerrainPositionP("mb31")
				local mp2 = BehaviorFunctions.GetTerrainPositionP("mb32")
				local mp3 = BehaviorFunctions.GetTerrainPositionP("mb33")

				local Mon1 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon1] = Mon1
				BehaviorFunctions.SetEntityValue(Mon1,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon1,mp1.x,mp1.y,mp1.z)

				local Mon2 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon2] = Mon2
				BehaviorFunctions.SetEntityValue(Mon2,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon2,mp2.x,mp2.y,mp2.z)

				local Mon3 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon3] = Mon3
				BehaviorFunctions.SetEntityValue(Mon3,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon3,mp3.x,mp3.y,mp3.z)

				self:MonsterGroup(self.monstersGroup,2,Mon1,Mon2,Mon3)

				BehaviorFunctions.DoLookAtTargetImmediately(Mon1,self.role)
				BehaviorFunctions.DoLookAtTargetImmediately(Mon2,self.role)
				BehaviorFunctions.DoLookAtTargetImmediately(Mon3,self.role)

				--指引敌人
				BehaviorFunctions.SetGuide(100402,mp1.x,mp1.y,mp1.z)
				BehaviorFunctions.SetGuideState(false)
				BehaviorFunctions.HideGuidePointState()
				BehaviorFunctions.ShowTip(1003002)

				self.monsters.Count = self.monsters.Count + 3

				--玩家看向怪物
				self.levelCam:Position_Camera(self.role,mp2,1)				--玩家看向目标点

				self.wave = self.wave + 1
			end

		elseif self.wave == 2  and self.missionstate == 25 then

			if self.battleArea5 == true then

				local mp1 = BehaviorFunctions.GetTerrainPositionP("mb21")
				local mp2 = BehaviorFunctions.GetTerrainPositionP("mb22")
				local mp3 = BehaviorFunctions.GetTerrainPositionP("mb23")

				local Mon1 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon1] = Mon1
				BehaviorFunctions.SetEntityValue(Mon1,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon1,mp1.x,mp1.y,mp1.z)

				local Mon2 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon2] = Mon2
				BehaviorFunctions.SetEntityValue(Mon2,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon2,mp2.x,mp2.y,mp2.z)

				local Mon3 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon3] = Mon3
				BehaviorFunctions.SetEntityValue(Mon3,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon3,mp3.x,mp3.y,mp3.z)

				self:MonsterGroup(self.monstersGroup,3,Mon1,Mon2,Mon3)

				BehaviorFunctions.DoLookAtTargetImmediately(Mon1,self.role)
				BehaviorFunctions.DoLookAtTargetImmediately(Mon2,self.role)
				BehaviorFunctions.DoLookAtTargetImmediately(Mon3,self.role)

				--指引敌人
				BehaviorFunctions.SetGuide(100402,mp1.x,mp1.y,mp1.z)
				BehaviorFunctions.SetGuideState(false)
				BehaviorFunctions.HideGuidePointState()
				BehaviorFunctions.ShowTip(1003002)

				self.monsters.Count = self.monsters.Count + 3

				--玩家看向怪物
				self.levelCam:Position_Camera(self.role,mp2,1)				--玩家看向目标点

				self.wave = self.wave + 1
			end
			
		elseif self.wave == 3  and self.missionstate == 35 then

			if self.time - self.timeStart == 90 then

				local mp1 = BehaviorFunctions.GetTerrainPositionP("mb21")
				local mp2 = BehaviorFunctions.GetTerrainPositionP("mb22")
				local mp3 = BehaviorFunctions.GetTerrainPositionP("mb23")

				local Mon1 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon1] = Mon1
				BehaviorFunctions.SetEntityValue(Mon1,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon1,mp1.x,mp1.y,mp1.z)

				local Mon2 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon2] = Mon2
				BehaviorFunctions.SetEntityValue(Mon2,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon2,mp2.x,mp2.y,mp2.z)

				local Mon3 = BehaviorFunctions.CreateEntity(900010)
				self.monsters[Mon3] = Mon3
				BehaviorFunctions.SetEntityValue(Mon3,"idle",0)
				BehaviorFunctions.DoSetPosition(Mon3,mp3.x,mp3.y,mp3.z)

				self:MonsterGroup(self.monstersGroup,4,Mon1,Mon2,Mon3)

				BehaviorFunctions.DoLookAtTargetImmediately(Mon1,self.role)
				BehaviorFunctions.DoLookAtTargetImmediately(Mon2,self.role)
				BehaviorFunctions.DoLookAtTargetImmediately(Mon3,self.role)

				--指引敌人
				BehaviorFunctions.SetGuide(100402,mp1.x,mp1.y,mp1.z)
				BehaviorFunctions.SetGuideState(false)
				BehaviorFunctions.HideGuidePointState()
				BehaviorFunctions.ShowTip(1003002)

				self.monsters.Count = self.monsters.Count + 3

				--玩家看向怪物
				self.levelCam:Position_Camera(self.role,mp2,1)				--玩家看向目标点
				self.wave = self.wave + 1
			end
		end
	end

	--清怪检测
	if self.monsters.Count == 0 then
		if self.wave == 1 and self.missionstate < 15 then
			self.missionstate = 10

		elseif self.wave == 2 and self.missionstate < 20 then
			self.missionstate = 20

		elseif self.wave == 3 and self.missionstate <= 30 then
			self.missionstate = 30
			
		elseif self.wave == 4 and self.missionstate <= 40 then
			self.missionstate = 40
		end

	end
end




--死亡事件
function LevelBehavior200100105:Death(instanceId)
	if self.monsters[instanceId] then
		self.monsters[instanceId] = nil
		self.monsters.Count = self.monsters.Count - 1
		self:CheckGroup(self.monstersGroup)
		--print("kill"..instanceId)
	end
	if instanceId == self.role then
		BehaviorFunctions.SetFightResult(false)
	end
end

--时间暂停
function LevelBehavior200100105:StopTime()        --暂停实体时间和行为
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.AddBuff(self.role,npcs[i],200100101001,1)
	end
end

--解除时间暂停
function LevelBehavior200100105:Continue()        --解除暂停
	local npcs = BehaviorFunctions.SearchNpc()
	for i in ipairs(npcs)  do
		BehaviorFunctions.RemoveBuff(npcs[i],200100101001)
	end
end

--技能辅助轮
function LevelBehavior200100105:SkillTips()
	--提示长按普攻动效显示判断
	self.CoreResRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1204)
	if self.CoreResRatio == 10000 and not BehaviorFunctions.HasEntitySign(self.role,10030000) then
		BehaviorFunctions.SetFightMainNodeVisible(1,"JTips20015",true)
	else
		BehaviorFunctions.SetFightMainNodeVisible(1,"JTips20015",false)
	end
end


--获取目前可交互npc的id
function LevelBehavior200100105:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = triggerInstanceId
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",false)	--右侧UI隐藏
end

--离开范围时，取消所有交互ui
function LevelBehavior200100105:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	self.InterInstance = nil
	BehaviorFunctions.SetFightMainNodeVisible(2,"ButtomRight",true)	--右侧UI显示
end

function LevelBehavior200100105:CreatMonster(...)
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
		self.monsters[MonsterId] = MonsterId
		BehaviorFunctions.SetEntityValue(self.monsters[MonsterId],"idle",0)
		BehaviorFunctions.DoSetPosition(MonsterId,MonsterIdnPos[MPosX],MonsterIdnPos[MPosY],MonsterIdnPos[MPosZ])
		MId = MId + 4
		MPosX = MPosX + 4
		MPosY = MPosY + 4
		MPosZ = MPosZ + 4
		BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,1)
	end
	return MonsterIdnPos[1]
end

function LevelBehavior200100105:__delete()

end

--创造怪物组
function LevelBehavior200100105:MonsterGroup(MonsterGroup,GroupID,...)
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
function LevelBehavior200100105:MonsterGroupAttack(MonsterGroup,GroupID,Frequency,AttackNum)
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
			end
		elseif GroupID == nil then
			LogError("[警告]至少需要输入一个组ID")
		end
	elseif MonsterGroup == nil then
		LogError("[警告]至少需要输入一个怪物组和组ID")
	end
end

--检测实体的生死状态
function LevelBehavior200100105:CheckGroup(MonsterGroup)
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
function LevelBehavior200100105:CheckGroupAttackState(MonsterGroup,GroupID)
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