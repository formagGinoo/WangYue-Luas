AssetCenterGuidePanel = BaseClass("AssetCenterGuidePanel", BasePanel)

local ItemHeight = 114

function AssetCenterGuidePanel:__init()  
    self:SetAsset("Prefabs/UI/AttendantCenter/MainUI/AssetCenterGuidePanel.prefab")
    self.partnerInfoObjList = {}
    self.guideTask = nil
end

function AssetCenterGuidePanel:__BindListener()
end

function AssetCenterGuidePanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.SystemTaskChange, self:ToFunc("SystemTaskChange"))
    EventMgr.Instance:AddListener(EventName.SystemTaskFinish, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:AddListener(EventName.SystemTaskFinished, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:AddListener(EventName.SystemTaskAccept, self:ToFunc("SystemTaskChange"))

    EventMgr.Instance:AddListener(EventName.OnSetPartnerWorkInAsset, self:ToFunc("RefreshInfo"))
    EventMgr.Instance:AddListener(EventName.OnSetPartnerWorkInDevice, self:ToFunc("RefreshInfo"))
    EventMgr.Instance:AddListener(EventName.UpdateDecorationNumInAsset, self:ToFunc("RefreshInfo"))

    EventMgr.Instance:AddListener(EventName.GuideTaskChange, self:ToFunc("SetGuideMainTask"))
    --EventMgr.Instance:AddListener(EventName.MulTaskChange, self:ToFunc("SetGuideMainTask"))

    EventMgr.Instance:AddListener(EventName.AssetLevelUp, self:ToFunc("RefreshInfo"))
    EventMgr.Instance:AddListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("DecorationInfoUpdate"))
end

function AssetCenterGuidePanel:__Create()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function AssetCenterGuidePanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.SystemTaskChange, self:ToFunc("SystemTaskChange"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskFinish, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskFinished, self:ToFunc("SystemTaskFinish"))
    EventMgr.Instance:RemoveListener(EventName.SystemTaskAccept, self:ToFunc("SystemTaskChange"))

    EventMgr.Instance:RemoveListener(EventName.OnSetPartnerWorkInAsset, self:ToFunc("RefreshInfo"))
    EventMgr.Instance:RemoveListener(EventName.OnSetPartnerWorkInDevice, self:ToFunc("RefreshInfo"))
    EventMgr.Instance:RemoveListener(EventName.UpdateDecorationNumInAsset, self:ToFunc("RefreshInfo"))

    EventMgr.Instance:RemoveListener(EventName.GuideTaskChange, self:ToFunc("SetGuideMainTask"))
    --EventMgr.Instance:RemoveListener(EventName.MulTaskChange, self:ToFunc("SetGuideMainTask"))

    EventMgr.Instance:RemoveListener(EventName.AssetLevelUp, self:ToFunc("RefreshTaskGuide"))
    EventMgr.Instance:RemoveListener(EventName.AssetDecorationInfoUpdate, self:ToFunc("DecorationInfoUpdate"))
end

function AssetCenterGuidePanel:__Hide()
end

function AssetCenterGuidePanel:__Show()
    self.assetId = self.args.assetId
    self.assetInfo = mod.AssetPurchaseCtrl:GetExistingAssetInfoById(self.assetId)
    
end

function AssetCenterGuidePanel:__ShowComplete()
    self:RefreshInfo()

    -- 每次进资产界面判断要不要进引导
    if not mod.GuideCtrl:CheckGuideFinish(1039) then
        Fight.Instance.clientFight.guideManager:PlayGuideGroup(1039, 1, true, true)
    end
end

function AssetCenterGuidePanel:RefreshPartnerListInfo()
    self.partnerList = TableUtils.CopyTable(self.assetInfo.partner_list)
    table.sort(self.partnerList, function(a, b)
        local astate = mod.PartnerBagCtrl:GetAssetPartnerState(a)
        local bstate = mod.PartnerBagCtrl:GetAssetPartnerState(b)
        if astate ~= bstate then
            return astate > bstate
        end
        local aInfo = mod.BagCtrl:GetPartnerData(a)
        local bInfo = mod.BagCtrl:GetPartnerData(b)
        if aInfo.work_info.work_decoration_id == bInfo.work_info.work_decoration_id then
            return false
        else
            return aInfo.work_info.work_decoration_id ~= 0 and bInfo.work_info.work_decoration_id == 0 
        end
    end)
end

function AssetCenterGuidePanel:RefreshInfo()
    local maxCount = AssetPurchaseConfig.GetAssetStaffNum(self.assetId,self.assetInfo.level)
    self:RefreshPartnerListInfo()
    self.PartnerCount_txt.text = string.format("员工数量 %d/%d",#self.partnerList,maxCount)

    local restcount,restMaxcount = mod.DecorationCtrl:GetDecorationNumAndLimitCount(1001004)
    self.RestStationInfo_txt.text = string.format("休息站 %d/%d",restcount,restMaxcount)

    if not self.partnerList or #self.partnerList == 0 then
        UtilsUI.SetActive(self.ListPart,false)
    else
        UtilsUI.SetActive(self.ListPart,true)
        self:RefreshPartnerList()
    end
    
    self:RefreshTaskGuide()
    self:ForceRebuildLayout()
end

function AssetCenterGuidePanel:RefreshPartnerList()
    local listNum = #self.partnerList 
    if listNum == 1 then
        UnityUtils.SetSizeDelata(self.ListPart_rect, self.ListPart_rect.rect.width, ItemHeight)
    else
        UnityUtils.SetSizeDelata(self.ListPart_rect, self.ListPart_rect.rect.width, ItemHeight*2)
    end
    self.PartnerList_recyceList:SetLuaCallBack(self:ToFunc("RefreshPartnerCell"))
    self.PartnerList_recyceList:SetCellNum(listNum)
end

function AssetCenterGuidePanel:RefreshPartnerCell(index, go)
    if not go then
        return 
    end

    local partnerInfoItem
    local partnerInfoObj
    if self.partnerInfoObjList[index] then
        partnerInfoItem = self.partnerInfoObjList[index].partnerInfoItem
    else
        partnerInfoItem = PoolManager.Instance:Pop(PoolType.class, "PartnerStateItem")
        if not partnerInfoItem then
            partnerInfoItem = PartnerStateItem.New()
        end
        
        self.partnerInfoObjList[index] = {}
        self.partnerInfoObjList[index].partnerInfoItem = partnerInfoItem
    end
    local uiContainer = {}
    uiContainer = UtilsUI.GetContainerObject(go.transform, uiContainer)
    partnerInfoObj = uiContainer.PartnerStateItem
    
    partnerInfoItem:InitItem(partnerInfoObj,self.partnerList[index],true)
end

function AssetCenterGuidePanel:RefreshTaskGuide()
    self:SetGuideMainTask()
    local taskId = mod.AssetTaskCtrl:GetGuideTask()
    if taskId == nil then
        UtilsUI.SetActive(self.TaskPart,false)
        return
    end
    UtilsUI.SetActive(self.TaskPart,true)
    self.guideTask = taskId

    local curValue = mod.SystemTaskCtrl:GetTaskProgress(taskId)
    local targetValue = ConditionManager.GetConditionTarget(taskId)
    local taskInfo = AssetTaskConfig.GetAssetTaskInfoById(taskId)
    self.TaskDesc_txt.text =  string.format("%s (%d/%d)",taskInfo.desc, curValue, targetValue) 
end

function AssetCenterGuidePanel:DecorationInfoUpdate(assetId,decorationId)
    if assetId == self.assetId then
        self:RefreshInfo()
    end
end

function AssetCenterGuidePanel:SystemTaskChange(data)
    if self.guideTask and self.guideTask == data.id then
        self:RefreshTaskGuide()
    end
end

function AssetCenterGuidePanel:ForceRebuildLayout()
    LuaTimerManager.Instance:AddTimer(1,0.1,function()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.ListPart.transform.parent)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.LeftPart.transform)
    end)
end

function AssetCenterGuidePanel:SystemTaskFinish(data)
    local id = data
    if type(data) == "table" then
        id = data.id
    end
    if self.guideTask and self.guideTask == id then
        self:RefreshTaskGuide()
    end
end

function AssetCenterGuidePanel:SetGuideMainTask()
    local guideMainTask = Fight.Instance.taskManager:GetGuideTask()
    local guideTaskConfig = mod.TaskCtrl:GetGuideTaskConfig()
    if not guideMainTask then
        UtilsUI.SetActive(self.TipPart, false)
        --LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
            LayoutRebuilder.ForceRebuildLayoutImmediate(self.TipPart.transform)
        --end)
        return
    end
	UtilsUI.SetActive(self.TipPart, true)
	if guideMainTask and next(guideMainTask) then
		self.TaskTip_txt.text = mod.TaskCtrl:GetGuideTaskDesc()
        self.SubTipsTemp_txt.text = guideTaskConfig.task_goal
        if guideTaskConfig.task_goal and #guideTaskConfig.task_goal > 0 then
            UtilsUI.SetActive(self.SubTipsTemp, true)
        end 
		local taskType = mod.TaskCtrl:GetTaskType(guideMainTask.taskId)
		if taskType then
			local icon = AssetConfig.GetTaskTypeIcon(taskType)
			SingleIconLoader.Load(self.TaskIcon, icon)
		end
	end

    local taskConfig = guideMainTask.taskConfig
    local mapId = Fight.Instance:GetFightMap()

    if taskConfig.map_id ~= mapId then
        UtilsUI.SetActive(self.TaskTipDis, true)
        local mapName = Config.DataMap.data_map[taskConfig.map_id].name
        self.TaskTipDis_txt.text = string.format("请前往[%s]", mapName)
    else
        UtilsUI.SetActive(self.TaskTipDis, false)
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.SubTipsContent.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.TipPart.transform)
	-- LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
		
	-- end)
end