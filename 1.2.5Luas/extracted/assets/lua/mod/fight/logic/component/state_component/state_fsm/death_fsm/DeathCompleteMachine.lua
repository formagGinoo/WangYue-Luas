DeathCompleteMachine = BaseClass("DeathCompleteMachine", MachineBase)

function DeathCompleteMachine:__init()

end

function DeathCompleteMachine:Init(fight, entity, deathFSM)
	self.fight = fight
	self.entity = entity
    self.deathFSM = deathFSM

	self.death = false
	self.changeIndex = 0
	self.changeEntity = nil
	self.removeEntity = true		-- 是否是玩家
	self.formatRevive = false		-- 是否编队复活
	self.changeTime = entity:GetComponentConfig(FightEnum.ComponentType.State).DeathTime or 0
end

function DeathCompleteMachine:OnEnter()
	self.entity.transformComponent:Async()
	
	self.death = false
	self.fight.entityManager:CallBehaviorFun("DeathEnter", self.entity.instanceId)
	self.remainChangeTime = self.changeTime
	if not self.remainChangeTime then
		self.remainChangeTime = 0
	end
	
end

function DeathCompleteMachine:BeforeDeath()
	if self.entity.buffComponent then
		self.entity.buffComponent:RemoveAllBuff()
	end

	if self.entity.partComponent then
		self.entity.partComponent:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
	end

	self.removeEntity = true
	local player = self.fight.playerManager:GetPlayer()
	for i = 1, #player.entityInfos do
		if self.entity.instanceId == player.entityInfos[i].InstanceId then
			self.removeEntity = false
			break
		end
	end

	if not self.removeEntity then
		self.formatRevive = true
		local formation = mod.FormationCtrl:GetCurFormationInfo()
		if #formation.roleList == 1 then
			return
		end

		self.changeIndex = 0
		self.changeEntity = nil

		local selfIndex = 0
		for i = 1, #formation.roleList do
			if formation.roleList[i] ~= self.entity.masterId then
				local entity = player:GetQTEEntityObject(i)
				local isEntityDeath = entity.stateComponent:IsState(FightEnum.EntityState.Death)
				if not isEntityDeath and ((selfIndex == 0 and self.changeIndex == 0) or (selfIndex ~= 0 and i > self.changeIndex)) then
					self.changeIndex = i
					self.changeEntity = entity
				end

				if not isEntityDeath then
					self.formatRevive = false
				end
			else
				selfIndex = i
			end
		end
	end
end

function DeathCompleteMachine:OnDeath()
	local deathReason = self.deathFSM.deathReason
	if not self.removeEntity then
		-- TODO 测试逻辑
		if self.formatRevive then
			local isDup = mod.WorldMapCtrl:CheckIsDup()
			if not isDup then
				WindowManager.Instance:OpenWindow(WorldFailWindow, {isDup})
			end
		else
			if deathReason ~= FightEnum.DeathReason.Damage or self.changeIndex == 0 then
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

				-- TODO 测试逻辑
				if ctx then
					LoadPanelManager.Instance:FakeLoading(1)
				end
			elseif deathReason == FightEnum.DeathReason.Damage then
				if self.changeIndex ~= 0 then
					self.fight.entityManager:CallBehaviorFun("ChangeRole", self.changeIndex, self.entity.instanceId, self.changeEntity.instanceId)
				end
			end
		end
	end
	self.fight.entityManager:CallBehaviorFun("Death", self.entity.instanceId, self.formatRevive)
	EventMgr.Instance:Fire(EventName.OnEntityDeath, self.entity.instanceId, deathReason)
	if ctx and self.entity.sInstanceId then
		--EventMgr.Instance:Fire(EventName.EntityHit, self.entity.instanceId, false)
	end
end

function DeathCompleteMachine:AfterDeath()
	self.death = true
	if self.removeEntity then
		if self.entity.sInstanceId then
			EventMgr.Instance:Fire(EventName.EntityHit, self.entity.instanceId, false)
		else
			self.fight.entityManager:RemoveEntity(self.entity.instanceId)
		end
	end
end

function DeathCompleteMachine:OnLeave()
	self.changeIndex = 0
	self.changeEntity = nil
	self.removeEntity = false
end

function DeathCompleteMachine:Update()
	self.remainChangeTime = self.remainChangeTime - FightUtil.deltaTime / 10000 * self.entity.timeComponent:GetTimeScale()
	if self.remainChangeTime <= 0 and not self.death then
		self:BeforeDeath()
		self:OnDeath()
		self:AfterDeath()
	end
end

function DeathCompleteMachine:CanMove()
	return false
end

function DeathCompleteMachine:CanCastSkill()
	return false
end

function DeathCompleteMachine:CanJump()
	return false
end

function DeathCompleteMachine:OnCache()
	self.fight.objectPool:Cache(DeathCompleteMachine,self)
end

function DeathCompleteMachine:__cache()

end

function DeathCompleteMachine:__delete()

end