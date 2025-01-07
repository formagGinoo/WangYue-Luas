TaskBehavior900000001 = BaseClass("TaskBehavior900000001")
--新手流程致死区隐藏任务

function TaskBehavior900000001.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior900000001:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.CoreUIDisable = false
end

function TaskBehavior900000001:Update()
	--死亡区域判断
	self.role = BehaviorFunctions.GetCtrlEntity()
	local inArea = BehaviorFunctions.CheckEntityInArea(self.role,"DeadZone","Logic10020001_6")
	if inArea then
		local lifeRatio = BehaviorFunctions.GetEntityAttrValueRatio(self.role,1001)
		if lifeRatio > 0  then
			BehaviorFunctions.SetEntityAttr(self.role,1001,0)
		end
	end
	
	--第一场战斗前把能量条关掉
	local test = BehaviorFunctions.CheckTaskIsFinish(101030401)
	if test ~= true then
		local fightState = BehaviorFunctions.CheckPlayerInFight()
		if not fightState then
			--清空并停止能量条恢复
			BehaviorFunctions.AddEntitySign(self.role,10000030,-1)
			--清空玩家能量条
			BehaviorFunctions.SetEntityAttr(self.role,1201,0)
		end
	end
	
	--通关新手前之前把炎印关掉
	local test2 = BehaviorFunctions.CheckTaskIsFinish(104011201)
	if not  test2  then
		BehaviorFunctions.SetCoreUIEnable(self.role,false)
		--设置玩家能量条
		BehaviorFunctions.SetEntityAttr(self.role,1204,0)
	elseif test2 == true then
		BehaviorFunctions.SetCoreUIEnable(self.role,true)
	end
	--if test2 == nil and self.CoreUIDisable == false then
		--BehaviorFunctions.SetCoreUIEnable(self.role,false)
		--self.CoreUIDisable = true
	--elseif test2 == true and self.CoreUIDisable == true then
		--BehaviorFunctions.SetCoreUIEnable(self.role,true)
	--end
end

function TaskBehavior900000001:EnterArea(instanceId,Area)

end