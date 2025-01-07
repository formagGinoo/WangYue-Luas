Behavior200000104 = BaseClass("Behavior200000104",EntityBehaviorBase)
function Behavior200000104.GetGenerates()


end

function Behavior200000104.GetMagics()

end

function Behavior200000104:Init()
	self.ecoEntitys = nil
	self.magicState = 0
end

function Behavior200000104:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	if not self.ecoEntitys then
		self.ecoEntitys = BehaviorFunctions.GetTotalEntity()
	elseif self.ecoEntitys and self.magicState == 0 then
		for i,v in pairs(self.ecoEntitys) do
			if BehaviorFunctions.CheckEntity(v.instanceId) then
				BehaviorFunctions.SetEntityShowState(v.instanceId,true)
				BehaviorFunctions.SetEntityLifeBarVisibleType(v.instanceId,1)
				if v.buffComponent and BehaviorFunctions.HasBuffKind(v.instanceId,200000106) then
					BehaviorFunctions.RemoveBuff(v.instanceId,200000106)
				end
				if v.buffComponent and v.animatorComponent and v.timeComponent 
					and BehaviorFunctions.HasBuffKind(v.instanceId,200000102)then
					BehaviorFunctions.RemoveBuff(v.instanceId,200000102)
				end
			end
		end
		self.magicState = 1
	end
end