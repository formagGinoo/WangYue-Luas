Behavior2030410 = BaseClass("Behavior2030410",EntityBehaviorBase)
--生态玩法交互机关3
function Behavior2030410.GetGenerates()

end

function Behavior2030410:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId

	self.button = nil
	self.role = nil
	self.level = 405010203


	self.totalFrame = 0

end

function Behavior2030410:LateInit()

	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)

end

function Behavior2030410:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	local ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe) --获取生态状态
end

--点击交互
function Behavior2030410:WorldInteractClick(uniqueId,instanceId)

	if instanceId ~= self.me then
		return
	end

	if instanceId ==self.me then

		--创建对应关卡
		BehaviorFunctions.AddLevel(405010203)

		--移除交互
		BehaviorFunctions.SetEntityWorldInteractState(self.me, false)

	end
end

function Behavior2030410:FinishLevel(levelId)
	if levelId == self.level then
		BehaviorFunctions.SetEcoEntityState(self.me,1)
	end
end