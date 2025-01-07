TradeConfig = TradeConfig or {}

TradeConfig.PageType = 
{
    Consume = {BagPage = 4, TradePage = 1},
    Develop = {BagPage = 2, TradePage = 2},
}

TradeConfig.PageIndex = 
{
    [1] = TradeConfig.PageType.Consume,
    [2] = TradeConfig.PageType.Develop,
}

TradeConfig.NpcJumpData = Config.DataNpcSystemJump.Find
TradeConfig.TradeCommon = Config.DataTradeCommon.Find
TradeConfig.TradeStore = Config.DataTradeStore.Find
TradeConfig.TradeOrder = Config.DataTradeOrder.Find

function TradeConfig.GetStoreIdByNpcId(npcId)
    local npcData = EcoSystemConfig.GetEcoConfig(npcId)

    if npcData then
        for _, jumpId in ipairs(npcData.jump_system_id) do
            local jumpData = TradeConfig.NpcJumpData[jumpId]
            if jumpData and jumpData.type == 7 then
                if jumpData.param[1] == nil then
                    LogError(string.format("NpcJump表的%d, Type类型为7, 但参数为空, 找不到对应的收购库Id", jumpId))
                    return nil
                end
                return jumpData.param[1]
            end
        end
    end
end

function TradeConfig.GetNpcCameraParams(npcId)
    local npcData = EcoSystemConfig.GetEcoConfig(npcId)

    if npcData then
        for _, jumpId in ipairs(npcData.jump_system_id) do
            local jumpData = TradeConfig.NpcJumpData[jumpId]
            if jumpData and jumpData.type == 7 then
                if jumpData.param[1] == nil then
                    LogError(string.format("NpcJump表的%d, Type类型为7, 但参数为空, 找不到对应的收购库Id", jumpId))
                    return nil
                end
                return jumpData.camera_params
            end
        end
    end
end

function TradeConfig.GetTeachId()
    return TradeConfig.TradeCommon["TradeTeachId"].int_val
end

function TradeConfig.GetCurrencyList()
    local tb = TradeConfig.TradeCommon["TradeCurrencyId"].int_tab
    if not tb then
        tb = {}
    end
    return tb
end

function TradeConfig.GetStoreInfo(storeId)
    return TradeConfig.TradeStore[storeId]
end

function TradeConfig.GetStoreCool(storeId)
    return TradeConfig.TradeStore[storeId].cool_time
end

function TradeConfig.GetTradeOrder(orderId)
    return TradeConfig.TradeOrder[orderId]
end