Behavior2020102 = BaseClass("Behavior2020102",EntityBehaviorBase)
--钟楼
function Behavior2020102.GetGenerates()

end

function Behavior2020102:Init()
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
	----任务保底
	self.canActive = true
end


function Behavior2020102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity	()
	self.EcoId = BehaviorFunctions.GetEntityEcoId(self.me)
	self.isActive = BehaviorFunctions.CheckEntityEcoState(self.me)
	if (not self.myPos or not self.lookPos) then
		self.myPos = BehaviorFunctions.GetPositionP(self.me)
		self.lookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,10,0)
	end

	--if self.isActive == false  then
		--if self.canGuide == nil and self.canGuideState == 0 then
			--self.canGuide = true
			--self.canGuideState = 1
		--end
	--end
	if self.isActive == false and not self.LockedEffect and self.myPos and self.lookPos then
		self.LockedEffect = BehaviorFunctions.CreateEntity(202010201,self.me,self.myPos.x,self.myPos.y,self.myPos.z,self.lookPos.x,self.lookPos.y,self.lookPos.z)
	elseif self.isActive == true and not self.UnlockedEffect and self.myPos and self.lookPos then
		if self.LockedEffect then
			BehaviorFunctions.RemoveEntity(self.LockedEffect)
			self.LockedEffect = nil
		end
		self.UnlockedEffect = BehaviorFunctions.CreateEntity(202010203,self.me,self.myPos.x,self.myPos.y,self.myPos.z,self.lookPos.x,self.lookPos.y,self.lookPos.z)
	end
	--任务没到激活小钟悬之前不允许交互
	--if self.EcoId == 1003001010001 then
		--if not self.canActive and BehaviorFunctions.CheckTaskId(101104201) or BehaviorFunctions.CheckTaskIsFinish(101104201) then
			--self.canActive = true
		--end
	--else
		--if not self.canActive and  BehaviorFunctions.CheckTaskId(101104301) or BehaviorFunctions.CheckTaskIsFinish(101104301) then
			--self.canActive = true
		--end
	--end
end


function Behavior2020102:WorldInteractClick(uniqueId, instanceId)
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
			BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			local rolePos = {x=0,y=0,z=0}
			local timelineLookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,5,0)
			local timelinePos = BehaviorFunctions.GetPositionP(self.me)
			rolePos.x,rolePos.y,rolePos.z = BehaviorFunctions.GetEntityTransformPos(self.me,"RolePos")
			BehaviorFunctions.StartStoryDialog(102010201,{},nil,nil,timelinePos,timelineLookPos)
			self.localactive = true
			self.playInstanceId = self.me
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
			self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,WorldEnum.InteractType.Transport,nil,"敲钟", 1)
		end
	end
end


function Behavior2020102:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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
function Behavior2020102:StoryStartEvent(dialogId)
	if self.playInstanceId and self.playInstanceId == self.me then
		if dialogId == 102010201 then
			BehaviorFunctions.AddBuff(1,self.role,900000010)
			BehaviorFunctions.SetEntityShowState(self.me,false)
			--BehaviorFunctions.AddBuff(1,self.me,900000010)
			local rolePos = {x=0,y=0,z=0}
			local timelineLookPos = BehaviorFunctions.GetPositionOffsetBySelf(self.me,5,0)
			local timelinePos = BehaviorFunctions.GetPositionP(self.me)
			rolePos.x,rolePos.y,rolePos.z = BehaviorFunctions.GetEntityTransformPos(self.me,"RolePos")
			BehaviorFunctions.DoSetPosition(self.role,rolePos.x,rolePos.y,rolePos.z)
			BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.me)
		end
	end
end


function Behavior2020102:StoryEndEvent(dialogId)
	if self.playInstanceId and self.playInstanceId == self.me then
		if dialogId == 102010201 then
			BehaviorFunctions.RemoveBuff(self.role,900000010)
			BehaviorFunctions.SetEntityShowState(self.me,true)
			BehaviorFunctions.InteractEntityHit(self.me)
			--BehaviorFunctions.RemoveBuff(self.me,900000010)
		end
	end
end