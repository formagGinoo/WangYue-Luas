Behavior2020101 = BaseClass("Behavior2020101",EntityBehaviorBase)
--大赐福
function Behavior2020101.GetGenerates()

end

function Behavior2020101:Init()
	self.me = self.instanceId
	self.taskState = 0
	self.localactive = false
	
	--指引相关
	self.guideDistance = 30 --指引距离
	self.canGuide = nil
	self.guideIcon = nil
	self.canGuideState = 0
end


function Behavior2020101:Update()
	self.role = BehaviorFunctions.GetCtrlEntity	()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
    if self.taskState == 0 and self.EcoId == 1103 and self.isActive == false then
		self.taskState = 1
	end
	if self.taskState == 1 and self.isActive == true then
		BehaviorFunctions.StartStoryDialog(16001)
		self.taskState = 999
	end
	if self.isActive == false  then
		if not self.LockEffect then
			self.LockEffect = BehaviorFunctions.CreateEntity(202010101,self.me)
		end	
		if self.canGuide == nil and BehaviorFunctions.CheckTaskId(200100106) and self.canGuideState == 0 then
			self.canGuide = true
			self.canGuideState = 1
		end
	end
	
	--guideIcon显示
	--if self.canGuide and BehaviorFunctions.CheckEntity(self.me) then
		--if  BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) <= self.guideDistance and self.guideIcon == nil then
			--self.guideIcon = BehaviorFunctions.AddEntityGuidePointer(self.me,FightEnum.GuideType.Transport,3.5)
		--elseif BehaviorFunctions.GetDistanceFromTarget(self.me,self.role) > self.guideDistance and self.guideIcon then
			--BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
			--self.guideIcon = nil
		--end
	--end
end


function Behavior2020101:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		if self.canGuide and self.guideIcon then
			self.canGuide = nil
			BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
			self.guideIcon = nil
		end
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)	
		BehaviorFunctions.InteractEntityHit(self.me,FightEnum.SysEntityOpType.Transport)
		BehaviorFunctions.ShowTip(3001011)
		if not self.UnlockEffect then
			self.UnlockEffect = BehaviorFunctions.CreateEntity(202010102,self.me)
			BehaviorFunctions.ShowWeakGuide(10009)
			if self.LockEffect then
				BehaviorFunctions.RemoveEntity(self.LockEffect)
			end
		end
		self.localactive = true
	end
end


function Behavior2020101:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if BehaviorFunctions.CheckTaskId(200100106) then
		if self.isActive == false and self.localactive == false then 
			if self.isTrigger then
				return
			end

			self.isTrigger = triggerInstanceId == self.me
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(WorldEnum.InteractType.Transport,nil,"大星碑", 1)
		end		
	end
end


function Behavior2020101:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me and self.localactive == false then
		self.isTrigger = false
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end