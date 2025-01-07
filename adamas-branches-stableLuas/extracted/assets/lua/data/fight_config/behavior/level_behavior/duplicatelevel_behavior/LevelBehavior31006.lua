LevelBehavior31006 = BaseClass("LevelBehavior31006",LevelBehaviorBase)
--屠龙
function LevelBehavior31006:__init(fight)
	self.fight = fight
end


function LevelBehavior31006.GetGenerates()
	local generates = {900040,900050,900030,80001001}
	return generates
end


function LevelBehavior31006:Init()
	self.role = 1
	self.missionState = 0
	self.deathState = 0
	self.bgmState = 0
	self.winState = 0
	self.count = 0
	self.StoryStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.timeLineState = 0
	self.storyList =
	{
		[1] = 41001,
	}
end

function LevelBehavior31006.GetStorys()
	local story = {41001}
	return story
end

function LevelBehavior31006:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if self.bgmState == 0 then
		self.bgmState = 1
	end
	--self:CheckTimelienState()
	self:DialogHideNPC(41001)
	if self.missionState == 0  then
		--local mb1 = BehaviorFunctions.GetTerrainPositionP("MB1",self.levelId,"Logic10020001_5")
		local mb1 = BehaviorFunctions.GetTerrainPositionP("Mb4",self.levelId)
		--self.monster = BehaviorFunctions.CreateEntity(900040,nil,mb1.x,mb1.y,mb1.z)
		self.monster = BehaviorFunctions.CreateEntity(900040,nil,mb1.x,mb1.y,mb1.z)
		--local mb2 =BehaviorFunctions.GetTerrainPositionP("MB2",self.levelId,"Logic10020001_5")
		local mb2 =BehaviorFunctions.GetTerrainPositionP("Mb5",self.levelId)
		self.monster2 = BehaviorFunctions.CreateEntity(900050,nil,mb2.x,mb2.y,mb2.z)
		--local mb3 =BehaviorFunctions.GetTerrainPositionP("MB3",self.levelId,"Logic10020001_5")
		local mb3 =BehaviorFunctions.GetTerrainPositionP("Mb6",self.levelId)
		self.monster3 = BehaviorFunctions.CreateEntity(900030,nil,mb3.x,mb3.y,mb3.z)

		--local npc1 =BehaviorFunctions.GetTerrainPositionP("Afei",self.levelId,"Logic10020001_5")
		local npc1 =BehaviorFunctions.GetTerrainPositionP("NPCPosition2",self.levelId)
		self.NPC1 = BehaviorFunctions.CreateEntity(80001002,nil,npc1.x,npc1.y,npc1.z)
		BehaviorFunctions.PlayAnimation(self.NPC1,"Afraid_loop")
		
		BehaviorFunctions.SetEntityValue(self.monster,"haveWarn",false)
		BehaviorFunctions.SetEntityValue(self.monster2,"haveWarn",false)
		BehaviorFunctions.SetEntityValue(self.monster3,"haveWarn",false)
		
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster,self.NPC1)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster2,self.NPC1)
		BehaviorFunctions.DoLookAtTargetImmediately(self.monster3,self.NPC1)
		
		self.missionState = 10
	end
	if self.missionState == 20 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			self:DialogHideNPC(41001)
			--self.timeLineState = self.StoryStateEnum.Playing
			self.missionState = 30
		end
	end
	if self.missionState == 30 then
		if self.timeLineState == self.StoryStateEnum.PlayOver then
			if self.NPC1 then
				BehaviorFunctions.RemoveEntity(self.NPC1)
			end
			--BehaviorFunctions.SendTaskProgress(200100209,1,1)
			BehaviorFunctions.SetDuplicateResult(true)
			BehaviorFunctions.RemoveLevel(31006)
			self.missionState = 999
		end
	end
	
	if self.deathState == 2 then
		if self.monster then
			BehaviorFunctions.RemoveEntity(self.monster)
		end
		if self.monster2 then
			BehaviorFunctions.RemoveEntity(self.monster2)
		end
		if self.monster3 then
			BehaviorFunctions.RemoveEntity(self.monster3)
		end
		if self.NPC1 then
			BehaviorFunctions.RemoveEntity(self.NPC1)
		end
		BehaviorFunctions.SetDuplicateResult(false)
		BehaviorFunctions.RemoveLevel(31006)
		self.deathState = 999
	end
end

--function LevelBehavior31006:CheckTimelienState()
	--if BehaviorFunctions.GetStoryPlayState() == true and self.timeLineState ~= self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.Playing

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.Playing then
		--self.timeLineState = self.StoryStateEnum.PlayOver

	--elseif BehaviorFunctions.GetStoryPlayState() == false and self.timeLineState == self.StoryStateEnum.PlayOver then
		--self.timeLineState = self.StoryStateEnum.NotPlaying
	--end
	--return self.timeLineState
--end

function LevelBehavior31006:DialogHideNPC(dialogID)
	local player = BehaviorFunctions.GetCtrlEntity()
	if self.timeLineState == self.StoryStateEnum.Playing and BehaviorFunctions.GetNowPlayingId() == dialogID then
		--隐藏对话NPC模型
		if BehaviorFunctions.CheckEntity(self.NPC1) ~= false and BehaviorFunctions.HasBuffKind(self.NPC1,900000010) == false then
			BehaviorFunctions.DoMagic(self.NPC1,self.NPC1,900000010)
		end
		--隐藏玩家模型
		if BehaviorFunctions.HasBuffKind(player,900000010) == false then
			BehaviorFunctions.DoMagic(player,player,900000010)
		end
	elseif self.timeLineState == self.StoryStateEnum.PlayOver then
		--显示对话NPC模型
		if BehaviorFunctions.CheckEntity(self.NPC1) ~= false and BehaviorFunctions.HasBuffKind(self.NPC1,900000010) == true then
			BehaviorFunctions.RemoveBuff(self.NPC1,900000010)
		end
		--显示对话玩家模型
		if BehaviorFunctions.HasBuffKind(player,900000010) == true then
			BehaviorFunctions.RemoveBuff(player,900000010)
		end
	end
end

--移除事件
function LevelBehavior31006:RemoveEntity(instanceId)
	if self.count == 3 and self.missionState == 10 then
		self.missionState = 20
		BehaviorFunctions.StartStoryDialog(41001)
	end
end

function LevelBehavior31006:Death(instanceId,isFormationRevive)
	if instanceId == self.monster or instanceId == self.monster2 or instanceId == self.monster3 then
		self.count = self.count + 1
	end
	if isFormationRevive then
		self.deathState = 2 
	elseif instanceId == self.monster then
		self.winState = 1
	end
end

function LevelBehavior31006:__delete()

end

function LevelBehavior31006:StoryStartEvent(dialogId)
	for i,v in ipairs(self.storyList) do
		if v == dialogId then
			self.timeLineState = self.StoryStateEnum.Playing
		end
	end
end

function LevelBehavior31006:StoryEndEvent(dialogId)
	for i,v in ipairs(self.storyList) do
		if v == dialogId then
			self.timeLineState = self.StoryStateEnum.PlayOver
		end
	end
end
