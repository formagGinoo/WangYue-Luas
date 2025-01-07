---@class ElementStateComponent
ElementStateComponent = BaseClass("ElementStateComponent",PoolBaseClass)

local _min = math.min
local _max = math.max
local _clamp = MathX.Clamp
local _tinsert = table.insert
local _tremove = table.remove

local ElementType = FightEnum.ElementType
local StateType = FightEnum.ElementState

function ElementStateComponent:__init()
	self.elementState = {}
end

function ElementStateComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.instanceId = entity.instanceId
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.ElementState)
	self.ignoreTimeScale = false
end

function ElementStateComponent:LateInit()
	if not self.config.ElementMaxAccumulateDict or not next(self.config.ElementMaxAccumulateDict) then
		return
	end

	local maxElementValue
	local attrId = self.entity.attrComponent and self.entity.attrComponent.config.DefaultAttrID or 0
	if self.entity.masterId then
		local monsterCfg = Config.DataMonster.Find[self.entity.masterId]
		attrId = monsterCfg and monsterCfg.attr_id or attrId	
	end

	if attrId and attrId ~= 0 then
		local monsterAttrs = EntityAttrsConfig.GetMonsterBaseAttr(attrId, self.entity.attrComponent.level or 1)
		if monsterAttrs then
			maxElementValue = monsterAttrs[EntityAttrsConfig.AttrType.WeakPoint]
		end
	end

	self.elementType = self.config.ElementType
	for k, v in pairs(self.config.ElementMaxAccumulateDict) do
		local element = ElementType[k]
		self.elementAccu = self.elementAccu or element --目前需求只有一种元素累计值
		if element and v ~= 0 then
			self.elementState[element] = {
				element = element, -- 元素
				count = 0, --累计值，在进入就绪状态时置0
				maxCount = (maxElementValue and maxElementValue ~= 0) and maxElementValue or v, --最大累计值
				readyTick = 0, --就绪状态当前值
				readyFrame = 0, --就绪状态最大值
				isCooling = false, --冷却中
				coolingTick = 0, --元素状态冷却当前值
				coolingFrame = 0, --元素状态冷却最大值
				valve = 7, --状态开关->FightEnum.ElementState
				state = StateType.Accumulation, --状态
			}
		end
	end

	self.elementResistanceVal = {} -- 元素累计抵抗值
end

function ElementStateComponent:Reset(config)
	if config.isCooling and config.coolingTick <= 0 then
		config.isCooling = false
		config.coolingTick = 0
		config.coolingFrame = 0
	else
		config.state = StateType.Accumulation
		config.count = 0
		config.valve = 7
		config.readyTick = 0
		config.readyFrame = 0
	end
	
	if not config.isCooling then
		local cur, max = config.count, config.maxCount
		if config.state == StateType.Ready then
			cur, max = config.readyTick, config.readyFrame
		end
		EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, config.element, config.state, cur, max)
	end
end

function ElementStateComponent:GetElementState(element)
	if not element or element == -1 then
		return self.elementState[self.elementAccu]
	end
	
	return self.elementState[element]
end

function ElementStateComponent:IsStateRuning(elementState, state)
	return (elementState.valve & state) ~= 0
end

function ElementStateComponent:UpdateElementResistanceVal(magicId, resistanceVal, isInsert)
	self.elementResistanceVal[magicId] = self.elementResistanceVal[magicId] or {}
	if isInsert then
		_tinsert(self.elementResistanceVal[magicId], resistanceVal)
	else
		_tremove(self.elementResistanceVal[magicId], 1)
	end
end

function ElementStateComponent:UpdateElementState(atkInstanceId, element, count)
	if not count then
		return
	end
	
	if self.entity and self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Death) then
		return 
	end

	--没有对应配置不处理
    local elementState = self:GetElementState(element)
	if not elementState or elementState.state ~= StateType.Accumulation or elementState.isCooling or
		not self:IsStateRuning(elementState, StateType.Accumulation) then
		return 
	end

	count = self:calcElementResistance(count)
	elementState.count = _clamp(elementState.count + count, 0, elementState.maxCount)
	
	--实例ID，元素类型，冷却状态，当前值，最大值
	EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, elementState.element, elementState.state, elementState.count, elementState.maxCount)

	if elementState.count >= elementState.maxCount then
		elementState.count = 0
		elementState.state = StateType.Ready
		self.fight.entityManager:CallBehaviorFun("EnterElementStateReady", atkInstanceId, self.instanceId, elementState.element)
		EventMgr.Instance:Fire(EventName.EnterElementStateReady, atkInstanceId, self.instanceId, elementState.element)
	end
end

function ElementStateComponent:calcElementResistance(addVal)
	-- for _, list in pairs(self.elementResistanceVal) do
	-- 	for _, resistanceVal in pairs(list) do
	-- 		addVal = addVal * (resistanceVal / 10000)
	-- 	end
	-- end
	return addVal
end

function ElementStateComponent:Update()
	if self.ignoreTimeScale then
		return
	end
	
	self:UpdateFrame()
end

function ElementStateComponent:UpdateIgnoreTimeScale()
	if not self.ignoreTimeScale then
		return
	end
	
	self:UpdateFrame()
end

function ElementStateComponent:UpdateFrame()
	if not self.elementState or not next(self.elementState) then
		return
	end

	for k, v in pairs(self.elementState) do
		if v.state == StateType.Ready and self:IsStateRuning(v, StateType.Ready) then
			v.readyTick = v.readyTick - 1

			if v.readyTick <= 0 then
				self:Reset(v)
			elseif not v.isCooling then
				EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, k, StateType.Ready, v.readyTick, v.readyFrame)
			end
		end

		if v.isCooling and self:IsStateRuning(v, StateType.Cooling) then
			v.coolingTick = v.coolingTick - 1

			if v.coolingTick <= 0 then
				self:Reset(v)
			else
				EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, k, StateType.Cooling, v.coolingTick, v.coolingFrame)
			end
		end
	end
end

function ElementStateComponent:EnableElementStateRuning(state, enable, element)
	local elementState = self:GetElementState(element)
	if not elementState then
		return false
	end
	
	elementState.valve = enable and elementState.valve | state or elementState.valve & (~state)
end

function ElementStateComponent:CheckElementState(state, element)
	local elementState = self:GetElementState(element)
	if not elementState then
		return false
	end
	
	if state == StateType.Cooling then
		return elementState.isCooling
	end

	return elementState.state == state
end

function ElementStateComponent:EnterCooling(coolingTime, element)
	local elementState = self:GetElementState(element)
	if not elementState then
		return
	end
	
	elementState.isCooling = true
	
	local durationFrame = coolingTime * FightUtil.targetFrameRate
	elementState.coolingTick = durationFrame
	elementState.coolingFrame = durationFrame
	EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, elementState.element, StateType.Cooling, durationFrame, durationFrame)
end

function ElementStateComponent:AddCoolingTime(coolingTime, element)
	local elementState = self:GetElementState(element)
	if not elementState or not elementState.isCooling then
		return
	end

	local addtionFrame = coolingTime * FightUtil.targetFrameRate
	elementState.coolingTick = _clamp(elementState.coolingTick + addtionFrame, 0, elementState.coolingFrame)
	EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, elementState.element, StateType.Cooling, elementState.coolingTick, elementState.coolingFrame)
end

function ElementStateComponent:SetReadyDurationTime(duration, element)
	local elementState = self:GetElementState(element)
	if not elementState or elementState.state ~= StateType.Ready then
		return
	end
	
	local durationFrame = duration * FightUtil.targetFrameRate
	elementState.readyTick = durationFrame
	elementState.readyFrame = durationFrame
	if not elementState.isCooling then
		EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, elementState.element, StateType.Ready, durationFrame, durationFrame)
	end
end

function ElementStateComponent:AddReadyDurationTime(duration, element)
	local elementState = self:GetElementState(element)
	if not elementState or elementState.state ~= StateType.Ready then
		return
	end
	
	local addtionFrame = duration * FightUtil.targetFrameRate
	elementState.readyTick = _clamp(elementState.readyTick + addtionFrame, 0, elementState.readyFrame)
	if not elementState.isCooling then
		EventMgr.Instance:Fire(EventName.UpdateElementState, self.instanceId, elementState.element, StateType.Ready, elementState.readyTick, elementState.readyFrame)
	end
end

function ElementStateComponent:GetAccumulationCount(element)
	local elementState = self:GetElementState(element)
	if not elementState then
		return 0, 0
	end

	return elementState.count, elementState.maxCount
end

function ElementStateComponent:SetIgnoreTimeScale(ignore)
	self.ignoreTimeScale = ignore
end

function ElementStateComponent:OnCache()
	TableUtils.ClearTable(self.elementState)
	self.fight.objectPool:Cache(ElementStateComponent,self)
end

function ElementStateComponent:__cache()
	self.fight = nil
	self.entity = nil
	self.config = nil
	self.elementAccu = nil
	self.elementState = {}
end

function ElementStateComponent:__delete()

end