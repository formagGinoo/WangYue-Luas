ActivityTaskItem = BaseClass("ActivityTaskItem")
local MissionProcessStr = TI18N("%d/%d")

local colorVal = {
    [1] = Color(77/255, 82/255, 87/255, 1),
    [2] = Color(203/255, 90/255, 90/255, 1),
}

function ActivityTaskItem:__init()

end

function ActivityTaskItem:Destory()
    for k, data in pairs(self.awardItemMap) do
		PoolManager.Instance:Push(PoolType.class, "CommonItem", data.awardItem)
        GameObject.Destroy(data.obj)
	end
	self.awardItemMap = {}
end
function ActivityTaskItem:OnReset()
    
end

function ActivityTaskItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
	self.awardItemMap = {}
    self.parent = parent
    self.taskId = data.taskId
    self.index = data.index
    self.taskConfig = ActivityConfig.GetTaskConfig(self.taskId)
    self.item:SetActive(true)
    self:UpdateView()
end

function ActivityTaskItem:UpdateView()

	-- 完成状态 1:未完成 2:完成未领取 3:已领取
	local progress, maxProgress = DailyActivityConfig.GetTaskProgress(self.taskId)

    
    local config = SystemTaskConfig.GetTask(self.taskId)

    local fromStatistic = ConditionManager.GetConditionSearchFromStatistic(config.condition)


	local finishType = progress == -1 and 3 or 1
	if progress >= maxProgress then
		progress = maxProgress
		finishType = 2
	end
    local isCompleted = finishType == 3

    if fromStatistic then
         local conditionConfig = Config.DataCondition.data_condition[config.condition]
        progress = math.min(maxProgress,mod.RoleCtrl:GetItemExpendCount(tonumber(conditionConfig.arg1))) 
    end
    progress = isCompleted and maxProgress or progress 
    
	-- 更新进度
	self.ProgressTxt_txt.text = string.format(MissionProcessStr, progress, maxProgress)
	self.ProgressFill_img.fillAmount = progress / maxProgress

    local isLock = false
    local systemOpenConfig = nil
    if self.taskConfig.system_id ~= 0 then
        systemOpenConfig = Config.DataSystemOpen.data_system_open[self.taskConfig.system_id]
        isLock = not Fight.Instance.conditionManager:CheckConditionByConfig(systemOpenConfig.condition)
    end
    
    self.Content_txt.text = TI18N(self.taskConfig.desc)

    -- 道具
    self:UpdateDropItemView()
    
    -- 锁定
	UnityUtils.SetActive(self.LockDes, isLock)
    if isLock then
		if systemOpenConfig then
			local simDes = Config.DataCondition.data_condition[systemOpenConfig.condition].simple_desc
			local description = Config.DataCondition.data_condition[systemOpenConfig.condition].description
			local systemName = systemOpenConfig.name
			self.LockContent1_txt.text = TI18N(systemName)
			self.LockContent2_txt.text = TI18N(simDes)
			SingleIconLoader.Load(self.LockIcon, systemOpenConfig.notice_icon2)

            UnityUtils.SetActive(self.GetButton, false)
            UnityUtils.SetActive(self.GotoButton, false)
            UnityUtils.SetActive(self.Running, false)
            UnityUtils.SetActive(self.Completed, false)
            
            if self.taskConfig.system_id then
                local func = function()
                    PanelManager.Instance:OpenPanel(SystemOpenPanel,{showSystem =description, systemId = self.taskConfig.system_id})   
                end
                
                self.LockButton_btn.onClick:RemoveAllListeners()
                self.LockButton_btn.onClick:AddListener(func)
            end
        end
    else
        -- 提交按钮
        local showReceiveBtn =  finishType == 2
        UnityUtils.SetActive(self.GetButton, showReceiveBtn)
        if showReceiveBtn then
            local func = function()
                self.parent:SystemTaskCommit(self.taskId)
            end
            self.GetButton_btn.onClick:RemoveAllListeners()
            self.GetButton_btn.onClick:AddListener(func)
        end
        
        -- 跳转按钮
        local jumpId = self.taskConfig.jump_id
        local showJumpBtn =  finishType == 1 and jumpId ~= 0
        UnityUtils.SetActive(self.GotoButton, showJumpBtn)
        if showJumpBtn then
            local func = function()
                --print("System Jump:"..jumpId)
                JumpToConfig.DoJump(jumpId)
            end

            self.GotoButton_btn.onClick:RemoveAllListeners()
            self.GotoButton_btn.onClick:AddListener(func)
        end
        -- 没有按钮，任务中
        local showInProcessText = finishType == 1 and jumpId == 0
        UnityUtils.SetActive(self.Running, showInProcessText)
        self.Running_txt.text = TI18N("进行中")


        UnityUtils.SetActive(self.Completed, isCompleted)
        self.CompleteTxt_txt.text = TI18N("已完成")
    end

end


function ActivityTaskItem:UpdateDropItemView()
    local rewardList = ItemConfig.GetReward2(self.taskConfig.reward)
    for _, reward in ipairs(rewardList) do
        self:UpdateRewardInfo(reward)
    end
end

function ActivityTaskItem:UpdateRewardInfo(reward)
    local obj = GameObject.Instantiate(self.CommonItem)
    obj.transform:SetParent(self.DropContent.transform)
    
    local awardItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
    if not awardItem then
        awardItem = CommonItem.New()
    end 

    local itemId = reward[1]
    local num = reward[2]
    local itemInfo = {template_id = itemId, count = num or 0, scale = 0.55}
    awardItem:InitItem(obj, itemInfo, true)
    table.insert(self.awardItemMap, {awardItem = awardItem, obj = obj})
end

function ActivityTaskItem:GotoTask()
    if not mod.ResDuplicateCtrl:CheckFightCost(self.costVal) then
        return
    end
    local cfg = self.cfg
    local mapId = cfg.trans_map_id
    local MapPos = BehaviorFunctions.GetTerrainPositionP(cfg.trans_position[2], cfg.trans_map_id, cfg.trans_position[1])
    WindowManager.Instance:CloseWindow(AdvMainWindowV2)
    mod.WorldMapCtrl:CacheTpRotation(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW)
    BehaviorFunctions.Transport(mapId, MapPos.x, MapPos.y, MapPos.z)
    -- local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    -- player.rotateComponent:SetRotation(Quat.New(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW))
end

function ActivityTaskItem:GetTask()
    if not mod.ResDuplicateCtrl:CheckFightCost(self.costVal) then
        return
    end
    local cfg = self.cfg
    local mapId = cfg.trans_map_id
    local MapPos = BehaviorFunctions.GetTerrainPositionP(cfg.trans_position[2], cfg.trans_map_id, cfg.trans_position[1])
    WindowManager.Instance:CloseWindow(AdvMainWindowV2)
    mod.WorldMapCtrl:CacheTpRotation(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW)
    BehaviorFunctions.Transport(mapId, MapPos.x, MapPos.y, MapPos.z)
    -- local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    -- player.rotateComponent:SetRotation(Quat.New(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW))
end
