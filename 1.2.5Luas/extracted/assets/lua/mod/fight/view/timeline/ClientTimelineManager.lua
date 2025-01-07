ClientTimelineManager = BaseClass("ClientTimelineManager")
local moveX = 2
local moveY = 4
local rotateY = 8
function ClientTimelineManager:__init(clientFight)
	self.clientFight = clientFight
	self.timelineRoot = GameObject("TimelineRoot")
	self.timelineRoot:SetActive(true)
	self.timelineRoot.transform:SetParent(self.clientFight.fightRoot.transform)
	self.timelines = {}
	self.cameraTracks = {}
	self.moveOffset = Vec3.zero
	self.lastMoveOffset = Vec3.zero
	self.cameraManager = self.clientFight.cameraManager
end


function ClientTimelineManager:LoadDialogTrack(track, dialogUI, useTimeScale, setting)
	track.transform:SetParent(self.timelineRoot.transform)
	self.playableDialogDirector = track.gameObject:GetComponent(CS.UnityEngine.Playables.PlayableDirector)
	if setting.bindingList then
		for i = 1, #setting.bindingList do
			local target = BehaviorFunctions.fight.entityManager:GetEntity(setting.bindingList[i])
			if target then
				local targetTransform = target.clientEntity.clientTransformComponent.transform
				if i == 1 then
					track.transform.position = targetTransform.position
					track.transform.rotation = targetTransform.rotation
				end
				CustomUnityUtils.SetPlaytrackBinding(track.transform, i, targetTransform)
			end
		end
	end
	if setting.position or setting.lookPosition then
		track.transform.position = setting.position or Vec3.zero
		local lookDir = setting.lookPosition - track.transform.position
		lookDir.y = 0
		track.transform.rotation = Quaternion.LookRotation(lookDir);
	end

	CustomUnityUtils.SetPlaytrackBinding(track.transform, "ContentTrack", dialogUI)
	CustomUnityUtils.PlayTimeLime(track.transform)
	--if IS_DEBUG then
        --self.debug = debug.traceback()
    --end

	self.time = 0
	self.dialogPlaying = true
	self.useTimeScale = useTimeScale
	return self.playableDialogDirector
end

function ClientTimelineManager:JumpToTime(time)
	self.time = time
	CustomUnityUtils.SetPlayableDirectorTime(self.playableDialogDirector,time)
end

function ClientTimelineManager:ContinueDialogTrack()
	self.playableDialogDirector:Play()
	self.dialogPlaying = false
end

function ClientTimelineManager:PauseDialogTrack()
	self.playableDialogDirector:Pause()
	self.dialogPlaying = false
end
function ClientTimelineManager:StopDialogTrack()
	self.dialogPlaying = false
end

function ClientTimelineManager:PlayTrack(mainTarget,target,path,timeIn,timeOut,useTimeScale)
	if self.clientFight.cameraManager.cinemachineBrain.IsBlending then
		self.clientFight.cameraManager.cinemachineBrain.ActiveBlend = nil
	end
	CustomUnityUtils.AddCameraTrackBlend(self.clientFight.cameraManager.cinemachineBrain,"TrackCamera",timeIn,timeOut)
	mainTarget.clientEntity.clientTransformComponent:Async()
	local track
	if self.timelines[path] then
		track = self.timelines[path]
		track.transform.position = mainTarget.clientEntity.clientTransformComponent.model.position
		track.transform.rotation = mainTarget.clientEntity.clientTransformComponent.model.rotation
		track:SetActive(true)
	else
		track = self.clientFight.assetsPool:Get(path)
		track:SetActive(false)
		self.timelines[path] = track
		track.transform:SetParent(self.timelineRoot.transform)
		self:SetCameraNoise(track)
	end
	self.mainTarget = mainTarget
	track.transform.position = mainTarget.clientEntity.clientTransformComponent.model.position
	track.transform.rotation = mainTarget.clientEntity.clientTransformComponent.model.rotation
	track:SetActive(true)
	self.time = 0
	self.playableDirector = track.gameObject:GetComponent(CS.UnityEngine.Playables.PlayableDirector)
	CustomUnityUtils.SetPlaytrackBinding(track.transform,"MainTarget",mainTarget.clientEntity.clientTransformComponent.model)
	if mainTarget ~= target then
		CustomUnityUtils.SetPlaytrackBinding(track.transform,"Target",target.clientEntity.clientTransformComponent.model)
	end
	CustomUnityUtils.PlayTimeLime(track.transform)
	self.playing = true
	self.useTimeScale = useTimeScale

    --if IS_DEBUG then
        --self.debug = debug.traceback()
    --end
end

function ClientTimelineManager:StopTrack(mainTarget,target,path)
	self.timelines[path]:SetActive(false)
	self.playing = false
end

function ClientTimelineManager:PlayCameraTrack(mainTarget,target,path,timeIn,timeOut,useTimeScale,followPosition)
	CustomUnityUtils.AddCameraTrackBlend(self.clientFight.cameraManager.cinemachineBrain,"TrackCamera",timeIn,timeOut)
	mainTarget.clientEntity.clientTransformComponent:Async()
	if self.clientFight.cameraManager.cinemachineBrain.IsBlending then
		self.clientFight.cameraManager.cinemachineBrain.ActiveBlend = nil
	end
	self.moveTotalOffset = Vector3.zero
	UnityUtils.BeginSample("PlayCameraTrack Part")
	local track
	if self.cameraTracks[path] then
		track = self.cameraTracks[path]
		track.transform.position = mainTarget.clientEntity.clientTransformComponent.transform.position
		track.transform.rotation = mainTarget.clientEntity.clientTransformComponent.transform.rotation
		track:SetActive(true)
	else
		track = self.clientFight.assetsPool:Get(path)
		self.cameraTracks[path] = track
		track:SetActive(false)
		track.transform:SetParent(self.timelineRoot.transform)
		self:SetCameraNoise(track)
	end
	self.mainTarget = mainTarget
	UnityUtils.EndSample()
	track.transform.position = mainTarget.clientEntity.clientTransformComponent.transform.position
	track.transform.rotation = mainTarget.clientEntity.clientTransformComponent.transform.rotation
	track:SetActive(true)
	self.cameraTrackStartPosition = track.transform.position
	self.cameraTrackStartRotation = track.transform.rotation
	self.mainTargetTransform = mainTarget.clientEntity.clientTransformComponent.transform
	self.cameraTrackPlaying = true
	self.playableDirector = track.gameObject:GetComponent(CS.UnityEngine.Playables.PlayableDirector)
	self.cameraTrack = track
	self.time = 0
	CustomUnityUtils.SetPlayableDirectorTime(self.playableDirector,0)
	
	CustomUnityUtils.PlayTimeLime(track.transform)
	self.playing = true
	self.useTimeScale = useTimeScale
	self.frame = self.clientFight.fight.fightFrame
	self.moveOffset = Vector3.zero
	self.lastMoveOffset = Vector3.zero

	--if IS_DEBUG then
        --self.debug = debug.traceback()
    --end
end

function ClientTimelineManager:StopCameraTrack(path,autoResetVAxis,vAxisOffset,autoResetHAxis,hAxisOffset)
	UnityUtils.BeginSample("StopCameraTrack")
	self.cameraTracks[path]:SetActive(false)
	self.cameraTrackPlaying = false
	self.playing = false
	self.clientFight.cameraManager:SetCameraState(FightEnum.CameraState.Operating)
	if autoResetVAxis then
		self.clientFight.cameraManager:FixVerticalAxis(vAxisOffset)
	end
	if autoResetHAxis then
		self.clientFight.cameraManager:FixHorizontalAxis(hAxisOffset)
	end
	UnityUtils.EndSample()
	--self.clientFight.cameraManager:FixVerticalAxis(30)
	--self.clientFight.cameraManager:FixHorizontalAxis(0)
end

function ClientTimelineManager:Update(lerpTime)
	if self.cameraTrackPlaying then
		self:UpdateMoveTotalOffset(lerpTime)
		local position = self.cameraTrack.transform.position - self.moveOffset * lerpTime + self.lastMoveOffset
		self.lastMoveOffset = self.moveOffset * lerpTime
		self.cameraTrack.transform.position = position
		
	end
	if self.playing and self.useTimeScale then
		self.time = self.time + Time.deltaTime * self.mainTarget.timeComponent:GetTimeScale()

		if UtilsBase.IsNull(self.playableDirector) then
	        Log("playableDirector null: "..self.debug)
	    end
		CustomUnityUtils.SetPlayableDirectorTime(self.playableDirector,self.time)
	end
	if self.dialogPlaying and self.useTimeScale then
		-- self.time = self.time + Time.deltaTime * self.mainTarget.timeComponent:GetTimeScale()
		-- CustomUnityUtils.SetPlayableDirectorTime(self.playableDialogDirector,self.time)
	end
	
end

function ClientTimelineManager:UpdateMoveTotalOffset(lerpTime)
	local moveOffset = self.mainTarget.moveComponent.moveOffset
	if self.frame == self.clientFight.fight.fightFrame then
		--self.moveOffset.z = 0
		--self.moveOffset.x = 0
		return
	end
	
	local position = self.cameraTrack.transform.position - self.moveOffset + self.lastMoveOffset
	self.cameraTrack.transform.position = position
	self.lastMoveOffset = Vector3.zero
	
	self.frame = self.clientFight.fight.fightFrame
	self.moveOffset.z = moveOffset.z
	self.moveOffset.x = moveOffset.x
	--self.moveOffset = self.cameraTrackStartRotation * self.moveOffset
end

	
function ClientTimelineManager:SetCameraNoise(track)
	UnityUtils.BeginSample("ClientTimelineManager:SetCameraNoise")
	local cinemachineCameras = track.gameObject:GetComponentsInChildren(Cinemachine.CinemachineVirtualCamera)
	for i = 0, cinemachineCameras.Length - 1 do
		local cinemachineCamera = cinemachineCameras[i]
		CinemachineInterface.SetCinemachineNoiseExtend(cinemachineCamera.transform,self.cameraManager.noise)
		local noise = CinemachineInterface.GetNoise(cinemachineCamera.transform)
		noise.cinemachineBrain = self.cameraManager.cinemachineBrain
	end
	UnityUtils.EndSample()
end


function ClientTimelineManager:__delete()

end