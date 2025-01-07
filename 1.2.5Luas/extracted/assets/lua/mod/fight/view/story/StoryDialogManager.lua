---@class StoryDialogManager
StoryDialogManager = BaseClass("StoryDialogManager")

local DialogType = StoryConfig.DialogType

local CurtainCount = 0

function StoryDialogManager:__init(fight)
    self.fight = fight
    self.clientFight = fight.clientFight
    self.clientTimelineManager = fight.clientFight.clientTimelineManager
    self.timelineRoot = GameObject("StoryTimelineCache")
    self.timelineRoot.transform:SetParent(self.clientFight.fightRoot.transform)
    self.eventManager = StoryEventManager.New(self)

    self.timelineRoot:SetActive(false)
    self.startUniqueId = 0
    self.endUniqueId = 0
    self.runningStatus = false
    self.timelineObjects = {}
    self.removeList = {}
    self.lastCtrlEntityState = nil
    if ctx.Editor then
        self.ignoreSkipConfig = true
    else
        self.ignoreSkipConfig = false
    end

    EventMgr.Instance:AddListener(EventName.ResumeByCloseWindow,self:ToFunc("ResumeByCloseWindow"))
    EventMgr.Instance:AddListener(EventName.PauseByOpenWindow,self:ToFunc("PauseByOpenWindow"))
end

function StoryDialogManager:__delete()
    EventMgr.Instance:RemoveListener(EventName.ResumeByCloseWindow,self:ToFunc("ResumeByCloseWindow"))
    EventMgr.Instance:RemoveListener(EventName.PauseByOpenWindow,self:ToFunc("PauseByOpenWindow"))
    self.fight = nil
    self.runningStatus = false
    self.timelineObjects = {}
    self.removeList = {}
    
    self.eventManager:DeleteMe()
    if self.assertLoader then
        self.assertLoader:DeleteMe()
        self.assertLoader = nil
    end

    if self.endFuncTimer then
        LuaTimerManager.Instance:RemoveTimer(self.endFuncTimer)
    end
    if self.timeOutTimer then
        LuaTimerManager.Instance:RemoveTimer(self.timeOutTimer)
    end
    if self.fadeIntimer then
        LuaTimerManager.Instance:RemoveTimer(self.fadeIntimer)
    end
end

function StoryDialogManager:StartStoryDialog(dialogId, setting) --判断配置是否存在黑幕
    StoryDialogManager.CustomsLog("开始播放："..dialogId)
    if self.pauseStory then
        LogError("剧情系统处于暂停状态，不能开始新剧情："..dialogId)
    end
    if not StoryConfig.GetStoryConfig(dialogId) then
        LogError(string.format("没有在剧情配置表中找到[%s]的数据", dialogId))
        return
    end
    if self.assertLoader then
        LogError(string.format("当前正在加载对话资源:[%s]，尝试开始对话:[%s]",self.curPlayConfig.talk_id,dialogId))
        return
    end
    if self.runningStatus and self.curPlayConfig then -- 正在播放剧情时开始新的剧情对话
        if self.curPlayConfig.talk_id == dialogId then
            LogError(string.format("当前正在播放对话:[%s]，但是尝试重新开始播放它",dialogId))
            return
        end
        StoryDialogManager.CustomsLog("打断播放："..self.curPlayConfig.talk_id)
        if self.endFuncTimer then
            LuaTimerManager.Instance:RemoveTimer(self.endFuncTimer)
        end
        if self.timeOutTimer then
            LuaTimerManager.Instance:RemoveTimer(self.timeOutTimer)
        end
        self.endUniqueId = self.endUniqueId + 1
        self:EndCallBack(self.curPlayConfig.talk_id)
    end

    --播放过的对话进入销毁列表
    if not self.removeList[dialogId] then
        self.removeList[dialogId] = dialogId
    end

    local config = StoryConfig.GetStoryConfig(dialogId)
    self.runningStatus = true
    self.curPlayConfig = config
    if config.type ~= DialogType.TipAside then
        local entity = BehaviorFunctions.GetEntity(BehaviorFunctions.GetCtrlEntity())
        local lastState = entity.stateComponent:GetState()
        if entity and lastState == FightEnum.EntityState.Glide then
            self.lastCtrlEntityState = entity.stateComponent:GetState()
        end
        EventMgr.Instance:Fire(EventName.ShowFightDisplay, false)
        BehaviorFunctions.StopMove(BehaviorFunctions.GetCtrlEntity())
        BehaviorFunctions.DoSetEntityState(BehaviorFunctions.GetCtrlEntity(),FightEnum.EntityState.Perform)
        InputManager.Instance:AddLayerCount(InputManager.Instance.actionMapName, "Story")
    end

    if config.close_sound_channel then
        for k, v in pairs(config.close_sound_channel) do
            SoundManager.Instance:StopChannelSound(v)
        end
    end

    if self.fadeIntimer then
        LuaTimerManager.Instance:RemoveTimer(self.fadeIntimer)
    end

    if config.fade_in ~= 0 then
        if config.fade_in == -1 then
            StoryDialogManager.CurtainCtrl(0,true)
            self.fadeIntimer = LuaTimerManager.Instance:AddTimer(1, 0, function ()
                self:PlayStoryDialog(dialogId, setting, config)
            end)
        else
            StoryDialogManager.CurtainCtrl(config.fade_in, true)
            self.fadeIntimer = LuaTimerManager.Instance:AddTimer(1, config.fade_in, function ()
                self:PlayStoryDialog(dialogId, setting, config)
            end)
        end
    else
        self:PlayStoryDialog(dialogId, setting, config)
    end
end

function StoryDialogManager:PlayStoryDialog(dialogId, setting, config) --开始加载资源
    if not config.custom_camera and config.type ~= DialogType.TipAside and config.type ~= DialogType.Animation then
        if not self.waitPlayParam or not next(self.waitPlayParam) then
            self.waitPlayParam = { dialogId = dialogId, setting = setting}
            EventMgr.Instance:Fire(EventName.GetLastInstanceId, true)
            return
        end
    end
    self:LoadRelatedPrefabs(dialogId, function ()
        self:DoConfigBehavior(config, true)
        self:PlayDialog(dialogId, setting)
    end)
end

function StoryDialogManager:OnRecv_LastInstanceId(instanceId)
    if not self.waitPlayParam or not next(self.waitPlayParam) then
        return
    end
    self.lastInstanceId = instanceId
    self:DefaultCameraBlend(instanceId)

    local dialogId = self.waitPlayParam.dialogId
    local setting = self.waitPlayParam.setting
    TableUtils.ClearTable(self.waitPlayParam)
    self:LoadRelatedPrefabs(dialogId, function ()
        local config = StoryConfig.GetStoryConfig(dialogId)
        self:DoConfigBehavior(config, true)
        self:PlayDialog(dialogId, setting)
    end)
end

function StoryDialogManager:PlayDialog(dialogId, setting)
    if self.pauseStory then
        self.cacheConfig = {dialogId = dialogId, setting = setting}
        return
    end
    self.startUniqueId = self.startUniqueId + 1
    local panel = PanelManager.Instance:OpenPanel(StoryDialogPanel)
    panel:SetBindingSetting(setting)
    panel:PlayDialogByMgr(dialogId, self.startUniqueId)
    self:StartCallBack(dialogId, self.startUniqueId)
end
--打开窗口暂停
function StoryDialogManager:PauseByOpenWindow()
    self.pauseStory = true
end

function StoryDialogManager:ResumeByCloseWindow()
    self.pauseStory = false
    if self.cacheConfig and next(self.cacheConfig) then
        self:PlayDialog(self.cacheConfig.dialogId, self.cacheConfig.setting)
        self.cacheConfig = nil
    end
end

function StoryDialogManager:DefaultCameraBlend(instanceId) --使用默认对话视角
    if not instanceId then return end
    local target = BehaviorFunctions.fight.entityManager:GetEntity(instanceId)
    local player = BehaviorFunctions.GetEntity(BehaviorFunctions.GetCtrlEntity())
    if target and player then
        local targetTransform = target.clientEntity.clientTransformComponent.transform:Find("CameraTarget")
        local playerTransform = player.clientEntity.clientTransformComponent.transform:Find("CameraTarget")
        BehaviorFunctions.fight.clientFight.cameraManager:SetDialogTargets(playerTransform, targetTransform)
        BehaviorFunctions.SetCameraState(FightEnum.CameraState.Dialog)
    end
end

function StoryDialogManager:SetNextStoryCameraBlend(timeIn, timeOut) --设置下一次相机的过渡时间
    if timeIn == nil and timeOut == nil then
        return
    end
    self.customBlend = true
    CustomUnityUtils.AddCameraTrackBlend(self.clientFight.cameraManager.cinemachineBrain,"StoryCamera",timeIn or 0,timeOut or 0)
    self.timeOut = timeOut or 0
end

function StoryDialogManager:DialogEnd(isSkip, uniqueId)--结束时是否需要黑幕
    if uniqueId ~= self.endUniqueId + 1 then
		StoryDialogManager.CustomsLog(string.format("传入结束id：%s当前开始id：%s，当前结束id：%s", uniqueId, self.startUniqueId, self.endUniqueId))
        return
    end
    self.endUniqueId = self.endUniqueId + 1
    if self.endFuncTimer then
        LuaTimerManager.Instance:RemoveTimer(self.endFuncTimer)
    end
    if self.timeOutTimer then
        LuaTimerManager.Instance:RemoveTimer(self.timeOutTimer)
    end

    if self.curPlayConfig.fade_out then
        StoryDialogManager.CurtainCtrl(1, true)

        self.endFuncTimer =  LuaTimerManager.Instance:AddTimer(1, 1, function ()
            self:EndFunc(isSkip)
        end)
    else
        self:EndFunc(isSkip)
    end

end

function StoryDialogManager:EndFunc(isSkip)
	self:CacheCurTimelineObj();
    self:DoConfigBehavior(self.curPlayConfig, false)
    local state = CameraManager.Instance:GetCameraState()
    local changeState = state == FightEnum.CameraState.Level and state or FightEnum.CameraState.Operating
    BehaviorFunctions.SetCameraState(changeState)
    local func = function ()
        CustomUnityUtils.AddCameraTrackBlend(self.clientFight.cameraManager.cinemachineBrain,"StoryCamera",0,0)
        --删除缓存资源
        for key, value in pairs(self.removeList) do
            self:RemoveDataByGorupId(value)
            self.removeList[key] = nil
        end
        if self.curPlayConfig.type ~= DialogType.TipAside then
            local state = self.lastCtrlEntityState
            if not state then
                state = FightEnum.EntityState.Idle
            end
            self.lastCtrlEntityState = nil
            EventMgr.Instance:Fire(EventName.ShowFightDisplay, true)
            BehaviorFunctions.DoSetEntityState(BehaviorFunctions.GetCtrlEntity(), state)
            InputManager.Instance:MinusLayerCount()
        end

		if self.curPlayConfig.fade_out then
			StoryDialogManager.CurtainCtrl(0.8, false)
		end

        self.runningStatus = false
        
        self:EndCallBack(self.curPlayConfig.talk_id)
    end

    if self.customBlend and self.timeOut > 0 and not isSkip then --如果有淡出则延时销毁
        self.customBlend = false
        self.timeOutTimer = LuaTimerManager.Instance:AddTimer(1, self.timeOut, function ()
            func()
        end)
    else
        func()
    end
end

--加载资源完成时触发
function StoryDialogManager:StartCallBack(dialogId, uniqueId)
    StoryDialogManager.CustomsLog("StartCallBack:"..dialogId, uniqueId)
    Fight.Instance.entityManager:CallBehaviorFun("StoryStartEvent", dialogId)
    EventMgr.Instance:Fire(EventName.StoryDialogStart, dialogId)
end
--对话结束时触发
function StoryDialogManager:EndCallBack(dialogId)
    StoryDialogManager.CustomsLog("EndCallBack:"..dialogId, self.endUniqueId)
	self.curPlayConfig = nil

    Fight.Instance.entityManager:CallBehaviorFun("StoryEndEvent", dialogId, SoundManager.Instance.channelStop)
    EventMgr.Instance:Fire(EventName.StoryDialogEnd, dialogId)
    InputManager.Instance:MinusLayerCount()
end

function StoryDialogManager:SelectCallBack(dialogId)
    StoryDialogManager.CustomsLog("SelectCallBack:"..dialogId)
    Fight.Instance.entityManager:CallBehaviorFun("StorySelectEvent", dialogId)
end

function StoryDialogManager:PassCallBack(dialogId)
    Fight.Instance.entityManager:CallBehaviorFun("StoryPassEvent", dialogId)
end

function StoryDialogManager:CacheCurTimelineObj() --隐藏当前timeline
    if not self.curDialogid then
        return
    end
    local data = self:GetDataById(self.curDialogid)
    if data then
        data.obj.transform:SetParent(self.timelineRoot.transform)
    end
    self.curDialogid = nil
end

function StoryDialogManager:GetStoryPlayState()
    return self.runningStatus
end

function StoryDialogManager:GetNowPlayingId()
    if self.runningStatus and self.curPlayConfig then
        return self.curPlayConfig.talk_id
    else
        return nil
    end
end

function StoryDialogManager:LoadRelatedPrefabs(dialogId,callBack) --加载关联资源
    local loadList = {}
    for k, v in ipairs(StoryConfig.GetAddRelevanceId(dialogId)) do
        self:GetRelatedData(loadList, v)
    end
    self:GetRelatedData(loadList, dialogId)

    for i = #loadList, 1, -1 do
        local path = StoryConfig.GetStoryFilePath(loadList[i].talkId)
        local obj
        if self.fight.clientFight.assetsPool:Contain(path) then
            obj = self.fight.clientFight.assetsPool:Get(path)
        end
        if obj then
            self:AddCacheObj(loadList[i].talkId, loadList[i].groupId, obj)
            table.remove(loadList, i)
        else
            loadList[i].path = path
            loadList[i].type = AssetType.Prefab
        end
    end

    local resOnLoad = function ()
        for i = 1, #loadList do
            self:AddCacheObj(loadList[i].talkId, loadList[i].groupId, self.assertLoader:Pop(loadList[i].path))
        end
        if self.assertLoader then
            self.assertLoader:DeleteMe()
            self.assertLoader = nil
        end
        if self.curPlayConfig and self.curPlayConfig.fade_in ~= 0 then
            StoryDialogManager.CurtainCtrl(0.8, false)
        end
        if callBack then
            callBack()
        end
    end

    if next(loadList) then
        self.assertLoader = AssetBatchLoader.New("DialogTimeLineLoader")
        self.assertLoader:AddListener(resOnLoad)
        self.assertLoader:LoadAll(loadList)
    elseif callBack then
        if self.curPlayConfig and self.curPlayConfig.fade_in ~= 0 then
            StoryDialogManager.CurtainCtrl(0.8, false)
        end
        callBack()
    end
end

function StoryDialogManager:GetRelatedData(loadList, dialogId) --获取关联加载对象
    local relevanceId = StoryConfig.GetRelevanceId(dialogId)
    if next(relevanceId) then
        for k, id in ipairs(relevanceId) do
            if not self.timelineObjects[dialogId] or not self.timelineObjects[dialogId][id] then
                table.insert(loadList, {talkId = id, groupId = dialogId})
            end
        end
    else
        if not self.timelineObjects[dialogId] or not self.timelineObjects[dialogId][dialogId] then
            table.insert(loadList, {talkId = dialogId, groupId = dialogId})
        end
    end
end

function StoryDialogManager:GetTimelineFile(dialogId)
    self:CacheCurTimelineObj(); --显示新资源隐藏当前的预设
    if self:GetDataById(dialogId) then
        self.curDialogid = dialogId
        local data = self:GetDataById(dialogId)
        PanelManager.Instance:GetPanel(StoryDialogPanel):PlayTimeline(data.obj, data.firstLoad)
        data.firstLoad = false
    else
        LogError(string.format("获取对话[%s]预设失败,原因是它没有被预加载到", dialogId))
    end
end


function StoryDialogManager:AddCacheObj(talkId, groupId, obj) --存储预加载资源
    --StoryDialogManager.CustomsLog("groupId"..groupId.."  talkId"..talkId)
    local transform =  obj.transform
    transform:SetParent(self.timelineRoot.transform)

    --是否使用配置位置
    local config = StoryConfig.GetStoryConfig(groupId)
    if config.position and next(config.position) then
        local dupId, dupLevelId = mod.WorldMapCtrl:GetDuplicateInfo()
        local tfConfig = mod.WorldMapCtrl:GetMapPositionConfig(dupLevelId, config.position[2], config.position[1])
        if tfConfig then
            UnityUtils.SetPosition(transform, tfConfig.X, tfConfig.Y, tfConfig.Z)
            UnityUtils.SetRotation(transform, tfConfig.rotX, tfConfig.rotY, tfConfig.rotZ, tfConfig.rotW)
        end
    else
        transform:ResetAttr()
    end

    --设置动画更新模式
	CustomUnityUtils.SetAnimatorStateByTimelineObject(obj, true)

    --缓存加载的资源
    if not self.timelineObjects[groupId] then
        self.timelineObjects[groupId] = {}
    end
    if not self.timelineObjects[groupId][talkId] then
        self.timelineObjects[groupId][talkId] = {}
    end
    self.timelineObjects[groupId][talkId].obj = obj
    self.timelineObjects[groupId][talkId].firstLoad = true
end

function StoryDialogManager:GetDataById(dialogId) --获取timeline信息
    for groupId, group in pairs(self.timelineObjects) do
        if group[dialogId] then
            return group[dialogId]
        end
    end
end

function StoryDialogManager:RemoveDataByGorupId(groupId) -- 删除指定组资源
    for key, group in pairs(self.timelineObjects) do
        if key == groupId then
            for k, v in pairs(group) do
                local path = StoryConfig.GetStoryFilePath(k)
                if self.fight.clientFight.assetsPool:Contain(path) then
                    self.fight.clientFight.assetsPool:Cache(path, v.obj)
                else
                    GameObject.DestroyImmediate(v.obj)
                end
            end
			self.timelineObjects[key] = nil
            break
        end
    end
end

function StoryDialogManager:DoConfigBehavior(config, isEnter)
    --执行配置表中的特殊行为
    if config.hide_player then
        local instanceId =  BehaviorFunctions.GetCtrlEntity()
        local entity = BehaviorFunctions.GetEntity(instanceId)
        if entity and entity.clientEntity.clientTransformComponent then
            entity.clientEntity.clientTransformComponent:SetActivity(not isEnter)
        end
    end
    if config.hide_all_entity then
        if isEnter then
            BehaviorFunctions.fight.entityManager:HideAllEntity()
        else
            BehaviorFunctions.fight.entityManager:ShowAllEntity()
        end
    end
    if config.hide_npc_list and next(config.hide_npc_list) then
        for i = 1, #config.hide_npc_list, 1 do
            local entity = BehaviorFunctions.GetNpcEntity(config.hide_npc_list[i])
            if entity and entity.clientEntity.clientTransformComponent then
                entity.clientEntity.clientTransformComponent:SetActivity(not isEnter)
            end
        end
    end
end

--触发行为
function StoryDialogManager:BehaviorTrigger(triggerId)
    local npcId 
    if self.lastInstanceId then
        npcId = BehaviorFunctions.GetNpcId(self.lastInstanceId)
    end
    self.eventManager:BehaviorTrigger(triggerId, npcId, self.lastInstanceId)
end

--检查触发行为是否可用

function StoryDialogManager:CheckBehaviorTrigger(triggerId)
    local npcId 
    if self.lastInstanceId then
        npcId = BehaviorFunctions.GetNpcId(self.lastInstanceId)
    end
    local condition = StoryConfig.GetTriggerCondition(npcId, triggerId)
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(condition)
    return isPass

end
function StoryDialogManager:ChangeIgnoreSkipConfig()
    self.ignoreSkipConfig = not self.ignoreSkipConfig
    if self.runningStatus then
        PanelManager.Instance:GetPanel(StoryDialogPanel):ShowSkipButton()
    end
    return self.ignoreSkipConfig
end

function StoryDialogManager:SkipDialog()
    if self.runningStatus then
        PanelManager.Instance:GetPanel(StoryDialogPanel):SkipDialogByCommand()
    end
end

function StoryDialogManager.CurtainCtrl(time, isEnter)
    time = time or 0
    if isEnter then
        CurtainCount = CurtainCount + 1 
        CurtainManager.Instance:FadeIn(true, time)
    else
        CurtainCount = CurtainCount - 1
        CurtainManager.Instance:FadeOut(time)
    end
    StoryDialogManager.CustomsLog("CurtainCount", CurtainCount)
end

local showLog = false
local logs = {}
function StoryDialogManager.CustomsLog(...)
    if not ctx.Editor then
        return
    end
    if #logs > 100 then
        table.remove(logs, 1)
    end
    local log = table.concat({...}, ",") or ""
    table.insert(logs, log)
    if showLog then
        Log("Log: " ,log)
    end
end