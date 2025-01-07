Behavior2030902 = BaseClass("Behavior2030902",EntityBehaviorBase)
--通用开门（不记录后端）
function Behavior2030902.GetGenerates()
	 local generates = {}
	 return generates
end

function Behavior2030902:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.totalFrame = 0
	self.doorState = 0
	self.doorStateEnum =
	{
		Closed =0,
		Opened = 1,
		Closing = 2,
		Opening = 3,
	}
	self.canOpen = true
	self.doorOpen = false

	self.ChenckUpdateClosed = false
	self.ChenckUpdateOpended = false

	--延时调用
	self.delayCallList = {}
	--当前延时数量
	self.currentdelayCallNum = 0

end

function Behavior2030902:LateInit()
	-- 获取门对应的动画帧数时间
	self.openDurationTime = 1 --BehaviorFunctions.GetEntityAnimationFrame(self.me,"Opening")
	self.closeDurationTime = 1--BehaviorFunctions.GetEntityAnimationFrame(self.me,"Closeing")
	self.doorOpen = BehaviorFunctions.SetEntityValue(self.me,"doorOpen",false)
	BehaviorFunctions.SetEntityValue(self.me,"canOpenKey",false)
	BehaviorFunctions.SetEntityValue(self.me,"gamePlay",false)
end

function Behavior2030902:Update()

	if BehaviorFunctions.GetEntityValue(self.me,"gamePlay") == true then
		if BehaviorFunctions.GetEntityValue(self.me,"doorOpen") == false then
			if self.ChenckUpdateClosed == false then
				-- BehaviorFunctions.PlayAnimation(self.me, "Closed")
				BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
				self.ChenckUpdateClosed = true
			end
		else
			if self.ChenckUpdateOpended == false then
				-- BehaviorFunctions.PlayAnimation(self.me, "Opened")
				BehaviorFunctions.SetEntityWorldInteractState(self.me, true)
				self.ChenckUpdateOpended = true
			end
		end
	else
		BehaviorFunctions.PlayAnimation(self.me, "Opened")
		BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
	end

	if self.doorOpen == false then
		--开门
		if self.openingTime then
			self.totalFrame = self.totalFrame + 1
			if self.totalFrame >= self.openDurationTime*30 then
				self.totalFrame = 0
				self.doorState = self.doorStateEnum.Opened
				-- 赋值
				BehaviorFunctions.SetEntityValue(self.me,"isOpen",true)
				self.openingTime = nil
			end
			-- 关门
		elseif self.closingTime then
			self.totalFrame = self.totalFrame + 1
			if self.totalFrame >= self.closeDurationTime*30 then
				self.totalFrame = 0
				self.doorState = self.doorStateEnum.Closed
				self.closingTime = nil
			end
		end
	end

	if self.doorState == self.doorStateEnum.Opening then
		BehaviorFunctions.PlayAnimation(self.me, "Opened")
		self.doorState = self.doorStateEnum.Opened
	end
end

--点击按钮
function Behavior2030902:WorldInteractClick(uniqueId, instanceId)
	if instanceId == self.me then
		if self.interactUniqueId == uniqueId then
			local canOpenKey = BehaviorFunctions.GetEntityValue(self.me,"canOpenKey")
			if self.canOpen and canOpenKey == true then		-- self.doorOpen == false and 
				if self.doorState == self.doorStateEnum.Closed then
					self.isTrigger = false
					-- 移除标记
					BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
					-- 播开门动画
					BehaviorFunctions.PlayAnimation(self.me, "Opening")
					-- 获取开门的帧数
					self.openingTime = BehaviorFunctions.GetEntityFrame(self.me)
					-- 修改门的状态
					self.doorState = self.doorStateEnum.Opening
				end
			else
				BehaviorFunctions.StartStoryDialog(601019601)
			end
		end
	end
end

function Behavior2030902:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger or triggerInstanceId ~= self.me or (self.doorState ~= self.doorStateEnum.Closed) then		-- and self.doorState ~= self.doorStateEnum.Opened
		return
	end
	self.isTrigger = true
	local interactType = WorldEnum.InteractType.OpenDoor
	local interactDesc = self.doorState == self.doorStateEnum.Closed and "开门" or "关门"
	self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,interactType, nil, interactDesc, 1)
	-- BehaviorFunctions.SetEntityValue(self.me,"doorOpen",true)
end

function Behavior2030902:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if not self.isTrigger or triggerInstanceId ~= self.me then
		return
	end
	self.isTrigger = false
	BehaviorFunctions.WorldInteractRemove(self.me, self.interactUniqueId)
	self.interactUniqueId = nil
end

function Behavior2030902:RemoveEntity(instanceId)
	if instanceId == self.me then
		self:RemoveAllLevelDelayCall()
	end
end

--关卡延时调用帧数（卸载时自动移除剩余的DelayCall）
function Behavior2030902:AddLevelDelayCallByFrame(frame,obj,callback,...)
	local delayId = BehaviorFunctions.AddDelayCallByFrame(frame,obj,callback,...)
	self.currentdelayCallNum = self.currentdelayCallNum + 1
	table.insert(self.delayCallList,self.currentdelayCallNum,delayId)
	return delayId
end
--移除所有关卡延时调用
function Behavior2030902:RemoveAllLevelDelayCall()
	for i,delaycallId in ipairs(self.delayCallList) do
		BehaviorFunctions.RemoveDelayCall(delaycallId)
	end
end