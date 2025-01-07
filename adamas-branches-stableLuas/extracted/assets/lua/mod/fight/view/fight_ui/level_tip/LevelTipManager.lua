LevelTipManager = BaseClass("LevelTipManager")

function LevelTipManager:__init(clientFight)
    self.fight = clientFight.fight
end

function LevelTipManager:PlayBackGroundText(id)
    PanelManager.Instance:OpenPanel(LevelTipPanel, id)
end

function LevelTipManager:BackGroundEnd(id)
    self.fight.entityManager:CallBehaviorFun("BackGroundEnd", id)
end