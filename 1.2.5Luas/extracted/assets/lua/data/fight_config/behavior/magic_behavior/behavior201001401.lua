Behavior201001401 = BaseClass("Behavior201001401",EntityBehaviorBase)
function Behavior201001401.GetGenerates()


end

function Behavior201001401.GetMagics()

end

function Behavior201001401:Init()
	self.ecoEntitys = nil
	self.magicState = 0
	self.me = self.instanceId
	self.starttime = BehaviorFunctions.GetEntityFrame(self.instanceId)/30--初始化时间
end

function Behavior201001401:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30--时间
end

function Behavior201001401:Collide(attackInstanceId,hitInstanceId)
    if attackInstanceId == self.me and hitInstanceId ~= self.me and self.time> self.starttime+ 10 then
		BehaviorFunctions.DoMagic(self.me,hitInstanceId,900000003,1)--眩晕
		self.starttime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录时间
	end
end