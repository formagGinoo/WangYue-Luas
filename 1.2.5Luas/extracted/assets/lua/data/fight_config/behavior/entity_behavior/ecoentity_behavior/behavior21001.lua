Behavior21001 = BaseClass("Behavior21001",EntityBehaviorBase)

local DataItem = Config.DataItem.data_item

--预加载
function Behavior21001.GetGenerates()

end

function Behavior21001:Init()
	self.me = self.instanceId
end


function Behavior21001:Update()
	
end

function Behavior21001:WorldInteractClick(uniqueId)
	if self.interactUniqueId and self.interactUniqueId == uniqueId then
		BehaviorFunctions.InteractEntityHit(self.me, false)
	end	
end

function Behavior21001:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
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
		--self.itemId = self.itemInfo.item_template_id
		--self.itemConfig = DataItem[self.itemId]

	end
	
	--进入范围时，将对应物品信息添加至交互列表中
	self.interactUniqueId = BehaviorFunctions.WorldItemInteractActive(self.itemInfo.id)
end

function Behavior21001:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if self.isTrigger and triggerInstanceId == self.me then
		self.isTrigger = false
		--离开范围时，移除交互列表中对应的交互信息
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
	end
end

--function Behavior21001:EntityHitEnd()
	----以线性轨迹移动至玩家角色
	--Log("1111111111")
	----BehaviorFunctions.MoveTrackTarget(self.me)
--end

function Behavior21001:__delete()
	if self.isTrigger then
		BehaviorFunctions.WorldInteractRemove(self.interactUniqueId)
		self.isTrigger = false
	end
end

function Behavior21001:EntityHitEnd(instanceId)
	if instanceId == self.me then
		Log("111111111111")
	end
end