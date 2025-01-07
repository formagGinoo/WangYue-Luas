Behavior300001511 = BaseClass("Behavior300001511",EntityBehaviorBase)
function Behavior300001511.GetGenerates()


end

function Behavior300001511.GetMagics()
	local generates = {300001501}
	return generates
end

function Behavior300001511:Init()
	self.ecoEntitys = nil
	self.magicState = 0
	self.me = self.instanceId
	self.starttime = BehaviorFunctions.GetEntityFrame(self.instanceId)/30--初始化时间
end

function Behavior300001511:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30--时间
end

function Behavior300001511:Collide(attackInstanceId,hitInstanceId)
    if attackInstanceId == self.me and hitInstanceId ~= self.me and self.time> self.starttime+ 0.5 then
		BehaviorFunctions.DoMagic(self.me,self.me,300001501,1)--暴击率提升
		self.starttime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录时间
	end
end