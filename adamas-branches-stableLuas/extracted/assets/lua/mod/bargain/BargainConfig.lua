local _random = math.random

BargainConfig = BargainConfig or {}

BargainConfig.NpcCharacter = Config.DataBargainNpcCharacter.Find
BargainConfig.Score = Config.DataBargainScore.Find
BargainConfig.BargainMain = Config.DataBargainMain.Find
BargainConfig.BargainMainByNegotiateId = Config.DataBargainMain.FindbyNegotiateId
BargainConfig.BargainScore = Config.DataBargainScore.Find
BargainConfig.BargainMainDialog = Config.DataBargainDialogMain.Find
BargainConfig.BargainDialog = Config.DataBargainDialog.Find
BargainConfig.BargainPlayerModel = Config.DataBargainPlayerModel.Find
BargainConfig.HeroMain = Config.DataHeroMain.Find
BargainConfig.BargainModelParam = Config.DataBargainModelParam.Find
BargainConfig.BargainCommon = Config.DataBargainCommon.Find
BargainConfig.BargainDialogAnim = Config.DataBargainDialogAnim.Find
BargainConfig.Shop = Config.DataShop.Find

BargainConfig.Color = 
{
    White = "#eaeaea",
    Green = "#a6f787",
    Red = "#ff5b5b",
    Blue = "#61BAFF",
}

BargainConfig.EntryWaitTime = 3

function BargainConfig.GetNpcCharacterInfo(characterId)
    return BargainConfig.NpcCharacter[characterId]
end

function BargainConfig.GetOrder(negotiateInfo, round)
    local order = negotiateInfo.order_list[round]
    return order
end

function BargainConfig.GetNpcStrategy(negotiateInfo, round)
    local characterId = negotiateInfo.npc_character
    local character = BargainConfig.GetNpcCharacterInfo(characterId)
    return character.strategy_list[round]
end

function BargainConfig.GetScore(playerChoice, npcChoice)
    local key = UtilsBase.GetDoubleKeys(npcChoice, playerChoice, 32)
    return BargainConfig.Score[key].player_score
end

function BargainConfig.GetScoreInfo(playerChoice, npcChoice)
    local key = UtilsBase.GetDoubleKeys(npcChoice, playerChoice, 32)
    return BargainConfig.Score[key]
end

function BargainConfig.GetBargainInfo(negotiateId, bargainCount)
    local idInfo = BargainConfig.BargainMainByNegotiateId[negotiateId]
    local index = nil
    if idInfo then
        for _, v in pairs(idInfo) do
            local tMain = BargainConfig.BargainMain[v]
            if bargainCount >= tMain.bargain_count then
                if index and tMain.bargain_count > BargainConfig.BargainMain[index].bargain_count then
                    index = v
                elseif index == nil then
                    index = v
                end
            end
        end
    end

    if index then
        return BargainConfig.BargainMain[index]
    end
    
    return nil
end

function BargainConfig.GetBargainNpcCharacterByBargainInfo(bargainInfo)
    local characterInfo = BargainConfig.NpcCharacter[bargainInfo.npc_character]
    if not characterInfo then
        LogError(string.format("Npc性格Id:%d, 在Npc性格表中找不到相应数据"))
        return nil
    end
    return characterInfo
end

function BargainConfig.GetRandomSubGruodId(bargainInfo)
    local subGroupList = BargainConfig.BargainMainDialog[bargainInfo.dialog_group_id]
    if subGroupList and #subGroupList.sub_group_id > 0 then
        local index = _random(1, #subGroupList.sub_group_id)
        return subGroupList.sub_group_id[index]
    end
    return nil
end

function BargainConfig.GetBargainDialog(subGruopId, round)
    local key = UtilsBase.GetDoubleKeys(subGruopId, round, 32)
    return BargainConfig.BargainDialog[key]
end

function BargainConfig.GetBargainSoundBank(subGruopId)
    local subGroupList = Config.DataBargainDialog.FindbySubGroupId[subGruopId]
    if not subGroupList then
        LogError(string.format("对话表子组Id %d 无法找到对应的对话表组", subGruopId))
        return
    end
    local bankTable = {}
    for key, _ in pairs(subGroupList) do
        local dialogInfo = BargainConfig.BargainDialog[key]
        if dialogInfo then
            if dialogInfo.player_up_cv then
                bankTable[dialogInfo.player_up_cv[1]] = true
            end
            if dialogInfo.player_under_cv then
                bankTable[dialogInfo.player_under_cv[1]] = true
            end
            if dialogInfo.npc_up_cv then
                bankTable[dialogInfo.npc_up_cv[1]] = true
            end
            if dialogInfo.npc_under_cv then
                bankTable[dialogInfo.npc_under_cv[1]] = true
            end
        end
    end
    return bankTable
end

function BargainConfig.GetUiModelByPlayerId(playerId)
    local playerModel = BargainConfig.BargainPlayerModel[playerId]
    if playerModel then
        return playerModel.bargain_ui_model
    end
    return nil
end

function BargainConfig.GetUiModelByNpcId(bargainInfo)
    return bargainInfo.npc_ui_model
end

function BargainConfig.GetModelOffsetByUiModel(uiModelName)
    local t = BargainConfig.BargainModelParam[uiModelName]
    if not t then
        return {camera_position = {x = 0.00, y = 0.00, z = 0.00}, camera_rotation = {x = 0.00, y = 0.00, z = 0.00}, camera_scale = {x = 1.00, y = 1.00, z = 1.00}}
    end
    return t
end

function BargainConfig.GetPlayerIconByPlayerId(playerId)
    return BargainConfig.HeroMain[playerId].rhead_icon
end

function BargainConfig.GetNpcIconByNpcId(npcId)
    local npcConfig = EcoSystemConfig.GetEcoConfig(npcId)
    return npcConfig.head_icon
end

function BargainConfig.GetNegotiateIdByShopNpcId(npcId)
    local npcData = EcoSystemConfig.GetEcoConfig(npcId)
    if npcData then
        for _, jumpId in ipairs(npcData.jump_system_id) do
            local jumpData = TradeConfig.NpcJumpData[jumpId]
            if jumpData and jumpData.type == 8 then
                if jumpData.param[1] == nil then
                    LogError(string.format("NpcJump表的%d, Type类型为8, 但参数为空, 找不到对应的交涉Id", jumpId))
                    return nil
                end
                return jumpData.param[1]
            end
        end
    end
end

function BargainConfig.GetNegotiateIdByShopId(shopId)
    return BargainConfig.Shop[shopId].negotiate_id
end

function BargainConfig.GetBargainScoreShowInfo()
    local tb = {}
    for _, v in pairs(BargainConfig.BargainScore) do
        if v.show_order and v.show_order > 0 then
            if tb[v.show_order] then
                LogError("讨价还价得分表配置了重复的显示顺序")
            end
            tb[v.show_order] = {playerChoice = v.player_choice, npcChoice = v.npc_choice, playerScore = v.player_score, npcScore = v.npc_score}
        end
    end
    return tb
end

function BargainConfig.GetBargainChooseCountTime()
    return BargainConfig.BargainCommon["ChooseCountTime"].double_val
end

function BargainConfig.GetNpcName(npcId)
    return EcoSystemConfig.GetEcoConfig(npcId).name
end

function BargainConfig.GetDialogAnim(animKey)
    return BargainConfig.BargainDialogAnim[animKey]
end