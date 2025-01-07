StoryController = SingleClass("StoryController")

function StoryController:__init(story)
    self.timelineRoot = GameObject("TimelineRoot").transform
    self.storyTimeline = self.timelineRoot.gameObject:AddComponent(StoryTimeline)
    self.timelineRoot:SetParent(story.root.transform)

    self.duration = 0
    self.exploreMap = {}
    self:InitClipEvent()
end

function StoryController:InitClipEvent()
    self.storyTimeline:SetAction(self:ToFunc("ClipEnter"), self:ToFunc("ClipPause"))
    self.storyTimeline:SetExploreObjAction(self:ToFunc("AddExploreObj"), self:ToFunc("RmoveExploreObj"))
    self.storyTimeline:SetExploreAction(self:ToFunc("AddExplore"), self:ToFunc("RemoveExplore"))
end

function StoryController:TryPlayStory(fileId, func)
    local succeed = UtilsBase.TryCatch(self.PlayStory, self, fileId)
    if not succeed then
        if func then func() end
        Story.Instance:BreakStory()
    end
    return succeed
end

function StoryController:PlayStory(fileId)
    if self.playableDirector then
        CustomUnityUtils.RemovePlayableEndEvent(self.playableDirector)
        self.playableDirector = nil
    end
    local track = StoryAssetsMgr.Instance:GetTimelineFile(fileId)
    track.transform:SetParent(self.timelineRoot)
    self.fileId = fileId
    self.playableDirector = track:GetComponent(CS.UnityEngine.Playables.PlayableDirector)
    local setting = Story.Instance:GetSetting()

	if setting.bindingList then
		for i = 1, #setting.bindingList do
			local target = BehaviorFunctions.fight.entityManager:GetEntity(setting.bindingList[i])
			if target then
				local targetTransform = target.clientTransformComponent.transform
				if i == 1 then
					track.transform.position = targetTransform.position
					track.transform.rotation = targetTransform.rotation
				end
				CustomUnityUtils.SetPlaytrackBinding(track.transform, i, targetTransform)
			end
		end
	end
	if setting.pos or setting.rot then
		track.transform.position = setting.pos or Vec3.zero
		local lookDir = setting.rot - track.transform.position
		lookDir.y = 0
		track.transform.rotation = Quaternion.LookRotation(lookDir);
	end

    CustomUnityUtils.AddPlayableEndEvent(self.playableDirector, self:ToFunc("TimelineEnd"))
    CustomUnityUtils.SetPlaytrackBinding(track.transform, "ContentTrack")
	CustomUnityUtils.PlayTimeLime(track.transform)
    self:UpDateTimelineInfo()
    self.dialogPlaying = true
end

function StoryController:UpDateTimelineInfo()
    self.duration = self.storyTimeline.timelineDuration
    TableUtils.ClearTable(self.exploreMap)
    if self.storyTimeline.isExploreTrack then
        local exploreList = self.storyTimeline.exploreList
        local exploreStartList = self.storyTimeline.exploreStartList
        local exploreEndList = self.storyTimeline.exploreEndList
        StoryExploreMgr.Instance:UpdateData(exploreList, exploreStartList, exploreEndList)
        self:JumpToTime(self.duration - 1 / 60)
        self:SetSpeed(0)
    else
        self:SetSpeed(1)
    end
end

function StoryController:ClipEnter(storyId,contentType)
	Story.Instance:PassCallback(storyId)
    EventMgr.Instance:Fire(EventName.ClipEnter, storyId, contentType)
end

function StoryController:ClipPause(storyId)
    EventMgr.Instance:Fire(EventName.ClipPause, storyId)
end

function StoryController:AddExploreObj(exploreId, go)
    StoryExploreMgr.Instance:AddExploreObj(exploreId, go)
end

function StoryController:RmoveExploreObj(exploreId)
    StoryExploreMgr.Instance:RemoveExploreObj(exploreId)
end

function StoryController:AddExplore(exploreId)
    StoryExploreMgr.Instance:AddExplore(exploreId)
end

function StoryController:RemoveExplore(exploreId)
    StoryExploreMgr.Instance:RemoveExplore(exploreId)
end

function StoryController:TimelineEnd()
    CustomUnityUtils.RemovePlayableEndEvent(self.playableDirector)
    local isEnd = Story.Instance:TimelineEnd(self.fileId)
    if not isEnd then
        CustomUnityUtils.AddPlayableEndEvent(self.playableDirector, self:ToFunc("TimelineEnd"))
    end
end

function StoryController:KeepEndState()
    self:JumpToTime(self.duration - 1 / 60)
    self:Play()
    self:SetSpeed(0)
end

function StoryController:ClearData()
    if not UtilsBase.IsNull(self.playableDirector) then
        CustomUnityUtils.RemovePlayableEndEvent(self.playableDirector)
    end
    self.playableDirector = nil
    self.fileId = nil
    self.dialogPlaying = false
end

function StoryController:Pause()
    self.playableDirector:Pause()
	self.dialogPlaying = false
end

function StoryController:Play()
    self.playableDirector:Play()
    self:SetSpeed(1)
	self.dialogPlaying = true
end

function StoryController:Resume()
    self.playableDirector:Play()
    self:SetSpeed(1)
	self.dialogPlaying = true
end

function StoryController:Stop()
    self.playableDirector:Stop()
	self.dialogPlaying = false
end

function StoryController:SetSpeed(speed)
    if not self.playableDirector then
        return
    end
    local curTime = self.playableDirector.time
    if speed > 0 and curTime >= self.duration then
        return
    elseif speed < 0 and curTime <= 0 then
        return
    end
    CustomUnityUtils.SetTimelineSpeed(self.playableDirector, speed)
end

function StoryController:JumpToTime(targetTime)
    self.playableDirector.time = targetTime
end

function StoryController:GetPauseTimeById(id)
    return self.storyTimeline:GetPauseTimeById(id)
end

function StoryController:GetStartTimeById(id)
    return self.storyTimeline:GetStartTimeById(id) + 0.01
end

function StoryController:GetCurTime()
    return self.playableDirector.time
end

function StoryController:GetCurState()
    return self.playableDirector and self.playableDirector.state
end

function StoryController:GetDuration()
    return self.duration
end

function StoryController:GetExploreCamObj()
    return self.storyTimeline:GetExploreCamObj()
end
--go, time
function StoryController:GetExploreClueCamObj(id)
    return self.storyTimeline:GetExploreClueCamObj(id)
end

function StoryController:GetLockState()
    return self.storyTimeline.lockState
end

function StoryController:GetPalyState()
    return self.dialogPlaying
end