---@class ClientBuffComponent
ClientBuffComponent = BaseClass("ClientBuffComponent",PoolBaseClass)

function ClientBuffComponent:__init()
	self.buffCounts = {}
	self.buffs = {}
end

function ClientBuffComponent:Init(clientFight,clientEntity,info)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.activity = true
	self.timeScale = 1
end

function ClientBuffComponent:AddBuff(buff)
	if buff.config.EffectInfos then
		for i = 1, #buff.config.EffectInfos do
			local buffAdded = true
			local effectPath = buff.config.EffectInfos[i].EffectPath
			local effectBindRoot = buff.config.EffectInfos[i].EffectBindBones
			local offset = buff.config.EffectInfos[i].EffectOffset
			local dontBindRotation = buff.config.EffectInfos[i].DontBindRotation
			local onlyUpdateY = buff.config.EffectInfos[i].OnlyUpdateY
			local loadToBones = buff.config.EffectInfos[i].LoadToBones

			if not self.buffCounts[effectPath] then
				self.buffs[effectPath] = {}
				self.buffCounts[effectPath] = {}
			end

			if not self.buffCounts[effectPath][effectBindRoot] then
				local clientBuff = self.clientFight.fight.objectPool:Get(ClientBuff)
				local effectInfo = {
					Effect = effectPath,
					EffectBone = effectBindRoot,
					OffsetX = offset[1],
					OffsetY = offset[2],
					OffsetZ = offset[3],
					dontBindRotation = dontBindRotation,
					onlyUpdateY = onlyUpdateY,
					loadToBones = loadToBones,
				}
				buffAdded = clientBuff:Init(self.clientFight, self.clientEntity, effectInfo, self.activity, buff.buffId, self.timeScale)
				if buffAdded then
					self.buffs[effectPath][effectBindRoot] = clientBuff
					self.buffCounts[effectPath][effectBindRoot] = 0
				end
			end

			if buffAdded then
				self.buffCounts[effectPath][effectBindRoot] = self.buffCounts[effectPath][effectBindRoot] + 1
			end
		end
	end
end

function ClientBuffComponent:RemoveBuff(buff)
	if buff.config.EffectInfos then
		for i = 1, #buff.config.EffectInfos do
			local effectPath = buff.config.EffectInfos[i].EffectPath
			local effectBindRoot = buff.config.EffectInfos[i].EffectBindBones
			if not self.buffCounts[effectPath] then
				return
			end
			self.buffCounts[effectPath][effectBindRoot] = self.buffCounts[effectPath][effectBindRoot] - 1
			if self.buffCounts[effectPath][effectBindRoot] == 0 then
				local clientBuff = self.buffs[effectPath][effectBindRoot]
				clientBuff:OnCache()

				self.buffCounts[effectPath][effectBindRoot] = nil
				self.buffs[effectPath][effectBindRoot] = nil
			end
		end
	end
end

function ClientBuffComponent:SetIgnoreTimeScale(buff, ignoreTimeScale, scale)
	if buff.config.EffectInfos then
		for i = 1, #buff.config.EffectInfos do
			local effectPath = buff.config.EffectInfos[i].EffectPath
			local effectBindRoot = buff.config.EffectInfos[i].EffectBindBones
			if self.buffs[effectPath] and self.buffs[effectPath][effectBindRoot] then
				self.buffs[effectPath][effectBindRoot]:SetIgnoreTimeScale(ignoreTimeScale, scale)
			end
		end
	end
end

function ClientBuffComponent:SetActivity(active)
	if self.activity == active then
		return
	end
	self.activity = active
	for k, v in pairs(self.buffs) do
		for m, n in pairs(v) do
			n:SetActivity(active)
		end
	end
end


function ClientBuffComponent:Update()
	for k, v in pairs(self.buffs) do
		for m, n in pairs(v) do
			n:Update()
		end
	end
end

function ClientBuffComponent:AfterUpdate()
	for k, v in pairs(self.buffs) do
		for m, n in pairs(v) do
			n:AfterUpdate()
		end
	end
end

function ClientBuffComponent:SetTimeScale(timeScale)
	self.timeScale = timeScale
	for k, v in pairs(self.buffs) do
		for m, n in pairs(v) do
			n:SetTimeScale(timeScale)
		end
	end
end

function ClientBuffComponent:SaveTimeScale()
	self.timeScaleCache = self.timeScale
end

function ClientBuffComponent:ResetTimeScale()
	if not self.timeScaleCache then
		return
	end
	self.timeScale = self.timeScaleCache

	for k, v in pairs(self.buffs) do
		for m, n in pairs(v) do
			n:SetTimeScale(self.timeScale)
		end
	end
end

function ClientBuffComponent:OnCache()
	for k, v in pairs(self.buffCounts) do
		for m, n in pairs(self.buffs[k]) do
			n:OnCache()
		end
	end

	TableUtils.ClearTable(self.buffCounts)
	TableUtils.ClearTable(self.buffs)
	self.timeScale = 1
	self.timeScaleCache = nil
	self.clientFight.fight.objectPool:Cache(ClientBuffComponent,self)
end

function ClientBuffComponent:__cache()

end

function ClientBuffComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end