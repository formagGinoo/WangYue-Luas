---@class Player
---@field fight Fight
---@field entityInfos entityInfo[]
Player = BaseClass("Player")

local DataHeroMain = Config.DataHeroMain.Find

function Player:__init()
	self.resCount = 0
	self.loadCount = 0
	self.cacheRole = {}

	self.propertyList = {}
	self.updatePlayerInfoTime = 0

	EventMgr.Instance:AddListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
	EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
end

function Player:Init(fight,playerId,heroIds)
	self.fight = fight
	self.playerId = playerId
	self.heroIds = heroIds
	self.ctrlId = 2
	-- 在更换玩家顺序的时候需要更新获取的玩家列表
	self.needChangeList = false
	-- 角色列表
	self.entityList = nil

	self.fightPlayer = FightPlayer.New()
	self.fightPlayer:Init(self)

	-- 记录位置 在临时控制其他实体的时候保存最后一帧的位置
	self.playerPosRecord = nil
	self.playerRotRecord = nil
end

function Player:StartFight(pos, callBack)
	self.entityInfos = {}
	self:InitCommonEntity()
	self.fightPlayer:InitTalent()
	self:UpdateEntityInfos(mod.RoleCtrl:GetCurUseRole(), pos, callBack,true)
end

function Player:ChangeHeroList(heroIds)
	self.needChangeList = true

	self.cacheRole = self.cacheRole or {}
	local ignoreRole = {}
	for i = 1, #heroIds do
		for k = 1, #self.heroIds do
			if heroIds[i] == self.heroIds[k] then
				self.cacheRole[heroIds[i]] = TableUtils.CopyTable(self.entityInfos[k])
				ignoreRole[heroIds[i]] = true
				break
			end
		end
	end

	local oldHeroIds = self.heroIds or {}
	self.heroIds = TableUtils.CopyTable(heroIds)

	local curPos = nil
	local curHeroId = mod.RoleCtrl:GetCurUseRole()

	self:LoadRoleAsset(self.heroIds, ignoreRole, function ()
		for i = #self.entityInfos, 1, -1 do
			local entityInfo = table.remove(self.entityInfos)
			local entity = self.fight.entityManager:GetEntity(entityInfo.InstanceId)
			if entity.instanceId == self.ctrlId then
				curPos = { x = entity.transformComponent.position.x, y = entity.transformComponent.position.y, z = entity.transformComponent.position.z }
			end

			if not self.cacheRole[entityInfo.HeroId] then
				mod.FormationCtrl:SyncServerProperty(entity.instanceId)
				entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
				if entityInfo.Partner then
					self.fight.entityManager:RemoveEntity(entityInfo.Partner)
				end
				self.fight.entityManager:RemoveEntity(entity.instanceId)
			end
		end
		self:UpdateEntityInfos(curHeroId, curPos)
		self:UnLoadRoleAsset(oldHeroIds, ignoreRole)
	end)
end

function Player:LoadRoleAsset(heroIds, ignoreRole, callback)
	local loadCount = 1
	local onLoad = function ()
		loadCount = loadCount - 1
		if loadCount == 0 then
			if callback then
				callback()
			end
		end
	end
	for i = 1, #heroIds, 1 do
		if not ignoreRole[heroIds[i]] then
			loadCount = loadCount + 1
			self.fight.clientFight.assetsNodeManager:LoadRole(self.playerId, heroIds[i], onLoad)
		end
	end

	onLoad()
end

function Player:UnLoadRoleAsset(heroIds, ignoreRole)
	for i = 1, #heroIds, 1 do
		if not ignoreRole[heroIds[i]] then
			self.fight.clientFight.assetsNodeManager:UnLoadRole(self.playerId, heroIds[i])
		end
	end
end

function Player:Update()
	self.fightPlayer:Update()
	if not self.ctrlId then return end

	self.updatePlayerInfoTime = self.updatePlayerInfoTime + 1
	if self.updatePlayerInfoTime < 150 then return end

	self.updatePlayerInfoTime = 0
	local entity = self.fight.entityManager:GetEntity(self.ctrlId)
	if not entity then return end

	-- 同步角色属性
	if entity.masterId then
		mod.FormationCtrl:SyncServerProperty(self.ctrlId)
	end

	-- 同步角色位置 滞空和骇入状态不同步位置
	if not entity.values["HackingCamera"] and not entity.moveComponent.isAloft then
		local position = entity.transformComponent.position
		local syncPos = {
			pos_x = math.floor(position.x * 10000),
			pos_y = math.floor(position.y * 10000),
			pos_z = math.floor(position.z * 10000)
		}
		mod.WorldFacade:SendMsg("map_sync_position", {mapId = self.fight:GetFightMap(), position = syncPos})
	end
end

function Player:UpdateEntityInfos(curHeroId, bornPos, callBack, firstCreate)
	local curInstanceId = nil
	for i = 1, #self.heroIds do
		if self.cacheRole[self.heroIds[i]] then
			self.entityInfos[i] = TableUtils.CopyTable(self.cacheRole[self.heroIds[i]])
			local entityInfo = self.entityInfos[i]
			local entity = BehaviorFunctions.GetEntity(entityInfo.InstanceId)
			if entity.masterId ~= curHeroId then
				entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
			else
				curInstanceId = entity.instanceId
			end
		else
			local entity = self.fight.entityManager:CreateEntity(DataHeroMain[self.heroIds[i]].entity_id, nil, self.heroIds[i])
			local partnerEntityId = mod.RoleCtrl:GetRolePartnerEntityId(self.heroIds[i])
			local partnerInstanceId
			if partnerEntityId then
				local partnerEntity = self.fight.entityManager:CreateEntity(partnerEntityId, entity)
				partnerEntity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
				partnerInstanceId = partnerEntity.instanceId
			end
			entity.masterId = self.heroIds[i]
			---@class entityInfo
			local entityInfo = {
				HeroId = self.heroIds[i],
				InstanceId = entity.instanceId,
				EntityId = entity.entityId,
				Partner = partnerInstanceId,
				QTETime = 0,
				SwitchTime = 0,
				QTEState = 1,
				SwitchState = 1,
			}
			self.entityInfos[i] = entityInfo
			
			if partnerInstanceId then
				self:ChangePartnerSkill(entity.instanceId)
			end

			if entity.masterId == curHeroId or (i == #self.heroIds and not curInstanceId) then
				local opEntity = (entity.masterId == curHeroId) and entity or self.fight.entityManager:GetEntity(self.entityInfos[1].InstanceId)
				curInstanceId = opEntity.instanceId
			else
				entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
			end
			local uniqueId = mod.RoleCtrl:GetRoleWeapon(self.heroIds[i])
			local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, self.heroIds[i])
			self:EquipWeapon(self.heroIds[i], weaponData, true, false)
			
			local partnerUniqueId = mod.RoleCtrl:GetRolePartner(self.heroIds[i])
			if partnerUniqueId ~= 0 then
				local partnerData = mod.BagCtrl:GetPartnerData(partnerUniqueId)
				self:EquipPartner(self.heroIds[i], partnerData)
			end
			self:InitRoleSkillAttr(self.heroIds[i])

			self:ApplyServerAttr(self.heroIds[i])
		end
	end

	if self.ctrlId ~= curInstanceId or firstCreate then
		self.ctrlId = curInstanceId
		local opEntity = BehaviorFunctions.GetEntity(curInstanceId)
		opEntity.transformComponent:SetPosition(bornPos.x, bornPos.y, bornPos.z)
		opEntity.stateComponent:ChangeBackstage(FightEnum.Backstage.Foreground)
		if not callBack then
			callBack = function ()
				return 1
			end
		end
	
		local transform = opEntity.clientEntity.clientTransformComponent.transform
		self.fight.clientFight.cameraManager:SetMainTarget(transform)
		BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
		opEntity.clientEntity.clientTransformComponent:SetMainRole(true)
		if BehaviorFunctions.IsPause() then
			opEntity.clientEntity.clientAnimatorComponent:SaveTimeScale(1)
		end
		local terrainInitCallback = function()
			self.fight.clientFight.clientMap:SetTerrianFollow(transform)
			CustomUnityUtils.SetLookAtPlayer(transform, tostring(opEntity.instanceId))
			SceneUnitManager.Instance:SetTargetTransform(transform)
			--BlockManager.Instance:SetTargetTransform(transform)
			SceneUnitManager.Instance:DoEnterLoad(callBack, self.fight.clientFight.clientMap.transform, bornPos.x, bornPos.y, bornPos.z, AssetBatchLoader.UseLocalRes)
		end
		self.fight.clientFight.clientMap:LoadTerrian(bornPos.x, bornPos.y, bornPos.z, terrainInitCallback)
	
		opEntity.stateComponent:SetState(FightEnum.EntityState.Born)
	end

	TableUtils.ClearTable(self.cacheRole)

	EventMgr.Instance:Fire(EventName.PlayerUpdate, true)
end

function Player:InitCommonEntity()
	local commonEntity = {2000}
	for i = 1, #commonEntity do
		local entity = self.fight.entityManager:CreateEntity(commonEntity[i])
	end
	self.ctrlId = #commonEntity + 1
end

function Player:IsMyEntity(instanceId)
	for k, v in pairs(self.entityInfos) do
		if v.InstanceId == instanceId then
			return true
		end
	end
	return false
end

function Player:GetQTEEntity(index)
	local entityInfo = self.entityInfos[index]
	if not entityInfo then
		return
	end

	return entityInfo.InstanceId
end

function Player:GetQTEEntityInfo(index)
	local entityInfo = self.entityInfos[index]
	if not entityInfo then
		return
	end
	return entityInfo
end

function Player:GetEntityQTEIndex(instanceId)
	for i = 1, #self.entityInfos do
		local entityInfo = self.entityInfos[i]
		if entityInfo.InstanceId == instanceId then
			return i, true
		end
	end
	return 1, false
end

function Player:SetQTEState(index, type, state)
	local entityInfo = self.entityInfos[index]
	if type == 1 then
		entityInfo.QTEState = state
	elseif type == 2 then
		entityInfo.SwitchState = state
	end
end

function Player:GetQTEEntityObject(index)
	local entityInfo = self.entityInfos[index]
	if not entityInfo or not self.fight.entityManager then
		return
	end

	return self.fight.entityManager:GetEntity(entityInfo.InstanceId)
end

function Player:AddTime(index, type, time)
	local entityInfo = self.entityInfos[index]
	if type == 1 then
		entityInfo.QTETime = entityInfo.QTETime + time / FightUtil.deltaTime * 10000
	elseif type == 2 then
		entityInfo.SwitchTime = entityInfo.SwitchTime + time / FightUtil.deltaTime * 10000
	end
end

function Player:SetTime(index, type, time)
	local entityInfo = self.entityInfos[index]
	if type == 1 then
		entityInfo.QTETime = self.fight.fightFrame + time / FightUtil.deltaTime * 10000
	elseif type == 2 then
		entityInfo.SwitchTime = self.fight.fightFrame + time / FightUtil.deltaTime * 10000
		entityInfo.SwitchCDTime = time
	end
end

--1可用，2不可用，3冷却中,4，激活标记（策划自行定义）
function Player:GetState(index,type)
	local entityInfo = self.entityInfos[index]
	if type == 1 then
		if entityInfo.QTEState == 2 then
			return 2
		else
			return self.fight.fightFrame > entityInfo.QTETime and entityInfo.QTEState or 3
		end
	elseif type == 2 then
		if entityInfo.SwitchState == 2 then
			return 2
		else
			return self.fight.fightFrame > entityInfo.SwitchTime and entityInfo.SwitchState or 3
		end
	end
end

function Player:CheckState(index,type,state)
	return self:GetState(index,type) == state
end

function Player:SetCtrlEntity(instanceId)
	CameraManager.Instance:SetEntityEffectVisible(self.ctrlId, false)

	self.ctrlId = instanceId
	local curEntity = self:GetCtrlEntityObject()

	curEntity:RemoveTrigger()
	CameraManager.Instance:SetEntityEffectVisible(self.ctrlId, true)

	local entity = self.fight.entityManager:GetEntity(instanceId)
	entity.clientEntity.clientTransformComponent:SetMainRole(true)
	self.fight.clientFight.cameraManager:SetMainTarget(entity.clientEntity.clientTransformComponent.transform)
	self.fight.clientFight.clientMap:SetTerrianFollow(entity.clientEntity.clientTransformComponent.transform)
	EventMgr.Instance:Fire(EventName.PlayerUpdate)

	SceneUnitManager.Instance:SetTargetTransform(curEntity.clientEntity.clientTransformComponent.transform)
	CustomUnityUtils.SetLookAtPlayer(curEntity.clientEntity.clientTransformComponent.transform, tostring(instanceId))

	mod.RoleFacade:SendMsg("hero_use", curEntity.masterId)

	self.fight.entityManager:CallEntityFun("OnSwitchPlayerCtrl")
	EventMgr.Instance:Fire(EventName.SetCurEntity, curEntity)
end

-- 第二个参数代表是不是角色本体
function Player:GetCtrlEntity()
	return self.ctrlId
end

function Player:GetCtrlEntityObject()
	return self.fight.entityManager:GetEntity(self.ctrlId)
end

function Player:SetPosNRotRecord()
	local ctrlEntity = BehaviorFunctions.GetEntity(self.ctrlId)
	local pos = ctrlEntity.transformComponent:GetPosition()
	local rot = ctrlEntity.transformComponent:GetRotation()

	self.playerPosRecord = Vec3.New(pos.x, pos.y, pos.z)
	self.playerRotRecord = Quat.New(rot.x, rot.y, rot.z, rot.w)
end

function Player:GetRecordPosition()
	return self.playerPosRecord
end

function Player:GetRecordRotation()
	return self.playerRotRecord
end

function Player:SyncBaseCommonAttr(srcInstanceId, attrType, attrValue)
	for k, v in pairs(self.entityInfos) do
		if v.InstanceId ~= srcInstanceId then
			local entity = self.fight.entityManager:GetEntity(v.InstanceId)
			entity.attrComponent:SyncBaseCommonAttr(attrType, attrValue)
		end
	end

	if srcInstanceId ~= self.ctrlId then
		local entity = self.fight.entityManager:GetEntity(self.ctrlId)
		entity.attrComponent:SyncBaseCommonAttr(attrType, attrValue)
	end
end

function Player:SetBackState(instanceId,state)
	local entity = self.fight.entityManager:GetEntity(instanceId)
	if entity.stateComponent.backstage == state then
		return
	end
	
	--清理部分数据
	entity.rotateComponent:OnSetBackStage()
	entity.stateComponent:ChangeBackstage(state)
end

function Player:GetEntityCount()
	return #self.entityInfos
end

function Player:SetPlayerBorn(x, y, z)
	local entity = self.fight.entityManager:GetEntity(self.ctrlId)
	entity.transformComponent:SetPosition(x,y,z)

	local entityInfoHelp = self.entityInfos[1]
	if entityInfoHelp then
		local entityHelp = self.fight.entityManager:GetEntity(entityInfoHelp.InstanceId)
		-- 待扩展
		entityHelp.transformComponent:SetPosition(x, y, z)
		entityHelp.rotateComponent.rotation = entity.rotateComponent.rotation
	end
end

function Player:UseItem(index, magicId)
	local heroId = self.heroIds[index]
	local entityInfo = nil
	for k, v in pairs(self.entityInfos) do
		if v.HeroId == heroId then
			entityInfo = v
			break
		end
	end

	if not entityInfo or not next(entityInfo) then
		return
	end

	local entity = self.fight.entityManager:GetEntity(entityInfo.InstanceId)
	local magic = MagicConfig.GetMagic(magicId, entity.entityId)
	local buff = MagicConfig.GetBuff(magicId, entity.entityId)
	if magic then
		return self.fight.magicManager:DoMagic(magic, nil, entity, entity, false)
	elseif buff then
		return entity.buffComponent:AddBuff(entity, magicId, 1, entity)
	end
end

function Player:UseItemForAll(magicId)
	for k, v in pairs(self.entityInfos) do
		local entity = self.fight.entityManager:GetEntity(v.InstanceId)
		local magic = MagicConfig.GetMagic(magicId, v.EntityId)
		local buff = MagicConfig.GetBuff(magicId, v.EntityId)
		if magic then
			self.fight.magicManager:DoMagic(magic, nil, entity, entity, false)
		elseif buff then
			entity.buffComponent:AddBuff(entity, magicId, 1, entity)
		end
	end
end

function Player:GetEntityList()
	if not self.needChangeList and self.entityList and next(self.entityList) then
		return self.entityList
	end

	local entityList = {}
	for i = 1, #self.heroIds do
		local heroId = self.heroIds[i]
		for k, v in pairs(self.entityInfos) do
			if v.HeroId == heroId then
				table.insert(entityList, self.fight.entityManager:GetEntity(v.InstanceId))
				break
			end
		end
	end

	self.entityList = entityList
	return self.entityList
end

function Player:AutoCtrlEntitySwitch()
	local ctrlEntity = self:GetCtrlEntityObject()
	if ctrlEntity.stateComponent:IsState(FightEnum.EntityState.Death) then
		local deathReason = ctrlEntity.stateComponent:GetDeathReason()
		if deathReason ~= FightEnum.DeathReason.Damage and deathReason ~= FightEnum.DeathReason.Direct then
			ctrlEntity:Revive()
		else
			-- 人物死亡自动上阵另一个角色
			local teamRevive = true
			for k, v in ipairs(self.entityInfos) do
				if v.EntityId ~= self.ctrlId then
					local entity = self.fight.entityManager:GetEntity(v.InstanceId)
					if not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
						self.fight.entityManager:CallBehaviorFun("ChangeRole", k, ctrlEntity.instanceId, v.InstanceId)
						teamRevive = false
						break
					end
				end
			end

			if teamRevive then
				for k, v in ipairs(self.entityInfos) do
					local entity = self.fight.entityManager:GetEntity(v.InstanceId)
					entity:Revive()
				end
			end
		end
	end

	return self:GetCtrlEntityObject()
end

function Player:CheckIsAllDead()
	for k, v in ipairs(self.entityInfos) do
		local entity = self.fight.entityManager:GetEntity(v.InstanceId)
		if not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
			return false
		end
	end

	return true
end

function Player:GetAliveEntityCount()
	local count = 0
	for k, v in pairs(self.entityInfos) do
		local entity = self.fight.entityManager:GetEntity(v.InstanceId)
		if not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
			count = count + 1
		end
	end

	return count
end

function Player:GetInstanceIdByHeroId(heroId)
	for index, entityInfo in pairs(self.entityInfos) do
		if heroId == entityInfo.HeroId then
			return entityInfo.InstanceId, index
		end
	end
end

function Player:GetEntityByEntityId(entityId)
	if self.entityInfos and next(self.entityInfos) then
		for index, entity in pairs(self.entityInfos) do
			if entity.EntityId == entityId then
				return entity.instanceId
			end
		end
	end
end

function Player:GetHeroIdByInstanceId(instanceId)
	if self.entityInfos and next(self.entityInfos) then
		for index, entity in pairs(self.entityInfos) do
			if entity.InstanceId == instanceId then
				return entity.heroId
			end
		end
	end
end

function Player:GetEntityInfo(instanceId)
	if self.entityInfos and next(self.entityInfos) then
		for index, entityInfo in pairs(self.entityInfos) do
			if entityInfo.InstanceId == instanceId then
				return entityInfo
			end
		end
	end
end

function Player:WeaponAttrChange(heroId, odlItem, newItem)
	if not self:GetInstanceIdByHeroId(heroId) then
		return
	end
	self:DisboardWeapon(heroId,odlItem)
	self:EquipWeapon(heroId, newItem, nil, true)
end

function Player:HeroWeaponChanged(heroId, oldWeapon, newWeapon)
	if not self:GetInstanceIdByHeroId(heroId) then
		return
	end
	local oldWeaponData = mod.BagCtrl:GetWeaponData(oldWeapon)
	local newWeaponData = mod.BagCtrl:GetWeaponData(newWeapon)

	local onLoad = function ()
		self:DisboardWeapon(heroId,oldWeaponData)
		self:EquipWeapon(heroId, newWeaponData, true, true)
		self.fight.clientFight.assetsNodeManager:UnLoadWeapon(self.playerId, heroId, oldWeapon)
	end
	self.fight.clientFight.assetsNodeManager:LoadWeapon(self.playerId, heroId, newWeapon, onLoad)
end

--武器切换和养成都是先卸载在加载，初始化角色不需要卸载武器
function Player:DisboardWeapon(heroId, weaponData)
	local instanceId = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end

    local entity = BehaviorFunctions.GetEntity(instanceId)

    local levelEffect = RoleConfig.GetWeaponLevelAttrs(weaponData.template_id, weaponData.lev)
    local stageEffect = RoleConfig.GetWeaponStageAttrs(weaponData.template_id, weaponData.stage)
	local refineEffect = {}
	if RoleConfig.GetWeaponRefineConfig(weaponData.template_id, weaponData.refine) then
		refineEffect = RoleConfig.GetWeaponRefineConfig(weaponData.template_id, weaponData.refine).magic_type
	end
    
	for i = 1, #refineEffect, 1 do
		entity.buffComponent:RemoveBuffByBuffId(refineEffect[i])
    end
    for i = 1, #levelEffect, 1 do
        entity.attrComponent:AddValue(levelEffect[i][1], -levelEffect[i][2])
    end
    for i = 1, #stageEffect, 1 do
        entity.attrComponent:AddValue(stageEffect[i][1], -stageEffect[i][2])
    end
end

function Player:EquipWeapon(heroId, weaponData, changeModel, syncAttr)
	local instanceId = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if changeModel then
		entity.clientEntity.clientTransformComponent:BindWeapon(weaponData.template_id)
	end
	self:ApplyWeaponAttr(heroId, weaponData, syncAttr)
end

function Player:HeroPartnerChanged(heroId, oldPartner, newPartner)
	local instanceId, index = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end

	local entityInfo = self.entityInfos[index]
	local newPartnerId = newPartner ~= 0 and mod.BagCtrl:GetPartnerData(newPartner).template_id

	local onLoad = function ()
		local owner = BehaviorFunctions.GetEntity(instanceId)
		if entityInfo.Partner then
			self.fight.entityManager:CallBehaviorFun("BeforePartnerReplaced", instanceId, entityInfo.Partner)
			---删除按钮映射
			owner.skillSetComponent:CancelRelevanceSkill(entityInfo.Partner)
			self.fight.entityManager:RemoveEntity(entityInfo.Partner)
			local partnerData = mod.BagCtrl:GetPartnerData(oldPartner)
			self:DisboardPartner(heroId, partnerData, true)
			entityInfo.Partner = nil
		end
		if newPartnerId then
			local entityId = RoleConfig.GetPartnerEntityId(newPartnerId) or newPartnerId
			local entity = self.fight.entityManager:CreateEntity(entityId, owner)
			entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
			entityInfo.Partner = entity.instanceId
			local partnerData = mod.BagCtrl:GetPartnerData(newPartner)
			self:EquipPartner(heroId, partnerData, true)
			---建立按钮映射
			self:ChangePartnerSkill(instanceId)
		end
		if oldPartner ~= 0 then
			self.fight.clientFight.assetsNodeManager:UnLoadPartner(self.playerId, heroId, oldPartner)
		end
		CurtainManager.Instance:ExitWait()
	end

	CurtainManager.Instance:EnterWait()
	if newPartnerId then
		self.fight.clientFight.assetsNodeManager:LoadPartner(self.playerId, heroId, newPartner, onLoad)
	else
		onLoad()
	end
end

function Player:PartnerAttrChanged(heroId, oldData, newData)
	local instanceId = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end
	
	local onLoad = function ()
		self:DisboardPartner(heroId, oldData)
		self:EquipPartner(heroId, newData, true)
		self.fight.clientFight.assetsNodeManager:UnLoadPartnerSkills(self.playerId, heroId, oldData.unique_id,oldData.skill_list)
	end
	self.fight.clientFight.assetsNodeManager:LoadPartnerSkills(self.playerId, heroId, newData.unique_id, newData.skill_list, onLoad)
end

function Player:EquipPartner(heroId, partnerData, syncAttr)
	local instanceId, index = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end

	if not partnerData then
		Log("角色[%s]的佩从不具备属性", heroId)
		return
	end

	local entityInfo = self.entityInfos[index]
	local entity = BehaviorFunctions.GetEntity(instanceId)

	for key, attr in pairs(partnerData.property_list) do
		local value = RoleConfig.GetPartnerAttr(partnerData.template_id, partnerData.lev, attr.key, attr.value)
		entity.attrComponent:AddValue(attr.key, value)
	end

	for _, skill in pairs(partnerData.skill_list) do
		local config = RoleConfig.GetPartnerSkillLevelConfig(skill.key, skill.value)
		if not config then
			LogError("找不到佩从技能信息 skill.key = "..skill.key.." skill.value = "..skill.value)
			return
		end

		for key, value in pairs(config.fight_marks) do
			BehaviorFunctions.AddEntitySign(entityInfo.Partner, value, -1)
		end
		for key, value in pairs(config.fight_magic) do
			entity.buffComponent:AddBuff(entity, value, 1, nil, FightEnum.MagicConfigFormType.Partner)
		end
	end
	if syncAttr then
		mod.FormationCtrl:SyncServerProperty(instanceId)
	end
end

function Player:DisboardPartner(heroId, partnerData, isDelete)
	local instanceId, index = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end

	local entityInfo = self.entityInfos[index]
	local entity = BehaviorFunctions.GetEntity(instanceId)

	for key, attr in pairs(partnerData.property_list) do
		local value = RoleConfig.GetPartnerAttr(partnerData.template_id, partnerData.lev, attr.key, attr.value)
		entity.attrComponent:AddValue(attr.key, - value)
	end

	for _, skill in pairs(partnerData.skill_list) do
		local config = RoleConfig.GetPartnerSkillLevelConfig(skill.key, skill.value)
		for key, value in pairs(config.fight_marks) do
			if not isDelete then
				BehaviorFunctions.RemoveEntitySign(entityInfo.Partner, value)
			end
		end
		for key, value in pairs(config.fight_magic) do
			entity.buffComponent:RemoveBuffByBuffId(value)
		end
	end
end

function Player:ShowPartner(instanceId, isShow)
	local info = self:GetEntityInfo(instanceId)
	if info.Partner then
		local entity = self.fight.entityManager:GetEntity(info.Partner)
		if entity then
			entity.stateComponent:ChangeBackstage(isShow and FightEnum.Backstage.Foreground or FightEnum.Backstage.Background)
		end
	end
end

function Player:CheckPartnerShow(instanceId)
	local info = self:GetEntityInfo(instanceId)
	if info.Partner then
		local entity = self.fight.entityManager:GetEntity(info.Partner)
		if entity then
			return entity.stateComponent.backstage == FightEnum.Backstage.Foreground
		end
	end
	return nil
end

function Player:ChangePartnerSkill(heroInstanceId, newSkillId)
	local info = self:GetEntityInfo(heroInstanceId)
	if info.Partner then
		local partnerEntity = self.fight.entityManager:GetEntity(info.Partner)
		local owner = BehaviorFunctions.GetEntity(info.InstanceId)
		if partnerEntity then
			owner.skillSetComponent:CancelRelevanceSkill(info.Partner)
			if not newSkillId and partnerEntity.skillSetComponent then
				newSkillId = partnerEntity.skillSetComponent:GetSkillIdByKeyEvent(FightEnum.KeyEvent.Partner)
			end
			if newSkillId then
				partnerEntity.skillSetComponent:ChangeButtonMap(FightEnum.KeyEvent.Partner, newSkillId)
				owner.skillSetComponent:RelevanceSkill(info.Partner, FightEnum.KeyEvent.Partner, newSkillId)
			end
		end
	end
end

function Player:GetHeroPartnerInstanceId(heroInstanceId)
	local info = self:GetEntityInfo(heroInstanceId)
	if info then
		return info.Partner
	end
end

function Player:ApplyServerAttr(roleId)
	local instanceId = self:GetInstanceIdByHeroId(roleId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local attrMap = mod.RoleCtrl:GetRolePropertyMap(roleId)
	for key, attrKey in pairs(FormationConfig.SyncProperty) do
		if attrKey > 1000 and attrMap[attrKey] then
			entity.attrComponent:SetValue(attrKey, attrMap[attrKey])
		end
	end
end

function Player:ApplyWeaponAttr(heroId, weaponData, syncAttr)
	local instanceId = self:GetInstanceIdByHeroId(heroId)
	local entity = BehaviorFunctions.GetEntity(instanceId)

	local levelEffect = RoleConfig.GetWeaponLevelAttrs(weaponData.template_id, weaponData.lev)
	local stageEffect = RoleConfig.GetWeaponStageAttrs(weaponData.template_id, weaponData.stage)


	local refineEffect = {}
	if RoleConfig.GetWeaponRefineConfig(weaponData.template_id, weaponData.refine) then
		refineEffect = RoleConfig.GetWeaponRefineConfig(weaponData.template_id, weaponData.refine).magic_type
	end

	for i = 1, #refineEffect, 1 do
		entity.buffComponent:AddBuff(entity, refineEffect[i], 1, nil, FightEnum.MagicConfigFormType.Equip)
	end

	for i = 1, #levelEffect, 1 do
		entity.attrComponent:AddValue(levelEffect[i][1], levelEffect[i][2])
	end
	for i = 1, #stageEffect, 1 do
		entity.attrComponent:AddValue(stageEffect[i][1], stageEffect[i][2])
	end
	if syncAttr then
		mod.FormationCtrl:SyncServerProperty(instanceId)
	end
end

function Player:onHeroUpgrade(heroId, oldLevel, newLevel)
	for _, entityInfo in pairs(self.entityInfos) do
		if heroId == entityInfo.HeroId then
			local entity = self.fight.entityManager:GetEntity(entityInfo.InstanceId)
			if entity then
				local oldAttrs = EntityAttrsConfig.GetHeroBaseAttr(heroId, oldLevel)
				local newAttrs = EntityAttrsConfig.GetHeroBaseAttr(heroId, newLevel)
				for attrId, value in pairs(newAttrs) do
					if value - (oldAttrs[attrId] or 0) ~= 0 then
						entity.attrComponent:AddValue(attrId, value - (oldAttrs[attrId] or 0))
					end
				end
				mod.FormationCtrl:SyncServerProperty(entity.instanceId)
			end
			break
		end
	end
end

function Player:onHeroStageUp(heroId, oldStage, newStage)
	for _, entityInfo in pairs(self.entityInfos) do
		if heroId == entityInfo.HeroId then
			local entity = self.fight.entityManager:GetEntity(entityInfo.InstanceId)
			if entity then
				local oldAttrs = EntityAttrsConfig.GetHeroStageAttr(heroId, oldStage)
				local newAttrs = EntityAttrsConfig.GetHeroStageAttr(heroId, newStage)
				for attrId, value in pairs(newAttrs) do
					if value - (oldAttrs[attrId] or 0) ~= 0 then
						entity.attrComponent:AddValue(attrId, value - (oldAttrs[attrId] or 0))
					end
				end
				mod.FormationCtrl:SyncServerProperty(entity.instanceId)
			end
			break
		end
	end
end

function Player:InitRoleSkillAttr(heroId)
	local instanceId = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end
	local skills = RoleConfig.GetRoleSkill(heroId)
	if skills and next(skills) then
		for key, skillId in pairs(skills) do
			local lev, ex_lev = mod.RoleCtrl:GetSkillInfo(heroId, skillId)
			self:RoleSkillChange(heroId, {order_id = skillId, lev = lev, ex_lev = ex_lev}, true)
		end
	end
end

function Player:RoleSkillChange(heroId, newSkill, isInit)
	local skillId = newSkill.order_id
	local lev, ex_lev = mod.RoleCtrl:GetSkillInfo(heroId, skillId)
	local instanceId = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if not isInit and lev and lev + ex_lev > 0 then
		local levAttr = RoleConfig.GetSkillLevelConfig(skillId, lev + ex_lev).fight_attrs
		if levAttr then
			for i = 1, #levAttr, 1 do
				entity.attrComponent:AddValue(levAttr[i][1], -levAttr[i][2])
			end
		end

		local fightMarks = RoleConfig.GetSkillLevelConfig(skillId, lev + ex_lev).fight_marks
		if fightMarks then
			for i = 1, #fightMarks, 1 do
				BehaviorFunctions.RemoveEntitySign(instanceId, fightMarks[i])
			end
		end
	end
	if newSkill.lev + newSkill.ex_lev > 0 then
		local levAttr = RoleConfig.GetSkillLevelConfig(skillId, newSkill.lev + newSkill.ex_lev).fight_attrs
		if levAttr then
			for i = 1, #levAttr, 1 do
				entity.attrComponent:AddValue(levAttr[i][1], levAttr[i][2])
			end
		end
		local fightMarks = RoleConfig.GetSkillLevelConfig(skillId, newSkill.lev + newSkill.ex_lev).fight_marks
		if fightMarks then
			for i = 1, #fightMarks, 1 do
				BehaviorFunctions.AddEntitySign(instanceId, fightMarks[i], -1)
			end
		end
	end
end

function Player:RoleInfoUpdate(index, roldData)
	local instanceId = self:GetInstanceIdByHeroId(roldData.id)
    if not instanceId then
        return
    end
	--TODO 角色信息变更,后续改成技能更新通知
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if entity.skillComponent then
		entity.skillComponent:InitSkillLevel()
	end
end

---comment
---@param enterEntity table entity
---@param exitEntity table entity
function Player:ChangeCtrlEntity(exitEntity, enterEntity)
	local state = exitEntity.stateComponent:GetState()
	local needInherit = false
	for k, v in pairs(FightEnum.ChangeRoleCheckState) do
		if state == v then
			needInherit = true
			break
		end
	end

	if not needInherit then
		return
	end

	local isMoving = BehaviorFunctions.CheckMove()
	local subState = exitEntity.stateComponent:ChangeRole_GetSubState()
	local inheritState
	if isMoving and FightEnum.InheritMoveState[state][subState] then
		inheritState = FightEnum.InheritMoveState[state][subState]
	elseif FightEnum.InheritState["Speical"][state] and FightEnum.InheritState["Speical"][state][subState] then
		inheritState = FightEnum.InheritState["Speical"][state][subState]
	else
		inheritState = FightEnum.InheritState["Normal"][state]
	end

	enterEntity.stateComponent:ChangeRole_SetSubState(state, inheritState)
end

function Player:__delete()
	self.resCount = 0
	self.loadCount = 0

	EventMgr.Instance:RemoveListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
	EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
end

