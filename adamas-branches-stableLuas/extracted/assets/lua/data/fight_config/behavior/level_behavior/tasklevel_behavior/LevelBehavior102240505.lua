LevelBehavior102240505 = BaseClass("LevelBehavior102240505",LevelBehaviorBase)
--中据点第三波关卡


function LevelBehavior102240505:__init(fight)
	self.fight = fight
end

function LevelBehavior102240505.GetGenerates()
	local generates = {910040,900040,900041,900050}
	return generates
end

function LevelBehavior102240505.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior102240505:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	self.initState = 0
	self.missionState = 0
	self.dialogState = 0
	self.tipState = 0
	self.enterArea = 0
	
	self.tipId = 102030201  --消灭怪物

	self.dialogId1 = 102230501 --采药途中播
	self.dialogId2 = 102230601 --播完上一个播
	
	self.monsters = {}
	self.monLev = 3
	
	self.ecoId = 0
end

function LevelBehavior102240505:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	--召怪
	if self.initState == 0 then
		self.monsters = self:CreatMonster({
		{id = 910040 ,posName = "Drug3Mon1",wave = 1},
		{id = 900040 ,posName = "Drug3Mon2",wave = 1},
		{id = 900041 ,posName = "Drug3Mon3",wave = 1},
		{id = 900050 ,posName = "Drug3Mon4",wave = 1},
		})
		
		----看向终点镜头
		--local pos = BehaviorFunctions.GetTerrainPositionP("SmallMon9",10020001,"TaskMain002")
		--self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z)
		--self.levelCam = BehaviorFunctions.CreateEntity(22002)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		----延时移除目标和镜头
		--BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		--BehaviorFunctions.AddDelayCallByFrame(60,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		
		for i,v in pairs(self.monsters) do
			BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId,self.role)
		end
		self.wave1Count = self:WaveCount(1)

		self.initState = 5

	elseif self.initState == 5 then
		if BehaviorFunctions.GetEcoEntityByEcoId(3001002020009) then
			self.ecoId = BehaviorFunctions.GetEcoEntityByEcoId(3001002020009)
			BehaviorFunctions.SetEntityWorldInteractState(self.ecoId,false)
			self.initState = 10
		end
	
	--距离显隐tip
	elseif self.initState == 10 then
		local pos = BehaviorFunctions.GetPositionP(self.role)
		local tarPos = BehaviorFunctions.GetTerrainPositionP("Drug3Fight",10020001,"TaskMain002")
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
	
	if self.missionState == 5 then
		BehaviorFunctions.ShowTip(self.tipId)
		BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId,self.wave1Count)
		self.tipState = 1   --距离显隐tip用
		self.missionState = 10
		
	elseif self.missionState == 10 and self.wave1Count == 0 then
		BehaviorFunctions.SetEntityWorldInteractState(self.ecoId,true)
		BehaviorFunctions.StartStoryDialog(self.dialogId1)
		self:Finish()
		self.missionState = 20
	end
end

function LevelBehavior102240505:__delete()

end

function LevelBehavior102240505:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102240505,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--刷怪
function LevelBehavior102240505:CreatMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"TaskMain002")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "TaskMain002")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",true)
			--table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId})
			monsterList[a].instanceId = MonsterId
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "TaskMain002")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,nil,nil,nil,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",false)
			BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
			--table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId})
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
function LevelBehavior102240505:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior102240505:Death(instanceId,isFormationRevive)
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

function LevelBehavior102240505:EnterArea(triggerInstanceId,areaName,logicName)
	if triggerInstanceId == self.role and areaName == "DrugArea3Fight" and logicName == "TaskMain002" then
		if self.enterArea == 0 then
			self.missionState = 5
			self.enterArea = 1
		end
	end
end

function LevelBehavior102240505:StoryEndEvent(dialogId)
	if dialogId == self.dialogId1 then
		BehaviorFunctions.StartStoryDialog(self.dialogId2)
	end
end