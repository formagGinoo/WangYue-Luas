Behavior2020112 = BaseClass("Behavior2020112",EntityBehaviorBase)
--城市地图传送点
function Behavior2020112.GetGenerates()

end

function Behavior2020112:Init()
	self.me = self.instanceId
	self.localactive = false
	self.myPos = nil
	self.lookPos = nil

	--指引相关
	self.guideDistance = 20 --指引距离
	self.canGuide = nil
	self.guideIcon = nil
	self.canGuideState = 0
	self.LockedEffect = nil
	self.UnlockedEffect = nil
	self.playInstanceId = nil
	
	self.effectStateInit = false
	self.effectIns = nil
	
	self.canActive = true
end

function Behavior2020112:LateInit()
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
	if self.isActive == false  then
		BehaviorFunctions.PlayAnimation(self.me,"LockIdle")
	elseif self.isActive == true then
		BehaviorFunctions.PlayAnimation(self.me,"UnlockIdle")
	end
	--self.myPos = BehaviorFunctions.GetPositionP(self.me)
	--self.lookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)
	
	--BehaviorFunctions.CreateEntity(202011201,self.me,self.myPos.x,self.myPos.y,self.myPos.z,self.lookPos.x,self.lookPos.y,self.lookPos.z)
end


function Behavior2020112:Update()
	self.role = BehaviorFunctions.GetCtrlEntity	()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
	self.myPos = BehaviorFunctions.GetPositionP(self.me)
	self.lookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)

	if self.isActive == false  then
		if not self.effectStateInit then
			self.effectIns = BehaviorFunctions.CreateEntity(202011201,self.me)
			local euler = BehaviorFunctions.GetEntityEuler(self.me)
			BehaviorFunctions.SetEntityEuler(self.effectIns,0,0,0)
			self.effectStateInit = true
		end
	elseif self.isActive == true then
		if not self.effectStateInit then
			self.effectIns = BehaviorFunctions.CreateEntity(202011201,self.me)
			local euler = BehaviorFunctions.GetEntityEuler(self.me)
			BehaviorFunctions.SetEntityEuler(self.effectIns,0,0,0)
			BehaviorFunctions.PlayAnimation(self.effectIns,"TransportMapLoop1")
			self.effectStateInit = true
		end
	end
end


function Behavior2020112:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.canActive then
		if self.interactUniqueId and self.interactUniqueId == uniqueId then
			if self.canGuide and self.guideIcon then
				self.canGuide = nil
				BehaviorFunctions.RemoveEntityGuidePointer(self.guideIcon)
				self.guideIcon = nil
			end
			BehaviorFunctions.InteractEntityHit(self.me)
			BehaviorFunctions.CreateEntity(202011202,self.me,self.myPos.x,self.myPos.y,self.myPos.z,self.lookPos.x,self.lookPos.y,self.lookPos.z)
			BehaviorFunctions.PlayAnimation(self.me,"Unlock")		
			BehaviorFunctions.PlayAnimation(self.effectIns,"TransportMapStart")	
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			BehaviorFunctions.DoEntityAudioPlay(self.role,"UIlevelupRole")
			self.localactive = true
			self.playInstanceId = self.me
		end
	end
end

function Behavior2020112:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.canActive then
		if self.isActive == false and self.localactive == false then
			if self.isTrigger then
				return
			end

			self.isTrigger = triggerInstanceId == self.me
			if not self.isTrigger then
				return
			end
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Transport,nil,"激活传送点", 1)
		end
	end
end


function Behavior2020112:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.playInstanceId and triggerInstanceId == self.me then
		self.playInstanceId = nil
	end
	if self.canActive then
		if self.isTrigger and triggerInstanceId == self.me and self.localactive == false then
			self.isTrigger = false
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		end
	end
end

function Behavior2020112:RemoveEntity(instanceId)
	if instanceId == self.me then
		if self.LockedEffect and BehaviorFunctions.CheckEntity(self.LockedEffect) then
			BehaviorFunctions.RemoveEntity(self.LockedEffect)
		end
		if self.UnlockedEffect and BehaviorFunctions.CheckEntity(self.UnlockedEffect) then
			BehaviorFunctions.RemoveEntity(self.UnlockedEffect)
		end
	end
end