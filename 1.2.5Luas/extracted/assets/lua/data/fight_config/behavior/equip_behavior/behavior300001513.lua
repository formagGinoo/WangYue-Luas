Behavior300001513 = BaseClass("Behavior300001513",EntityBehaviorBase)
function Behavior300001513.GetGenerates()


end

function Behavior300001513.GetMagics()
	local generates = {300001503}
	return generates
end

function Behavior300001513:Init()
	self.ecoEntitys = nil
	self.magicState = 0
	self.me = self.instanceId
	self.starttime = BehaviorFunctions.GetEntityFrame(self.instanceId)/30--初始化时间
end

function Behavior300001513:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)/30--时间
end

function Behavior300001513:Collide(attackInstanceId,hitInstanceId)
    if attackInstanceId == self.me and hitInstanceId ~= self.me and self.time> self.starttime+ 0.5 then
		BehaviorFunctions.DoMagic(self.me,self.me,300001503,1)--暴击率提升
		self.starttime = BehaviorFunctions.GetEntityFrame(self.me)/30--记录时间
	end
end