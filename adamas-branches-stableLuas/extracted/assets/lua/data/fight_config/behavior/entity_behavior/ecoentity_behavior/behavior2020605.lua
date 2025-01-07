Behavior2020605 = BaseClass("Behavior2020605",EntityBehaviorBase)
--通用开门（不记录后端）
function Behavior2020605.GetGenerates()
	 local generates = {}
	 return generates
end

function Behavior2020605:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.totalFrame = 0
	self.doorState = 0
	self.doorStateEnum =
	{
		Closed =0,
		Closing = 1,
		Opening = 2,
		Opened = 3,
	}
	self.canOpen = true
	self.doorOpen = false
end

function Behavior2020605:LateInit()
	---- 获取门对应的动画帧数时间
	--self.openDurationTime = 1 --BehaviorFunctions.GetEntityAnimationFrame(self.me,"Opening")
	--self.closeDurationTime = 1--BehaviorFunctions.GetEntityAnimationFrame(self.me,"Closeing")
	--self.doorOpen = BehaviorFunctions.SetEntityValue(self.me,"doorOpen",false)
end



function Behavior2020605:Update()
	
	--if BehaviorFunctions.CheckEntityEcoState(nil,2002101040064) then
		--self.canOpen = true
	--else
		--self.canOpen = true
	--end
	
	--self.doorOpen = BehaviorFunctions.GetEntityValue(self.me,"doorOpen")
	----if self.doorOpen == false then
		----开门
		--if self.openingTime then
			--self.totalFrame = self.totalFrame + 1
			--if self.totalFrame >= self.openDurationTime*30 then
				--self.totalFrame = 0
				--self.doorState = self.doorStateEnum.Opened
				--赋值
				--BehaviorFunctions.SetEntityValue(self.me,"isOpen",true)
				--self.openingTime = nil
			--end
			--关门
		--elseif self.closingTime then
			--self.totalFrame = self.totalFrame + 1
			--if self.totalFrame >= self.closeDurationTime*30 then
				--self.totalFrame = 0
				--self.doorState = self.doorStateEnum.Closed
				----self.closingTime = nil
			----end
		--end
	--end
	
	----罗睺锁门
	--self.lock = BehaviorFunctions.GetEntityValue(self.me,"lock")
	--if self.lock and not self.num1 then
		---- 播关门动画
		--BehaviorFunctions.SetEntityWorldInteractState(self.me,false)
		--if self.doorState == self.doorStateEnum.Opened then
			--self.isTrigger = false
			---- 移除标记
			--BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			---- 播关门动画
			--BehaviorFunctions.PlayAnimation(self.me, "Closing")
			---- 获取开门的帧数
			--self.closingTime = BehaviorFunctions.GetEntityFrame(self.me)
			---- 修改门的状态
			--self.doorState = self.doorStateEnum.Closing
		--end
		--self.num1 = true
	--end
end
--点击按钮
function Behavior2020605:WorldInteractClick(uniqueId, instanceId)

	--if self.canOpen and self.doorOpen == false then
		--if self.doorState == self.doorStateEnum.Closed then
			--self.isTrigger = false
			---- 移除标记
			--BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			-- 播开门动画
			--BehaviorFunctions.PlayAnimation(self.me, "Opening")
			---- 获取开门的帧数
			--self.openingTime = BehaviorFunctions.GetEntityFrame(self.me)
			-- 修改门的状态
			--self.doorState = self.doorStateEnum.Opening
			--self.doorOpen = BehaviorFunctions.SetEntityValue(self.me,"doorOpen",true)
		--elseif self.doorState == self.doorStateEnum.Opened then
			--self.isTrigger = false
			---- 移除标记
			--BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
			---- 播关门动画
			--BehaviorFunctions.PlayAnimation(self.me, "Closing")
			---- 获取开门的帧数
			--self.closingTime = BehaviorFunctions.GetEntityFrame(self.me)
			---- 修改门的状态
			--self.doorState = self.doorStateEnum.Closing
		--end
	--else
		--BehaviorFunctions.StartStoryDialog(601019601)
	--end
end

--function Behavior2020605:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if self.isTrigger or triggerInstanceId ~= self.me 
		--or (self.doorState ~= self.doorStateEnum.Closed and self.doorState ~= self.doorStateEnum.Opened) then
		--return
	--end
	--self.isTrigger = true
	--local interactType = WorldEnum.InteractType.OpenDoor
	--local interactDesc = self.doorState == self.doorStateEnum.Closed and "开门" or "关门"
	--self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.me,interactType, nil, interactDesc, 1)
	
--end

--function Behavior2020605:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if not self.isTrigger or triggerInstanceId ~= self.me then
		--return
	--end	
	--self.isTrigger = false
	--BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	--self.interactUniqueId = nil
--end