Behavior2040102 = BaseClass("Behavior2040102",EntityBehaviorBase)
--旧刻刻
function Behavior2040102.GetGenerates()

end

function Behavior2040102:Init()
	self.me = self.instanceId
	self.taskState = 0
	self.storyStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.timeLineState = nil
	self.objectIdentity = {
		{name = '？？？',ecoID = 40011,interactState = false, dialogID = 60001,state = false,uniqueID = nil},
						}
	self.condition = false
	self.interact = false
	self.interactEvent = nil
	self.uniqueID = nil
end


function Behavior2040102:Update()
	local ecoID = BehaviorFunctions.GetEntityEcoId(self.me)
	self.condition = BehaviorFunctions.GetEntityValue(self.me,"condition")
	if self.condition == true then
		self.interactEvent = BehaviorFunctions.GetEntityValue(self.me,"interactEvent")--如果需要传事件进来则
		BehaviorFunctions.SetEntityValue(self.me,"myUniqueID",self.uniqueID)
	end
end


function Behavior2040102:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	for index,value in ipairs(self.objectIdentity) do
		if uniqueId == self.objectIdentity[index].uniqueID then
			if self.condition ~= true then
				BehaviorFunctions.StartStoryDialog(self.objectIdentity[index].dialogID,{})
			end
			BehaviorFunctions.WorldInteractRemove(self.me,self.objectIdentity[index].uniqueID)
			self.objectIdentity[index].interactState = false
		end
	end
end


function Behavior2040102:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	local ecoID = BehaviorFunctions.GetEntityEcoId(triggerInstanceId)
	if triggerInstanceId == self.me then
		if ecoID ~= nil then
			for index,value in ipairs(self.objectIdentity) do
				if self.objectIdentity[index].ecoID == ecoID and self.objectIdentity[index].interactState == false then
					--self.objectIdentity[index].uniqueID = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Item,200001,self.objectIdentity[index].name, 1)
					self.objectIdentity[index].uniqueID = BehaviorFunctions.WorldNPCInteractActive(self.me,self.objectIdentity[index].name)
					BehaviorFunctions.SetEntityValue(self.me,"UniID",self.objectIdentity[index].uniqueID)
					self.uniqueID = self.objectIdentity[index].uniqueID
					self.objectIdentity[index].interactState = true
				end
			end
		elseif ecoID == nil then
			--for index,value in ipairs(self.objectIdentity) do
				--if  self.objectIdentity[index].interactState == false then
					----self.objectIdentity[index].uniqueID = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Item,200001,self.objectIdentity[index].name, 1)
					--self.objectIdentity[index].uniqueID = BehaviorFunctions.WorldNPCInteractActive(self.me,self.objectIdentity[index].name)
					--BehaviorFunctions.SetEntityValue(self.me,"UniID",self.objectIdentity[index].uniqueID)
					--self.objectIdentity[index].interactState = true
				--end
			--end
		end
	end
end

function Behavior2040102:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	local ecoID = BehaviorFunctions.GetEntityEcoId(triggerInstanceId)
	for index,value in ipairs(self.objectIdentity) do
		if self.objectIdentity[index].ecoID == ecoID and self.objectIdentity[index].interactState == true then
			BehaviorFunctions.WorldInteractRemove(self.me,self.objectIdentity[index].uniqueID)
			self.objectIdentity[index].interactState = false
		end
	end
end


--function Behavior2040102:EnterEntityCollider(instanceID)
	--local instanceID2 = instanceID
	--if instanceID == self.role then
		--if self.interact ~= true then
			--self.interact == true
			--self.objectIdentity[index].uniqueID = BehaviorFunctions.WorldNPCInteractActive(self.me,self.objectIdentity[index].name)
			--BehaviorFunctions.SetEntityValue(self.me,"UniID",self.objectIdentity[index].uniqueID)
			--self.objectIdentity[index].interactState = true
		--end
	--end
--end

function Behavior2040102:StoryStartEvent(dialogId)
	self.timeLineState = self.storyStateEnum.Playing
end

function Behavior2040102:StoryEndEvent(dialogId)
	self.timeLineState = self.storyStateEnum.PlayOver
end

function Behavior2040102:RemoveEntity(instanceId)

end