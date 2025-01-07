LevelBehavior30001 = BaseClass("LevelBehavior30001",LevelBehaviorBase)
--拯救于静
function LevelBehavior30001:__init(fight)
	self.fight = fight
end

function LevelBehavior30001.GetGenerates()
	local generates = {900040}
	return generates
end

function LevelBehavior30001.GetStorys()
	local storys = {12001}
	return storys
end


function LevelBehavior30001:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	self.monsters = {}
end

function LevelBehavior30001:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.wave1Count = self:WaveCount(1)
	self.wave2Count = self:WaveCount(2)
	self.frame = BehaviorFunctions.GetFightFrame()
	if self.missionState == 0 then
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
		BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",false) --核心被动
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
		BehaviorFunctions.StartStoryDialog(12001)
		self.missionState = 1
	end
	if self.missionState == 5 then
		local pos = BehaviorFunctions.GetTerrainPositionP("TimelineOver12001",10020001,"MVP_1")
		BehaviorFunctions.DoSetPositionP(self.role,pos)
		BehaviorFunctions.SetGuideTask(200100105)
		if BehaviorFunctions.HasBuffKind(self.role,900000010) then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
		end
		--BehaviorFunctions.ShowTip(3001006) --消灭怪物
		self:CreatMonster({
		{id = 900040 ,posName = "Monster101",lookatposName = "TimelineOver12001",wave = 1},
		{id = 900040 ,posName = "Monster102",lookatposName = "TimelineOver12001",wave = 1},
		{id = 900040 ,posName = "Monster103",lookatposName = "TimelineOver12001",wave = 1},
		})
		self.missionState = 10
	end
	--技能教学
	if self.missionState == 10 then
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		BehaviorFunctions.SetTaskGuideDisState(false)
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能
		BehaviorFunctions.ShowWeakGuide(10003)
		self.frameStart = self.frame
		self.missionState = 11
	end
	--第一波怪杀光进图片tips
	if self.missionState == 11 and self.wave1Count == 0 and self.frame > self.frameStart then
		local closeCallback = function()
			self:Dooo()
		end
		BehaviorFunctions.ShowGuideImageTips(10015,closeCallback)
		self.missionState = 12
	end
	--关掉tips召怪
	if self.missionState == 13  then
		--显示按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"Core",true) --被动条
		BehaviorFunctions.SetFightMainNodeVisible(2,"R",true) --核心被动
		BehaviorFunctions.SetFightMainNodeVisible(2,"L",true) --大招
		--确保加满能量
		BehaviorFunctions.DoMagic(1,self.role,200000001)
		self:CreatMonster({
				{id = 900040 ,posName = "Monster201",lookatposName = "TimelineOver12001",wave = 2},
				{id = 900040 ,posName = "Monster202",lookatposName = "TimelineOver12001",wave = 2},
				{id = 900040 ,posName = "Monster203",lookatposName = "TimelineOver12001",wave = 2},
			})
		self.frameStart = self.frame
		self.missionState = 15
	end
	if self.missionState == 15 and self.frame> self.frameStart and self.wave2Count == 0 then
		BehaviorFunctions.StartStoryDialog(14001)
		BehaviorFunctions.DoMagic(1,self.role,900000010)
		self.missionState = 20
	end
	if self.missionState == 30 then
		local pos = BehaviorFunctions.GetTerrainPositionP("Role1",10020001,"MVP_1")
		local lpos = BehaviorFunctions.GetTerrainPositionP("Npc1",10020001,"MVP_1")
		BehaviorFunctions.DoSetPositionP(self.role,pos)
		BehaviorFunctions.DoLookAtPositionImmediately(self.role,lpos.x,lpos.y,lpos.z)
		self.frameStart = self.frame
		self.missionState = 40
	end
	if self.missionState == 40 and self.storyDone and self.frame >self.frameStart then	
		BehaviorFunctions.RemoveLevel(30001)
		BehaviorFunctions.SendTaskProgress(200100105,1,1)
		self.missionState = 999
	end
end
function LevelBehavior30001:RemoveEntity(instanceId)
	if instanceId == self.monster then
		self.missionState = 30
	end
end

function LevelBehavior30001:__delete()

end

--刷怪
function LevelBehavior30001:CreatMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001, "MVP_1")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "MVP_1")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z)
			BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",false)
			table.insert(self.monsters,{wave =monsterList[a].wave,instanceId =MonsterId})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "MVP_1")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z)
			BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",false)
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
function LevelBehavior30001:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior30001:Death(instanceId)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
		end
	end
	if instanceId == self.role then
		BehaviorFunctions.RemoveLevel(30001)
	end
end

function LevelBehavior30001:StoryEndEvent(dialogId)
	if dialogId == 14001  then
		self.storyDone = true
	end
	if dialogId == 12001 then
		self.missionState = 5
	end
end

function LevelBehavior30001:StoryStartEvent(dialogId)
	if dialogId == 14001  then
		self.missionState = 30
	end
	if dialogId == 12001 then
		BehaviorFunctions.DoMagic(1,self.role,900000010)
	end
end

function LevelBehavior30001:Dooo()
	self.missionState = 13
end