PartnerAllBehavior = BaseClass("PartnerAllBehavior",EntityBehaviorBase)


--仲魔组合合集
function PartnerAllBehavior:Init()

	--仲魔技能释放集合
	 self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	 self.PartnerResidentLockTarget = BehaviorFunctions.CreateBehavior("PartnerResidentLockTarget",self)
	 self.PartnerResidentCastSkill = BehaviorFunctions.CreateBehavior("PartnerResidentCastSkill",self)

end

function PartnerAllBehavior:Update()
	
end