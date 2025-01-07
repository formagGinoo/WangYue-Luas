LevelBehavior101040101 = BaseClass("LevelBehavior101040101",LevelBehaviorBase)
--击败两名从士
function LevelBehavior101040101:__init(fight)
	self.fight = fight
end

function LevelBehavior101040101.GetGenerates()
	local generates = {900040,900042,2030202}
	return generates
end

function LevelBehavior101040101.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101040101:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
		
	self.weakGuide =
	{
		[1] = {Id = 2011,state = false,Describe ="推动摇杆进行移动",count = 0},
		[2] = {Id = 2012,state = false,Describe ="长按进入跑步状态",count = 0},
		[3] = {Id = 2013,state = false,Describe ="连续点击2次跳跃可二段跳",count = 0},
		[4] = {Id = 2014,state = false,Describe ="长按在墙面上奔跑",count = 0},
		[5] = {Id = 2015,state = false,Describe ="点击按钮使用普通攻击",count = 0},
		[6] = {Id = 2016,state = false,Describe ="普攻积攒日相能量",count = 0},
		[7] = {Id = 2017,state = false,Describe ="消耗日相能量释放技能",count = 0},
		[8] = {Id = 2018,state = false,Describe ="点击按钮释放绝技",count = 0},
		[9] = {Id = 2019,state = false,Describe ="消耗日相能量释放技能",count = 0},
		[10] = {Id = 2009,state = false,Describe ="在受到红眼攻击前，按下闪避键将进入异质空间",count = 0},
	}
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	
	self.dialogList =
	{
		[1] = {Id = 101040901,state = self.dialogStateEnum.NotPlaying},--噬脉生物出现
		[2] = {Id = 101041001,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	
	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010401Mb1",entityId = 900040},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010401Mb2",entityId = 900040},
	}
	
	self.waveList =
	{
		[1] = {1}
	}
	
	self.monsterDead = 0
	
	self.time = 0
	self.timeStart = 0
	self.blockInf =
	{
		[1] = {Id = nil ,bp = "Task1010401Wall1",entityId = 2030202},
	}
	self.watchPos = "watchPosition1"
	self.monLev = 1
	
	self.creatPos = nil
end

function LevelBehavior101040101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)
	
	if self.missionState == 0 then
		--添加区域内的花墙
		self:CreateWall(self.blockInf)
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		if not self.creatPos then
			local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010401Area01","Logic10020001_6")
			if inArea then
				local pos = self:ReturnPosition(self.role,4.7,10,10,0.5)
				if pos then
					BehaviorFunctions.SetTipsGuideState(false)
					self.creatPos = pos
				end
			end
		else
			--延迟召唤小怪
			BehaviorFunctions.AddDelayCallByFrame(5,self,self.Assignment,"missionState",2.1)
			--BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0)
			--禁用角色输入
			self:DisablePlayerInput(true,true)
			BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",false) --摇杆
			BehaviorFunctions.SetFightMainNodeVisible(2,"J",false) --普攻
			BehaviorFunctions.SetFightMainNodeVisible(2,"O",false) --跳跃
			BehaviorFunctions.SetFightMainNodeVisible(2,"K",false) --疾跑
			--local camPos = BehaviorFunctions.GetTerrainPositionP("Task1010401Mb1",10020001,"Logic10020001_6")
			--self:LevelLookAtPos(camPos,22002,90)
			local camPos = BehaviorFunctions.GetPositionOffsetBySelf(self.role,9,0)
			self:LevelLookAtPos(camPos,22002,-1)
			----播放遇敌timeline
			--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
			--self.dialogList[1].state = self.dialogStateEnum.Playing
			--开启空气墙
			BehaviorFunctions.ActiveSceneObj("101040101Airwall",true,self.levelId)
			--角色战斗待机动作
			BehaviorFunctions.DoSetEntityState(self.role,FightEnum.EntityState.FightIdle)
			self.missionState = 2
		end
	end
	
	if self.missionState == 2.1 then
		--召唤战斗区域1的小怪
		for i,v in ipairs (self.waveList[1]) do
			--local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,10020001,"Logic10020001_6")
			self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,self.creatPos.x,self.creatPos.y,self.creatPos.z,nil,nil,nil,self.levelId,self.monLev)
			self.monsterList[v].state = self.monsterStateEnum.Live
			BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
			--关闭警戒
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
			--设置脱战范围
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",200)
			--设置目标追踪范围
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",200)
			--元素累积相关处理
			--隐藏元素条
			BehaviorFunctions.ShowEntityLifeBarElementBar(self.monsterList[v].Id,false)
			--锁住元素条
			BehaviorFunctions.EnableEntityElementStateRuning(self.monsterList[v].Id, FightEnum.ElementState.Accumulation, false,-1)
			----怪物停止攻击
			--BehaviorFunctions.SetEntityValue(self.monsterList[1].Id,"skillList",{})
			--停止行为树
			BehaviorFunctions.AddDelayCallByFrame(1,BehaviorFunctions,BehaviorFunctions.AddBuff,self.role,self.monsterList[1].Id,900000012)
		end
		BehaviorFunctions.AddDelayCallByFrame(45,self,self.Assignment,"missionState",2.3)
		self.missionState = 2.2
	end
	
	if self.missionState == 2.3 then
		BehaviorFunctions.CastSkillByTarget(self.monsterList[1].Id,90004014,self.role)
		BehaviorFunctions.AddDelayCallByFrame(33,self,self.Assignment,"missionState",2.5)
		self.missionState = 2.4
	end
	
	if self.missionState == 2.5 then
		BehaviorFunctions.AddBuff(self.role,self.role,200000008)
		BehaviorFunctions.AddBuff(self.role,self.monsterList[1].Id,200000008)
		--闪避视频引导
		BehaviorFunctions.ShowGuideImageTips(20025)
		----打开闪避按钮
		--BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --疾跑
		--if self.weakGuide[10].state == false then
			--self:WeakGuide(self.weakGuide[10].Id)
			--self.weakGuide[10].state = true
		--end
		self.missionState = 2.6
	end
	
	if self.missionState == 2.6 then
		if BehaviorFunctions.CheckKeyDown(FightEnum.KeyEvent.Dodge) then
			--禁用角色输入
			self:DisablePlayerInput(true,true)
			BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,200000008)
			BehaviorFunctions.RemoveBuff(self.role,200000008)
			self.missionState = 2.7
		end
	end
	
	if self.missionState == 2.7 then
		--播放遇敌timeline
		BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		self.dialogList[1].state = self.dialogStateEnum.Playing
		self.missionState = 2.8
	end
	
	if self.missionState == 2.9 then
		--开启角色输入
		self:DisablePlayerInput(false,false)
		BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能
		self.missionState = 3
	end
	
	if self.missionState == 3 then
		if BehaviorFunctions.CheckEntity(self.levelCam2) then
			BehaviorFunctions.RemoveEntity(self.levelCam2)
		end
		--恢复技能显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"Joystick",true) --摇杆
		BehaviorFunctions.SetFightMainNodeVisible(2,"J",true) --普攻
		BehaviorFunctions.SetFightMainNodeVisible(2,"O",true) --跳跃
		--设置玩家能量条
		BehaviorFunctions.SetEntityAttr(self.role,1201,7000)
		--恢复能量条显示
		BehaviorFunctions.SetFightMainNodeVisible(2,"PowerGroup",true,1)
		BehaviorFunctions.StopSetFightMainNodeVisible("PowerGroup")
		--替换关卡进度
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		BehaviorFunctions.ShowTip(101060801,0)
		self.missionState = 4
	end
		
	--怪物死亡检查
	if self.missionState == 4 then
		--屏蔽核心被动
		if BehaviorFunctions.GetEntityAttrVal(self.role,1204)~=0 then
			BehaviorFunctions.SetEntityAttr(self.role,1204,0,1)
		end
		--第一段timeline播放结束后
		if self.dialogList[1].state == self.dialogStateEnum.PlayOver then
			local yellowPowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201)
			if yellowPowerRatio >= 7000 then
				--弱引导日相
				if self.weakGuide[7].state == false then
					self:WeakGuide(self.weakGuide[7].Id)
					--暂停时间
					BehaviorFunctions.AddBuff(self.role,self.role,200000008)
					BehaviorFunctions.AddBuff(self.role,self.monsterList[1].Id,200000008)
					self.weakGuide[7].state = true
				end
				if self.weakGuide[6].state then
					self:RemoveWeakGuide()
				end
			else
				--弱引导普攻
			if self.weakGuide[6].state == false then
					self:WeakGuide(self.weakGuide[6].Id)
					self.weakGuide[6].state = true
				end
			end
		end
		local monsterList = self.waveList[1]
		local listLenth = #monsterList
		for i,v in ipairs (monsterList) do
			if self.monsterList[v].state ~= self.monsterStateEnum.Dead then
				return
			else
				if i == listLenth then
					self.timeStart = BehaviorFunctions.GetEntityFrame(self.role)
					--关闭所有引导
					self:RemoveWeakGuide()
					self.missionState = 5
				end
			end
		end
	end
	
	--战斗结束
	if self.missionState == 5 and self.time - self.timeStart >= 15 then
		--BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
		BehaviorFunctions.HideTip()
		if self.blockInf[1].Id ~= nil then
			if BehaviorFunctions.CheckEntity(self.blockInf[1].Id) then
				--玩家看着花墙消失
				local pos = BehaviorFunctions.GetTerrainPositionP(self.watchPos,10020001,"Logic10020001_6")
				self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
				self.levelCam = BehaviorFunctions.CreateEntity(22001,nil,0,0,0,nil,nil,nil,self.levelId)
				BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.empty)
				BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.blockInf[1].Id)
				BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
				BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
				BehaviorFunctions.AddDelayCallByFrame(80,BehaviorFunctions,BehaviorFunctions.StartStoryDialog,self.dialogList[2].Id)
				BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.blockInf[1].Id)
				BehaviorFunctions.SetEntityAttr(self.blockInf[1].Id,1001,0)
				--BehaviorFunctions.AddDelayCallByFrame(10,BehaviorFunctions,BehaviorFunctions.SetEntityAttr,self.blockInf[1].Id,1001,0)
			end
		end
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101040101Airwall",false,self.levelId)
		self.missionState = 6
	end
	
end

function LevelBehavior101040101:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in ipairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(i,false)
		end
	end
	if closeUI then
		--屏蔽战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",false)
	else
		--显示战斗主UI
		BehaviorFunctions.SetFightMainNodeVisible(2,"PanelParent",true)
	end
end

function LevelBehavior101040101:LevelLookAtPos(pos,type,frame,bindTransform)
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	self.levelCam2 = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	if frame > 0 then
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam2, false)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
	end
end

--技能循环引导
function LevelBehavior101040101:SkillGuide()
	--逻辑：蓝点能放先放蓝点，黄点能放先放黄点，不能放就放普攻
	local yellowPowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1201)
	local bluePowerRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1202)
	if bluePowerRatio >= 6665 then
		if self.weakGuide[8].state == false then
			--普攻弱引导重开
			self.weakGuide[6].state = false
			--日相技能弱引导重开
			self.weakGuide[7].state = false
			self:WeakGuide(self.weakGuide[8].Id)
		end
	else
		if yellowPowerRatio < 7000 then
			--弱引导普攻
			if self.weakGuide[6].state == false then
				--日相技能弱引导重开
				self.weakGuide[7].state = false
				--月相技能弱引导重开
				self.weakGuide[8].state = false
				self:WeakGuide(self.weakGuide[6].Id)
			end
		elseif yellowPowerRatio >= 7000 then
			if self.weakGuide[7].state == false then
				--普攻弱引导重开
				self.weakGuide[6].state = false
				--月相技能弱引导重开
				self.weakGuide[8].state = false
				self:WeakGuide(self.weakGuide[7].Id)
			end
		end
	end
end

--创建墙体
function LevelBehavior101040101:CreateWall(list)
	for i,v in ipairs (list) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,10020001,"Logic10020001_6")
		local rotate = BehaviorFunctions.GetTerrainRotationP(v.bp,10020001,"Logic10020001_6")
		v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
		BehaviorFunctions.DoMagic(v.Id,v.Id,900000007)
		BehaviorFunctions.SetEntityEuler(v.Id,rotate.x,rotate.y,rotate.z)
	end
end

--移除墙体
function LevelBehavior101040101:RemoveWall(list)
	for i,v in ipairs (list) do
		if v.Id ~= nil then
			local result = BehaviorFunctions.CheckEntity(v.Id)
			if result == true then
				BehaviorFunctions.SetEntityAttr(v.Id,1001,0)
			end
		end
	end
end

--图片引导开启/关闭检测
function LevelBehavior101040101:OnGuideImageTips(tipsId,isOpen)
	if tipsId == 20025 and isOpen == false then
		--开启角色输入
		self:DisablePlayerInput(false,false)
		--打开闪避按钮
		BehaviorFunctions.SetFightMainNodeVisible(2,"K",true) --疾跑
		--闪避弱引导
		if self.weakGuide[10].state == false then
			self:WeakGuide(self.weakGuide[10].Id)
			self.weakGuide[10].state = true
		end
	end
end

--开启弱引导，并且关闭其他弱引导
function LevelBehavior101040101:WeakGuide(guideId)
	local result = false
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
		if v.Id == guideId then
			v.state = true
			result = true
		end
	end
	if result == true then
		BehaviorFunctions.PlayGuide(guideId,1,1)
	end
end

--关闭所有弱引导
function LevelBehavior101040101:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end

function LevelBehavior101040101:OnGuideFinish(guideId,stage)
	if guideId == self.weakGuide[7].Id then
		--移除停止行为树
		if BehaviorFunctions.HasBuffKind(self.monsterList[1].Id,900000012) then
			BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,900000012)
		end
		--恢复暂停时间
		BehaviorFunctions.RemoveBuff(self.monsterList[1].Id,200000008)
		BehaviorFunctions.RemoveBuff(self.role,200000008)
	end
end

function LevelBehavior101040101:RemoveEntity(instanceId)

end

function LevelBehavior101040101:__delete()

end

--死亡事件
function LevelBehavior101040101:Death(instanceId,isFormationRevive)
	if isFormationRevive then	
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		self:RemoveWall(self.blockInf)
		self:RemoveWeakGuide()
		BehaviorFunctions.HideTip()
		--关闭空气墙
		BehaviorFunctions.ActiveSceneObj("101040101Airwall",false,self.levelId)
		--移除关卡
		BehaviorFunctions.RemoveLevel(101040101)
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
				--BehaviorFunctions.ShowTip(101060801,self.monsterDead)
				BehaviorFunctions.ChangeTitleTipsDesc(101060801,self.monsterDead)
			end
		end
	end
end

function LevelBehavior101040101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			if dialogId == self.dialogList[2].Id then
				--发送任务完成
				BehaviorFunctions.SendTaskProgress(101040101,1,1)
				--任务追踪恢复
				BehaviorFunctions.SetTipsGuideState(true)
				--日相视频引导
				BehaviorFunctions.ShowGuideImageTips(20021)
				--移除关卡
				BehaviorFunctions.RemoveLevel(101040101)
			end
			--遇敌timeline结束
			if dialogId == self.dialogList[1].Id then
				BehaviorFunctions.SetFightMainNodeVisible(2,"I",true) --技能
				self.missionState = 2.9
				----图片引导日相循环
				--BehaviorFunctions.ShowGuideImageTips(20010)
			end
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior101040101:StoryStartEvent(dialogId)

end

function LevelBehavior101040101:PathFindingBegin(instanceId,pos)
	local nextPosition = BehaviorFunctions.GetTerrainPositionP(pos,10020001,"Logic10020001_6")
	local result = BehaviorFunctions.SetPathFollowPos(instanceId,nextPosition)
	if result == true then
		BehaviorFunctions.DoSetMoveType(instanceId,FightEnum.EntityMoveSubState.Run)
		return true
	else
		LogError("无路径可供寻路")
		return false
	end
end

function LevelBehavior101040101:PathFindingEnd(instanceId,result)
	BehaviorFunctions.DoLookAtTargetImmediately(instanceId,self.role)
	BehaviorFunctions.ClearPathFinding(instanceId)
	BehaviorFunctions.DoSetEntityState(instanceId,FightEnum.EntityState.Idle)
end

--赋值
function LevelBehavior101040101:Assignment(variable,value)
	self[variable] = value
end

---返回范围内没有障碍的位置
function LevelBehavior101040101:ReturnPosition(target,distance,startAngel,endAngel,checkheight,checkCollision,returnFarthestPos)
	local posTable = {}
	local farthestPos = nil
	for angel = startAngel,endAngel,5 do
		local pos = BehaviorFunctions.GetPositionOffsetBySelf(target,distance,angel)
		local targetPos = BehaviorFunctions.GetPositionP(target)
		--点位克隆
		local posClone = TableUtils.CopyTable(pos)
		local targetposClone = TableUtils.CopyTable(targetPos)
		--如果有检查高度则检查
		if checkheight then
			posClone.y = posClone.y + checkheight
			targetposClone.y = targetposClone.y + checkheight
		end
		--获取与该点的距离
		local dis = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,posClone,false)
		--获取与该障碍的距离
		if farthestPos then
			--选取最远的距离
			local dis2 = BehaviorFunctions.GetDistanceBetweenObstaclesAndPos(targetposClone,farthestPos,false)
			if dis > dis2 then
				farthestPos = posClone
				farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
			end
		else
			farthestPos = BehaviorFunctions.GetPositionOffsetBySelf(target,dis,angel)
		end
		--检测障碍：
		if not BehaviorFunctions.CheckObstaclesBetweenPos(targetposClone,posClone,false) then
			local layerHight,layer = BehaviorFunctions.CheckPosHeight(posClone)
			if layerHight <= 1 then
				if layer == FightEnum.Layer.Terrain or layer == 0 then
					table.insert(posTable,pos)
				end
			end
		end
	end
	--返回组中角度最中心的点
	local posNum = #posTable
	if #posTable ~= 0 then
		local middleNum = math.ceil(posNum/2)
		return posTable[middleNum]
	else
		if not returnFarthestPos then
			return nil
		else
			--返回最远的点
			return farthestPos
		end
	end
end