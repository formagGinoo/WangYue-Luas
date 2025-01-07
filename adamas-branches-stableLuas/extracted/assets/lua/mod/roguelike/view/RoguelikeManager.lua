RoguelikeManager = BaseClass("RoguelikeManager")

local _tInsert = table.insert
local _tRemove = table.remove
local _tSort = table.sort

function RoguelikeManager:__init(fight)
    self.fight = fight
    self.clientFight = fight.clientFight
    
    self.roguelikeCtrl = mod.RoguelikeCtrl
    self.roguelikeFacade = mod.RoguelikeFacade

    self.allEventList = {}

    -- TODO 这里后端应该会有个记录
    self.triggeredEvent = {}
    --发现的事件 
    self.triggeredDiscoverEvent = {}

    self.addMagicMap = {}

    self.checkCondition = {}
    
    self:InitRouguelikeEventInfo()

    self:InitRoguelikeConditionInfo()
end

function RoguelikeManager:GetDiscoverEventList()
    return self.triggeredDiscoverEvent
end

function RoguelikeManager:StartFight()
    if self.roguelikeCtrl then
        self.roguelikeCtrl:CheckRogueChoiceList()
    end
end

function RoguelikeManager:ReqRogueInfo()
    self.roguelikeFacade:SendMsg("rogue_info")
end

function RoguelikeManager:ResetRogueLikeManager()
    for eventId, v in pairs(self.triggeredDiscoverEvent) do
        mod.WorldMapCtrl:RemoveEventMark(eventId)
    end
    self.triggeredDiscoverEvent = {}
    self.allEventList = {}
    self.triggeredEvent = {}
    
    self:InitRouguelikeEventInfo()
end

function RoguelikeManager:InitRouguelikeEventInfo()
    local allEvent = self.roguelikeCtrl:GetAllEventList()
    -- 初始化一份事件信息
    for id, data in pairs(allEvent) do
        self:SetEventInfo(id, data)
    end
    --初始化"本轮"已经发现的事件
    local findEvent = self.roguelikeCtrl:GetDiscoverEventList()
    for eventId, v in pairs(findEvent) do
        self.triggeredDiscoverEvent[eventId] = true
    end
end

function RoguelikeManager:InitRoguelikeConditionInfo()
    local gameNum = mod.RoguelikeCtrl:GetGameRoundId()
    --前期重启条件表
    local gameReplayConfig = RoguelikeConfig.GetRogueGameReplayConfig()
    --todo 可能后期靠时间刷新的红点需要注意
    --把所有的conditionId都塞到表里
    if gameReplayConfig[gameNum] then
        for i, v in pairs(gameReplayConfig) do
            self.checkCondition[v.condition] = v.condition
            self.fight.conditionManager:AddListener(v.condition, self:ToFunc("OnConditionFunc"))
        end
    end
end

function RoguelikeManager:SetEventInfo(eventId, eventInfo)
    if not eventInfo then return end
    local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(eventId)
    if not eventCfg then
        LogError("未找到Roguelike eventId , eventId = ", eventId)
        return
    end
    local mapPos = BehaviorFunctions.GetTerrainPositionP(eventCfg.position[2], eventCfg.map_id, eventCfg.position[1])
    if not mapPos then
        LogError("Roguelike eventId的点位有问题 , eventId = "..eventId)
        return 
    end
    local data = {
        pos = Vec3.New(mapPos.x, mapPos.y, mapPos.z),
        loadRadius = eventCfg.load_radius,
        duplicateLoadRadius = eventCfg.duplicate_load_radius,
        unloadRadius = eventCfg.unload_radius or 0,
        duplicateLevel = eventCfg.duplicate_level,
        isComplete = eventInfo.isComplete
    }
    self.allEventList[eventId] = data
end

function RoguelikeManager:Update()
    self:CheckTriggerEvent()
end

function RoguelikeManager:CheckTriggerEvent()
    if TableUtils.GetTabelLen(self.allEventList) <= 0 then return end

    local playerInsId = BehaviorFunctions.GetCtrlEntity()
    local rolePos = BehaviorFunctions.GetPositionP(playerInsId)
    for eventId, event in pairs(self.allEventList) do
        local loadRadius = event.loadRadius ^ 2
        local findRadius = event.duplicateLoadRadius ^ 2
        local unloadRadius = event.unloadRadius ^ 2
        local curRadius = UtilsBase.GetPosRadius(event.pos, rolePos)

        local isInLoadRadius = curRadius <= loadRadius --加载半径 
        local isFindRadius = curRadius <= findRadius --发现半径
        if unloadRadius > 0 and curRadius >= unloadRadius and self.triggeredEvent[eventId] then -- 卸载
            BehaviorFunctions.RemoveLevel(event.duplicateLevel)
            self.triggeredEvent[eventId] = nil
            goto continue
        end

        if self.triggeredEvent[eventId] or event.isComplete then
            goto continue
        end

        if isInLoadRadius then --到达加载半径才加载关卡
            local isCreated = self:TriggerEvent(eventId)
            if isCreated then
                self.triggeredEvent[eventId] = true
            end
        end
        if event.duplicateLoadRadius == 0 then --为零的话直接就设置为发现了该事件
            --事件发现提示
            self:TriggerDiscoverEvent(eventId, false)
        elseif isFindRadius then
            --事件发现提示
            self:TriggerDiscoverEvent(eventId, true)
        end
        ::continue::
    end
end

function RoguelikeManager:TriggerEvent(eventId)
    local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(eventId)
    if not eventCfg then return end
    -- TODO 触发事件触发提示
    
    local levelOccupancyList = self.fight.levelManager.levelOccupancyList
    if levelOccupancyList then
        --检测有没有被区域占用
        for i, value in pairs(levelOccupancyList) do
            if value[eventCfg.duplicate_level] then
                return false
            end
        end
    end
    -- 添加关卡行为脚本
    BehaviorFunctions.AddLevel(eventCfg.duplicate_level, nil, nil, {rogueEventId = eventId})
    --检测是否加载成功
    return BehaviorFunctions.CheckLevelIsCreate(eventCfg.duplicate_level)
end

function RoguelikeManager:TriggerDiscoverEvent(eventId, isShowTips)
    if not self.triggeredDiscoverEvent[eventId] then
        if isShowTips then
            EventMgr.Instance:Fire(EventName.AddSystemContent, RogueTipsPanel, { args = {eventId = eventId, isShowProgress = false} })
        end
        self:RogueDiscoverEvent(eventId)
        self.triggeredDiscoverEvent[eventId] = true
    end
end

function RoguelikeManager:SetRoguelikeEventCompleteState(eventId, isComplete)
    local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(eventId)
	if not eventCfg then
		LogError("缺少肉鸽事件配置，事件iD = "..eventId)
		return
	end
	local areaId = eventCfg.area
    if isComplete then
        self:EventFinish(areaId, eventId)
    else
        BehaviorFunctions.RemoveLevel(eventCfg.duplicate_level)
    end
    self.triggeredEvent[eventId] = nil
end

function RoguelikeManager:EventFinish(areaId, eventId)
    -- 事件完成,策划通知
    local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(eventId)
    if not eventCfg then
        LogError("缺少事件配置"..eventId)
        return
    end
    
    --发完成事件之前判断是否是首次完成
    mod.RoguelikeCtrl:SetCurrentEvent(eventId)
    
    self.roguelikeFacade:SendMsg("rogue_event_finish", areaId, eventId)
    
    if self.allEventList[eventId] then
        self.allEventList[eventId].isComplete = true
    end
end

-- TIP:奖励自动发放
function RoguelikeManager:GetEventReward(areaId, eventId)
    -- local eventComplete = self.roguelikeCtrl:CheckAreaEventCompleteState(areaId, eventId)
    -- if not eventComplete then
    --     LogError("事件未完成"..eventId)
    --     return
    -- end

    -- self.roguelikeFacade:SendMsg("rogue_event_reward", eventId)
end

--发现事件 event_id
function RoguelikeManager:RogueDiscoverEvent(eventId)
    local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(eventId)
    if not eventCfg then
        LogError("缺少事件配置"..eventId)
        return
    end
    
    local orderId, protoId = self.roguelikeFacade:SendMsg("rogue_event_discover", eventCfg.area, eventId)
    SystemConfig.WaitProcessing(orderId, protoId, function(ERRORCODE)
        if ERRORCODE == 0 then
            --更新发现事件列表
            if self.roguelikeCtrl then
                self.roguelikeCtrl:SetDiscoverEvent(eventId)
            end
            --加载发现事件的图标
            mod.WorldMapCtrl:LoadRogueEventMark()
        end
    end)
end


function RoguelikeManager:GMCompleteEvent(areaId, eventId)
    self:EventFinish(areaId, eventId)
end

function RoguelikeManager:GMCompleteAllEvent()
    local allEvent = self.roguelikeCtrl:GetAllEventList()
    for eventId, data in pairs(allEvent) do
        self:GMCompleteEvent(data.areaId, eventId)
    end
end

-- 这里移除所有卡牌附带的magic
function RoguelikeManager:RemoveAllCardMagic()
    -- 切换角色/卡牌数据发生变化
	local curInstanceId = BehaviorFunctions.GetCtrlEntity()
    for cardId, addMagicId in pairs(self.addMagicMap) do
        if addMagicId then
            -- 移除已经添加的magic效果
            BehaviorFunctions.RemoveBuff(curInstanceId, addMagicId)
        end
    end
    TableUtils.ClearTable(self.addMagicMap)
end

-- 这里获取所有卡牌附带的magic
function RoguelikeManager:AddAllCardMagic()
    --先移除再添加
    self:RemoveAllCardMagic()
    -- 初次进入游戏/切换角色/卡牌数据发生变化
    local curEquipCard = self.roguelikeCtrl:GetCardEquip()
    for cardId, count in pairs(curEquipCard) do
        self:AddNewCardMagic(cardId, count)
    end
end

-- 新加卡牌
function RoguelikeManager:AddNewCardMagic(cardId, lv)
    -- 这里考虑下后期是否需要添加一个系统的magic管理器
    local cardCfg = RoguelikeConfig.GetWorldRougeCardLevelConfigById(cardId, lv)
    local magicIdInfo = StringHelper.Split(cardCfg.magic_id, ",")
    local addMagicId = tonumber(magicIdInfo[1])
    local magicLV = magicIdInfo[2] and tonumber(magicIdInfo[2]) or 1
    local curInstanceId = BehaviorFunctions.GetCtrlEntity()
    BehaviorFunctions.DoMagic(curInstanceId, curInstanceId, addMagicId, magicLV, FightEnum.MagicConfigFormType.Roguelike)
    self.addMagicMap[cardId] = addMagicId
end

--条件达成的时候去判断下红点
function RoguelikeManager:OnConditionFunc(conditionId)
    if not self.checkCondition[conditionId] then
        return
    end
    --刷新Rogue红点
    EventMgr.Instance:Fire(EventName.CheckRogueRed)
end