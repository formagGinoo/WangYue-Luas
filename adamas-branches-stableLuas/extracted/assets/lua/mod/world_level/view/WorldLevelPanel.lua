WorldLevelPanel = BaseClass("WorldLevelPanel", BasePanel)

local ButtonState = 
{
    Upgrade = 1,
    Degrade = 2,
    Achieved = 3,
    Cur = 4,
    Break = 5
}

local ObjType = 
{
    Level = "LevelObj",
    Condition = "ConditionObj",
    Task = "TaskObj"
}

function WorldLevelPanel:__init()
    self:SetAsset("Prefabs/UI/WorldLevel/WorldLevelPanel.prefab")
    self.curLevelList = {}
    self.itemList = {}
    self.taskItemList = {}
    self.taskMap = {}
    self.levelMap = {}
end

function WorldLevelPanel:__BindListener()
    self:BindRedPoint(RedPointName.WorldLevBreak, self.SubmitRed)
    self:SetHideNode("WorldLevelPanel_Exit")
    --UtilsUI.SetHideCallBack(self.WorldLevelPanel_Exit, self:ToFunc("Close_CallBack"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
    self.DescButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenDesc"))

    local dragBehaviour = self.LevelList:AddComponent(UIDragBehaviour)
    dragBehaviour.onBeginDrag = function(data)
        for i = 0, self.LevelContent_rect.childCount - 1 do
            local obj = self.levelMap[i]
            obj.Level_txt.fontSize = 46
        end
    end
    dragBehaviour.onEndDrag = function (data)
        self:OnLevelSliderDragEnd()
    end
    --EventMgr.Instance:AddListener(EventName.WorldLevelChange, self:ToFunc("WorldLevelChange"))

    EventMgr.Instance:AddListener(EventName.SystemTaskChange, self:ToFunc("SystemTaskChange"))
    EventMgr.Instance:AddListener(EventName.SystemTaskFinish, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:AddListener(EventName.SystemTaskFinished, self:ToFunc("SystemTaskFinish"))
end

function WorldLevelPanel:__delete()
    --EventMgr.Instance:RemoveListener(EventName.WorldLevelChange, self:ToFunc("WorldLevelChange"))
    
    EventMgr.Instance:RemoveListener(EventName.SystemTaskChange, self:ToFunc("SystemTaskChange"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskFinish, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskFinished, self:ToFunc("SystemTaskFinish"))
end

function WorldLevelPanel:__Hide()
    self:CacheObj()
end



function WorldLevelPanel:CacheObj()
    for i = #self.itemList, 1, -1 do
        local item = table.remove(self.itemList, i)
        ItemManager.Instance:PushItemToPool(item)
    end
    for i = #self.taskItemList, 1, -1 do
        local item = table.remove(self.taskItemList, i)
        ItemManager.Instance:PushItemToPool(item)
    end
    self:PushAllUITmpObject(ObjType.Condition, self.CacheRoot_rect)
    self:PushAllUITmpObject(ObjType.Task, self.CacheRoot_rect)
    self:PushAllUITmpObject(ObjType.Level, self.CacheRoot_rect)
end

function WorldLevelPanel:__Show()
    self.curLevel, self.maxLevel = mod.WorldLevelCtrl:GetWorldLevel()
    local lev = self.maxLevel + 1 <= WorldLevelConfig.GetMaxLev() and self.maxLevel + 1 or WorldLevelConfig.GetMaxLev()
    self:SelectLevel(lev)
end

function WorldLevelPanel:WorldLevelChange()
    local oldCur, oldMax = self.curLevel, self.maxLevel
    self.curLevel, self.maxLevel = mod.WorldLevelCtrl:GetWorldLevel()
    self.levelCount = math.min(self.maxLevel, WorldLevelConfig.GetMaxLev()) + 1
    local lev
    if oldMax ~= self.maxLevel then
        lev = self.curLevel + 1 <= WorldLevelConfig.GetMaxLev() and self.curLevel + 1 or WorldLevelConfig.GetMaxLev()
        --PanelManager.Instance:OpenPanel(WorldLevelChangeTipPanel, {level = self.maxLevel})
    else
        lev = self.selectLev
    end
    self:SelectLevel(lev)
end

function WorldLevelPanel:SystemTaskChange(data)
    if self.taskMap[data.id] and self.active then
        self:ChangeTask(data.id)
    end
end

function WorldLevelPanel:SystemTaskFinish(data)
    local id = data
    if type(data) == "table" then
        id = data.id
    end
    if self.taskMap[id] and self.active then
        for i = #self.taskItemList, 1, -1 do
            local item = table.remove(self.taskItemList, i)
            ItemManager.Instance:PushItemToPool(item)
        end
        self:PushAllUITmpObject(ObjType.Task, self.CacheRoot_rect)
        self:ShowTask()
    end
end

function WorldLevelPanel:JumpToLev(lev)
    local x = -80 * (lev - 1)
    UnityUtils.SetAnchoredPosition(self.LevelContent_rect, x, 0)
end

function WorldLevelPanel:OnClick_SelectLevel(lev)
    if lev < 1 or lev > WorldLevelConfig.GetMaxLev() then
        return
    end
    if  math.abs(lev - self.selectLev) > 1 then
        return
    end
    if lev > self.maxLevel + 2  then
        return
    end

    if self.selectLev == lev then
        return
    end
    self:SelectLevel(lev)
end

function WorldLevelPanel:SelectLevel(level, notJump)
    self:CacheObj()
    self.selectLev = level
    self:ShowRewardItem()
    self:ShowCondition()
    self:ShowTask()
    self:ShowLevel()
    if self.selectLev == self.curLevel then
        self:ChangeButtonState(ButtonState.Cur)
    elseif self.selectLev < self.maxLevel and self.selectLev >= self.maxLevel - 1 then
        self:ChangeButtonState(ButtonState.Degrade)
    elseif self.selectLev < self.maxLevel - 1 then
        self:ChangeButtonState(ButtonState.Achieved)
    elseif self.selectLev > self.curLevel and self.selectLev <= self.maxLevel then
        self:ChangeButtonState(ButtonState.Upgrade)
    else
        self:ChangeButtonState(ButtonState.Break)
    end
    if not notJump then
        self:JumpToLev(level)
    end
end

function WorldLevelPanel:ShowCondition()
    local descs = WorldLevelConfig.GetLevelDesc(self.selectLev)

    for i = 1, #descs, 1 do
        local obj = self:PopUITmpObject(ObjType.Condition, self.ConditionRoot_rect)
        obj.Unlock:SetActive(self.selectLev <= self.maxLevel)
        obj.Locked:SetActive(self.selectLev > self.maxLevel)
        obj.Text_txt.text = descs[i]
    end
end

function WorldLevelPanel:ShowRewardItem()
    local reward =  WorldLevelConfig.GetWorldLevelReward(self.selectLev)
    if not reward then
        return
    end
    for index, value in ipairs(reward) do
        local itemInfo = {}
        itemInfo.template_id = value[1]
        itemInfo.count = value[2]
        itemInfo.acquired = self.selectLev <= self.maxLevel
        itemInfo.scale = 0.7
        local item = ItemManager.Instance:GetItem(self.ItemList_rect, itemInfo, true)
        self.itemList = self.itemList or {}
        table.insert(self.itemList,item)
    end
end

function WorldLevelPanel:ShowTask()
    local taskList = WorldLevelConfig.GetWorldLevelTask(self.selectLev)
    if not taskList then
        return
    end
    TableUtils.ClearTable(self.taskMap)
    local finishCount = 0

    for i = 1, #taskList, 1 do
        local config = SystemTaskConfig.GetTask(taskList[i])
        local obj = self:PopUITmpObject(ObjType.Task, self.TaskList_rect)
        local curValue = mod.SystemTaskCtrl:GetTaskProgress(taskList[i])
        local targetValue = ConditionManager.GetConditionTarget(config.condition)
        obj.TargetValue_txt.text = targetValue
        if curValue == -1 then
            finishCount = finishCount + 1
            obj.CurValue_txt.text = targetValue
        else
			curValue = curValue < targetValue and curValue or targetValue
            obj.CurValue_txt.text = curValue
        end

        obj.State1:SetActive(curValue < targetValue and curValue ~= -1) -- 进行中
        obj.State2:SetActive(curValue == targetValue) -- 可领取
        obj.State3:SetActive(curValue == -1) --已完成
        obj.Mask:SetActive(curValue == -1)
        if curValue < targetValue and curValue ~= -1 then
            if config.jump_id ~= 0 then
                obj.State1_txt.text = TI18N("前往")
                obj.State1Bg:SetActive(true)
                obj.State1_btn.onClick:RemoveAllListeners()
                obj.State1_btn.onClick:AddListener(function ()
                    JumpToConfig.DoJump(config.jump_id)
                end)
            else
                obj.State1_txt.text = TI18N("进行中")
                obj.State1Bg:SetActive(false)
            end
        end
        obj.Content_txt.text = config.desc
        local rewards = ItemConfig.GetReward(config.reward)
        for j = 1, #rewards, 1 do
            local itemInfo = {}
            itemInfo.template_id = rewards[j][1]
            itemInfo.count = rewards[j][2]
            itemInfo.scale = 0.65
            local item = ItemManager.Instance:GetItem(obj.ItemRoot_rect, itemInfo, true)
            table.insert(self.taskItemList, item)
        end
        obj.State2_btn.onClick:RemoveAllListeners()
        obj.State2_btn.onClick:AddListener(function ()
            self:SubmitTask(taskList[i])
        end)
        self.taskMap[taskList[i]] = obj
    end
    self.BarText_txt.text = string.format("%s/%s", finishCount, #taskList)
    self.BarImg_img.fillAmount = finishCount / #taskList
    if finishCount == #taskList then
        self.canBreak = true
    else
        self.canBreak = false
    end
end

function WorldLevelPanel:ChangeTask(taskId)
    local obj = self.taskMap[taskId]
    local curValue = mod.SystemTaskCtrl:GetTaskProgress(taskId)
    local targetValue = SystemTaskConfig.GetTaskTarget(taskId)
    curValue = curValue < targetValue and curValue or targetValue
    obj.CurValue_txt.text = curValue
end

function WorldLevelPanel:ShowLevel()
    TableUtils.ClearTable(self.levelMap)
    self.levelCount = math.min(self.maxLevel, WorldLevelConfig.GetMaxLev())
    local showCount = math.min(self.levelCount + 4, WorldLevelConfig.GetMaxLev() + 2)
    for i = -1, showCount, 1 do
        local obj = self:PopUITmpObject(ObjType.Level, self.LevelContent_rect)
        self.levelMap[i + 1] = obj
        local showLev = i
        if showLev < 1 or showLev > self.levelCount + 2 or showLev > WorldLevelConfig.GetMaxLev() then
            obj.Content:SetActive(false)
        else
            obj.Content:SetActive(true)
            obj.Level_txt.text = showLev
    
            obj.Content_btn.onClick:RemoveAllListeners()
            obj.Content_btn.onClick:AddListener(function ()
                self:OnClick_SelectLevel(showLev)
            end)
            if showLev > self.maxLevel + 1 then
                UtilsUI.SetTextColor(obj.Level_txt, "#b8bbbe")
            else
                UtilsUI.SetTextColor(obj.Level_txt, "#FFDFB1")
            end

            if self.curLevel == showLev then
                obj.Cur:SetActive(true)
                obj.Old:SetActive(false)
            elseif showLev > self.curLevel and showLev <= self.maxLevel then
                obj.Cur:SetActive(false)
                obj.Old:SetActive(true)
            elseif showLev < self.curLevel then
                obj.Cur:SetActive(false)
                obj.Old:SetActive(true)
            else
                obj.Cur:SetActive(false)
                obj.Old:SetActive(false)
            end
            if self.selectLev == showLev then
                obj.Level_txt.fontSize = 90
            else
                obj.Level_txt.fontSize = 46
            end
        end
    end
end

function WorldLevelPanel:SubmitTask(id)
    CurtainManager.Instance:EnterWait()
    LuaTimerManager.Instance:AddTimer(1, 0.45, function ()
        CurtainManager.Instance:ExitWait()
    end)
    mod.SystemTaskCtrl:SystemTaskCommit(id)
end

function WorldLevelPanel:ChangeButtonState(state)
    self.buttonState = state
    self.Submit:SetActive(state ~= ButtonState.Cur and state ~= ButtonState.Achieved)
    self.SubmitRedRoot:SetActive(state == ButtonState.Break)

    if state == ButtonState.Break then
        self.SubmitText_txt.text = TI18N("突破")
    elseif state == ButtonState.Degrade then
        self.SubmitText_txt.text = TI18N("降低世界等级")
    elseif state == ButtonState.Upgrade then
        self.SubmitText_txt.text = TI18N("提升世界等级")
    elseif state == ButtonState.Achieved then
        self.NotOnClick_txt.text = TI18N("已领取")
    elseif state == ButtonState.Cur then
        self.NotOnClick_txt.text = TI18N("当前")
    end
end

function WorldLevelPanel:OnClick_Submit()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end

    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end

    CurtainManager.Instance:EnterWait()
    LuaTimerManager.Instance:AddTimer(1, 0.45, function ()
        CurtainManager.Instance:ExitWait()
    end)

    if self.buttonState == ButtonState.Upgrade then
        PanelManager.Instance:OpenPanel(WorldLevelChangePanel,{oldLev = self.curLevel, newLev = self.curLevel + 1})
    elseif self.buttonState == ButtonState.Degrade then
        PanelManager.Instance:OpenPanel(WorldLevelChangePanel,{oldLev = self.curLevel, newLev = self.curLevel - 1})
    elseif self.buttonState == ButtonState.Break then
        if self.canBreak then
            mod.WorldLevelCtrl:WorldLevelUpgrade()
        else
            MsgBoxManager.Instance:ShowTips(TI18N("完成全部任务才可以提升世界等级"))
        end
    end
end

function WorldLevelPanel:OnClick_OpenDesc()
    BehaviorFunctions.ShowGuideImageTips(WorldLevelConfig.GetTeachId())
end

function WorldLevelPanel:OnLevelSliderDragEnd()
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, function()
        if not self.active then
            return
        end
        local content = self.LevelContent_rect
        local anchorPosition = content.anchoredPosition

        local posX = math.abs(anchorPosition.x / 80) + 1

        local index = math.floor(posX + 0.5)
        local targetPosX = (index - 1) * -80
        content:DOAnchorPosX(targetPosX, 0.1)
        if index ~= self.selectLev then
            self:SelectLevel(index, true)
        else
            local obj = self.levelMap[index + 1]
            obj.Level_txt.fontSize = 90
        end
    end)
end

function WorldLevelPanel:ShowCloseNode()
    self.WorldLevelPanel_Exit:SetActive(true)
end

function WorldLevelPanel:Close_CallBack()
    --self:Hide()
end