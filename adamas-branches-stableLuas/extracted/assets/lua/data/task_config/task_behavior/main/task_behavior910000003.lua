TaskBehavior910000003 = BaseClass("TaskBehavior910000003")
--茶馆生态控制

function TaskBehavior910000003.GetGenerates()
	local generates = {}
	return generates

end

function TaskBehavior910000003:__init(taskInfo)
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
	
	--检查玩家是否完成救茶馆任务
	self.task1Finish = false
	
	--检查玩家是否完成出茶馆任务
	self.task2Finish = false
	
	--玩家在该店拿走了多少商品
	self.totalNotavailable = 0
	--玩家在该店拿走了多少商品才播放对话
	self.limitGoods = 3
	--触发允许拿的上限时的对话ID
	self.dialogId1 = 101101201
	--不允许随意拿取时的对话ID
	self.dialogId2 = 101104701
end

function TaskBehavior910000003:LateInit()
	--self.totalNotavailable = BehaviorFunctions.GetTaskProgress(910000003,2)
end

function TaskBehavior910000003:Update()	
	
	for i,v in ipairs(self.ecoGoodsList) do
		local result = BehaviorFunctions.CheckEntityEcoState(nil,v.ecoId)
		if v.available == true and result == false then 
			v.available = false
			self.totalNotavailable = self.totalNotavailable + 1
		end
	end
	
	if BehaviorFunctions.CheckTaskIsFinish(101101101) then
		self.task1Finish = true
	end
	
	if BehaviorFunctions.CheckTaskIsFinish(101101301) then
		self.task2Finish = true
	end
	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
end

function TaskBehavior910000003:OnStealEntityGoods(goods_id,instanceId)
	for i,v in ipairs(self.ecoGoodsList) do
		v.instanceId = BehaviorFunctions.GetEcoEntityByEcoId(v.ecoId)
		if v.instanceId == instanceId then
			if self.task1Finish == true and self.task2Finish == false then
				BehaviorFunctions.InteractEntityHit(instanceId,false)
				--BehaviorFunctions.SendTaskProgress(910000003,2,1)
				self.totalNotavailable = self.totalNotavailable + 1
				if self.totalNotavailable == self.limitGoods then
					BehaviorFunctions.StartStoryDialog(self.dialogId1)
				end
			else
				BehaviorFunctions.StartStoryDialog(self.dialogId2)
			end
		end
	end
end