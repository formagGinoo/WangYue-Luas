Behavior300001414 = BaseClass("Behavior300001414",EntityBehaviorBase)
function Behavior300001414.GetGenerates()


end

function Behavior300001414.GetMagics()

end

function Behavior300001414:Init()
	self.ecoEntitys = nil
	self.magicState = 0
	self.me = self.instanceId
	self.starttime = BehaviorFunctions.GetEntityFrame(self.instanceId)/30--初始化时间
end

function Behavior300001414:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30--时间
end

function Behavior300001414:Collide(attackInstanceId,hitInstanceId)
    if attackInstanceId == self.me and hitInstanceId ~= self.me and self.time> self.starttime+ 12.5 then
		BehaviorFunctions.DoMagic(self.me,hitInstanceId,900000003)--测试buff
		self.starttime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录时间
	end
end