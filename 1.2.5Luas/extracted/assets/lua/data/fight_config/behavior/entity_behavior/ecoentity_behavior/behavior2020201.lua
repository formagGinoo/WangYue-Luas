Behavior2020201 = BaseClass("Behavior2020201",EntityBehaviorBase)
--任务追踪光柱
local DataItem = Config.DataItem.data_item

--预加载
function Behavior2020201.GetGenerates()
	-- local generates = {}
	-- return generates
end

function Behavior2020201:Init()
	self.me = self.instanceId
	self.showDistance = 2
	self.switchTime = 2
	self.state = 0
	self.stateEnum = {
		Default = 0,
		Start = 1,
		Starting = 2,
		Overing = 3,
		}
end


function Behavior2020201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.roleDistance = BehaviorFunctions.GetDistanceFromTarget(self.me,self.role)
	self.time = BehaviorFunctions.GetFightFrame()/30
	--距离大于showDistance，显示
	if self.state == self.stateEnum.Default and self.roleDistance >= self.showDistance then
		self.state = self.stateEnum.Starting
		BehaviorFunctions.PlayAnimation(self.me,"FxGuideStart")
		self.timeStart = self.time
	end
	--持续状态
	if self.state == self.stateEnum.Starting and self.time - self.timeStart > self.switchTime then
		self.state = self.stateEnum.Start
	end
	--距离小于showDistance，隐藏
	if self.state == self.stateEnum.Start and self.roleDistance < self.showDistance then
		self.state = self.stateEnum.Overing
		BehaviorFunctions.PlayAnimation(self.me,"FxGuideOver")
		self.timeStart = self.time	
	end
	--动画结束，恢复默认
	if self.state == self.stateEnum.Overing and self.time - self.timeStart > self.switchTime then
		self.state = self.stateEnum.Default
	end
end

function Behavior2020201:__delete()

end