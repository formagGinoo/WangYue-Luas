FSMBehavior900001 = BaseClass("FSMBehavior900001",FSMBehaviorBase)
--出生总状态


function FSMBehavior900001.GetGenerates()
	local generates = {}
	return generates
end

function FSMBehavior900001:Init()
	self.isBorned = false				--是否出生完成
	self.bornEffectId = 900000104		--通用小怪精英怪出生特效
end

function FSMBehavior900001:Update()

end

--受击进入warnning状态
function FSMBehavior900001:Collide(attackInstanceId,hitInstanceId,instanceId)
	if (attackInstanceId == self.MainBehavior.battleTarget or (BehaviorFunctions.GetEntityOwner(attackInstanceId) and BehaviorFunctions.GetEntityOwner(attackInstanceId) ==self.MainBehavior.battleTarget)
			or BehaviorFunctions.GetCampType(attackInstanceId) ~= 2)
		and hitInstanceId == self.MainBehavior.me
		and self.MainBehavior.haveWarn == true
		and not BehaviorFunctions.HasEntitySign(self.MainBehavior.battleTarget,610025) then
		self.ParentBehavior.hitWhenInitial = 1
		--and not BehaviorFunctions.HasBuffKind(self.MainBehavior.me,900000007) then
		--if not BehaviorFunctions.HasBuffKind(self.MainBehavior.me,900000001)
		--and self.beHit == false
		--and self.MainBehavior.warnSkillId then
		--BehaviorFunctions.AddBuff(1,self.MainBehavior.me,900000001)
		--self.beHit = true
		--end

	end

	--被暗杀直接进入战斗，跳过表演
	if hitInstanceId == self.MainBehavior.me and
		(BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001004001
			or BehaviorFunctions.GetEntityTemplateId(instanceId) == 62001009001
			or BehaviorFunctions.GetEntityTemplateId(instanceId) == 610025012001) then
		BehaviorFunctions.AddFightTarget(self.MainBehavior.me,self.MainBehavior.battleTarget)
		self.MainBehavior.inFight = true
	end
end