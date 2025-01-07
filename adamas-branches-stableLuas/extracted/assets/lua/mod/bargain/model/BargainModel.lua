BargainModel = BaseClass("BargainModel", module)

local _random = math.random

function BargainModel:__init()
    self.isGame = false
    self.isReady = false

    self.curRound = 0
    self.sumRound = 0
    self.playerChoice = {}
    self.npcChoice = {}

    self.roundStartCallback = nil
    self.roundEndCallback = nil
end

function BargainModel:__delete()
    
end

function BargainModel:SetBargain(bargainInfo)
    self:Reset()

    self.bargainInfo = bargainInfo
    self.curRound = 0
    self.sumRound = bargainInfo.total_rounds

    self.isGame = true
    self.isReady = true
end

function BargainModel:SetCallback(roundStartCallback, roundEndCallback)
    self.roundStartCallback = roundStartCallback
    self.roundEndCallback = roundEndCallback
end

function BargainModel:PlayerChoice(choice)
    if not self.isGame or self.isReady then
        LogError("砍价玩法未开始, 或者玩家已经出牌完毕")
        return false
    end

    self.playerChoice[self.curRound] = choice

    local order = BargainConfig.GetOrder(self.bargainInfo, self.curRound)
    if order == BargainEnum.Order.Together then
        -- npc出牌
        local strategy = BargainConfig.GetNpcStrategy(self.bargainInfo, self.curRound)
        local npcChoice = self:NpcPlay(strategy)
        if not npcChoice then
            LogError("Npc没有出牌")
            return false
        end
        self.npcChoice[self.curRound] = npcChoice
    end
    self.isReady = true

    if self.roundEndCallback then
        self.roundEndCallback(self.curRound, self.playerChoice, self.npcChoice)
    end

    return true
end

function BargainModel:CalculatedScore()
    if not self.isGame or not self.isReady then
        return nil
    end

    if self.playerChoice[self.curRound] and self.npcChoice[self.curRound] then
        local curScore = BargainConfig.GetScore(self.playerChoice[self.curRound], self.npcChoice[self.curRound])

        return curScore
    end

    return nil
end

function BargainModel:NextRound()
    if not self.isGame or not self.isReady then
        LogError("砍价玩法未开始, 或者有玩家还未出牌")
        return false
    end

    if self.curRound == self.sumRound then
        --游戏结束
        return false
    end

    self.curRound = self.curRound + 1
    self.isReady = false

    -- 判断是否npc先行
    local order = BargainConfig.GetOrder(self.bargainInfo, self.curRound)
    if order == BargainEnum.Order.Npc then
        local strategy = BargainConfig.GetNpcStrategy(self.bargainInfo, self.curRound)
        local npcChoice = self:NpcPlay(strategy)
        if not npcChoice then
            LogError("Npc还没有出牌")
            return false
        end
        self.npcChoice[self.curRound] = npcChoice
    end

    if self.roundStartCallback then
        self.roundStartCallback(self.curRound, self.playerChoice, self.npcChoice)
    end

    return true
end

function BargainModel:NpcPlay(strategy)
    if strategy == BargainEnum.Strategy.Random then
        return _random(BargainEnum.Choice.Up, BargainEnum.Choice.Under)

    elseif strategy == BargainEnum.Strategy.Up then
        return BargainEnum.Choice.Up

    elseif strategy == BargainEnum.Strategy.Under then
        return BargainEnum.Choice.Under

    elseif strategy == BargainEnum.Strategy.Last then
        if self.curRound <= 1 then
            LogError("[砍价玩法, 逻辑错误]在第一回合中, 选择了上一回合的策略")
            return nil
        end
        local npcChoice = nil
        for i = self.curRound - 1, 1, -1 do
            if self.playerChoice[i] ~= BargainEnum.Choice.NoChoice then
                npcChoice = self.playerChoice[i]
                break
            end
        end
        if not npcChoice then
            LogInfo("没有找到玩家的上一次选择, Npc选择了自身上一次的牌")
            npcChoice = self.npcChoice[self.curRound - 1]
        end
        
        return npcChoice

    elseif strategy == BargainEnum.Strategy.ContraryLast then
        if self.curRound <= 1 then
            LogError("[砍价玩法, 逻辑错误]在第一回合中, 选择了上一回合相反的策略")
            return nil
        end
        local npcChoice = nil
        for i = self.curRound - 1, 1, -1 do
            if self.playerChoice[i] ~= BargainEnum.Choice.NoChoice then
                if self.playerChoice[i] == BargainEnum.Choice.Up then
                    npcChoice = BargainEnum.Choice.Under
                elseif self.playerChoice[i] == BargainEnum.Choice.Under then
                    npcChoice = BargainEnum.Choice.Up
                else
                    LogError(string.format("[砍价玩法, 逻辑错误]在第%d回合中, 玩家出了不存在的牌, 牌面%d", self.curRound, self.playerChoice[i]))
                end
                break
            end
        end

        if not npcChoice then
            LogInfo("没有找到玩家的上一次选择, Npc选择了自身上一次的牌")
            npcChoice = self.npcChoice[self.curRound - 1]
        end

        return npcChoice
    else
        LogError("未配置的性格")
    end
end

function BargainModel:GetChoice()
    return self.playerChoice, self.npcChoice
end

function BargainModel:Reset()
    self.isReady = false
    self.isGame = false

    self.curRound = 0
    self.sumRound = 0

    TableUtils.ClearTable(self.playerChoice)
    TableUtils.ClearTable(self.npcChoice)
end