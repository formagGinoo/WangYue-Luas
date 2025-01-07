Behavior2030411 = BaseClass("Behavior2030411",EntityBehaviorBase)
--生态玩法交互机关4
function Behavior2030411.GetGenerates()

end

function Behavior2030411:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId

	self.button = nil
	self.role = nil
	self.level = 405010204
	self.stateEnum = {
		Actived = 0,     --开着状态
		Closed = 1,    --关着状态
	}
	self.ecoState = nil
	self.totalFrame = 0
	self.isOpen = false
	self.ecoState = nil
end



function Behavior2030411:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.ecoState = BehaviorFunctions.GetEcoEntityState(self.ecoMe) --获取生态状态
	
	----设置状态：
	--if self.state == self.stateEnum.Actived and self.ecoState == 1 then

		--self.state = self.stateEnum.Closed
	--end
	if self.ecoState == 1 and self.isOpen == false then
		--移除交互
		BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		self.isOpen = true
	end
	
end

--点击交互
function Behavior2030411:WorldInteractClick(uniqueId,instanceId)

	if instanceId ~= self.me then
		return
	end

	if instanceId == self.me then
		--创建对应关卡
		BehaviorFunctions.AddLevel(405010204)

		----移除交互
		--BehaviorFunctions.SetEntityWorldInteractState(self.me, false)

	end
end

function Behavior2030411:FinishLevel(levelId)
	if levelId == self.level then
		BehaviorFunctions.SetEcoEntityState(self.ecoMe,1)
		self.state = self.stateEnum.Closed
	end
end
