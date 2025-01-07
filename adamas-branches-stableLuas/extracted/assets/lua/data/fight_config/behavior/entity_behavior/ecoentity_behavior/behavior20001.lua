Behavior20001 = BaseClass("Behavior20001",EntityBehaviorBase)

--预加载
function Behavior20001.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior20001:Init()
	self.me = self.instanceId
	self.state = 0
	self.time = 0
	self.timestart = 0
	self.openTime = 0
	self.storyState = 0
end 


function Behavior20001:Update()
	self.time = BehaviorFunctions.GetFightFrame()/30
	if self.state == 1 and self.time - self.timestart > self.openTime then
		BehaviorFunctions.InteractEntityHit(self.me,false)
		if self.storyState == 0 and BehaviorFunctions.CheckTaskId(200100102) then
			BehaviorFunctions.StartStoryDialog(9001)
		end
		self.state = 999
	end
end

function Behavior20001:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		if self.state == 0 then
			--BehaviorFunctions.PlayAnimation(self.me,"open")
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			self.timestart =self.time
			self.state = 1		
		end
	end
end

function Behavior20001:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return
	end

	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end
	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Item, 200001, '宝箱', 1)--self.interactionUniqueId是按钮的id
end

function Behavior20001:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end
