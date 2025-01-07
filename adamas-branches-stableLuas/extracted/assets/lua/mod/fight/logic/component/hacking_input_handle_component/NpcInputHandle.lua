NpcInputHandle = BaseClass("NpcInputHandle", BaseInputHandle)

function NpcInputHandle:Init(fight, entity, config)
    self.fight = fight
    self.entity = entity
    self.config = config

    self.hackMailState = false
    self.hackPhoneCallState = false

    if self.fight.entityManager.npcEntityManager:CheckNpcMailState(self.entity.sInstanceId) then
        self.entity.hackingInputHandleComponent:SetHackingButtonEnable(HackingConfig.HackingKey.Up, true)
    else
        self.entity.hackingInputHandleComponent:SetHackingButtonEnable(HackingConfig.HackingKey.Up, false)
    end

    if self.fight.entityManager.npcEntityManager:CheckNpcCallState(self.entity.sInstanceId) then
        self.entity.hackingInputHandleComponent:SetHackingButtonEnable(HackingConfig.HackingKey.Down, true)
    else
        self.entity.hackingInputHandleComponent:SetHackingButtonEnable(HackingConfig.HackingKey.Down, false)
    end

    EventMgr.Instance:AddListener(EventName.NpcMailStateChange, self:ToFunc("OnNpcMailStateChange"))
    EventMgr.Instance:AddListener(EventName.NpcCallStateChange, self:ToFunc("OnNpcCallStateChange"))
end

function NpcInputHandle:Hacking()
end

function NpcInputHandle:ClickUp(down)
    if not down then
        return
    end
	
	if self.hackMailState then
		self:StopHacking()
		return
		
	end
    
    if not self.fight.entityManager.npcEntityManager:CheckNpcMailState(self.entity.sInstanceId) then
        return
    end

    local mailId = self.fight.entityManager.npcEntityManager:GetNpcMailId(self.entity.sInstanceId)
    if not mailId then
        return
    end

    self.hackMailState = not self.hackMailState
	EventMgr.Instance:Fire(EventName.HackStateChange, self.entity.instanceId, self.config.HackingType)
    EventMgr.Instance:Fire(EventName.HackMail, self.entity.instanceId, mailId, self.hackMailState)
end

function NpcInputHandle:ClickDown(down)
    if not down then
        return
    end
	
	if self.hackPhoneCallState then
		self:StopHacking()
		return
	end

    if not self.fight.entityManager.npcEntityManager:CheckNpcCallState(self.entity.sInstanceId) then
        return
    end

    local callId = self.fight.entityManager.npcEntityManager:GetNpcCallId(self.entity.sInstanceId)
    if not callId then
        return
    end

    self.hackPhoneCallState = not self.hackPhoneCallState
	EventMgr.Instance:Fire(EventName.HackStateChange, self.entity.instanceId, self.config.HackingType)
    EventMgr.Instance:Fire(EventName.HackPhoneCall, self.entity.instanceId, callId, self.hackPhoneCallState)
end

function NpcInputHandle:StopHacking(nextHackId)
    if self.hackPhoneCallState then
        self.hackPhoneCallState = false
        EventMgr.Instance:Fire(EventName.HackPhoneCall, self.entity.instanceId, nil, self.hackPhoneCallState)
    end

    if self.hackMailState then
        self.hackMailState = false
        EventMgr.Instance:Fire(EventName.HackMail, self.entity.instanceId, nil, self.hackMailState)
    end
	
    --EventMgr.Instance:Fire(EventName.ExitHackingMode)
	--EventMgr.Instance:Fire(EventName.HackStateChange)
end

function NpcInputHandle:GetUpOperateState()
	if not self.fight.entityManager.npcEntityManager:CheckNpcMailState(self.entity.sInstanceId) then
		return FightEnum.HackOperateState.Forbidden
	end
	
	return self.hackMailState and FightEnum.HackOperateState.Continue or FightEnum.HackOperateState.Normal
end

function NpcInputHandle:GetDownOperateState()
	if not self.fight.entityManager.npcEntityManager:CheckNpcCallState(self.entity.sInstanceId) then
		return FightEnum.HackOperateState.Forbidden
	end
	
	return self.hackPhoneCallState and FightEnum.HackOperateState.Continue or FightEnum.HackOperateState.Normal
end

function NpcInputHandle:OnNpcMailStateChange(sInstanceId, state)
    if self.entity.sInstanceId == sInstanceId then
        self.entity.hackingInputHandleComponent:SetHackingButtonEnable(HackingConfig.HackingKey.Up, state)
    end
end

function NpcInputHandle:OnNpcCallStateChange(sInstanceId, state)
    if self.entity.sInstanceId == sInstanceId then
        self.entity.hackingInputHandleComponent:SetHackingButtonEnable(HackingConfig.HackingKey.Down, state)
    end
end

function NpcInputHandle:OnCache()
    EventMgr.Instance:RemoveListener(EventName.NpcMailStateChange, self:ToFunc("OnNpcMailStateChange"))
    EventMgr.Instance:RemoveListener(EventName.NpcCallStateChange, self:ToFunc("OnNpcCallStateChange"))

    self.fight.objectPool:Cache(NpcInputHandle, self)
end