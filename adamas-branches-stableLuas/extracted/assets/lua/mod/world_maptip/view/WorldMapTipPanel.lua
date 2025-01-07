WorldMapTipPanel = BaseClass("WorldMapTipPanel", BasePanel)

local PanelStateEnum = {
    Progress = 1, --进度界面
    Legend = 2 --图例界面
}

local PanelScale = {
    Open = Vec3.New(1,-1,1),
    Close = Vec3.one
}

local disCoverLength = 998 --未发现
local finishLength = 999 --已完成
local emptyLength = 1000 --空的

local otherItemInfo = {
    [disCoverLength] = { name = "未发现", numFunc = function (tipId)  return mod.WorldMapTipCtrl:GetNoDiscoverEvent(tipId) end},
    [finishLength] = { name = "已完成", numFunc = function (tipId)  return mod.WorldMapTipCtrl:GetFinishedEvent(tipId) end},
    [emptyLength] = { name = "", numFunc = function (tipId)  return end }
}

--初始化
function WorldMapTipPanel:__init()
    self:SetAsset("Prefabs/UI/WorldMapTips/WorldMapTipPanel.prefab")
    self.showPanel = PanelStateEnum.Progress
    self.mapAllEvent = {}

    --ui 
    self.areaObjList = {}
    self.areaItemList = {}

    self.exampleObjList = {}
    self.exampleItemList = {}
end

--添加监听器
function WorldMapTipPanel:__BindListener()
    self.changeBtn_btn.onClick:AddListener(self:ToFunc("OnClickChangeBtn"))
end

--缓存对象
function WorldMapTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end
--
function WorldMapTipPanel:__Create()

end

function WorldMapTipPanel:__Show(args)
    --设置层级， 避免和linerender一个sortingOrder
    self.canvas.sortingOrder = self.args.sortingOrder
    self:ShowPanel(self.args.mapId, self.args.areaId)
end

function WorldMapTipPanel:__RepeatShow()
    self.canvas.sortingOrder = self.args.sortingOrder
    self:ShowPanel(self.args.mapId, self.args.areaId)
end

function WorldMapTipPanel:ShowPanel(mapId, areaId)
    self.mapId = mapId
    self.areaId = areaId
    local allEvents = mod.WorldMapTipCtrl:GetMapAreaAllEvent(self.mapId, self.areaId)

    self.mapAllEvent = {}
    for i, v in pairs(allEvents) do
        table.insert(self.mapAllEvent, v)
    end
    
    table.sort(self.mapAllEvent, function(a, b)
        local aTipCfg = WorldMapTipConfig.GetMapTipCfg(a)
        local bTipCfg = WorldMapTipConfig.GetMapTipCfg(b)
        if aTipCfg.priority ~= bTipCfg.priority then
            return aTipCfg.priority < bTipCfg.priority
        end
        return aTipCfg.tips_id < bTipCfg.tips_id
    end)
    self:UpdateUI()
end

function WorldMapTipPanel:__delete()
    for i, v in pairs(self.areaObjList) do
        self:PushUITmpObject("item", v.obj)
    end
    for _, v1 in pairs(self.areaItemList) do
        for k2, obj in pairs(v1) do
            self:PushUITmpObject("dropItem", obj)
        end
    end
    TableUtils.ClearTable(self.areaObjList)
    TableUtils.ClearTable(self.areaItemList)
end

function WorldMapTipPanel:__Hide()

end

function WorldMapTipPanel:__ShowComplete()

end

function WorldMapTipPanel:UpdateUI()
    self:UpdateTop()
    UtilsUI.SetActive(self.areaInfoPanel, self.showPanel == PanelStateEnum.Progress)
    UtilsUI.SetActive(self.examplePanel, self.showPanel == PanelStateEnum.Legend)
    if self.showPanel == PanelStateEnum.Progress then
        self:UpdateAreaInfoPanel()
    elseif self.showPanel == PanelStateEnum.Legend then
        self:UpdateExamplePanel()
    end
end

function WorldMapTipPanel:UpdateTop()
    local mapCfg = WorldMapTipConfig.GetMapCfg(self.mapId)
    local areaCfg = WorldMapTipConfig.GetMapAreaCfg(self.areaId, self.mapId)
    self.title_txt.text = string.format(TI18N("%s-%s"), mapCfg.name, areaCfg.name)
end

function WorldMapTipPanel:UpdateAreaInfoProgress()
    --更新区域完整进度
    local progress = mod.WorldMapTipCtrl:GetMapAreaProgress(self.mapId, self.areaId)
    self.areaProgress_txt.text = string.format(TI18N("%s%%"), progress)
end

function WorldMapTipPanel:UpdateAreaInfoPanel()
    self:UpdateAreaInfoProgress()
    
    for i, v in pairs(self.areaObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end

    if not self.mapAllEvent then
        return
    end

    for _, tipId in pairs(self.mapAllEvent) do
        local obj
        if not self.areaObjList[tipId] then
            self.areaObjList[tipId] = {}
            obj = self:PopUITmpObject("item", self.itemContent.transform)
            self.areaObjList[tipId].obj = obj
        else
            obj = self.areaObjList[tipId].obj
        end
        UtilsUI.SetActive(obj.object, true)
        
        self:UpdateMapTipItem(tipId)
    end
end

function WorldMapTipPanel:UpdateMapTipItem(tipId)
    local obj = self.areaObjList[tipId].obj
    local mapTipCfg = WorldMapTipConfig.GetMapTipCfg(tipId)
    local mapTipsType = WorldMapTipConfig.GetDataMapTipsType(mapTipCfg.sub_type)
    --名字
    obj.name_txt.text = mapTipsType.name
    --icon
    if mapTipsType.icon ~= "" then
        SingleIconLoader.Load(obj.icon, mapTipsType.icon)
    end
    --num
    local finishedEventNum = mod.WorldMapTipCtrl:GetFinishedEvent(tipId)
    obj.num_txt.text = string.format("%s/%s", #finishedEventNum, #mapTipCfg.property)
    --dropBtn
    obj.dropBtn_btn.onClick:RemoveAllListeners()
    obj.dropBtn_btn.onClick:AddListener(function()
        self:OnClickDropBtn(tipId)
    end)
end

function WorldMapTipPanel:OnClickDropBtn(tipId)
    self.areaObjList[tipId].openDrop = not self.areaObjList[tipId].openDrop
    local openDrop = self.areaObjList[tipId].openDrop
    local obj = self.areaObjList[tipId].obj
    
    local scale = openDrop and PanelScale.Open or PanelScale.Close
    UnityUtils.SetLocalScale(obj.dropBtn.transform, scale.x, scale.y, scale.z)
    UtilsUI.SetActive(obj.drop.transform, openDrop or false)
    
    self:UpdateSubTypeObj(tipId)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemContent.transform)
end

function WorldMapTipPanel:UpdateSubTypeObj(tipId)
    if not self.areaItemList[tipId] then
        self.areaItemList[tipId] = {}
    end
    --二级列表展示发现但是未完成的事件
    local discoverEvents = mod.WorldMapTipCtrl:GetDiscoverEvent(tipId)
    --刷新UI
    for i, event_id in ipairs(discoverEvents) do
        local obj
        if not self.areaItemList[tipId][i] then
            obj = self:PopUITmpObject("dropItem", self.areaObjList[tipId].obj.drop.transform)
            self.areaItemList[tipId][i] = obj
        else
            obj = self.areaItemList[tipId][i]
        end
        UtilsUI.SetActive(obj.object, true)

        local name, dis, markInstance = mod.WorldMapTipCtrl:GetTipEventInfo(tipId, event_id)
        --名字
        obj.name_txt.text = name
        --距离
        obj.dis_txt.text = string.format("%sm", dis)
        --前往按钮
        obj.jumpBtn_btn.onClick:RemoveAllListeners()
        obj.jumpBtn_btn.onClick:AddListener(function()
            self:OnClickJumpBtn(markInstance)
        end)
    end
    
    --未发现，已完成的事件
    self:UpdateOtherItem(tipId)
end

function WorldMapTipPanel:UpdateOtherItem(tipId)
    for i = disCoverLength, emptyLength do
        local obj
        if not self.areaItemList[tipId][i] then
            obj = self:PopUITmpObject("dropItem", self.areaObjList[tipId].obj.drop.transform)
            self.areaItemList[tipId][i] = obj
        else
            obj = self.areaItemList[tipId][i]
        end
        UtilsUI.SetActive(obj.object, true)
        UtilsUI.SetActive(obj.jumpBtn.transform, false)
        local eventList = otherItemInfo[i].numFunc(tipId)

        obj.name_txt.text = otherItemInfo[i].name
        obj.dis_txt.text = eventList and string.format("x%s", #eventList) or TI18N("")
    end
end

--点击前往按钮
function WorldMapTipPanel:OnClickJumpBtn(markInstance)
    -- 追踪
    local markInfo = mod.WorldMapCtrl:GetMark(markInstance)
    mod.WorldMapCtrl:ChangeMarkTraceState(markInstance, true)
    -- 位置锁定
    local posX, posZ = mod.WorldMapCtrl:TransWorldPosToUIPos(markInfo.position.x, markInfo.position.z, self.mapId)
    if self.parentWindow then
        self.parentWindow:DOMapMove({x = posX, y = posZ})
    end
end

function WorldMapTipPanel:UpdateExamplePanel()
    self.title_txt.text = TI18N("图例展示")
    local LegendConfig = WorldMapTipConfig.GetAllLegendConfig()
    local exampleMap = {}
    for k, v in pairs(LegendConfig) do
        if not exampleMap[v.type_id] then exampleMap[v.type_id] = {} end
        table.insert(exampleMap[v.type_id],k)
    end

    for k, v in pairs(exampleMap) do
        local obj,item
        if not self.exampleObjList[k] then
            self.exampleObjList[k] = {}
            obj = self:PopUITmpObject("EventTypeItem", self.Content.transform)
            self.exampleObjList[k].obj = obj
        else
            obj = self.exampleObjList[k].obj
        end
        UtilsUI.SetActive(obj.object, true)
        
        if not self.exampleItemList[k] then
            item = PoolManager.Instance:Pop(PoolType.class, "EventTypeItem")
            if not item then
                item = EventTypeItem.New()
            end
            self.exampleItemList[k] = item
        else
            item = self.exampleItemList[k]
        end
        item:InitItem(obj.object, {main_type = k, legendList = v})
    end
end

function WorldMapTipPanel:OnClickChangeBtn()
    self.showPanel = self.showPanel == PanelStateEnum.Progress and PanelStateEnum.Legend or PanelStateEnum.Progress
    self:UpdateUI()
end



