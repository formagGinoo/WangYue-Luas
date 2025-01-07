Behavior20006 = BaseClass("Behavior20006",EntityBehaviorBase)
--赐福
function Behavior20006.GetGenerates()

end

function Behavior20006:Init()
	self.me = self.instanceId
	self.taskState = 0
	self.animationFrame = 63
	self.playFrame = 0
	self.playState = 0
end


function Behavior20006:Update()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
	self.myFrame = BehaviorFunctions.GetEntityFrame(self.me)
	if self.taskState == 0 and self.EcoId == 21 and self.isActive == false then
		self.taskState = 1
	end
	if self.taskState == 1 and self.isActive == true then
		BehaviorFunctions.SendGmExec("task_finish", {"200100102"})
		BehaviorFunctions.ShowTip(3001004)
		self.taskState = 999
	end
	if self.isActive == true and self.playState == 1 and self.myFrame - self.playFrame >= self.animationFrame then
		BehaviorFunctions.PlayAnimation(self.me,"Stand")
		self.playState = 999
	elseif self.isActive == true and self.playState == 0 then
		BehaviorFunctions.PlayAnimation(self.me,"Stand")
		self.playState = 999
	end
end


function Behavior20006:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)	
		BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Transport)
		BehaviorFunctions.PlayAnimation(self.me,"open")
		self.playFrame = self.myFrame
		self.playState = 1
		self.isTrigger = false
	end
end


function Behavior20006:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isActive == false then
		if self.isTrigger then
			return
		end

		self.isTrigger = triggerInstanceId == self.me
		if not self.isTrigger then
			return
		end
		self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Item,200001,"激活", 1)
	end
end


function Behavior20006:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end