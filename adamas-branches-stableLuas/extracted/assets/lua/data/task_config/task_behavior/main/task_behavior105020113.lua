TaskBehavior105020113 = BaseClass("TaskBehavior105020113")

function TaskBehavior105020113:__init()
    self.frame = 0
	self.elcbox = nil
	self.taskstate = 0
	
end

function TaskBehavior105020113:Update()
	self.elcbox = BehaviorFunctions.GetEcoEntityByEcoId(2001001020009)
	
	
	self:checkelcboxstate()
	
	
	
end


function TaskBehavior105020113:checkelcboxstate()
	local s = BehaviorFunctions.GetEcoEntityState(2001001020009)
	if s == 1 and self.taskstate == 0 then
		
		BehaviorFunctions.StartStoryDialog(601013401)
		BehaviorFunctions.SendTaskProgress(1050201, 9, 1)
		self.taskstate = 1
		
	end
end


