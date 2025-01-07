ActiveHackingButtonBar = BaseClass("ActiveHackingButtonBar", BaseHackingButtonBar)

function ActiveHackingButtonBar:__Init()
end

function ActiveHackingButtonBar:Init(fight, entity, config, title)
    self.config = config[title .. "HackingActiveType"]
    self.fight = fight
    self.entity = entity
    self.callFuncName = title .. "HackingActive"
    self.active = false
    self.enable = true
end

function ActiveHackingButtonBar:GetButtonConfig()
    if not self:GetEnable() then
        return HackingConfig.NullHackButtonConfig
    end

    if self.active then
        return {icon = self.config.ActiveButtonIcon, Name = self.config.ActiveHackingButtonName or "", hackingRam = self.config.ActiveHackingRam or 0, hackingDesc = self.config.HackingDesc or ""}
    else
        return {icon = self.config.UnActiveButtonIcon, Name = self.config.UnActiveHackingButtonName or "", hackingRam = self.config.UnActiveHackingRam or 0, hackingDesc = self.config.HackingDesc or ""}
    end
end

function ActiveHackingButtonBar:CallBehavior()
    if not self:GetEnable() then
        return
    end

    if self.callFuncName then
        self.fight.entityManager:CallBehaviorFun(self.callFuncName, self.entity.instanceId, self.active)
    end
end

function ActiveHackingButtonBar:GetCostRam()
    if not self:GetEnable() then
        return 0
    end

    if self.active then
        return self.config.ActiveHackingRam or 0
    else
        return self.config.UnActiveHackingRam or 0
    end
end

function ActiveHackingButtonBar:GetCostElectricity()
    return 0
end

function ActiveHackingButtonBar:SetActiveState(flag)
    self.active = flag
end

function ActiveHackingButtonBar:GetEnable()
    if self.enable then
        if self.active then
            return self.config.ActiveButtonIcon and self.config.ActiveButtonIcon ~= ""
        else
            return self.config.UnActiveButtonIcon and self.config.UnActiveButtonIcon ~= ""
        end
    else
        return false
    end
end

function ActiveHackingButtonBar:OnCache()
    self.fight.objectPool:Cache(ActiveHackingButtonBar, self)
end

function ActiveHackingButtonBar:__cache()

end

function ActiveHackingButtonBar:__delete()

end