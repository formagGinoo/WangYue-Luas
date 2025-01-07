---@class Buff
Buff = BaseClass("Buff",PoolBaseClass)

function Buff:__init()
	self.magicOnFrame = {}
	self.magic = {}
	self.interval = {}
end

function Buff:Init(entity,relEntity,buffComponent,buffId,instanceId,level,formType, part)
	self.fight = entity.fight
	self.entity = entity
	self.relEntity = relEntity
	self.buffComponent = buffComponent
	self.clientBuffComponent = self.entity.clientEntity.clientBuffComponent

	-- buff配置信息
	self.buffId = buffId
	self.instanceId = instanceId
	self.level = level
	self.formType = formType
	self.part = part
	self.config = MagicConfig.GetBuff(buffId, relEntity.entityId, formType)
	if not self.config then
		LogError("buff id not found "..buffId)
		return
	end

	self.buffType = self.config.Type
	self.bindTimeScale = self.config.BindTimeScale or false
	self.durationFrame = self.config.DurationFrame

	-- buff延迟生效
	self.delayFrame = self.config.DelayFrame
	self.waitDelay = self.delayFrame > 0

	-- buff数值积累
	self.waitAttrAccumulate = self.buffType == FightEnum.BuffType.Accumulate
	self.curAccumulateValue = 0

	if self.config.Interval then
		for i = 1, #self.config.Interval do
			local tempTable =  { waitTime = self.config.Interval[i], intervalTime = 0 }
			self.interval[i] = tempTable
		end
	end

	if self.waitAttrAccumulate then
		if self.config.BindAttrType then
			EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("OnEntityAttrChange"))
		else
			EventMgr.Instance:AddListener(EventName.BuffValueChange, self:ToFunc("OnBuffValueChange"))
		end
	end

	if self.delayFrame == 0 and not self.waitAttrAccumulate then
		self:TakeEffect()
	end
end

-- 策划说buff累计数值就只会应用在加其他的buff上 所以就不放到update里面了
function Buff:Update()
	local timeScale = self.bindTimeScale and self.entity.timeComponent:GetTimeScale() or 1
	local time = FightUtil.deltaTimeSecond * timeScale
	if self.waitDelay then
		self.delayFrame = self.delayFrame - 1 * timeScale
		if self.delayFrame <= 0 then
			if not self.waitAttrAccumulate then
				self:TakeEffect()
			end
			self.waitDelay = false
		end
		return
	end

	for i = 1, #self.interval do
		if self.interval[i].waitTime > 0 then
			self.interval[i].intervalTime = self.interval[i].intervalTime + time
			if self.interval[i].intervalTime >= self.interval[i].waitTime then
				self.interval[i].intervalTime = 0
				self:DoMagic(i)
			end
		end
	end

	self.durationFrame = self.durationFrame - 1 * timeScale
	if self.durationFrame <= 0 and self.config.DurationFrame ~= -1 then
		self.buffComponent:RemoveBuffByInstacneId(self.instanceId)
	end
end

-- 监听属性变化 累加buff累计值
function Buff:OnEntityAttrChange(attrType, entity, oldValue, newValue)
	if self.config.AttrValueType ~= attrType or self.entity.isntanceId ~= entity.isntanceId then
		return
	end

	local changeValue = newValue - oldValue
	self.curAccumulateValue = self.curAccumulateValue + changeValue
	EventMgr.Instance:Fire(EventName.UIBuffValueChange, self.entity, self)

	if self.curAccumulateValue < self.config.NeedValue then
		return
	end

	self.buffComponent:AddBuff(self.relEntity, self.config.FinishBuffId, self.level, nil, nil, self.part)
	self.waitAttrAccumulate = false
	self:RemoveSelf()
end

function Buff:OnBuffValueChange(entity, buffValueType, value)
	if self.config.BuffValueType ~= buffValueType or self.entity.isntanceId ~= entity.isntanceId then
		return
	end

	self.curAccumulateValue = self.curAccumulateValue + value
	EventMgr.Instance:Fire(EventName.UIBuffValueChange, self.entity, self)

	if self.curAccumulateValue < self.config.NeedValue then
		return
	end

	self.buffComponent:AddBuff(self.relEntity, self.config.FinishBuffId, self.level, nil, nil, self.part)
	self.waitAttrAccumulate = false
	self:RemoveSelf()
end

function Buff:TakeEffect()
	if self.config.MagicIds then
		for i = 1, #self.config.MagicIds do
			self:DoMagic(i)
		end
	end

	if ctx then
		if self.config.EffectInfos and next(self.config.EffectInfos) and self.entity.clientEntity.clientBuffComponent then
			self.entity.clientEntity.clientBuffComponent:AddBuff(self)
		end
	end
end

function Buff:GetEffectPath()
	
end

function Buff:DoMagic(index)
	local magicCfg = MagicConfig.GetMagic(self.config.MagicIds[index], self.relEntity.entityId, self.formType)
	local magicTemp = {
		magic = magicCfg,
		instanceId = self.fight.magicManager:DoMagic(magicCfg, self.level, self.relEntity, self.entity, false, nil, self.formType, self.part, self.relEntity)
	}

	self.magic[index] = magicTemp
end

function Buff:CheckBuffKind(kind)
	for k, v in pairs(self.config.Kinds) do
		if kind == v then
			return true
		end
	end
	return false
end

function Buff:GetTimeOffset()
	local timeOffsetList = self.buffComponent.buffTimeOffset
	local timeOffset = 1
	for k, v in pairs(self.config.Kinds) do
		local data = timeOffsetList[v]
		if data then
			timeOffset = timeOffset * data.factor^data.count
			data.count = data.count + 1
		end
	end

	return timeOffset
end

function Buff:RemoveSelf()
	self.durationFrame = 0
	self.buffComponent:RemoveBuffByInstacneId(self.instanceId)
end

function Buff:OnCache()
	if self.waitAttrAccumulate then
		if self.config.BindAttrType then
			EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("OnEntityAttrChange"))
		else
			EventMgr.Instance:RemoveListener(EventName.BuffValueChange, self:ToFunc("OnBuffValueChange"))
		end
	end

	if ctx then
		if self.config.EffectInfos and next(self.config.EffectInfos) and self.entity.clientEntity.clientBuffComponent then
			self.entity.clientEntity.clientBuffComponent:RemoveBuff(self)
		end
	end

	if not self.config.MagicId and not self.config.MagicIds then
		return
	end

	for i = 1, #self.magic do
		local magic = self.magic[i].magic
		self.fight.magicManager:DoMagic(magic, self.level, self.relEntity, self.entity, true, self.magic[i].instanceId, self.formType, self.part, self.relEntity)
	end

	TableUtils.ClearTable(self.magic)
	TableUtils.ClearTable(self.interval)

	self.fight.objectPool:Cache(Buff,self)
end

function Buff:GetDurationFrame()
	return self.durationFrame
end

function Buff:__cache()
end

function Buff:__delete()
end