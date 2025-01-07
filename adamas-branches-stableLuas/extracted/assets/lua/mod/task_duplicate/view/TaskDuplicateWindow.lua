TaskDuplicateWindow = BaseClass("TaskDuplicateWindow", BaseWindow)

local _inster = table.insert

function TaskDuplicateWindow:__init()
    self:SetAsset("Prefabs/UI/TaskDuplicate/TaskDuplicateWindow.prefab")
end

function TaskDuplicateWindow:__CacheObject()
    self.elementsContainer = UtilsUI.GetContainerObject(self.elements.transform)
end

function TaskDuplicateWindow:__ShowComplete()

end

function TaskDuplicateWindow:__BindListener()

    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("OnClickClose"))
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("OnClickClose"))
    self.GoFight_btn.onClick:AddListener(self:ToFunc("GoDuplicate"))
end

function TaskDuplicateWindow:OnClickClose()
    WindowManager.Instance:CloseWindow(self)
end

function TaskDuplicateWindow:__Show()
    self.resDupId = self.args.resDupId --副本systemDuplicateId
    self.dropItemMap = {}--通关奖励
    self.monsterItemMap = {} --可能遭遇的boss
    --获取当前对应的任务副本信息
    self:UpdateDuplicateInfo()
    --更新左侧
    self:UpdateLeftInfo()
    --更新中间的UI图
    self:UpdateCenterInfo()
    --更新右侧
    self:UpdateRightInfo()
end

function TaskDuplicateWindow:__Hide()
    
end

function TaskDuplicateWindow:__delete()
    self:ResetDupInfo()
end

function TaskDuplicateWindow:UpdateDuplicateInfo()
    if not self.taskDuplicateConfig then --任务副本配置
        self.taskDuplicateConfig = TaskDuplicateConfig.GetTaskDuplicateConfigById(self.resDupId)
    end
    if not self.systemDuplicateConfig then --系统副本配置
        self.systemDuplicateConfig = TaskDuplicateConfig.GetSystemDuplicateConfigById(self.taskDuplicateConfig.system_duplicate_id)
    end
end

function TaskDuplicateWindow:UpdateLeftInfo()
    self.leftTitleText_txt.text = self.taskDuplicateConfig.name
end

function TaskDuplicateWindow:UpdateCenterInfo()
    UtilsUI.SetActive(self.Centerui, false)
    --这里是0则显示ui
    if self.taskDuplicateConfig and self.taskDuplicateConfig.ui_type == TaskDuplicateConfig.UITYPE.UI then
        if self.taskDuplicateConfig.icon ~= "" then
            --加载图标 cfg.icon
            local callback = function()
                UtilsUI.SetActive(self.Centerui, true)
            end
            SingleIconLoader.Load(self.Centerui, self.taskDuplicateConfig.icon, callback)
        end
    end
end

function TaskDuplicateWindow:UpdateRightInfo()
    --更新顶部
    self:UpdateRightTop()
    --更新怪物图标
    self:UpdateMonsterItem()
    --更新通关奖励图标
    self:UpdateDropItem()
end

function TaskDuplicateWindow:UpdateRightTop()
    self:UpdateTopTitle()
    self:UpdateShowElement()
    self:UpdateChallengeInfo()
    self:UpdateRecommendInfo()
end

function TaskDuplicateWindow:UpdateTopTitle()
    if self.taskDuplicateConfig then
        self.duplicateName_txt.text = self.taskDuplicateConfig.name
    end
end

function TaskDuplicateWindow:UpdateShowElement()
    --获取五行配置
    if self.systemDuplicateConfig then
        for i, id in ipairs(self.systemDuplicateConfig.show_element_id) do
			if id ~= 0 then 
                local cfg = TaskDuplicateConfig.GetElementConfigById(id)
                --加载图标 cfg.icon
                local callback = function()
                    self.elementsContainer['icon'..i].transform:SetActive(true)
                end
                SingleIconLoader.Load(self.elementsContainer['icon'..i], cfg.icon, callback)
            end
        end
    end
end

function TaskDuplicateWindow:UpdateChallengeInfo()
    if self.taskDuplicateConfig.challenge_des == "" then --如果没配置挑战条件
        UtilsUI.SetActive(self.challengeTitleText, false)
        return 
    end
    
    UtilsUI.SetActive(self.challengeTitleText, true)
    self.challengeText_txt.text = self.taskDuplicateConfig.challenge_des
end

function TaskDuplicateWindow:UpdateRecommendInfo()
    if self.systemDuplicateConfig then
        self.recommendText_txt.text = TI18N("推荐队伍等级")..self.systemDuplicateConfig.recommend_level
    end
end

function TaskDuplicateWindow:UpdateMonsterItem()
    if self.systemDuplicateConfig then
        for index, id in ipairs(self.systemDuplicateConfig.show_monster_id) do
            local showMonsterCfg = TaskDuplicateConfig.GetMonsterConfig(id)
            if showMonsterCfg then
                local data = {icon = showMonsterCfg.icon, level = showMonsterCfg.level}
                self:UpdateMonsterInfo(data)
            end
        end
    end
end

function TaskDuplicateWindow:UpdateMonsterInfo(data)
    local obj = GameObject.Instantiate(self.MonsterItem)
    obj.transform:SetParent(self.MonsterContent.transform)
    UnityUtils.SetLocalScale(obj.transform, 1, 1, 1)
    local item = DuplicateMonsterItem.New()
    local itemData = {obj = obj, data = data}
    item:SetData(self, itemData)
    
    _inster(self.monsterItemMap, {item = item, obj = obj})
end

function TaskDuplicateWindow:UpdateDropItem()
    if self.systemDuplicateConfig and self.systemDuplicateConfig.show_reward ~= 0 then
        local rewardList = ItemConfig.GetReward2(self.systemDuplicateConfig.show_reward)
        for _, reward in ipairs(rewardList) do
            self:UpdateRewardInfo(reward)
        end
    end
end

function TaskDuplicateWindow:UpdateRewardInfo(reward)
    local obj = GameObject.Instantiate(self.DropItem)
    obj.transform:SetParent(self.DropContent.transform)
    UnityUtils.SetLocalScale(obj.transform, 0.8, 0.8, 0.8)
    
    local itemId = reward[1]
    local num = reward[2]
    local itemInfo = {template_id = itemId, count = num or 0}
    local awardItem = ItemManager.Instance:GetItem(obj, itemInfo)
    UtilsUI.SetActive(obj, true)
    _inster(self.dropItemMap, {awardItem = awardItem, obj = obj})
end


function TaskDuplicateWindow:ResetDupInfo()
    for k, data in pairs(self.dropItemMap) do
        ItemManager.Instance:PushItemToPool(data.awardItem)
        GameObject.Destroy(data.obj)
    end
    self.dropItemMap = {}

    for _, data in pairs(self.monsterItemMap) do
        GameObject.Destroy(data.obj)
        data.item:DeleteMe()
    end
    self.monsterItemMap = {}
end




function TaskDuplicateWindow:GoDuplicate()
    --if not mod.ResDuplicateCtrl:CheckFightCost(self.costVal) then
    --    return
    --end
    
    --这里保存编队类型和成员限制id
    --local data = {team_type = self.taskDuplicateConfig.team_type, team_request_id = self.systemDuplicateConfig.team_request_id}

    --if not self.dupCfg then return end
    --local dupId = self.dupCfg.duplicate_id
    if Fight.Instance then
        Fight.Instance.duplicateManager:CreateDuplicate(self.systemDuplicateConfig.id)
    end
end
