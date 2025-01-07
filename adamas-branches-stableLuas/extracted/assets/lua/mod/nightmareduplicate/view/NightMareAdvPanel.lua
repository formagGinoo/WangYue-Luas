NightMareAdvPanel = BaseClass("NightMareAdvPanel", BasePanel)
--冒险界面梦魇入口
local _tinsert = table.insert
local DataReward = Config.DataReward.Find --奖励表

function NightMareAdvPanel:__init()
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareAdvPanel.prefab")
    self.nightMareList = {}
    self.nightMareMainItem = {} --主item
    self.nightMarePrimaryItem = {} --层item
    self.nightMareFinalItem = {} --层item
    self.rewardItemObjs = {} --奖励icon
end

function NightMareAdvPanel:__CacheObject()

end

function NightMareAdvPanel:__BindListener()

end

function NightMareAdvPanel:__Show()
    self.nightMareCfg = NightMareConfig.GetDataNightmareMain()
    self:UpdateMainData()
    self:UpdateMainList()
end

function NightMareAdvPanel:__Hide()
   
end

function NightMareAdvPanel:__delete()
    self:PushMainItem()
    self:PushLayerItem()
    self:PushRewardIcon()
end

function NightMareAdvPanel:PushMainItem()
    for _, obj in pairs(self.nightMareMainItem) do
        self:PushUITmpObject("mainItem", obj)
    end
    self.nightMareMainItem = {}
end

function NightMareAdvPanel:PushLayerItem()
    for _, obj in pairs(self.nightMarePrimaryItem) do
        self:PushUITmpObject("primaryLayerItem", obj)
    end
    self.nightMarePrimaryItem = {}
    for i, v in pairs(self.nightMareFinalItem) do
        self:PushUITmpObject("finalLayerItem", v)
    end
    self.nightMareFinalItem = {}
end

function NightMareAdvPanel:PushRewardIcon()
    for _, v in pairs(self.rewardItemObjs) do
        if v.item then
            ItemManager.Instance:PushItemToPool(v.item)
        end
    end
    self.rewardItemObjs = {}
end

function NightMareAdvPanel:UpdateMainData()
    --更新数据，当【终难度】未解锁时，界面排列中优先显示【初难度】：
    --【终难度】解锁后，则优先显示【终难度】
    for i, cfg in ipairs(self.nightMareCfg) do
        self.nightMareList[i] = cfg
    end
    --如果终难度开启了，则列表第一个应该是终难度
    local isOpen, desc = Fight.Instance.conditionManager:CheckConditionByConfig(self.nightMareList[NightMareConfig.MainId.final].condition)
    if isOpen then
        table.sort(self.nightMareList, function(a, b)
            return a.id > b.id
        end)
    else
        table.sort(self.nightMareList, function(a, b)
            return a.id < b.id
        end)
    end
end

function NightMareAdvPanel:UpdateMainList()
    --先回收icon
    self:PushRewardIcon()
    
    for i, cfg in ipairs(self.nightMareList) do
        if not self.nightMareMainItem[i] then
            self.nightMareMainItem[i] = self:PopUITmpObject("mainItem", self.mainContent.transform)
        end
        UtilsUI.SetActive(self.nightMareMainItem[i].object, true)
        --刷新该难度的数据
        self:UpdateMainItem(i, cfg)
        --监听前往按钮
        self.nightMareMainItem[i].CommonButton_Btn_btn.onClick:AddListener(function()
            self:JumpToBtn(cfg)
        end)
    end
end

function NightMareAdvPanel:UpdateMainItem(i, cfg)
    local item = self.nightMareMainItem[i]

    local isOpen, desc = Fight.Instance.conditionManager:CheckConditionByConfig(cfg.condition)
    item.mainLockBg:SetActive(not isOpen)
    --当玩家点击未解锁的【终难度】板块时会有飘字提示：提示文本索引contion条件描述文本
    if not isOpen then
        --注册监听
        local conditionCfg = Config.DataCondition.data_condition[cfg.condition]
        item.mainLockBg_btn.onClick:AddListener(function()
            MsgBoxManager.Instance:ShowTips(conditionCfg.description)
        end)
        item.lockCodition_txt.text = conditionCfg.description
        return 
    end
    --标题名
    item.mainTitleName_txt.text = cfg.name
    
    
    if cfg.id == NightMareConfig.MainId.normal then --初难度的才刷新
        item.refresh:SetActive(false)
        item.nowLayer:SetActive(false)
        item.nowRank:SetActive(false)
        item.primaryScrollView:SetActive(true)
        item.finalScrollView:SetActive(false)
        self:UpdatePrimaryItem(cfg, item) --刷新初难度的item
    else
        --终难度取服务端的数据
        item.refresh:SetActive(true)
        item.nowLayer:SetActive(true)
        item.nowRank:SetActive(true)
        item.primaryScrollView:SetActive(false)
        item.finalScrollView:SetActive(true)
        self:UpdateFinalItem(cfg, item) --刷新终难度的item
    end

    --刷新奖励
    self:UpdateRewardItem(cfg, item)
end

function NightMareAdvPanel:UpdatePrimaryItem(cfg, item)
    --刷新初难度的所有层级
    local layerList = NightMareConfig.GetDataNightmareLayerFindbyType(cfg.id)--拿到该难度的数据
    local allLayerPoint = 0
    for layerType, layerId in ipairs(layerList) do
        local layerScore = mod.NightMareDuplicateCtrl:GetNightMareLayerScoreList(layerId)
        if not self.nightMarePrimaryItem[layerId] then
            self.nightMarePrimaryItem[layerId] = self:PopUITmpObject("primaryLayerItem", item.primaryContent.transform)
            UtilsUI.SetActive(self.nightMarePrimaryItem[layerId].object, true)
        end
        self:UpdatePrimaryLayerItem(layerId, layerScore)
        allLayerPoint = allLayerPoint + (layerScore or 0)
    end
    item.nowTotalScore:SetActive(true)
    item.nowTotalScore_txt.text = string.format(TI18N("累计积分:<#E4B265>%s</color>"), allLayerPoint)
end

function NightMareAdvPanel:UpdatePrimaryLayerItem(layerId, layerScoreList)
    --更新每一层的数据
    local item = self.nightMarePrimaryItem[layerId]
    local layerCfg = NightMareConfig.GetDataNightmareLayer(layerId) --该层的配置
    --layerCfg.point_reward
    --是否达到开放条件
    local isOpen, desc = Fight.Instance.conditionManager:CheckConditionByConfig(layerCfg.condition)
    item.lock:SetActive(not isOpen)
    --刷新背景图
    if layerCfg.icon ~= "" then
        AtlasIconLoader.Load(item.layerItemBg, layerCfg.icon)
    end
    --第几层
    item.layerNum_txt.text = layerId
    --统计该层的进度
    local nowProgress, maxProgress = mod.NightMareDuplicateCtrl:GetNowLayerProgress(layerId)
    --进度显示
    item.layerProgress_txt.text = string.format(TI18N("进度%s/%s"), nowProgress, maxProgress)
    item.haveDone:SetActive(nowProgress == maxProgress)
    --积分 
    local nowLayerScore = layerScoreList or 0
    local maxLayerScore = mod.NightMareDuplicateCtrl:GetNightMareLayerMaxScore(layerId)
    item.layerPoint_txt.text = string.format(TI18N("积分 %s/%s"), nowLayerScore, maxLayerScore)
end

function NightMareAdvPanel:UpdateFinalItem(cfg, item)
    --刷新终难度的数据
    local finalInfo = mod.NightMareDuplicateCtrl:GetNightMareFinalInfo()--拿到该难度的数据
    local list = NightMareConfig.GetDataNightmareDuplicateRefresh(finalInfo.order, finalInfo.duplicate_rule)
    if not list then return end 
    
    for i, systemDupId in ipairs(list.duplicate_group) do
        if not self.nightMareFinalItem[systemDupId] then
            self.nightMareFinalItem[systemDupId] = self:PopUITmpObject("finalLayerItem", item.finalContent.transform)
            UtilsUI.SetActive(self.nightMareFinalItem[systemDupId].object, true)
        end
        self:UpdateFinalLayerItem(systemDupId)
    end
    
    local layerScore = mod.NightMareDuplicateCtrl:GetNightMareLayerScoreList(finalInfo.layer)
    local point = layerScore or 0
    item.nowRank:SetActive(true)
    item.nowBestScore:SetActive(true)
    item.nowBestScore_txt.text = string.format(TI18N("本期积分:<#E4B265>%s</color>"), point)
end

function NightMareAdvPanel:UpdateFinalLayerItem(systemDupId)
    --更新每一层的数据
    local item = self.nightMareFinalItem[systemDupId]
    local systemDupCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDupId)
    local nightMareDupCfg = NightMareConfig.GetDataNightmareDuplicate(systemDupId)
    --layerCfg.point_reward
    --是否达到开放条件
    local isOpen, desc = Fight.Instance.conditionManager:CheckConditionByConfig(systemDupCfg.condition)
    item.lock:SetActive(not isOpen)
    ----刷新背景图
    --if layerCfg.icon ~= "" then
    --    AtlasIconLoader.Load(item.layerItemBg, layerCfg.icon)
    --end
    --名字
    item.dupName_txt.text = nightMareDupCfg.name
    --积分
    local stateList = mod.DuplicateCtrl:GetDuplicateStateBySysId(systemDupId)
    local point = stateList and stateList.current_score or 0
    item.layerPoint_txt.text = string.format(TI18N("积分 %s"), point)
    --showTips点击
    item.showTips_btn.onClick:RemoveAllListeners()
    item.showTips_btn.onClick:AddListener(function()
        self:OnClickShowTips(systemDupId)
    end)
end

function NightMareAdvPanel:UpdateRewardItem(cfg, item)
    local rewardCfg = DataReward[cfg.show_reward]
    if rewardCfg then
        for _, itemInfoData in ipairs(rewardCfg.reward_list) do
            local itemInfo = {
                template_id = itemInfoData[1],
                count = itemInfoData[2],
                scale = 0.85,
            }
            local rewardItem = ItemManager.Instance:GetItem(item.rewardContent, itemInfo)
            _tinsert(self.rewardItemObjs, {item = rewardItem})
        end
    end
end

function NightMareAdvPanel:OnClickShowTips(systemDupId)
    PanelManager.Instance:OpenPanel(NightMareAdvTipsPanel, {systemDuplicateId = systemDupId})
end

function NightMareAdvPanel:JumpToBtn(cfg)
    local jumpId =  cfg.jump_id
    local commonCfg = NightMareConfig.GetDataNightmareCommonConfigByTranspoint()
    --先传送过去，传送完成后再打开UI 
    local mapId = commonCfg.int_tab[1]
    local MapPos = BehaviorFunctions.GetTerrainPositionP(commonCfg.string_tab[2], mapId, commonCfg.string_tab[1])
    WindowManager.Instance:CloseWindow(AdvMainWindowV2)
    mod.WorldMapCtrl:CacheTpRotation(MapPos.rotX, MapPos.rotY, MapPos.rotZ, MapPos.rotW)
    mod.WorldMapCtrl:CacheEnterMapCallback(function()
        self:OpenNightMareMainWindow(jumpId)
    end)
    BehaviorFunctions.Transport(mapId, MapPos.x, MapPos.y, MapPos.z)
end

function NightMareAdvPanel:OpenNightMareMainWindow(jumpId)
    local npcSystemJump = Config.DataNpcSystemJump.Find[jumpId]
    --这里也校验一下
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(npcSystemJump.condition)
    if isPass then
        WindowManager.Instance:OpenWindow(NightMareMainWindow, {typeId = npcSystemJump.param[1]})
    end
end
