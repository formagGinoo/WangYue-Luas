CommonDisplayInteractBehavior = BaseClass("CommonDisplayInteractBehavior", BehaviorBase)

local BF = BehaviorFunctions
local clamp = MathX.Clamp



function CommonDisplayInteractBehavior:Init()
end

---@param fight Fight
---@param entity Entity
function CommonDisplayInteractBehavior:InitConfig(fight, entity)
    self.fight = fight
    self.entity = entity

	self.isTrigger = nil
	self.me = self.entity.instanceId
    self.partnerDisplayManager = BehaviorFunctions.fight.entityManager.partnerDisplayManager

end


function CommonDisplayInteractBehavior:WorldInteractClick(uniqueId, instanceId)
    if instanceId == self.entity.instanceId then
        self.partnerDisplayManager:InteractClick(instanceId,uniqueId)
    end
end

function CommonDisplayInteractBehavior:OnUpdateDiaplayInteractItem(uniqueId)
	if not self.uniqueId then
		local decorationCtrl = self.partnerDisplayManager:GetDecorationByEntity(self.me)
		if decorationCtrl then
			self.uniqueId = decorationCtrl.uniqueId
		end
		local displayCtrl = self.partnerDisplayManager:GetDisplayByEntity(self.me)
		if displayCtrl then
			self.uniqueId = displayCtrl.uniqueId
		end
	end
	
	if self.uniqueId == uniqueId and self.isTrigger then
        self.partnerDisplayManager:SetInteractActive(self.me,true)
    end
end



function CommonDisplayInteractBehavior:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	if triggerInstanceId ~= self.me then
		return 
	end
	if self.isTrigger then
		return	
	end
	
	--进入范围时，显示交互列表
	self.isTrigger = self.partnerDisplayManager:SetInteractActive(self.me,true)

    
end

function CommonDisplayInteractBehavior:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	
	if triggerInstanceId ~= self.me then
		return
	end
	
	if not self.isTrigger then
		return
	end
	
	self.isTrigger = false
	--离开范围时，移除交互列表中对应的交互信息
	self.partnerDisplayManager:SetInteractActive(self.me,false)
end


function CommonDisplayInteractBehavior:OnCache()
    
end
