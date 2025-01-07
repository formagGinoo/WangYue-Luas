---@class AttributesComponent
AttributesComponent = BaseClass("AttributesComponent",PoolBaseClass)

---@type AttrType
local AttrType = EntityAttrsConfig.AttrType --普通属性
local SpecialType = EntityAttrsConfig.SpecialType --连乘属性
local TotolType = EntityAttrsConfig.TotolType -- 复合属性
local ShieldType = EntityAttrsConfig.ShieldType
local ShieldPriority = EntityAttrsConfig.ShieldPriority
local Attr2Total = EntityAttrsConfig.Attr2Total
local Totol2Attr = EntityAttrsConfig.Totol2Attr
local Attr2AttrPercent = EntityAttrsConfig.Attr2AttrPercent
local AttrPercent2Attr = EntityAttrsConfig.AttrPercent2Attr
local AttrOverlayType = FightEnum.AttrOverlayType
local AttrType2MaxType = EntityAttrsConfig.AttrType2MaxType
local AllowLessThanZero = EntityAttrsConfig.AllowLessThanZero
local DataNpc = Config.DataNpc
local DataHero = Config.DataHero
local DataGlobal = Config.DataGlobal.data_global
local DataAttrsDefine = Config.DataAttrsDefine.Find
local DataHeroMain = Config.DataHeroMain.Find
local DataPlayerAttrsDefine = Config.DataPlayerAttrsDefine.Find

local _floor = math.floor
local AttrArea = 
{
	Base = 1,-- 基础属性，加算
	Special = 2, --特殊属性，乘算, table
	Final = 3,-- 结果值不能直接修改
}

function AttributesComponent:__init()
	self.name = "Attributes"
	self._attrs = {}
	self.backups = {} --备份属性

	self.shieldMap = {} --每一个来源的护盾详细信息
	self.shieldTypeMap = {} --同一属性类型护盾的来源记录
	
	self.uniqueKey = 0 --转化条件的自增id
	--key更新时，对应value都要更新
	self.transitionInfo = {}
	--key更新时，要统计value中的所有值
	self.reverseTransition = {}

	self.transitionRecord = {}

	self.npcConfig = nil

	self.recoverEventMap = {}
	self.emptyEventMap = {}
	self.lockAttrTable = {}

	self.frameChangeAttrs = {}

	self.damageTime = 0

	self.transformFunc = {
		[FightEnum.AttrTranslationType.Percentage] = AttributesComponent.TransformByPercentage,
		[FightEnum.AttrTranslationType.FixedValue] = AttributesComponent.TransformByFixedValue,
	}

	-- 登记属性来源
	self.attrWithSource = {}
end

function AttributesComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.level =  entity.params and entity.params.level
	self.subjoinLev = entity.params and entity.params.subjoinLev
	self.playerNpcTag = false
	self.secretKey = math.random(100000,999999)
	self.totalShild = 0

	for k, v in pairs(AttrArea) do
		self._attrs[v] = {}
		self.backups[v] = {}
	end

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
	for k, v in pairs(AttrType) do
		if SpecialType[v] then
			self._attrs[AttrArea.Special][v] = {}
		else
			self:_SetValue(AttrArea.Base, v, 0)
		end

	end
	local npcTag = self.entity.tagComponent.npcTag
	if npcTag == FightEnum.EntityNpcTag.Player then
		self.playerNpcTag = true
		self.npcConfig = DataHeroMain[self.entity.parent.masterId]
		local curRoleInfo = mod.RoleCtrl:GetRoleData(self.entity.parent.masterId) 
		--TODO 兼容黑幕
		self.level = curRoleInfo and curRoleInfo.lev or 1
		local levelAttrs = EntityAttrsConfig.GetHeroBaseAttr(self.entity.masterId, self.level)
		for k, v in pairs(levelAttrs) do
			self:_AddBaseValue(k, v)
		end
		local stageAttrs = EntityAttrsConfig.GetHeroStageAttr(self.entity.masterId, curRoleInfo and curRoleInfo.stage or 0)
		for k, v in pairs(stageAttrs) do
			self:_AddBaseValue(k, v)
		end
	else
		local attrId = self.config.DefaultAttrID
		if self.entity.masterId then
			self.npcConfig = Config.DataMonster.Find[self.entity.masterId]
			attrId = self.npcConfig.attr_id
		end
		--先判断处于副本内需要读副本表的等级配置
		local dupLevel = mod.DuplicateCtrl:GetMonsterLevelByDup(self.entity.masterId, npcTag)
		self.level = dupLevel or self.level
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

		if self.subjoinLev then
			self.level = self.level + self.subjoinLev
		end
		local monsterAttrs = EntityAttrsConfig.GetMonsterBaseAttr(attrId, self.level)
		for k, v in pairs(monsterAttrs) do
			self:_AddBaseValue(k, v)
		end
		self:_SetValue(AttrArea.Base, AttrType.LifeBar, 10)
		if self:_GetValue(AttrArea.Base, AttrType.LifeBar) == 0 then
			self:_SetValue(AttrArea.Base, AttrType.LifeBar, 10)
		end
	end

	for k, attrType in pairs(AttrType) do
		self:_SetValue(AttrArea.Final, attrType, self:CalcFinalTotalAttrValue(attrType))
	end


	self:_SetValue(AttrArea.Base, AttrType.Life, self:GetValue(AttrType.MaxLife))
	self:_SetValue(AttrArea.Final, AttrType.Life, self:CalcFinalTotalAttrValue(AttrType.Life))

	self:_SetValue(AttrArea.Base, AttrType.Armor, self:GetValue(AttrType.MaxArmor))
	self:_SetValue(AttrArea.Final, AttrType.Armor, self:CalcFinalTotalAttrValue(AttrType.Armor))
	
	self:_SetValue(AttrArea.Base, AttrType.Dodge, self:GetValue(AttrType.MaxDodge))
	self:_SetValue(AttrArea.Final, AttrType.Dodge, self:CalcFinalTotalAttrValue(AttrType.Dodge))
	
	self:_SetValue(AttrArea.Base, AttrType.MaxCommonAttr1, DataGlobal.FightAttrCommonAttr1Max.ivalue)
	self:_SetValue(AttrArea.Final, AttrType.Dodge, self:CalcFinalTotalAttrValue(AttrType.Dodge))
	

	self.maxLifeSection = 1
	for i = 0, 1 do
		local maxLife = self:GetValue(AttrType.MaxLife2 + i)
		if maxLife and maxLife > 0 then
			self.lifeSection = self.lifeSection or {} 
			table.insert(self.lifeSection, maxLife)
			self.maxLifeSection = self.maxLifeSection + 1
		end
	end
	self.curLifeSection = 1
end

function AttributesComponent:_AddBaseValue(type, value)
	if DataAttrsDefine[type] and DataAttrsDefine[type].value_type == FightEnum.AttrValueType.Percent then
		value = value * 0.0001
	end
	if SpecialType[type] then
		self:AddSpecialValue(type, value)
	else
		local tempValue = self:_GetValue(AttrArea.Base, type) or 0
		self:_SetValue(AttrArea.Base, type, tempValue + value)
	end

end

function AttributesComponent:Update()
	if not self.recoverEventMap or self:_GetValue(AttrArea.Final, AttrType.Life) <= 0 then
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
			local value = self:_GetValue(AttrArea.Base, maxType) * v.RecoverAttrValue * 0.0001
			self:AddValue(v.RecoverAttrType, value)
			v.RecoverTime = v.RecoverNeedTime
		end

		::continue::
	end
end

function AttributesComponent:AfterUpdate()
	for type, oldValue in pairs(self.frameChangeAttrs) do
		EventMgr.Instance:Fire(EventName.EntityAttrChange, type, self.entity, oldValue, self:_GetValue(AttrArea.Final, type))
		if type == FightEnum.RoleSkillPoint.Ex or type == FightEnum.RoleSkillPoint.Normal then
			EventMgr.Instance:Fire(EventName.EntityAttrChange, SetButtonEnum.UseCostMode.SkillPoint, self.entity)
		end
	end
	TableUtils.ClearTable(self.frameChangeAttrs)
end


--- func desc
---@param attrType any
---@param value any
---@param groupType any 已弃用
function AttributesComponent:AddValue(attrType, value, sourceParam)
	if self.lockAttrTable[attrType] then
		return
	end
	if DataAttrsDefine[attrType] and DataAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
		value = value * 0.0001
	end

	if SpecialType[attrType] then
		return self:AddSpecialValue(attrType, value)
	end

	local changeValue = value
	local setValue = 0
	if sourceParam and sourceParam.haveMaxValue then
		local oldValue = 0
		if self.attrWithSource[sourceParam.sourceType] and self.attrWithSource[sourceParam.sourceType][sourceParam.sourceKey] then
			oldValue = self.attrWithSource[sourceParam.sourceType][sourceParam.sourceKey]
		elseif not self.attrWithSource[sourceParam.sourceType] then
			self.attrWithSource[sourceParam.sourceType] = {}
		end

		local after = oldValue + changeValue
		if math.abs(after) >= math.abs(sourceParam.maxValue) then
			if math.abs(after - sourceParam.maxValue) >= math.abs(changeValue) or (math.abs(after) == math.abs(sourceParam.maxValue) and math.abs(oldValue) > math.abs(after)) then
				changeValue = 0
			else
				local c = math.abs(after - sourceParam.maxValue)
				changeValue = changeValue < 0 and changeValue + c or changeValue - c
			end
		end

		self.attrWithSource[sourceParam.sourceType][sourceParam.sourceKey] = after
	end

	local oldValue = self:_GetValue(AttrArea.Final, attrType)
	local groupAttrValue = self:_GetValue(AttrArea.Base, attrType)
	local maxType = AttrType2MaxType[attrType]
	if maxType then
		setValue = MathX.Clamp(groupAttrValue + changeValue, 0, self:_GetValue(AttrArea.Final, maxType))
	else
		setValue = groupAttrValue + changeValue
	end

	if groupAttrValue == setValue then
		return
	end

	self:_SetValue(AttrArea.Base, attrType, setValue)

	local index, isPlayer = self.fight.playerManager:GetPlayer():GetEntityQTEIndex(self.entity.instanceId)
	local isDeath = self.entity.stateComponent:IsState(FightEnum.EntityState.Death) and self.entity.stateComponent.stateFSM:CheckDeathAnimState()
	if isPlayer and attrType == EntityAttrsConfig.AttrType.Life and changeValue > 0 and isDeath then
		return
		-- self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
	end

	self:OnChangeAttrValue(attrType, oldValue)
end

function AttributesComponent:AddSpecialValue(attrType, value)
	if value == 0 then
		return
	end

	local oldValue = self:_GetValue(AttrArea.Final, attrType)
	local attrData = self._attrs[AttrArea.Special][attrType]
	if value > 0 then
		table.insert(attrData, value)
	else
		local isExist
		for k, v in pairs(attrData) do
			if -value == v then
				isExist = true
				table.remove(attrData,k)
				break
			end
		end
		if not isExist then
			LogErrorf("没有添加过值为%s的属性类型%s，现在正在尝试移除它", value, attrType)
			return
		end
	end
	self:OnChangeAttrValue(attrType, oldValue)
end

--- func desc
---@param attrType any
---@param value any
---@param groupType any 已弃用
function AttributesComponent:SetValue(attrType, value, groupType)
	if SpecialType[attrType] then
		LogError("该属性不支持直接设置", attrType)
		return
	end
	if self.lockAttrTable[attrType] then
		return
	end
	if DataAttrsDefine[attrType] and DataAttrsDefine[attrType].value_type == FightEnum.AttrValueType.Percent then
		value = value * 0.0001
	end

	local maxType = AttrType2MaxType[attrType]
	local oldValue = self:_GetValue(AttrArea.Final, attrType)

	if maxType then
		local setValue = MathX.Clamp(value, 0, self:_GetValue(AttrArea.Final, maxType))
		self:_SetValue(AttrArea.Base, attrType, setValue)
	else
		self:_SetValue(AttrArea.Base, attrType, value)
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
				if not self:CheckConcludeBuffState() then
					EventMgr.Instance:Fire(EventName.EntityWillDie, self.entity.instanceId)
					self.entity.stateComponent:SetState(FightEnum.EntityState.Death, FightEnum.DeathReason.Damage, self.damageAttackEntity)
				else
					EventMgr.Instance:Fire(EventName.EntityWillDie, self.entity.instanceId)
					self.entity.stateComponent:SetState(FightEnum.EntityState.Death, FightEnum.DeathReason.CatchDeath, self.damageAttackEntity)
				end
			else
				self.fight.entityManager:RemoveEntity(self.entity.instanceId)
			end
			
			self.fight.entityManager:AddResultDeadEntity(self.entity) 
		else
			self:SetValue(AttrType.Life, 1)
		end
    end
}

-- 检查是否存在缔结buff
function AttributesComponent:CheckConcludeBuffState()
	if not self.entity:CheckConcludeBuffState() then return end
	return true
end

function AttributesComponent:OnChangeAttrValue(attrType, oldValue)
	oldValue = oldValue or self:_GetValue(AttrArea.Final, attrType)

	--策划需要在属性修改前知道修改的情况
	local resultValue = self:CalcFinalTotalAttrValue(attrType)
	if attrType == FightEnum.RoleSkillPoint.Ex or attrType == FightEnum.RoleSkillPoint.Normal then
		local curPoint, newPoint = self:CalcSkillPoint(attrType, resultValue)
		if curPoint ~= newPoint then
			BehaviorFunctions.fight.entityManager:CallBehaviorFun("SkillPointChangeBefore", 
			self.entity.instanceId, attrType, curPoint, newPoint - curPoint)
		end
	end

	self:_SetValue(AttrArea.Final, attrType, resultValue)

	if attrType == AttrType.Life and  self:_GetValue(AttrArea.Final, attrType) <= 0 then
		self.entity:CallBehaviorFun("BeforeDie", self.entity.instanceId)
	end
	
	if  self:_GetValue(AttrArea.Final, attrType) <= 0 then
		self:_AttrEmpty(attrType)
	end

	if ctx then
		self.frameChangeAttrs[attrType] = self.frameChangeAttrs[attrType] or oldValue
	end

    if attrType == AttrType.CommonAttr1 then
    	local player = Fight.Instance.playerManager:GetPlayer()
    	player:SyncBaseCommonAttr(self.entity.instanceId, attrType, resultValue)
    end

	EventMgr.Instance:Fire(EventName.EntityAttrChangeImmediately, self.entity, attrType, resultValue, oldValue)
	self.entity:CallBehaviorFun("ChangeAttrValue", attrType, resultValue, resultValue - oldValue)
	if attrType == FightEnum.RoleSkillPoint.Ex or attrType == FightEnum.RoleSkillPoint.Normal then
		local curPoint, oldPoint = self:CalcSkillPoint(attrType, oldValue)
		if curPoint ~= oldPoint then
			EventMgr.Instance:Fire(EventName.SkillPointChangeAfter, self.entity.instanceId, attrType, oldPoint, curPoint)
			BehaviorFunctions.fight.entityManager:CallBehaviorFun("SkillPointChangeAfter", self.entity.instanceId, 
			attrType, oldPoint, curPoint, curPoint - oldPoint)
		end
	end

	--改变的复合属性的组成属性，其外显属性也要改变
	local totalType = Attr2Total[attrType]
	if totalType and totalType ~= attrType then
		self:OnChangeAttrValue(totalType)
	end

	--改变的是百分比属性，其原始属性也要更新
	if AttrPercent2Attr[attrType] then
		for k, originalAttr in pairs(AttrPercent2Attr[attrType]) do
			self:OnChangeAttrValue(originalAttr)
		end
	end
end

function AttributesComponent:CalcSkillPoint(attrType, value)
	local curValue, maxValue = self:GetValueAndMaxValue(attrType)
	local pointValue = maxValue / 3
	local curPoint, curOverflow = math.modf(curValue / pointValue)
	local point, oldOverflow = math.modf(value / pointValue)

	return curPoint, point
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
	self:_SetValue(AttrArea.Final, attrType, attrValue)
	self:_SetValue(AttrArea.Base, attrType, attrValue)
	EventMgr.Instance:Fire(EventName.EntityAttrChange, attrType, self.entity)
end

function AttributesComponent:CheckCost(attrType, costValue)
	-- if self.entity.masterId then
	-- 	return BehaviorFunctions.GetPlayerBaseAttrVal(attrType) >= costValue
	-- else
	-- 	return self:_GetValue(AttrGroupType.Attrs, attrType) >= costValue
	-- end
	return self:_GetValue(AttrArea.Final, attrType) >= costValue
end

function AttributesComponent:CanDie()
	return not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneDie)
end

-- isFloor 向下取整
function AttributesComponent:GetValue(attrType, isFloor)
	local value = self:_GetValue(AttrArea.Final, attrType)
	if isFloor then
		value = (value > 0 and value < 1) and 1 or value
		value = _floor(value)
	end
	return value
end

function AttributesComponent:GetBaseValue(attrType)
	return self:GetCombinedBaseValue(attrType)
end

function AttributesComponent:GetValueAndMaxValue(attrType)
	local maxValue = 0
	local maxType = AttrType2MaxType[attrType]
	if maxType then
		maxValue = self:_GetValue(AttrArea.Final, maxType)
	end
	return self:_GetValue(AttrArea.Final, attrType), maxValue
end

function AttributesComponent:_GetValue(group, key)
	if group == AttrArea.Special then return end
	local res = 0
	if self._attrs[group][key] then
		res = (self._attrs[group][key] ~ self.secretKey) * 0.0001
		if self.backups[group][key] ~= res then
			LogError("备份数据校验错误", key)
		end
	else
		--Log("实体属性不存在!", key)
	end
	return res
end

function AttributesComponent:_SetValue(group, key, value)
	if group == AttrArea.Special then return end
	--浮点数精度问题
	local res = _floor((value + 0.00001) * 10000)
	self._attrs[group][key] = res ~ self.secretKey
	self.backups[group][key] = res *  0.0001
end

function AttributesComponent:GetValueRatio(attrType)
	local maxType = AttrType2MaxType[attrType]
	if not maxType then
		return 0
	end

	local curValue = self:GetValue(attrType)
	local maxValue = self:GetValue(maxType)
	return _floor(curValue / maxValue * 10000)
end

function AttributesComponent:GetTranslationValue(type, originalType, ...)
	local info = {}
	info.type = type
	info.originalType = originalType
	--info.targetAttr = targetAttr
	info.uniqueKey = self.uniqueKey + 1
	info.params = {}
	for i, v in ipairs({...}) do
		info.params[i] = v
	end
	return self.transformFunc[info.type](self, info)
end

--添加属性转化
function AttributesComponent:AddTranslation(type, originalType, targetAttr, dynamicUpdate, ...)
	self.transitionInfo[originalType] = self.transitionInfo[originalType] or {}
	self.reverseTransition[targetAttr] = self.reverseTransition[targetAttr] or {}
	local info = {}
	info.type = type
	info.originalType = originalType
	info.targetAttr = targetAttr
	info.dynamicUpdate = dynamicUpdate
	self.uniqueKey = self.uniqueKey + 1
	info.uniqueKey = self.uniqueKey
	info.params = {}
	for i, v in ipairs({...}) do
		info.params[i] = v
	end
	self.transitionInfo[originalType][info.uniqueKey] = info
	self.reverseTransition[targetAttr][info.uniqueKey] = info
	self.transitionRecord[info.uniqueKey] = info
	self:OnChangeAttrValue(targetAttr)
	return info.uniqueKey
end

--移除属性转化
function AttributesComponent:RemoveTranslation(uniqueKey)
	local info = self.transitionRecord[uniqueKey]

	self.transitionInfo[info.originalType][uniqueKey] = nil
	self.reverseTransition[info.targetAttr][uniqueKey] = nil
	self:OnChangeAttrValue(info.targetAttr)

	--LogError("尝试移除为添加过的属性转化", type, originalType, targetAttr)
end

--计算最终属性 + 转化属性
function AttributesComponent:CalcFinalTotalAttrValue(attrType, recordLog)
	local logTable = recordLog and {}
	--判断复合属性
	local resultValue = self:GetTotalAttrValue(attrType, logTable)
	local oldValue = resultValue

	--是否有其他属性转化为它
	local infos = self.reverseTransition[attrType]
	if infos and next(infos) then
		for k, info in pairs(infos) do
			resultValue = resultValue + self.transformFunc[info.type](self, info)
		end
	end

	if logTable and resultValue ~= oldValue then
		table.insert(logTable, "转化值：".. resultValue - oldValue)
	end

	local maxType = AttrType2MaxType[attrType]
	if maxType then
		resultValue = math.min(resultValue, self:_GetValue(AttrArea.Final, maxType))
	end
	resultValue =  EntityAttrsConfig.GetEntityAttrValue(attrType, resultValue)

	return resultValue, logTable
end

--计算最终属性
function AttributesComponent:GetTotalAttrValue(attrType, logTable)
	--判断复合属性
	local resultValue = 0
	local oldValue = self:GetFinalAttrValue(attrType)
	local totalType = Attr2Total[attrType]
	if totalType and totalType == attrType then
		for _, type in pairs(Totol2Attr[totalType]) do
			local tempValue = self:GetFinalAttrValue(type, logTable)
			resultValue = resultValue + tempValue
		end
	else
		resultValue = self:GetFinalAttrValue(attrType, logTable)
	end

	if logTable and resultValue ~= oldValue then
		table.insert(logTable, "额外值:"..resultValue - oldValue)
	end

	return resultValue
end

--获取应用百分比属性后的属性
function AttributesComponent:GetFinalAttrValue(attrType, logTable)
	local oldValue = self:GetAllGroupValue(attrType, logTable)
	local resultValue
	if Attr2AttrPercent[attrType] then
		resultValue = oldValue * (1 + self:GetAllGroupValue(Attr2AttrPercent[attrType]))
	else
		resultValue = oldValue
	end
	if logTable and oldValue ~= resultValue then
		table.insert(logTable, string.format("属性id:%s，加成值:%s",attrType, resultValue - oldValue))
	end
	return resultValue
end

--获取基础属性在所有分区的和
function AttributesComponent:GetAllGroupValue(attrType, logTable)
	local res = self:GetCombinedBaseValue(attrType, logTable)
	return res
end

--获取角色基础属性值和玩家基础属性值组合后的结果
---@private
function AttributesComponent:GetCombinedBaseValue(attrType, logTable)
	local baseValue
	if SpecialType[attrType] then
		local attrData = self._attrs[AttrArea.Special][attrType]
		if next(attrData) then
			baseValue = 1
			for k, v in pairs(attrData) do
				baseValue = baseValue * (1 - v)
			end
			baseValue = 1 - baseValue
		else
			baseValue = 0
		end
	else
		baseValue = self:_GetValue(AttrArea.Base, attrType)
	end

	if not self.entity.masterId or not DataPlayerAttrsDefine[attrType] then
		if logTable then
			table.insert(logTable, string.format("包含属性:%s, 基础值:%s, 实体：%s", attrType, baseValue, baseValue))
		end
		return baseValue
	end
	local playerValue = BehaviorFunctions.GetPlayerAttrVal(attrType) or 0

	if DataPlayerAttrsDefine[attrType].overlay_type == AttrOverlayType.Additvie then
		if logTable then
			table.insert(logTable, string.format("包含属性:%s, 基础值（叠加）:%s, 实体：%s，玩家：%s", attrType, baseValue + playerValue, baseValue, playerValue))
		end
		return baseValue + playerValue
	else
		local result = math.max(self:_GetValue(AttrArea.Base, attrType), playerValue)
		if logTable then
			table.insert(logTable, string.format("包含属性:%s, 基础值(最大):%s, 实体：%s，玩家：%s", attrType, result, baseValue, playerValue))
		end
		return math.max(self:_GetValue(AttrArea.Base, attrType), playerValue)
	end
end

--#region --属性转化类型方法
-- info.type = type
-- info.originalType = originalType
-- info.targetAttr = targetAttr
-- info.uniqueKey = self.uniqueKey + 1
-- info.params = {}

--按参数1(万分比)比例转化
function AttributesComponent:TransformByPercentage(info)
	if not info.dynamicUpdate and info.snapshootValue then
		return info.snapshootValue
	end

	local originalValue = self:GetTotalAttrValue(info.originalType)
	if not info.dynamicUpdate then
		info.snapshootValue = originalValue * info.params[1] * 0.0001	
	end
	return originalValue * info.params[1] * 0.0001
end

--参数1的部分按参数2(万分比)比例转化,参数3:大于/小于
function AttributesComponent:TransformByFixedValue(info)
	if not info.dynamicUpdate and info.snapshootValue then
		return info.snapshootValue
	end

	local originalValue = self:GetTotalAttrValue(info.originalType)
	local operation = info.params[3] or FightEnum.ComparisonOperation.GreaterThan
	local res = 0
	if operation == FightEnum.ComparisonOperation.GreaterThan then
		if originalValue > info.params[1] then
			res = originalValue - info.params[1]
			res = res * info.params[2] * 0.0001
		end
	elseif operation == FightEnum.ComparisonOperation.LessThan then
		res = math.min(originalValue, info.params[1])
		res = res * info.params[2] * 0.0001
	end

	if not info.dynamicUpdate then
		info.snapshootValue = res
	end

	return res
end
--#endregion

-- 护盾吸收伤害
function AttributesComponent:DeductShield(value)
	local tempValue = value
	for index, types in ipairs(ShieldPriority) do
		local surplus = tempValue
		for _, type in ipairs(types) do
			if self.shieldTypeMap[type] then
				for source, v in pairs(self.shieldTypeMap[type]) do
					local info = self.shieldMap[source]
					if info.curValue > tempValue then
						info.curValue = info.curValue - tempValue
						surplus = 0
					else
						surplus = math.min(surplus, tempValue - info.curValue)
						self:RemoveShield(info.source, true)
					end
				end
				self:CalcShield(type)
			end
		end

		tempValue = surplus
		if tempValue == 0 then
			break
		end
	end

	return tempValue
end

--添加护盾, 属性类型， 来源（magicId）,叠加模式
function AttributesComponent:AddShield(type, value, source, overlayMode, maxValue)
	value = value * (self:GetValue(AttrType.ShieldPercent) + 1)
	self.shieldTypeMap[type] = 	self.shieldTypeMap[type] or {}
	if self.shieldMap[source] then
		local info = self.shieldMap[source]
		if overlayMode == FightEnum.EOverlayMode.Superposition then --叠加
			info.totalValue = math.min(value + info.curValue, info.maxValue)
			info.curValue = info.totalValue
		elseif overlayMode == FightEnum.EOverlayMode.Refresh then --刷新
			info.totalValue = value
			info.curValue = info.totalValue
		elseif overlayMode == FightEnum.EOverlayMode.Inherit then --继承
			
		end
	else
		self.shieldMap[source] = {}
		local info = self.shieldMap[source]
		info.source = source
		info.type = type
		info.maxValue = maxValue
		info.totalValue = value
		info.curValue = value
		self.shieldTypeMap[type][source] = true
	end

	self:CalcShield(type)
end

--移除护盾
function AttributesComponent:RemoveShield(source, notCalc)
	if not self.shieldMap[source] then
		return
	end
	local type = self.shieldMap[source].type
	self.shieldMap[source] = nil
	self.shieldTypeMap[type][source] = nil  
	if notCalc then
		local buffComponent = self.entity.buffComponent
		if buffComponent then
			buffComponent:RemoveByMagic(FightEnum.MagicType.AddShield ,source)
		end
	else
		self:CalcShield(type)
	end
end

function AttributesComponent:CalcShield(type)
	local oldValue = self:GetValue(type)
	local resValue = 0
	for source, v in pairs(self.shieldTypeMap[type]) do
		resValue = math.max(self.shieldMap[source].curValue, resValue)
	end

	if resValue ~= oldValue then
		self:SetValue(type, resValue)
		self:ShildChanged()
	end
end

function AttributesComponent:ShildChanged()
	local oldValue = self.totalShild
	local newValue = 0
	for index, types in ipairs(ShieldPriority) do
		local tempValue = 0
		for _, type in pairs(types) do
			tempValue = math.max(tempValue, self:GetValue(type))
		end
		newValue = newValue + tempValue
	end
	self.totalShild = newValue
end

function AttributesComponent:GetTotalShild()
	return self.totalShild
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
	TableUtils.ClearTable(self._attrs)
	TableUtils.ClearTable(self.backups)
	TableUtils.ClearTable(self.transitionInfo)
	TableUtils.ClearTable(self.reverseTransition)
	TableUtils.ClearTable(self.frameChangeAttrs)
	TableUtils.ClearTable(self.shieldMap)
	TableUtils.ClearTable(self.shieldTypeMap)
	TableUtils.ClearTable(self.transitionRecord)
	
	self.fight.objectPool:Cache(AttributesComponent,self)
end

function AttributesComponent:__cache()
end

function AttributesComponent:__delete()
end