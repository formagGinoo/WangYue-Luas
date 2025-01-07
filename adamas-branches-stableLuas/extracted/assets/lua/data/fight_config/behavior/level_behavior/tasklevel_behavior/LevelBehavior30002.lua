LevelBehavior30002 = BaseClass("LevelBehavior30002",LevelBehaviorBase)
--玉剑刻刻
function LevelBehavior30002:__init(fight)
	self.fight = fight
end


function LevelBehavior30002.GetGenerates()
	local generates = {900040,1002}
	return generates
end

function LevelBehavior30002.GetStorys()
	local storys = {24001,18001}
	return storys
end


function LevelBehavior30002:Init()
	self.missionState = 0
	--剧情相关
	self.storyList = {
		{id = 1,storyState = 0,storyDialogId = 24001},  --遇到刻刻timeline
		{id = 2,storyState = 0,storyDialogId = 18001},  --timeline后对话
	}
	self.StoryStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
end

function LevelBehavior30002:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.frame = BehaviorFunctions.GetFightFrame()
	if 	self.missionState == 0 then
		local pb1 = BehaviorFunctions.GetTerrainPositionP("P24001",10020001,"Logic10020001_5")
		local lp1 = BehaviorFunctions.GetTerrainPositionP("Face24001",10020001,"Logic10020001_5")
		self:PlayStory(1,{},0,0,pb1,lp1)
		BehaviorFunctions.DoMagic(1,self.role,900000010)
		local xumuPos = Vec3.New(237,58.5,402,6)
		BehaviorFunctions.DoSetPositionP(self.role,xumuPos)
		self.missionState = 1
	end
	
	if self.missionState == 5 then
		if BehaviorFunctions.HasBuffKind(self.role,900000010) then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
		end	
			local pos = BehaviorFunctions.GetTerrainPositionP("Monster101",self.levelId)
			self.monster = BehaviorFunctions.CreateEntity(900040,nil,pos.x,pos.y,pos.z)
			BehaviorFunctions.SendTaskProgress(200100107,1,1)
			--BehaviorFunctions.SendGmExec("task_finish", {"200100106"})
			self.missionState = 10
	end
	
	if self.missionState == 30 then
		BehaviorFunctions.RemoveLevel(30002)
		self.missionState = 999
	end
end
function LevelBehavior30002:RemoveEntity(instanceId)
	if instanceId == self.monster then
		self.missionState = 30
	end
end

function LevelBehavior30002:__delete()

end

function LevelBehavior30002:PlayStory(storyListId,bindList,timeIn,timeOut,position,lookatPosition)
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

function LevelBehavior30002:EnterArea(triggerInstanceId, areaName)

end

function LevelBehavior30002:ExitArea(triggerInstanceId, areaName)

end

function LevelBehavior30002:CheckAreaName(areaName,logicName,list)
	if list then
		for i = 1,#list do
			if list[i].areaName == areaName and list[i].logicName == logicName then
				return true
			end
		end
	end
end

function LevelBehavior30002:StoryStartEvent(dialogId)
	--if 	dialogId == 24001 then
		--BehaviorFunctions.DoMagic(1,self.role,900000010)
		--local xumuPos = Vec3.New(237,58.5,402,6)
		--BehaviorFunctions.DoSetPositionP(self.role,xumuPos)
	--end
end

function LevelBehavior30002:StoryEndEvent(dialogId)
	if dialogId == 24001 then
		BehaviorFunctions.StartStoryDialog(18001)
	end
	if dialogId == 18001 then
		self.missionState = 5
	end
end
