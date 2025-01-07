Behavior200000103 = BaseClass("Behavior200000103",EntityBehaviorBase)
function Behavior200000103.GetGenerates()


end

function Behavior200000103.GetMagics()

end

function Behavior200000103:Init()
	self.ecoEntitys = nil
	self.magicState = 0
end

function Behavior200000103:Update()
	if not self.ecoEntitys then
		self.ecoEntitys = BehaviorFunctions.GetTotalEntity()
	elseif self.ecoEntitys and self.magicState == 0 then
		for i,v in pairs(self.ecoEntitys) do
			if BehaviorFunctions.CheckEntity(v.instanceId) 
			--特殊tag
			and v.tagComponent and not (v.tagComponent.tag == 0 and v.tagComponent.npcTag == 0) 
			--奇怪非生态实体
			and BehaviorFunctions.GetEntityEcoId(v.instanceId) then
				BehaviorFunctions.SetEntityShowState(v.instanceId,false)
				BehaviorFunctions.SetEntityLifeBarVisibleType(v.instanceId,3)
				if v.buffComponent then
					BehaviorFunctions.AddBuff(1,v.instanceId,200000106)
				end
				if v.buffComponent and v.animatorComponent and v.timeComponent then
					BehaviorFunctions.DoMagic(1,v.instanceId,200000102)
				end
			end
		end
		self.magicState = 1
	end
end