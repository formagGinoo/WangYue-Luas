Behavior2010601 = BaseClass("Behavior2010601",EntityBehaviorBase)

local DataItem = Config.DataItem.data_item

--预加载
function Behavior2010601.GetGenerates()

end

function Behavior2010601:Init()
	self.me = self.instanceId
end


function Behavior2010601:Update()
	
end

function Behavior2010601:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	
	if instanceId == self.me then
		BehaviorFunctions.InteractEntityHit(self.me, false)
	end
	--if self.interactUniqueId and self.interactUniqueId == uniqueId then
		--BehaviorFunctions.InteractEntityHit(self.me, false)
	--end	
end