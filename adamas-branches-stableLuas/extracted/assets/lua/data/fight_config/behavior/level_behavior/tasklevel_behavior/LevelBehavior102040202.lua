LevelBehavior102040202 = BaseClass("LevelBehavior102040202",LevelBehaviorBase)
--村庄入口关卡


function LevelBehavior102040202:__init(fight)
	self.fight = fight
end

function LevelBehavior102040202.GetGenerates()
	local generates = {900040,900041,900042,900050,910040}
	return generates
end

function LevelBehavior102040202.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior102040202:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	self.initState = 0
	self.missionState = 0
	self.dialogState = 0
	self.tipState = 0
	self.tipWave = 0
	self.guideState = 0
	self.createState = 0
	
	self.tipId = 102030201  --消灭怪物
	self.tipId2 = 10030004 --敌方增援来袭
	self.dialogId = 102220401 --村门口怪死完后播
	
	--怪物状态
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.monsterList = {
	{id = 900040 ,state = self.monsterStateEnum.Default,posName = "TownMon1",wave = 1},
	{id = 900040 ,state = self.monsterStateEnum.Default,posName = "TownMon2",wave = 1},
	{id = 900041 ,state = self.monsterStateEnum.Default,posName = "TownMon3",wave = 1},
		
	{id = 900041 ,state = self.monsterStateEnum.Default,posName = "TownMon4",wave = 2},
	{id = 900042 ,state = self.monsterStateEnum.Default,posName = "TownMon5",wave = 2},
	{id = 900042 ,state = self.monsterStateEnum.Default,posName = "TownMon6",wave = 2},
		
	{id = 910040 ,state = self.monsterStateEnum.Default,posName = "TownMon7",wave = 3},
	{id = 900042 ,state = self.monsterStateEnum.Default,posName = "TownMon8",wave = 3},
	{id = 900050 ,state = self.monsterStateEnum.Default,posName = "TownMon9",wave = 3}, 
	{id = 900040 ,state = self.monsterStateEnum.Default,posName = "TownMon10",wave = 3},
		}
	self.monLev = 3
	self.waveStart = 1
	self.waveEnd = 3
end

function LevelBehavior102040202:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	--波次刷怪
	if self.createState == 0 then
		self:CreateMonster(self.monsterList,self.waveStart,self.waveEnd)
	end
	
	if self.initState == 0 then
		--看向终点镜头
		local pos = BehaviorFunctions.GetTerrainPositionP("TownMon1",10020001,"TaskMain002")
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--延时移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
		
		self.wave1Count = #self.monsterList
		self.initState = 5

	elseif self.initState == 5 then
		self.initState = 10
	
	--距离显隐tip
	elseif self.initState == 10  then
		local pos = BehaviorFunctions.GetPositionP(self.role)
		local tarPos = BehaviorFunctions.GetTerrainPositionP("Town",10020001,"TaskMain002")
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
		self:Finish()
		self.createState = 1
		self.missionState = 20
	end
end

function LevelBehavior102040202:__delete()

end

function LevelBehavior102040202:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102040202,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--波次刷怪
function LevelBehavior102040202:CreateMonster(monsterList,waveStart,waveEnd)
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
					local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"TaskMain002")
					local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "TaskMain002")
					MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
					monsterList[a].instanceId = MonsterId
					monsterList[a].state = self.monsterStateEnum.Live
					--关闭警戒直接进战
					BehaviorFunctions.SetEntityValue(monsterList[a].instanceId,"haveWarn",false)
				end
			else
				if monsterList[a].state == self.monsterStateEnum.Default then
					local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "TaskMain002")
					MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,nil,nil,nil,self.levelId,self.monLev)
					BehaviorFunctions.DoLookAtTargetImmediately(MonsterId,self.role)
					monsterList[a].instanceId = MonsterId
					monsterList[a].state = self.monsterStateEnum.Live
					--关闭警戒直接进战
					BehaviorFunctions.SetEntityValue(monsterList[a].instanceId,"haveWarn",false)
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

--死亡事件
function LevelBehavior102040202:Death(instanceId,isFormationRevive)
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