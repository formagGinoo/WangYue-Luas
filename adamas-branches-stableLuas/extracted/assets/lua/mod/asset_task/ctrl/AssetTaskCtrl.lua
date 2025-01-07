AssetTaskCtrl = BaseClass("AssetTaskCtrl",Controller)

function AssetTaskCtrl:__init()
    self.taskInfo = nil
    self.taskIdList = nil
    self.taskInfoList = nil
end

function AssetTaskCtrl:InitTaskInfo(assetId)
    self.assetInfo = mod.AssetPurchaseCtrl:GetExistingAssetInfoById(assetId)
    self.taskInfo = AssetTaskConfig.GetAssetTaskConfig(self.assetInfo.asset_id)
    self.taskIdList = {} 
    for i, v in ipairs(self.taskInfo) do
        self.taskIdList[v.level_id] = {}
        for _,v1 in pairs (AssetTaskConfig.GetAssetTaskListByGroup(v.system_group)) do
            table.insert(self.taskIdList[v.level_id], v1)
        end
        table.sort(self.taskIdList[v.level_id], function(a, b)
            return AssetTaskConfig.GetAssetTaskInfoById(a).order > AssetTaskConfig.GetAssetTaskInfoById(b).order
        end)
    end

    self:GetTaskInfoList(self.assetInfo.level)
end

function AssetTaskCtrl:GetTaskIdList(level)
    return self.taskIdList[level]
end

function AssetTaskCtrl:GetTaskInfoList(level)
    self.taskInfoList = {}
    for k, v in pairs(self.taskIdList[level]) do
        table.insert(self.taskInfoList,AssetTaskConfig.GetAssetTaskInfoById(v))
    end
    -- table.sort(self.taskInfoList,function(a,b)
    --     return a.order > b.order
    -- end)

    return self.taskInfoList
end

function AssetTaskCtrl:GetGuideTask()
    for i, v in pairs(self.taskIdList[self.assetInfo.level]) do

        local curValue = mod.SystemTaskCtrl:GetTaskProgress(v)
        local targetValue = ConditionManager.GetConditionTarget(v)

        if curValue ~= -1 and curValue < targetValue then
            return v
        end
    end
end

function AssetTaskCtrl:AssetLevelUp(asset_id)
    CurtainManager.Instance:EnterWait()
    self.waitServer = true
    local id,cmd = mod.AssetTaskFacade:SendMsg("asset_center_asset_level_up", {asset_id = asset_id})
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function(ERRORCODE)
        if self.waitServer then
            CurtainManager.Instance:ExitWait()
            self.waitServer = nil
        end
    end)
end

function AssetTaskCtrl:CheckAssetTaskRedPoint()
    if self.taskInfoList and next(self.taskInfoList) then
        local canLevelUp = true
        for k, v in pairs(self.taskInfoList) do
            local curValue = mod.SystemTaskCtrl:GetTaskProgress(v.condition)
            local targetValue = ConditionManager.GetConditionTarget(v.condition)
            if curValue ~= -1 then
                canLevelUp = false
            end
            if curValue == targetValue then
                return true
            end
        end
        return canLevelUp
    else        
        return false
    end
    
end