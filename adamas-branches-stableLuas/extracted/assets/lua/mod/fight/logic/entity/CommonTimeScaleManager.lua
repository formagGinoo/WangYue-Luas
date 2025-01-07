---@class CommonTimeScaleManager
CommonTimeScaleManager = BaseClass("CommonTimeScaleManager")

local _tinsert = table.insert
local _tremove = table.remove
local _unityUtils = UnityUtils
local _eventMgr = EventMgr
local _fightEnum = FightEnum
local _eventName = EventName

--全局时间缩放管理器（优先级低于时间组件中的缩放）
function CommonTimeScaleManager:__init(fight,entityManager)
	self.fight = fight
	self.entityManager = entityManager
	--#region 敌方的全局速度
	self.timeScaleCurveInstance = 1
	self.enemyCommonTimeCurves = {}
	self.enemyCommonTimeScaleWithTime = {}
	self.enemyCommonTimeScales = {} --敌方使用的全局速度，常用于超算，解决超算时间内出生的敌方没有被减速
	self.enemyCommonTimeScale = 1
	self.enemyCommonTimeScaleBuff = 1
	self.enemyCommonTimeScaleCurve = 1
	self.enemyCommonTimeScaleChange = false
	self.skillTimeScaleMap = {}
	self.skillTimeScaleCurveMap = {}

	--#region 角色的全局速度
	self.timeScaleCurveInstance = 1
	self.roleCommonTimeCurves = {}
	self.roleCommonTimeScaleWithTime = {}
	self.roleCommonTimeScales = {}
	self.roleCommonTimeScale = 1
	self.roleCommonTimeScaleBuff = 1
	self.roleCommonTimeScaleCurve = 1
	self.roleCommonTimeScaleChange = false
	self.skillRoleTimeScaleMap = {}
	self.skillRoleTimeScaleCurveMap = {}
end


function CommonTimeScaleManager:Update()

	--在这里计算移除屏蔽顿帧,且屏蔽递归计算
	self:CheckRemovePauseFrameData(true)

	--怪物全局速度更新
	-- 先计算曲线再计算定时缩放，否则会然修改延迟一帧
	self:UpdateEnemyCommonTimeScaleCurve()
	
	if self.enemyCommonTimeScaleWithTime then
		for k, v in pairs(self.enemyCommonTimeScaleWithTime) do
			self.enemyCommonTimeScaleWithTime[k].frame = self.enemyCommonTimeScaleWithTime[k].frame - 1
			if self.enemyCommonTimeScaleWithTime[k].frame <= 0 then
				self:RemoveEnemyCommonTimeScale(v.timeScale)
				self.enemyCommonTimeScaleWithTime[k] = nil
			end
		end
	end



	--角色全局速度更新
	self:UpdateRoleCommonTimeScaleCurve()

	if self.roleCommonTimeScaleWithTime then
		for k, v in pairs(self.roleCommonTimeScaleWithTime) do
			self.roleCommonTimeScaleWithTime[k].frame = self.roleCommonTimeScaleWithTime[k].frame - 1
			if self.roleCommonTimeScaleWithTime[k].frame <= 0 then
				self:RemoveRoleCommonTimeScale(v.timeScale)
				self.roleCommonTimeScaleWithTime[k] = nil
			end
		end
	end
	
end

--- 该方法在entityManger里紧随self:update调用
function CommonTimeScaleManager:UpdateCommonTimeScale(entity)
	if self.enemyCommonTimeScaleChange and entity.timeComponent then
		entity.timeComponent:UpdateEnemyCommonTimeScale()
	end
	if self.roleCommonTimeScaleChange and entity.timeComponent then
		entity.timeComponent:UpdateRoleCommonTimeScale()
	end
end

--- 现在不会影响顿帧数据添加，但是影响应用
---@param skillId any
function CommonTimeScaleManager:CheckAddTimeScale(skillId)
	--[[
	if self.shieldPauseFrameData then
		local shieldType = self.shieldPauseFrameData.shieldPauseFrameType
		if shieldType == _fightEnum.ShieldPauseFrameType.NoSelfPauseFrame and self.shieldPauseFrameData.triggerSkillId ~= skillId then
			return
		elseif shieldType == _fightEnum.ShieldPauseFrameType.AllPauseFrame then
			return
		end
	end]]
	return true
end

function CommonTimeScaleManager:AddEnemyCommonTimeScale(timeScale, frame, isCanBreak, entity)
	local skillComponent = entity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end
	
	if not self:CheckAddTimeScale(curSkillId) then
		return
	end

	if frame then
		_tinsert(self.enemyCommonTimeScaleWithTime, { timeScale = timeScale, frame = frame, isCanBreak = isCanBreak })
	end

	if not self.enemyCommonTimeScales[timeScale] then
		self.enemyCommonTimeScales[timeScale] = 0
	end
	self.enemyCommonTimeScales[timeScale] = self.enemyCommonTimeScales[timeScale] + 1


	self.skillTimeScaleMap[curSkillId] = self.skillTimeScaleMap[curSkillId] or {}
	if not self.skillTimeScaleMap[curSkillId][timeScale] then
		self.skillTimeScaleMap[curSkillId][timeScale] = self.skillTimeScaleMap[curSkillId][timeScale] or 1
	else
		self.skillTimeScaleMap[curSkillId][timeScale] = self.skillTimeScaleMap[curSkillId][timeScale] + 1
	end

	self:UpdateEnemyCommonTimeScale()
end

function CommonTimeScaleManager:RemoveEnemyCommonTimeScale(timeScale)
	if self.enemyCommonTimeScales[timeScale] then
		self.enemyCommonTimeScales[timeScale] = self.enemyCommonTimeScales[timeScale] - 1
	end

	for _, timeScaleMap in pairs(self.skillTimeScaleMap) do
		if timeScaleMap[timeScale] then
			timeScaleMap[timeScale] = timeScaleMap[timeScale] - 1
		end
	end

	self:UpdateEnemyCommonTimeScale()
end

--- 应用timescales变化
function CommonTimeScaleManager:UpdateEnemyCommonTimeScale()
	local timeScale = 1

	for i, v in pairs(self.enemyCommonTimeScales) do
		if i < timeScale and v > 0 then
			timeScale = i
		end
	end
	self.enemyCommonTimeScaleBuff = timeScale
	self.enemyCommonTimeScale = self.enemyCommonTimeScaleBuff < self.enemyCommonTimeScaleCurve and self.enemyCommonTimeScaleBuff or self.enemyCommonTimeScaleCurve
	for i = 1, #self.entityManager.entityInstances do
		local entity = self.entityManager.entites[self.entityManager.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateEnemyCommonTimeScale()
		end
	end
end

function CommonTimeScaleManager:AddEnemyCommonTimeScaleCurve(entity, curveId, isCanBreak, triggerEntity)
	local skillComponent = triggerEntity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end


	if not self:CheckAddTimeScale(curSkillId) then
		return
	end
	

	local curve = CurveConfig.GetCurve(entity.entityId, curveId)
	if not curve then
		LogError("找不到曲线,id = "..curveId)
		return
	end

	self.timeScaleCurveInstance = self.timeScaleCurveInstance + 1
	local curveInfo = { curve = curve, startFrame = self.fight.fightFrame - 1, isCanBreak = isCanBreak }
	self.enemyCommonTimeCurves[self.timeScaleCurveInstance] = curveInfo

	self.skillTimeScaleCurveMap[curSkillId] = self.skillTimeScaleCurveMap[curSkillId] or {}
	table.insert(self.skillTimeScaleCurveMap[curSkillId], self.timeScaleCurveInstance)

	self:UpdateEnemyCommonTimeScaleCurve()
	for i = 1, #self.entityManager.entityInstances do
		local entity = self.entityManager.entites[self.entityManager.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateEnemyCommonTimeScale()
		end
	end

	return self.timeScaleCurveInstance
end

function CommonTimeScaleManager:RemoveEnemyCommonTimeScaleCurve(instanceId)
	if not instanceId then
		return
	end

	self.enemyCommonTimeCurves[instanceId] = nil
	for _, map in pairs(self.skillTimeScaleCurveMap) do
		for key, insId in ipairs(map) do
			if insId == instanceId then
				table.remove(map, key)
				break
			end
		end
	end

	self:UpdateEnemyCommonTimeScaleCurve()
	for i = 1, #self.entityManager.entityInstances do
		local entity = self.entityManager.entites[self.entityManager.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateEnemyCommonTimeScale()
		end
	end
end

function CommonTimeScaleManager:UpdateEnemyCommonTimeScaleCurve()
	local timeScale = 1
	local before = self.enemyCommonTimeScale
	
	for k, v in pairs(self.enemyCommonTimeCurves) do
		local index = self.fight.fightFrame - v.startFrame
		local ts = v.curve[index]
		if ts and ts < timeScale then
			timeScale = ts
		end
	end

	self.enemyCommonTimeScaleCurve = timeScale
	self.enemyCommonTimeScale = self.enemyCommonTimeScaleBuff < self.enemyCommonTimeScaleCurve and self.enemyCommonTimeScaleBuff or self.enemyCommonTimeScaleCurve

	self.enemyCommonTimeScaleChange = before ~= self.enemyCommonTimeScale
end

function CommonTimeScaleManager:AddRoleCommonTimeScale(timeScale, frame, isCanBreak, entity)
	local skillComponent = entity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end

	
	
	if not self:CheckAddTimeScale(curSkillId) then
		return
	end

	if frame then
		_tinsert(self.roleCommonTimeScaleWithTime, { timeScale = timeScale, frame = frame, isCanBreak = isCanBreak })
	end

	if not self.roleCommonTimeScales[timeScale] then
		self.roleCommonTimeScales[timeScale] = 0
	end
	self.roleCommonTimeScales[timeScale] = self.roleCommonTimeScales[timeScale] + 1


	self.skillRoleTimeScaleMap[curSkillId] = self.skillRoleTimeScaleMap[curSkillId] or {}
	if not self.skillRoleTimeScaleMap[curSkillId][timeScale] then
		self.skillRoleTimeScaleMap[curSkillId][timeScale] = self.skillRoleTimeScaleMap[curSkillId][timeScale] or 1
	else
		self.skillRoleTimeScaleMap[curSkillId][timeScale] = self.skillRoleTimeScaleMap[curSkillId][timeScale] + 1
	end

	self:UpdateRoleCommonTimeScale()
end

function CommonTimeScaleManager:RemoveRoleCommonTimeScale(timeScale)
	if self.roleCommonTimeScales[timeScale] then
		self.roleCommonTimeScales[timeScale] = self.roleCommonTimeScales[timeScale] - 1
	end

	for _, timeScaleMap in pairs(self.skillRoleTimeScaleMap) do
		if timeScaleMap[timeScale] then
			timeScaleMap[timeScale] = timeScaleMap[timeScale] - 1
		end
	end

	self:UpdateRoleCommonTimeScale()
end

function CommonTimeScaleManager:UpdateRoleCommonTimeScale()
	local timeScale = 1

--根据策划需求
	--ShieldPauseFrameType.NoSelfPauseFrame 仅让skillID影响时间缩放
	--ShieldPauseFrameType.AllPauseFrame 所有时间缩放不生效
	if self.shieldPauseFrameData then
		if self.shieldPauseFrameData.ShieldPauseFrameType == _fightEnum.ShieldPauseFrameType.NoSelfPauseFrame then
			local targetSkillId = self.shieldPauseFrameData.triggerSkillId
			local skillScales = self.skillRoleTimeScaleMap[targetSkillId] 
			if skillScales then
				for k, v in pairs(skillScales) do
					if k < timeScale and v > 0 then
						timeScale = k
					end
				end
			end
		end
	else
		for i, v in pairs(self.roleCommonTimeScales) do
			if i < timeScale and v > 0 then
				timeScale = i
			end
		end
	end

	self.roleCommonTimeScaleBuff = timeScale
	self.roleCommonTimeScale = self.roleCommonTimeScaleBuff < self.roleCommonTimeScaleCurve and self.roleCommonTimeScaleBuff or self.roleCommonTimeScaleCurve
	for i = 1, #self.entityManager.entityInstances do
		local entity = self.entityManager.entites[self.entityManager.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateRoleCommonTimeScale()
		end
	end
end

function CommonTimeScaleManager:AddRoleCommonTimeScaleCurve(entity, curveId, isCanBreak, triggerEntity)
	local skillComponent = triggerEntity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end

	if not self:CheckAddTimeScale(curSkillId) then
		return
	end

	local curve = CurveConfig.GetCurve(entity.entityId, curveId)
	if not curve then
		LogError("找不到曲线,id = "..curveId)
		return
	end

	self.timeScaleCurveInstance = self.timeScaleCurveInstance + 1
	local curveInfo = { curve = curve, startFrame = self.fight.fightFrame - 1, isCanBreak = isCanBreak }
	self.roleCommonTimeCurves[self.timeScaleCurveInstance] = curveInfo

	self.skillRoleTimeScaleCurveMap[curSkillId] = self.skillRoleTimeScaleCurveMap[curSkillId] or {}
	table.insert(self.skillRoleTimeScaleCurveMap[curSkillId], self.timeScaleCurveInstance)

	self:UpdateRoleCommonTimeScaleCurve()
	for i = 1, #self.entityManager.entityInstances do
		local entity = self.entityManager.entites[self.entityManager.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateRoleCommonTimeScale()
		end
	end

	return self.timeScaleCurveInstance
end

function CommonTimeScaleManager:RemoveRoleCommonTimeScaleCurve(instanceId)
	if not instanceId then
		return
	end

	self.roleCommonTimeCurves[instanceId] = nil
	for _, map in pairs(self.skillRoleTimeScaleCurveMap) do
		for key, insId in ipairs(map) do
			if insId == instanceId then
				table.remove(map, key)
				break
			end
		end
	end

	self:UpdateRoleCommonTimeScaleCurve()
	for i = 1, #self.entityManager.entityInstances do
		local entity = self.entityManager.entites[self.entityManager.entityInstances[i]]
		if entity and entity.timeComponent then
			entity.timeComponent:UpdateRoleCommonTimeScale()
		end
	end
end

function CommonTimeScaleManager:UpdateRoleCommonTimeScaleCurve()
	local timeScale = 1
	local before = self.roleCommonTimeScale
	
	--根据策划需求
	--ShieldPauseFrameType.NoSelfPauseFrame 仅让skillID影响时间缩放
	--ShieldPauseFrameType.AllPauseFrame 所有时间缩放不生效
	if self.shieldPauseFrameData then
		if self.shieldPauseFrameData.ShieldPauseFrameType == _fightEnum.ShieldPauseFrameType.NoSelfPauseFrame then
			local targetSkillId = self.shieldPauseFrameData.triggerSkillId
			local skillInstanceMap = self.skillRoleTimeScaleCurveMap[targetSkillId] 
			if skillInstanceMap then
				for k, v in pairs(skillInstanceMap) do
					local curveInfo  = self.roleCommonTimeCurves[v]
					local index = self.fight.fightFrame - curveInfo.startFrame
					local ts = curveInfo.curve[index]
					if ts and ts < timeScale then
						timeScale = ts
					end
				end
			end
		end
	else
		for k, v in pairs(self.roleCommonTimeCurves) do
			local index = self.fight.fightFrame - v.startFrame
			local ts = v.curve[index]
			if ts and ts < timeScale then
				timeScale = ts
			end
		end
	end

	self.roleCommonTimeScaleCurve = timeScale
	self.roleCommonTimeScale = self.roleCommonTimeScaleBuff < self.roleCommonTimeScaleCurve and self.roleCommonTimeScaleBuff or self.roleCommonTimeScaleCurve

	self.roleCommonTimeScaleChange = before ~= self.roleCommonTimeScale
end

--- 添加屏蔽顿帧数据，这个对全局角色时间缩放生效，全局怪物时间缩放不生效
function CommonTimeScaleManager:AddShieldPauseFrame(data, entity)
	local skillComponent = entity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end

	local curFrame = self.fight.fightFrame
	local endFrame = curFrame + data.durationFrame

	-- 同一时间存在一个屏蔽数据，后来的直接覆盖这个
	self.shieldPauseFrameData = data
	self.shieldPauseFrameData.triggerSkillId = curSkillId
	self.shieldPauseFrameData.endFrame = endFrame
	local shieldType = data.shieldPauseFrameType

	
	self:UpdateRoleCommonTimeScaleCurve()
	self:UpdateRoleCommonTimeScale()
	--[[
	if shieldType == _fightEnum.ShieldPauseFrameType.NoSelfPauseFrame then
		self:RemoveTimeScaleBySkillId(curSkillId)
	elseif shieldType == _fightEnum.ShieldPauseFrameType.AllPauseFrame then
		self:RemoveAllTimeScale()
	end
	]]
end


--[[
function CommonTimeScaleManager:RemoveTimeScaleBySkillId(skillId)
	for id, timeScaleMap in pairs(self.skillTimeScaleMap) do
		if id ~= skillId or id == 0 then
			for scale, _ in pairs(timeScaleMap) do
				self.enemyCommonTimeScales[scale] = 0
			end
			timeScaleMap = {}
		end
	end
	self:UpdateEnemyCommonTimeScale()

	for id, curveMap in pairs(self.skillTimeScaleCurveMap) do
		if id ~= skillId or id == 0 then
			for _, insId in pairs(curveMap) do
				self.enemyCommonTimeCurves[insId] = nil
			end
			curveMap = {}
		end
	end
	self:UpdateEnemyCommonTimeScaleCurve()
end

function CommonTimeScaleManager:RemoveAllTimeScale()
	self.skillTimeScaleMap = {}
	self.skillTimeScaleCurveMap = {}
	self.enemyCommonTimeScales = {}
	self.enemyCommonTimeCurves = {}

	self:UpdateEnemyCommonTimeScale()
	self:UpdateEnemyCommonTimeScaleCurve()
end
]]
function CommonTimeScaleManager:RemoveShieldData(shieldUpdate)
	self.shieldPauseFrameData = nil
	
	--移除屏蔽顿帧需要重新刷新缩放
	if not shieldUpdate then
		self:UpdateRoleCommonTimeScaleCurve()
		self:UpdateRoleCommonTimeScale()
	end
end

function CommonTimeScaleManager:CheckRemovePauseFrameData(shieldUpdate)
	if not self.shieldPauseFrameData then return end
	local curFrame = self.fight.fightFrame
	if self.shieldPauseFrameData.endFrame <= curFrame then
		self:RemoveShieldData(shieldUpdate)
	end
end

--可打断配置出现在attack配置，全局角色速度只有magic可添加，没有attack需求所以不支持
function CommonTimeScaleManager:RemoveCanBreakPauseFrame()
	if not self.enemyCommonTimeScaleWithTime or not next(self.enemyCommonTimeScaleWithTime) then
		return
	end
	for k, v in pairs(self.enemyCommonTimeScaleWithTime) do
		if v.isCanBreak then
			self:RemoveEnemyCommonTimeScale(v.timeScale)
			self.enemyCommonTimeScaleWithTime[k] = nil
		end
	end

	if not self.enemyCommonTimeCurves or not next(self.enemyCommonTimeCurves) then
		return
	end
	for k, v in pairs(self.enemyCommonTimeCurves) do
		if v.isCanBreak then
			self:RemoveEnemyCommonTimeScaleCurve(k)
		end
	end
end

function CommonTimeScaleManager:__delete()
end
