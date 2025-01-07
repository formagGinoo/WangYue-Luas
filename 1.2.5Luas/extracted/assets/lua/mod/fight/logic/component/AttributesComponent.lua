---@class AttributesComponent
AttributesComponent = BaseClass("AttributesComponent",PoolBaseClass)

---@type AttrType
local AttrType = EntityAttrsConfig.AttrType
local Attr2AttrPercent = EntityAttrsConfig.Attr2AttrPercent
local AttrPercent2Attr = EntityAttrsConfig.AttrPercent2Attr
local AttrGroupType = FightEnum.AttrGroupType
local AttrType2MaxType = EntityAttrsConfig.AttrType2MaxType
local DataNpc = Config.DataNpc
local DataHero = Config.DataHero
local DataGlobal = Config.DataGlobal.data_global
local DataAttrsDefine = Config.DataAttrsDefine.Find
local DataHeroMain = Config.DataHeroMain.Find
local DataPlayerAttrsDefine = Config.DataPlayerAttrsDefine.Find

function AttributesComponent:__init()
	self.name = "Attributes"
	self.baseAttrs = {}
	self.additveAttrs = {}
	self.npcConfig = nil
	-- 结果值不能直接修改
	self.attrs = {}
	self.recoverEventMap = {}
	self.emptyEventMap = {}
	self.lockAttrTable = {}

	self.frameChangeAttrs = {}

	self.damageTime = 0
end

function AttributesComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.level =  entity.params and entity.params.level
	self.playerNpcTag = false

	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Attributes)
	if self.config.AttributeEventList then
		for k, v in pairs(self.config.AttributeEventList) do
			if v.RecoverEvent then
				local info = {
					RecoverTime = v.RecoverEvent.Time,
					RecoverNeedTime = v.RecoverEvent.Time,
					RecoverAttrType = v.RecoverEvent.RecoverAttrType,
					RecoverAttrValue = v.RecoverEvent.RecoverAttrValue,
					StopDmgCondition = v.RecoverEvent.StopDmgCondition,
				}

				self.recoverEventMap[v.AttrType] = info
				table.insert(self.recoverEventMap, info)
			end

			if v.EmptyEvent then
				self.emptyEventMap[v.AttrType] = v.EmptyEvent
				self.emptyEventMap[v.AttrType].emptyTime = 0
			end
		end
	end
end

function AttributesComponent:LateInit()
	for _, v in pairs(AttrType) do
		self.baseAttrs[v] = 0
	end
	local npcTag = self.entity.tagComponent.npcTag
	if npcTag == FightEnum.EntityNpcTag.Player then
		self.playerNpcTag = true
		self.npcConfig = DataHeroMain[self.entity.owner.masterId]
		local curRoleInfo = mod.RoleCtrl:GetRoleData(self.entity.owner.masterId)
		--TODO 兼容黑幕
		self.level = curRoleInfo.lev or 1
		local levelAttrs = EntityAttrsConfig.GetHeroBaseAttr(self.entity.masterId, curRoleInfo and curRoleInfo.lev or 1)
		for k, v in pairs(levelAttrs) do
			self.baseAttrs[k] = (self.baseAttrs[k] or 0) + v
		end
		local stageAttrs = EntityAttrsConfig.GetHeroStageAttr(self.entity.masterId, curRoleInfo and curRoleInfo.stage or 0)
		for k, v in pairs(stageAttrs) do
			self.baseAttrs[k] = (self.baseAttrs[k] or 0) + v
		end
	else
		local attrId = self.config.DefaultAttrID
		if self.entity.masterId then
			self.npcConfig = Config.DataMonster.Find[self.entity.masterId]
			attrId = self.npcConfig.attr_id
		end

		if not self.level then
			if npcTag == FightEnum.EntityNpcTag.Monster
			or npcTag == FightEnum.EntityNpcTag.Elite
			or npcTag == FightEnum.EntityNpcTag.Boss
			then
				self.level = mod.WorldLevelCtrl:GetEcoEntityLevel(npcTag)
			end
			
		end
		self.level = self.level or 1

		--Log("创建实体，等级："..self.level)

		local monsterAttrs = EntityAttrsConfig.GetMonsterBaseAttr(attrId, self.level)
		for k, v in pairs(monsterAttrs) do
			self.baseAttrs[k] = (self.baseAttrs[k] or 0) + v
		end

		if self.baseAttrs[AttrType.LifeBar] == 0 then
			self.baseAttrs[AttrType.LifeBar] = 10
		end
	end

	for attrType, value in pairs(self.baseAttrs) do
		if DataAttrsDefine[attrType] and DataAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
			self.baseAttrs[attrType] = value * 0.0001
		end
	end

	for attrType, attrPercentType in pairs(Attr2AttrPercent) do
	 	self.attrs[attrType] = math.floor(self:GetCombinedBaseValue(attrType) * (1 + self:GetCombinedBaseValue(attrPercentType)))
	end

	self.baseAttrs[AttrType.Life] = self.attrs[AttrType.MaxLife]
	self.baseAttrs[AttrType.Armor] = self.baseAttrs[AttrType.MaxArmor]
	self.baseAttrs[AttrType.Dodge] = self.baseAttrs[AttrType.MaxDodge]
	self.baseAttrs[AttrType.MaxCommonAttr1] = DataGlobal.FightAttrCommonAttr1Max.ivalue

	for k, v in pairs(self.baseAttrs) do
		if not Attr2AttrPercent[k] then
			self.attrs[k] = self:GetCombinedBaseValue(k)
		end
		self.additveAttrs[k] = 0
	end

	self.maxLifeSection = 1
	for i = 0, 1 do
		local maxLife = self.baseAttrs[AttrType.MaxLife2+i]
		if maxLife and maxLife > 0 then
			self.lifeSection = self.lifeSection or {} 
			table.insert(self.lifeSection, maxLife)
			self.maxLifeSection = self.maxLifeSection + 1
		end
	end
	self.curLifeSection = 1
end

function AttributesComponent:Update()
	if not self.recoverEventMap or self.attrs[AttrType.Life] <= 0 then
		return
	end

	local deltaTime = FightUtil.deltaTimeSecond
	for k, v in pairs(self.recoverEventMap) do
		local emptyEvent = self.emptyEventMap[k]
		if emptyEvent and emptyEvent.emptyTime > 0 then
			emptyEvent.emptyTime = emptyEvent.emptyTime - deltaTime 
			if emptyEvent.emptyTime < 0 and emptyEvent.EndMagicList then
				for i, magicId in ipairs(emptyEvent.EndMagicList) do
					local magic = MagicConfig.GetMagic(magicId, self.entity.entityId)
					local buff = MagicConfig.GetBuff(magicId, self.entity.entityId)
					if magic then
						self.fight.magicManager:DoMagic(magic, nil, self.entity,self.entity,false)
					elseif buff and self.entity.buffComponent then
						self.entity.buffComponent:AddBuff(self.entity, magicId, 1)
					end
				end
			end
			goto continue
		end
		

		if v.StopDmgCondition then
			if self.fight.time - self.damageTime < v.StopDmgCondition.Time * 10000 then
				goto continue
			end
		end

		v.RecoverTime = v.RecoverTime - deltaTime 
		if v.RecoverTime <= 0 then
			local maxType = AttrType2MaxType[v.RecoverAttrType]
			local value = self.baseAttrs[maxType] * v.RecoverAttrValue * 0.0001
			self:AddValue(v.RecoverAttrType, value)
			v.RecoverTime = v.RecoverNeedTime
		end

		::continue::
	end
end

function AttributesComponent:AfterUpdate()
	for type, oldValue in pairs(self.frameChangeAttrs) do
		EventMgr.Instance:Fire(EventName.EntityAttrChange, type, self.entity, oldValue, self.attrs[type])
		if type == FightEnum.RoleSkillPoint.Ex or type == FightEnum.RoleSkillPoint.Normal then
			EventMgr.Instance:Fire(EventName.EntityAttrChange, SetButtonEnum.UseCostMode.SkillPoint, self.entity)
		end
	end
	TableUtils.ClearTable(self.frameChangeAttrs)
end

function AttributesComponent:GetAttrGroup(groupType)
	if groupType == AttrGroupType.Base then
		return self.baseAttrs
	elseif groupType == AttrGroupType.Additvie then
		return self.additveAttrs
	end
end

function AttributesComponent:AddValue(attrType, value, groupType)
	if self.lockAttrTable[attrType] then
		return
	end
	groupType = groupType or AttrGroupType.Base
	if DataAttrsDefine[attrType] and DataAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
		value = value * 0.0001
	end
	local groupAttrs = self:GetAttrGroup(groupType)
	local oldValue = self.attrs[attrType]
	local setValue = 0
	if value < 0 then
		setValue = math.max(0, groupAttrs[attrType] + value)
	else
		local maxType = AttrType2MaxType[attrType]
		if maxType then
			setValue = math.min(groupAttrs[attrType] + value, self.attrs[maxType])
		else
			setValue = groupAttrs[attrType] + value
		end
	end

	if groupAttrs[attrType] == setValue then
		return
	end

	groupAttrs[attrType] = setValue

	local index, isPlayer = self.fight.playerManager:GetPlayer():GetEntityQTEIndex(self.entity.instanceId)
	local isDeath = self.entity.stateComponent:IsState(FightEnum.EntityState.Death) and self.entity.stateComponent.stateFSM:CheckDeathAnimState()
	if isPlayer and attrType == EntityAttrsConfig.AttrType.Life and value > 0 and isDeath then
		return
		-- self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end

	self:OnChangeAttrValue(attrType, oldValue)
end

function AttributesComponent:SetValue(attrType, value, groupType)
	if self.lockAttrTable[attrType] then
		return
	end
	if DataAttrsDefine[attrType] and DataAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
		value = value * 0.0001
	end
	groupType = groupType or AttrGroupType.Base
	local groupAttrs = self:GetAttrGroup(groupType)
	local maxType = AttrType2MaxType[attrType]
	local oldValue = self.attrs[attrType]
	if maxType then
		groupAttrs[attrType] = math.min(value, self.attrs[maxType])	
	else
		groupAttrs[attrType] = value
	end
	
	local index, isPlayer = self.fight.playerManager:GetPlayer():GetEntityQTEIndex(self.entity.instanceId)
	if isPlayer and attrType == EntityAttrsConfig.AttrType.Life and value > 0 and self.entity.stateComponent:IsState(FightEnum.EntityState.Death) then
		self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end

	self:OnChangeAttrValue(attrType, oldValue)
end

local AttrEmpertyFuncs = {
    [AttrType.Life] = function(self)
    	self.curLifeSection = self.curLifeSection + 1
    	if self.lifeSection and #self.lifeSection > 0 then
    		local maxLife = table.remove(self.lifeSection, 1)
			self:SetValue(AttrType.MaxLife, maxLife)
    		self:SetValue(AttrType.Life, maxLife)
			self:SetValue(AttrType.LifeBar, 10)
    		return
    	end
    	
		if self:CanDie() then
			--Log("kill "..self.entity.instanceId)
			if self.entity.stateComponent then
				self.entity.stateComponent:SetState(FightEnum.EntityState.Death, FightEnum.DeathReason.Damage, self.damageAttackEntity)
			else
				self.fight.entityManager:RemoveEntity(self.entity.instanceId)
			end
			
			self.fight.entityManager:AddResultDeadEntity(self.entity) 
		else
			self:SetValue(AttrType.Life, 1)
		end
    end
}


function AttributesComponent:OnChangeAttrValue(attrType, oldValue)
	local baseValue = self.baseAttrs[attrType]
	if not baseValue then
		return
	end

	--策划需要在属性修改前知道修改的情况
	local resultValue
	if Attr2AttrPercent[attrType] then
		baseValue = math.floor(self:GetCombinedBaseValue(attrType) * (1 + self:GetCombinedBaseValue(Attr2AttrPercent[attrType])))
		resultValue = baseValue + self.additveAttrs[attrType]
	else
		resultValue = self:GetCombinedBaseValue(attrType) + self.additveAttrs[attrType]
	end

	local maxType = AttrType2MaxType[attrType]
	if maxType then
		resultValue = math.min(resultValue, self.attrs[maxType])
	end
	if attrType == FightEnum.RoleSkillPoint.Ex or attrType == FightEnum.RoleSkillPoint.Normal then
		local curValue, maxValue = self:GetValueAndMaxValue(attrType)
		local pointValue = maxValue / 3
		local curPoint, curOverflow = math.modf(curValue / pointValue)
		local newPoint, oldOverflow = math.modf(resultValue / pointValue)
		if curPoint ~= newPoint then
			local type = attrType
			BehaviorFunctions.fight.entityManager:CallBehaviorFun("SkillPointChangeBefore", self.entity.instanceId, type, curPoint, newPoint - curPoint)
		end
	end

	if AttrPercent2Attr[attrType] then
		self.attrs[attrType] = resultValue
		self.attrs[AttrPercent2Attr[attrType]] = math.floor(self:GetCombinedBaseValue(AttrPercent2Attr[attrType]) * (1 + resultValue)) + self.additveAttrs[AttrPercent2Attr[attrType]]
	else
		self.attrs[attrType] = resultValue
	end
	if attrType == AttrType.Life and self.attrs[attrType] <= 0 then
		self.entity:CallBehaviorFun("BeforeDie", self.entity.instanceId)
	end
	
	if self.attrs[attrType] <= 0 then
		self:_AttrEmpty(attrType)
	end

	if ctx then
		--EventMgr.Instance:Fire(EventName.EntityAttrChange, attrType, self.entity, oldValue, self.attrs[attrType])
		self.frameChangeAttrs[attrType] = self.frameChangeAttrs[attrType] or oldValue
	end

    if attrType == AttrType.CommonAttr1 then
    	local player = Fight.Instance.playerManager:GetPlayer()
    	player:SyncBaseCommonAttr(self.entity.instanceId, attrType, self.attrs[attrType])
    end

    self.entity:CallBehaviorFun("ChangeAttrValue", attrType, self.attrs[attrType], self.attrs[attrType] - oldValue)

	--TODO 临时写死的黄蓝属性
	if attrType == FightEnum.RoleSkillPoint.Ex or attrType == FightEnum.RoleSkillPoint.Normal then
		--EventMgr.Instance:Fire(EventName.EntityAttrChange, SetButtonEnum.UseCostMode.SkillPoint, self.entity)
		local curValue, maxValue = self:GetValueAndMaxValue(attrType)
		local pointValue = maxValue / 3
		local curPoint, curOverflow = math.modf(curValue / pointValue)
		local oldPoint, oldOverflow = math.modf(oldValue / pointValue)
		if curPoint ~= oldPoint then
			local type = attrType
			EventMgr.Instance:Fire(EventName.SkillPointChangeAfter, self.entity.instanceId, type, oldPoint, curPoint)
			BehaviorFunctions.fight.entityManager:CallBehaviorFun("SkillPointChangeAfter", self.entity.instanceId, type, oldPoint, curPoint, curPoint - oldPoint)
		end
	end
end

function AttributesComponent:_AttrEmpty(attrType)
	local attrEmpertyFunc = AttrEmpertyFuncs[attrType]
	if attrEmpertyFunc then
    	attrEmpertyFunc(self)
    end

    if self.emptyEventMap and self.emptyEventMap[attrType] then
    	self.emptyEventMap[attrType].emptyTime = self.emptyEventMap[attrType].Time  
		for i, magicId in ipairs(self.emptyEventMap[attrType].SelfMagicList) do
			local magic = MagicConfig.GetMagic(magicId, self.entity.entityId)
			local buff = MagicConfig.GetBuff(magicId, self.entity.entityId)
			if magic then
				self.fight.magicManager:DoMagic(magic,nil,self.entity,self.entity,false)
			elseif buff and self.entity.buffComponent then
				self.entity.buffComponent:AddBuff(self.entity, magicId, 1)
			end
		end

		if not self.playerNpcTag then
			local player = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject() 
			for i, magicId in ipairs(self.emptyEventMap[attrType].PlayerMagicList) do
				local magic = MagicConfig.GetMagic(magicId, self.entity.entityId)
				local buff = MagicConfig.GetBuff(magicId, self.entity.entityId)
				if magic then
					self.fight.magicManager:DoMagic(magic,nil,player,player,false)
				elseif buff and self.entity.buffComponent then
					self.entity.buffComponent:AddBuff(player, magicId, 1)
				end
			end
		end
    end
end

function AttributesComponent:SyncBaseCommonAttr(attrType, attrValue)
	self.baseAttrs[attrType] = attrValue
	self.attrs[attrType] = attrValue
	EventMgr.Instance:Fire(EventName.EntityAttrChange, attrType, self.entity)
end

function AttributesComponent:CheckCost(attrType, costValue)
	return self.attrs[attrType] >= costValue
end

function AttributesComponent:CanDie()
	return not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneDie)
end

function AttributesComponent:GetValue(attrType)
	return self.attrs[attrType]
end

function AttributesComponent:GetBaseValue(attrType)
	return self.baseAttrs[attrType]
end

function AttributesComponent:GetValueAndMaxValue(attrType)
	local maxValue = 0
	local maxType = AttrType2MaxType[attrType]
	if maxType then
		maxValue = self.attrs[maxType]
	end
	if not self.attrs[attrType] then
		LogError(string.format("实体[%s]不存在属性[%s],但是在尝试获取它", self.entity.entityId, attrType))
	end
	return self.attrs[attrType], maxValue
end

function AttributesComponent:GetValueRatio(attrType)
	local maxType = AttrType2MaxType[attrType]
	if not maxType then
		return 0
	end

	local curValue = self:GetValue(attrType)
	local maxValue = self:GetValue(maxType)
	return math.floor(curValue / maxValue * 10000)
end

--获取角色基础属性值和玩家基础属性值组合后的结果
---@private
function AttributesComponent:GetCombinedBaseValue(attrType)
	if not self.entity.masterId or not DataPlayerAttrsDefine[attrType] then
		return self.baseAttrs[attrType]
	end
	if DataPlayerAttrsDefine[attrType].overlay_type == 1 then
		return self.baseAttrs[attrType] + BehaviorFunctions.GetPlayerBaseAttrVal(attrType)
	else
		return math.max(self.baseAttrs[attrType], BehaviorFunctions.GetPlayerBaseAttrVal(attrType) or 0)
	end
end

function AttributesComponent:SetDamageAttackEntity(attackEntity)
	self.damageAttackEntity = attackEntity

	if self.recoverEventMap then
		self.damageTime = self.fight.time
		for k, v in pairs(self.recoverEventMap) do
			if v.StopDmgCondition then
				v.StopDmgCondition.RecoverTime = 0
			end
		end
	end
end

function AttributesComponent:LockAttr(attrType, isLock)
	self.lockAttrTable[attrType] = isLock or false
end

function AttributesComponent:OnCache()
	TableUtils.ClearTable(self.recoverEventMap)
	TableUtils.ClearTable(self.emptyEventMap)
	TableUtils.ClearTable(self.lockAttrTable)
	TableUtils.ClearTable(self.attrs)
	TableUtils.ClearTable(self.additveAttrs)
	TableUtils.ClearTable(self.baseAttrs)
	TableUtils.ClearTable(self.frameChangeAttrs)
	self.fight.objectPool:Cache(AttributesComponent,self)
end

function AttributesComponent:__cache()
end

function AttributesComponent:__delete()
end