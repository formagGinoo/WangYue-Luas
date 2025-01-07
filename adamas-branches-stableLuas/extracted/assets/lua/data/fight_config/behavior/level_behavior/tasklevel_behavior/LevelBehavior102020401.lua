LevelBehavior102020401 = BaseClass("LevelBehavior102020401",LevelBehaviorBase)
--刻刻瞄准射击教学关卡

function LevelBehavior102020401:__init(fight)
	self.fight = fight
end

function LevelBehavior102020401.GetGenerates()
	local generates = {900080}
	return generates
end

function LevelBehavior102020401.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior102020401:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.initState = 0
	self.missionState = 0
	self.tipId1 = 102020401  --切换为刻刻
	self.tipId2 = 102020402  --瞄准击败怪物
	self.tipId3 = 102020403  --开启宝箱
	self.monsters = {}
	self.dialogId1 = 102210701  --瞄准教学开始后timeline
	self.dialogId2 = 102210801  --射击命中后timeline
	--self.dialogId3 = 102210901  --旁白
	self.roleTemId = 0
	self.monLev = 2 --怪物等级
	self.guideState = 0	 --控制瞄准引导开关
	self.guideState2 = 0 --控制切换刻刻引导开关
end

function LevelBehavior102020401:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	self.roleTemId = BehaviorFunctions.GetEntityTemplateId(self.role)
	--播timeline，播完召怪
	if self.initState == 0 then
		BehaviorFunctions.FinishGuide(1019,6)
		BehaviorFunctions.FinishGuide(1019,7)
		BehaviorFunctions.StartStoryDialog(self.dialogId1)
		self.frameStart = self.frame
		self.initState = 10
	end
	
	if self.missionState == 10 then
		--提示切换为刻刻
		if self.roleTemId ~= 1002 then
			BehaviorFunctions.HideTip()
			BehaviorFunctions.ShowTip(self.tipId1)
			BehaviorFunctions.PlayGuide(2206)
			self.missionState = 20
		end
		--处理切换为刻刻后重载的情况
		if self.roleTemId == 1002 then
			self.missionState = 20
		end
		
	elseif self.missionState == 20 then
		--切换成刻刻前不允许输入
		BehaviorFunctions.DisableAllSkillButton(self.role,true)
		BehaviorFunctions.CancelJoystick()
		--切换成刻刻后才进下一步流程
		self.roleTemId = BehaviorFunctions.GetEntityTemplateId(self.role)
		if self.roleTemId == 1002 then
			--仅解禁攻击键
			BehaviorFunctions.DisableSkillButton(self.role, FightEnum.KeyEvent.Attack, false)
			--看向终点镜头
			local fp1 = BehaviorFunctions.GetTerrainPositionP("KekeTeachMon1",10020001,"LogicWorldTest01")
			self.empty = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
			self.levelCam = BehaviorFunctions.CreateEntity(22002)
			BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
			BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
			--延时移除目标和镜头
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
			BehaviorFunctions.AddDelayCallByFrame(45,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
			self.missionState = 30
		end
		
	elseif self.missionState == 30 then
		BehaviorFunctions.HideTip()
		BehaviorFunctions.ShowTip(self.tipId2)
		BehaviorFunctions.ChangeSubTipsDesc(1,self.tipId2,self.wave1Count)
		self.missionState = 40
		
	elseif self.missionState == 40 then
		--角色为刻刻时播放引导，不为刻刻不播
		if self.roleTemId == 1002 and self.guideState == 0 then
			BehaviorFunctions.FinishGuide(2206,1)
			BehaviorFunctions.PlayGuide(2048) --长按普攻进入瞄准教学
			self.guideState = 1
			self.guideState2 = 0
		end
		if self.roleTemId ~= 1002 and self.guideState2 == 0 then
			BehaviorFunctions.FinishGuide(2048,1)
			BehaviorFunctions.PlayGuide(2206)
			self.guideState = 0
			self.guideState2 = 1
		end
		BehaviorFunctions.CancelJoystick()
		
	elseif self.missionState == 45 then
			BehaviorFunctions.FinishGuide(2048,1)
			BehaviorFunctions.FinishGuide(2206,1)
			BehaviorFunctions.CancelJoystick()
			--怪物死亡关卡完成
			if self.wave1Count == 0 then
				BehaviorFunctions.StartStoryDialog(self.dialogId2)
				--队伍内角色输入解禁
				local role = BehaviorFunctions.GetCurFormationEntities()
				for i,v in pairs(role) do
					BehaviorFunctions.DisableAllSkillButton(v,false)
				end
			--显示宝箱
				if not BehaviorFunctions.GetEcoEntityByEcoId(3001002020002) then
					BehaviorFunctions.ChangeEcoEntityCreateState(3001002020002,true)
				end
				BehaviorFunctions.ShowTip(self.tipId3)
				self.missionState = 50
			end
		
	elseif self.missionState == 50 then
		if BehaviorFunctions.GetEcoEntityByEcoId(3001002020002) then
			local treasure = BehaviorFunctions.GetEcoEntityByEcoId(3001002020002)
			BehaviorFunctions.AddEntityGuidePointer(treasure,2,1,false)
		end
		self.missionState = 55

	elseif self.missionState == 60 then

		self.missionState = 70
		
	elseif self.missionState == 70 then
		self:Finish()
	end
end

function LevelBehavior102020401:__delete()

end

function LevelBehavior102020401:Finish()
	BehaviorFunctions.HideTip()
	BehaviorFunctions.SendTaskProgress(102020402,1,1)
	BehaviorFunctions.RemoveLevel(self.levelId)
end

--刷怪
function LevelBehavior102020401:CreatMonster(monsterList)
	local MonsterId = 0
	for a = 1,#monsterList,1 do
		if monsterList[a].lookatposName then
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName,10020001,"LogicWorldTest01")
			local lookatposP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].lookatposName,10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,lookatposP.x,nil,lookatposP.z,self.levelId,self.monLev)
			--BehaviorFunctions.SetEntityValue(MonsterId,"haveWarn",true)
			table.insert(self.monsters,{wave =monsterList[a].wave,instanceId = MonsterId})
		else
			local posP = BehaviorFunctions.GetTerrainPositionP(monsterList[a].posName, 10020001, "LogicWorldTest01")
			MonsterId = BehaviorFunctions.CreateEntity(monsterList[a].id,nil,posP.x,posP.y,posP.z,nil,nil,nil,self.levelId,self.monLev)
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
function LevelBehavior102020401:WaveCount(waveNum)
	local count	= 0
	for i = #self.monsters,1,-1  do
		if self.monsters[i].wave == waveNum then
			count = count + 1
		end
	end
	return count
end

--死亡事件
function LevelBehavior102020401:Death(instanceId,isFormationRevive)
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

function LevelBehavior102020401:StoryEndEvent(dialogId)
	if dialogId ==  self.dialogId1 then
		self:CreatMonster({
				{id = 79000801, posName = "KekeTeachMon1", lookatposName = "KekeTeachMonS1", wave = 1},
			})
		self.wave1Count = self:WaveCount(1)
		local pos = BehaviorFunctions.GetTerrainPositionP("KekeTeachPos1",10020001,"LogicWorldTest01")
		BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		self.missionState = 10
	
	elseif dialogId == self.dialogId2 then
		
	end
end

--开启宝箱完成任务步骤
function LevelBehavior102020401:WorldInteractClick(uniqueId,instanceId)
	local treasure = BehaviorFunctions.GetEcoEntityByEcoId(3001002020002)
	if instanceId == treasure then
		self.missionState = 60
	end
end

function LevelBehavior102020401:Die(attackInstanceId,instanceId)
	if next(self.monsters) then
		if instanceId == self.monsters[1].instanceId then
			self.missionState = 45
		end
	end
end