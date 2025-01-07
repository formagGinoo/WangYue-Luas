GOAPAgent = BaseClass("GOAPAgent")

function GOAPAgent:__init()
	self.actions = nil
	self.debugPlanInfo = ""
	self.actionTime = 5 -- 临时写个时间
	self.optimalPathNode = nil
end

function GOAPAgent:Init(planner,goapActions)
	self.planner = planner
	self.goapActions = goapActions
	EventMgr.Instance:AddListener(EventName.PathFindEnd, self:ToFunc("PathFindEnd"))
	BehaviorFunctions.fight.clientFight.headInfoManager:CreateHeadInfoObj(self.planner.entity.instanceId)
end

function GOAPAgent:Update()
	if self.action then
		self.goapActions:DoAction(self.action, self.planner)
	end
end

function GOAPAgent:PathFindEnd(instanceId, result)
	if self.actionPosition and instanceId then
		if not result then
			local pos = self.actionPosition
			LogError("GOAPAction无法抵达该地点，坐标"..pos.x.." "..pos.y.." "..pos.z)
		else
			local time = self.goapActions:StartDoAction(self.action,self.planner)
			LuaTimerManager.Instance:AddTimer(1, self.actionTime,function ()
					self.goapActions:FinishAction(self.action,self.planner)
					self:Next()
			end)
		end
	end
end

function GOAPAgent:Next()
	self.index = self.index + 1
	self.action = self.actions[self.index]
	if self.action then
		self.planner.curAction = self.action
		local pos = self.goapActions:GetActionPosition(self.action,self.planner)		
		if pos then
			BehaviorFunctions.PlayAnimation(self.planner.entity.instanceId, "Tuoshou_loop", FightEnum.AnimationLayer.PerformLayer)
			-- BehaviorFunctions.DoSetEntityState(self.planner.entity.instanceId, FightEnum.EntityState.Move)
			-- local result = BehaviorFunctions.SetPathFollowPos(self.planner.entity.instanceId,pos)
			-- if not result then
			-- 	LogError("GOAPAction无法抵达该地点，坐标"..pos.x.." "..pos.y.." "..pos.z)
			-- end
			self:StartDoAction(self.action, self.planner)
			self:FinishAction(self.action, self.planner)
			return
		else
			self:StartDoAction(self.action, self.planner)
			self:FinishAction(self.action, self.planner)
		end
	else
		self:FinishPlan()
	end
	-- self:DebugPlanToString(self.optimalPath)
end

function GOAPAgent:StartDoAction(action, planner)
	local action = action
	local planner = planner
	LuaTimerManager.Instance:AddTimer(1, self.actionTime,function ()
		self.goapActions:StartDoAction(self.action,self.planner)
		LogError("GOAP开始"..action.."了")
	end)
end

function GOAPAgent:FinishAction(action, planner)
	local action = action
	local planner = planner
	LuaTimerManager.Instance:AddTimer(1, self.actionTime + 5,function ()
		self.goapActions:FinishAction(action, planner)
		self:Next()
		LogError("GOAP干完"..action.."了，准备做下个工作了")
	end)

end

function GOAPAgent:FinishPlan()
	LogError("GOAP目标完成了手动触发下planner找新的目标")
	self.planner:PlanningGoal()
end

function GOAPAgent:SetActions(actions,optimalPath)
	self.actions = actions
	self.index = 1
	self.optimalPath = optimalPath
	self:Next()
	-- self:DebugPlanToString(self.optimalPath)
end

function GOAPAgent:DebugPlanToString(optimalPath)
	local info
	self.debugPlanInfo = info
end

function GOAPAgent:ShowInfo(info)
	--BehaviorFunctions.ChangeNpcBubbleContent(3,info,999999)
	--BehaviorFunctions.SetNonNpcBubbleVisible(3,true)
end

function GOAPAgent:__cache()
	EventMgr.Instance:RemoveListener(EventName.PathFindEnd, self:ToFunc("PathFindEnd"))
end

function GOAPAgent:__delete()

end
 