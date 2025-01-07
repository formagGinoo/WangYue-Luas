LevelBehavior102010301 = BaseClass("LevelBehavior102010301",LevelBehaviorBase)
--刺杀教学关卡
--可能需要判断一下没有装备佩从时给remake和佩从装备引导

function LevelBehavior102010301:__init(fight)
	self.fight = fight
end

function LevelBehavior102010301.GetGenerates()
	local generates = {900040,910040}
	return generates
end

function LevelBehavior102010301.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior102010301:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.initState = 0
	self.missionState = 0
	self.dialogState = 0
	self.tipId1 = 102030202   --悄悄靠近怪物
	self.tipId2 = 102030201   --消灭全部怪物
	self.tipState = 0
	self.monsters = {}
	self.guideState = 0
	
	self.dropPos1 = 0
	self.dropPos2 = 0
	
	self.yuState = 0
	
	self.rolepos = 0
	self.pos = 0
	self.distance = 0
	self.monLev = 2
	
	self.transport = 0
end

function LevelBehavior102010301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--处理触发remake情况，在还未传送时再次触发remake导致循环触发的问题
	if self.loadingMap then
		return
	end

	--召怪
	if self.initState == 0 then
		self:CreatMonster({
				{id = 900040 ,posName = "Monster1",lookatposName = "MonsterS1",wave = 1},
				{id = 900040 ,posName = "Monster2",lookatposName = "MonsterS1",wave = 1},
				{id = 910040 ,posName = "Monster3",lookatposName = "MonsterS1",wave = 1},
			})
		self.wave1Count = self:WaveCount(1)
		--处理在area内上下线，导致无法触发enterarea的情况
		local rolepos = BehaviorFunctions.GetPositionP(self.role)
		local pos = BehaviorFunctions.GetTerrainPositionP("Ass2",10020001,"LogicWorldTest01")
		local distance = BehaviorFunctions.GetDistanceFromPos(rolepos,pos)
		if distance < 30 then
			self.missionState = 20
		end
		self.initState = 10
	end
	
	--超出范围remake	
	if self.initState >= 10 then
		self.rolepos = BehaviorFunctions.GetPositionP(self.role)
		self.pos = BehaviorFunctions.GetTerrainPositionP("Ass2",10020001,"LogicWorldTest01")
		self.distance = BehaviorFunctions.GetDistanceFromPos(self.rolepos,self.pos)
		if BehaviorFunctions.GetEcoEntityByEcoId(1001002020001) then
			self.transport = BehaviorFunctions.GetEcoEntityByEcoId(1001002020001)
			BehaviorFunctions.SetEntityWorldInteractState(self.transport,false)
		end
		
		if self.distance > 110 then
			self:Remake()
		end
	end
	
	--进入区域
	if self.missionState == 20 then
		BehaviorFunctions.ShowTip(self.tipId1)  --悄悄靠近怪物tip
		self.missionState = 30		
		
	elseif self.missionState == 30  then
		if self.distance < 30 then
			if self.tipState == 0 then
				BehaviorFunctions.ShowTip(self.tipId2)  --消灭全部怪物tip
				BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId2,self.wave1Count)
				self.tipState = 1
			end
		end
		
		--没装佩从时跳过刺杀教学
		if not BehaviorFunctions.GetPartnerInstanceId(self.role) then
			self.missionState = 70
		end
		
		if BehaviorFunctions.CheckPlayerInFight() then
			BehaviorFunctions.FinishGuide(2203,1)
			self.missionState = 70
		end
		
		--暗杀判断，判断佩从的按钮可按下
		if BehaviorFunctions.GetPartnerInstanceId(self.role) then	
			local partnerId = BehaviorFunctions.GetPartnerInstanceId(self.role)
			if not BehaviorFunctions.CheckPlayerInFight() and BehaviorFunctions.CheckBtnUseSkill(partnerId,FightEnum.KeyEvent.Partner) then
				self.missionState = 40
			end
		end
		
		--if BehaviorFunctions.CheckPlayerInFight() then
			----靠近失败，重置关卡
			--self:Remake()
		--end
	
	--时停刺杀引导
	elseif self.missionState == 40 then
			BehaviorFunctions.PlayGuide(2203)
			--BehaviorFunctions.AddBuff(self.role,self.role,200000008)
			--屏蔽除佩从键以外的输入
			--BehaviorFunctions.DisableAllSkillButton(self.role,true)
			--BehaviorFunctions.DisableSkillButton(self.role, FightEnum.KeyEvent.Partner,false)
			self.missionState = 50
	
	elseif self.missionState == 50 then
		--BehaviorFunctions.CancelJoystick()
		if BehaviorFunctions.HasEntitySign(self.role,62001001) then
			BehaviorFunctions.FinishGuide(2203,1)
			--BehaviorFunctions.RemoveBuff(self.role,200000008)
			--解除按键屏蔽
			--BehaviorFunctions.DisableAllSkillButton(self.role,false)
			self.missionState = 60
		end
		
		if BehaviorFunctions.CheckPlayerInFight() then
			BehaviorFunctions.FinishGuide(2203,1)
			self.missionState = 70
		end
		
	--触发刺杀引导后长时间不刺杀，因空中开伞下落导致无法刺杀后的处理
		--if not BehaviorFunctions.HasEntitySign(self.role,62001001) then
			--local canAss = 0
			--for i = 1,#self.monsters do
				--if self.monsters[i].instanceId and BehaviorFunctions.HasBuffKind(self.monsters[i].instanceId,900000053) then
				--canAss = canAss + 10
				--elseif self.monsters[i].instanceId and not BehaviorFunctions.HasBuffKind(self.monsters[i].instanceId,900000053) then
				--canAss = canAss + 1
				--end
			--end
			--if canAss == 3 then
				--self.missionState = 30
				--BehaviorFunctions.DisableAllSkillButton(self.role,false)
			--end
		--end
		
	elseif self.missionState == 65 then
		for i,v in pairs(self.monsters) do
			BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId,self.role)
		end
		self.missionState = 70
	
		
	elseif self.missionState == 70 then
		--跳过刺杀教学时正常显示tip
		if self.distance < 30 then
			if self.tipState == 0 then
				BehaviorFunctions.ShowTip(self.tipId2)  --消灭全部怪物tip
				BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId2,self.wave1Count)
				self.tipState = 1
			end
		end
		
		if self.wave1Count == 0 then
			self:Finish()
			self.missionState = 80	
		end
	end
	
	local flag1 = 0
	local flag2 = 0
	if self.yuState == 0 then
		if flag1 == 0 then
			if BehaviorFunctions.GetEcoEntityByEcoId(2001002020005) and self.dropPos1 ~= 0 then
				local drop1 = BehaviorFunctions.GetEcoEntityByEcoId(2001002020005)
				BehaviorFunctions.DoSetPositionP(drop1,self.dropPos1)
				BehaviorFunctions.InteractEntityHit(drop1)
				--self.yuState = 999
				flag1 = 1
			end
		end

		if flag2 == 0 then
			if BehaviorFunctions.GetEcoEntityByEcoId(2001002020006) and self.dropPos2 ~= 0 then
				local drop2 = BehaviorFunctions.GetEcoEntityByEcoId(2001002020006)
				BehaviorFunctions.DoSetPositionP(drop2,self.dropPos2)
				BehaviorFunctions.InteractEntityHit(drop2)
				--self.yuState = 999
				flag2 = 1
			end
		end
	end
end

function LevelBehavior102010301:__delete()

end

function LevelBehavior102010301:Remake()
	--移除怪物
	for i = 1,#self.monsters do
		if self.monsters[i].instanceId then
			BehaviorFunctions.RemoveEntity(self.monsters[i].instanceId)
		end
	end
	self.monsters = {}
	self.initState = 0
	self.missionState = 0
	self.tipState = 0
	BehaviorFunctions.HideTip()
	BehaviorFunctions.ShowBlackCurtain(true,0)
	local remakePos = BehaviorFunctions.GetTerrainPositionP("AssRemake",10020001,"LogicWorldTest01")
	BehaviorFunctions.InMapTransport(remakePos.x,remakePos.y,remakePos.z)
	self.loadingMap = true
	self.dialogState = 0
end

function LevelBehavior102010301:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102010401,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--刷怪
function LevelBehavior102010301:CreatMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"LogicWorldTest01")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",true)
			table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId,posName = monsterList[a].posName})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,nil,nil,nil,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",false)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
			table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId,posName = monsterList[a].posName})
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


--波数计数
function LevelBehavior102010301:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior102010301:Death(instanceId,isFormationRevive)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
			self.wave1Count = self.wave1Count - 1
			BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId2,self.wave1Count)
		end
	end
	if isFormationRevive  == true then
		--移除怪物
		for i = 1,#self.monsters do
			if self.monsters[i].instanceId then
				BehaviorFunctions.RemoveEntity(self.monsters[i].instanceId)
			end
		end
		BehaviorFunctions.RemoveLevel(self.levelId)
	end
end

--从士模拟掉落处理
function LevelBehavior102010301:Die(attackInstanceId,dieInstanceId)
	for i,v in pairs(self.monsters) do
		if v.posName == "Monster1" then
			if dieInstanceId == v.instanceId then
				BehaviorFunctions.ChangeEcoEntityCreateState(2001002020005,true)
				self.dropPos1 = BehaviorFunctions.GetPositionP(v.instanceId)
			end
		end
		
		if v.posName == "Monster2" then
			if dieInstanceId == v.instanceId then
				BehaviorFunctions.ChangeEcoEntityCreateState(2001002020006,true)
				self.dropPos2 = BehaviorFunctions.GetPositionP(v.instanceId)
			end
		end
	end
end


function LevelBehavior102010301:EnterArea(triggerInstanceId,areaName,logicName)
	if self.loadingMap then
		self.missionState = 0
	end
	self.loadingMap = false
	BehaviorFunctions.ShowBlackCurtain(false, 1)
	if triggerInstanceId == self.role and areaName == "AssTipArea" then
		if self.guideState == 0 and self.missionState == 30 then
			BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,20022)
			self.guideState = 1
		end
	end
	
	if triggerInstanceId == self.role and areaName == "AssTeachArea" then
		if self.dialogState == 0 and self.tipState == 0 then
			--临时逻辑
			self.missionState = 20
			--临时逻辑
			self.dialogState = 1
		end
	end
end

--赋值
function LevelBehavior102010301:Assignment(variable,value)
	self[variable] = value
end

--刺杀结束
function LevelBehavior102010301:FinishSkill(instanceId,skillId,skillSign,skillType)
	if skillId == 62001006 and self.missionState == 60 then
		self.missionState = 65
	end
end