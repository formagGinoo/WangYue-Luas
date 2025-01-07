Behavior300001415 = BaseClass("Behavior300001415",EntityBehaviorBase)
function Behavior300001415.GetGenerates()


end

function Behavior300001415.GetMagics()

end

function Behavior300001415:Init()
	self.ecoEntitys = nil
	self.magicState = 0
	self.me = self.instanceId
	self.starttime = BehaviorFunctions.GetEntityFrame(self.instanceId)/30--初始化时间
end

function Behavior300001415:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30--时间
end

function Behavior300001415:Collide(attackInstanceId,hitInstanceId)
    if attackInstanceId == self.me and hitInstanceId ~= self.me and self.time> self.starttime+ 10 then
		BehaviorFunctions.DoMagic(self.me,hitInstanceId,900000003)--测试buff
		self.starttime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录时间
	end
end