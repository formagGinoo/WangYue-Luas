Story = SingleClass("Story")

Story.IgnoreSkipConfig = false

local StoryState = StoryConfig.StoryState
local ViewState = StoryConfig.ViewState
local StateType = SystemStateConfig.StateType

function Story:__init()
    self.root = GameObject("StoryRoot")
    self.pauseCount = 0
    GameObject.DontDestroyOnLoad(self.root)

    self:SetStoryState(StoryState.None)
    self:SetViewState(ViewState.None)
    self.storyData = {}
    self.storyQueue = {}
    self.runningQueue = {}
    self.selectList = {}
    self.stateMap = {}

    if ctx.Editor then
        Story.IgnoreSkipConfig = true
    else
        Story.IgnoreSkipConfig = PlayerPrefs.GetInt("IgnoreSkipConfig") > 0
    end

    StoryAssetsMgr.New(self)
    StoryController.New(self)
    StoryExploreMgr.New(self)
    self.eventManager = StoryEventManager.New(self)
    --EventMgr.Instance:AddListener(EventName.EnterSystemState, self:ToFunc("EnterSystemState"))
end

function Story:AddStoryCommand(id, delayStart, instanceId, bindingList, timeIn, timeOut, pos, rot, delayEnd)
    Story.StoryLog("添加剧情命令：", id)
    local storyData = {
        bindingList = bindingList, --绑定实体列表，按顺序匹配timeline中的空轨道
        timeIn = timeIn,--镜头融合，进入
        timeOut = timeOut,--镜头融合，退出
        pos = pos,
        rot = rot,
        instanceId = instanceId,
        delayEnd = delayEnd,

        curId = id,
        lastCtrlEntityState = nil --记录实体状态
    }
    table.insert(self.storyQueue, storyData)

    if not delayStart and not self:IsPause() then
        self:TryStartStoryByQueue()
    end

    if self:IsPause() then
        Story.StoryLog("剧情系统暂停中，已将其加入队列",id)
    end
end

function Story:TryStartStoryByQueue()
    if self:IsPause() then  return end
    if not next(self.storyQueue) then
        return
    end
    local storyData = table.remove(self.storyQueue, 1)
    local succeed = self:TryStartStory(storyData.curId, storyData)

    if not succeed then return end
    if StoryConfig.IsTipAside(storyData.curId) then
        self:StartStory(storyData.curId, storyData)
    else
        SystemStateMgr.Instance:AddState(StateType.Story, storyData.curId, storyData)
    end
end

function Story:TryStartStory(id, storyData)
    Story.StoryLog("开始播放：", id)
    if not StoryConfig.GetStoryConfig(id) then
        LogError(string.format("没有在剧情配置表中找到[%s]的数据,默认成功播放/结束", id))
        self:StartCallback(id)
        self:EndCallback(id)
        return false
    end
    if self:GetStoryState() == StoryState.Loading then
        LogError(string.format("当前正在加载对话资源:[%s]，尝试开始对话:[%s]", self.storyId, id))
        return false
    elseif self:GetStoryState() == StoryState.Playing and self.storyId == id then
        LogError(string.format("当前正在播放对话:[%s]，但是尝试重新开始播放它",id))
        return false
    elseif self:GetStoryState() == StoryState.Playing then
        if StoryConfig.AllowBreak(self.storyId) then
            Story.StoryLog("打断播放：", self.storyId)
            self:StoryEnd(true)
        else
            table.insert(self.storyQueue, 1, storyData)
            return false
        end
    end
    return true
end

function Story:StartStory(id, storyData)
    self.storyId = id
    Fight.Instance.entityManager:FireTriggerEntityInteract()
    TableUtils.ClearTable(self.storyData)
    for k, v in pairs(storyData) do
        self.storyData[k] = v
    end

    self:EnterStory()
end

function Story:EnterStory()
    local config = StoryConfig.GetStoryConfig(self.storyId)
    local storyData = self.storyData

    Story:ResetCurtain()

    self:SetNextStoryCameraBlend(storyData.timeIn, storyData.timeOut)
    self:EnterStoryState()

    --进入黑幕
    local isCurtainIn, curtainInTime = StoryConfig.GetCurtainIn(self.storyId)
    if isCurtainIn then
        local id = self.storyId
        Story.CurtainCtrl(curtainInTime,true)
        self.fadeIntimer = LuaTimerManager.Instance:AddTimer(1, curtainInTime, function ()
            if id == self.storyId then
                self:StartLoad()
            end
        end)
    else
        self:StartLoad()
    end
end

function Story:StartLoad()
    self:SetStoryState(StoryState.Loading)
    StoryAssetsMgr.Instance:LoadStory(self.storyId, self:ToFunc("LoadDone")) 
end

function Story:LoadDone()
    self:SetStoryState(StoryState.LoadDone)
    if self:IsPause() then
        return
    end
    self:PlayStory()
end

function Story:EnterStoryState(active)
    local config = StoryConfig.GetStoryConfig(self.storyId)
    if not StoryConfig.IsTipAside(self.storyId) and (not self.isEnterStory or active) then
        self.isEnterStory = true
        local storyData = self.storyData
        DayNightMgr.Instance:Pause()
        SystemStateMgr.Instance:SetFightVisible(StateType.Story, "000000000")
        EventMgr.Instance:Fire(EventName.OnEnterStory)
        --EventMgr.Instance:Fire(EventName.ShowFightMainUIDisplay, false)
        --EventMgr.Instance:Fire(EventName.PauseTipQueue)
        BehaviorFunctions.ShowAllHeadTips(false)
        BehaviorFunctions.CancelJoystick()
        BehaviorFunctions.StopMove(BehaviorFunctions.GetCtrlEntity())
        SystemStateMgr.Instance:ChangeEntityState(StateType.Story,FightEnum.EntityState.Perform)
        --BehaviorFunctions.DoSetEntityState(BehaviorFunctions.GetCtrlEntity(),FightEnum.EntityState.Perform)
        InputManager.Instance:AddLayerCount("Story")
    elseif self.isEnterStory and config.type == StoryConfig.DialogType.TipAside then
        self:ExitStoryState()
    end
end

function Story:ExitStoryState()
    self:SetNextStoryCameraBlend(0, 0)
    if self.isEnterStory or not StoryConfig.IsTipAside(self.storyId) then
        self.isEnterStory = false
        DayNightMgr.Instance:Resume()
        --EventMgr.Instance:Fire(EventName.ShowFightMainUIDisplay, true)
        --EventMgr.Instance:Fire(EventName.ResumeTipQueue)
        BehaviorFunctions.ShowAllHeadTips(true)
        LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
            CameraManager.Instance:SetCameraInheritPosition(true)
        end)
        --BehaviorFunctions.DoSetEntityState(BehaviorFunctions.GetCtrlEntity(), state)
        InputManager.Instance:MinusLayerCount("Story")
        SystemStateMgr.Instance:RemoveState(StateType.Story)
    end
end

function Story:ExitViewState()
    if self:GetStoryState() ~= StoryState.None then
        return
    end
    if self:GetViewState() == ViewState.Playing then
        Story.StoryLog("ExitViewState")
        self:ResetCurtain()
        self:DoConfigBehavior(self.historyConfig, false)
        StoryController.Instance:ClearData()
        StoryAssetsMgr.Instance:RemoveCacheObj()
        StoryExploreMgr.Instance:ClearData()
        self:ExitStoryState()
        if not next(self.storyQueue) then
            StoryAssetsMgr.Instance:DeleteAsset()
        end
        self:SetViewState(ViewState.None)
        --self:TryStartStoryByQueue()
    end
end

function Story:PlayStory()
    local isCurtainIn, curtainInTime = StoryConfig.GetCurtainIn(self.storyId)
    if isCurtainIn then
        Story.CurtainCtrl(0.8, false)
    end
    local config = StoryConfig.GetStoryConfig(self.storyId)
    local storyData = self.storyData
    if not StoryConfig.IsTipAside(self.storyId) then
        CameraManager.Instance:SetCameraInheritPosition(false)
        if storyData.instanceId then
            if StoryAssetsMgr.Instance:GetCameraType(self.storyId) == StoryConfig.CameraType.Entity then
                self:DefaultCameraBlend(storyData.instanceId)
            end
            local npcId = BehaviorFunctions.GetNpcId(storyData.instanceId)
            EventMgr.Instance:Fire(EventName.StartNPCDialog, npcId)
        end
    end
    self:DoConfigBehavior(config, true)
    --打开界面，播放timeline

    local showDone = function ()
        self:SetStoryState(StoryState.Playing)
        self:SetViewState(ViewState.Playing)
        self:StartCallback(self.storyId)
        StoryController.Instance:TryPlayStory(self.storyId)
        self.history = {storyData = storyData, storyId = self.storyId}
        self.panel:ShowDisplay()
    end

    self:ShowPanel(showDone)
end

function Story:DefaultCameraBlend(instanceId) --使用默认对话视角
    if not instanceId then return end
    local target = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
    local player = BehaviorFunctions.GetEntity(BehaviorFunctions.GetCtrlEntity())
    if target and player then
        local targetTransform = target.clientTransformComponent:GetTransform("CameraTarget")
		if not targetTransform then
			targetTransform = target.clientTransformComponent.transform:Find("CameraTarget")
		end
        local playerTransform = player.clientTransformComponent.transform:Find("CameraTarget")
        local cam = CameraManager.Instance:GetCamera(FightEnum.CameraState.Dialog)
        cam:SetTargetList(playerTransform, targetTransform)
        cam:OnEnter()
    end
end

function Story:SetNextStoryCameraBlend(timeIn, timeOut)
        if timeIn == nil and timeOut == nil then
        return
    end
    CustomUnityUtils.AddCameraTrackBlend(CameraManager.Instance.cinemachineBrain,"StoryCamera",timeIn or 0,timeOut or 0)
end

function Story:CheckNeedDelayView()
    local dealy, selectMap = Fight.Instance.taskManager.taskConditionManager:GetStoryEndCondition(self.storyId)
    if selectMap then
        dealy = false
        for k, selectId in pairs(self.selectList) do
            if selectMap[selectId] then
                dealy = true
                break
            end
        end
    end
    self.storyData.delayEnd = dealy
end

function Story:NeedDelayView()
    if self.storyData and self.storyData.delayEnd then
        return not StoryConfig.IsTipAside(self.storyId)
    end
end

function Story:DoConfigBehavior(config, enter)
    --执行配置表中的特殊行为
    --逻辑层结束时，表现层延时到下次开始才结束
    if self:NeedDelayView() and not enter then
        if not self.historyConfig then
            self.historyConfig = config
            return
        end
    end
    if enter and self.historyConfig then
        self:DoConfigBehavior(self.historyConfig, false)
    end

    if config.hide_player then
        local instanceId = BehaviorFunctions.GetCtrlEntity()
        local entity = BehaviorFunctions.GetEntity(instanceId)
        if entity and entity.clientTransformComponent then
            entity.clientTransformComponent:SetActivity(not enter)
        end
    end
    if config.hide_all_entity then
        if enter then
            BehaviorFunctions.fight.entityManager:HideAllEntity()
        else
            BehaviorFunctions.fight.entityManager:ShowAllEntity()
        end
    end
    if config.hide_npc_list and next(config.hide_npc_list) then
        for i = 1, #config.hide_npc_list, 1 do
            local entity = BehaviorFunctions.GetNpcEntity(config.hide_npc_list[i])
            if entity and entity.clientTransformComponent then
                entity.clientTransformComponent:SetActivity(not enter)
            end
        end
    end
    self.historyConfig = nil
end

--- func 返回timeline是否正常结束
---@param fileId any
function Story:TimelineEnd(fileId)
	local curId = self.storyData.curId
    local config = StoryConfig.GetStoryConfig(curId)
    local id = config.next_id

    local storyConfig = StoryConfig.GetStoryConfig(self.storyId)

    if storyConfig.child_type == StoryConfig.ChildType.Explore then
        StoryController.Instance:KeepEndState()
        return false
    end

    if not id then
        self:ExitStory()
    elseif id > 1000 then
        local tagetConfig = StoryConfig.GetStoryConfig(id)
        if tagetConfig.group_id == config.group_id then
            StoryController.Instance:TryPlayStory(id)
        else
            self:AddStoryCommand(id, true)
            self:ExitStory()
        end
    else
        self:ExitStory()
        self:BehaviorTrigger(id)
    end

    return true
end

function Story:SkipStory(curId)
    local config = StoryConfig.GetStoryConfig(self.storyId)
    if not config then
        LogError("缺少对应的配置信息，配置id = "..self.storyId)
        return
    end

    if StoryConfig.GetGroupAbstract(config.group_id) then
        StoryController.Instance:SetSpeed(0)
        PanelManager.Instance:OpenPanel(StoryAbstractPanel,{groupId = config.group_id})
        return
    end

    local targetId, fileId = StoryConfig.GetNextSelectId(curId or self.storyId , self.storyId)
    if not fileId then
        self:ExitStory(true)
    else
        if fileId ~= StoryController.Instance.fileId then
            StoryController.Instance:TryPlayStory(fileId)
        end
        local targetTime = StoryController.Instance:GetPauseTimeById(targetId)
        StoryController.Instance:JumpToTime(targetTime + 1 / 60)
    end
end

function Story:ExitStory(isSkip)
    if isSkip then
        StoryController.Instance:SetSpeed(0)
        local nextStory = StoryConfig.GetNextGorupStory(self.storyData.curId)
        if nextStory then
            self:AddStoryCommand(nextStory, true)
        end
    else
        StoryController.Instance:KeepEndState()
    end
    local config = StoryConfig.GetStoryConfig(self.storyId)
    self.panel:HideDisplay(true)
    if config.fade_out then
        Story.CurtainCtrl(1, true)
        self.endFuncTimer =  LuaTimerManager.Instance:AddTimer(1, 1, function ()
            self:StoryEnd(isSkip)
        end)
    else
        self:StoryEnd(isSkip)
    end
end

function Story:StoryEnd(isSkip)
    local storyData = self.storyData
    CameraManager.Instance:SetCameraPreviousState()
    local config = StoryConfig.GetStoryConfig(self.storyId)
    self:CheckNeedDelayView()
    self:DoConfigBehavior(config, false)
    self:SetNextStoryCameraBlend(storyData.timeIn, storyData.timeOut)

    local cam = CameraManager.Instance:GetCamera(FightEnum.CameraState.Dialog)
    cam:OnLeave()

    if self:NeedDelayView() then
        Story.StoryLog("StoryDelayView", self.storyId)
    else
        StoryController.Instance:ClearData()
        StoryAssetsMgr.Instance:RemoveCacheObj()
        StoryExploreMgr.Instance:ClearData()
    end

    local func = function (storyId)
        if not self:NeedDelayView() then
            self:ExitStoryState()
            if not next(self.storyQueue) then
                StoryAssetsMgr.Instance:DeleteAsset()
            end
            self:SetViewState(ViewState.None)
        else
            self.viewDelayTimer = LuaTimerManager.Instance:AddTimer(1, StoryConfig.DefaultDelayTime, self:ToFunc("ExitViewState"))
        end

        self:SetStoryState(StoryState.None)
        self:EndCallback(storyId)
        self:TryStartStoryByQueue()
    end

    if config.fade_out and not self:NeedDelayView() then
        Story.CurtainCtrl(0.8, false)
    end

    if storyData.timeOut and storyData.timeOut > 0 and not isSkip then
        self.timeOutTimer = LuaTimerManager.Instance:AddTimer(1, storyData.timeOut, function ()
            func(self.storyId)
        end)
    else
        func(self.storyId)
    end
end

function Story:StartCallback(storyId)
    if self.tempId then
        LogError("剧情未进入结束回调", self.tempId, storyId)
    end
    TableUtils.ClearTable(self.selectList)
    self.tempId = storyId
    Story.StoryLog("StartCallback:", storyId)
    EventMgr.Instance:Fire(EventName.StoryDialogStart, storyId)
    Fight.Instance.entityManager:CallBehaviorFun("StoryStartEvent", storyId)
    local config = StoryConfig.GetStoryConfig(storyId)
    if config.child_type == StoryConfig.ChildType.Explore then
        Fight.Instance.entityManager:CallBehaviorFun("ExploreStartEvent", storyId)
    end
    -- local dealy = Fight.Instance.taskManager.taskConditionManager:GetStoryEndCondition(storyId)
    -- self.storyData.delayEnd = dealy
end

function Story:EndCallback(storyId)
    if self.tempId and self.tempId ~= storyId then
        LogError("开始与结束id不一致", self.tempId, storyId)
    end
    self.tempId = nil
    self.storyId = nil
    TableUtils.ClearTable(self.storyData)
    Fight.Instance.entityManager:FireTriggerEntityInteract()
    -- 对话结束再获取选项奖励
    for i, v in ipairs(self.selectList) do
        mod.StoryCtrl:SelectDialog(storyId,v)
    end

    Story.StoryLog("EndCallback:", storyId)
    EventMgr.Instance:Fire(EventName.StoryDialogEnd, storyId, self.selectList)
    Fight.Instance.entityManager:CallBehaviorFun("StoryEndEvent", storyId, SoundManager.Instance.channelStop)
    local config = StoryConfig.GetStoryConfig(storyId)
    if config.child_type == StoryConfig.ChildType.Explore then
        local res = StoryExploreMgr.Instance:IsComplete()
        Fight.Instance.entityManager:CallBehaviorFun("ExploreEndEvent", storyId, res)
    end
end

function Story:SelectCallback(selectId,storyId)
    Story.StoryLog("SelectCallback:", selectId)
    EventMgr.Instance:Fire(EventName.StorySelectEvent, selectId, storyId)
    Fight.Instance.entityManager:CallBehaviorFun("StorySelectEvent", selectId)
    table.insert(self.selectList,selectId)
end

function Story:PassCallback(storyId)
    Story.StoryLog("PassCallback:", storyId)
	self.storyData.curId = storyId
    EventMgr.Instance:Fire(EventName.StoryPassEvent, storyId)
    Fight.Instance.entityManager:CallBehaviorFun("StoryPassEvent", storyId)
end


function Story:SelectOption(index)
    Story.StoryLog("选择选项序号",index)
    local storyId = self.storyData.curId
    local config = StoryConfig.GetStoryConfig(storyId)
    local selectId
    if config.options[index] then
        selectId = config.options[index][2]
    end

    if not selectId then
        self:ExitStory()
    elseif selectId > 1000 then
        local selectConfig = StoryConfig.GetStoryConfig(selectId)
        if selectConfig.group_id == config.group_id then
            local res = StoryController.Instance:TryPlayStory(selectId, function()
                self:SelectCallback(selectId,self.storyId)
            end)
            if not res then
                return
            end
        else
            self:AddStoryCommand(selectId, true)
            self:ExitStory()
        end
    else
        self:BehaviorTrigger(selectId)
        self:ExitStory()
    end

    if selectId then
        self:SelectCallback(selectId,self.storyId)
    end
end

--- func desc
---@param index any
function Story:GetOptionContent(index)
    local storyId = self.storyData.curId
    local config = StoryConfig.GetStoryConfig(storyId)
    local selectId, content, icon, sub
    if config.options[index] then
        selectId = config.options[index][2]
        content = config.options[index][1]
        icon = StoryConfig.GetTriggerIcon(selectId)
    end

    local isLock,tip, condition = self:CheckOptionCondtion(selectId)

    if selectId and selectId <= 1000 and self.storyData.instanceId then
        local npcId = BehaviorFunctions.GetNpcId(self.storyData.instanceId)
        content, sub = self.eventManager:GetBehaviorTriggerContext(selectId, npcId, content)
    end

    return content, icon, sub, isLock, tip, condition
end

function Story:GetOptionId(index)
    local config = StoryConfig.GetStoryConfig(self.storyData.curId)
    return config.options[index][2]
end

function Story:CheckOptionCondtion(optionId)
    if not optionId then
        return false,{}
    end

    local isLock, tip, m_condition
    if optionId > 1000 then
        -- local config = StoryConfig.GetStoryConfig(optionId)
        local condition = StoryConfig.GetStoryCondition(optionId)
        if condition and condition > 0 then
            isLock = not Fight.Instance.conditionManager:CheckConditionByConfig(condition)
            if isLock then
                tip = Fight.Instance.conditionManager:GetConditionDesc(condition)
            end
            m_condition = condition
        end
    else
        if not self.storyData.instanceId then
            LogError("没有和npc交换，不能触发功能")
            return isLock, tip, m_condition
        end
        local npcId = BehaviorFunctions.GetNpcId(self.storyData.instanceId)
        local condition = StoryConfig.GetTriggerCondition(npcId, optionId)
        isLock = not Fight.Instance.conditionManager:CheckConditionByConfig(condition)
        if isLock then
            tip = Fight.Instance.conditionManager:GetConditionDesc(condition)
        end
        m_condition = condition
    end

    return isLock, tip, m_condition
end



function Story:BehaviorTrigger(triggerId)
    if not self.storyData.instanceId then
        return
    end
    local npcId = BehaviorFunctions.GetNpcId(self.storyData.instanceId)
    self.eventManager:BehaviorTrigger(triggerId, npcId, self.storyData.instanceId)
end

function Story:GetSetting()
    return self.storyData
end

function Story:ShowPanel(callback)
    if not self.panel then
        self.panel = StoryDialogPanelV2.New()
        self.panel:StartStory(self.storyId)
        self.panel:Show(callback)
    elseif callback then
        self.panel:StartStory(self.storyId)
        callback()
    end
end

function Story:GetStoryPlayState()
    return self:GetStoryState() ~= StoryState.None
end

function Story:SetStoryState(state, id)
    if Fight.Instance then
        Fight.Instance.entityManager:FireTriggerEntityInteract()
    end
    self.runningState = state
end

function Story:GetStoryState(id)
    return self.runningState
end

function Story:SetViewState(state)
    self.viewState = state
end

function Story:GetViewState()
    return self.viewState
end

function Story:GetNowPlayingId()
    return self.storyId
end

function Story:RePlayLastNPCDialog()
    if self.history and next(self.history) then
        BehaviorFunctions.StartNPCDialog(self.history.storyId, self.history.storyData.instanceId)
    end
end

function Story:OnFightStart()
    if self:GetStoryState() == StoryState.Playing then
        self:EnterStoryState(true)
    end
end

function Story:Resume()--恢复
    self.pauseCount = self.pauseCount - 1
	if self.pauseCount < 0 then
		self.pauseCount = 0
        return
	end
    Story.StoryLog("剧情系统恢复", self.pauseCount)
    if self.pauseCount == 0 then
        if self:GetStoryState() == StoryState.LoadDone then
            self:PlayStory()
        elseif self:GetStoryState() == StoryState.Playing then
            StoryController.Instance:SetSpeed(1)
            self.panel:ShowDisplay()
        else
            self:TryStartStoryByQueue()
        end
    end
end

function Story:Pause()--暂停
    self.pauseCount = self.pauseCount + 1
    Story.StoryLog("剧情系统暂停", self.pauseCount)
    if self.pauseCount == 1 and self:GetStoryState() == StoryState.Playing then
        StoryController.Instance:SetSpeed(0)
        self.panel:HideDisplay()
    end
end

function Story:IsPause()
    return self.pauseCount > 0
end

function Story:Stop()
    if not self:GetStoryPlayState() then
        return
    end
    self.panel:HideDisplay(true)
    self:ResetCurtain()

    StoryAssetsMgr.Instance:StopLoading()
    StoryController.Instance:ClearData()
    StoryExploreMgr.Instance:ClearData()
    StoryAssetsMgr.Instance:RemoveCacheObj()
    StoryAssetsMgr.Instance:DeleteAsset()

    self.storyId = nil
    self.storyData = nil
    self:SetStoryState(StoryState.None)
    TableUtils.ClearTable(self.stateMap)
    TableUtils.ClearTable(self.runningQueue)
end

function Story:GetCurStory()
    if self:GetStoryPlayState() then
        return self.storyId
    end
end

function Story:Update()
    if self:GetStoryState() == StoryState.Playing then
        self.panel:Update()
    end
end

function Story:CallPanelFunc(funcName,...)
    if self:GetStoryState() == StoryState.Playing then
        self.panel[funcName](self.panel, ...)
    end
end

function Story:BreakStory()
    local res = string.format("剧情[%s]播放异常，请截图反馈文案，已自动跳过", self.storyId)
    MsgBoxManager.Instance:ShowTextMsgBox(res)
    self.panel:HideDisplay(true)
    self:StoryEnd(true)
    self:ResetCurtain()
end
--#region 其他
local logs = {}

function Story.StoryLog(...)
    if ctx.Editor then
        if #logs > 20 then
            table.remove(logs, 1)
        end
        table.insert(logs, table.concat({...}, ",") or "")
    end
    if DebugConfig.ShowStoryLog then
        local log = table.concat({...}, ",") or ""
        LogError("StoryLog: " ,log)
    end
end

local CurtainCount = 0
function Story.CurtainCtrl(time, isEnter)
    time = time or 0
    if isEnter then
        CurtainCount = CurtainCount + 1 
        CurtainManager.Instance:FadeIn(true, time)
    else
        CurtainCount = CurtainCount - 1
        CurtainManager.Instance:FadeOut(time)
    end
    Story.StoryLog("剧情黑幕计数", CurtainCount)
end

function Story:ResetCurtain()
    if self.fadeIntimer then
        LuaTimerManager.Instance:RemoveTimer(self.fadeIntimer)
    end
    if self.endFuncTimer then
        LuaTimerManager.Instance:RemoveTimer(self.endFuncTimer)
    end
    if self.timeOutTimer then
        LuaTimerManager.Instance:RemoveTimer(self.timeOutTimer)
    end
    if self.viewDelayTimer then
        LuaTimerManager.Instance:RemoveTimer(self.viewDelayTimer)
    end
    for i = 1, CurtainCount, 1 do
        Story.CurtainCtrl(0, false)
    end
end
--#endregion