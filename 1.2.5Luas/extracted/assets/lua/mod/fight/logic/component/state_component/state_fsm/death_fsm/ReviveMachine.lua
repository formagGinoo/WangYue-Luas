ReviveMachine = BaseClass("ReviveMachine", MachineBase)

local DataGlobal = Config.DataGlobal.data_global

function ReviveMachine:__init()
    self.isTransport = false
end

function ReviveMachine:Init(fight, entity, deathFSM)
    self.fight = fight
    self.entity = entity
    self.deathFSM = deathFSM
    self.reviveTime = entity:GetComponentConfig(FightEnum.ComponentType.State).ReviveTime
end

function ReviveMachine:OnEnter(isTransport, reviveValue)
    self.duration = self.reviveTime
    self.isTransport = isTransport
    if not self.duration then
        self.duration = 0
    end

    self.fight.entityManager:CallBehaviorFun("Revive", self.entity.instanceId, self.entity.entityId)
    self.fight.levelManager:CallBehaviorFun("Revive", self.entity.instanceId, self.entity.entityId)
	self.fight.taskManager:CallBehaviorFun("Revive", self.entity.instanceId, self.entity.entityId)

    if self.entity.partComponent then
        self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.Entity)
    end

    if self.entity.clientEntity.clientAnimatorComponent then
        self.entity.clientEntity.clientAnimatorComponent:SetTimeScale(1)
    end

	local _, maxLife = self.entity.attrComponent:GetValueAndMaxValue(EntityAttrsConfig.AttrType.Life)
	local reviveLife = reviveValue
    if not reviveLife then
        reviveLife = maxLife * 0.0001 * DataGlobal.ReviveLife.ivalue
    end

    reviveLife = math.min(reviveLife, maxLife)
	self.entity.attrComponent:AddValue(EntityAttrsConfig.AttrType.Life, reviveLife)

	if self.entity.deathComponent then
		self.entity.deathComponent.isDeath = false
	end

	EventMgr.Instance:Fire(EventName.Revive, self.entity.instanceId)
end

function ReviveMachine:Update()
    if self.duration <= 0 then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
    end

    self.duration = self.duration - FightUtil.deltaTime / 10000
end

function ReviveMachine:OnLeave()
    mod.FormationCtrl:SyncServerProperty(self.entity.instanceId)
    if self.isTransport then
        self.isTransport = false
        local transFunc = function ()
			--LoadPanelManager.Instance:FakeLoading(1)
            local transportPoint = mod.WorldCtrl:GetNearByTransportPoint()
            local mapId = self.fight:GetFightMap()
            local mapConfig = mod.WorldMapCtrl:GetMapConfig(mapId)
            if not transportPoint then
                -- TODO 临时写的位置
                local pos = mod.WorldMapCtrl:GetMapPositionConfig(mapConfig.level_id, "PlayerBorn1", "Logic10020001_1")
                BehaviorFunctions.Transport(mapId, pos.x, pos.y, pos.z)
                return
            end

            mod.WorldMapCtrl:SendMapTransport(mapConfig.level_id, transportPoint)
        end
        LuaTimerManager.Instance:AddTimer(1, 0.1, transFunc)
    end
end

function ReviveMachine:CanHit()
    return false
end

function ReviveMachine:CanMove()
	return false
end

function ReviveMachine:CanCastSkill()
	return false
end

function ReviveMachine:CanJump()
	return false
end

function ReviveMachine:OnCache()
	self.fight.objectPool:Cache(ReviveMachine, self)
end

function ReviveMachine:__cache()
    self.isTransport = false
end

function ReviveMachine:__delete()
    self.isTransport = false
end