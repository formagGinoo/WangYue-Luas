Behavior600060 = BaseClass("Behavior600060",EntityBehaviorBase)
--资源预加载
function Behavior600060.GetGenerates()
	local generates = {}
	return generates
end

function Behavior600060.GetMagics()
	local generates = {60006006}
	return generates
end



function Behavior600060:Init()
	self.me = self.instanceId	--记录自身

	self.PartnerAllParm = BehaviorFunctions.CreateBehavior("PartnerAllParm",self)
	self.PartnerCastSkill = BehaviorFunctions.CreateBehavior("PartnerCastSkill",self)
	

	
	
	self.PartnerAllParm.hasFightSkill = false	--是否会因为战斗影响技能切换
	self.PartnerAllParm.skillList = {
		--主动技能列表
		{
			id = 600060005,
			showType = 2,	--1变身型，2召唤型
			frame = 69,	--技能持续时间，时间结束自动进入退场流程
			skillType = 3, --1战前释放，2战中释放，3不需要战前战中切换
			distance =	0	--冲刺距离
		}
	}
	
	self.PartnerAllParm.createDistance = 2
	self.PartnerAllParm.createAngle = 270
end



function Behavior600060:Update()
	

	self.PartnerAllParm:Update()
	self.PartnerCastSkill:Update()
	

end	



function Behavior600060:FirstCollide(attackInstanceId,hitInstanceId,instanceId,attackType)
	if BehaviorFunctions.GetEntityTemplateId(instanceId) == 600060005001 and attackInstanceId == self.me then
		if BehaviorFunctions.CheckPlayerInFight() then
			BehaviorFunctions.DoMagic(self.me,hitInstanceId,600060002,1)
		else
			BehaviorFunctions.DoMagic(self.me,hitInstanceId,600060001,1)
		end
	end
end