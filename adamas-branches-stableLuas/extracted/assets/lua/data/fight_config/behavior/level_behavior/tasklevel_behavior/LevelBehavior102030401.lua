LevelBehavior102030401 = BaseClass("LevelBehavior102030401",LevelBehaviorBase)
--中据点第三波关卡


function LevelBehavior102030401:__init(fight)
	self.fight = fight
end

function LevelBehavior102030401.GetGenerates()
	local generates = {900041,900042,900050,900083}
	return generates
end

function LevelBehavior102030401.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior102030401:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	self.initState = 0
	self.missionState = 0
	self.dialogState = 0
	self.tipState = 0
	self.guideState = 0
	
	self.tipId = 102030201  --消灭怪物

	self.dialogId = 102211501 --怪物死完后播
	
	self.monsters = {}

	self.patrolPosList = {}
	self.monLev = 3
end

function LevelBehavior102030401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	--召怪,炸药桶
	if self.initState == 0 then
		self.monsters = self:CreatMonster({
		{id = 900041 ,posName = "SmallMon7",wave = 1},
		{id = 900042 ,posName = "SmallMon8",wave = 1},
		{id = 900083 ,posName = "SmallMon9",wave = 1},
		})
		
		--看向终点镜头
		local pos = BehaviorFunctions.GetTerrainPositionP("SmallMon9",10020001,"LogicWorldTest01")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--延时移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		
		for i,v in pairs(self.monsters) do
			BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId,self.role)
		end
		
		self.wave1Count = self:WaveCount(1)
		self.frameStart = self.frame
		self.initState = 5

	elseif self.initState == 5 then
		--self:SetPatrol(self.monsters)
		self.initState = 10
	
	--距离显隐tip
	elseif self.initState == 10  then
		local pos = BehaviorFunctions.GetPositionP(self.role)
		local tarPos = BehaviorFunctions.GetTerrainPositionP("Small2",10020001,"LogicWorldTest01")
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
	
	if self.missionState == 0 then
		BehaviorFunctions.ShowTip(self.tipId)
		BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId,self.wave1Count)
		self.tipState = 1   --距离显隐tip用
		self.missionState = 10
		
	elseif self.missionState == 10 and self.wave1Count == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogId)
		self.missionState = 20
	end
end

function LevelBehavior102030401:__delete()

end

function LevelBehavior102030401:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102030402,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--刷怪
function LevelBehavior102030401:CreatMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"LogicWorldTest01")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",true)
			monsterList[a].instanceId = MonsterId
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,nil,nil,nil,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",false)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
			monsterList[a].instanceId = MonsterId
		end
	end
	--table.sort(self.monsters,function(a,b)
			--if a.wave < b.wave then
				--return true
			--elseif a.wave == b.wave then
				--if a.instanceId < b.instanceId then
					--return true
				--end
			--end
		--end)
	table.sort(monsterList,function(a,b)
			if a.wave < b.wave then
				return true
			elseif a.wave == b.wave then
				if a.instanceId < b.instanceId then
					return true
				end
			end
		end)
	return monsterList
end

--波数计数
function LevelBehavior102030401:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior102030401:Death(instanceId,isFormationRevive)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
			self.wave1Count = self.wave1Count - 1
			BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId,self.wave1Count)
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

function LevelBehavior102030401:StoryEndEvent(dialogId)
	if dialogId == self.dialogId then
		self:Finish()
	end
end

--不往返巡逻
function LevelBehavior102030401:SetPatrol(monsterList)
	for i,v in pairs(monsterList) do
		if v.routePos then
			local patrolPosList = {}
			local routePos = BehaviorFunctions.GetTerrainPositionP(v.routePos,10020001,"LogicWorldTest01")
			local startPos = BehaviorFunctions.GetTerrainPositionP(v.posName,10020001,"LogicWorldTest01")
			patrolPosList = {startPos,routePos}
			BehaviorFunctions.SetEntityValue(v.instanceId,"peaceState",1)  -- 1是巡逻
			BehaviorFunctions.SetEntityValue(v.instanceId,"patrolPositionList",patrolPosList)
			BehaviorFunctions.SetEntityValue(v.instanceId,"canReturn",false)
		end
	end
end