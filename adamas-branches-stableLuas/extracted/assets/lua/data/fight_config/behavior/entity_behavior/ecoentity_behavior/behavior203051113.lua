Behavior203051113 = BaseClass("Behavior203051113",EntityBehaviorBase)

function Behavior203051113.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior203051113:Init()
	self.me = self.instanceId

end

function Behavior203051113:LateInit()
	self.pos = BehaviorFunctions.GetPositionP(self.me)
end


function Behavior203051113:Update()


end

function Behavior203051113:Die(attackInstanceId,dieInstanceId)
	if dieInstanceId == self.me then
		BehaviorFunctions.CreateEntity(20305080002,self.me,self.pos.x,self.pos.y,self.pos.z,nil,nil,nil,nil,nil)
	end
end