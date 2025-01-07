StoryExploreMgr = SingleClass("StoryExploreMgr")

function StoryExploreMgr:__init(story)
    self.exploreRoot = GameObject("ExploreRoot").transform
    self.exploreRoot:SetParent(story.root.transform)
    self.exploreMap = {}
    self.exploreObjMap = {}
    self.exploreCamMap = {}
    self.exploreInfoMap = {}
end

function StoryExploreMgr:UpdateData(exploreList, exploreStartList, exploreEndList)
    TableUtils.ClearTable(self.exploreMap)
    self.clueCount = exploreList.Count
    self.curCount = 0
    local totalTime = StoryController.Instance:GetDuration()
    for i = 0, self.clueCount - 1, 1 do
        local leading = StoryConfig.GetClueLeading(exploreList[i])
        local state = leading and StoryConfig.ClueState.NotFind or StoryConfig.ClueState.Locked
        self.exploreMap[exploreList[i]] = {
            id = exploreList[i],
            m_startTime = exploreEndList[i],
            startTime = totalTime - exploreEndList[i],
            m_endTime = exploreStartList[i],
            endTime = totalTime - exploreStartList[i],
            duration = exploreEndList[i] - exploreStartList[i],
            state = state
        }
    end

    self.active = true
    local cam = CameraManager.Instance:GetCamera(FightEnum.CameraState.StoryExplore)
    local exploreCamObj = StoryController.Instance:GetExploreCamObj()
    local exploreCam = exploreCamObj:GetComponent(ExploreCam)
    cam:SetPostion(exploreCam.camPos)
    cam:SetFollowAndDistance(exploreCam.follow, exploreCam.distance)
    cam:OnEnter()
    CustomUnityUtils.Scene3DUISetting(true, false)
    BehaviorFunctions.DoMagic(1,1,200001030, 1, FightEnum.MagicConfigFormType.Level)
end

function StoryExploreMgr:ClearData()
    if self.active then
        self.active = false
        CameraManager.Instance:GetCamera(FightEnum.CameraState.StoryExplore):OnLeave()
        for k, info in pairs(self.exploreInfoMap) do
            self:PushClueUI(info)
        end
        TableUtils.ClearTable(self.exploreInfoMap)
        TableUtils.ClearTable(self.exploreCamMap)
        CustomUnityUtils.Scene3DUIReset()
        BehaviorFunctions.DoMagic(1,1,200001030, 1, FightEnum.MagicConfigFormType.Level)
    end
end

function StoryExploreMgr:GetClueCount()
    return self.clueCount
end

function StoryExploreMgr:GetUnLockCount()
    return self.curCount
end

function StoryExploreMgr:GetClueData()
    return self.exploreMap
end

function StoryExploreMgr:AddExploreObj(id, go)
    local state = self:GetClueLockState(id)
    if state == StoryConfig.ClueState.NotFind then
        return
    end
    self.exploreObjMap[id] = go
    if not self.exploreInfoMap[id] then
        local info = self:PopClueUI()
        info:Init(id, go, self.exploreRoot)
        info:ShowDetail()
        self.exploreInfoMap[id] = info
    else
        self.exploreInfoMap[id]:ShowDetail()
    end
    local storyId = Story.Instance:GetCurStory()
    local unLock = state == StoryConfig.ClueState.Unlock
    Fight.Instance.entityManager:CallBehaviorFun("ClueEnterView", storyId, id, true, unLock)
end

function StoryExploreMgr:RemoveExploreObj(id)
    local state = self:GetClueLockState(id)
    if state == StoryConfig.ClueState.NotFind then
        return
    end
    self.exploreObjMap[id] = nil
    if self.exploreInfoMap[id] then
        local info = self.exploreInfoMap[id]
        info:Hide()
    end
    local storyId = Story.Instance:GetCurStory()
    local unLock = state == StoryConfig.ClueState.Unlock
    Fight.Instance.entityManager:CallBehaviorFun("ClueEnterView", storyId, id, false, unLock)
end

function StoryExploreMgr:AddExplore(id)
    self.exploreCamMap[id] = true
    --Story.Instance:CallPanelFunc("EnterClue",id)
    local storyId = Story.Instance:GetCurStory()
    local isFinish = self:GetClueLockState(id) == StoryConfig.ClueState.Unlock
    Fight.Instance.entityManager:CallBehaviorFun("EnterClueArea", storyId, id, true, isFinish)
end

function StoryExploreMgr:RemoveExplore(id)
    self.exploreCamMap[id] = nil
    --Story.Instance:CallPanelFunc("ExitClue",id)
    local storyId = Story.Instance:GetCurStory()
    local isFinish = self:GetClueLockState(id) == StoryConfig.ClueState.Unlock
    Fight.Instance.entityManager:CallBehaviorFun("EnterClueArea", storyId, id, false, isFinish)
end

function StoryExploreMgr:IsComplete()
    return self.curCount >= self.clueCount
end

function StoryExploreMgr:GetClueLockState(id)
    return self.exploreMap[id].locked
end

function StoryExploreMgr:GetExpBarState(time)
    for id, info in pairs(self.exploreMap) do
        if time >= info.startTime and time <= info.endTime then
            if info.state == StoryConfig.ClueState.Locked then
                return StoryConfig.ExploreBarState.Yellow
            elseif info.state == StoryConfig.ClueState.Unlock then
                return StoryConfig.ExploreBarState.Blue
            end
        end
    end
    return StoryConfig.ExploreBarState.Default
end

function StoryExploreMgr:GetClueLockState(id)
    return self.exploreMap[id].state
end

function StoryExploreMgr:SetClueLockState(id, state)
    local storyId = Story.Instance:GetCurStory()
    if self.exploreMap[id].state ~= state then
        local oldCount = self.curCount
        self.exploreMap[id].state = state
        if oldCount < self:UpdateUnLockCount() then
            SoundManager.Instance:PlaySound("UIDetectUnlock")
            Fight.Instance.entityManager:CallBehaviorFun("ClueUnlock", storyId, id)
        end

        if self:IsComplete() then
            MsgBoxManager.Instance:ShowTips(TI18N("所有线索已调查完成"))
            Story.Instance:CallPanelFunc("ClueFullUnlock")
            Fight.Instance.entityManager:CallBehaviorFun("ClueFullUnlock", storyId)
        end
        self:UpdateFindClue()
        Story.Instance:CallPanelFunc("UpdateProgress", id)
        if state == StoryConfig.ClueState.Unlock then
            self:ActiveCamera(id)
        end
    end
end

function StoryExploreMgr:ActiveCamera(id)
    local go, time = StoryController.Instance:GetExploreClueCamObj(id)
    CurtainManager.Instance:EnterWait(SystemConfig.WaitType.NotLoading)
    go:SetActive(true)
    LuaTimerManager.Instance:AddTimer(1, time, function()
        CurtainManager.Instance:ExitWait()
        if not UtilsBase.IsNull(go) then
            go:SetActive(false)
        end
    end)
end

function StoryExploreMgr:UpdateUnLockCount()
    local count = 0
    for k, v in pairs(self.exploreMap) do
        if v.state == StoryConfig.ClueState.Unlock then
            count = count + 1
        end
    end
    self.curCount = count
    return count
end

function StoryExploreMgr:UpdateFindClue()
    local dirty = false
    for id, value in pairs(self.exploreMap) do
        if value.state == StoryConfig.ClueState.NotFind then
            for _, v in pairs(StoryConfig.GetClueLeading(id)) do
                if self:GetClueLockState(v) ~= StoryConfig.ClueState.Unlock then
                    goto continue
                end
            end
            value.state = StoryConfig.ClueState.Locked
            dirty = true
            ::continue::
        end
    end
    if dirty then
        Story.Instance:CallPanelFunc("ShowExploreContent")
    end
end

function StoryExploreMgr:PopClueUI()
    local info = PoolManager.Instance:Pop(PoolType.class, "StoryClueObj")
    if not info then
        info = StoryClueObj.New()
    end
    return info
end

function StoryExploreMgr:PushClueUI(info)
    PoolManager.Instance:Push(PoolType.class, "StoryClueObj", info)
end

function StoryExploreMgr:GetMinTime()
    local res = 0
    for id, clue in pairs(self.exploreMap) do
        if clue.state == StoryConfig.ClueState.Locked and not StoryConfig.GetClueLeading(id) then
            res = clue.m_endTime > res and clue.m_endTime or res
        end
    end
    return res
end