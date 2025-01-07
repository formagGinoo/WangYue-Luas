MercenaryEcoCtrlManager = BaseClass("MercenaryEcoCtrlManager")

local EnterHuntAreaMap = {
    none = 0,
    enter = 1,
    exit = 2,
}


function MercenaryEcoCtrlManager:__init(mercenaryHuntManager)
    self.mercenaryMgr = mercenaryHuntManager
    self.fight = self.mercenaryMgr.fight
    self.clientFight = self.mercenaryMgr.clientFight
    self.mercenaryHuntCtrl = mod.MercenaryHuntCtrl

    self.isEnterState = EnterHuntAreaMap.none
    self.ecoCtrlMap = {}
end

function MercenaryEcoCtrlManager:__delete()
end

function MercenaryEcoCtrlManager:AddMercenaryCtrl(ecoId)
    local ctrl = self.fight.objectPool:Get(MercenaryEcoCtrl)
    ctrl:InitData(self, ecoId)
    self.ecoCtrlMap[ecoId] = ctrl
end

function MercenaryEcoCtrlManager:Update()
    self.curEntity = BehaviorFunctions.GetCtrlEntity()
    self:UpdatePlayEnterHuntArea()
    for _, ctrl in pairs(self.ecoCtrlMap) do
        ctrl:Update()
    end
end

function MercenaryEcoCtrlManager:UpdatePlayEnterHuntArea()
    local len = TableUtils.GetTabelLen(self.ecoCtrlMap)
    if len <= 0 then
        self.isEnterState = EnterHuntAreaMap.none
        return
    end
    
    if not self.curEntity then return end
    local position = BehaviorFunctions.GetPositionP(self.curEntity)
    local isEnter = BehaviorFunctions.IsMercenaryHuntArea(position)
    local newState = isEnter and EnterHuntAreaMap.enter or EnterHuntAreaMap.exit
    
    if newState ~= self.isEnterState then
        self.fight.entityManager:CallBehaviorFun("MercenaryHuntAreaState", isEnter)
    end

    self.isEnterState = newState
end

function MercenaryEcoCtrlManager:KillMercenary(ecoId)
    self.ecoCtrlMap[ecoId] = nil
end

function MercenaryEcoCtrlManager:GetMercenaryEco(ecoId)
    return self.ecoCtrlMap[ecoId]
end