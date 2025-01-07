TaskBehavior10040003 = BaseClass("TaskBehavior10040003")
--新增timeline（台阶前边）独立播放+解谜图片引导
function TaskBehavior10040003:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskState = 0
	--剧情相关
	self.storyList = {
		{id = 1,storyState = 0,storyDialogId = 19001},
		{id = 2,storyState = 0,storyDialogId = 77001},
	}
	self.StoryStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.playingStoryId = 0
	self.camGuide = true
	self.camGuideState = 0
end

function TaskBehavior10040003:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local closeCallback = function()
		self:Dooo()
	end
	--timeline播完视频引导
	if self.taskState == 1 then
		BehaviorFunctions.ShowGuideImageTips(10017,closeCallback)
		self.taskState = 2
	end
	--完成任务
	if self.taskState == 3  then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
		----相机指引
		--if self.camGuide and self.camGuideState == 0 then
			--local camPos = BehaviorFunctions.GetTerrainPositionP("Gear2",10020001,"MVP_1")
			--local camTarget = BehaviorFunctions.CreateEntity(2001,nil,camPos.x,camPos.y,camPos.z)
			--local cam = BehaviorFunctions.CreateEntity(20051)
			--BehaviorFunctions.CameraEntityFollowTarget(cam,self.role)
			--BehaviorFunctions.CameraEntityLockTarget(cam,camTarget)
			--BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.RemoveEntity,cam)
			--self.camGuideState = 1
		--end
		self.taskState = 4 
	end
end

function TaskBehavior10040003:RemoveTask()
	
end

function TaskBehavior10040003:ExitArea(triggerInstanceId, areaName)
	
end

function TaskBehavior10040003:EnterArea(triggerInstanceId, areaName)
	if triggerInstanceId == self.role and self:CheckAreaName("ShootGuide","MVP_1", areaName) then
		self:PlayStory(2)
	end
end

function TaskBehavior10040003:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function TaskBehavior10040003:StoryStartEvent(dialogId)
	if self.storyList then
		for i = 1, #self.storyList do
			if self.storyList[i].storyDialogId == dialogId then
				self.storyList[i].storyState = self.StoryStateEnum.Playing
				break
			end
		end
	end
	if dialogId == 77001 then
		BehaviorFunctions.DoMagic(1,self.role,900000010)
	end
end

function TaskBehavior10040003:StoryEndEvent(dialogId)
	if self.storyList then
		for i = 1, #self.storyList do
			if self.storyList[i].storyDialogId == dialogId then
				self.storyList[i].storyState = self.StoryStateEnum.PlayOver
				self.playingStoryId = 0
				break
			end
		end
	end
	if dialogId == 77001 then
		if BehaviorFunctions.HasBuffKind(self.role,900000010) then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
		end
		self.taskState = 1
	end

end

function TaskBehavior10040003:PlayStory(storyListId,bindList,timeIn,timeOut,position,lookatPosition)
	if self.storyList then
		--遍历子任务列表，匹配传入Id
		for i = 1, #self.storyList do
			if storyListId == self.storyList[i].id then
				if self.storyList[i].storyState == self.StoryStateEnum.Default then
					--开始播剧情
					BehaviorFunctions.StartStoryDialog(self.storyList[i].storyDialogId,bindList,timeIn,timeOut,position,lookatPosition)
					--修改子任务列表中stortystate
					self.storyList[i].storyState = self.StoryStateEnum.Playing
					self.playingStoryId = self.storyList[i].id
					break
				end
			end
		end
	end
end

function TaskBehavior10040003:Dooo()
	self.taskState = 3
end