TaskBehavior101230201 = BaseClass("TaskBehavior101230201")
--将茶馆商品设置为可拿取

function TaskBehavior101230201.GetGenerates()
	local generates = {}
	return generates

end

function TaskBehavior101230201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil	
	
	--茶馆生态商品ID
	self.ecoGoodsGroupId = 30030010101
	self.ecoGoodsList = 
	
	{
		[1] = {ecoId = 3003001010002 , instanceId = nil ,available = true},
		[2] = {ecoId = 3003001010003 , instanceId = nil ,available = true},
		[3] = {ecoId = 3003001010004 , instanceId = nil ,available = true},
		[4] = {ecoId = 3003001010005 , instanceId = nil ,available = true},
		[5] = {ecoId = 3003001010006 , instanceId = nil ,available = true},
	}
	self.init = false
end

function TaskBehavior101230201:LateInit()
	
end

function TaskBehavior101230201:Update()	
	if not self.init then
		for i,v in ipairs(self.ecoGoodsList) do
			local state = BehaviorFunctions.GetEcoEntityState(v.ecoId)
			if state == 0 then
				BehaviorFunctions.SetEcoEntityState(v.ecoId,1)
			end		
		end
		self.init = true
	end
end
