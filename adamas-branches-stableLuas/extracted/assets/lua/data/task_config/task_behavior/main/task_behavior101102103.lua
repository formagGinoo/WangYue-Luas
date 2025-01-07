TaskBehavior101102103 = BaseClass("TaskBehavior101102103")
--攀爬教学

function TaskBehavior101102103.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101102103:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0	
	
	self.weakGuide =
	{
		[1] = {Id = 2014,state = false,Describe ="长按在墙面上奔跑"},
	}
	
	self.init = false
end

function TaskBehavior101102103:Update()	
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.init == false then
		--开启攀爬
		BehaviorFunctions.SetClimbEnable(true)
		self.init = true
	end
	
	--如果玩家处于攀爬状态，则引导跑墙
	if BehaviorFunctions.GetEntityState(self.role) == FightEnum.EntityState.Climb 
	and self.weakGuide[1].state == false then
		self:WeakGuide(self.weakGuide[1].Id)
	end
end

--开启弱引导，并且关闭其他弱引导
function TaskBehavior101102103:WeakGuide(guideId)
	for i,v in ipairs(self.weakGuide) do
		if v.Id == guideId then
			BehaviorFunctions.PlayGuide(guideId,1,1)
			v.state = true
		elseif v.Id ~= guideId then
			BehaviorFunctions.FinishGuide(v.Id,1)
		end
	end
end

--关闭所有弱引导
function TaskBehavior101102103:RemoveWeakGuide()
	for i,v in ipairs(self.weakGuide) do
		BehaviorFunctions.FinishGuide(v.Id,1)
	end
end