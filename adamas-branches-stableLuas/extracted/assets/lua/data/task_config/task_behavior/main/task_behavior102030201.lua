TaskBehavior102030201 = BaseClass("TaskBehavior102030201")
--大世界任务组2：清除小拒点
--子任务2：到达拒点周围
--完成条件：前往据点

--到达据点门口，提前创建关卡，播timeline，播完黑幕+传送


function TaskBehavior102030201.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior102030201:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.taskState = 0
	self.dialogId = 102211001 --到达据点门口的timeline
	self.dialogId2 = 102211101 --据点第一波战斗开始时旁白
	self.levelState = 0
end

function TaskBehavior102030201:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	self.time = BehaviorFunctions.GetEntityFrame(self.role)/30
	if self.taskState == 2 then
		local lookpos = BehaviorFunctions.GetTerrainPositionP("Bomb2",10020001,"LogicWorldTest01")
		local pos = BehaviorFunctions.GetTerrainPositionP("SmallStart",10020001,"LogicWorldTest01")
		BehaviorFunctions.DoLookAtPositionImmediately(self.role,lookpos.x,pos.y,lookpos.z)
		BehaviorFunctions.StartStoryDialog(self.dialogId2)
		self.taskState = 3
		
	elseif self.taskState == 3 then
		BehaviorFunctions.SendTaskProgress(self.taskInfo.taskId,1,1)
	end
end

function TaskBehavior102030201:EnterArea(triggerInstanceId, areaName,logicName)
	if triggerInstanceId == self.role and areaName == "SmallArea" and logicName == "LogicWorldTest01" then
		if self.taskState == 0 then
			--重创关卡
			if self.levelState == 0 then
				if not BehaviorFunctions.CheckLevelIsCreate(102030202) then
					BehaviorFunctions.AddLevel(102030202)
				end
				self.levelState = 1
			end
			
			BehaviorFunctions.StartStoryDialog(self.dialogId)
			self.taskState = 1
		end
	end
end

function TaskBehavior102030201:StoryEndEvent(dialogId)
	if dialogId == self.dialogId then
		BehaviorFunctions.ShowBlackCurtain(true,0)
		BehaviorFunctions.CancelJoystick()
		local pos = BehaviorFunctions.GetTerrainPositionP("SmallStart",10020001,"LogicWorldTest01")
		--BehaviorFunctions.InMapTransport(pos.x,pos.y,pos.z)
		BehaviorFunctions.DoSetPositionP(self.role,pos)
		BehaviorFunctions.AddDelayCallByFrame(30,BehaviorFunctions,BehaviorFunctions.ShowBlackCurtain,false,1)
		BehaviorFunctions.AddDelayCallByFrame(30,self,self.Assignment,"taskState",2)
	end
end

--赋值
function TaskBehavior102030201:Assignment(variable,value)
	self[variable] = value
end