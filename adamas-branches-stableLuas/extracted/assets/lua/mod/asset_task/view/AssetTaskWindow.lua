AssetTaskWindow = BaseClass("AssetTaskWindow", BaseWindow)

function AssetTaskWindow:__init()
	self:SetAsset("Prefabs/UI/AssetTask/AssetTaskWindow.prefab")
    self.specicalDescObj = {}
    self.taskInfoObjList = {}
    self.taskItemMap = {}
    self.awardItemMap = {}
end

function AssetTaskWindow:__BindListener()
    self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClickClose"))
    self.LastLevelBtn_btn.onClick:AddListener(self:ToFunc("ShowLastLevel"))
    self.NextLevelBtn_btn.onClick:AddListener(self:ToFunc("ShowNextLevel"))
    self.LevelUpBtn_btn.onClick:AddListener(self:ToFunc("OnClickLevelUp"))

    EventMgr.Instance:AddListener(EventName.SystemTaskChange, self:ToFunc("SystemTaskChange"))
    EventMgr.Instance:AddListener(EventName.SystemTaskFinish, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:AddListener(EventName.SystemTaskFinished, self:ToFunc("SystemTaskFinished"))
    EventMgr.Instance:AddListener(EventName.SystemTaskAccept, self:ToFunc("SystemTaskChange"))

    EventMgr.Instance:AddListener(EventName.AssetLevelUp, self:ToFunc("AfterAssetLevelUp"))
end

function AssetTaskWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AssetTaskWindow:__Create()
    
end

function AssetTaskWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.SystemTaskChange, self:ToFunc("SystemTaskChange"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskFinish, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskFinished, self:ToFunc("SystemTaskFinished"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskAccept, self:ToFunc("SystemTaskChange"))
    
    EventMgr.Instance:RemoveListener(EventName.AssetLevelUp, self:ToFunc("AfterAssetLevelUp"))

    for k, v in pairs(self.taskInfoObjList) do
        PoolManager.Instance:Push(PoolType.class, "AssetTaskItem",v.taskInfoItem)
    end
    for k, v in pairs(self.awardItemMap) do
        PoolManager.Instance:Push(PoolType.class, "CommonItem",v.awardItem)
    end
end

function AssetTaskWindow:__Show()
    self:SetBlurBack()
    self:InitInfo()
end

function AssetTaskWindow:__ShowComplete()
    
    self:RefreshShowInfo()
end

function AssetTaskWindow:InitInfo()
    self.assetInfo = mod.AssetPurchaseCtrl:GetCurAssetInfo()
    self.assetLv = self.assetInfo.level
    self.taskIdList = mod.AssetTaskCtrl:GetTaskIdList(self.assetLv)
    self.taskInfoList = mod.AssetTaskCtrl:GetTaskInfoList(self.assetLv)
    
    self.showLv = self.assetLv
    self.lvConfig = AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv)
    self:CheckCanLevelUp()
end

function AssetTaskWindow:CheckCanLevelUp()
    self.canLevelUp = true
    for i, v in pairs(self.taskIdList) do
        if mod.SystemTaskCtrl:GetTaskProgress(v) ~= -1 then
            self.canLevelUp = false
            break
        end
    end
    self:UpdataLevelUpInfo()
end

function AssetTaskWindow:AfterAssetLevelUp()
    self:InitInfo()
    self:RefreshShowInfo()
end

function AssetTaskWindow:RefreshShowInfo()
    self.taskIdList = mod.AssetTaskCtrl:GetTaskIdList(self.showLv)
    self.taskInfoList = mod.AssetTaskCtrl:GetTaskInfoList(self.showLv)
    self:RefreshTaskList()
    self:InitLeftInfo()
end

function AssetTaskWindow:InitLeftInfo()
    self:UpdataLeftShow()
end

function AssetTaskWindow:UpdataLeftShow()
    self.Lv_txt.text = self.showLv
    self.showTaskInfo = AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv)
    if self.showLv == self.assetLv then
        UtilsUI.SetActive(self.CurLevel,true)
    else
        UtilsUI.SetActive(self.CurLevel,false)
    end

    for i, v in ipairs(self.showTaskInfo.super_reward_des) do
        local obj = self.specicalDescObj[i]
        if obj == nil then
            obj = self:PopUITmpObject("SpecialDesc", self.SpecialReward_rect)
            self.specicalDescObj[i] = obj
        end
        obj.SpecialDesc_txt.text = v
    end
    LuaTimerManager.Instance:AddTimer(1,0.1,function()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.SpecialReward.transform)
    end)

    if AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv - 1) then
        UtilsUI.SetActive(self.LastLevelBtn,true)
    else
        UtilsUI.SetActive(self.LastLevelBtn,false)
    end

    if self.showLv + 1 <= self.assetLv and AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv + 1) then
        UtilsUI.SetActive(self.NextLevelBtn,true)
    else
        UtilsUI.SetActive(self.NextLevelBtn,false)
    end

    self:RefreshReward()
    self:UpdataLevelUpInfo()
end

function AssetTaskWindow:RefreshReward()
    local rewardList = ItemConfig.GetReward2(self.lvConfig.reward)
    for i, reward in ipairs(rewardList) do
        local obj
        local awardItem
        if self.awardItemMap[i] == nil then
            obj = GameObject.Instantiate(self.LvRewardItem)
            obj.transform:SetParent(self.LvRewardContent.transform)
            
            awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
            if not awardItem then
                awardItem = CommonItem.New()
            end 
        else
            obj = self.awardItemMap[i].obj
            awardItem = self.awardItemMap[i].awardItem
        end
        local itemId = reward[1]
        local num = reward[2]
        local itemInfo = {template_id = itemId, count = num or 0, scale = 1}
        awardItem:InitItem(obj, itemInfo, true)
        self.awardItemMap[i] = {awardItem = awardItem, obj = obj}
    end

    for i = #rewardList + 1, #self.awardItemMap, 1 do
		UtilsUI.SetActive(self.awardItemMap[i].obj, false)
	end
end

function AssetTaskWindow:UpdataLevelUpInfo()
    UtilsUI.SetActive(self.Received,self.showLv < self.assetLv)
    UtilsUI.SetActive(self.UnComplete,self.showLv > self.assetLv or (self.showLv == self.assetLv and not self.canLevelUp))
    UtilsUI.SetActive(self.LevelUp,self.showLv == self.assetLv and self.canLevelUp)
end

function AssetTaskWindow:RefreshTaskList()
    local listNum = #self.taskInfoList
    self.TaskList_recyceList:SetLuaCallBack(self:ToFunc("RefreshTaskCell"))
    self.TaskList_recyceList:SetCellNum(listNum)
end

function AssetTaskWindow:RefreshTaskCell(index,go)
    if not go then
        return
    end

    local taskInfoItem
    local taskInfoObj
    if self.taskInfoObjList[index] then
        taskInfoItem = self.taskInfoObjList[index].taskInfoItem
        taskInfoItem:OnReset()
    else
        taskInfoItem = PoolManager.Instance:Pop(PoolType.class, "AssetTaskItem")
        if not taskInfoItem then
            taskInfoItem = AssetTaskItem.New()
        end
        self.taskInfoObjList[index] = {}
        self.taskInfoObjList[index].taskInfoItem = taskInfoItem
    end

    local uiContainer = {}
    uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
    taskInfoObj = uiContainer.AssetTaskItem

    self.taskItemMap[self.taskInfoList[index].id] = taskInfoItem
    taskInfoItem:InitItem(taskInfoObj,self.taskInfoList[index],true)
end

function AssetTaskWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function AssetTaskWindow:ShowLastLevel()
    if AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv - 1) then
        self.showLv = self.showLv - 1
        self.lvConfig = AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv)
        self:RefreshShowInfo()
    end
end

function AssetTaskWindow:ShowNextLevel()
    if self.showLv + 1 <= self.assetLv and AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv + 1) then
        self.showLv = self.showLv + 1
        self.lvConfig = AssetTaskConfig.GetAssetTaskConfigByLevel(self.assetInfo.asset_id,self.showLv)
        self:RefreshShowInfo()
    end
end

function AssetTaskWindow:OnClickLevelUp()
    mod.AssetTaskCtrl:AssetLevelUp(self.assetInfo.asset_id)
end

function AssetTaskWindow:SystemTaskChange(data)
    if self.taskItemMap[data.id] then
        self.taskItemMap[data.id]:TaskUpdata()
    end
end

function AssetTaskWindow:SystemTaskFinish(data)
    local id = data.id
    if self.taskItemMap[id] then
        self.taskItemMap[id]:TaskUpdata()
    end
end

function AssetTaskWindow:SystemTaskFinished(id)
    if self.taskItemMap[id] then
        self.taskItemMap[id]:TaskUpdata()

        self:CheckCanLevelUp()
    end
end

function AssetTaskWindow:__Hide()
	
end