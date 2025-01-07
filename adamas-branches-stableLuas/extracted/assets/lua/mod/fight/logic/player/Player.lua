---@class Player
---@field fight Fight
---@field entityInfos entityInfo[]
Player = BaseClass("Player")

local DataHeroMain = Config.DataHeroMain.Find
local EntityAttrType = EntityAttrsConfig.AttrType --普通属性
local DataLevelOccupancy = Config.LevelOccupancyData
local EntityLODManager = EntityLODManager

function Player:__init()
	self.resCount = 0
	self.loadCount = 0
	self.cacheHero = {}

	self.propertyList = {}
	self.updatePlayerInfoTime = 0

	EventMgr.Instance:AddListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
	EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
	EventMgr.Instance:AddListener(EventName.EnterDuplicate, self:ToFunc("EnterDuplicate"))
	EventMgr.Instance:AddListener(EventName.QuitDuplicate, self:ToFunc("QuitDuplicate"))
	EventMgr.Instance:AddListener(EventName.UpdateQTERes, self:ToFunc("UpdateCurQTERes"))
end

function Player:Init(fight,playerId,heroIds,abilityPartner)
	self.fight = fight
	self.playerId = playerId
	self.heroIds = heroIds
	self.abilityPartner = abilityPartner
	self.ctrlId = 2
	-- 在更换玩家顺序的时候需要更新获取的玩家列表
	self.needChangeList = false
	-- 角色列表
	self.entityList = nil
	self.isRoleFirstAppear = true

	self.fightPlayer = FightPlayer.New()
	self.fightPlayer:Init(self)

	-- 记录位置 在临时控制其他实体的时候保存最后一帧的位置
	self.playerPosRecord = nil
	self.playerRotRecord = nil

	-- 配从变身状态
	self.partnerHenshinState = {}
end

function Player:StartFight(pos, rot)
	self.entityInfos = {}
	self:InitCommonEntity()
	self.fightPlayer:InitTalent()
	self:AddPlayerAttrValue()
	self:UpdateEntityInfos(mod.RoleCtrl:GetCurUseRole(), true, pos, rot)
end

function Player:AddPlayerAttrValue()
	--这里获取下编队类型
	local team_type = mod.FormationCtrl:GetTeamType()
	local curMode = mod.FormationCtrl.curMode
	--如果处于副本模式且处于编队类型4，补满大招
	if curMode == FormationConfig.Mode.Duplicate and team_type == DuplicateConfig.formationType.freeType then
		self.fightPlayer:AddAttrValue(FightEnum.PlayerAttr.Curqteres, self.fightPlayer:GetAttrValue(FightEnum.PlayerAttr.Maxqteres))
	end
end

function Player:AddEntityAttrValue(entity)
	--这里获取下编队类型
	local team_type = mod.FormationCtrl:GetTeamType()
	local curMode = mod.FormationCtrl.curMode
	--如果处于副本模式且处于编队类型4，日向，月向
	if curMode == FormationConfig.Mode.Duplicate and team_type == DuplicateConfig.formationType.freeType then
		if entity.attrComponent then
			entity.attrComponent:AddValue(FightEnum.RoleSkillPoint.Normal, entity.attrComponent:GetValue(EntityAttrType.MaxNormalSkillPoint))
			entity.attrComponent:AddValue(FightEnum.RoleSkillPoint.Ex, entity.attrComponent:GetValue(EntityAttrType.MaxExSkillPoint))
		end
	end
end

function Player:ChangeHeroList(heroIds, callback)
	self.needChangeList = true

	self.cacheHero = self.cacheHero or {}
	local ignoreRole = {}
	for i = 1, #heroIds do
		for k = 1, #self.heroIds do
			if heroIds[i] == self.heroIds[k] then
				self.cacheHero[heroIds[i]] = TableUtils.CopyTable(self.entityInfos[k])
				ignoreRole[heroIds[i]] = true
				break
			end
		end
	end

	local oldHeroIds = self.heroIds or {}
	self.heroIds = TableUtils.CopyTable(heroIds)

	local curPos = nil
	local curRot = nil
	local curHeroId = mod.RoleCtrl:GetCurUseRole()

	self:LoadRoleAsset(self.heroIds, ignoreRole, function ()
		for i = #self.entityInfos, 1, -1 do
			local entityInfo = table.remove(self.entityInfos)
			local entity = self.fight.entityManager:GetEntity(entityInfo.InstanceId)
			if entity.instanceId == self.ctrlId then
				curPos = { x = entity.transformComponent.position.x, y = entity.transformComponent.position.y, z = entity.transformComponent.position.z }
				curRot = entity.transformComponent:GetRotation():ToEulerAngles()
			end

			if not self.cacheHero[entityInfo.HeroId] then
				mod.FormationCtrl:SyncServerProperty(entity.instanceId)
				entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
				if entityInfo.Partner then
					self.fight.entityManager:RemoveEntity(entityInfo.Partner)
				end
				BehaviorFunctions.RemoveLookAtTarget(entity.instanceId,"CameraTarget")
				BehaviorFunctions.RemoveFollowTarget(entity.instanceId,"CameraTarget")
				self.fight.entityManager:RemoveEntity(entity.instanceId)
			end
		end
		self:UpdateEntityInfos(curHeroId, false, curPos, curRot)
		self:UnLoadRoleAsset(oldHeroIds, ignoreRole)
		if callback then callback() end
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
	for i = 1, #self.entityInfos do
		local heroId = self.entityInfos[i].HeroId
		local heroCfg = DataHeroMain[heroId]
		if not heroCfg then
			goto continue
		end

		if self.ctrlId ~= self.entityInfos[i].InstanceId then
			local addPoint = heroCfg.skillpoint_back * FightUtil.deltaTimeSecond * 0.0001
			BehaviorFunctions.AddSkillPoint(self.entityInfos[i].InstanceId, FightEnum.RoleSkillPoint.Normal, addPoint)
		elseif not self.fightPlayer:InFight() then
			local addPoint = heroCfg.skillpoint_peace * FightUtil.deltaTimeSecond * 0.0001
			BehaviorFunctions.AddSkillPoint(self.entityInfos[i].InstanceId, FightEnum.RoleSkillPoint.Normal, addPoint)
		end

		::continue::
	end

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
		local rotation = entity.transformComponent:GetRotation():ToEulerAngles()
		local syncPos = {
			pos_x = math.floor(position.x * 10000),
			pos_y = math.floor(position.y * 10000),
			pos_z = math.floor(position.z * 10000)
		}

		local syncRot = {
			pos_x = math.floor(rotation.x * 10000),
			pos_y = math.floor(rotation.y * 10000),
			pos_z = math.floor(rotation.z * 10000)
		}
		mod.WorldFacade:SendMsg("map_sync_position", {mapId = self.fight:GetFightMap(), position = syncPos, rotate = syncRot})
	end
end

function Player:AfterUpdate()
	self.fightPlayer:AfterUpdate()
end

function Player:LowUpdate()
	local moveEvent = self.fight.operationManager:GetMoveEvent()
	if moveEvent then
		--处理没有碰撞的区域的检测
		local playerInsId = BehaviorFunctions.GetCtrlEntity()
		local rolePos = BehaviorFunctions.GetPositionP(playerInsId)
		self:CheckLevelOccupancyList(rolePos)
	end
end

function Player:CheckLevelOccupancyList(position)
	--有区域占用的情况下，判断在哪个区域里
	if self.fight.levelManager then
		local levelInAreaId
		local mapId = Fight.Instance:GetFightMap()
		local levelPointData = DataLevelOccupancy[mapId]
		
		for levelId, v in pairs(self.fight.levelManager.levelOccupancyList) do
			if levelPointData then
				local LevelPoint = levelPointData[levelId]
				if BehaviorFunctions.IsPointInsidePolygon(position, LevelPoint) then
					levelInAreaId = levelId
				end
			end
		end
		if self.fight.levelManager.curLevelOccupancyId ~= levelInAreaId then
			self.fight.levelManager.curLevelOccupancyId = levelInAreaId
			if levelInAreaId then
				EventMgr.Instance:Fire(EventName.ShowLevelOccupancyTips, {isShow = true})
			else
				EventMgr.Instance:Fire(EventName.ShowLevelOccupancyTips, {isShow = false})
			end
		end
	end
end

function Player:UpdateEntityInfos(curHeroId, firstCreate, bornPos, bornRot)
	local isTeamRevive = true
	local curInstanceId, firstEntity

	if not curHeroId or (not self.cacheHero[curHeroId] and not firstCreate) then
		curHeroId = self.heroIds[1]
	end
	for i = 1, #self.heroIds do
		local heroId = self.heroIds[i]
		local entityInfo = self:CreateHeroEntity(heroId, i)
		local entity = BehaviorFunctions.GetEntity(entityInfo.InstanceId)
		entity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
		--临时处理，entity补满日向和月向
		self:AddEntityAttrValue(entity)
		
		if curHeroId == entityInfo.HeroId then
			curInstanceId = entityInfo.InstanceId
		end
		if isTeamRevive and entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life) > 0 then
			isTeamRevive = false
			firstEntity = entityInfo.InstanceId
		end
	end
	TableUtils.ClearTable(self.cacheHero)

	if isTeamRevive then
		for i = 1, #self.heroIds do
			local instanceId = self:GetInstanceIdByHeroId(self.heroIds[i])
			local entity = BehaviorFunctions.GetEntity(instanceId)
			entity:Revive()
		end
	end

	local tempEntity = BehaviorFunctions.GetEntity(curInstanceId)
	if tempEntity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life) <= 0 then
		curInstanceId = firstEntity
		tempEntity = BehaviorFunctions.GetEntity(firstEntity)
	end
	if self.ctrlId ~= curInstanceId or firstCreate then
		self.ctrlId = curInstanceId
		local opEntity = BehaviorFunctions.GetEntity(curInstanceId)
		if bornPos then
			opEntity.transformComponent:SetPosition(bornPos.x, bornPos.y, bornPos.z)
		end

		if bornRot then
			opEntity.transformComponent:SetRotation(Quat.Euler(bornRot.x, bornRot.y, bornRot.z))
		end

		if firstCreate then
			local rotX, rotY, rotZ, rotW = mod.WorldMapCtrl:GetCacheTpRotation()
			if rotX then
				opEntity.rotateComponent:SetRotation(Quat.New(rotX, rotY, rotZ, rotW))
				CameraManager.Instance:SetCameraRotation(opEntity.transformComponent.rotation)
			end
		end

		local transform = opEntity.clientTransformComponent.transform
		self.fight.clientFight.cameraManager:SetMainTarget(transform)
		BehaviorFunctions.SetCameraState(FightEnum.CameraState.Operating)
		opEntity.clientTransformComponent:SetMainRole(true)
		if BehaviorFunctions.IsPause() then
			opEntity.clientEntity.clientAnimatorComponent:SaveTimeScale(1)
		end
		CustomUnityUtils.SetLookAtPlayer(transform, tostring(opEntity.instanceId))
		opEntity.stateComponent:SetState(FightEnum.EntityState.Born)
		self:SetCtrlEntity(self.ctrlId)
	end

	tempEntity.stateComponent:ChangeBackstage(FightEnum.Backstage.Foreground)

	self.fightPlayer:UpdateEntityInfos()
	EventMgr.Instance:Fire(EventName.PlayerUpdate, true)
end

function Player:CreateHeroEntity(heroId, index)
	local entityInfo, notCache
	local realRoleId = mod.RoleCtrl:GetRealRoleId(heroId)
	if self.cacheHero[heroId] then
		entityInfo = TableUtils.CopyTable(self.cacheHero[heroId]) or {}
		self.entityInfos[index] = entityInfo
		notCache = false
	else
		local entity = self.fight.entityManager:CreateEntity(DataHeroMain[realRoleId].entity_id, nil, heroId)
		local partnerEntityId = mod.RoleCtrl:GetRolePartnerEntityId(heroId)
		local partnerInstanceId
		if partnerEntityId then
			local partnerEntity = self.fight.entityManager:CreateEntity(partnerEntityId, entity)
			partnerEntity.stateComponent:ChangeBackstage(FightEnum.Backstage.Background)
			partnerInstanceId = partnerEntity.instanceId
		end
		entity.masterId = heroId
		---@class entityInfo
		entityInfo = {
			HeroId = heroId,--有可能是机器人id
			InstanceId = entity.instanceId,
			EntityId = entity.entityId,
			Partner = partnerInstanceId,
			QTETime = 0,
			SwitchTime = 0,
			QTEState = 1,
			SwitchState = 1,
		}
		self.entityInfos[index] = entityInfo

		if entityInfo.Partner then
			self:ChangePartnerSkill(entity.instanceId)
		else
			entity.attrComponent:SetValue(EntityAttrType.ExSkillPoint, 0)
			entity.attrComponent:LockAttr(EntityAttrType.ExSkillPoint, true)
		end

		local uniqueId = mod.RoleCtrl:GetRoleWeapon(heroId)
		local weaponData = mod.BagCtrl:GetWeaponData(uniqueId, heroId)
		self:EquipWeapon(heroId, weaponData, true, false)

		local partnerUniqueId = mod.RoleCtrl:GetRolePartner(heroId)
		if partnerUniqueId ~= 0 then
			local partnerData = mod.BagCtrl:GetPartnerData(partnerUniqueId, nil, heroId)
			self:EquipPartner(heroId, partnerData, false)
		end
		self:InitRoleSkillAttr(heroId)

		self:ApplyServerAttr(heroId)

		notCache = true
	end

	return entityInfo, notCache
end

function Player:InitCommonEntity()
	local commonEntity = {2000, 2002}
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

function Player:GetCurPlayerIndex()
	for index, v in pairs(self.entityInfos) do
		if v.InstanceId == self.ctrlId then
			return index
		end
	end
end

function Player:PlayerListIsAllDie()
	for i, v in ipairs(self.entityInfos) do
		local entity = self.fight.entityManager:GetEntity(v.InstanceId)
		if entity and not entity.stateComponent:IsState(FightEnum.EntityState.Death) then
			return false
		end
	end
	return true
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

function Player:GetTime(index, type)
	local entityInfo = self.entityInfos[index]
	if not entityInfo then
		return
	end

	if type == 1 then
		return entityInfo.QTETime
	elseif type == 2 then
		return entityInfo.SwitchTime
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
	-- 如果他现在在配从变身的话 要解除变身 临时的 后续要修改
	local henshinState = self:GetPartnerHenshinState(self.ctrlId)
	if henshinState and henshinState ~= FightEnum.PartnerHenshinState.None then
		local entityInfo = self:GetEntityInfo(self.ctrlId)
		BehaviorFunctions.CallCommonBehaviorFunc(entityInfo.Partner, "StopHenshin")
	end
	CameraManager.Instance:SetEntityEffectVisible(self.ctrlId, false)
	self:CheckRemoveRoguelikeMagic()

	local oldInstanceId = self.ctrlId
	self.ctrlId = instanceId
	local curEntity = self:GetCtrlEntityObject()

	curEntity:RemoveTrigger()
	CameraManager.Instance:SetEntityEffectVisible(self.ctrlId, true)

	local entity = self.fight.entityManager:GetEntity(instanceId)
	entity.clientTransformComponent:SetMainRole(true)
	--EntityLODManager设置ReferenceId必须在SetTerrianFollow之前，不然就会导致地形Lod位置计算出错
	EntityLODManager.Instance:SetReferenceId(instanceId)
	self.fight.clientFight.cameraManager:SetMainTarget(entity.clientTransformComponent.transform)
	self.fight.clientFight.clientMap:SetTerrianFollow(entity.clientTransformComponent.transform)
	EventMgr.Instance:Fire(EventName.PlayerUpdate)

	SceneUnitManager.Instance:SetTargetTransform(curEntity.clientTransformComponent.transform)
	CustomUnityUtils.SetLookAtPlayer(curEntity.clientTransformComponent.transform, tostring(instanceId))

	if mod.FormationCtrl.curMode ~= FormationConfig.Mode.Duplicate then
		if mod.RoleCtrl.curUseRole ~= curEntity.masterId then
			mod.RoleFacade:SendMsg("hero_use", curEntity.masterId)
		end
	end

	self.fight.entityManager:CheckTriggerComponnet(oldInstanceId)
	self.fight.entityManager:CallEntityFun("OnSwitchPlayerCtrl")
	self.fight.entityManager:CallBehaviorFun("OnSwitchPlayerCtrl", oldInstanceId, instanceId)
	self:CheckAddRoguelikeMagic()
	EventMgr.Instance:Fire(EventName.SetCurEntity, curEntity)
end

function Player:CheckRemoveRoguelikeMagic()
	-- 检查肉鸽的附带buff
	self.fight.rouguelikeManager:RemoveAllCardMagic()
end

function Player:CheckAddRoguelikeMagic()
	--副本编队类型为1,2,3,4的不带入buff
	local systemDuplicateId = mod.DuplicateCtrl:GetSystemDuplicateId()
	local systemDuplicateCfg = DuplicateConfig.GetSystemDuplicateConfigById(systemDuplicateId)
	if systemDuplicateCfg and DuplicateConfig.dupFormation[systemDuplicateCfg.team_type] then
		return 
	end
 	-- 检查肉鸽的附带buff
	self.fight.rouguelikeManager:AddAllCardMagic()
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

function Player:UseItem(index, magicId, lev)
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
		return self.fight.magicManager:DoMagic(magic, lev, entity, entity, false)
	elseif buff then
		return entity.buffComponent:AddBuff(entity, magicId, lev, entity)
	end
	mod.SyncServerProperty(entityInfo.InstanceId)
end

function Player:UseItemForAll(magicId, lev)
	for k, v in pairs(self.entityInfos) do
		local entity = self.fight.entityManager:GetEntity(v.InstanceId)
		local magic = MagicConfig.GetMagic(magicId, v.EntityId)
		local buff = MagicConfig.GetBuff(magicId, v.EntityId)
		if magic then
			self.fight.magicManager:DoMagic(magic, nil, entity, entity, false)
		elseif buff then
			entity.buffComponent:AddBuff(entity, magicId, lev, entity)
		end
		mod.SyncServerProperty(v.InstanceId)
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
		EntityLODManager.Instance:SetReferenceId(0)
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

function Player:GetEntityMap()
	return self.entityInfos
end

function Player:GetInstanceIdByHeroId(heroId)
	if not self.entityInfos then 
		return 
	end
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
				return entity.InstanceId
			end
		end
	end
end

function Player:GetHeroIdByInstanceId(instanceId)
	if self.entityInfos and next(self.entityInfos) then
		for index, entity in pairs(self.entityInfos) do
			if entity.InstanceId == instanceId then
				return entity.HeroId
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
		local magicId, lev = RoleConfig.GetMagicData(refineEffect[i])
		entity.buffComponent:RemoveBuffByBuffId(magicId)
		entity:RemoveEntityMagicRecord(FightEnum.MagicConfigFormType.Equip, magicId)
    end
	local info = self:RecordAttrRatio(entity)
	for i = 1, #levelEffect, 1 do
        entity.attrComponent:AddValue(levelEffect[i][1], -levelEffect[i][2])
    end
    for i = 1, #stageEffect, 1 do
        entity.attrComponent:AddValue(stageEffect[i][1], -stageEffect[i][2])
    end
	self:RecoverAttrRatio(entity, info)
end

function Player:EquipWeapon(heroId, weaponData, changeModel, syncAttr)
	local instanceId = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end
	local entity = BehaviorFunctions.GetEntity(instanceId)
	if changeModel then
		entity.clientTransformComponent:BindWeapon(weaponData.template_id)
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
			local partnerData = mod.BagCtrl:GetPartnerData(oldPartner)
			self:DisboardPartner(heroId, partnerData)
			self.fight.entityManager:RemoveEntity(entityInfo.Partner)
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
			self.fight.entityManager:CallBehaviorFun("AfterPartnerReplaced", instanceId, entityInfo.Partner)
			owner.attrComponent:LockAttr(EntityAttrType.ExSkillPoint, false)
		else
			owner.attrComponent:SetValue(EntityAttrType.ExSkillPoint, 0)
			owner.attrComponent:LockAttr(EntityAttrType.ExSkillPoint, true)
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
		local skills = RoleConfig.GetAllPartnerSkills(oldData)
		self.fight.clientFight.assetsNodeManager:UnLoadPartnerSkills(self.playerId, heroId, oldData.unique_id,skills)
	end
	local skills = RoleConfig.GetAllPartnerSkills(newData)
	self.fight.clientFight.assetsNodeManager:LoadPartnerSkills(self.playerId, heroId, newData.unique_id, skills, onLoad)
end

function Player:EquipPartner(heroId, partnerData, syncAttr)
	local instanceId, index = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end

	if not partnerData then
		Log("角色[%s]的月灵不具备属性", heroId)
		return
	end

	local entityInfo = self.entityInfos[index]
	local entity = BehaviorFunctions.GetEntity(instanceId)

	local info = self:RecordAttrRatio(entity)
	local attrs = RoleConfig.GetPartnerBaseAttrs(partnerData.template_id, partnerData.lev)
	for key, value in pairs(attrs) do
		entity.attrComponent:AddValue(key, value)
	end
	
	--应用技能效果
	for _, skill in pairs(partnerData.skill_list) do
		local config = RoleConfig.GetPartnerSkillConfig(skill.key)
		if not config then
			LogError("找不到月灵技能配置", skill.key)
			goto continue
		end
		for key, value in pairs(config.fight_attrs) do
			entity.attrComponent:AddValue(value[1], value[2])
		end

		for key, value in pairs(config.fight_marks) do
			BehaviorFunctions.AddEntitySign(entityInfo.Partner, value, -1)
			BehaviorFunctions.AddEntitySignRecord(FightEnum.MagicConfigFormType.Partner, entityInfo.Partner, value, -1) --记录
		end
		for key, value in pairs(config.fight_magic) do
			local magicId, lev = RoleConfig.GetMagicData(value)
			entity.buffComponent:AddBuff(entity, magicId, lev, nil, FightEnum.MagicConfigFormType.Partner)
			BehaviorFunctions.AddEntityMagicRecord(FightEnum.MagicConfigFormType.Partner, instanceId, magicId, lev)
		end
		::continue::
	end

	--应用巅峰盘效果
	for _, panel in pairs(partnerData.panel_list) do
		for k, skill in pairs(panel.skill_list) do
			if skill.is_active then
				local config = RoleConfig.GetPartnerSkillConfig(skill.skill_id)
		
				for key, value in pairs(config.fight_attrs) do
					entity.attrComponent:AddValue(value[1], value[2])
				end

				for key, value in pairs(config.fight_marks) do
					BehaviorFunctions.AddEntitySign(entityInfo.Partner, value, -1)
					BehaviorFunctions.AddEntitySignRecord(FightEnum.MagicConfigFormType.Partner, entityInfo.Partner, value, -1) --记录
				end
				for key, value in pairs(config.fight_magic) do
					local magicId, lev = RoleConfig.GetMagicData(value)
					local buffConfig = MagicConfig.GetBuff(magicId, entity.entityId, FightEnum.MagicConfigFormType.Partner, entity.parent.instanceId)
					local fromType = buffConfig and FightEnum.MagicConfigFormType.Partner or FightEnum.MagicConfigFormType.PartnerPerk
					entity.buffComponent:AddBuff(entity, magicId, lev, nil, fromType)
					BehaviorFunctions.AddEntityMagicRecord(fromType, instanceId, magicId, lev)
				end
			end
		end
	end

	--应用被动技能效果
	for _, skill in pairs(partnerData.passive_skill_list) do
		local config = RoleConfig.GetPartnerSkillConfig(skill.value)
		if not config then
			LogError("找不到月灵技能配置", skill.value)
			goto continue
		end
		for key, value in pairs(config.fight_attrs) do
			entity.attrComponent:AddValue(value[1], value[2])
		end

		for key, value in pairs(config.fight_marks) do
			BehaviorFunctions.AddEntitySign(entityInfo.Partner, value, -1)
			BehaviorFunctions.AddEntitySignRecord(FightEnum.MagicConfigFormType.Partner, entityInfo.Partner, value, -1) --记录
		end
		for key, value in pairs(config.fight_magic) do
			local magicId, lev = RoleConfig.GetMagicData(value)
			local buffConfig = MagicConfig.GetBuff(magicId, entity.entityId, FightEnum.MagicConfigFormType.Partner, entity.parent.instanceId)
			local fromType = buffConfig and FightEnum.MagicConfigFormType.Partner or FightEnum.MagicConfigFormType.PartnerPerk
			entity.buffComponent:AddBuff(entity, magicId, lev, nil, fromType)
			BehaviorFunctions.AddEntityMagicRecord(fromType, instanceId, magicId, lev)
		end
		::continue::
	end

	self:RecoverAttrRatio(entity, info)
	if syncAttr then
		mod.FormationCtrl:SyncServerProperty(instanceId)
	end
end

function Player:DisboardPartner(heroId, partnerData)
	local instanceId, index = self:GetInstanceIdByHeroId(heroId)
    if not instanceId then
        return
    end

	local entityInfo = self.entityInfos[index]
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local info = self:RecordAttrRatio(entity)

	--移除技能效果
	for _, skill in pairs(partnerData.skill_list) do
		local config = RoleConfig.GetPartnerSkillConfig(skill.key)
		if not config then
			LogError("找不到月灵技能配置", skill.key)
			goto continue
		end
		for key, value in pairs(config.fight_marks) do
			BehaviorFunctions.RemoveEntitySign(entityInfo.Partner, value)
			BehaviorFunctions.RemoveEntitySignRecord(FightEnum.MagicConfigFormType.Partner, entityInfo.Partner, value) --移除记录
		end
		for key, value in pairs(config.fight_magic) do
			local magicId, lev = RoleConfig.GetMagicData(value)
			entity.buffComponent:RemoveBuffByBuffId(magicId)
			BehaviorFunctions.RemoveEntityMagicRecord(FightEnum.MagicConfigFormType.Partner, instanceId, magicId)
		end
		for key, value in pairs(config.fight_attrs) do
			entity.attrComponent:AddValue(value[1],  -value[2])
		end
		::continue::
	end

	--移除巅峰盘效果
	for _, panel in pairs(partnerData.panel_list) do
		for k, skill in pairs(panel.skill_list) do
			if skill.is_active then
				local config = RoleConfig.GetPartnerSkillConfig(skill.skill_id)
				for key, value in pairs(config.fight_marks) do
					BehaviorFunctions.RemoveEntitySign(entityInfo.Partner, value)
					BehaviorFunctions.RemoveEntitySignRecord(FightEnum.MagicConfigFormType.Partner, entityInfo.Partner, value) --移除记录
				end
				for key, value in pairs(config.fight_magic) do
					local magicId, lev = RoleConfig.GetMagicData(value)
					entity.buffComponent:RemoveBuffByBuffId(magicId)
					local buffConfig = MagicConfig.GetBuff(magicId, entity.entityId, FightEnum.MagicConfigFormType.Partner, entity.parent.instanceId)
					local fromType = buffConfig and FightEnum.MagicConfigFormType.Partner or FightEnum.MagicConfigFormType.PartnerPerk
					BehaviorFunctions.RemoveEntityMagicRecord(fromType, instanceId, magicId)
				end
				for key, value in pairs(config.fight_attrs) do
					entity.attrComponent:AddValue(value[1],  -value[2])
				end
			end
		end
	end

	--移除被动技能效果
	for _, skill in pairs(partnerData.passive_skill_list) do
		local config = RoleConfig.GetPartnerSkillConfig(skill.value)
		if not config then
			LogError("找不到月灵技能配置", skill.value)
			goto continue
		end
		for key, value in pairs(config.fight_marks) do
			BehaviorFunctions.RemoveEntitySign(entityInfo.Partner, value)
			BehaviorFunctions.RemoveEntitySignRecord(FightEnum.MagicConfigFormType.Partner, entityInfo.Partner, value) --移除记录
		end
		for key, value in pairs(config.fight_magic) do
			local magicId, lev = RoleConfig.GetMagicData(value)
			entity.buffComponent:RemoveBuffByBuffId(magicId)
			local buffConfig = MagicConfig.GetBuff(magicId, entity.entityId, FightEnum.MagicConfigFormType.Partner, entity.parent.instanceId)
			local fromType = buffConfig and FightEnum.MagicConfigFormType.Partner or FightEnum.MagicConfigFormType.PartnerPerk
			BehaviorFunctions.RemoveEntityMagicRecord(fromType, instanceId, magicId)
		end
		for key, value in pairs(config.fight_attrs) do
			entity.attrComponent:AddValue(value[1],  -value[2])
		end
		::continue::
	end
	local attrs = RoleConfig.GetPartnerBaseAttrs(partnerData.template_id, partnerData.lev)
	for key, value in pairs(attrs) do
		entity.attrComponent:AddValue(key, - value)
	end
	self:RecoverAttrRatio(entity, info)
end

function Player:ShowPartner(instanceId, isShow)
	local info = self:GetEntityInfo(instanceId)
	if info and info.Partner then
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
	if mod.FormationCtrl.curMode == FormationConfig.Mode.Duplicate then return end
	
	local instanceId = self:GetInstanceIdByHeroId(roleId)
	local entity = BehaviorFunctions.GetEntity(instanceId)
	local attrMap = mod.RoleCtrl:GetRolePropertyMap(roleId)
	for key, attrKey in pairs(FormationConfig.SyncProperty) do
		if attrKey > 1000 and attrMap[attrKey] then
			if attrMap[attrKey - 1000] then
				local temp = attrMap[attrKey] / attrMap[attrKey - 1000]
				local maxValue = entity.attrComponent:GetValue(attrKey - 1000)
				local curValue = temp * maxValue
				entity.attrComponent:SetValue(attrKey, curValue)
			else
				entity.attrComponent:SetValue(attrKey, attrMap[attrKey])
			end
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

	local info = self:RecordAttrRatio(entity)
	for i = 1, #levelEffect, 1 do
		entity.attrComponent:AddValue(levelEffect[i][1], levelEffect[i][2])
	end
	for i = 1, #stageEffect, 1 do
		entity.attrComponent:AddValue(stageEffect[i][1], stageEffect[i][2])
	end
	self:RecoverAttrRatio(entity, info)

	for i = 1, #refineEffect, 1 do
		local magicId, lev = RoleConfig.GetMagicData(refineEffect[i])
		entity.buffComponent:AddBuff(entity, magicId, lev, nil, FightEnum.MagicConfigFormType.Equip)
		BehaviorFunctions.AddEntityMagicRecord(FightEnum.MagicConfigFormType.Equip, instanceId, magicId, lev)
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
				local info = self:RecordAttrRatio(entity)
				for attrId, value in pairs(oldAttrs) do
					entity.attrComponent:AddValue(attrId, newAttrs[attrId] - value)
				end
				self:RecoverAttrRatio(entity,info)
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
				local info = self:RecordAttrRatio(entity)
				for attrId, value in pairs(newAttrs) do
					entity.attrComponent:AddValue(attrId, value)
				end
				for attrId, value in pairs(oldAttrs) do
					entity.attrComponent:AddValue(attrId, -value)
				end
				self:RecoverAttrRatio(entity, info)
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
	local realHeroId = mod.RoleCtrl:GetRealRoleId(heroId)
	local skills = RoleConfig.GetRoleSkill(realHeroId)
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
		local fightMarks = RoleConfig.GetSkillLevelConfig(skillId, lev + ex_lev).fight_marks
		if fightMarks then
			for i = 1, #fightMarks, 1 do
				BehaviorFunctions.RemoveEntitySign(instanceId, fightMarks[i])
				BehaviorFunctions.RemoveEntitySignRecord(FightEnum.MagicConfigFormType.Player, instanceId, fightMarks[i])
			end
		end

		local levAttr = RoleConfig.GetSkillLevelConfig(skillId, lev + ex_lev).fight_attrs
		if levAttr then
			local info = self:RecordAttrRatio(entity)
			for i = 1, #levAttr, 1 do
				entity.attrComponent:AddValue(levAttr[i][1], -levAttr[i][2])
			end
			self:RecoverAttrRatio(entity, info)
		end
	end
	if newSkill.lev + newSkill.ex_lev > 0 then
		local levAttr = RoleConfig.GetSkillLevelConfig(skillId, newSkill.lev + newSkill.ex_lev).fight_attrs
		if levAttr then
			local info = self:RecordAttrRatio(entity)
			for i = 1, #levAttr, 1 do
				entity.attrComponent:AddValue(levAttr[i][1], levAttr[i][2])
			end
			self:RecoverAttrRatio(entity, info)
		end
		local fightMarks = RoleConfig.GetSkillLevelConfig(skillId, newSkill.lev + newSkill.ex_lev).fight_marks
		if fightMarks then
			for i = 1, #fightMarks, 1 do
				BehaviorFunctions.AddEntitySign(instanceId, fightMarks[i], -1)
				BehaviorFunctions.AddEntitySignRecord(FightEnum.MagicConfigFormType.Player, instanceId, fightMarks[i])
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

--TODO 预留接口，不重载副本实现FightEvent（进入）
function Player:EnterDuplicate()
	if not self.entityList then return end
	local fightEventIdList = mod.DuplicateCtrl:GetFightEventIdList()
	for _, fightEventId in ipairs(fightEventIdList) do
		if fightEventId > 0 then
			local fightEvent = DuplicateConfig.GetFightEvent(fightEventId)
			if  fightEvent.effect_type == 1 then
				for _, magicId in ipairs(fightEvent.magic_id) do
					if magicId > 0 then
						for _, entity in ipairs(self.entityList) do
							BehaviorFunctions.DoMagic(entity.instanceId,entity.instanceId,magicId)
						end
					end
				end
			end
		end
	end
end
--TODO 预留接口，不重载副本实现FightEvent（退出）
function Player:QuitDuplicate()
	if not self.entityList then return end
	local fightEventIdList = mod.DuplicateCtrl:GetFightEventIdList()
	for _, fightEventId in ipairs(fightEventIdList) do
		if fightEventId > 0 then
			local fightEvent = DuplicateConfig.GetFightEvent(fightEventId)
			if  fightEvent.effect_type == 1 then
				for _, magicId in ipairs(fightEvent.magic_id) do
					if magicId > 0 then
						for _, entity in ipairs(self.entityList) do
							BehaviorFunctions.RemoveBuff(entity.instanceId,magicId)
						end
					end
				end
			end
		end
	end
end
--记录关键属性比例
function Player:RecordAttrRatio(entity)
	local info = {}
	local attrComponent = entity.attrComponent
	for _, cur in pairs(FormationConfig.ConstantRatioAttr) do
		local curValue = attrComponent:GetValue(cur)
		local maxValue = attrComponent:GetValue(cur - 1000)
		info[cur] = curValue / maxValue
	end
	return info
end

--恢复关键属性比例
function Player:RecoverAttrRatio(entity, info)
	for key, value in pairs(info) do
		local maxValue = entity.attrComponent:GetValue(key - 1000)
		local curValue = maxValue * value
		entity.attrComponent:SetValue(key, curValue)
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

-- 设置AILOD/EntityCtrl的中心点位置
function Player:SetLodCenterPoint(position)
	self.lodCenterPoint = position
end

function Player:GetLodCenterPoint()
	if self.lodCenterPoint then
		return self.lodCenterPoint
	end

	local ctrlEntity = self:GetCtrlEntityObject()
	return ctrlEntity.transformComponent:GetPosition()
end

function Player:GetCtrlEnityPosition()
	local ctrlEntity = self:GetCtrlEntityObject()
	return ctrlEntity.transformComponent:GetPosition()
end

function Player:IsRoleFirstAppear(instanceId)
	if self.isRoleFirstAppear then
		for k, v in pairs(self.entityInfos) do
			if v.InstanceId == instanceId then
				self.isRoleFirstAppear = false
				return true
			end
		end
	end
	return false
end

-- 更新角色大招点数
function Player:UpdateCurQTERes(_attackInstance, _instanceId, _deathReason)
	if _attackInstance == self.ctrlId then
		local entity = BehaviorFunctions.GetEntity(_instanceId)
		local monsterCfg = Config.DataMonster.Find[entity.masterId]

		local t = BehaviorFunctions.GetNpcType(_instanceId)
		if t == FightEnum.EntityNpcTag.Monster 
				or t == FightEnum.EntityNpcTag.Elite 
				or t == FightEnum.EntityNpcTag.Boss then
			
			local value = monsterCfg and monsterCfg.energy * 0.0001 or 0.5
			BehaviorFunctions.ChangePlayerAttr(FightEnum.PlayerAttr.Curqteres, value)
		end
	end
end

function Player:SetPartnerHenshinState(instanceId, state)
	local index = self:GetEntityQTEIndex(instanceId)
	if not index then
		return
	end

	self.partnerHenshinState[index] = state
	EventMgr.Instance:Fire(EventName.PlayerHenshinPartner)
end

function Player:GetPartnerHenshinState(instanceId)
	local index = self:GetEntityQTEIndex(instanceId)
	if not index then
		return
	end

	if not self.partnerHenshinState[index] then
		self.partnerHenshinState[index] = FightEnum.PartnerHenshinState.None
	end

	return self.partnerHenshinState[index]
end

function Player:__delete()
	self.fightPlayer:DeleteMe()
	self.fightPlayer = nil

	self.resCount = 0
	self.loadCount = 0

	EventMgr.Instance:RemoveListener(EventName.SkillInfoChange, self:ToFunc("RoleSkillChange"))
	EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
	EventMgr.Instance:RemoveListener(EventName.EnterDuplicate, self:ToFunc("EnterDuplicate"))
	EventMgr.Instance:RemoveListener(EventName.QuitDuplicate, self:ToFunc("QuitDuplicate"))
	EventMgr.Instance:RemoveListener(EventName.UpdateQTERes, self:ToFunc("UpdateCurQTERes"))
end

