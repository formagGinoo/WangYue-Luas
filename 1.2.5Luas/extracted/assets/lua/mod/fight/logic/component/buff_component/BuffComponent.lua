---@class BuffComponent : PoolBaseClass
BuffComponent = BaseClass("BuffComponent",PoolBaseClass)

local _tinsert = table.insert
local _tsort = table.sort

--每个buff独立存在
--buffId = 配置ID，instanceId = 实例Id
function BuffComponent:__init()
	self.buffInstances = {}--所有buff的实例Id,数组
	self.buffs = {}--所有的buff key = instanceId,value = buff

	self.buffByBuffId = {}--根据ID存放的数据结构，方便使用(同一个Id的buff会有多个)
	self.visibleBuffByPriority = {}--根据优先级存放的可视buff数据结构
	self.buffByGroup = {}--根据组存放的数据结构，方便使用(一个buff会有多个分组)
	self.buffByKind = {}--根据类别存放的数据结构，方便使用(一个buff只能有一个类别)
	self.addBuffTempQueue = {}	-- 根据ID存放 在addbuff的时候先占个坑 避免层数没有加上导致的死循环 在doAddBuff的时候去掉

	self.buffOnShow = {}

	self.addQueue = {}
	self.removeQueue = {}

	self.buffStates = {}

	self.buffTimeOffset = {}


	self.visibleBuff = {}
	self.visibleDebuff = {}
	self.countBuffRecord = {}

	self.removeBuffRecord = {} -- 移除buff记录
end

function BuffComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.buffInstance = 0
	
	
	self.maxBuffCount = 100 -- Buff上限数量
	self.maxPriority = 0 --当前显示最大优先级
	self.visibleCount = 0 --当前可视buff数量
end

function BuffComponent:Update()
	for i, instanceId in ipairs(self.buffInstances) do
		local buff = self.buffs[instanceId]
		if buff then
			buff:Update()
		else
			table.insert(self.removeQueue,i)
		end
	end

	if next(self.addQueue) then
		for i = 1, #self.addQueue do
			local buff = self.buffs[self.addQueue[i]]
			if buff then
				buff:Update()
				table.insert(self.buffInstances,buff.instanceId)
			end
		end

		for i = #self.addQueue, 1, -1 do
			table.remove(self.addQueue)
		end
	end

	if next(self.removeQueue) then
		for i = #self.removeQueue,1, -1 do
			table.remove(self.buffInstances,self.removeQueue[i])
		end

		for i = #self.removeQueue, 1, -1 do
			table.remove(self.removeQueue)
		end
	end
end

function BuffComponent:AddBuff(relEntity, buffId, level, instanceId, kind, part)
	if instanceId and self.buffs[instanceId] then
		return self.buffs[instanceId]
	end
	local buffConfig = MagicConfig.GetBuff(buffId, relEntity.entityId, kind)
	if not buffConfig or not next(buffConfig) then
		local kindstr = ""
		if kind then
			kindstr = kind
		end

		LogError("buffConfig not found. buffId = "..buffId.." entityID = "..relEntity.entityId.." kind = "..kindstr)
		return
	end

	local count = 0
	local configLimit = buffConfig.MaxLimit
	local checkKind = buffConfig.CheckKind

	if self.buffByBuffId[buffId] then
		for i, v in pairs(self.buffByBuffId[buffId]) do
			configLimit = v.config.MaxLimit
			count = count + 1
		end
	end

	if self.addBuffTempQueue[buffId] then
		count = count + self.addBuffTempQueue[buffId]
	end

	if self.buffByBuffId[buffId] and buffConfig.IsResetDurationFrame then
		for k, v in pairs(self.buffByBuffId[buffId]) do
			v.durationFrame = v.config.DurationFrame
		end
	end

	if configLimit and configLimit > 0 and count >= configLimit then
		-- LogError("buff 层数超过限制 检查逻辑 id = "..buffId)
		return
	end

	if checkKind then
		for k, v in pairs(buffConfig.Kinds) do
			if self.buffByKind[v] and next(self.buffByKind[v]) then
				LogError("buff 存在同种类buff 不允许添加 检查逻辑 id = "..buffId)
				return
			end
		end
	end

	if count > self.maxBuffCount then
		LogError("Buff 数量超过100个，请检查逻辑！"..buffId)
		return
	end

	if not self.addBuffTempQueue[buffId] then
		self.addBuffTempQueue[buffId] = 1
	else
		self.addBuffTempQueue[buffId] = self.addBuffTempQueue[buffId] + 1
	end

	self.buffInstance = self.buffInstance + 1
	local buff = self.fight.objectPool:Get(Buff)
	buff:Init(self.entity,relEntity,self,buffId,self.buffInstance,level,kind, part)
	self:DoAddBuff(buff)

    if buffConfig.effectFontType and buffConfig.effectFontType > 0 then
        Fight.Instance.clientFight.fontAnimManager:PlayEffectAnimation(self.entity, buffConfig.effectFontType)
    end

	return buff
end

function BuffComponent:GetBuff(instanceId)
	return self.buffs[instanceId]
end

function BuffComponent:GetBuffTime(instanceId)
	local buff = self.buffs[instanceId]
	if buff then
		return buff.durationFrame * FightUtil.deltaTimeSecond
	end
	return 0
end

function BuffComponent:HasBuffId(buffId)
	if self.buffByBuffId[buffId] then
		return next(self.buffByBuffId[buffId]) ~= nil
	end
	return false
end

function BuffComponent:HasBuffKind(kind)
	if self.buffByKind[kind] then
		return next(self.buffByKind[kind]) ~= nil
	end
	return false
end

function BuffComponent:CheckBuffKind(buffInstanceId,kind)
	local buff = self.buffs[buffInstanceId]
	if buff then
		return buff:CheckBuffKind(kind)
	end
	return false
end

function BuffComponent:GetBuffCount(buffId)
	if not self.buffByBuffId or not self.buffByBuffId[buffId] then
		return 0
	end

	local count = 0
	if self.buffByBuffId[buffId] then
		for i, v in pairs(self.buffByBuffId[buffId]) do
			count = count + 1
		end
	end

	return count
end

function BuffComponent:GetBuffByBuffId(buffId)
	if self.buffByBuffId[buffId] then
		return self.buffByBuffId[buffId]
	end
end

function BuffComponent:RemoveBuffByInstacneId(buffInstanceId)
	local buff = self.buffs[buffInstanceId]
	if buff then
		self:DoRemoveBuff(buff)
	end
end

function BuffComponent:RemoveBuffByBuffId(buffId)
	local buffs = self.buffByBuffId[buffId]
	if buffs then
		for k,buff in pairs(buffs) do
			self:DoRemoveBuff(buff)
		end
	end
end

function BuffComponent:RemoveBuffByKind(kind)
	local buffs = self.buffByKind[kind]
	if buffs then
		for k,buff in pairs(buffs) do
			self:DoRemoveBuff(buff)
		end
	end
end

function BuffComponent:RemoveBuffByGroup(groupId)
	local buffs = self.buffByGroup[groupId]
	if buffs then
		for k,buff in pairs(buffs) do
			self:DoRemoveBuff(buff)
		end
	end
end

function BuffComponent:RemoveAllBuff()
	for k, v in pairs(self.buffs) do
		self:DoRemoveBuff(v)
	end
end

function BuffComponent:ResetBuff(buffId)
	if not self.buffByBuffId[buffId] then
		return
	end

	for k, v in pairs(self.buffByBuffId[buffId]) do
		v.durationFrame = v.config.DurationFrame
	end
end

function BuffComponent:ResetBuffByKind(kind)
	if not self.buffByKind[kind] then
		return
	end

	for k, v in pairs(self.buffByKind[kind]) do
		v.durationFrame = v.config.DurationFrame
	end
end

function BuffComponent:ResetBuffByGroup(groupId)
	if not self.buffByGroup[groupId] then
		return
	end

	for k, v in pairs(self.buffByGroup[groupId]) do
		v.durationFrame = v.config.DurationFrame
	end
end

function BuffComponent:SetBuffTimeByKind(kind,frame)
	if not self.buffByKind[kind] then
		return
	end

	for k, v in pairs(self.buffByKind[kind]) do
		v.durationFrame = frame
	end
end

function BuffComponent:SetBuffTimeByGroup(groupId,frame)
	if not self.buffByGroup[groupId] then
		return
	end

	for k, v in pairs(self.buffByGroup[groupId]) do
		v.durationFrame = frame
	end
end

function BuffComponent:DoAddBuff(buff)
	self.buffs[buff.instanceId] = buff
	
	--添加buffID的记录
	if not self.buffByBuffId[buff.buffId] then
		self.buffByBuffId[buff.buffId] = {}
		--self.buffByBuffId[buff.buffId].count = 0
	end
	self.addBuffTempQueue[buff.buffId] = self.addBuffTempQueue[buff.buffId] - 1
	self.buffByBuffId[buff.buffId][buff.instanceId] = buff

	--记录需要显示图标的buff
	if buff.config.buffIconPath and buff.config.buffIconPath ~= "" then
		if not self.visibleBuffByPriority[buff.config.showPriority]  then
			if buff.config.showPriority > self.maxPriority then
				self.maxPriority = buff.config.showPriority
			end
			self.visibleBuffByPriority[buff.config.showPriority] = {}
		end
		table.insert(self.visibleBuffByPriority[buff.config.showPriority], buff)
		self.visibleCount = self.visibleCount + 1
	end

	--self.buffByBuffId[buff.buffId].count = self.buffByBuffId[buff.buffId].count + 1
	
	--添加组的记录
	for i = 1, #buff.config.Groups do
		local group = buff.config.Groups[i]
		if not self.buffByGroup[group] then
			self.buffByGroup[group] = {}
			--self.buffByGroup[group].count = 0
		end
		self.buffByGroup[group][buff.instanceId] = buff
		--self.buffByGroup[group].count = self.buffByGroup[group].count + 1
	end
	
	--添加类别的记录
	if buff.config.Kinds then
		for i = 1, #buff.config.Kinds do
			if not self.buffByKind[buff.config.Kinds[i]] then
				self.buffByKind[buff.config.Kinds[i]] = {}
			end
			
			self.buffByKind[buff.config.Kinds[i]][buff.instanceId] = buff
		end
	end
	self.fight.entityManager:CallBehaviorFun("AddBuff", self.entity.instanceId, buff.instanceId,buff.buffId)
	EventMgr.Instance:Fire(EventName.OnEntityBuffChange, self.entity.instanceId, buff.instanceId ,buff.buffId, true)
	table.insert(self.addQueue,buff.instanceId)
end

function BuffComponent:DoRemoveBuff(buff)
	local buffId = buff.buffId

	self.fight.entityManager:CallBehaviorFun("RemoveBuff", self.entity.instanceId, buff.instanceId,buffId)
	EventMgr.Instance:Fire(EventName.OnEntityBuffChange, self.entity.instanceId, buff.instanceId ,buffId, false)
	
	self.buffs[buff.instanceId] = nil
	
	--移除ID记录
	self.buffByBuffId[buffId][buff.instanceId] = nil

	self.removeBuffRecord[buffId] = self.removeBuffRecord[buffId] or 0
	self.removeBuffRecord[buffId] = self.removeBuffRecord[buffId] + 1
	--self.buffByBuffId[buff.buffId].count = self.buffByBuffId[buff.buffId].count - 1

	--移除可视buff
	if buff.config.buffIconPath and buff.config.buffIconPath ~= "" then
		for i = 1, #self.visibleBuffByPriority[buff.config.showPriority] do
			if self.visibleBuffByPriority[buff.config.showPriority][i].instanceId == buff.instanceId then
				table.remove(self.visibleBuffByPriority[buff.config.showPriority], i)
				self.visibleCount = self.visibleCount - 1
				break
			end
		end
	end
	--移除组记录
	for i = 1, #buff.config.Groups do
		local group = buff.config.Groups[i]
		self.buffByGroup[group][buff.instanceId] = nil
		--self.buffByGroup[group].count = self.buffByGroup[group].count - 1
	end
	
	--移除类别记录
	if buff.config.Kinds then
		for i = 1, #buff.config.Kinds do
			self.buffByKind[buff.config.Kinds[i]][buff.instanceId] = nil
		end
	end
	-- 判断是否要移除衍生buff
	self:CheckRemoveDeriveBuff(buff)

	-- 清除移除的记录
	local curBuffNum = self:GetBuffCount(buffId)
	if curBuffNum <= 0 then
		self.removeBuffRecord[buffId] = nil
	end

	buff:OnCache()
end

function BuffComponent:CheckRemoveDeriveBuff(buff)
	local buffCfg = buff.config
	local buffId = buff.buffId
	local curRemoveNum = self.removeBuffRecord[buffId]
	local deriveList = buffCfg.DeriveList
	if not deriveList or #deriveList <= 0 then return end
	local targetRemoveNum = buffCfg.TriggerRemoveNum
	if curRemoveNum < targetRemoveNum then return end
	for _, data in pairs(deriveList) do
		local removeId = data.buffId
		local removeNum = data.removeNum
		self:DoRemoveDeriveBuff(removeId, removeNum)
	end
end

function BuffComponent:DoRemoveDeriveBuff(buffId, removeNum)
	local buffList = self:GetBuffByBuffId(buffId)
	if not buffList then return end
	local sortTab = {}
	for _, buff in pairs(buffList) do
		local instanceId = buff.instanceId
		local resdiueFrame = buff:GetDurationFrame()
		_tinsert(sortTab, {instanceId = instanceId, resdiueFrame = resdiueFrame})
	end

	-- 这里的移除规则是根据时间排序移除
	if removeNum ~= 0 then
		_tsort(sortTab, function (a, b)
			if a.resdiueFrame == b.resdiueFrame then
				return a.instanceId < b.instanceId
			end
			return a.resdiueFrame < b.resdiueFrame
		end)

		for i = 1, removeNum do
			local data = sortTab[i]
			if data then
				self:RemoveBuffByInstacneId(data.instanceId)
			end
		end

	else
		-- 全部移除
		for _, data in pairs(sortTab) do
			self:RemoveBuffByInstacneId(data.instanceId)
		end
	end
end

function BuffComponent:AddState(state)
	if self.buffStates[state] then
		self.buffStates[state] = self.buffStates[state] + 1
	else
		self.buffStates[state] = 1
	end

	if self:CheckState(FightEnum.EntityBuffState.Stun) and not self:CheckState(FightEnum.EntityBuffState.ImmuneStun) then
		if self.entity.stateComponent then
			if self.entity.stateComponent:CanStun() then
				self.entity.stateComponent:SetState(FightEnum.EntityState.Stun)
			end
		end
	end
	
	if self:CheckState(FightEnum.EntityBuffState.PauseTime) then
		if ctx then
			self.entity.clientEntity.clientAnimatorComponent:SetTimeScale(0)
		end
	end
	if state == FightEnum.EntityBuffState.IgnoreCommonEnemyTimeScale then
		self.entity.timeComponent:UpdateEnemyCommonTimeScale()
	end
end

function BuffComponent:RemoveState(state)
	self.buffStates[state] = self.buffStates[state] - 1
	if state == FightEnum.EntityBuffState.Stun and not self:CheckState(state) then
		if self.entity.stateComponent and self.entity.stateComponent:GetState() == FightEnum.EntityState.Stun then
			self.entity.stateComponent:SetState(FightEnum.EntityState.Idle)
		end
	end
	
	if state == FightEnum.EntityBuffState.PauseTime and not self:CheckState(state) then
		if ctx then
			local timeScale = 1
			if self.entity.timeComponent then
				timeScale = self.entity.timeComponent:GetTimeScale()
			end
			 
			if self.entity.clientEntity.clientAnimatorComponent then
				self.entity.clientEntity.clientAnimatorComponent:SetTimeScale(timeScale)
			end
		end
	end
	if state == FightEnum.EntityBuffState.IgnoreCommonEnemyTimeScale then
		self.entity.timeComponent:UpdateEnemyCommonTimeScale()
	end
end

function BuffComponent:CheckStates(...)
	local args = {...}
	for i = 1, #args do
		if not self:CheckState(args[i]) then
			return false
		end
	end
	return true
end

function BuffComponent:CheckState(state)
	if self.buffStates[state] then
		return self.buffStates[state] > 0
	else
		return false
	end
end

function BuffComponent:GetVisibleBuff(count)
	if not self.visibleCount or not count then
		return
	end

	self.visibleBuff = {}
	self.visibleDebuff = {}
	self.countBuffRecord = {}
	for i = self.maxPriority, 0, -1 do
		if not self.visibleBuffByPriority[i] then
			goto continue
		end

		for j = #self.visibleBuffByPriority[i], 1, -1 do
			local buff = self.visibleBuffByPriority[i][j]
			if (buff.config.isDebuff and #self.visibleDebuff < count) or (not buff.config.isDebuff and #self.visibleBuff < count) then
				if not buff.config.isShowNum then
					table.insert(buff.config.isDebuff and self.visibleDebuff or self.visibleBuff, self.visibleBuffByPriority[i][j])
				elseif not self.countBuffRecord[buff.buffId] then
					self.countBuffRecord[buff.buffId] = true

					local reseverFrame = 0
					local instanceId = 0
					for k, v in pairs(self.buffByBuffId[buff.buffId]) do
						if v.durationFrame >= reseverFrame then
							instanceId = v.instanceId
							reseverFrame = v.durationFrame
						end
					end

					table.insert(buff.config.isDebuff and self.visibleDebuff or self.visibleBuff, self.buffByBuffId[buff.buffId][instanceId])
				end
			end
		end

		::continue::
	end

	return self.visibleBuff, self.visibleDebuff
end

function BuffComponent:UpdateBuffTimeOffset(remove, buffKind, factor)
	if remove then
		self.buffTimeOffset[buffKind] = nil
	else
		self.buffTimeOffset[buffKind] = {factor = factor, count = 1}
	end
end

-- 给buff添加/减少累计值
function BuffComponent:AddBuffAccumulateAttr(instanceId, value)
	local buff = self:GetBuff(instanceId)
	if buff.buffType ~= FightEnum.BuffType.Accumulate then
		return
	end

	buff:AddAccumulateAttr(value)
end

function BuffComponent:OnCache()
	self:RemoveAllBuff()

	TableUtils.ClearTable(self.buffInstances)
	TableUtils.ClearTable(self.buffs)

	TableUtils.ClearTable(self.buffByBuffId)
	TableUtils.ClearTable(self.visibleBuffByPriority)
	TableUtils.ClearTable(self.buffByGroup)
	TableUtils.ClearTable(self.buffByKind)

	TableUtils.ClearTable(self.addQueue)
	TableUtils.ClearTable(self.removeQueue)

	TableUtils.ClearTable(self.buffStates)

	TableUtils.ClearTable(self.visibleBuff)
	TableUtils.ClearTable(self.visibleDebuff)
	TableUtils.ClearTable(self.countBuffRecord)

	self.fight.objectPool:Cache(BuffComponent,self)
end

function BuffComponent:__cache()
end

function BuffComponent:__delete()
end