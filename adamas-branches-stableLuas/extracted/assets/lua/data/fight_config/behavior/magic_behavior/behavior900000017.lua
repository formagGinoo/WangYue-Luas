
Behavior900000017 = BaseClass("Behavior900000017",EntityBehaviorBase)
function Behavior900000017.GetGenerates()


end

function Behavior900000017.GetMagics()

end

function Behavior900000017:Init()
	self.me = self.instanceId		--记录自己
	self.hp = BehaviorFunctions.GetEntityAttrVal(self.me,1) --获取生命最大值
end

function Behavior900000017:BeforeDamage(attackInstanceId,hitInstanceId,damageType,magicId,damageElementType,damageVal)
	--if hitInstanceId == self.me and damageElementType == 2 then
		--BehaviorFunctions.ChangeEntityAttr(self.me,1001,-(self.hp*0.3))
	--end
	--临时救火，检测是不是序幕
	if hitInstanceId == self.me and BehaviorFunctions.GetEntityTemplateId(attackInstanceId) == 1003 then
		BehaviorFunctions.ChangeEntityAttr(self.me,1001,-(self.hp*0.3))
	end
end