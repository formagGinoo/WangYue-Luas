ClickHackingButtonBar = BaseClass("ClickHackingButtonBar", BaseHackingButtonBar)

function ClickHackingButtonBar:__Init()
end

function ClickHackingButtonBar:Init(fight, entity, config, title)
    self.config = config[title .. "HackingClickType"]
    if not self.config or (not self.config.ButtonIcon or self.config.ButtonIcon == "") then
        self.config = 
        {
            ButtonIcon = config[title .. "Button"],
            HackingButtonName = "",
            HackingRam = 0,
            HackCostElectricity = 0,
            HackingDesc = "",
        }
    end
    self.fight = fight
    self.entity = entity
    self.enable = true
end

function ClickHackingButtonBar:GetButtonConfig()
    if not self:GetEnable() then
        return HackingConfig.NullHackButtonConfig
    end

    return {icon = self.config.ButtonIcon, Name = self.config.HackingButtonName or "", hackingRam = self.config.HackingRam or 0, hackingDesc = self.config.HackingDesc or ""}
end

function ClickHackingButtonBar:CallBehavior()

end

function ClickHackingButtonBar:GetCostRam()
    if not self:GetEnable() then
        return 0
    end

    return self.config.HackingRam or 0
end

function ClickHackingButtonBar:GetCostElectricity()
    if not self:GetEnable() then
        return 0
    end

    return self.config.HackCostElectricity
end

function ClickHackingButtonBar:SetActiveState(flag)
    
end

function ClickHackingButtonBar:GetEnable()
    return self.enable and (self.config.ButtonIcon and self.config.ButtonIcon ~= "")
end

function ClickHackingButtonBar:OnCache()
    self.fight.objectPool:Cache(ClickHackingButtonBar, self)
end

function ClickHackingButtonBar:__cache()

end

function ClickHackingButtonBar:__delete()

end