TaskBehavior2040010602 = BaseClass("TaskBehavior2040010602")
--修复信号发射器

function TaskBehavior2040010602.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior2040010602:__init(taskInfo)
	self.taskInfo = taskInfo
	self.role = nil
	self.missionState = 0
	self.currentDialog = nil
	self.dialogStateEnum = {
		Default = 0,
		NotPlaying = 1,
		Playing = 2,
		PlayOver = 3,
	}
	self.dialogList =
	{
		[1] = {Id = 202070401,state = self.dialogStateEnum.NotPlaying},
	}
	
	self.time = BehaviorFunctions.GetFightFrame()
	
	self.interactionSwitch = false
	self.interactIns = nil
	self.interactUniqueId = nil
end

function TaskBehavior2040010602:Update()
	self.time = BehaviorFunctions.GetFightFrame()
	self.role = BehaviorFunctions.GetCtrlEntity()

	--if self.missionState == 0 then
		--local targetPos = BehaviorFunctions.GetTerrainPositionP("FinalGoal",10020004,"WorldTgc00106")
		--self.interactIns = BehaviorFunctions.CreateEntity(200000101,nil,targetPos.x,targetPos.y,targetPos.z)
		--self.missionState = 1
		
	--elseif self.missionState == 1 then
		----local dis = BehaviorFunctions.GetDistanceFromTarget(self.role,self.interactIns)
		----if dis <= 1 and self.interactSwitch == false then
			----BehaviorFunctions.SetEntityWorldInteractState(self.interactIns,true)
			----self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.interactIns,WorldEnum.InteractType.Check,nil,"修复信号发射器",1)
			----self.interactSwitch = true
		----elseif dis > 1 and self.interactSwitch == true then
			
			----self.interactSwitch = false
		----end
	
	--elseif self.missionState == 2 then
		--BehaviorFunctions.WorldInteractRemove(self.interactIns,self.interactUniqueId)
		--BehaviorFunctions.StartStoryDialog(self.dialogList[1].Id)
		--self.missionState = 3
	
	--elseif self.missionState == 4 then
		--BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
		--local instanceId = BehaviorFunctions.GetEcoEntityByEcoId(2002001060006)
		--BehaviorFunctions.SetEntityValue(instanceId,"levelResult",true)
		--BehaviorFunctions.SendTaskProgress(302070103,1,1)
		--self.missionState = 5
	--end
end

--function TaskBehavior2040010602:WorldInteractClick(uniqueId,instanceId)
	--if uniqueId == self.interactUniqueId and instanceId == self.interactIns then
		--self.missionState = 2
	--end
--end

--function TaskBehavior2040010602:EnterTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if self.interactIns == triggerInstanceId and self.interactionSwitch == false then
		--self.interactUniqueId = BehaviorFunctions.WorldInteractActive(self.interactIns,WorldEnum.InteractType.Check,nil,"修复信号发射器",1)
		--self.interactionSwitch = true
	--end
--end

--function TaskBehavior2040010602:ExitTrigger(triggerInstanceId,triggerEntityId,roleInstanceId)
	--if self.interactIns == triggerInstanceId and self.interactionSwitch == true then
		--BehaviorFunctions.WorldInteractRemove(self.interactIns,self.interactUniqueId)
		--self.interactionSwitch = false
	--end
--end

--死亡事件
function TaskBehavior2040010602:Death(instanceId,isFormationRevive)

end

function TaskBehavior2040010602:RemoveTask()

end

function TaskBehavior2040010602:StoryStartEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		if dialogId == v.Id then
			v.state = self.dialogStateEnum.Playing
			self.currentDialog = v.Id
		end
	end
end

function TaskBehavior2040010602:StoryEndEvent(dialogId)
	for i,v in ipairs(self.dialogList) do
		--if dialogId == v.Id then
			--v.state = self.dialogStateEnum.PlayOver
			--self.currentDialog = nil
			--if self.dialogList[1].Id == dialogId then
				--self.missionState = 4
			--end
		--end
	end
	
	if dialogId == 202070701 then
		--BehaviorFunctions.ShowCommonTitle(8,"已清除城市威胁",true)
	end
end

--赋值
function TaskBehavior2040010602:Assignment(variable,value)
	self[variable] = value
end
