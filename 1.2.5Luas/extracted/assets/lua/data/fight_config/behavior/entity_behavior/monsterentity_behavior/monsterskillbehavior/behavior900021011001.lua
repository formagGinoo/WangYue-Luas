Behavior900021011001 = BaseClass("Behavior900021011001",EntityBehaviorBase)

--预加载
function Behavior900021011001.GetGenerates()
	local generates = {90002101103,900021011002}
	return generates
end

function Behavior900021011001:Init()
	self.me = self.instanceId
	self.time = 0
	self.timeStart = 0
	self.initialState = 0
	self.owner = 0
end


function Behavior900021011001:Update()

end


function Behavior900021011001:FirstCollide(attackInstanceId,hitInstanceId,InstanceIdId)
	--if hitInstanceId == BehaviorFunctions.GetCtrlEntity() then
		--local place = BehaviorFunctions.GetPositionP(self.me)
		----创建冰冻爆炸伤害
		--local IceExploDamage = BehaviorFunctions.CreateEntity(900021011002,attackInstanceId,place.x,place.y,place.z)
		--LogError("11")
	--end
end

function Behavior900021011001:RemoveEntity(InstanceIdId)
	if InstanceIdId == self.me then
		--LogError("2222")
		local place = BehaviorFunctions.GetPositionP(self.me)
		local owner = BehaviorFunctions.GetEntityOwner(InstanceIdId)
		--创建冰冻爆炸伤害
		local IceExploDamage = BehaviorFunctions.CreateEntity(900021011002,owner,place.x,place.y,place.z)
	end
end


