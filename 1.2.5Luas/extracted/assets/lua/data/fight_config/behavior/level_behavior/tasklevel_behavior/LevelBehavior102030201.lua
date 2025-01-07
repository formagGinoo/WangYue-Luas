LevelBehavior102030201 = BaseClass("LevelBehavior102030201",LevelBehaviorBase)
--刺杀教学关卡
function LevelBehavior102030201:__init(fight)
	self.fight = fight
end

function LevelBehavior102030201.GetGenerates()
	local generates = {910025,900040}
	return generates
end

function LevelBehavior102030201.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior102030201:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.initState = 0
	self.missionState = 0
	self.dialogState = 0
	self.tipState = 0
	self.monsters = {}
	self.yuState = 0
end

function LevelBehavior102030201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	--召怪
	if self.initState == 0 then
		self:CreatMonster({
				{id = 900040 ,posName = "Monster1",lookatposName = "MonsterS1",wave = 1},
				{id = 900040 ,posName = "Monster2",lookatposName = "MonsterS1",wave = 1},
				{id = 910025 ,posName = "Monster3",lookatposName = "MonsterS1",wave = 1},
			})
		self.wave1Count = self:WaveCount(1)
		self.frameStart = self.frame
		self.initState = 10
	end
	--超出范围remake	
	if self.initState >= 10 then
		local rolepos = BehaviorFunctions.GetPositionP(self.role)
		local pos = BehaviorFunctions.GetTerrainPositionP("Ass2",10020001,"LogicWorldTest01")
		local distance = BehaviorFunctions.GetDistanceFromPos(rolepos,pos)
		if distance > 80 then
			self:Remake()
		end
	end
	
	--进入区域
	if self.missionState == 20 then
		--悄悄靠近怪物
		BehaviorFunctions.ShowTip(102030202)
		self.missionState = 30		
	end
	if self.missionState == 30  then
		--刺杀判断
		for i = 1,#self.monsters do
			if self.monsters[i].instanceId and BehaviorFunctions.HasBuffKind(self.monsters[i].instanceId,900000053) then
				self.missionState = 40
			end
		end
		if BehaviorFunctions.CheckPlayerInFight() then
			--靠近失败，重置关卡
			self:Remake()
		end
	end
	
	if self.missionState == 40 then
		BehaviorFunctions.PlayGuide(2203)
		BehaviorFunctions.CancelJoystick()
		BehaviorFunctions.ShowTip(self.levelId)
		BehaviorFunctions.ChangeSubTipsDesc(1,self.levelId,self.wave1Count)
		self.missionState = 50
	end
	if self.missionState == 50 and  BehaviorFunctions.HasEntitySign(self.role,62001001) then
		self.frameStart = self.frame
		self.missionState = 60
	end
	if self.missionState == 65 then		
		BehaviorFunctions.AddDelayCallByTime(0.5,BehaviorFunctions,BehaviorFunctions.ShowGuideImageTips,20022)
		self.missionState = 70
	end
	
	if self.missionState == 70 and self.wave1Count == 0  then
		self:Finish()
		self.missionState = 80	
	end
	if self.yuState == 0 then
		if BehaviorFunctions.GetEcoEntityByEcoId(3002020005) and self.yuPos then
			local yu = BehaviorFunctions.GetEcoEntityByEcoId(3002020005)
			BehaviorFunctions.DoSetPositionP(yu,self.yuPos)
			self.yuState = 999
		end
	end
end

function LevelBehavior102030201:__delete()

end

function LevelBehavior102030201:Remake()
	--移除怪物
	for i = 1,#self.monsters do
		if self.monsters[i].instanceId then
			BehaviorFunctions.RemoveEntity(self.monsters[i].instanceId)
		end
	end
	self.monsters = {}
	self.initState = 0
	self.missionState = 0
	BehaviorFunctions.HideTip()
	BehaviorFunctions.ShowBlackCurtain(true,0)
	local remakePos = BehaviorFunctions.GetTerrainPositionP("AssRemake",10020001,"LogicWorldTest01")
	BehaviorFunctions.InMapTransport(remakePos.x,remakePos.y,remakePos.z)
	self.dialogState = 0
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
	BehaviorFunctions.AddDelayCallByTime(2,self,self.Assignment,"missionState",0)
	BehaviorFunctions.AddDelayCallByTime(2,BehaviorFunctions,BehaviorFunctions.ShowTip,102030203)
end

function LevelBehavior102030201:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102030202,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--刷怪
function LevelBehavior102030201:CreatMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"LogicWorldTest01")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",true)
			table.insert(self.monsters,{wave =monsterList[a].wave,instanceId =MonsterId})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",false)
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


--波数计数
function LevelBehavior102030201:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior102030201:Death(instanceId,isFormationRevive)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
			self.wave1Count = self.wave1Count - 1
			BehaviorFunctions.ChangeSubTipsDesc(1,self.levelId,self.wave1Count)
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
--石龙掉落处理
function LevelBehavior102030201:Die(attackInstanceId,dieInstanceId)
	if BehaviorFunctions.GetEntityTemplateId(dieInstanceId) == 910025 then
		self.yuPos = BehaviorFunctions.GetPositionP(dieInstanceId)
		if not BehaviorFunctions.GetEcoEntityByEcoId(3002020005) then
			BehaviorFunctions.ChangeEcoEntityCreateState(3002020005,true)
		end
	end
end


function LevelBehavior102030201:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "AssTeachArea" then
		if self.dialogState == 0 then
			BehaviorFunctions.StartStoryDialog(102030701)
			self.dialogState = 1
		end
	end
end

function LevelBehavior102030201:StoryEndEvent(dialogId)
	if dialogId ==  102030701 then
		self.missionState = 20
	end
end

--赋值
function LevelBehavior102030201:Assignment(variable,value)
	self[variable] = value
	if variable == "myState" then
	end
end

--刺杀结束
function LevelBehavior102030201:FinishSkill(instanceId,skillId,skillType)
	if skillId == 62001006 and self.missionState == 60   then
		self.missionState = 65
	end
end
