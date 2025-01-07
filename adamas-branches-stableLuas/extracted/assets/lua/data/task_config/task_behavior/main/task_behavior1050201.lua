task_behavior1050201 = BaseClass("task_behavior1050201")
--新手流程按键和能力开放

function task_behavior1050201.GetGenerates()
	local generates = {}
	return generates
end

function task_behavior1050201:__init(taskInfo)
	self.taskstate = 0
	self.player = BehaviorFunctions.GetCtrlEntity()
end

function task_behavior1050201:Update()
	
	if self.taskstate == 0 then
		local  i = BehaviorFunctions.GetEcoEntityByEcoId(8010051)
		BehaviorFunctions.AddBuff(self.player,i,200001150)
		self.taskstate = 1
	end
	
	
end
