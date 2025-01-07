Behavior2040105 = BaseClass("Behavior2040105",EntityBehaviorBase)
--打不开的门（空实体）
function Behavior2040105.GetGenerates()

end

function Behavior2040105:Init()
	self.me = self.instanceId
	self.ecoMe = self.sInstanceId
	self.trueDoor = nil
	--假门状态
	self.stateEnum = {
		Default = 0,    --可交互
		Actived = 1		--移除交互
		}
	
	
	--默认状态
	self.state = self.stateEnum.Default


 
end

function Behavior2040105:LateInit()
	-- 获取状态
	self.state = BehaviorFunctions.GetEcoEntityState(self.ecoMe)
	
	
end

function Behavior2040105:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	--获取真门
	local state = BehaviorFunctions.GetEcoEntityState(2002001040002)
	
	--如果真门打开，移除交互
	if state == 1 then --0:没开  1：已开
		BehaviorFunctions.SetEntityWorldInteractState(self.me, false)
		--BehaviorFunctions.InteractEntityHit(self.me,false)
	end
	
end


--交互
function Behavior2040105:WorldInteractClick(uniqueId, instanceId)
	if instanceId ~= self.me then
		return
	end
	
	if instanceId ==self.me then
		--播开不了门的对话
		BehaviorFunctions.StartStoryDialog(202070201)
	end
end