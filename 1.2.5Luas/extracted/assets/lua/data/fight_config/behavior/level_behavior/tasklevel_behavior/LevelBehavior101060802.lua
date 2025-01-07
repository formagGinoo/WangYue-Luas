LevelBehavior101060802 = BaseClass("LevelBehavior101060802",LevelBehaviorBase)
--击败一只精英从士+两只从士
function LevelBehavior101060802:__init(fight)
	self.fight = fight
end

function LevelBehavior101060802.GetGenerates()
	local generates = {900040,910040,2030202}
	return generates
end

function LevelBehavior101060802.GetStorys()
	local storys = {}
	return storys
end


function LevelBehavior101060802:Init()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.missionState = 0
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.monsterStateEnum = {
		Default = 0,
		Live = 1,
		Dead = 2,
	}
	self.dialogList = {
		
	}

	self.monsterList =
	{
		[1] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010608Mb4",entityId = 900040},
		[2] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010608Mb5",entityId = 900040},
		[3] = {Id = nil , state = self.monsterStateEnum.Default ,bp = "Task1010608Mb6",entityId = 910040},
	}
	self.waveList = 
	{
		[1] = {1,2,3}
	}
	
	self.blockInf =
	{
		[1] = {Id = nil ,bp = "Task1010608Wall2",entityId = 2030202},
	}

	self.monsterDead = 0
	self.time = 0
	self.timeStart = 0
end

function LevelBehavior101060802:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		self:CreateWall(self.blockInf)
		--召唤战斗区域的3只小怪
		for i,v in ipairs (self.waveList[1]) do
			local pos = BehaviorFunctions.GetTerrainPositionP(self.monsterList[v].bp,10020001,"Logic10020001_6")
			self.monsterList[v].Id = BehaviorFunctions.CreateEntity(self.monsterList[v].entityId,nil,pos.x,pos.y,pos.z)
			self.monsterList[v].state = self.monsterStateEnum.Live
			BehaviorFunctions.DoLookAtTargetImmediately(self.monsterList[v].Id,self.role)
			--关闭怪物警戒
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"haveWarn",false)
			--设置脱战范围
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"ExitFightRange",100)
			--设置目标追踪范围
			BehaviorFunctions.SetEntityValue(self.monsterList[v].Id,"targetMaxRange",100)
		end
		--替换关卡进度
		BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
		BehaviorFunctions.ShowTip(101060802,0)
		--看向怪物镜头
		self.levelCam = BehaviorFunctions.CreateEntity(22001)
		BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.monsterList[3].Id)
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,"CameraTarget")
		BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.monsterList[3].Id)
		self.missionState = 1
	end

	--检查怪物死没死
	if self.missionState == 1 then
		if BehaviorFunctions.CheckEntity(self.levelCam) then
			BehaviorFunctions.RemoveEntity(self.levelCam)
		end
		local listLenth = #self.waveList[1]
		local count = 0
		for i,v in ipairs (self.waveList[1]) do
			--如果击杀了怪物
			if self.monsterList[v].state == self.monsterStateEnum.Dead then
				count = count + 1
				if count == listLenth then
					BehaviorFunctions.HideTip()
					self.missionState = 2
				end
			end
		end
	end

	--如果击杀了所有怪物
	if self.missionState == 2 then
		--移除花墙
		self:RemoveWall(self.blockInf)
		--任务成功移除关卡
		BehaviorFunctions.RemoveLevel(101060802)
		BehaviorFunctions.SendTaskProgress(101060802,1,1)
		self.missionState = 3
	end
end

--创建墙体
function LevelBehavior101060802:CreateWall(list)
	for i,v in ipairs (list) do
		local pos = BehaviorFunctions.GetTerrainPositionP(v.bp,10020001,"Logic10020001_6")
		local rotate = BehaviorFunctions.GetTerrainRotationP(v.bp,10020001,"Logic10020001_6")
		v.Id = BehaviorFunctions.CreateEntity(v.entityId,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.DoMagic(v.Id,v.Id,900000007)
		BehaviorFunctions.SetEntityEuler(v.Id,rotate.x,rotate.y,rotate.z)
	end
end

--移除墙体
function LevelBehavior101060802:RemoveWall(list)
	for i,v in ipairs (list) do
		if v.Id ~= nil then
			local result = BehaviorFunctions.CheckEntity(v.Id)
			if result == true then
				BehaviorFunctions.SetEntityAttr(v.Id,1001,0)
			end
		end
	end
end

function LevelBehavior101060802:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.ShowWeakGuide(guideId)
			v.state = true
		end
	end
end

function LevelBehavior101060802:RemoveEntity(instanceId)

end

function LevelBehavior101060802:__delete()

end

--死亡事件
function LevelBehavior101060802:Death(instanceId,isFormationRevive)
	if isFormationRevive then
		for i,v in ipairs(self.monsterList) do
			if BehaviorFunctions.CheckEntity(v.Id) then
				BehaviorFunctions.RemoveEntity(v.Id)
			end
		end
		self:RemoveWall(self.blockInf)
		--任务失败移除关卡
		BehaviorFunctions.RemoveLevel(101060802)
		BehaviorFunctions.HideTip()
	else
		for i,v in ipairs(self.monsterList) do
			if instanceId == v.Id then
				v.state = self.monsterStateEnum.Dead
				self.monsterDead = self.monsterDead + 1
				BehaviorFunctions.ChangeTitleTipsDesc(101060802,self.monsterDead)
			end
		end
	end
end

function LevelBehavior101060802:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end
	end
end

function LevelBehavior101060802:StoryStartEvent(dialogId)

end