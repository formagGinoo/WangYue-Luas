LevelBehavior102020301 = BaseClass("LevelBehavior102020301",LevelBehaviorBase)
--遇见刻刻关卡，播放遇见刻刻timeline及出怪后旁白

function LevelBehavior102020301:__init(fight)
	self.fight = fight
end

function LevelBehavior102020301.GetGenerates()
	local generates = {900042,900040,900041}
	return generates
end

function LevelBehavior102020301.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior102020301:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.initState = 0
	self.missionState = 0
	self.tipId = 102030201  --消灭怪物
	self.tipId2 = 10030004 --敌方增援来袭
	self.tipState = 0
	self.createState = 0 
	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monsterList = {
		{id = 900040 ,state = self.monsterStateEnum.Default,posName = "KekeMon1",wave = 1},
		{id = 900040 ,state = self.monsterStateEnum.Default,posName = "KekeMon2",wave = 1},
		{id = 900042 ,state = self.monsterStateEnum.Default,posName = "KekeMon3",wave = 1},

		{id = 900041 ,state = self.monsterStateEnum.Default,posName = "KekeMon4",wave = 2},
		{id = 900040 ,state = self.monsterStateEnum.Default,posName = "KekeMon5",wave = 2},
		{id = 900040 ,state = self.monsterStateEnum.Default,posName = "KekeMon6",wave = 2},
		{id = 900042 ,state = self.monsterStateEnum.Default,posName = "KekeMon7",wave = 2},
	}
	self.waveStart = 1
	self.waveEnd = 2
	self.monLev = 2 --怪物等级
	
	self.dialogId1 = 102210401  --遇见刻刻timeline
	self.dialogId2 = 102210501  --出怪后旁白
	self.dialogId3 = 102210601  --怪死完后timeline
	self.dialogState = 0
end

function LevelBehavior102020301:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	if self.createState == 0 then
		self:CreateMonster(self.monsterList,self.waveStart,self.waveEnd)
	end
	--召怪
	if self.initState == 0 then
		self.wave1Count = #self.monsterList
		self.initState = 10
	end
	--距离显隐tip
	if self.initState == 10  then
		local pos = BehaviorFunctions.GetPositionP(self.role)
		local tarPos = BehaviorFunctions.GetTerrainPositionP("KekeMon3",10020001,"LogicWorldTest01")
		local dis = BehaviorFunctions.GetDistanceFromPos(pos,tarPos)
		if dis > 50 then
			if self.tipState == 1 then
				BehaviorFunctions.HideTip()
				self.tipState = 2
			end
		end
		if dis < 50 then
			if self.tipState == 2 then
				BehaviorFunctions.ShowTip(self.tipId)
				BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId,self.wave1Count)
				self.tipState = 1
			end
		end
	end
	
	--怪物死亡关卡完成
	if self.missionState == 10 and self.wave1Count == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogId3)
		self.createState = 1
		self.missionState = 20
	end
end

function LevelBehavior102020301:__delete()

end

function LevelBehavior102020301:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102020302,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--波次刷怪
function LevelBehavior102020301:CreateMonster(monsterList,waveStart,waveEnd)
	local MonsterId = 0
	local waveLength = 0
	local deadLength = 0
	local wave = waveStart

	for a = 1,#monsterList,1 do
		--波次判断
		if monsterList[a].wave == wave then
			if monsterList[a].state == self.monsterStateEnum.Dead then
				deadLength = deadLength + 1
			end
			waveLength = waveLength + 1

			if monsterList[a].lookatposName then
				if monsterList[a].state == self.monsterStateEnum.Default then
					local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"LogicWorldTest01")
					local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "LogicWorldTest01")
					MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
					monsterList[a].instanceId = MonsterId
					monsterList[a].state = self.monsterStateEnum.Live
					--关闭警戒直接进战
					if wave == 2 then
						BehaviorFunctions.SetEntityValue(monsterList[a].instanceId,"haveWarn",false)
					end
				end
			else
				if monsterList[a].state == self.monsterStateEnum.Default then
					local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "LogicWorldTest01")
					MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,nil,nil,nil,self.levelId,self.monLev)
					BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
					monsterList[a].instanceId = MonsterId
					monsterList[a].state = self.monsterStateEnum.Live
					--关闭警戒直接进战
					if wave == 2 then
						BehaviorFunctions.SetEntityValue(monsterList[a].instanceId,"haveWarn",false)
					end
				end
			end
		end
	end

	--波次判断
	if waveLength == deadLength and waveLength ~= 0 then
		self.waveStart = waveStart + 1
		--if self.waveStart <= waveEnd then
			--BehaviorFunctions.ShowTip(self.tipId2)
		--end
	end

	--table.sort(monsterList,function(a,b)
	--if a.wave < b.wave then
	--return true
	--elseif a.wave == b.wave then
	--if a.instanceId < b.instanceId then
	--return true
	--end
	--end
	--end)
	--return monsterList
end


--波数计数
function LevelBehavior102020301:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end


--死亡事件
function LevelBehavior102020301:Death(instanceId,isFormationRevive)
	local i = 0
	for i = #self.monsterList,1,-1 do
		if self.monsterList[i].instanceId == instanceId then
			self.monsterList[i].state = self.monsterStateEnum.Dead
			self.wave1Count = self.wave1Count - 1
			BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId,self.wave1Count)
		end
	end
	if isFormationRevive  == true then
		--移除怪物
		for i = 1,#self.monsterList do
			if self.monsterList[i].instanceId then
				BehaviorFunctions.RemoveEntity(self.monsterList[i].instanceId)
			end
		end
		BehaviorFunctions.RemoveLevel(self.levelId)
	end
end

function LevelBehavior102020301:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId1 then
		BehaviorFunctions.ShowTip(self.tipId)
		BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId,self.wave1Count)
		BehaviorFunctions.StartStoryDialog(self.dialogId2)
		self.tipState = 1
		self.missionState = 10
	end
	
	if dialogId == self.dialogId3 then
		self:Finish()
	end
end

function LevelBehavior102020301:EnterArea(triggerInstanceId,areaName,logicName)
	if triggerInstanceId == self.role and areaName == "KekeArea2" and logicName == "LogicWorldTest01" then
		if self.dialogState == 0 then
			BehaviorFunctions.StartStoryDialog(self.dialogId1)
			self.dialogState = 1
		end
	end
end