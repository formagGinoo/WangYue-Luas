Behavior92002091001 = BaseClass("Behavior92002091001",EntityBehaviorBase)

--预加载
function Behavior92002091001.GetGenerates()
	local generates = {}
	return generates
end

--mgaic预加载
function Behavior92002091001.GetMagics()
	local generates = {1001001}
	return generates
end

function Behavior92002091001:Init()
	self.me = self.instanceId
	self.time = 0
	self.timeStart = 0
	self.initialState = 0
end


function Behavior92002091001:Update()
	self.time = BehaviorFunctions.GetEntityFrame(self.me)
	if self.initialState == 0 then
		self.timeStart = self.time + 45
		self.initialState = 1
	end
	if self.initialState ==  1 and self.time == self.timeStart then
		--添加震屏特效，震屏的owner是实体92002091001
		BehaviorFunctions.DoMagic(self.me,self.me,1001001)
	end
end
