Behavior900020012001 = BaseClass("Behavior900020012001",EntityBehaviorBase)

--预加载
function Behavior900020012001.GetGenerates()
	local generates = {90002001203}
	return generates
end

function Behavior900020012001:Init()
	self.me = self.instanceId
	self.time = 0
	self.timeStart = 0
	self.initialState = 0
end


function Behavior900020012001:Update()

end


function Behavior900020012001:FirstCollide(attackInstanceId,hitInstanceId,InstanceIdId)
	if hitInstanceId == BehaviorFunctions.GetCtrlEntity() and BehaviorFunctions.GetDodgeLimitState(hitInstanceId) ~= Enable then
		self.initialState = 3
	end
end
