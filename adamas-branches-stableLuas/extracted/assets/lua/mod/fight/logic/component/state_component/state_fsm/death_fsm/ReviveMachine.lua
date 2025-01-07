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

    if self.entity.animatorComponent then
		self.entity.animatorComponent:PlayAnimation(Config.EntityCommonConfig.AnimatorNames.Idle)
	end

    --角色复活时，把角色的和佩丛的entitySign都给加回去
    self.entity:AddEntitySignAndMagicRecord()
    --加上佩丛身上的entitySign
    local info = Fight.Instance.playerManager:GetPlayer():GetEntityInfo(self.entity.instanceId)
    if info then
        local partnerEntity = BehaviorFunctions.GetEntity(info.Partner)
        if partnerEntity then
            partnerEntity:AddEntitySignAndMagicRecord()
        end
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