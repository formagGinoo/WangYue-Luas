---@class FightConditionManager
FightConditionManager = BaseClass("FightConditionManager")

local ConditionType = FightEnum.FightConditionType
local MeetConditionEventType = FightEnum.MeetFightConditionEventType

local EventState = {
	Ready = 1,
	Cooling = 2,
	DelayForEvent = 3,
}

function FightConditionManager:__init(fight)
	self.fight = fight
	
	self.listeners = {}
	self.frame = 0
	
	self.removeList = {}
end

function FightConditionManager:__delete()
	EventMgr.Instance:RemoveListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	--EventMgr.Instance:RemoveListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:RemoveListener(EventName.OnDoDamage, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:RemoveListener(EventName.OnEntityBuffChange, self:ToFunc("OnEntityBuffChange"))
end

function FightConditionManager:StartFight()
	self:BindEnumFuncs()
	self:BindListener()
end

function FightConditionManager:BindEnumFuncs()
	self.conditions = {
		[ConditionType.LifeInRange] = self:ToFunc("LifeInRange"),
		[ConditionType.HitCount] = self:ToFunc("HitCount"),
		[ConditionType.HasBuff] = self:ToFunc("HasBuff")
	}
	
	self.events = {
		[MeetConditionEventType.CustomCallback] = self:ToFunc("CustomCallback"),
		[MeetConditionEventType.SuperArmor] = self:ToFunc("SuperArmor"),
	}
end

function FightConditionManager:BindListener()
	EventMgr.Instance:AddListener(EventName.EntityAttrChange, self:ToFunc("EntityAttrChange"))
	--EventMgr.Instance:AddListener(EventName.OnEntityHit, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:AddListener(EventName.OnDoDamage, self:ToFunc("OnEntityHit"))
	EventMgr.Instance:AddListener(EventName.OnEntityBuffChange, self:ToFunc("OnEntityBuffChange"))
end

function FightConditionManager:AddListenerList(instanceId, listenerList)
	for _, v in pairs(listenerList) do
		self:AddListener(instanceId, v.EventId, v)
	end
end

function FightConditionManager:AddListener(instanceId, eventId, params)
	local listener = self.listeners[instanceId]
	if not listener then
		self.listeners[instanceId] = {}
		listener = self.listeners[instanceId]
	end
	
	if listener[eventId] then
		return 
	end
	
	listener[eventId] = {
		instanceId = instanceId, --实例ID
		eventId = eventId, --事件ID
		params = params, --事件参数
		count = params.Count or -1, --剩余触发次数
		eventState = EventState.Ready, --状态
		changeFrame = self.frame, --状态改变的帧数
		meets = {}, --完成列表
	}
	
	local conditionCount = params.ConditionList and #params.ConditionList or 0
	if conditionCount == 0  then
		self:TryDoEvent(listener[eventId])
	end
end

function FightConditionManager:RemoveListener(instanceId, eventId)
	local event = self.listeners[instanceId]
	if not event then
		return
	end

	event[eventId] = nil
end

function FightConditionManager:Update()
	self.frame = self.frame + 1
	
	TableUtils.ClearTable(self.removeList)
	for instanceId, events in pairs(self.listeners) do
		if BehaviorFunctions.CheckEntity(instanceId) then
			for eventId, data in pairs(events) do
				if data.eventState == EventState.Cooling then
					if self.frame >= data.changeFrame then
						data.eventState = EventState.Ready
						self:CheckConditionMeet(data)
					end
				elseif data.eventState == EventState.DelayForEvent then
					if self.frame >= data.changeFrame then
						self:DoEvent(data)
					end
				end
			end
		else
			table.insert(self.removeList, instanceId)
		end
	end
	
	for _, v in pairs(self.removeList) do
		self.listeners[v] = nil
	end
end

function FightConditionManager:UpdateCondition(conditionType, events, ...)
	if not events or not next(events) then
		return
	end

	for eventId, data in pairs(events) do
		local meetCount = self:UpdateMeet(data, conditionType, ...)
		
		if meetCount > 0 then
			self:CheckConditionMeet(data)
		end
	end
end

function FightConditionManager:UpdateMeet(data, conditionType, ...)
	local conditionList = data.params.ConditionList or {}
	local meetCount = 0
	
	for idx, v in pairs(conditionList) do
		if v.ConditionType == conditionType then
			if not data.meets[idx] then
				data.meets[idx] = {}
				data.meets[idx].config = v
				data.meets[idx].type = conditionType
			end

			local meet, record = self.conditions[conditionType](v, data.meets[idx].record, false, ...)

			data.meets[idx].meet = meet
			data.meets[idx].record = record

			if meet then
				meetCount = meetCount + 1
			end
		end
	end
	
	return meetCount
end

function FightConditionManager:CheckConditionMeet(data)
	if data.eventState ~= EventState.Ready then
		return
	end
	
	local meetConditionCount = data.params.MeetConditionCount or -1
	local conditionList = data.params.ConditionList or {}
	local condCount = meetConditionCount == -1 and #conditionList or meetConditionCount
	local meets = data.meets
	local meetCount = 0
	
	for _, v in pairs(meets) do
		if v.meet and self.conditions[v.type](v.config, v.record, true) then
			meetCount = meetCount + 1
		end
	end
	
	if meetCount >= condCount then
		self:TryDoEvent(data)
	end
end

function FightConditionManager:TryDoEvent(data)
	if data.eventState ~= EventState.Ready then
		return
	end
	
	local delay = data.params.DelayTime or 0
	if delay == 0 then
		self:DoEvent(data)
	else
		data.eventState = EventState.DelayForEvent
		data.changeFrame = self.frame + math.ceil(delay * FightUtil.targetFrameRate)
	end
end

function FightConditionManager:DoEvent(data)
	if data.eventState == EventState.Cooling then
		return
	end
	
	local eventList = data.params.MeetConditionEventList
	for _, v in pairs(eventList) do
		self.events[v.MeetConditionEventType](data.instanceId, data.eventId, v)
	end
	
	for _, v in pairs(data.meets) do
		if v.record and v.record.clean then
			v.record = nil
		end
	end
	
	data.count = data.count - 1
	if data.count == 0 then
		self:RemoveListener(data.instanceId, data.eventId)
	else
		local interval = data.params.Interval or 0.01
		local cooling = interval == 0 and 0.01 or interval
		if cooling == 0 then
			self:TryDoEvent(data)
		else
			data.eventState = EventState.Cooling
			data.changeFrame = self.frame + math.ceil(cooling * FightUtil.targetFrameRate)
		end
	end
end

--条件判断
--[[
参数：
data：编辑器的配置数据
record：上次记录的数据【第二个返回值】
onlyCheck：只做条件检查【为true时无后续参数】
...：后续参数是需要检查的参数

--返回值：
第一个返回值：条件是否满足
第二个返回值：记录的数据
]]
function FightConditionManager:LifeInRange(data, record, onlyCheck, lifePercent)
	record = record or {}
	record.lifePercent = record.lifePercent or -1
	if not onlyCheck then
		record.lifePercent = lifePercent
	end

	if data.MinLife == 0 and data.MaxLife == 0 then
		return record.lifePercent == 0, record
	end
	return data.MinLife < record.lifePercent and record.lifePercent <= data.MaxLife, record
end

function FightConditionManager:HasBuff(data, record, onlyCheck, isSelfBuff, buffId, isAdd)
	record = record or {}
	
	if not onlyCheck then
		if isSelfBuff then
			if not record.selfBuff then
				record.selfBuff = {}
			end
			
			local buffIdList = data.SelfBuffIdList
			for i = 1, #buffIdList do
				local id = buffIdList[i]
				if buffId == id then
					record.targetBuff[id] = isAdd
				end
			end
		else
			if not record.targetBuff then
				record.targetBuff = {}
			end
			
			local buffIdList = data.TargetBuffIdList
			for i = 1, #buffIdList do
				local id = buffIdList[i]
				if buffId == id then
					record.targetBuff[id] = isAdd
				end
			end
		end
	end
	
	for _, v in pairs(data.SelfBuffIdList) do
		if not record.selfBuff or not record.selfBuff[v] then
			return false, record
		end
	end
	
	for _, v in pairs(data.TargetBuffIdList) do
		if not record.targetBuff or not record.targetBuff[v] then
			return false, record
		end
	end
	
	return true, record
end

function FightConditionManager:HitCount(data, record, onlyCheck, instanceId)
	record = record or {clean = true}
	record.count = record.count or 0
	record.resetFrame = record.resetFrame or self.frame
	record.startCountFrame = record.startCountFrame or self.frame
	
	if not onlyCheck then
		if self.frame >= record.resetFrame then
			record.count = 0
			record.startCountFrame = self.frame
		end
		
		local entity = self.fight.entityManager:GetEntity(instanceId)
		local immuneHit = false
		if entity and entity.buffComponent and entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHit) then
			immuneHit = true
		end
		if not immuneHit then
			record.minusCount = false
			record.count = record.count + 1
		elseif data.CountWhenSuperArmor then
			record.count = record.count + 1
		end
		
		if immuneHit and not record.minusCount then
			record.count = math.max(record.count - data.MinusCountWhenSuperArmor, 0)
			record.minusCount = true
		end

		record.resetFrame = self.frame + math.ceil(data.CountInterval * FightUtil.targetFrameRate)
	end
	
	return record.count >= data.Count and self.frame < record.resetFrame and 
			(self.frame - record.startCountFrame) >= data.HitDuration * FightUtil.targetFrameRate, record
end

--事件触发
function FightConditionManager:CustomCallback(instanceId, eventId, data)
	self.fight.entityManager:CallBehaviorFun("ConditionEvent", instanceId, eventId)
end

local SuperArmorBuffId = 900000040
local BuffEntityId = 1000
function FightConditionManager:SuperArmor(instanceId, eventId, data)
	local buffConfig = MagicConfig.GetBuff(SuperArmorBuffId, BuffEntityId)
	if buffConfig then
		local duration = data.Duration
		if data.Duration > 0 then
			duration = data.Duration * FightUtil.targetFrameRate
		end
		buffConfig.DurationFrame = duration
		BehaviorFunctions.AddBuff(1, instanceId, SuperArmorBuffId)
	end
end


--信号接收
function FightConditionManager:EntityAttrChange(attrType, entity, oldValue, newValue)
	local instanceId = entity.instanceId
	if not self.listeners[instanceId] then
		return 
	end
	
	if attrType == EntityAttrsConfig.AttrType.Life then
		local val, maxVal = entity.attrComponent:GetValueAndMaxValue(EntityAttrsConfig.AttrType.Life)
		self:UpdateCondition(ConditionType.LifeInRange, self.listeners[instanceId], (val / maxVal) * 100)
	end
end

function FightConditionManager:OnEntityHit(atkInstanceId, hitInstanceId, hitType)
	if not self.listeners[hitInstanceId] then
		return
	end
	
	self:UpdateCondition(ConditionType.HitCount, self.listeners[hitInstanceId], hitInstanceId)
end

function FightConditionManager:OnEntityBuffChange(instanceId, buffInstanceId, buffId, isAdd)
	local listenerList = {}
	if self.listeners[instanceId] then
		table.insert(listenerList, instanceId)
	end
	
	for k, _ in pairs(self.listeners) do
		local entity = self.fight.entityManager:GetEntity(k)
		if entity then
			local target = entity.skillComponent and entity.skillComponent.target
			if target and target.instanceId == instanceId then
				table.insert(listenerList, k)
			end
		end
	end
	
	for _, v in pairs(listenerList) do
		self:UpdateCondition(ConditionType.HasBuff, self.listeners[v], instanceId == v, buffId, isAdd)
	end
end