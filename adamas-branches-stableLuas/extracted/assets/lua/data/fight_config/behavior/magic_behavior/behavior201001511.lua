Behavior201001511 = BaseClass("Behavior201001511",EntityBehaviorBase)
function Behavior201001511.GetGenerates()


end

function Behavior201001511.GetMagics()

end

function Behavior201001511:Init()
	self.ecoEntitys = nil
	self.magicState = 0
	self.me = self.instanceId
	self.starttime = BehaviorFunctions.GetEntityFrame(self.instanceId)/30--初始化时间
end

function Behavior201001511:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30--时间
end

function Behavior201001511:Collide(attackInstanceId,hitInstanceId)
    if attackInstanceId == self.me and hitInstanceId ~= self.me and self.time> self.starttime+ 0.5 then
		BehaviorFunctions.DoMagic(self.me,self.me,201001501,1)--暴击率提升
		self.starttime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录时间
	end
end