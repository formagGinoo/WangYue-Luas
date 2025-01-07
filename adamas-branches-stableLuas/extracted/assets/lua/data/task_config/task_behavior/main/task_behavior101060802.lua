TaskBehavior101060802 = BaseClass("TaskBehavior101060802")
--任务11：青乌击败精英从士继续向前，遇到了精英从士+从士*2的组合

function TaskBehavior101060802.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101060802:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
	self.currentDialog = nil	
	self.initSetting = false
	
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 101064201,state = self.dialogStateEnum.NotPlaying},--打完精英从士后继续前进
	}
	
	--玩家复活点
	self.currentCheckPoint = "checkPoint11"
	--玩家下个目标点
	self.nextTargetPos = "Task1010608Target02"
	
	self.gate1EcoId = 2001020001
	
	self.trace = false
end

function TaskBehavior101060802:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.trace == false then
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	--初始化设置
	if self.initSetting == false then
		--打开庭院的门
		local ins = BehaviorFunctions.GetEcoEntityByEcoId(self.gate1EcoId)
		if ins ~= nil then
			local result = BehaviorFunctions.CheckEntity(ins)
			if result == true then
				BehaviorFunctions.SetEntityValue(ins,"Remove",true)
			end
		end
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		self.initSetting = true
	end
	
	if self.missionState == 0 then
		----如果玩家已经在战斗区域内则让玩家出去
		--local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010608","Logic10020001_6")
		--if inArea then
			--local targetPos = BehaviorFunctions.GetTerrainPositionP(self.currentCheckPoint,10020001,"Logic10020001_6")
			----BehaviorFunctions.DoSetPosition(self.role,targetPos.x,targetPos.y,targetPos.z)
			--BehaviorFunctions.Transport(10020001,targetPos.x,targetPos.y,targetPos.z)
			--self:LevelLookAtPos()
		--end
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"BattleArea1010608","Logic10020001_6")
		if inArea then
			self.missionState = 2
		end
	end

	if self.missionState == 2 then
		--路上的口水话
		local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101062601","Logic10020001_6")
		if inArea then
			if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
				self.dialogList[1].state = self.dialogStateEnum.Playing
			end
		end
		
		local inArea2 = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010608Area02","Logic10020001_6")
		if inArea2 then
			--BehaviorFunctions.AddLevel(101060802)
			--BehaviorFunctions.SetGuideShowState(FightEnum.GuideType.Task,false)
			BehaviorFunctions.SendTaskProgress(101060802,1,1)
			self.missionState = 3
		end
	end
end

function TaskBehavior101060802:LevelLookAtPos()
	--看向下一个目标点镜头
	local fp1 = BehaviorFunctions.GetTerrainPositionP(self.nextTargetPos,10020001,"Logic10020001_6")
	self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
	self.levelCam2 = BehaviorFunctions.CreateEntity(22002)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty2)
	BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
	--延迟移除目标和镜头
	BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam2, false)
	BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
	BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
end

function TaskBehavior101060802:RemoveTask()
	
end

--死亡事件
function TaskBehavior101060802:Revive(instanceId, entityId)
	--玩家死亡重来
	if instanceId == self.role then
		if self.missionState == 3 then
			self.trace = false
			self.missionState = 0
		end
	end
end


function TaskBehavior101060802:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101060802:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end