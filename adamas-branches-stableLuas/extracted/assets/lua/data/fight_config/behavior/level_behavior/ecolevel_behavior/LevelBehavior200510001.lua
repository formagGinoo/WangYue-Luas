LevelBehavior200510001 = BaseClass("LevelBehavior200510001",LevelBehaviorBase)
--大悬钟，搬运电梯玩法
function LevelBehavior200510001.GetGenerates()
	local generates = {2080110,2990101}
	return generates
end


function LevelBehavior200510001:Init()
	self.missionState = 0
	self.tipState = 0
	self.time = nil
	self.frame = nil
	self.role = nil
	self.targetId = 0
	
	self.isIn = 1
	
	self.towerId = 0
	self.towerEcoId = 1003001020001
	self.fakeElevatorId = 0
	self.elevatorId = 0
	self.elevatorEcoId = 2003001020003
	self.npc = 0
	self.npcId = 5003001020001
	self.dialogId1 = 602200101  --对话id
	self.dialogId2 = 602200201  --把电梯搬到正确位置上了
end

function LevelBehavior200510001:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	self.frame = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	if self.missionState == 0 then
		self.fakeElevatorId = BehaviorFunctions.CreateEntityByPosition(2080110,nil,"Elevator",nil,200510001,self.levelId)
		self.targetId = BehaviorFunctions.CreateEntityByPosition(2001,nil,"ElevatorTarget",nil,200510001,self.levelId)
		self.npc = BehaviorFunctions.CreateEntityByPosition(2990101,nil,"NPC",nil,200510001,self.levelId)
		self.towerId = BehaviorFunctions.GetEcoEntityByEcoId(self.towerEcoId)
		BehaviorFunctions.SetEntityWorldInteractState(self.towerId,false)
		BehaviorFunctions.PlayAnimation(self.npc,"Fue_loop")
		--气泡对话
		BehaviorFunctions.ShowCharacterHeadTips(self.npc,true)
		BehaviorFunctions.ChangeNpcBubbleContent(self.npc,"怎么办呢……",999)
		BehaviorFunctions.SetNonNpcBubbleVisible(self.npc,true)
		self.missionState = 1
	
	elseif self.missionState == 1 then
		--local pos1 = BehaviorFunctions.GetPositionP(self.elevatorId)
		--local pos2 = BehaviorFunctions.GetTerrainPositionP("ElevatorTarget",self.levelId)
		--local distance = BehaviorFunctions.GetDistanceFromPos(pos1,pos2)
		local Euler = BehaviorFunctions.GetEntityEuler(self.fakeElevatorId)
		local distance2 = BehaviorFunctions.GetDistanceFromTargetWithY(self.fakeElevatorId,self.targetId)
		
		--local con1 = Euler.x <= 5 or Euler.x >= 355
		--local con2 = Euler.z <= 5 or Euler.z >= 355
		--local con3 = BehaviorFunctions.CheckEntityInArea(self.fakeElevatorId,"ElevatorArea","BigBellTower_Level200510001")
		
		if distance2 >= 50 then
			BehaviorFunctions.RemoveEntity(self.fakeElevatorId)
			self.fakeElevatorId = BehaviorFunctions.CreateEntityByPosition(2080110,nil,"Elevator",nil,200510001,self.levelId)
		end
		
		if distance2 <= 2  
			and (Euler.x <= 5 or Euler.x >= 355)
			and (Euler.z <= 5 or Euler.z >= 355)
			then
			BehaviorFunctions.StartNPCDialog(self.dialogId2,self.npc)
			self.missionState = 2
		end
		
	elseif self.missionState == 3 then
		BehaviorFunctions.RemoveEntity(self.fakeElevatorId)
		self.missionState = 4
		
	elseif self.missionState == 4 then
		self.elevatorId = BehaviorFunctions.GetEcoEntityByEcoId(self.elevatorEcoId)
		if self.elevatorId then
			BehaviorFunctions.SetEntityValue(self.elevatorId,"specialState",1)
			local pos = BehaviorFunctions.GetTerrainPositionP("ElevatorTarget",self.levelId)
			BehaviorFunctions.DoSetPositionP(self.elevatorId,pos)
			
			--BehaviorFunctions.DoSetPositionOffset(self.elevatorId,0,-48,0)
			BehaviorFunctions.AddDelayCallByTime(3,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,fasle,2)
			BehaviorFunctions.AddDelayCallByTime(5,BehaviorFunctions,BehaviorFunctions.FinishLevel,self.levelId)
			BehaviorFunctions.SetEntityWorldInteractState(self.towerId,true)
			self.missionState = 5
		end
	end
	
	
	if self.tipState == 0 then
		local dis = BehaviorFunctions.GetDistanceFromTarget(self.role,self.targetId)
		if dis <= 25 then
			self.guideTips = BehaviorFunctions.AddLevelTips(200510001,self.levelId)
			BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.ChallengeInfo,"重启大悬钟",nil)
			self.tipState = 1
		end
	end
end

function LevelBehavior200510001:Death(instanceId, isFormationRevive)

end

--function LevelBehavior200510001:EnterArea(triggerInstanceId, areaName)
	--if triggerInstanceId == self.elevatorId and areaName == "ElevatorArea" then
		--self.isIn = 1
	--end
--end

function LevelBehavior200510001:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.npc then
		BehaviorFunctions.StartNPCDialog(self.dialogId1,self.npc)
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.role)
	end
end

function LevelBehavior200510001:RemoveLevel(levelId)
	if levelId == self.levelId then
		if self.guideTips then
			BehaviorFunctions.RemoveLevelTips(self.guideTips)
		end
	end
end

function LevelBehavior200510001:FinishLevel()
	--BehaviorFunctions.ShowCommonTitle(WorldTitlePanel.TitleType.challengeEnd,"重启大悬钟",true)
	BehaviorFunctions.ChangeEcoEntityCreateState(self.npcId,false)
end

--赋值
function LevelBehavior200510001:Assignment(variable,value)
	self[variable] = value
end

function LevelBehavior200510001:StoryEndEvent(dialogId)
	if dialogId == self.dialogId1 then
		BehaviorFunctions.DoLookAtTargetImmediately(self.npc,self.fakeElevatorId)
		BehaviorFunctions.PlayAnimation(self.npc,"Fue_loop")
	end
	
	if dialogId == self.dialogId2 then
		BehaviorFunctions.ShowBlackCurtain(true,2)
		BehaviorFunctions.AddDelayCallByTime(2,self,self.Assignment,"missionState",3)
		BehaviorFunctions.ChangeEcoEntityCreateState(self.elevatorEcoId,true)
	end
end