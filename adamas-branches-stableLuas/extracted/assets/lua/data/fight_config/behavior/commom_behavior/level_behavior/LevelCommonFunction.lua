LevelCommonFunction = BaseClass("LevelCommonFunction",LevelBehaviorBase)
--预加载
function LevelCommonFunction.GetGenerates()
	local generates = {}
	return generates
end

--参数初始化
function LevelCommonFunction:Init()
----------------基础参数--------------------
--开放参数
	self.levelId = nil
--基础参数
	self.role = nil
	--用于承载和管理该关卡创建的buff，关卡卸载时移除
	self.levelController = BehaviorFunctions.CreateEntity(2001,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	
	--关卡状态枚举
	self.levelStateEnum =
	{
		Default = 0,--默认状态
		Start = 1,--关卡开始状态
		Ongoing = 2,--关卡进行中
		LevelSuccess = 3,--关卡胜利
		LevelFail = 4,--关卡失败
		LevelEnd = 5,--关卡结束，进入移除
	}
	--关卡状态
	self.levelState = self.levelStateEnum.Default
	--关卡名称
	self.levelName = "默认关卡名称"
	--关卡是否成功
	self.isSuccess = false
	
----------------刷怪相关--------------------
--开放参数
	--关卡内怪物
	self.monsterList = 
	{
		--输出出来的一个组的格式如下
		--[1] = {
				 --list = {
							--{id = nil ,posName = nil ,wave = 1, instanceId = nil, lev = 0, isDead = false, engage = nil,infight = false,buff = {2001}}
						--},
				 --monsterNum = 0,
				 --deadMonsterNum = 0,
				 --currentWave = 0,
				 --topWave = 1,
			  --}
	}
	--怪物世界等级偏移
	self.monsterLevelBias =
	{
		[FightEnum.EntityNpcTag.Monster] = 0,
		[FightEnum.EntityNpcTag.Elite] = 0,
		[FightEnum.EntityNpcTag.Boss] = 0,
	}
	
--基础参数
	--当前怪物组数量
	self.currentGroupNum = 0
	--列表内已死亡怪物计数
	self.totalDeadMonsterNum = 0
	--列表内怪物总数
	self.totalMonsterNum = 0
	
--------------关卡模板相关--------------------	
--开放参数
--基础参数
	--关卡预设模板类型枚举	
	self.levelTypeEnum =
	{
		NoType = 0,
		TaskLevel = 1,
		ChallengeLevel = 2,
		RogueLevel = 3,
	}
	--关卡类型
	self.levelType = self.levelTypeEnum.NoType

----------------挑战条件相关--------------------
--开放参数
--基础参数
	--小队是否死亡
	self.formationDead = false
	--是否显示波次提示
	self.showWaveTips = false
	--是否显示敌人剩余数提示
	self.showEnemyRemainTips = false
	
----------------胜负条件相关--------------------
--开放参数
--基础参数
	--警告倒计时计时器ID
	self.warningCountDownId = nil
	--警告倒计时剩余时间
	self.warningCountDownSecond = nil
	--警告倒计时是否完成
	self.warningCountDownFinish = false
	
--失败条件：超出距离
	--是否超出关卡极限距离
	self.distanceLimit = false
	--超过距离警告当前时间
	self.distanceWarningCurrentTime = nil
	--超过距离警告结束时间
	self.distanceWarningEndTime = nil
	--超过距离警告当前剩余秒数
	self.warningSecond = 0
	
--失败条件：超出区域
	--Area名称
	self.areaLimitNameList = {}
	--是否超出Area
	self.leavingArea = false
	
--失败条件：时间限制
	--是否开启时间限制
	self.timeLimit = false
	--时间限制计时器ID
	self.timeLimitTimer = nil
	--时间限制是否失败
	self.timeLimitFinish = false
    --时间限制剩余秒数
	self.timeLimitSecond = 0
	
----------------相机相关--------------------
--开放参数
--基础参数
	--记录当前的相机组实体
	self.levelCameraGroup = 
	{
		--{camEntity = nil,lookatEntity = nil}
	}
	--当前相机组数量
	self.currentCamGroupNum = 0
	
----------------肉鸽相关--------------------
--开放参数
	self.guideDistance = 50
--基础参数	
	self.guide = nil
	self.guideEntity = nil
	self.guidePos = nil
	self.GuideTypeEnum = {
		Police = FightEnum.GuideType.Rogue_Police,
		Challenge = FightEnum.GuideType.Rogue_Challenge,
		Riddle = FightEnum.GuideType.Rogue_Riddle,
	}
	self.guideType = self.GuideTypeEnum.Police
	self.rogueEventId = nil
	
--------------延时调用相关------------------
	--基础参数
	self.delayCallList = {}
	--当前延时数量
	self.currentdelayCallNum = 0
-------------------------------------------
end

function LevelCommonFunction:LateInit()
	
end

--帧事件
function LevelCommonFunction:Update()
	if not self.role then
		self.role = BehaviorFunctions.GetCtrlEntity()
	end

	self:CheckInFight()
	
	--不设置任何类型模板的情况下啥也不跑
	if self.levelType == self.levelTypeEnum.NoType then
		
	--如果被设置为挑战关卡则运行挑战关卡状态机
	elseif self.levelType == self.levelTypeEnum.ChallengeLevel then
		self:ChallengeLevelFSM()
	
	--如果被设置为任务关卡则运行任务关卡状态机
	elseif self.levelType == self.levelTypeEnum.TaskLevel then
		self:TaskLevelFSM()
		
	--如果被设置为肉鸽关卡则运行肉鸽关卡状态机
	elseif self.levelType == self.levelTypeEnum.RogueLevel then
		self:RogueLevelFSM()
	end

end

----------------函数封装--------------------

--玩家传送且看向
function LevelCommonFunction:SetPlayerPos(position,lookAtPos)
	--设置玩家角色传送
	local pp1 = BehaviorFunctions.GetTerrainPositionP(position,self.levelId)
	BehaviorFunctions.InMapTransport(pp1.x,pp1.y,pp1.z)
	--设置玩家角色面向
	local lp1 = BehaviorFunctions.GetTerrainPositionP(lookAtPos,self.levelId)
	BehaviorFunctions.DoLookAtPositionImmediately(self.role,lp1.x,nil,lp1.z)
	--初始相机朝向
	BehaviorFunctions.CameraPosReduction(0)
end

function LevelCommonFunction:CheckPlayerInArea()
	
end

--关卡刷怪
function LevelCommonFunction:LevelCreateMonster(monsterList)
	if self.levelId then
		--在表中插入一个新的怪物组
		local tempList = {list = monsterList ,monsterNum = 0, currentWave = 1,deadMonsterNum = 0,topWave = 0}
		self.currentGroupNum = self.currentGroupNum + 1
		table.insert(self.monsterList,self.currentGroupNum,tempList)
		--计算出该怪物组的最高波数
		for i,v in ipairs(self.monsterList[self.currentGroupNum].list) do
			if self.monsterList[self.currentGroupNum].topWave < v.wave then
				self.monsterList[self.currentGroupNum].topWave = v.wave
			end
		end
		self.monsterList[self.currentGroupNum] = self:SummonMonster(self.monsterList[self.currentGroupNum])
		self.totalMonsterNum = self.totalMonsterNum + #self.monsterList[self.currentGroupNum].list
		--返回怪物组
		return self.monsterList[self.currentGroupNum]
	else	
		LogError("没有在行为树中对LevelCommonFunction中的levelId变量赋值，请检查行为树")
	end
end

--创建怪物
function LevelCommonFunction:SummonMonster(monsterList)
	--直接对原表进行修改，不进行地址引用的覆盖
	local table = monsterList
	for i,v in ipairs(table.list) do
		if v.id and v.wave == table.currentWave then
			if v.posName then
				local pos = BehaviorFunctions.GetTerrainPositionP(v.posName,self.levelId)
				local rot = BehaviorFunctions.GetTerrainRotationP(v.posName,self.levelId)
				if pos then
					--世界等级偏移计算
					local npcTag = BehaviorFunctions.GetTagByEntityId(v.id)
					local worldMonsterLevel = BehaviorFunctions.GetEcoEntityLevel(npcTag)
					local monsterLevel = worldMonsterLevel + self.monsterLevelBias[npcTag]
					--如果没有特别指定该怪物等级则直接等于按怪物标签偏移后的世界等级
					if v.lev == 0 or v.lev == nil then
						if monsterLevel > 0 then
							v.lev = monsterLevel
						else
							v.lev = worldMonsterLevel
							LogError("怪物世界等级偏移低于0级，请检查怪物世界等级偏移值")
						end
					end
					v.instanceId = BehaviorFunctions.CreateEntity(v.id,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId,v.lev)
					v.isDead = false
					v.infight = false
					--是否自动进入交战状态
					if v.engage ~= false then
						v.engage = true
					end
					table.monsterNum = table.monsterNum + 1
					--根据点位设置怪物朝向
					BehaviorFunctions.SetEntityEuler(v.instanceId,rot.x,rot.y,rot.z)
					--BehaviorFunctions.DoLookAtTargetImmediately(v.instanceId,self.role)
					if v.engage then
						v.infight = true
						--设置怪物的战斗目标
						BehaviorFunctions.AddFightTarget(v.instanceId,self.role)
						BehaviorFunctions.SetEntityValue(v.instanceId,"battleTarget",self.role)
						--关闭警戒
						BehaviorFunctions.SetEntityValue(v.instanceId,"haveWarn",false)
					end
					--设置脱战范围
					BehaviorFunctions.SetEntityValue(v.instanceId,"ExitFightRange",80)
					--设置目标追踪范围
					BehaviorFunctions.SetEntityValue(v.instanceId,"targetMaxRange",80)
				else
					LogError("未找到对应刷怪点位："..v.posName.." 请检查点位数据："..self.levelId)
				end
			else
				LogError("PosName为nil,请检查monsterList数据")
			end
		end
	end
	return table
end

--检查组内怪物的InFight状态(临时的，下个版本改用回调做)
function LevelCommonFunction:CheckInFight()
	if next(self.monsterList) then
		local allFightTarget = BehaviorFunctions.GetAllFightTarget()
		for i,v in ipairs(allFightTarget) do
			for i2,v2 in ipairs(self.monsterList[self.currentGroupNum].list) do
				if v2.instanceId == v then
					v2.infight = true
				end
			end
		end
	end
end

--进战时让其他关卡创建的怪物一起进战(临时的，下个版本改)
function LevelCommonFunction:CompanyFight(range)
	for i,v in ipairs(self.monsterList[self.currentGroupNum].list) do
		if v.infight == false then
			for i2,v2 in ipairs(self.monsterList[self.currentGroupNum].list) do
				if v2.instanceId ~= v.instanceId and v2.infight then
					local dis = BehaviorFunctions.GetDistanceFromTarget(v2.instanceId,v.instanceId)
					if dis and dis <= range then
						--关闭警戒
						BehaviorFunctions.SetEntityValue(v.instanceId,"haveWarn",false)
						BehaviorFunctions.AddFightTarget(v.instanceId,self.role)
						BehaviorFunctions.SetEntityValue(v.instanceId,"battleTarget",self.role)
					end
				end
			end
		end
	end
end

--时间暂停
function LevelCommonFunction:LevelStop()        
	BehaviorFunctions.DoMagic(self.LevelController,self.LevelController,200000008)
end

--解除时间暂停
function LevelCommonFunction:LevelContinue()
	BehaviorFunctions.RemoveBuff(self.LevelController,200000008)	
end

--显示敌人剩余数提示
function LevelCommonFunction:ShowEnemyRemainTips(isShow,mainTitleText)
	if isShow then
		local titleText = "击败所有敌人"
		if mainTitleText then
			titleText = mainTitleText
		end
		self.countTips = BehaviorFunctions.AddLevelTips(100000004,self.levelId,titleText)
		BehaviorFunctions.ChangeLevelSubTips(self.countTips,1,self.totalDeadMonsterNum.."/"..self.totalMonsterNum)
		--BehaviorFunctions.ShowTip(100000004,titleText)
		--BehaviorFunctions.ChangeSubTipsDesc(1,100000004,self.totalDeadMonsterNum.."/"..self.totalMonsterNum)
		self.showEnemyRemainTips = true
	else
		BehaviorFunctions.RemoveLevelTips(self.countTips)
		--BehaviorFunctions.HideTip(100000004)
		self.showEnemyRemainTips = false
	end
end

--显示敌人波次提示
function LevelCommonFunction:ShowWaveTips(isShow)
	if isShow then
		self.showWaveTips = true
	else
		self.showWaveTips = false
	end
end

--镜头看向目标实体
function LevelCommonFunction:LevelCameraLookAtInstance(type,frame,rolesBindTransform,instanceId,insBindTransform,blendInTime,blendOutTime)
	--在表中插入一个新的相机组
	local tempList = {camEntity = nil,lookatEntity = nil,rolesBindTransform = rolesBindTransform}
	self.currentCamGroupNum = self.currentCamGroupNum + 1
	table.insert(self.levelCameraGroup,self.currentCamGroupNum,tempList)
	
	--设置镜头过渡
	if blendInTime then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",blendInTime)
	end
	if blendOutTime then
		BehaviorFunctions.SetVCCameraBlend("LevelCamera","**ANY CAMERA**",blendOutTime)
	end
	
	--创建相机实体
	self.levelCameraGroup[self.currentCamGroupNum].camEntity = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,instanceId)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCameraGroup[self.currentCamGroupNum].camEntity,self.role,rolesBindTransform)
	BehaviorFunctions.CameraEntityLockTarget(self.levelCameraGroup[self.currentCamGroupNum].camEntity,instanceId,insBindTransform)
	
	--延迟移除
	if frame >= 0 then
		BehaviorFunctions.AddDelayCallByFrame(frame,self,self.RemoveLevelCamera,self.currentCamGroupNum)
	end
	
	--返回当前相机组ID
	return self.currentCamGroupNum
end

--镜头看向目标点位
function LevelCommonFunction:LevelCameraLookAtPos(type,frame,rolesBindTransform,lookAtPos,blendInTime,blendOutTime)
	--在表中插入一个新的相机组
	local tempList = {camEntity = nil,lookatEntity = nil,rolesBindTransform = rolesBindTransform}
	self.currentCamGroupNum = self.currentCamGroupNum + 1
	table.insert(self.levelCameraGroup,self.currentCamGroupNum,tempList)
	
	--设置镜头过渡
	if blendInTime then
		BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",blendInTime)
	end
	if blendOutTime then
		BehaviorFunctions.SetVCCameraBlend("LevelCamera","**ANY CAMERA**",blendOutTime)
	end
	
	local pos = BehaviorFunctions.GetTerrainPositionP(lookAtPos,self.levelId)	
	self.levelCameraGroup[self.currentCamGroupNum].lookatEntity = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	self.levelCameraGroup[self.currentCamGroupNum].camEntity = BehaviorFunctions.CreateEntity(type,nil,nil,nil,nil,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.levelCameraGroup[self.currentCamGroupNum].lookatEntity)
	if rolesBindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCameraGroup[self.currentCamGroupNum].camEntity,self.role,rolesBindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCameraGroup[self.currentCamGroupNum].camEntity,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCameraGroup[self.currentCamGroupNum].camEntity,self.levelCameraGroup[self.currentCamGroupNum].lookatEntity)
	
	--延迟移除
	if frame >= 0 then
		BehaviorFunctions.AddDelayCallByFrame(frame,self,self.RemoveLevelCamera,self.currentCamGroupNum)
	end

	--返回当前相机组ID
	return self.currentCamGroupNum
end

--移除相机
function LevelCommonFunction:RemoveLevelCamera(cameraGroupId)
	--先找到对应的相机组
	for i,v in ipairs(self.levelCameraGroup) do
		if i == cameraGroupId then
			--移除相机实体
			if v.camEntity then
				if BehaviorFunctions.CheckEntity(v.camEntity) then
					BehaviorFunctions.RemoveEntity(v.camEntity)
				end
			end
			--移除相机注视实体
			if v.lookatEntity then
				if BehaviorFunctions.CheckEntity(v.lookatEntity) then
					BehaviorFunctions.RemoveEntity(v.lookatEntity)
				end
			end
		end
	end
	BehaviorFunctions.SetVCCameraBlend("**ANY CAMERA**","LevelCamera",0.3)
	BehaviorFunctions.SetVCCameraBlend("LevelCamera","**ANY CAMERA**",0.3)
end

--关闭玩家按键输入
function LevelCommonFunction:DisablePlayerInput(isOpen,closeUI)
	--取消摇杆移动
	BehaviorFunctions.CancelJoystick()
	if isOpen then
		----禁用摇杆输入
		--BehaviorFunctions.SetJoyMoveEnable(self.role,false)
		--关闭按键输入
		for i,v in pairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(v,true)
		end
	else
		BehaviorFunctions.SetJoyMoveEnable(self.role,true)
		for i,v in pairs(FightEnum.KeyEvent) do
			BehaviorFunctions.ForbidKey(v,false)
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

--获取玩家与点位之间的距离
function LevelCommonFunction:GetDistanceBetweenPos(position)
	local player = BehaviorFunctions.GetCtrlEntity()
	local playerPos = BehaviorFunctions.GetPositionP(player)
	local targetPos = BehaviorFunctions.GetTerrainPositionP(position,self.levelId)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,targetPos)
	return distance
end

---返回范围内没有障碍的位置
function LevelCommonFunction:ReturnPosition(target,distance,startAngel,endAngel,checkheight,returnFarthestPos)
	local posTable = {}
	local posTable2 = {}
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
				if layer == FightEnum.Layer.Terrain or layer == FightEnum.Layer.Default then
					if BehaviorFunctions.CheckPosIsInScreen(pos) then
						table.insert(posTable2,pos)
					end
					--if self:CheckPosInCam(pos) then
					--table.insert(posTable2,pos)
					--end
					table.insert(posTable,pos)
				end
			end
		end
	end
	if #posTable2 ~= 0 then
		local randomPos = math.random(1,#posTable2)
		return posTable2[randomPos]
	else
		if #posTable ~= 0 then
			local randomPos = math.random(1,#posTable)
			return posTable[randomPos]
		else
			if not returnFarthestPos then
				return nil
			else
				--返回最远的点
				return farthestPos
			end
		end
	end
end

--关卡延时调用秒数（卸载时自动移除剩余的DelayCall）
function LevelCommonFunction:AddLevelDelayCallByTime(time,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(time,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function LevelCommonFunction:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end

--移除所有关卡延时调用
function LevelCommonFunction:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end

--肉鸽追踪
function LevelCommonFunction:RogueGuidePointer(guideDistance,guideType)
	--设置rogue追踪标
	if self.guidePos then
		local pos = BehaviorFunctions.GetTerrainPositionP(self.guidePos.position,self.guidePos.positionId,self.guidePos.logicName)
	else
		if self.rogueEventId then
			self.guidePos = BehaviorFunctions.GetRoguelikePointInfo(self.rogueEventId)
		else
			LogError("没有在行为树中对LevelCommonFunction中的rogueEventId变量赋值，请检查行为树")
		end
	end
	
	local playerPos = BehaviorFunctions.GetPositionP(self.role)
	local distance = BehaviorFunctions.GetDistanceFromPos(playerPos,self.guidePos)
	if distance <= guideDistance then
		if not self.guide then
			self.guideEntity = BehaviorFunctions.CreateEntity(2001,nil,self.guidePos.x,self.guidePos.y,self.guidePos.z,nil,nil,nil,self.levelId)
			self.guide =BehaviorFunctions.AddEntityGuidePointer(self.guideEntity,guideType,0,false)
		end
	else
		--移除追踪标空实体
		if self.guideEntity and BehaviorFunctions.CheckEntity(self.guideEntity) then
			BehaviorFunctions.RemoveEntity(self.guideEntity)
			self.guideEntity = nil
		end
		--移除追踪标
		BehaviorFunctions.RemoveEntityGuidePointer(self.guide)
		self.guide = nil
	end
end

--设置关卡为普通关卡
function LevelCommonFunction:SetAsTaskLevel()
	if self.levelType ~= self.levelTypeEnum.TaskLevel then
		self.levelType = self.levelTypeEnum.TaskLevel
	end
end

--普通关卡状态机
function LevelCommonFunction:TaskLevelFSM()
	--关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then
		--关卡处于开始状态
	elseif self.levelState == self.levelStateEnum.Start then
		self.levelState = self.levelStateEnum.Ongoing

		--关卡处于进行中状态
	elseif self.levelState == self.levelStateEnum.Ongoing then

		--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccess then
		self.isSuccess = true
		self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		self.isSuccess = false
		self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then
		self:ShowEnemyRemainTips(false)
		self:ShowWaveTips(false)
		if self.timeLimitTimerId then
			BehaviorFunctions.StopLevelTimer(self.timeLimitTimerId)
		end
		if self.isSuccess == true then
			BehaviorFunctions.FinishLevel(self.levelId)
		else
			BehaviorFunctions.RemoveLevel(self.levelId)
		end
	end
end

--设置关卡为挑战关卡
function LevelCommonFunction:SetAsChallengeLevel(challengeRule)
	if self.levelType ~= self.levelTypeEnum.ChallengeLevel then
		--挑战开始用
		if challengeRule == "挑战开始" or challengeRule == nil then
			self.levelName = nil
		else
			self.levelName = challengeRule
		end
		self.levelType = self.levelTypeEnum.ChallengeLevel
	end
end

--挑战关卡状态机
function LevelCommonFunction:ChallengeLevelFSM()
	--关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then		
		--关卡处于开始状态
	elseif self.levelState == self.levelStateEnum.Start then
		if self.levelName then
			BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.ChallengeInfo,self.levelName,nil)
		else
			BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.Challenge,"挑战开始",nil)
		end
		self.levelState = self.levelStateEnum.Ongoing
		
		--关卡处于进行中状态
	elseif self.levelState == self.levelStateEnum.Ongoing then

		--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccess then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,true)
		self.isSuccess = true
		self.levelState = self.levelStateEnum.LevelEnd
		
		--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,self.levelName,false)
		self.isSuccess = false
		self.levelState = self.levelStateEnum.LevelEnd
		
		--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then
		self:ShowEnemyRemainTips(false)
		self:ShowWaveTips(false)
		if self.timeLimitTimerId then
			BehaviorFunctions.StopLevelTimer(self.timeLimitTimerId)
		end
		if self.isSuccess == true then
			BehaviorFunctions.FinishLevel(self.levelId)
		else
			BehaviorFunctions.RemoveLevel(self.levelId)
		end
	end
end

--设置关卡为肉鸽关卡
function LevelCommonFunction:SetAsRogueLevel(guideType,guideDistance)
	if self.levelType ~= self.levelTypeEnum.RogueLevel then
		if guideType then
			if guideType == "Police" then
				self.guideType = self.GuideTypeEnum.Police
			elseif guideType == "Challenge" then
				self.guideType = self.GuideTypeEnum.Challenge
			elseif guideType == "Riddle" then
				self.guideType = self.GuideTypeEnum.Riddle
			else
				LogError("没有该类型的肉鸽事件")
			end
		end
		if guideDistance then
			if type(guideDistance) == "number" then
				self.guideDistance = guideDistance
			else
				LogError("你在距离参数这里压根没输入数字，采用默认距离50。")
			end
		end
		self.levelType = self.levelTypeEnum.RogueLevel
	end
end

--肉鸽关卡状态机
function LevelCommonFunction:RogueLevelFSM()
	--关卡处于默认状态时
	if self.levelState == self.levelStateEnum.Default then
		self:RogueGuidePointer(self.guideDistance,self.guideType)
		
		--关卡处于开始状态
	elseif self.levelState == self.levelStateEnum.Start then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.WorldTitlePanel,self.levelName,nil)
		self.levelState = self.levelStateEnum.Ongoing

		--关卡处于进行中状态
	elseif self.levelState == self.levelStateEnum.Ongoing then

		--关卡处于胜利状态
	elseif self.levelState == self.levelStateEnum.LevelSuccess then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.CityThreatenEnd,self.levelName,true)
		self.isSuccess = true
		self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于失败状态
	elseif self.levelState == self.levelStateEnum.LevelFail then
		BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.CityThreatenEnd,self.levelName,false)
		self.isSuccess = false
		self.levelState = self.levelStateEnum.LevelEnd

		--关卡处于结束状态
	elseif self.levelState == self.levelStateEnum.LevelEnd then
		self:ShowEnemyRemainTips(false)
		self:ShowWaveTips(false)
		if self.timeLimitTimerId then
			BehaviorFunctions.StopLevelTimer(self.timeLimitTimerId)
		end
		if self.isSuccess == true then
			BehaviorFunctions.FinishLevel(self.levelId)
		else
			BehaviorFunctions.RemoveLevel(self.levelId)
		end
	end
end

--关卡胜利条件
function LevelCommonFunction:LevelSuccessCondition(...)
	local condition = {...}
	local conditionTotalNum = #condition
	local conditionFinishNum = 0
	--计算完成条件的数量
	for i,v in ipairs(condition) do
		if v == true then
			conditionFinishNum = conditionFinishNum + 1
		end
	end
	--如果全部条件已经被完成
	if conditionFinishNum == conditionTotalNum then
		if self.levelState == self.levelStateEnum.Ongoing then
			--关卡状态改为胜利
			self.levelState = self.levelStateEnum.LevelSuccess
		end
	end
end

--关卡失败条件
function LevelCommonFunction:LevelFailCondition(...)
	local condition = {...}
	--计算完成条件的数量
	for i,v in ipairs(condition) do
		if v == true then
			if self.levelState == self.levelStateEnum.Ongoing then
				--关卡状态改为失败
				self.levelState = self.levelStateEnum.LevelFail
			end
		end
	end
end

--关卡开始
function LevelCommonFunction:LevelStart()
	if self.levelState == self.levelStateEnum.Default then
		self.levelState = self.levelStateEnum.Start
	end
end

--返回当前关卡的状态
function LevelCommonFunction:ReturnLevelState()
	return self.levelState
end

--关卡挑战条件：击败所有敌人
function LevelCommonFunction:SuccessCondition_DefeatAllEnemy(monsterList)
	if monsterList then
		if monsterList.deadMonsterNum == monsterList.monsterNum then
			return true
		elseif monsterList.deadMonsterNum < monsterList.monsterNum then
			return false		
		end
	else

	end
end

--关卡失败条件：时间限制
function LevelCommonFunction:FailCondition_TimeLimit(timeLimit)
	if self.timeLimit == false then
		self.timeLimitTimerId = BehaviorFunctions.StartLevelTimer(timeLimit,FightEnum.DuplicateTimerType.FightTargetUI)
		self.timeLimit = true
	else
		if self.timeLimitFinish then
			return true
		else
			return false
		end
	end
end

--关卡失败条件：关卡距离限制
function LevelCommonFunction:FailCondition_Distance(pos,distance,timeLimit,distanceLimit)
	local characterPos = BehaviorFunctions.GetPositionP(self.role)
	local levelPos = BehaviorFunctions.GetTerrainPositionP(pos,self.levelId)
	local distanceBetweenPos = BehaviorFunctions.GetDistanceFromPos(characterPos,levelPos)
	--是否有极限距离
	if distanceLimit then
		--超出极限距离立刻判负
		if distanceLimit < distanceBetweenPos then
			BehaviorFunctions.RemoveLevelTips(100000006)
			--BehaviorFunctions.HideTip(100000006)
			return true
		end
	end
	--超出警告距离时
	if distance < distanceBetweenPos then
		if self.distanceLimit == false then
			self.distanceWarningCurrentTime = BehaviorFunctions.GetFightFrame()
			self.distanceWarningEndTime = self.distanceWarningCurrentTime + timeLimit*30
			self.warningSecond = timeLimit
			self.distanceLimit = true
		else
			self.distanceWarningCurrentTime = BehaviorFunctions.GetFightFrame()
			if self.distanceWarningEndTime > self.distanceWarningCurrentTime then
				local second = math.ceil((self.distanceWarningEndTime - self.distanceWarningCurrentTime)/30)
				if second < self.warningSecond then
					self.warningSecond = second
					BehaviorFunctions.ShowTip(100000006,second)
				end
			else
				BehaviorFunctions.HideTip(100000006)
				return true
			end
		end
	else
		if self.distanceLimit == true then
			self.distanceLimit = false
			BehaviorFunctions.HideTip(100000006)
		end
	end
	return false
end

--关卡失败条件：关卡区域限制
function LevelCommonFunction:FailCondition_LeavingArea(areaName,logicName,timeLimit)
	local isInArea = BehaviorFunctions.CheckEntityInArea(self.role,areaName,logicName)
	--如果离开了区域则
	if not self.leavingArea and not isInArea then
		if not self.warningCountDownId then
			self.warningCountDownId = BehaviorFunctions.StartLevelTimer(timeLimit,FightEnum.DuplicateTimerType.CountDown)
		end
		self.leavingArea = true
	--如果回到了区域
	elseif self.leavingArea and isInArea then
		if self.warningCountDownId then
			BehaviorFunctions.StopLevelTimer(self.warningCountDownId)
			BehaviorFunctions.HideTip(100000006)
			self.warningCountDownId = nil
		end
		self.leavingArea = false
	end
	--处于区域外时
	if self.leavingArea then
		local remainTime = BehaviorFunctions.ReturnLevelTimerTime(self.warningCountDownId)
		if remainTime then
			local second = math.ceil(remainTime)
			BehaviorFunctions.ShowTip(100000006,math.ceil(second))
		end
	end
	--如果超出警告时间
	if self.warningCountDownFinish then
		self.leavingArea = false
		return true
	else
		return false
	end
end

---------------------回调----------------------------------
--关卡被移除时触发
function LevelCommonFunction:RemoveLevel(levelId)
	if levelId == self.levelId then
		self:RemoveAllLevelDelayCall()
	end
end

--关卡完成时触发
function LevelCommonFunction:FinishLevel(levelId)
	if levelId == self.levelId then
		self:RemoveAllLevelDelayCall()
	end
end

--计时器结束回调
function LevelCommonFunction:TimerCountFinish(timerId)
	--失败条件时间限制返回失败
	if timerId == self.timeLimitTimerId then
		self.timeLimitFinish = true
	--倒计时警告返回失败
	elseif timerId == self.warningCountDownId then
		self.warningCountDownFinish = true
	end
end

--切换玩家控制对象
function LevelCommonFunction:OnSwitchPlayerCtrl(oldInstanceId,instanceId)
	self.role = BehaviorFunctions.GetCtrlEntity()
-----------------相机相关封装----------------
	--如果在开相机的过程中切换了角色则替换相机的跟随目标
	if next(self.levelCameraGroup) then
		for i,v in ipairs(self.levelCameraGroup) do
			if BehaviorFunctions.CheckEntity(v.camEntity) then
				BehaviorFunctions.CameraEntityFollowTarget(v.camEntity,instanceId,v.rolesBindTransform)
			end
		end
	end

	if self.monsterList and self.monsterList[self.currentGroupNum] then
		local table = self.monsterList[self.currentGroupNum]
		for k, v in ipairs(table.list) do
			if v.id and v.wave == table.currentWave then
				if v.engage then
					--设置怪物的战斗目标
					BehaviorFunctions.AddFightTarget(v.instanceId,self.role)
					BehaviorFunctions.SetEntityValue(v.instanceId,"battleTarget",self.role)
				end
			end
		end
	end
end

--死亡回调
function LevelCommonFunction:Death(instanceId,isFormationRevive)
-----------------胜负相关封装----------------
	--如果是小队死亡
	if isFormationRevive then
		if self.formationDead == false then
			self.formationDead = true
		end
	end
	
-----------------刷怪相关封装----------------
	if not isFormationRevive then
		if next(self.monsterList) then
			local totalMonsterRemain = 0
			local totalMonster = 0
			--根据每个怪物组查找对应的死亡怪物ID
			for i1, v1 in ipairs(self.monsterList) do
				totalMonster = totalMonster + #v1.list
				for i2,v2 in ipairs(v1.list) do
					if instanceId == v2.instanceId and v2.isDead == false then
						v2.isDead = true
						v2.infight = false
						v2.instanceId = nil
						v1.deadMonsterNum = v1.deadMonsterNum + 1
						self.totalDeadMonsterNum = self.totalDeadMonsterNum + 1
					end
					if v2.isDead == true then
						totalMonsterRemain = totalMonsterRemain - 1
					end
				end
				--判断是否进入下一波次
				if v1.deadMonsterNum == v1.monsterNum then
					if v1.topWave >= v1.currentWave + 1 then
						v1.currentWave = v1.currentWave + 1
						self.monsterList[i1] = self:SummonMonster(self.monsterList[i1])
						--波次提示
						if self.showWaveTips then
							BehaviorFunctions.ShowTip(100000005,v1.currentWave)
						end
					end
				end
			end
			--敌人数量tips变更
			if self.showEnemyRemainTips then
				BehaviorFunctions.ChangeLevelSubTips(self.countTips,1,self.totalDeadMonsterNum.."/"..self.totalMonsterNum)
				--BehaviorFunctions.ChangeSubTipsDesc(1,100000004,self.totalDeadMonsterNum.."/"..self.totalMonsterNum)
			end
		end
	end
--------------------------------------------
end

-----------------回调自封装------------------
--通知胜负结果
function LevelCommonFunction:ReturnLevelResult(LevelId,isSuccess)

end



	