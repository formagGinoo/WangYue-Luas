Behavior2040103 = BaseClass("Behavior2040103",EntityBehaviorBase)
--可破坏花
function Behavior2040103.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2040103:Init()
	self.me = self.instanceId
	self.eventState = false
	self.role = BehaviorFunctions.GetCtrlEntity()

	self.storyStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.timeLineState = self.storyStateEnum.Default
end 


function Behavior2040103:Update()

	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.eventState == false and self.timeLineState == self.storyStateEnum.NotPlaying then
		if BehaviorFunctions.CheckEntityInArea(self.role,"GoldenTreeArea","Logic10020001_5") then
			self.eventState = true
			--隐藏玩家模型
			if BehaviorFunctions.HasBuffKind(self.role,900000010) == false then
				BehaviorFunctions.DoMagic(self.role,self.role,900000010)
			end
			BehaviorFunctions.StartStoryDialog(58001)
		end
	end
	
	if self.eventState == true and self.timeLineState == self.storyStateEnum.PlayOver then
		if BehaviorFunctions.HasBuffKind(self.role,900000010) == true then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
		end
		BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Death)
		BehaviorFunctions.RemoveEntity(self.me)
	end
	
	if self.storyStateEnum ~= nil then
		if BehaviorFunctions.GetNowPlayingId() == nil and self.timeLineState ~= self.storyStateEnum.NotPlaying then
			self.timeLineState = self.storyStateEnum.NotPlaying
		end
	end
end

function Behavior2040103:StoryStartEvent(dialogId)
	self.timeLineState = self.storyStateEnum.Playing
end

function Behavior2040103:StoryEndEvent(dialogId)
	self.timeLineState = self.storyStateEnum.PlayOver
end

