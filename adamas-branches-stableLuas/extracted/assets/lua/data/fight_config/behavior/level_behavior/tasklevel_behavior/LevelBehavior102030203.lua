LevelBehavior102030203 = BaseClass("LevelBehavior102030203",LevelBehaviorBase)
--中据点第二波关卡，靠近据点器械播timeline，把从士弓单独做了一波

function LevelBehavior102030203:__init(fight)
	self.fight = fight
end

function LevelBehavior102030203.GetGenerates()
	local generates = {900050}
	return generates
end

function LevelBehavior102030203.GetStorys()
	local storys = {}
	return storys
end

function LevelBehavior102030203:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.yuId = 0
	self.distance = 0
	
	self.initState = 0
	self.missionState = 0
	self.dialogState = 0
	self.tipState1 = 0
	self.tipState2 = 0
	self.guideState = 0
	self.yuState = 0
	
	self.tipId1 = 102030201  --消灭怪物
	self.tipId2 = 102030203 --拾取掉落的佩从玉
	self.dialogId0 = 102211701 --第一波战斗结束后对话
	self.dialogId1 = 102211601 --靠近器械后从士弓cg
	self.dialogId2 = 102211301 --捡玉前对话

	self.monsters = {}
	self.monLev = 3 --怪物等级
	self.patrolPosList = {}
	
	--重载后隐藏玉
	BehaviorFunctions.ChangeEcoEntityCreateState(3001002020006,false)
end

function LevelBehavior102030203:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.initState == 0 then
		BehaviorFunctions.StartStoryDialog(self.dialogId0)
		self.initState = 10
	end
	
	--距离显隐tip1
	if self.initState == 10 then
		local pos1 = BehaviorFunctions.GetPositionP(self.role)
		local tarPos1 = BehaviorFunctions.GetTerrainPositionP("SmallCheck1",10020001,"LogicWorldTest01")
		local dis1 = BehaviorFunctions.GetDistanceFromPos(pos1,tarPos1)
		if dis1 > 50 then
			if self.tipState1 == 1 then
				BehaviorFunctions.HideTip()
				self.tipState1 = 2
			end
		end
		if dis1 < 50 then
			if self.tipState1 == 2 then
				BehaviorFunctions.ShowTip(self.tipId1)
				BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId1,self.wave1Count)
				self.tipState1 = 1
			end
		end
	end
	--距离显隐tip2
	if self.initState == 20 then
		local pos2 = BehaviorFunctions.GetPositionP(self.role)
		local tarPos2 = BehaviorFunctions.GetTerrainPositionP("SmallCheck1",10020001,"LogicWorldTest01")
		local dis2 = BehaviorFunctions.GetDistanceFromPos(pos2,tarPos2)
		if dis2 > 50 then
			if self.tipState2 == 1 then
				BehaviorFunctions.HideTip()
				self.tipState2 = 2
			end
		end
		if dis2 < 50 then
			if self.tipState2 == 2 then
				BehaviorFunctions.ShowTip(self.tipId2)
				BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId2,self.wave1Count)
				self.tipState2 = 1
			end
		end
	end
	
	if self.missionState == 0 then
		local targetPos = BehaviorFunctions.GetTerrainPositionP("SmallCheck1",10020001,"LogicWorldTest01")
		local selfPos = BehaviorFunctions.GetPositionP(self.role)
		self.distance = BehaviorFunctions.GetDistanceFromPos(targetPos,selfPos)
		if self.distance < 5 then
			self.missionState = 10
		end
		
	elseif self.missionState == 10 then
		if BehaviorFunctions.HasBuffKind(self.role,900000010) == false then
			BehaviorFunctions.DoMagic(self.role,self.role,900000010)
		end
		BehaviorFunctions.StartStoryDialog(self.dialogId1)
		--隐藏任务追踪
		BehaviorFunctions.SetGuideShowState(4,false)
		BehaviorFunctions.SetTipsGuideState(false)
		self.missionState = 20
	end
	
	--处理为玉正常模拟掉落
	if self.yuState == 0 then
		if BehaviorFunctions.GetEcoEntityByEcoId(3001002020006) and self.yuPos then
			self.yuId = BehaviorFunctions.GetEcoEntityByEcoId(3001002020006)
			BehaviorFunctions.DoSetPosition(self.yuId,self.yuPos.x,self.yuPos.y,self.yuPos.z)
			--临时加宝箱图标，后续提通用一点的图标需求
			BehaviorFunctions.AddEntityGuidePointer(self.yuId,2,1,false)
			--播放玉掉落时的旁白对话
			BehaviorFunctions.StartStoryDialog(self.dialogId2)
			BehaviorFunctions.ShowTip(self.tipId2)
			self.initState = 20	  --距离显隐tip用
			self.tipState2 = 1	  --距离显隐tip用
			self.yuState = 1
		end
	elseif self.yuState == 1 then
		--local pos = BehaviorFunctions.GetPositionP(self.role)
		--local dis = BehaviorFunctions.GetDistanceFromPos(pos,self.yuPos)
		--if dis > 15 then
				----看向终点镜头
				--self.empty = BehaviorFunctions.CreateEntity(2001,nil,self.yuPos.x,self.yuPos.y,self.yuPos.z)
				--self.levelCam = BehaviorFunctions.CreateEntity(22002)
				--BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
				--BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
				--BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
				----延时移除目标和镜头
				--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
				--BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
				--self.yuState = 2
		--end
	end
end

function LevelBehavior102030203:__delete()

end

function LevelBehavior102030203:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102030203,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--刷怪
function LevelBehavior102030203:CreatMonster(monsterList)
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

--波数计数
function LevelBehavior102030203:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior102030203:Death(instanceId,isFormationRevive)
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
		BehaviorFunctions.RemoveLevel(self.levelId)
	end
end

--从士弓掉落处理
function LevelBehavior102030203:Die(attackInstanceId,dieInstanceId)
	for i,v in pairs(self.monsters) do 
		if v.id == 900050 then
			if dieInstanceId == v.instanceId then
				self.yuPos = BehaviorFunctions.GetPositionP(dieInstanceId)
				if not BehaviorFunctions.GetEcoEntityByEcoId(3001002020006) then
					BehaviorFunctions.ChangeEcoEntityCreateState(3001002020006,true)
				end
			end
		end
	end
end

function LevelBehavior102030203:StoryEndEvent(dialogID)
	if dialogID == self.dialogId1 then
		if BehaviorFunctions.HasBuffKind(self.role,900000010) == true then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
		end
		self.monsters = self:CreatMonster({
				{id = 900050 ,posName = "SmallMon99",wave = 1},
			})
		self.wave1Count = self:WaveCount(1)
		BehaviorFunctions.ShowTip(self.tipId1)
		BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId1,self.wave1Count)
		self.tipState1 = 1   --距离显隐tip用
		BehaviorFunctions.DoLookAtTargetImmediately(self.monsters[1].instanceId,self.role)
		BehaviorFunctions.AddFightTarget(self.monsters[1].instanceId,self.role)
		BehaviorFunctions.CastSkillByTarget(self.monsters[1].instanceId,90005001,self.role,nil)
		
		local monPos = BehaviorFunctions.GetTerrainPositionP("SmallMon99",10020001,"LogicWorldTest01")
		--看向终点镜头
		self.empty = BehaviorFunctions.CreateEntity(2001,nil,monPos.x,monPos.y,monPos.z)
		self.levelCam = BehaviorFunctions.CreateEntity(22002)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
		--延时移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	end
end

function LevelBehavior102030203:CatchPartnerEnd()
	self:Finish()
end