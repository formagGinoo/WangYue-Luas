WorldTitlePanel = BaseClass("WorldTitlePanel", BasePanel)

WorldTitlePanel.TitleType = {
    Map = 1,  --进入区域
    Task = 2, --激活任务
    TaskEnd = 3, --任务结束
    Challenge = 4, --激活挑战
    challengeEnd = 5, --挑战结束
    Victory = 6 --战斗胜利
}

function WorldTitlePanel:__init()
    self:SetAsset("Prefabs/UI/WorldTitle/WorldTitlePanel.prefab")
    self.mapTitleTimer = nil
end

function WorldTitlePanel:__CacheObject()
    self.victoryNode = UtilsUI.GetContainerObject(self.VictoryPart.transform)
    self.mapNode = UtilsUI.GetContainerObject(self.MapPart.transform)
    self.taskStartNode = UtilsUI.GetContainerObject(self.TaskStartPart.transform)
    self.taskEndNode = UtilsUI.GetContainerObject(self.TaskEndPart.transform)
    self.challengeStartNode = UtilsUI.GetContainerObject(self.ChallengeStartPart.transform)
    self.challengeEndNode = UtilsUI.GetContainerObject(self.ChallengeEndPart.transform)
end

function WorldTitlePanel:__BindListener()
    UtilsUI.SetHideCallBack(self.TaskEndPart, self:ToFunc("TaskEndPartHideEvent"))
    UtilsUI.SetHideCallBack(self.VictoryPart, function ()
        CustomUnityUtils.SetDepthOfFieldBoken(false, 0.16, 56, 32)
        self:HideEvent()
    end)
    UtilsUI.SetHideCallBack(self.MapPart, self:ToFunc("HideEvent"))
    UtilsUI.SetHideCallBack(self.TaskStartPart, self:ToFunc("HideEvent"))
    UtilsUI.SetHideCallBack(self.ChallengeStartPart, self:ToFunc("HideEvent"))
    UtilsUI.SetHideCallBack(self.ChallengeEndPart, self:ToFunc("HideEvent"))
end

function WorldTitlePanel:__Show()
	local command = self.args
	self.callBack = command[1]
    self:ShowTitleTip(command[2], command[3], command[4], command[5])

    UtilsUI.SetEffectSortingOrder(self.taskEndNode["21058"], self.canvas.sortingOrder)
    UtilsUI.SetEffectSortingOrder(self.challengeEndNode["21059"], self.canvas.sortingOrder)
end

function WorldTitlePanel:__Hide()
    if self.callBack then
        self.callBack()
        self.callBack = nil
    end
end

function WorldTitlePanel:__delete()
    if self.mapTitleTimer then
        LuaTimerManager.Instance:RemoveTimer(self.mapTitleTimer)
        self.mapTitleTimer = nil
    end
end

function WorldTitlePanel:ShowTitleTip(type, title, default, icon)
    if type == WorldTitlePanel.TitleType.Map and not self.mapTitleTimer then
        self.MapPart:SetActive(true)
        self.mapNode.Title_txt.text = title
        self.mapNode.NewPlace:SetActive(false)
        -- if default then
        --     self.mapNode.NewPlace:SetActive(true)
        -- else
        --     self.mapNode.NewPlace:SetActive(false)
        -- end

        local timerFunc = function ()
            if self.mapTitleTimer then
                LuaTimerManager.Instance:RemoveTimer(self.mapTitleTimer)
                self.mapTitleTimer = nil
            end
        end
        self.mapTitleTimer = LuaTimerManager.Instance:AddTimer(1, 10, timerFunc)
    elseif type == WorldTitlePanel.TitleType.Task then
        -- 任务指引延迟出现 TODO 不知道worldTitle有没有可能不是fightMain的一部分
        EventMgr.Instance:Fire(EventName.GuideDelayAnim, true)
        --self.parentWindow.panelList["FightGuidePanel"]:DelayAnim(false)
        self.TaskStartPart:SetActive(true)
        self.taskStartNode.Title_txt.text = title
        if icon then
            SingleIconLoader.Load(self.taskStartNode.TaskTypeIcon, icon)
        end
    elseif type == WorldTitlePanel.TitleType.TaskEnd then
        EventMgr.Instance:Fire(EventName.GuideDelayAnim, false, false)
        self.TaskEndPart:SetActive(true)
        self.taskEndNode.Title_txt.text = title
        if default then
            self.taskEndNode.Finish:SetActive(true)
            self.taskEndNode.Defeat:SetActive(false)
        else
            self.taskEndNode.Finish:SetActive(false)
            self.taskEndNode.Defeat:SetActive(true)
        end
    elseif type == WorldTitlePanel.TitleType.Challenge then
        self.ChallengeStartPart:SetActive(true)
        self.challengeStartNode.Title_txt.text = title
    elseif type == WorldTitlePanel.TitleType.challengeEnd then
        self.ChallengeEndPart:SetActive(true)
        self.challengeEndNode.Title_txt.text = title
        if default then
            self.challengeEndNode.Finish:SetActive(true)
            self.challengeEndNode.Defeat:SetActive(false)
        else
            self.challengeEndNode.Finish:SetActive(false)
            self.challengeEndNode.Defeat:SetActive(true)
        end
    elseif type == WorldTitlePanel.TitleType.Victory then
        CustomUnityUtils.SetDepthOfFieldBoken(true, 0.117, 42, 26)
        self.VictoryPart:SetActive(true)
        self.victoryNode.Title_txt.text = title
    end
end

function WorldTitlePanel:TaskEndPartHideEvent()
    local guideTask = Fight.Instance.taskManager:GetGuideTask()
    local showGuide = guideTask and next(guideTask)
    EventMgr.Instance:Fire(EventName.GuideDelayAnim, false, showGuide)
    --self.parentWindow.panelList["FightGuidePanel"]:DelayAnim(true)
    self:HideEvent()
end

function WorldTitlePanel:HideEvent()
    self:Hide()
end