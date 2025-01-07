NpcInputHandle = BaseClass("NpcInputHandle", BaseInputHandle)

function NpcInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.config = config
end

function NpcInputHandle:Hacking()
end

function NpcInputHandle:StopHacking()
end

function NpcInputHandle:ClickLeft(down)
	if not down then
		EventMgr.Instance:Fire(EventName.ExitHackingMode)
	end
end

function NpcInputHandle:Update()
end