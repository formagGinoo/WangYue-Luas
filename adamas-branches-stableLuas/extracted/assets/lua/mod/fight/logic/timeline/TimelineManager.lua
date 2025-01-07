---@class TimelineManager
TimelineManager = BaseClass("TimelineManager")

function TimelineManager:__init(fight)
	self.fight = fight
	self.cameraTrackConfig = {}

	self.mainTarget = nil
end

function TimelineManager:PlayTrack(mainTarget,target, param)
	if not param.IngoreSyncTargetPos then
		local pos = mainTarget.transformComponent.position
		target.transformComponent:SetPosition(pos.x,pos.y,pos.z)
	end

	mainTarget.stateComponent:SetState(FightEnum.EntityState.Perform)
	target.stateComponent:SetState(FightEnum.EntityState.Perform)

	mainTarget.stateComponent:SetPerformMoveState(param.UnlockMainMove)
	target.stateComponent:SetPerformMoveState(param.UnlockTargetMove)

	if ctx then
		self.fight.clientFight.clientTimelineManager:PlayTrack(mainTarget, target, param.TimelinePath, param.TimeIn, param.TimeOut, param.UseTimeScale, param.IngoreRotate)
	end
end

function TimelineManager:StopTrack(mainTarget,target,path)
	mainTarget.stateComponent:SetState(FightEnum.EntityState.Idle)
	target.stateComponent:SetState(FightEnum.EntityState.Idle)
	if ctx then
		self.fight.clientFight.clientTimelineManager:StopTrack(mainTarget,target,path)
	end
end

function TimelineManager:PlayCameraTrack(mainTarget,target, param)
	self.fight.clientFight.cameraManager:Track(true)
	self.cameraTrackConfig[param.CameraTrackPath] = {duration = param.Duration or -1, param = param}
	
	self.fight.clientFight.clientTimelineManager:PlayCameraTrack(mainTarget, target, param.CameraTrackPath, param.TimeIn, 
		param.TimeOut, param.UseTimeScale, nil, param.CameraTrackInfo, param.IngoreRotate)
end

function TimelineManager:StopCameraTrack(path)
	if not path or not self.cameraTrackConfig[path] then
		return 
	end
	
	local param = self.cameraTrackConfig[path].param
	self.cameraTrackConfig[path] = nil
	
	self.fight.clientFight.cameraManager:Track(false)
	self.fight.clientFight.clientTimelineManager:StopCameraTrack(param.CameraTrackPath,param.AutoResetVAxis,
		param.VAxisOffset,param.AutoResetHAxis,param.HAxisOffset)
end

function TimelineManager:Update()
	for k, v in pairs(self.cameraTrackConfig) do
		v.duration = v.duration - 1
		if v.duration == 0 then
			self:StopCameraTrack(k)
		end
	end
end

function TimelineManager:__delete()

end
