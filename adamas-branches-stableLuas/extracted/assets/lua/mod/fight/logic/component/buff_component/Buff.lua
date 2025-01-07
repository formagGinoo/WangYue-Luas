---@class Buff
Buff = BaseClass("Buff",PoolBaseClass)
local AttrType = EntityAttrsConfig.AttrType

function Buff:__init()
	self.magicOnFrame = {}
	self.magic = {}
	self.interval = {}
end

function Buff:Init(entity, relEntity, buffComponent, buffParams)
	self.fight = entity.fight
	self.entity = entity
	self.relEntity = relEntity
	self.buffComponent = buffComponent
	self.clientBuffComponent = self.entity.clientEntity.clientBuffComponent

	self.buffParams = buffParams
	self.instanceIdRecord = {}
	-- buff配置信息
	self.buffId = buffParams.buffId
	self.instanceId = buffParams.buffInstance
	self.level = buffParams.level
	self.formType = buffParams.kind
	self.part = buffParams.part
	self.skillType = buffParams.skillType

	self.ownerInstanceId = relEntity.parent and relEntity.parent.instanceId or nil
	self.config = MagicConfig.GetBuff(self.buffId, relEntity.entityId, self.formType, self.ownerInstanceId)
	if not self.config then
		LogError("buff id not found "..self.buffId)
		return
	end

	self.buffType = self.config.Type
	self.bindTimeScale = self.config.BindTimeScale or false
	self.configDuration = self:GetConfigDuration()
	self.durationFrame = self:GetBuffDuration()

	-- buff延迟生效
	self.delayFrame = self.config.DelayFrame
	self.waitDelay = self.delayFrame > 0

	-- buff数值积累
	self.waitAttrAccumulate = self.buffType == FightEnum.BuffType.Accumulate
	self.curAccumulateValue = 0

	-- buff层数计算
	self.buffLayer = 1
	self.isBuffLayerEffect = self.config.IsBuffLayer
	self.maxBuffLayer = self.config.MaxBuffLayer
	self.decLayer = self.config.DecLayer
	self.decBuffLayerTime = self.config.DecLayerFrame

	if self.config.Interval then
		for i = 1, #self.config.Interval do
			local magicId = self.config.MagicIds[i]
			local kind = self.config.kindId
			local config = MagicConfig.GetConfig(magicId, self.level, kind)
			local waitTime = config and config.interval or self.config.Interval[i]
			local firstTime = config and config.first_time
			if not firstTime then
				firstTime = self.config.FirstTimes and self.config.FirstTimes[i] or 0
			end
			firstTime = math.floor(firstTime * 30)
			waitTime = math.floor(waitTime * 30)
			local intervalTime = firstTime ~= 0 and waitTime - firstTime or 0
			local tempTable =  { waitTime = waitTime, intervalTime = intervalTime, firstTime = firstTime}
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
	EventMgr.Instance:AddListener(EventName.RemoveEntity, self:ToFunc("OnEntityRemove"))

	if self.delayFrame == 0 and not self.waitAttrAccumulate then
		self:TakeEffect()
	end
end

function Buff:GetConfigDuration()
	local magicLevelConfig = MagicManager.GetMagicLevelConfig(self.buffId, self.config.kindId, self.level)
	local magicConstConfig = MagicManager.GetMagicConstConfig(self.buffId, self.config.kindId)
	local configDuration = magicLevelConfig and magicLevelConfig.duration or 0
	if magicConstConfig and magicConstConfig.duration > 0 and configDuration == 0 then
		configDuration = magicConstConfig.duration
	end

	return configDuration > 0 and configDuration * FightUtil.logicTargetFrameRate or self.config.DurationFrame
end

function Buff:GetBuffDuration()
	local duration = self.configDuration
	if duration <= 0 then
		return duration
	end

	local per = 1
	local minPer = Config.DataGlobal.data_global["BuffMinDurationPer"].ivalue * 0.0001
	local isDebuff = BehaviorFunctions.CheckIsDebuffByID(self.relEntity.entityId, self.buffId)
	local isBuff = BehaviorFunctions.CheckIsBuffByID(self.relEntity.entityId, self.buffId)
	if self.entity.attrComponent and (isDebuff or isBuff) then
		local attrType = isDebuff and AttrType.DebuffDurationPercent or AttrType.BuffDurationPercent
		local val = BehaviorFunctions.GetEntityAttrVal(self.entity.instanceId, attrType)
		-- TODO 优化一下获取值的方法
		per = per + val
	end
	if self.relEntity.attrComponent and (isDebuff or isBuff)then
		local attrType = isDebuff and AttrType.InflictionDebuffDurationPercent or AttrType.InflictionBuffDurationPercent
		local val = self.relEntity.attrComponent:GetValue(attrType)
		per = per + val
	end
	per = per < minPer and minPer or per
	local offset = self:GetTimeOffset()
	return duration * per * offset
end

-- 策划说buff累计数值就只会应用在加其他的buff上 所以就不放到update里面了
function Buff:Update()
	local timeScale = self.bindTimeScale and self.entity.timeComponent:GetTimeScale() or 1
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

	local time = 1 * timeScale
	if not self.isBuffLayerEffect then
		for i = 1, #self.interval do
			if self.interval[i].waitTime > 0 then
				self.interval[i].intervalTime = self.interval[i].intervalTime + time
				while self.interval[i].intervalTime >= self.interval[i].waitTime do
					self.interval[i].intervalTime = self.interval[i].intervalTime - self.interval[i].waitTime
					self:DoMagic(i)
				end
			end
		end
	else
		self:CheckBuffLayer(timeScale)
		self:UpdateBuffLayerEffect(time)
	end

	self.durationFrame = self.durationFrame - 1 * timeScale
	if self.durationFrame <= 0 and self.configDuration ~= -1 then
		self.buffComponent:RemoveBuffByInstacneId(self.instanceId)
	end
end

function Buff:CheckBuffLayer(timeScale)
	self.decBuffLayerTime = self.decBuffLayerTime - 1 * timeScale
	if self.decBuffLayerTime <= 0 and self.buffLayer > 1 then
		self.buffLayer = math.max(self.buffLayer - self.decLayer, 1)
		self.decBuffLayerTime = self.config.DecLayerFrame
		return
	end
	self.decBuffLayerTime = math.max(0, self.decBuffLayerTime)
end

function Buff:UpdateBuffLayerEffect(time)
	local curLayer = self.buffLayer
	if self.effectLayer and curLayer == self.effectLayer then return end
	local magicData = self.interval[curLayer]
	if magicData and magicData.waitTime > 0 then
		magicData.intervalTime = magicData.intervalTime + time
		if magicData.intervalTime >= magicData.waitTime then
			magicData.intervalTime = magicData.intervalTime - magicData.waitTime
			self:DoMagic(curLayer)
			self.effectLayer = curLayer
		end
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

	self.buffComponent:AddBuff(self.relEntity, self.config.FinishBuffId, self.level, nil, nil, self.part, self.skillType)
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

	self.buffComponent:AddBuff(self.relEntity, self.config.FinishBuffId, self.level, nil, nil, self.part,self.skillType)
	self.waitAttrAccumulate = false
	self:RemoveSelf()
end

function Buff:OnEntityRemove(instanceId)
	if not self.config.BindRefEntity or not self.relEntity then
		return
	end

	-- 针对子弹的处理不一定需要 但是以防有子弹有行为树 用行为树上了个BUFF 那太幽默了吧
	local isBullet = not self.relEntity.tagComponent or self.relEntity.tagComponent.tag == FightEnum.EntityTag.Bullet
	local checkInstance = isBullet and self.relEntity.parent.instanceId or self.relEntity.instanceId
	if checkInstance ~= instanceId then
		return
	end

	self:RemoveSelf()
end

function Buff:TakeEffect()
	if self.config.MagicIds then
		for i = 1, #self.config.MagicIds do
			if self.interval[i].firstTime == 0 then
				self:DoMagic(i)
			end
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
	local parentInstanceId = self.relEntity.parent and self.relEntity.parent.instanceId or nil
	local magicCfg = MagicConfig.GetMagic(self.config.MagicIds[index], self.relEntity.entityId, self.formType, parentInstanceId)
	local sourceParam = { sourceKey = self.buffId, sourceType = FightEnum.AttrSourceType.Buff }
	local customParams = { sourceParam = sourceParam }
	local magicTemp = {
		magic = magicCfg,
		instanceId = self.fight.magicManager:DoMagic(magicCfg, self.level, self.relEntity, self.entity, 
		false, nil, self.formType, self.part, self.relEntity, customParams, self.skillType)
	}

	self.magic[index] = magicTemp
	self:AddListener(index)
end

function Buff:AddListener(index)
	local magicTemp = self.magic[index]
	if not magicTemp.instanceId then
		return
	end
	local type = magicTemp.magic.Type
	self.instanceIdRecord[type] = self.instanceIdRecord[type] or {}
	self.instanceIdRecord[type][magicTemp.instanceId] = magicTemp.instanceId
end

function Buff:RemoveByMagic(type, instanceId)
	if self.instanceIdRecord[type] and self.instanceIdRecord[type][instanceId] then
		self.instanceIdRecord[type][instanceId] = nil
		self:RemoveSelf()
	end
end

function Buff:CheckBuffKind(kind)
	for k, v in pairs(self.config.Kinds) do
		if kind == v then
			return true
		end
	end
	return false
end

function Buff:CheckEffectKind(kind)
	return self.config.EffectType == kind
end

function Buff:GetTimeOffset()
	local timeOffset = 1
	local minOffset, maxOffset = 1, 1
	for k, kind in pairs(self.config.Kinds) do
		local min, max = self.buffComponent:GetBuffTimeOffset(kind, self.config.EffectType)
		minOffset = min < minOffset and min or minOffset
		maxOffset = max > maxOffset and max or maxOffset
	end
	if minOffset < 1 and maxOffset < 1 then
		timeOffset = minOffset
	elseif minOffset > 1 and maxOffset > 1 then
		timeOffset = maxOffset
	elseif minOffset < 1 and maxOffset > 1 then
		timeOffset = minOffset * maxOffset
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
	EventMgr.Instance:RemoveListener(EventName.RemoveEntity, self:ToFunc("OnEntityRemove"))

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
		self.fight.magicManager:DoMagic(magic, self.level, self.relEntity, self.entity, true, 
		self.magic[i].instanceId, self.formType, self.part, self.relEntity, nil, self.skillType)
	end

	TableUtils.ClearTable(self.magic)
	TableUtils.ClearTable(self.interval)
	TableUtils.ClearTable(self.instanceIdRecord)

	self.fight.objectPool:Cache(Buff,self)
end

function Buff:GetDurationFrame()
	return self.durationFrame
end

------------------- 层数Buff
function Buff:CheckAddBuffLayer()
	if not self.isBuffLayerEffect then return end
	self.buffLayer = self.buffLayer + 1
	self.buffLayer = math.min(self.buffLayer, self.maxBuffLayer)
	return true
end

function Buff:__cache()
end

function Buff:__delete()
end