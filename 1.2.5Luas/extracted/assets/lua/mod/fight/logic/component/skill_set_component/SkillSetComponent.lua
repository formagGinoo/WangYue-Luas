

local KeyEvent2Btn = FightEnum.KeyEvent2Btn
local SkillBtn2Event = FightEnum.SkillBtn2Event
---@class SkillSetComponent
SkillSetComponent = BaseClass("SkillSetComponent",PoolBaseClass)

--#region 基本生命周期
function SkillSetComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.skillComponent = self.entity.skillComponent
	self.setConfig = self.entity:GetComponentConfig(FightEnum.ComponentType.SkillSet).UISets[1]
	self.setButtonList = {}

	self.setButtonInfos = self.skillComponent:GetSetButtonInfos()
	--构建部分通用按钮
	for btnName, keyEvent in pairs(SkillBtn2Event) do
		local config = self.setConfig[btnName]
		if config and config.Active and config.SkillId == 0 then
			local setButton = self.fight.objectPool:Get(SetButton)
			local setButtonInfo = {SkillIcon = config.SkillIcon}
			setButton:Init(fight,self.entity, setButtonInfo, keyEvent) --没有指定skillId就使用keyEvent做为索引
			self.setButtonList[keyEvent] = setButton
		end
	end

	--初始化核心技能,核心技能一定包含资源类型
	self.coreAttrTable = {}
	local coreInfos = self.setConfig.CoreInfos or {}
	for key, info in pairs(coreInfos) do
		local setButton = self.fight.objectPool:Get(SetButton)
		setButton:Init(fight, self.entity, info, info.UseCostType)
		self.setButtonList[info.UseCostType] = setButton
		table.insert(self.coreAttrTable, info.UseCostType)
	end

	--初始化技能
	for skillId, setButtonInfo in pairs(self.setButtonInfos) do
		local setButton = self.fight.objectPool:Get(SetButton)
		setButton:Init(fight,self.entity, setButtonInfo[1], skillId)
		self.setButtonList[skillId] = setButton
	end
	self:ResetMap()
end

function SkillSetComponent:UpdateIgnoreTimeScale()
	for index, value in pairs(self.KeyMap) do
		if self.setButtonList[value] then
			self.setButtonList[value]:Update()
		end
	end

	for skillId, needUpdate in pairs(self.skillUpdateList) do
		if self.setButtonList[skillId] and needUpdate then
			self.setButtonList[skillId]:Update()
		end
	end
end

function SkillSetComponent:OnCache()
	for k, v in pairs(self.setButtonList) do
		v:OnCache()
	end
	self.setConfig = nil
	self.setButtonList = nil
	self.setButtonInfos = nil
	self.KeyMap = nil
	self.skillUpdateList = nil
	self.fight.objectPool:Cache(SkillSetComponent,self)
end

--#endregion

--#region 技能按钮动态绑定，修改\获取技能基本信息

--重置按钮与技能映射
function SkillSetComponent:ResetMap()
	self.KeyMap = {}
	self.keyEventMap = {}
	self.skillUpdateList = {}

	for btnName, keyEvent in pairs(SkillBtn2Event) do
		local config = self.setConfig[btnName]
		if config and config.Active then
			if config.SkillId == 0 then
				self.KeyMap[keyEvent] = keyEvent
				self.keyEventMap[keyEvent] = keyEvent
			else
				self.KeyMap[keyEvent] = config.SkillId
				self.keyEventMap[config.SkillId] = keyEvent
			end
		end
	end

	--核心技能也要跑updata
	for key, attrType in pairs(self.coreAttrTable) do
		self.KeyMap[attrType] = attrType
		self.keyEventMap[attrType] = attrType
	end

	--初始化后台更新技能/后台更新技能是没有绑定到按键上，但是需要计算cd等逻辑的技能/常用于被关联技能的实体
	for _, skillId in pairs(self.setConfig.SkillUpdateList or {}) do
		local setButton = self.setButtonList[skillId]
		self.setButtonList[skillId] = setButton
		self.skillUpdateList[skillId] = true
	end

	self.relevanceSkillMap = {}
	self.relevanceEntityMap = {}
end

--关联其他实体技能
function SkillSetComponent:RelevanceSkill(instanceId, keyEvent, key)

	local tempEntity = self.fight.entityManager:GetEntity(instanceId)
	local realKey = tempEntity.skillSetComponent:GetKey(key)

	if not self.relevanceEntityMap[instanceId] then
		self.relevanceEntityMap[instanceId] = {}
	end
	if self.relevanceEntityMap[instanceId][realKey] and self.relevanceEntityMap[instanceId][realKey] == keyEvent then
		return
	end
	self.relevanceEntityMap[instanceId][realKey] = keyEvent

	if self.relevanceSkillMap[keyEvent] and next(self.relevanceSkillMap[keyEvent]) then
		local tempId = self.relevanceSkillMap[keyEvent].instanceId
		local tempKey = self.relevanceSkillMap[keyEvent].key
		local relevanceEntity = self.fight.entityManager:GetEntity(self.relevanceSkillMap[keyEvent].instanceId)
		relevanceEntity.skillSetComponent:SetButtonRelevanceEntity(self.entity.instanceId, realKey, false)
		self.relevanceEntityMap[tempId][tempKey] = nil
	end

	self.relevanceSkillMap[keyEvent] = {instanceId = instanceId, key = realKey}

	tempEntity.skillSetComponent:SetButtonRelevanceEntity(self.entity.instanceId, realKey, true)
	EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, keyEvent)
end

function SkillSetComponent:CancelRelevanceSkill(instanceId, keyEvent)
	local relevanceEntity = self.fight.entityManager:GetEntity(instanceId)
	if keyEvent then
		if self.relevanceSkillMap[keyEvent] then
			local config = self.relevanceSkillMap[keyEvent]
			local id, key = config.instanceId, config.key
			self.relevanceEntityMap[id][key] = nil
			self.relevanceSkillMap[keyEvent] = nil
			relevanceEntity.skillSetComponent:SetButtonRelevanceEntity(self.entity.instanceId, key, false)
			EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, keyEvent)
		end
	elseif instanceId then
		if self.relevanceEntityMap[instanceId] then
			for key, value in pairs(self.relevanceEntityMap[instanceId]) do
				relevanceEntity.skillSetComponent:SetButtonRelevanceEntity(self.entity.instanceId, self.relevanceSkillMap[value].key, false)
				self.relevanceSkillMap[value] = nil
				EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, value)
			end

			self.relevanceEntityMap[instanceId] = nil
		end
	end
end

function SkillSetComponent:CancelRelevanceAllSkill()
	for instanceId, Info in pairs(self.relevanceEntityMap) do
		for key, value in pairs(Info) do
			local relevanceEntity = BehaviorFunctions.GetEntity(instanceId)
			relevanceEntity.skillSetComponent:SetButtonRelevanceEntity(self.entity.instanceId, self.relevanceSkillMap[value].key, false)
		end
	end

	TableUtils.ClearTable(self.relevanceEntityMap)
	TableUtils.ClearTable(self.relevanceSkillMap)

	for key, keyEvent in pairs(FightEnum.SkillBtn2Event) do
		EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, keyEvent)
	end
end

function SkillSetComponent:SetButtonRelevanceEntity(instanceId, key, isAdd)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:SetRelevanceEntity(instanceId, isAdd)
	end
end

--更新技能信息变化
function SkillSetComponent:UpdateBtnShow(key, instanceId)
	local keyEvent
	if instanceId == self.entity.instanceId then
		if not self.relevanceSkillMap[keyEvent] then
			keyEvent = self:GetSkillKeyEvent(key)
		end
	elseif self.relevanceEntityMap[instanceId] then
		keyEvent = self.relevanceEntityMap[instanceId][key]
	end
	if keyEvent then
		EventMgr.Instance:Fire(EventName.UpdateSkillInfo, keyEvent, self.entity.instanceId)
	end
end

--技能资源释放完成
function SkillSetComponent:CastCostComplete(key, instanceId)
	local keyEvent
	if instanceId == self.entity.instanceId then
		keyEvent = self:GetSkillKeyEvent(key)
	elseif self.relevanceEntityMap[instanceId] then
		keyEvent = self.relevanceEntityMap[instanceId][key]
	end
	if keyEvent then
		EventMgr.Instance:Fire(EventName.CastSkillUIEffect, keyEvent, self.entity.instanceId)
	end
end

--切换技能模板
function SkillSetComponent:ChangeSkillTemplate(skillId, index)
	local config = self.setButtonInfos[skillId][index]
	local setButton = self:GetSetButton(skillId)
	setButton:ChangeTemplate(config)
	for keyEvent, value in pairs(self.KeyMap) do
		if skillId == value then
			EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, keyEvent)
		end
	end
end

--设置按钮绑定技能
function SkillSetComponent:SetSkillBtnId(keyEvent, skillId)
	if self:ChangeButtonMap(keyEvent, skillId) then
		EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, keyEvent)
	end
end

--修改按钮映射
function SkillSetComponent:ChangeButtonMap(keyEvent, skillId)
	---如果skillId在后台技能列表，交换映射
	if self.KeyMap[keyEvent] and self.KeyMap[keyEvent] ~= skillId then
		if self.skillUpdateList[self.KeyMap[keyEvent]] ~= nil then
			self.skillUpdateList[self.KeyMap[keyEvent]] = true
		end
		if self.skillUpdateList[skillId] then
			self.skillUpdateList[skillId] = false
		end
		self.KeyMap[keyEvent] = skillId
		self.keyEventMap[skillId] = keyEvent
		return true
	end
	return false
end

--修改技能配置
function SkillSetComponent:SetSkillBehaviorConfig(key, behaviorType, value)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:ChangeConfig(behaviorType, value)
		for keyEvent, skillId in pairs(self.KeyMap) do
			if key == skillId then
				EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, keyEvent)
			end
		end
	end
end

--修改技能图标
function SkillSetComponent:SetSkillBtnIcon(key, skillIcon)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		local config = self:GetConfig(key)
		config.SkillIcon = skillIcon
		for keyEvent, value in pairs(self.KeyMap) do
			if key == value then
				EventMgr.Instance:Fire(EventName.ChangeButtonConfig, self.entity.instanceId, keyEvent)
				break;
			end
		end
	end
end

--获取技能绑定keyevent
function SkillSetComponent:GetSkillKeyEvent(key)
	return self.keyEventMap[key]
end

--获取技能信息
function SkillSetComponent:GetSkill(key)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		return self.setButtonList[key]:GetSkill()
	end
end

--获取技能配置
function SkillSetComponent:GetConfig(key)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		return self.setButtonList[key]:GetConfig()
	end
end

function SkillSetComponent:GetSetButton(key)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		return self.setButtonList[key]
	end
end

function SkillSetComponent:GetSkillByBtnName(btnName)
	if	SkillBtn2Event[btnName] then
		local keyEvent = SkillBtn2Event[btnName]
		local config = self.relevanceSkillMap[keyEvent]
		if config then
			local entity = BehaviorFunctions.GetEntity(config.instanceId)
			if entity and entity.skillSetComponent then
				return entity.skillSetComponent:GetSkill(keyEvent)
			end
		end
		return self:GetSkill(keyEvent)
	end
end

function SkillSetComponent:GetConfigByBtnName(btnName)
	if SkillBtn2Event[btnName] then
		local keyEvent = SkillBtn2Event[btnName]
		local config = self.relevanceSkillMap[keyEvent]
		if config then
			local entity = BehaviorFunctions.GetEntity(config.instanceId)
			if entity and entity.skillSetComponent then
				return entity.skillSetComponent:GetConfig(keyEvent)
			end
		end
		return self:GetConfig(keyEvent)
	end
end

function SkillSetComponent:GetSetButtonByBtnName(btnName)
	if SkillBtn2Event[btnName] then
		local keyEvent = SkillBtn2Event[btnName]
		local config = self.relevanceSkillMap[keyEvent]
		if config then
			local entity = BehaviorFunctions.GetEntity(config.instanceId)
			if entity and entity.skillSetComponent then
				return entity.skillSetComponent:GetSetButton(keyEvent)
			end
		end
		return self:GetSetButton(keyEvent)
	end
end

function SkillSetComponent:GetConfigAndKeyEvent(key)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		return self.setButtonList[key]:GetConfig(key), self:GetSkillKeyEvent(key)
	end
end

--检查配置组件是否存在
function SkillSetComponent:CheckSkillBehaviorConfig(key, behaviorType)
	key = self:GetKey(key)
	local config = self:GetConfig(key)
	if config and config[behaviorType] then
		return true, config[behaviorType]
	end
end

--设置技能基本信息,历史遗留，可能会优化
function SkillSetComponent:SetSkillBaseInfo(key, useCostType, useCostValue, maxChargeTimes, maxCDtime)
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:SetSkillBaseInfo(useCostType, useCostValue, maxChargeTimes, maxCDtime)
	end
end

--#endregion

--#region 特化方法

--禁用按钮使用状态
function SkillSetComponent:DisableButton(key, disable)
	key = self:GetKey(key)

	if not self.setButtonList[key] then
		return
	end
	self.setButtonList[key]:DisableButton(disable)
end

function SkillSetComponent:DisableAllButton(disable)
	for key, value in pairs(self.setButtonList) do
		value:DisableButton(disable)
	end
end

--检查是否可以使用技能
function SkillSetComponent:CheckUseSkill(key, showEffect)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:CheckUseSkill(key, showEffect)
		end
	end

	key = self:GetKey(key)
	if not self.setButtonList[key] then
		return false
	end
	if showEffect then
		showEffect = self.entity.instanceId == BehaviorFunctions.GetCtrlEntity()
	end
	return self.setButtonList[key]:CheckUseSkill(showEffect)
end

--检查是否能使用子弹时间
function SkillSetComponent:CheckUseDodge(key)
	key = self:GetKey(key)
	if not self.setButtonList[key] then
		return false
	end
	return self.setButtonList[key]:CheckUseDodge()
end

function SkillSetComponent:SetBtnSkillCDTime(key, cdTime, isCheckRelevance)
	if isCheckRelevance then
		local config = self.relevanceSkillMap[key]
		if config then
			local entity = BehaviorFunctions.GetEntity(config.instanceId)
			if entity and entity.skillSetComponent then
				return entity.skillSetComponent:SetBtnSkillCDTime(key, cdTime)
			end
		end
	end

	key = self:GetKey(key)
	if key and self.setButtonList[key] then
		self.setButtonList[key]:SetBtnSkillCDTime(cdTime)
	end
end

function SkillSetComponent:ChangeBtnSkillCDTime(key, cdTime)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:ChangeBtnSkillCDTime(key, cdTime)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:ChangeBtnSkillCDTime(cdTime)
	end
end

function SkillSetComponent:SetChargeCD(key, cdTime)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:SetChargeCD(key, cdTime)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:SetChargeCD(cdTime)
	end
end

function SkillSetComponent:ChangeChargeCD(key, cdTime)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:ChangeChargeCD(key, cdTime)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:ChangeChargeCD(cdTime)
	end
end

function SkillSetComponent:SetChargePoint(key, value)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:SetChargePoint(key, value)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:SetChargePoint(value)
	end
end

function SkillSetComponent:ChangeChargePoint(key, value)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:ChangeChargePoint(key, value)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:ChangeChargePoint(value)
	end
end

function SkillSetComponent:CancelChargeChange(key)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:CancelChargeChange(key)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:RecordCommond(false)
	end
end

function SkillSetComponent:GetSkillCostValue(key)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:GetSkillCostValue(key)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		local value = self.setButtonList[key]:GetCostValue()
		return value
	end
end

function SkillSetComponent:CastSkillCost(key)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:CastSkillCost(key)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		self.setButtonList[key]:CastSkillCost()
	end
end

function SkillSetComponent:GetSkillCostType(key)
	local config = self.relevanceSkillMap[key]
	if config then
		local entity = BehaviorFunctions.GetEntity(config.instanceId)
		if entity and entity.skillSetComponent then
			return entity.skillSetComponent:GetSkillCostType(key)
		end
	end
	key = self:GetKey(key)
	if self.setButtonList[key] then
		return self.setButtonList[key]:GetSkillCostType()
	end
end

--供外部使用
function SkillSetComponent:GetSkillIdByKeyEvent(keyEvent)
	return self.KeyMap[keyEvent]
end

function SkillSetComponent:GetKeyEventBySkillId(skillId)
	for keyEvent, id in pairs(self.KeyMap) do
		if id == skillId then
			return keyEvent
		end
	end
end

--#endregion

--#region 通用技能点
function SkillSetComponent:GetSkillPointCost()
	local attr =  self.entity.attrComponent
    local curValue, maxValue = attr:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Ex)
    local pointValue1 = maxValue / 3
	local exPoint, exOverflow = math.modf(curValue / pointValue1)

    curValue, maxValue = attr:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Normal)
    local pointValue2 = maxValue / 3
    local normalPoint, yellowOverflow = math.modf(curValue / pointValue2)
    return exPoint + normalPoint, exPoint, normalPoint, pointValue1, pointValue2
end

function SkillSetComponent:AddSkillPoint(type, addValue)
    local attr =  self.entity.attrComponent
    if type == FightEnum.RoleSkillPoint.Ex then
		local curValue, maxValue = attr:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Ex)
		local pointValue = maxValue / 3
		addValue = addValue * pointValue
		attr:AddValue(FightEnum.RoleSkillPoint.Ex, addValue)
		local all, ex, normal = self:GetSkillPointCost()
		return ex, all
    elseif type == FightEnum.RoleSkillPoint.Normal then
		local curValue, maxValue = attr:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Normal)
		local pointValue = maxValue / 3
		addValue = addValue * pointValue
		attr:AddValue(FightEnum.RoleSkillPoint.Normal, addValue)
		local all, ex, normal = self:GetSkillPointCost()
		return normal, all
    end
end

function SkillSetComponent:SetSkillPoint(type, value)
	local attr =  self.entity.attrComponent
    if type == FightEnum.RoleSkillPoint.Ex then
		local curValue, maxValue = attr:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Ex)
		local pointValue = maxValue / 3
		value = value * pointValue
		attr:SetValue(FightEnum.RoleSkillPoint.Ex, value)
		local all, ex, normal = self:GetSkillPointCost()
		return ex, all
    elseif type == FightEnum.RoleSkillPoint.Normal then
		local curValue, maxValue = attr:GetValueAndMaxValue(FightEnum.RoleSkillPoint.Normal)
		local pointValue = maxValue / 3
		value = value * pointValue
		attr:SetValue(FightEnum.RoleSkillPoint.Normal, value)
		local all, ex, normal = self:GetSkillPointCost()
		return normal, all
    end
end
--#endregion

--#region 其他
function SkillSetComponent:GetKey(key)
	if self.KeyMap[key] then
		return self.KeyMap[key]
	end
	return key
end

function SkillSetComponent:GetUIBindRes()
	return self.setConfig["BindResList"]
end

function SkillSetComponent:GetCorePrefabPath()
	return self.setConfig["BindResPath"]
end

function SkillSetComponent:GetCoreAttrTable()
	return self.coreAttrTable or {}
end
--#endregion
