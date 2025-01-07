Behavior2020601 = BaseClass("Behavior2020601",EntityBehaviorBase)
--可开的门
function Behavior2020601.GetGenerates()
	 local generates = {}
	 return generates
end

function Behavior2020601:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId

	self.doorStateEnum =
	{
		Default =0,
		Closing = 1,
		Opening = 2,
		Opened = 3,		
	}
	
	self.keyStateEnum =
	{
		WithOutLock =0,
		Locked = 1,
	}

	self.totalFrame = 0
	self.doorState = self.doorStateEnum.Default
end

function Behavior2020601:LateInit()
	-- 获取门的状态
	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	-- 给门挂个图标
	local icon = self.ecoState == self.keyStateEnum.WithOutLock and "Textures/Icon/Single/Unlock/Unlock52.png" or "Textures/Icon/Single/Unlock/Unlock53.png"
	BehaviorFunctions.ShowBindChildObj(self.me, 1, true, {"UITarget", icon})
	-- 获取门对应的动画帧数时间
	self.openDurationTime = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Opening")
	self.closeDurationTime = BehaviorFunctions.GetEntityAnimationFrame(self.me,"Closeing")
end



function Behavior2020601:Update()
	local ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	if ecoState ~= self.ecoState and ecoState == self.keyStateEnum.WithOutLock then
		-- 如果开锁了 那就播一个开锁动画
		self.ecoState = ecoState
		BehaviorFunctions.PlayAnimation(self.me,"Opening")
		self.openingTime = BehaviorFunctions.GetEntityFrame(self.me)
		BehaviorFunctions.ShowBindChildObj(self.me, 1, false)
	end

	if self.openingTime then
		self.totalFrame = self.totalFrame + 1
		--开门动画播完 把门的状态改成已经开了
		if self.totalFrame >= 50 then
			self.totalFrame = 0
			self.doorState = self.doorStateEnum.Opened
			self.openingTime = nil
			BehaviorFunctions.ShowBindChildObj(self.me, 1, false)
		end
	end
end


--点击按钮
function Behavior2020601:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if not self.interactUniqueId or self.interactUniqueId ~= uniqueId then
		return
	end

	if self.ecoState == self.keyStateEnum.WithOutLock and self.doorState == self.doorStateEnum.Default then
		-- 移除标记
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
		-- 播开门动画
		BehaviorFunctions.PlayAnimation(self.me, "Opening")
		-- 获取开门的帧数
		self.openingTime = BehaviorFunctions.GetEntityFrame(self.me)
		-- 修改门的状态
		self.doorState = self.doorStateEnum.Opening
	elseif self.ecoState == self.keyStateEnum.Locked then
		-- 开锁
		BehaviorFunctions.keyOpenStartByEco(self.ecoMe)
	end
end

function Behavior2020601:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	-- 如果已经有触发标记 或者实体ID不对 就返回	
	if self.isTrigger or triggerInstanceId ~= self.me or self.doorState ~= self.doorStateEnum.Default then
		return
	end

	-- 修改触发标记
	self.isTrigger = true
	
	-- 后续要接入i18n的国际化
	local interactType = self.ecoState == self.keyStateEnum.WithOutLock and WorldEnum.InteractType.OpenDoor or WorldEnum.InteractType.Unlock
	local interactDesc = self.ecoState == self.keyStateEnum.WithOutLock and "开门" or "开锁"
	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,interactType, nil, interactDesc, 1)
end

function Behavior2020601:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if not self.isTrigger or triggerInstanceId ~= self.me then
		return
	end
	
	self.isTrigger = false
	BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	self.interactUniqueId = nil
end

--成功开锁
function Behavior2020601:OpenKeySuccess(instanceId)
	if instanceId ~= self.me then
		return
	end

	--设置门的状态
	BehaviorFunctions.SetEcoEntityState(self.ecoMe, 0)
	BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	self.interactUniqueId = nil
end