Behavior21002 = BaseClass("Behavior21002",EntityBehaviorBase)
--生态商品专用行为树

local DataItem = Config.DataItem.data_item

--预加载
function Behavior21002.GetGenerates()

end

function Behavior21002:Init()	
	self.me = self.instanceId

	self.ecoId = nil
	self.ecoState = nil

	self.myStateEnum =
	{
		inactive = 1,--不可拿取状态
		activated = 2,--可拿取状态
	}
	self.myState = self.myStateEnum.inactive
end

function Behavior21002:LateInit()
	if BehaviorFunctions.GetEntityEcoId(self.me) then
		self.ecoId = BehaviorFunctions.GetEntityEcoId(self.me)
		self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
	end
end

function Behavior21002:Update()
	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoId)
	--获得该生态的状态
	if self.ecoState == 0 then
		self.myState = self.myStateEnum.inactive
	elseif self.ecoState == 1 then
		self.myState = self.myStateEnum.activated
	end
end

function Behavior21002:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.InteractEntityHit(self.me, false)
	end	
end

function Behavior21002:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger then
		return	
	end

	self.isTrigger = triggerInstanceId == self.me
	if not self.isTrigger then
		return
	end

	--获取物品信息
	if not self.itemInfo then
		self.itemInfo = BehaviorFunctions.GetEntityItemInfo(self.me)
	end
	
	--进入范围时，将对应物品信息添加至交互列表中
	self.interactUniqueId = BehaviorFunctions.WorldItemInteractActive(self.me,self.itemInfo.id)
end

function Behavior21002:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		--离开范围时，移除交互列表中对应的交互信息
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

function Behavior21002:ExtraExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		--离开范围时，移除交互列表中对应的交互信息
		BehaviorFunctions.WorldInteractRemove(self.me,self.interactUniqueId)
	end
end

function Behavior21002:OnStealEntityGoods(goods_id,instanceId)
	if self.myState == self.myStateEnum.activated then
		BehaviorFunctions.InteractEntityHit(instanceId,false)
	end
end