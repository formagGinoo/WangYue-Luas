TaskBehavior101060101 = BaseClass("TaskBehavior101060101")
--任务9：青乌发现了地上插着把剑

function TaskBehavior101060101.GetGenerates()
	local generates = {2020401}
	return generates
end

function TaskBehavior101060101:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
	self.currentDialog = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{		
		[1] = {Id = 101041201,state = self.dialogStateEnum.NotPlaying},--前往剑区域的口水话
		[2] = {Id = 101064001,state = self.dialogStateEnum.NotPlaying},--看见剑
	}
	self.trace = false
	self.sword = nil
	self.swordInteractionId = nil
	self.InteractionSwitch = false
end

function TaskBehavior101060101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.trace == false then
		--隐藏按钮
		self:HideButton()
		BehaviorFunctions.SetFightMainNodeVisible(2,"Map",false) --隐藏地图
		--更新任务追踪
		BehaviorFunctions.SetGuideTask(self.taskInfo.taskId)
		self.trace = true
	end
	
	if self.missionState == 0 then
		
		--创造剑
		local pos = BehaviorFunctions.GetTerrainPositionP("Sword1",10020001,"Logic10020001_6")
		local rotation = BehaviorFunctions.GetTerrainRotationP("Sword1",10020001,"Logic10020001_6")
		self.sword = BehaviorFunctions.CreateEntity(2020401,nil,pos.x,pos.y,pos.z)
		BehaviorFunctions.SetEntityEuler(self.sword,rotation.x,rotation.y,rotation.z)
		self.missionState = 1
	end
	
	if self.missionState == 1 then
		--路上的口水话
		if self.dialogList[1].state == self.dialogStateEnum.NotPlaying then
			local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"TL101040601","Logic10020001_6")
			if inArea then
				BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
				self.dialogList[1].state = self.dialogStateEnum.Playing
			end
		end
			
		--叙慕发现剑
		if self.dialogList[2].state == self.dialogStateEnum.NotPlaying then
			local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"Task1010601Area01","Logic10020001_6")
			if inArea then
				BehaviorFunctions.StartStoryDialog(self.dialogList[2].Id)
				self.dialogList[2].state = self.dialogStateEnum.Playing
				--看向剑的镜头
				local fp1 = BehaviorFunctions.GetTerrainPositionP("Sword1",10020001,"Logic10020001_6")
				self.empty2 = BehaviorFunctions.CreateEntity(2001,nil,fp1.x,fp1.y,fp1.z)
				self.levelCam2 = BehaviorFunctions.CreateEntity(22002)
				BehaviorFunctions.CameraEntityFollowTarget(self.levelCam2,self.role)
				BehaviorFunctions.CameraEntityLockTarget(self.levelCam2,self.empty2)
				--延迟移除目标和镜头
				BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam2)
				BehaviorFunctions.AddDelayCallByFrame(90,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty2)
			end
		end
		
		--剑的交互
		local distance = BehaviorFunctions.GetDistanceFromTarget(self.role,self.sword)
		if distance <= 10 then
			if self.levelCam2 then
				BehaviorFunctions.RemoveEntity(self.levelCam2)
			end
		end
	end
	
	if self.missionState == 2  then
		BehaviorFunctions.SendTaskProgress(101060101,1,1)
		self.missionState = 3
	end
end


function TaskBehavior101060101:WorldInteractClick(uniqueId)
	if uniqueId == self.swordInteractionId then
		BehaviorFunctions.WorldInteractRemove(self.sword,self.swordInteractionId)
		BehaviorFunctions.RemoveEntity(self.sword)
		self.missionState = 2
		self.InteractionSwitch = false
	end
end

function TaskBehavior101060101:HideButton()
	--BehaviorFunctions.SetFightMainNodeVisible(2,"I",false) --技能
	BehaviorFunctions.SetFightMainNodeVisible(2,"L",false) --大招
	BehaviorFunctions.SetFightMainNodeVisible(2,"Core",false) --被动条
end

function TaskBehavior101060101:RemoveTask()
	--恢复任务追踪
	BehaviorFunctions.SetTipsGuideState(true)
end

--死亡事件
function TaskBehavior101060101:Death(instanceId,isFormationRevive)

end

function TaskBehavior101060101:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.sword == triggerInstanceId and self.InteractionSwitch == false then
		self.swordInteractionId = BehaviorFunctions.WorldInteractActive(self.sword,WorldEnum.InteractType.Check,nil,"拿起剑",1)
		self.InteractionSwitch = true
	end
end

function TaskBehavior101060101:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.sword == triggerInstanceId and self.InteractionSwitch == true then
		BehaviorFunctions.WorldInteractRemove(self.sword,self.swordInteractionId)
		self.InteractionSwitch = false
	end
end

function TaskBehavior101060101:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior101060101:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.PlayOver
			self.currentDialog = nil
		end		
	end
end