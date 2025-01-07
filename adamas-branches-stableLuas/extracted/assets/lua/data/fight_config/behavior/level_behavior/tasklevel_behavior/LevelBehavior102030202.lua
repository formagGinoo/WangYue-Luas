LevelBehavior102030202 = BaseClass("LevelBehavior102030202",LevelBehaviorBase)
--中据点第一波关卡，怪物死完播旁白，完成关卡和任务

function LevelBehavior102030202:__init(fight)
	self.fight = fight
end

function LevelBehavior102030202.GetGenerates()
	local generates = {900040,900041,900042,900050,900051,2030218}
	return generates
end

function LevelBehavior102030202.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior102030202:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.yuId = 0
	
	self.initState = 0
	self.missionState = 0
	self.dialogState = 0
	self.tipState = 0
	self.guideState = 0
	self.yuState = 0
	
	self.tipId1 = 102030201  --消灭怪物
	--self.tipId2 = 102030203 --拾取掉落的佩从玉
	--self.dialogId = 102211101 --据点第一波战斗开始时旁白

	self.monsters = {}
	self.monLev = 3 --怪物等级
	self.Bombs = 
	{
		--[1] = {id = 2030218,posName = "Bomb1"},
		--[2] = {id = 2030218,posName = "Bomb2"},
		--[3] = {id = 2030218,posName = "Bomb3"},
		[1] = {id = 2030218,posName = "Bomb4"},
	}
	self.patrolPosList = {}
	
end

function LevelBehavior102030202:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	--召怪,炸药桶
	if self.initState == 0 then
		self:CreateBomb(self.Bombs)
		self.monsters = self:CreatMonster({
		{id = 900042 ,posName = "SmallMon1",wave = 1},
		{id = 900051 ,posName = "SmallMon2",wave = 1},
		{id = 900041 ,posName = "SmallMon3",routePos = "SmallMon3Route",wave = 1},
		{id = 900040 ,posName = "SmallMon4",routePos = "SmallMon4Route",wave = 1},
		{id = 900042 ,posName = "SmallMon5",routePos = "SmallMon5Route",wave = 1},
		})
		self.wave1Count = self:WaveCount(1)
		self.frameStart = self.frame
		self.initState = 10
		
	elseif self.initState == 10 then
		self:SetPatrol(self.monsters)
		self.initState = 20
	end
	--距离显隐tip
	if self.initState == 20 then
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
				BehaviorFunctions.ShowTip(self.tipId1)
				BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId1,self.wave1Count)
				self.tipState = 1
			end
		end
	end
	
	--为了处理showtip时机不正确导致的tip显示异常
	if self.missionState == 0 then
		if BehaviorFunctions.CheckTaskIsFinish(102030201) == true then
			BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"missionState",5)
			self.missionState = 1
		end
		
	elseif self.missionState == 5 then
			BehaviorFunctions.ShowTip(self.tipId1)
			BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId1,self.wave1Count)
			self.tipState = 1	--距离显隐tip用
			self.missionState = 10
		
	elseif self.missionState == 10 and self.wave1Count == 0 then
		self:Finish()
		self.missionState = 20
	end
	
	--捡玉判断，捡完播装备从士弓引导，引导结束完成关卡
	--if self.yuState == 2 and BehaviorFunctions.CheckEcoEntityState(3002020006) == false then
		--if self.guideState == 0 then
			--BehaviorFunctions.PlayGuide()
			--self.guideState = 1
		--end
		--if BehaviorFunctions.CheckGuideFinish() then
			--self:Finish()
		--end
	--end
	
	----处理为玉正常模拟掉落
	--if self.yuState == 0 then
		--if BehaviorFunctions.GetEcoEntityByEcoId(3002020006) and self.yuPos then
			--self.yuId = BehaviorFunctions.GetEcoEntityByEcoId(3002020006)
			--BehaviorFunctions.DoSetPosition(self.yuId,self.yuPos.x,self.yuPos.y,self.yuPos.z)
			--BehaviorFunctions.SetEntityWorldInteractState(self.yuId,false)
			--self.yuState = 1
		--end
	----怪死完才能交互玉
	--elseif self.yuState == 1 then
		--if self.wave1Count == 0 and BehaviorFunctions.GetEcoEntityByEcoId(3002020006) then
			----播放玉掉落时的旁白对话
			--BehaviorFunctions.StartStoryDialog(self.dialogId)
			--BehaviorFunctions.ShowTip(self.tipId2)
			--self.yuState = 2
		--end
	--end
end

function LevelBehavior102030202:__delete()

end

function LevelBehavior102030202:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102030202,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--刷怪
function LevelBehavior102030202:CreatMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"LogicWorldTest01")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",true)
			--table.insert(self.monsters,{wave = monsterList[a].wave,instanceId = MonsterId})
			monsterList[a].instanceId = MonsterId
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "LogicWorldTest01")
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

--往返巡逻
function LevelBehavior102030202:SetPatrol(monsterList)
	for i,v in pairs(monsterList) do
		if v.routePos then
			local patrolPosList = {}
			local routePos = BehaviorFunctions.GetTerrainPositionP(v.routePos,10020001,"LogicWorldTest01")
			local startPos = BehaviorFunctions.GetTerrainPositionP(v.posName,10020001,"LogicWorldTest01")
			patrolPosList = {startPos,routePos}
			BehaviorFunctions.SetEntityValue(v.instanceId,"peaceState",1)  -- 1是巡逻
			BehaviorFunctions.SetEntityValue(v.instanceId,"patrolPositionList",patrolPosList)
			BehaviorFunctions.SetEntityValue(v.instanceId,"canReturn",true)
		end
	end
end

function LevelBehavior102030202:CreateBomb(Bombs)
	for i,v in pairs(Bombs) do
		local pos1 = BehaviorFunctions.GetTerrainPositionP(v.posName,10020001,"LogicWorldTest01")
		local BombId = BehaviorFunctions.CreateEntity(v.id,nil,pos1.x,pos1.y,pos1.z,nil,nil,nil,self.levelId,nil)
		Bombs[i].instanceId = BombId
	end
end

--波数计数
function LevelBehavior102030202:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior102030202:Death(instanceId,isFormationRevive)
	local i = 0
	for i = #self.monsters,1,-1 do
		if self.monsters[i].instanceId == instanceId then
			table.remove(self.monsters,i)
			self.wave1Count = self.wave1Count - 1
			BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId1,self.wave1Count)
		end
	end
	if isFormationRevive  == true then
		--移除怪物
		for i = 1,#self.monsters do
			if self.monsters[i].instanceId then
				BehaviorFunctions.RemoveEntity(self.monsters[i].instanceId)
			end
		end
		-- 您好 炸弹也要移除
		for i = 1, #self.Bombs do
			if self.Bombs[i].instanceId then
				BehaviorFunctions.RemoveEntity(self.Bombs[i].instanceId)
				self.Bombs[i].instanceId = nil
			end
		end
		BehaviorFunctions.RemoveLevel(self.levelId)
	end
end

--赋值
function LevelBehavior102030202:Assignment(variable,value)
	self[variable] = value
end

--从士弓掉落处理
--function LevelBehavior102030202:Die(attackInstanceId,dieInstanceId)
	--for i,v in pairs(self.monsters) do 
		--if v.id == 900050 then
			--if dieInstanceId == v.instanceId then
				--self.yuPos = BehaviorFunctions.GetPositionP(dieInstanceId)
				--if not BehaviorFunctions.GetEcoEntityByEcoId(3002020006) then
					--BehaviorFunctions.ChangeEcoEntityCreateState(3002020006,true)
				--end
			--end
		--end
	--end
--end

--function LevelBehavior102030202:StoryEndEvent(dialogID)
	--if dialogID == self.dialogId then
		--BehaviorFunctions.SetEntityWorldInteractState(self.yuId,true)
		--local yupos = BehaviorFunctions.GetPositionP(self.yuId)
		----看向终点镜头
		--self.empty = BehaviorFunctions.CreateEntity(2001,nil,yupos.x,yupos.y,yupos.z)
		--self.levelCam = BehaviorFunctions.CreateEntity(22002)
		--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		----延时移除目标和镜头
		--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		--BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	--end
--end

--function LevelBehavior102030202:CatchPartnerEnd()
	--self:Finish()
--end