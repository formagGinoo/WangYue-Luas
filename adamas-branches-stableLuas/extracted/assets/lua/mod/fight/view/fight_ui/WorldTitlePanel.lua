WorldTitlePanel = BaseClass("WorldTitlePanel", BasePanel)

WorldTitlePanel.TitleType = {
    MapSmallArea = 1,  --进入小区域
    Task = 2, --激活任务
    TaskEnd = 3, --任务结束
    Challenge = 4, --激活挑战
    challengeEnd = 5, --挑战结束
    Victory = 6, --战斗胜利
    CityThreatenStart = 7, --城市威胁开始
    CityThreatenEnd = 8, --城市威胁结束
    MapMidArea = 9,  --进入中区域
    ChallengeInfo = 10 --挑战信息
}

local codTime = Config.DataCommonCfg.Find["MapChangeTips"].int_val

function WorldTitlePanel:__init()
    self:SetAsset("Prefabs/UI/WorldTitle/V2/WorldTitlePanelV2.prefab")
    self.mapTitleTimer = nil
end

function WorldTitlePanel:__CacheObject()
    self.victoryNode = UtilsUI.GetContainerObject(self.VictoryPart.transform)
    self.mapNode = UtilsUI.GetContainerObject(self.MapPart.transform)
    self.taskStartNode = UtilsUI.GetContainerObject(self.TaskStartPart.transform)
    self.taskEndNode = UtilsUI.GetContainerObject(self.TaskEndPart.transform)
    self.challengeInfoNode = UtilsUI.GetContainerObject(self.ChallengeInfoPart.transform)
    self.challengeStartNode = UtilsUI.GetContainerObject(self.ChallengeStartPart.transform)
    self.challengeSuccessNode = UtilsUI.GetContainerObject(self.ChallengeSuccessPart.transform)
    self.challengeFailNode = UtilsUI.GetContainerObject(self.ChallengeFailPart.transform)
    self.helpCityNode = UtilsUI.GetContainerObject(self.HelpCityPart.transform)
    self.mapMidAreaNode = UtilsUI.GetContainerObject(self.MapMidArea.transform)
end

function WorldTitlePanel:__BindListener()
    UtilsUI.SetHideCallBack(self.MapPart, self:ToFunc("HideEvent"))

    UtilsUI.SetHideCallBack(self.victoryNode.VictoryPart_out, self:ToFunc("AnimEndCallback"))
    UtilsUI.SetHideCallBack(self.taskStartNode.TaskStartPart_out, self:ToFunc("TaskEndPartHideEvent"))
    -- UtilsUI.SetHideCallBack(self.challengeStartNode.ChallengeStartPart_out, self:ToFunc("AnimEndCallback"))
    -- UtilsUI.SetHideCallBack(self.challengeSuccessNode.ChallengeSuccessPart_out, self:ToFunc("AnimEndCallback"))
    -- UtilsUI.SetHideCallBack(self.challengeFailNode.ChallengeFailPart_out, self:ToFunc("AnimEndCallback"))
end

function WorldTitlePanel:__Show()
	local command = self.args
    self:ShowTitleTip(command[1], command[2], command[3], command[4])
    --TODO --保底，最多5秒后关闭自己
    LuaTimerManager.Instance:RemoveTimer(self.tempTiemr)
    self.tempTiemr = nil
    self.tempTiemr = LuaTimerManager.Instance:AddTimer(1, 5, function ()
        self.MapMidArea:SetActive(false)
        self:HideEvent()
        LogError("WorldTitlePanel未正常关闭")
        LogTable("command", command)
    end)
end

function WorldTitlePanel:__Hide()
end

function WorldTitlePanel:RemoveMapTitleTimer()
    if self.mapTitleTimer then
        LuaTimerManager.Instance:RemoveTimer(self.mapTitleTimer)
        self.mapTitleTimer = nil
    end
end

function WorldTitlePanel:__delete()
    self:RemoveMapTitleTimer()
end

function WorldTitlePanel:ShowTitleTip(type, title, default, icon)
    if type == WorldTitlePanel.TitleType.MapSmallArea then
        self.MapPart:SetActive(true)
        self.openPart = self.MapPart
        self.mapNode.Title_txt.text = TI18N(title)
        self.mapNode.NewPlace:SetActive(false)
        self.mapTitleTimer = LuaTimerManager.Instance:AddTimer(1, 10, self:ToFunc("RemoveMapTitleTimer"))
    elseif type == WorldTitlePanel.TitleType.Task then
        -- 任务指引延迟出现 TODO 不知道worldTitle有没有可能不是fightMain的一部分
        EventMgr.Instance:Fire(EventName.GuideDelayAnim, true)
        --self.parentWindow.panelList["FightGuidePanel"]:DelayAnim(false)
        self.TaskStartPart:SetActive(true)
        self.taskStartNode.TaskStartBigTitle_txt.text = TI18N(title)
        self.taskStartNode.TaskStartSmallTitle_txt.text = TI18N("新任务")
        self.openPart = self.TaskStartPart
        self.isTaskEnd = false

    elseif type == WorldTitlePanel.TitleType.TaskEnd then
        if default then
            EventMgr.Instance:Fire(EventName.GuideDelayAnim, false, false)
            -- 任务完成
            self.TaskStartPart:SetActive(true)
            self.taskStartNode.TaskStartBigTitle_txt.text = TI18N("任务完成")
            self.taskStartNode.TaskStartSmallTitle_txt.text = TI18N(title)            
            self.openPart = self.TaskStartPart
            self.isTaskEnd = true
        else
            -- 任务失败
            LogError("策划说没有任务失败的情况")
            self:HideEvent()
        end
    elseif type == WorldTitlePanel.TitleType.ChallengeInfo then
        self.ChallengeInfoPart:SetActive(true)
        self.challengeInfoNode.ChallengeInfoTitle_txt.text = TI18N(title)
        self.openPart = self.ChallengeInfoPart
        LuaTimerManager.Instance:AddTimer(1, 3, self:ToFunc("AnimEndCallback"))
    elseif type == WorldTitlePanel.TitleType.Challenge then
        self.ChallengeStartPart:SetActive(true)
        self.challengeStartNode.ChallengeStartTitle_txt.text = TI18N(title)
        self.openPart = self.ChallengeStartPart
        LuaTimerManager.Instance:AddTimer(1, 3, self:ToFunc("AnimEndCallback"))
    elseif type == WorldTitlePanel.TitleType.challengeEnd then
        if default then
            --挑战成功
            self.ChallengeSuccessPart:SetActive(true)
            self.openPart = self.ChallengeSuccessPart
            LuaTimerManager.Instance:AddTimer(1, 3, self:ToFunc("AnimEndCallback"))

        else
            --挑战失败
            self.ChallengeFailPart:SetActive(true)
            self.openPart = self.ChallengeFailPart
            LuaTimerManager.Instance:AddTimer(1, 3, self:ToFunc("AnimEndCallback"))
        end
    elseif type == WorldTitlePanel.TitleType.Victory then
        self.VictoryPart:SetActive(true)
        self.openPart = self.VictoryPart

        -- 调整镜头FOV
        LuaTimerManager.Instance:AddTimer(1, 0.2, function ()
            self.curFov = CameraManager.Instance:GetFOV()
            self.toFov = self.curFov - 8
            local tweener = CustomUnityUtils.TweenerTo(self.curFov, self.toFov, 1.5, self:ToFunc("SetFovCb"))
            tweener:SetEase(Ease.OutQuint)
        end)

        LuaTimerManager.Instance:AddTimer(1, 3.5, function ()
            local tweener = CustomUnityUtils.TweenerTo(self.toFov, self.curFov, 0.5, self:ToFunc("SetFovCb"))
            tweener:SetEase(Ease.InSine)
            self.curFov = nil
            self.toFov = nil
        end)

    elseif type == WorldTitlePanel.TitleType.CityThreatenStart then
        self.HelpCityPart:SetActive(true)
        self.openPart = self.HelpCityPart 
        self.helpCityNode.HelpCityBigTitle_txt.text = TI18N(title)
        UtilsUI.SetActive(self.helpCityNode.StrongHelp, true)
        self.HelpCityPart_anim:Play("UI_HelpCityPart_StrongHelp_")
        self.mapTitleTimer = LuaTimerManager.Instance:AddTimer(1, 3, self:ToFunc("HelpCityHide"))
    elseif type == WorldTitlePanel.TitleType.CityThreatenEnd then
        self.HelpCityPart:SetActive(true)
        self.openPart = self.HelpCityPart 
        self.helpCityNode.HelpCityBigTitle_txt.text = TI18N(title)
        UtilsUI.SetActive(self.helpCityNode.WeakHelp, true)
        self.HelpCityPart_anim:Play("UI_HelpCityPart_WeakHelp_")
        self.mapTitleTimer = LuaTimerManager.Instance:AddTimer(1, 3, self:ToFunc("HelpCityHide"))
    elseif type == WorldTitlePanel.TitleType.MapMidArea then
        local callback = function()
            self:RemoveMapTitleTimer()
            if self.MapMidArea then
                self.MapMidArea:SetActive(false)
            end
            self:AnimEndCallback()
        end
        if self.isCod then
            callback()
            return
        end
        self.isCod = true
        
        self.MapMidArea:SetActive(true)
        self.mapMidAreaNode.title_txt.text = TI18N(title)
        self.openPart = self.MapMidArea
        self:OpenCodTimer()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.mapMidAreaNode.TitleGroup.transform)
        self.mapTitleTimer = LuaTimerManager.Instance:AddTimer(1, 3, callback)
    end
end

function WorldTitlePanel:OpenCodTimer()
    if not self.codTimer and self.isCod then
        self.codTimer = LuaTimerManager.Instance:AddTimer(1, codTime, function ()
            self.isCod = false
            self:CloseCodTimer()
        end)
    end
end

function WorldTitlePanel:CloseCodTimer()
    if self.codTimer then 
        LuaTimerManager.Instance:RemoveTimer(self.codTimer)
        self.codTimer = nil
    end
end

function WorldTitlePanel:TaskEndPartHideEvent()
    if self.isTaskEnd then
        local guideTask = Fight.Instance.taskManager:GetGuideTask()
        local showGuide = guideTask and next(guideTask)
        EventMgr.Instance:Fire(EventName.GuideDelayAnim, false, showGuide)

    end
    self.isTaskEnd = nil

    self:AnimEndCallback()
end

function WorldTitlePanel:HideEvent()
    --self:Hide()
    LuaTimerManager.Instance:RemoveTimer(self.tempTiemr)
    self.tempTiemr = nil
    PanelManager.Instance:ClosePanel(self)
end

function WorldTitlePanel:AnimEndCallback()
    if self.openPart then
        self.openPart:SetActive(false)
        self.openPart = nil
    end
    self:HideEvent()
end

function WorldTitlePanel:HelpCityHide()
    UtilsUI.SetActive(self.helpCityNode.StrongHelp, false)
    UtilsUI.SetActive(self.helpCityNode.WeakHelp, false)
    UtilsUI.SetActive(self.HelpCityPart, false)
    self:HideEvent()
end


function WorldTitlePanel:SetFovCb(value)
    --print(value)
    CameraManager.Instance:SetFOV(value)
end