NightMareMainWindow = BaseClass("NightMareMainWindow", BaseWindow)
--冒险界面梦魇入口
local _tinsert = table.insert
local DataReward = Config.DataReward.Find --奖励表

local textColor = {
    select = Color(251 / 255, 212 / 255, 152 / 255, 1),
    noSelect = Color(255 / 255, 255 / 255, 255 / 255, 1)
}

function NightMareMainWindow:__init()
    self:SetAsset("Prefabs/UI/NightMareDuplicate/NightMareMainWindow.prefab")
    self.selectType = nil --选择哪个难度的界面
    self.selectLayer = nil --选择哪个层级
    
    self.leftTabItemList = {} --左侧tabitem
    self.bottomLayerItemList = {} --底部的层级item
    self.centerLevelItemList = {} --中间的关卡选择item
    --终难度 ui 
    self.finalCenterItemList = {}
    self.finalHeroIconList = {}
end

function NightMareMainWindow:__CacheObject()

end

function NightMareMainWindow:__BindListener()
    self.backBtn_btn.onClick:AddListener(self:ToFunc("OnClickCloseBtn"))
    EventMgr.Instance:AddListener(EventName.NightMareFreshRank, self:ToFunc("NightMareFreshRank"))
end

function NightMareMainWindow:__Show()
    --当【终难度】未解锁时
    --当【终难度】开启后 todo
    self.selectType = self.args and self.args.typeId or NightMareConfig.MainId.normal--选择难度
    self:UpdateUI()
end

function NightMareMainWindow:__Hide()

end

function NightMareMainWindow:__delete()
    for i, v in pairs(self.leftTabItemList) do
        self:PushUITmpObject("leftTabItem", v)
    end
    self.leftTabItemList = {}

    for i, v in pairs(self.centerLevelItemList) do
        self:PushUITmpObject("levelDupItem", v)
    end
    self.centerLevelItemList = {}
    for i, v in pairs(self.finalCenterItemList) do
        self:PushUITmpObject("finalDupItem", v)
    end
    self.finalCenterItemList = {}
    for i, v in pairs(self.finalHeroIconList) do
        for i, obj in pairs(v) do
            self:PushUITmpObject("heroIcon", obj)
        end
    end
    self.finalHeroIconList = {}
    EventMgr.Instance:RemoveListener(EventName.NightMareFreshRank, self:ToFunc("NightMareFreshRank"))
end

function NightMareMainWindow:UpdateUI()
    self:UpdateLeft()
end

function NightMareMainWindow:UpdateLeft()
    local list = NightMareConfig.GetDataNightmareMain()
    for i, cfg in ipairs(list) do
        if not self.leftTabItemList[i] then
            self.leftTabItemList[i] = self:PopUITmpObject("leftTabItem", self.leftTabContent.transform)
        end
        UtilsUI.SetActive(self.leftTabItemList[i].object, true)
        --刷新该难度的数据
        self:UpdateLeftTabItem(i, cfg)
        
        if i == self.selectType then
            self:OnClickType(self.selectType)
        end
    end
    
end

function NightMareMainWindow:UpdateLeftTabItem(i, cfg)
    local item = self.leftTabItemList[i]
    --名字颜色
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(cfg.condition)
    if not isPass then
        item.tabName_txt.text = string.format("<#7b7b7b>%s</color>", cfg.name)
    else
        item.tabName_txt.text = cfg.name
    end
    --监听点击难度
    item.tabName_btn.onClick:AddListener(function()
        self:OnClickType(i)
    end)
end

function NightMareMainWindow:OnClickType(type)
    --点击左侧列表时check下
    local mainCfg = NightMareConfig.GetDataNightmareMainById(type)
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(mainCfg.condition)
    if not isPass then
        local conditionCfg = Config.DataCondition.data_condition[mainCfg.condition]
        MsgBoxManager.Instance:ShowTipsImmediate(conditionCfg.description)
        return
    end
    
    self.selectType = type
    for i, v in pairs(self.leftTabItemList) do
        v.select:SetActive(i == self.selectType)
        v.noSelect:SetActive(i ~= self.selectType)
    end

    if self.selectType == NightMareConfig.MainId.normal then
        self.finalInfo:SetActive(false)
        self.primaryInfo:SetActive(true)
        self:UpdatePrimaryBottom()
    elseif self.selectType == NightMareConfig.MainId.final then
        self.finalInfo:SetActive(true)
        self.primaryInfo:SetActive(false)
        self:UpdateFinalInfo()
    end
    --刷新层级积分
    self:UpdateLayerPoint()
end

function NightMareMainWindow:UpdateLayerPoint()
    local currentLayerPoint = mod.NightMareDuplicateCtrl:GetNightMareLayerScoreList(self.selectLayer)
    local maxLayerPoint = mod.NightMareDuplicateCtrl:GetNightMareLayerMaxScore(self.selectLayer)
    self.layerScore_txt.text = currentLayerPoint or 0
    self.layerMaxScore_txt.text = '/'..maxLayerPoint
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardScore.transform)
end

--终难度的信息刷新
function NightMareMainWindow:UpdateFinalInfo()
    --更新终难度中间列表
    self:UpdateFinalCenter()
    --更新终战的数据
    self:UpdateFinalOtherInfo()
end

function NightMareMainWindow:UpdateFinalCenter()
    for i, v in pairs(self.finalCenterItemList) do
        UtilsUI.SetActive(self.finalCenterItemList[i].object, false)
    end

    local finalInfo = mod.NightMareDuplicateCtrl:GetNightMareFinalInfo()
    local list = NightMareConfig.GetDataNightmareDuplicateRefresh(finalInfo.order, finalInfo.duplicate_rule)
    for i, systemDuplicateId in ipairs(list.duplicate_group) do
        if not self.finalCenterItemList[systemDuplicateId] then
            self.finalCenterItemList[systemDuplicateId] = self:PopUITmpObject("finalDupItem", self.finalContent.transform)
        end
        UtilsUI.SetActive(self.finalCenterItemList[systemDuplicateId].object, true)
        --刷新该难度的数据
        self:RefreshFinalItem(i, systemDuplicateId)
    end
end

function NightMareMainWindow:RefreshFinalItem(i, systemDuplicateId)
    local item = self.finalCenterItemList[systemDuplicateId]
    local duplicateCfg = NightMareConfig.GetDataNightmareDuplicate(systemDuplicateId) --梦魇副本配置
    --校验下副本要有没有开启
    local systemDupCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(systemDupCfg.condition)
    if not isPass then
        --点击事件
        item.bg_btn.onClick:RemoveAllListeners()
        item.bg_btn.onClick:AddListener(function()
            local conditionCfg = Config.DataCondition.data_condition[systemDupCfg.condition]
            MsgBoxManager.Instance:ShowTipsImmediate(conditionCfg.description)
        end)
        
        return
    end

    local dupState = mod.DuplicateCtrl:GetDuplicateStateBySysId(systemDuplicateId)
    local currentPoint = dupState and dupState.current_score or 0

    --背景
    if duplicateCfg.icon ~= "" then
        AtlasIconLoader.Load(item.bg, duplicateCfg.icon)
    end
    --星空icon 
    if duplicateCfg.topicon ~= "" then
        AtlasIconLoader.Load(item.topIconBg, duplicateCfg.topicon)
    end
    --星空icon 
    item.topIconBg:SetActive(isPass)
    --未解锁 
    item.locked:SetActive(not isPass)
    --积分
    item.point_txt.text = string.format(TI18N("积分:%s"), currentPoint)
    --顺序
    item.index_txt.text = i
    --更新角色列表
    self:UpdateFinalHeroList(dupState, item, systemDuplicateId)
    --点击事件
    item.bg_btn.onClick:RemoveAllListeners()
    item.bg_btn.onClick:AddListener(function()
        self:OnClickEnterDuplicate(systemDuplicateId)
    end)
end

function NightMareMainWindow:UpdateFinalHeroList(dupState, item, systemDuplicateId)
    if not self.finalHeroIconList[systemDuplicateId] then 
        self.finalHeroIconList[systemDuplicateId] = {} 
    end 
    
    for i, v in pairs(self.finalHeroIconList[systemDuplicateId]) do
        UtilsUI.SetActive(v.object, false)
    end
    if (not dupState) or (dupState.current_score == 0) then return end
    
    for i, roleId in ipairs(dupState.use_hero_id_list) do
        if not self.finalHeroIconList[systemDuplicateId][roleId] then
            self.finalHeroIconList[systemDuplicateId][roleId] = self:PopUITmpObject("heroIcon", item.heroList.transform)
        end
        UtilsUI.SetActive(self.finalHeroIconList[systemDuplicateId][roleId].object, true)
        self:UpdateFinalHeroIcon(systemDuplicateId, roleId)
    end
end

function NightMareMainWindow:UpdateFinalHeroIcon(systemDuplicateId, roleId)
    local item = self.finalHeroIconList[systemDuplicateId][roleId]
    local heroCfg = Config.DataHeroMain.Find[roleId]
    if heroCfg and heroCfg.chead_icon ~= "" then
        SingleIconLoader.Load(item.icon, heroCfg.chead_icon, function()
            item.icon:SetActive(true)
        end)
    end
end

function NightMareMainWindow:UpdateFinalOtherInfo()
    local finalInfo = mod.NightMareDuplicateCtrl:GetNightMareFinalInfo()
    local list = NightMareConfig.GetDataNightmareDuplicateRefresh(finalInfo.order, finalInfo.duplicate_rule)
    --获取终难度所在哪一层
    self.selectLayer = finalInfo.layer
    
    local part = NightMareConfig.GetDataNightmarePartByLayer(self.selectLayer)
    --当前玩家所在区域
    self.finalTopInfo_txt.text = string.format("探索等级: %s - %s", part.level_limit[1], part.level_limit[2])
    self.areaName_txt.text = part.name
    --本层最高积分
    local currentLayerScore = mod.NightMareDuplicateCtrl:GetNightMareLayerScoreList(self.selectLayer)
    self.finalBestPoint_txt.text = currentLayerScore or 0
    --剩余时间
    --local nextRefreshTime = TimeUtils.GetRefreshTimeByRefreshId(finalInfo.duplicate_rule)
    --self.remainTime_txt.text = nextRefreshTime.days..TI18N("天")
    --排名
    mod.NightMareDuplicateCtrl:GetDuplicateNightmareRank(self.selectLayer)
end

function NightMareMainWindow:NightMareFreshRank()
    --当前排名 todo
    local rankData = mod.NightMareDuplicateCtrl:GetNightMareRankInfo(self.selectLayer)
    
end

function NightMareMainWindow:UpdatePrimaryCenter()
    local duplicateList = NightMareConfig.GetDataNightmareDuplicateFindbyLayer(self.selectLayer) --副本组
    --更新副本数据
    self:UpdateCenterLevelUI(duplicateList)
end

function NightMareMainWindow:UpdateCenterLevelUI(list)
    for i, v in pairs(self.centerLevelItemList) do
        UtilsUI.SetActive(self.centerLevelItemList[i].object, false)
    end
    
    for i, systemDuplicateId in ipairs(list) do
        if not self.centerLevelItemList[i] then
            self.centerLevelItemList[i] = self:PopUITmpObject("levelDupItem", self.levelContent.transform)
        end
        UtilsUI.SetActive(self.centerLevelItemList[i].object, true)
        --刷新该层的数据
        self:RefreshCenterLevelItem(i, systemDuplicateId)
    end
end

function NightMareMainWindow:RefreshCenterLevelItem(i, systemDuplicateId)
    local item = self.centerLevelItemList[i]
    local duplicateCfg = NightMareConfig.GetDataNightmareDuplicate(systemDuplicateId) --梦魇副本配置
    --校验下副本要有没有开启
    local systemDupCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(systemDupCfg.condition)
    if not isPass then
        --监听
        --点击事件
        item.bg_btn.onClick:RemoveAllListeners()
        item.bg_btn.onClick:AddListener(function()
            local conditionCfg = Config.DataCondition.data_condition[systemDupCfg.condition]
            MsgBoxManager.Instance:ShowTipsImmediate(conditionCfg.description)
        end)
    else
        --点击事件
        item.bg_btn.onClick:RemoveAllListeners()
        item.bg_btn.onClick:AddListener(function()
            self:OnClickEnterDuplicate(systemDuplicateId)
        end)
    end

    local dupState = mod.DuplicateCtrl:GetDuplicateStateBySysId(systemDuplicateId)
    local currentPoint = dupState and dupState.current_score or 0
    --背景
    if duplicateCfg.icon ~= "" then
        AtlasIconLoader.Load(item.bg, duplicateCfg.icon)
    end
    --星空icon 
    if duplicateCfg.topicon ~= "" then
        AtlasIconLoader.Load(item.topIconBg, duplicateCfg.topicon)
    end
    item.topIconBg:SetActive(isPass)
    --未解锁 
    item.locked:SetActive(not isPass)
    --积分
    item.point_txt.text = string.format(TI18N("积分:%s"), currentPoint)
    --顺序名
    item.index_txt.text = i
end

function NightMareMainWindow:UpdatePrimaryBottom()
    --获取该难度对应的层级的数据
    self.layerList = NightMareConfig.GetDataNightmareLayerFindbyType(self.selectType)
    for i, layerId in ipairs(self.layerList) do
        if not self.bottomLayerItemList[i] then
            self.bottomLayerItemList[i] = self:PopUITmpObject("layerItem", self.bottomLayerContent.transform)
        end
        UtilsUI.SetActive(self.bottomLayerItemList[i].object, true)
        --刷新该难度的数据
        self:RefreshBottomLayerItem(layerId)
    end
    self.selectLayer = mod.NightMareDuplicateCtrl:GetNightMareNowLayerAndProgress() -- 自动选中玩家目前打到第几层
    self:OnClickLayerBtn(self.selectLayer)
end


function NightMareMainWindow:RefreshBottomLayerItem(index)
    --index就是第几层
    local layerCfg = NightMareConfig.GetDataNightmareLayer(index)
    local node = self.bottomLayerItemList[index]
    --检查是否开启
    local isOpen = Fight.Instance.conditionManager:CheckConditionByConfig(layerCfg.condition)
    if not isOpen then
        node.layerName_txt.text = string.format("<#7b7b7b>%s</color>", layerCfg.name)
    else
        --名字
        node.layerName_txt.text = layerCfg.name
    end
    node.locked:SetActive(not isOpen)
    node.itemBtn_btn.onClick:RemoveAllListeners()
    --点击层级，显示中间的副本信息
    if isOpen then
        node.itemBtn_btn.onClick:AddListener(function()
            self:OnClickLayerBtn(index)
        end)
    end
end

--箭头
function NightMareMainWindow:OnClickMoveScrollViewBtn()
    --锁定到中间
    local index = 1
    --目前子节点的宽度
    local width = 470 * 2
    --计算列表需要滑动多少长度
    local scrollviewWidth = (index) * width
    scrollviewWidth = math.min(scrollviewWidth, self.levelContent.gameObject.transform.sizeDelta.x)

    local onclickFunc = function ()
        if self.mapMoveSequence then
            self.mapMoveSequence:Kill()
            self.mapMoveSequence = nil
        end

        self.mapMoveSequence = DOTween.Sequence()
        local targetPos = Vector3(-scrollviewWidth, 0, 0)
        local tween = self.levelContent.transform:DOLocalMove(targetPos, 0.5, true)
        self.mapMoveSequence:Append(tween)
    end
    onclickFunc()
end

--角色排序面板调用
function NightMareMainWindow:UpdateRoleList(rule)
    if not self.roleSelectPanel then
        self.roleSelectPanel = self:GetPanel(RoleSelectPanel)
    end
    if self.roleSelectPanel then
        self.roleSelectPanel:UpdateRoleList(rule)
    end
end

function NightMareMainWindow:RefreshItemList()
    if not self.roleSelectPanel then
        self.roleSelectPanel = self:GetPanel(RoleSelectPanel)
    end
    if self.roleSelectPanel then
        self.roleSelectPanel:RefreshItemList()
    end
end

--选择词缀面板调用
function NightMareMainWindow:RefreshHeroBuff(useBuffList)
    if not self.nightMareLevelEntryPanel then
        self.nightMareLevelEntryPanel = self:GetPanel(NightMareLevelEntryPanel)
    end
    if self.nightMareLevelEntryPanel then
        self.nightMareLevelEntryPanel:RefreshHeroBuff(useBuffList)
    end
end

--点击层级按钮
function NightMareMainWindow:OnClickLayerBtn(layer)
    --每一层点击也要check
    local layerCfg = NightMareConfig.GetDataNightmareLayer(layer)
    local isPass = Fight.Instance.conditionManager:CheckConditionByConfig(layerCfg.condition)
    if not isPass then
        local conditionCfg = Config.DataCondition.data_condition[layerCfg.condition]
        MsgBoxManager.Instance:ShowTipsImmediate(conditionCfg.description)
        return
    end
    
    self.selectLayer = layer
    for i, v in pairs(self.bottomLayerItemList) do
        v.select:SetActive(i == self.selectLayer)
        v.layerName_txt.color = (i == self.selectLayer) and textColor.select or textColor.noSelect
    end
    self:UpdatePrimaryCenter(layer)
    
    self:UpdateLayerPoint()
end

--点击进入副本按钮
function NightMareMainWindow:OnClickEnterDuplicate(systemDuplicateId)
    self:OpenPanel(NightMareLevelEntryPanel, {systemDuplicateId = systemDuplicateId})
end

function NightMareMainWindow:OnClickCloseBtn()
    WindowManager.Instance:CloseWindow(self)
end
