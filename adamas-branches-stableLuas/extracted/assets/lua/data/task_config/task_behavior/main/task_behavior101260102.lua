TaskBehavior101260102 = BaseClass("TaskBehavior101260102")
--镜头看向工人

function TaskBehavior101260102.GetGenerates()
	local generates = {}
	return generates
end

function TaskBehavior101260102:__init(taskInfo)
	self.taskInfo = taskInfo
	self.taskId = taskInfo.taskId
	self.taskStepId = taskInfo.stepId
	self.role = nil
	
	self.missionState = 0
end

function TaskBehavior101260102:LateInit()

end

function TaskBehavior101260102:Update()
	self.role = BehaviorFunctions.GetCtrlEntity()
	
	if self.missionState == 0 then
		local entity = BehaviorFunctions.GetNpcEntity(8101004)
		if entity then
			local pos = BehaviorFunctions.GetPositionP(entity.instanceId)
			if pos then
				self:LevelLookAtPos(pos,22008,30,"CameraTarget")
				self.missionState = 1
			end
		end
	end
end

function TaskBehavior101260102:LevelLookAtPos(pos,type,frame,bindTransform)
	self.empty = BehaviorFunctions.CreateEntity(2001,nil,pos.x,pos.y,pos.z,nil,nil,nil,self.levelId)
	self.levelCam = BehaviorFunctions.CreateEntity(type,nil,0,0,0,nil,nil,nil,self.levelId)
	--立刻朝向目标点
	BehaviorFunctions.DoLookAtTargetImmediately(self.role,self.empty)
	if bindTransform then
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role,bindTransform)
	else
		BehaviorFunctions.CameraEntityFollowTarget(self.levelCam,self.role)
	end
	BehaviorFunctions.CameraEntityLockTarget(self.levelCam,self.empty)
	if frame > 0 then
		--延迟移除目标和镜头
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.SetEntityShowState,self.levelCam, false)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.levelCam)
		BehaviorFunctions.AddDelayCallByFrame(frame,BehaviorFunctions,BehaviorFunctions.RemoveEntity,self.empty)
	end
end
