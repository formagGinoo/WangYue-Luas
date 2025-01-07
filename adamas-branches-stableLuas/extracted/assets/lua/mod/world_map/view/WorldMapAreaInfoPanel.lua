WorldMapAreaInfoPanel = BaseClass("WorldMapAreaInfoPanel", BasePanel)

local Red = Color(255 / 255, 124 / 255, 110 / 255, 1)
local Black = Color(22 / 255, 22 / 255, 26 / 255, 1)
local White = Color(255 / 255, 255 / 255, 255 / 255, 1)
local _insert = table.insert


function WorldMapAreaInfoPanel:__init(parent)
    self:SetAsset("Prefabs/UI/WorldMap/WorldMapAreaInfoPanel.prefab")
    self.logicMaps = {}
    self.rightItem = {}
    self.leftItem = {}
    self.leftEvent = {} --左侧事件列表（分类后）
    self.scheduleList = {}
    
    self.rogueLogicArea = {} 
    self.areaCenterAll = {}
    self.isHaveOnClick = false
end



function WorldMapAreaInfoPanel:__BindEvent()

end

--缓存对象
function WorldMapAreaInfoPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function WorldMapAreaInfoPanel:__BindListener()
    self.closeBg_btn.onClick:AddListener(self:ToFunc("OnClickCloseBtn"))
    self:BindCloseBtn(self.CommonBack1_btn, self:ToFunc("OnClickCloseBtn"))
end

function WorldMapAreaInfoPanel:__Create()

end

function WorldMapAreaInfoPanel:__Show()
    self.curMapId = mod.WorldMapCtrl:GetCurMap() --当前玩家所在的地图
    local logicMaps = mod.RoguelikeCtrl:GetAreaLogicMaps()
    local mCenter, sCenter = Fight.Instance.mapAreaManager:GetAreaCenter_All(self.args.mapId)
    --获取玩家目前在哪个中区域
    local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject()
    if entity then
        self.curAreaId = entity.values["mAreaId"]
    end
    
    --拿到该地图的需要显示的所有区域坐标和id
    self.areaCenterAll = {}
    for map_id, pos in pairs(mCenter) do
        local mapCfg = Fight.Instance.mapAreaManager:GetAreaConfig(map_id, self.args.mapId)
        _insert(self.areaCenterAll, {mapCfg = mapCfg, pos = pos} )
    end

    if logicMaps then
        for i, v in pairs(logicMaps) do
            --rogue玩法的逻辑区域(关联到小地图map_id做索引)
            local logicCfg = RoguelikeConfig.GetWorldRougeAreaLogic(v.area_logic_id)
            if not self.rogueLogicArea[logicCfg.map_id] then
                self.rogueLogicArea[logicCfg.map_id] = logicCfg
            end
        end
    end

    self:UpdateUI()
end

--在打开的时候再次show
function WorldMapAreaInfoPanel:__RepeatShow()
    UnityUtils.SetActive(self.Right, true)
end

function WorldMapAreaInfoPanel:__ShowComplete()
   
end

function WorldMapAreaInfoPanel:__Hide()

end

function WorldMapAreaInfoPanel:__delete()
    for i, v in pairs(self.scheduleList) do
        if v.obj then
            self:PushUITmpObject("schedule", v.obj)
        end
    end
    self.leftScrollView_recyceList:CleanAllCell()
    self.curAreaId = nil
end

function WorldMapAreaInfoPanel:UpdateUI()
    self.Left:SetActive(false)
    if self.args.isShowRight then
        self:UpdateRight()
    else
        self.isHaveOnClick = true
        self:CloseRight()
        self:OpenLeft(self.args.logicAreaId)
    end
end

function WorldMapAreaInfoPanel:CloseRight()
    self.closeBg:SetActive(false)
    self.Right:SetActive(false)
end

function WorldMapAreaInfoPanel:OpenLeft(areaLogicId)
    self.Left:SetActive(true)
    self:UpdateLeft(areaLogicId)
end

function WorldMapAreaInfoPanel:UpdateLeft(areaLogicId)
	--刷新名字
    local config = RoguelikeConfig.GetWorldRougeAreaLogic(areaLogicId)
    if config then
        self.leftTitle_txt.text = config.name
    end
    
    --获取已经发现的事件
    local areaEvent = mod.RoguelikeCtrl:GetDiscoverEventList()
    if not areaEvent then return end
    --对事件做分类
    self.leftEvent = {}
    for eventId, v in pairs(areaEvent) do
        local eventConfig = RoguelikeConfig.GetRougelikeEventConfig(eventId)
        if eventConfig.area == areaLogicId then --对区域做筛选
            if not self.leftEvent[eventConfig.event_type] then
                self.leftEvent[eventConfig.event_type] = {}
            end
            local isCompelete = mod.RoguelikeCtrl:GetAreaEventById(eventConfig.area, eventId)
            _insert(self.leftEvent[eventConfig.event_type], {eventConfig = eventConfig, isCompelete = isCompelete})
        end
    end
    
    --这里为了保证进循环列表是顺序的
    self.refreshTb = {}
    for event_type, v in pairs(self.leftEvent) do
        _insert(self.refreshTb, {event_type = event_type, data = v})
    end
    
    self.leftScrollView_recyceList:SetLuaCallBack(self:ToFunc("RefreshLeftItem"))
    self.leftScrollView_recyceList:SetCellNum(#self.refreshTb)
	--刷新进度
    self:UpdateLeftProgress(config, areaLogicId)
end

function WorldMapAreaInfoPanel:RefreshLeftItem(idx, obj)
    local insId = obj:GetInstanceID()
    if not self.leftItem[insId] then
        self.leftItem[insId] = {}
        self.leftItem[insId].obj = obj
        self.leftItem[insId].node = UtilsUI.GetContainerObject(self.leftItem[insId].obj)
    end
    
    local item = self.leftItem[insId]
    local itemData = self.refreshTb[idx]
    local config = RoguelikeConfig.GetRougelikeEventTypeConfig(itemData.event_type)
    item.node.name_txt.text = config.name
	item.node.maxNum_txt.text = #itemData.data
    
	local nowNum = 0 --目前完成的数量
    local maxNum = 0 --目前发现的数量
	for k, v in pairs(itemData.data) do
		if v.isCompelete then
            nowNum = nowNum +1
		end
        maxNum = maxNum + 1
	end
    item.node.nowNum_txt.text = nowNum..'/'..maxNum
    if config.map_icon ~= "" then
        SingleIconLoader.Load(item.node.icon, config.map_icon)
    end
end

function WorldMapAreaInfoPanel:UpdateLeftProgress(areaConfig, areaLogicId)
    local progressAmount = mod.RoguelikeCtrl:GetAreaEventProgress(areaLogicId)
    self.progressBar_img.fillAmount = progressAmount
    self.progressText_txt.text = TI18N("地区进度:  ")..math.floor(progressAmount * 100) .."%"
    --实例化schedule
    local areaRewardConfig = RoguelikeConfig:GetRogueScheduleCardReward(areaConfig.schedule_card_reward_id) --区域奖励配置
    for i, point in ipairs(areaRewardConfig.schedule) do
        if point ~= 0 then
            self:InitSchedule(progressAmount, point)
        end
    end
end

function WorldMapAreaInfoPanel:InitSchedule(progressAmount, point)
    if not self.scheduleList[point] then
        self.scheduleList[point] = {}
    end
    self.scheduleList[point].obj = self:PopUITmpObject("schedule", self.leftProgress.transform)
    UtilsUI.SetActive(self.scheduleList[point].obj.object, true)
    --位置
    local pointPos = self.progressBar.transform.sizeDelta.x * point * 0.01
    local pos = self.progressBar.transform.localPosition
    self.scheduleList[point].obj.object.transform.localPosition = Vec3.New(pos.x + pointPos, pos.y, pos.z)
    if progressAmount >= (point * 0.01) then
        self.scheduleList[point].obj.select:SetActive(true)
        self.scheduleList[point].obj.noSelect:SetActive(false)
    else
        self.scheduleList[point].obj.select:SetActive(false)
        self.scheduleList[point].obj.noSelect:SetActive(true)
    end
end

function WorldMapAreaInfoPanel:UpdateRight()
    self.rightScrollView_recyceList:SetLuaCallBack(self:ToFunc("RefreshRightLogicMaps"))
    self.rightScrollView_recyceList:SetCellNum(#self.areaCenterAll)
end

function WorldMapAreaInfoPanel:RefreshRightLogicMaps(idx, obj)
    local insId = obj:GetInstanceID()
    if not self.rightItem[insId] then
        self.rightItem[insId] = {}
        self.rightItem[insId].obj = obj
        self.rightItem[insId].node = UtilsUI.GetContainerObject(self.rightItem[insId].obj)
    end
    self.rightItem[insId].node.clickBtn_btn.onClick:RemoveAllListeners()
    self.rightItem[insId].node.clickBtn_btn.onClick:AddListener(function()
        self:OnClickItem(idx, insId)
    end)
    self:UpdateRightItem(idx, insId)
end

function WorldMapAreaInfoPanel:UpdateRightItem(idx, insId)
    local item = self.rightItem[insId]
    local data = self.areaCenterAll[idx].mapCfg
    item.node.name_txt.text = data.name
    item.node.name_txt.color = Black
    item.node.select:SetActive(false)
    if self.curMapId == self.args.mapId and self.curAreaId == data.id then
        --当前区域直接选择
        item.node.select:SetActive(true)
    end
end

function WorldMapAreaInfoPanel:OnClickItem(idx, insId)
    self.isHaveOnClick = true --是否点击过区域
    local data = self.areaCenterAll[idx]
    --点击了这个区域，需要传给地图主界面, 锁定到区域上
    if self.parentWindow and self.parentWindow.OnClickWorldMapToSetPos then
        self.parentWindow:OnClickWorldMapToSetPos(data.mapCfg, data.pos)
    end
    
    --这里判断下是不是肉鸽玩法的区域，如果是则更新左侧面板
    if self.rogueLogicArea[data.mapCfg.id] then
        self:OpenLeft(self.rogueLogicArea[data.mapCfg.id].area_logic)
    end
    self:CloseRight()
end

function WorldMapAreaInfoPanel:OnClickCloseBtn()
    if self.parentWindow then
        if self.isHaveOnClick then
            self.parentWindow:AreaToMapWindow()
        end
        self.parentWindow:ClosePanel(self)
    else
        PanelManager.Instance:ClosePanel(self)
    end
end