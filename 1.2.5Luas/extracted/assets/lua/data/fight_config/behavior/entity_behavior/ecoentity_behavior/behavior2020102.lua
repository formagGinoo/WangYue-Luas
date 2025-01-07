Behavior2020102 = BaseClass("Behavior2020102",EntityBehaviorBase)
--钟楼
function Behavior2020102.GetGenerates()

end

function Behavior2020102:Init()
	self.me = self.instanceId
	self.localactive = false

	--指引相关
	self.guideDistance = 20 --指引距离
	self.canGuide = nil
	self.guideIcon = nil
	self.canGuideState = 0
	self.LockedEffect = nil
	self.UnlockedEffect = nil
	
	--任务保底
	self.canActive = nil
end


function Behavior2020102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity	()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
	if self.isActive == false  then
		if self.canGuide == nil and self.canGuideState == 0 then
			self.canGuide = true
			self.canGuideState = 1
		end
	end
	if self.isActive == false and not self.LockedEffect then
		self.LockedEffect = BehaviorFunctions.CreateEntity(202010201,self.me)
	elseif self.isActive == true and not self.UnlockedEffect then
		if self.LockedEffect then
			BehaviorFunctions.RemoveEntity(self.LockedEffect)
			self.LockedEffect = nil
		end
		self.UnlockedEffect = BehaviorFunctions.CreateEntity(202010203,self.me)
	end
	--任务没到激活大钟悬之前不允许交互
	if self.EcoId == 1002020012 then
		if not self.canActive and BehaviorFunctions.CheckTaskId(102140101) or BehaviorFunctions.CheckTaskIsFinish(102140101) then
			self.canActive = true
		end
	else
		if not self.canActive and  BehaviorFunctions.CheckTaskId(102010501) or BehaviorFunctions.CheckTaskIsFinish(102010501) then
			self.canActive = true
		end
	end
end


function Behavior2020102:WorldInteractClick(uniqueId)
	if self.canActive then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			if self.canGuide and self.guideIcon then
				self.canGuide = nil
				BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
				self.guideIcon = nil
			end
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
			BehaviorFunctions.InteractEntityHit(self.me)
			if not BehaviorFunctions.CheckTaskId(102010501) then
				BehaviorFunctions.ShowTip(3001011)
			end
			self.localactive = true
		end
	end
end

function Behavior2020102:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canActive then
		if self.isActive == false and self.localactive == false then
			if self.isTrigger then
				return
			end

			self.isTrigger = triggerInstanceId == self.me
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Transport,nil,"敲钟", 1)
		end
	end
end


function Behavior2020102:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canActive then
		if self.isTrigger and triggerInstanceId == self.me and self.localactive == false then
			self.isTrigger = false
			BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		end
	end
end

function Behavior2020102:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.LockedEffect and BehaviorFunctions.CheckEntity(self.LockedEffect) then
			BehaviorFunctions.RemoveEntity(self.LockedEffect)
		end
		if self.UnlockedEffect and BehaviorFunctions.CheckEntity(self.UnlockedEffect) then
			BehaviorFunctions.RemoveEntity(self.UnlockedEffect)
		end
	end
end