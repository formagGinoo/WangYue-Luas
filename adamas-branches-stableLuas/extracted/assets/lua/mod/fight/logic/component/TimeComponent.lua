
---@class TimeComponent
TimeComponent = BaseClass("TimeComponent",PoolBaseClass)
local _insert = table.insert
local _remove = table.remove
local _fightEnum = FightEnum
local _clearTable = TableUtils.ClearTable
---时间比较偏移---
local fix = 0.01


function TimeComponent:__init()
	self.timeScale = 1
	self.parentRealTimeScale = 1
	self.time = 0
	self.frame = 0
	self.realFrame = 0--不受缩放影响的帧率
	self.currTimeScales = {}		-- 添加的时间缩放，选一个最小的
	self.currTimeScale = 1
	self.lastTimeScale = 1
	self.passSplitFrame = 0			-- 如果时间缩放小于1 那么记录一下当前帧过了多久了
	self.enemyTimeScale = 1			-- 全局的怪物时间缩放，如果有额外的时间缩放影响就不用这个
	self.roleTimeScale = 1			-- 全局的角色时间缩放，如果有额外的时间缩放影响就不用这个
	self.curves = {}
	self.curveInstance = 0
	self.curCurvesTimeScale = -1
	self.timeScaleWithDuration = {}
	self.isUseParentTimeScale = true

	self.skillTimeScaleMap = {}
	self.skillTimeScaleCurveMap = {}
end

function TimeComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Time)
	if self.config and self.config.DefalutTimeScale then
		self.timeScale = self.config.DefalutTimeScale
	end
end

function TimeComponent:UpdateCommonTimeScale()
	if self.useEnemyCommonTimeScale then
		self:UpdateEnemyCommonTimeScale()
	elseif self.useRoleCommonTimeScale then
		self:UpdateRoleCommonTimeScale()
	end
end

function TimeComponent:UpdateEnemyCommonTimeScale()
	if self.useEnemyCommonTimeScale then
		local scale = 1
		if self.fight.entityManager.commonTimeScaleManager.enemyCommonTimeScale and self.entity.buffComponent and not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.IgnoreCommonTimeScale) then
			scale = self.fight.entityManager.commonTimeScaleManager.enemyCommonTimeScale
		end
		-- self.timeScale = self.config.DefalutTimeScale * scale
		self.enemyTimeScale = self.timeScale * scale
		self:ChangeTimeScale()
	end
end

function TimeComponent:UpdateRoleCommonTimeScale()
	if self.useRoleCommonTimeScale then
		local scale = 1
		if self.fight.entityManager.commonTimeScaleManager.roleCommonTimeScale and self.entity.buffComponent and not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.IgnoreCommonTimeScale) then
			scale = self.fight.entityManager.commonTimeScaleManager.roleCommonTimeScale
		end

		-- self.timeScale = self.config.DefalutTimeScale * scale
		self.roleTimeScale = self.timeScale * scale
		self:ChangeTimeScale()
	end
end

function TimeComponent:LateInit()
	if self.entity.parent and self.entity.parent ~= self.entity
		 and self.entity.parent.timeComponent then
		self:BingParentTimeScale(self.entity.parent.timeComponent)
	end

	if self.entity.tagComponent then
		if self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Monster
			or self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Elite
			or self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Boss then
			-- self.timeScale = self.config.DefalutTimeScale * self.fight.entityManager.commonTimeScaleManager.enemyCommonTimeScale
			self.enemyTimeScale = self.timeScale *  self.fight.entityManager.commonTimeScaleManager.enemyCommonTimeScale
			self.useEnemyCommonTimeScale = true
		end
	end
	
	if self.entity.tagComponent then
		if self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player then
			self.roleTimeScale = self.timeScale *  self.fight.entityManager.commonTimeScaleManager.roleCommonTimeScale
			self.useRoleCommonTimeScale = true
		end
	end

	self:ChangeTimeScale()
end

function TimeComponent:CheckAddTimeScale(skillId)
	--[[
	if self.shieldPauseFrameData then
		local shieldType = self.shieldPauseFrameData.shieldPauseFrameType
		if shieldType == FightEnum.ShieldPauseFrameType.NoSelfPauseFrame and self.shieldPauseFrameData.triggerSkillId ~= skillId then
			return
		elseif shieldType == FightEnum.ShieldPauseFrameType.AllPauseFrame then
			return
		end
	end
]]
	return true
end

function TimeComponent:AddTimeScale(timeScale, durationFrame, isCanBreak)
	local entity = self.entity
	local skillComponent = entity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end

	if not self:CheckAddTimeScale(curSkillId) then
		return
	end

	if durationFrame then
		table.insert(self.timeScaleWithDuration, { timeScale = timeScale, durationFrame = durationFrame, isCanBreak = isCanBreak })
	end

	if self.currTimeScales[timeScale] then
		self.currTimeScales[timeScale] = self.currTimeScales[timeScale] + 1
	else
		self.currTimeScales[timeScale] = 1
	end

	self.skillTimeScaleMap[curSkillId] = self.skillTimeScaleMap[curSkillId] or {}
	if not self.skillTimeScaleMap[curSkillId][timeScale] then
		self.skillTimeScaleMap[curSkillId][timeScale] = self.skillTimeScaleMap[curSkillId][timeScale] or 1
	else
		self.skillTimeScaleMap[curSkillId][timeScale] = self.skillTimeScaleMap[curSkillId][timeScale] + 1
	end

	self:ResetCalculateTimeScale()
end

function TimeComponent:RemoveTimeScale(timeScale)
	self.currTimeScales[timeScale] = self.currTimeScales[timeScale] - 1

	for _, timeScaleMap in pairs(self.skillTimeScaleMap) do
		if timeScaleMap[timeScale] then
			timeScaleMap[timeScale] = timeScaleMap[timeScale] - 1
		end
	end

	self:ResetCalculateTimeScale()
end

function TimeComponent:AddTimeScaleCurve(entityId, curveId, isCanBreak, frame)
	local entity = self.entity
	local skillComponent = entity.skillComponent
	local curSkillId = 0
	if skillComponent then
		curSkillId = skillComponent.skillId
	end

	if not self:CheckAddTimeScale(curSkillId) then
		return
	end

	local curve = CurveConfig.GetCurve(entityId, curveId)
	if not curve then
		LogError("找不到曲线,id = "..curveId)
		return
	end
	self.curveInstance = self.curveInstance + 1

	frame = frame or 99999
	local startFrame = self.realFrame - 1
	local endFrame = startFrame + frame
	
	local curveInfo = { curve = curve,startFrame = startFrame, endFrame = endFrame, 
		isCanBreak = isCanBreak, scale = 1, Instance = self.curveInstance }
	--考虑以曲线ID为键
	self.curves[self.curveInstance] = curveInfo

	self.skillTimeScaleCurveMap[curSkillId] = self.skillTimeScaleCurveMap[curSkillId] or {}
	table.insert(self.skillTimeScaleCurveMap[curSkillId], self.curveInstance)

	self:UpdateCurveInfo()
	return self.curveInstance
end

function TimeComponent:RemoveTimeScaleCurve(InstanceId,shieldUpdate)
	InstanceId = InstanceId or self.curveInstance
	self.curves[InstanceId] = nil

	for _, map in pairs(self.skillTimeScaleCurveMap) do
		for key, insId in ipairs(map) do
			if insId == InstanceId then
				table.remove(map, key)
				break
			end
		end
	end
	if not shieldUpdate then
		self:UpdateCurveInfo()
	end
end

function TimeComponent:UpdateCurveInfo()
	local timeScale = -1 --self.curCurvesTimeScale

	--在这里计算移除屏蔽顿帧,且屏蔽递归计算
	self:CheckRemovePauseFrameData(true)

	self.removeList = self.removeList or {}
	_clearTable(self.removeList)

	for k, v in pairs(self.curves) do
		local index = self.realFrame - v.startFrame
		local ts = v.curve[index] or v.scale
		v.scale = ts
		if ts and (ts < timeScale or timeScale == -1) then
			timeScale = ts
		end
		
		if v.endFrame <= self.realFrame then
			table.insert(self.removeList, v.Instance)
		end
	end
	
	for i = 1, #self.removeList do
		-- 增加屏蔽递归计算
		self:RemoveTimeScaleCurve(self.removeList[i],true)
	end

	--根据策划需求
	--ShieldPauseFrameType.NoSelfPauseFrame 仅让skillID影响时间缩放
	--ShieldPauseFrameType.AllPauseFrame 所有时间缩放不生效
	if self.shieldPauseFrameData then
		if self.shieldPauseFrameData.ShieldPauseFrameType == _fightEnum.ShieldPauseFrameType.NoSelfPauseFrame then
			local targetSkillId = self.shieldPauseFrameData.triggerSkillId
			local skillInstanceMap = self.skillTimeScaleCurveMap[targetSkillId]
			if skillInstanceMap then
				for k, v in pairs(skillInstanceMap) do
					local curveInfo  = self.curves[v]
					local index = self.realFrame - curveInfo.startFrame
					local ts = curveInfo.curve[index] or curveInfo.scale
					curveInfo.scale = ts
					if ts and (ts < timeScale or timeScale == -1) then
						timeScale = ts
					end
				end
			end
		else
			timeScale = -1
		end
	end
	
	self.curCurvesTimeScale = timeScale
	self:ResetCalculateTimeScale()
end

function TimeComponent:ResetCalculateTimeScale()
	local timeScale = self.curCurvesTimeScale

	--根据策划需求
	--ShieldPauseFrameType.NoSelfPauseFrame 仅让skillID影响时间缩放
	--ShieldPauseFrameType.AllPauseFrame 所有时间缩放不生效
	if self.shieldPauseFrameData then
		if self.shieldPauseFrameData.ShieldPauseFrameType == _fightEnum.ShieldPauseFrameType.NoSelfPauseFrame then
			local targetSkillId = self.shieldPauseFrameData.triggerSkillId

			local skillScales = self.skillTimeScaleMap[targetSkillId]
			if skillScales then
				for i, v in pairs(skillScales) do
					if (i < timeScale or timeScale == -1) and v > 0 then
						timeScale = i
					end
				end
				if timeScale == 1 then
					for i, v in pairs(skillScales) do
						if i > timeScale and v > 0 then
							timeScale = i
						end
					end
				end
			end
		end
	else
		for i, v in pairs(self.currTimeScales) do
			if (i < timeScale or timeScale == -1) and v > 0 then
				timeScale = i
			end
		end
		if timeScale == 1 then
			for i, v in pairs(self.currTimeScales) do
				if i > timeScale and v > 0 then
					timeScale = i
				end
			end
		end
	end
	
	self.currTimeScale = timeScale
	self:ChangeTimeScale()
end

function TimeComponent:ChangeTimeScale()
	local timeScale = self:GetTimeScale()
	if self.lastTimeScale == timeScale then
		return
	end
	self.lastTimeScale = timeScale
	self:OnUpdateTimeScale()

	local ingoreChild = self.entity.buffComponent and self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.TimeScaleIngoreChild)
	if self.childTimeScaleMap and not ingoreChild then
		local entityManager = self.fight.entityManager
		for instanceId, _ in pairs(self.childTimeScaleMap) do
			local entity = entityManager:GetEntity(instanceId)
			if entity then
				entity.timeComponent:SetParentTimeScale(timeScale)
			end
		end
	end
end

function TimeComponent:SetParentTimeScale(timeScale)
	self.parentRealTimeScale = timeScale
	self:OnUpdateTimeScale()
end

function TimeComponent:SetIsUseParentTimeScale(isUseParentTimeScale)
	self.isUseParentTimeScale = isUseParentTimeScale
	self:OnUpdateTimeScale()
end

function TimeComponent:OnUpdateTimeScale()
	if ctx then
		local clientEntity = self.entity.clientEntity
		local timeScale = self:GetTimeScale()

		if clientEntity.clientAnimatorComponent then
			clientEntity.clientAnimatorComponent:SetTimeScale(timeScale)
		end

		if clientEntity.clientTransformComponent then
			clientEntity.clientTransformComponent:SetTimeScale(timeScale)
		end
		if clientEntity.clientBuffComponent then
			clientEntity.clientBuffComponent:SetTimeScale(timeScale)
		end
		if clientEntity.weaponComponent then
			clientEntity.weaponComponent:SetTimeScale(timeScale)
		end
		local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
		if ctrlEntity == self.entity.instanceId then
			self.fight.clientFight.cameraManager:UpdateNoiseTimeScale(timeScale)
		end
	end
end

-- function TimeComponent:GetUpdateTimes()
function TimeComponent:TryUpdate()
	if self.entity.buffComponent then
		if self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.PauseEntityTime)
			or self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.PauseTime) then
			return false
		end
	end

	self.realFrame = self.realFrame + 1
	self:UpdateCurveInfo()
	if self.timeScaleWithDuration then
		for k, v in pairs(self.timeScaleWithDuration) do
			self.timeScaleWithDuration[k].durationFrame = self.timeScaleWithDuration[k].durationFrame - 1
			if self.timeScaleWithDuration[k].durationFrame <= 0 then
				self:RemoveTimeScale(v.timeScale)
				self.timeScaleWithDuration[k] = nil
			end
		end
	end

	local timeScale = self:GetTimeScale()
	if timeScale > 0 and self.time == 0 then
		self.time = self.time + timeScale * FightUtil.deltaTime
	end
	-- local updateTimes = 0
	-- self.time = self.time + timeScale * FightUtil.deltaTime
	-- while self.time + fix >= (self.frame + 1) * FightUtil.deltaTime do
	if self.time + fix >= (self.frame + 1) * FightUtil.deltaTime then
		self.frame = self.frame + 1
		-- 加速播放的时候不重置时间
		if timeScale <= 1 then
			self.time = self.frame * FightUtil.deltaTime
		end

		if self.lastFrameSplit then
			if self.entity.skillComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
				self.entity.skillComponent.frameEventComponent:DoSplitFrameEvent(1)--保证跑完所有的小数帧
			end
			self.lastFrameSplit = false
		end

		-- updateTimes = updateTimes + 1
		return true
	else
		self.time = self.time + timeScale * FightUtil.deltaTime
	end

	if self.clearPassSplitFrame then
		self.passSplitFrame = 0
		self.clearPassSplitFrame = false
	end

	-- if updateTimes == 0 then
		self.lastFrameSplit = true
		self.passSplitFrame = self.passSplitFrame + timeScale
		local SplitFrame = (self.time - self.frame * FightUtil.deltaTime) / FightUtil.deltaTime
		if self.entity.skillComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
			self.entity.skillComponent.frameEventComponent:DoSplitFrameEvent(SplitFrame)
		end
	-- else
	-- 	if self.lastFrameSplit then
	-- 		if self.entity.skillComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
	-- 			self.entity.skillComponent.frameEventComponent:DoSplitFrameEvent(1)--保证跑完所有的小数帧
	-- 		end
	-- 	end
	-- 	self.lastFrameSplit = false
	-- end

	if self.passSplitFrame >= 1 then
		self.passSplitFrame = self.passSplitFrame - 1
	end

	-- return updateTimes
	return false
end

function TimeComponent:GetCurSplitFrameInfo()
	if self.passSplitFrame == 0 then
		return 0
	end

	self.clearPassSplitFrame = true

	return self.passSplitFrame
end

function TimeComponent:BingParentTimeScale(parentTimeComponent)
	self.parentTimeComponent = parentTimeComponent
	self.parentTimeComponent:AddChildTimeScale(self.entity.instanceId)
	self.parentRealTimeScale = self.parentTimeComponent:GetTimeScale()
end

function TimeComponent:UnBingParentTimeScale()
	if not self.parentTimeComponent then
		return
	end

	self.parentTimeComponent:RemoveChildTimeScale(self.entity.instanceId)
	self.parentTimeComponent = nil
	self.parentRealTimeScale = 1
end

function TimeComponent:AddChildTimeScale(childInstanceId)
	self.childTimeScaleMap = self.childTimeScaleMap or {}
	self.childTimeScaleMap[childInstanceId] = childInstanceId
end

function TimeComponent:AddShieldPauseFrame(data)
	local entity = self.entity
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

	self:UpdateCurveInfo()
	--[[
	local shieldType = data.shieldPauseFrameType
	if shieldType == FightEnum.ShieldPauseFrameType.NoSelfPauseFrame then
		self:RemoveTimeScaleBySkillId(curSkillId)
	elseif shieldType == FightEnum.ShieldPauseFrameType.AllPauseFrame then
		self:RemoveAllTimeScale()
	end
	]]
end

--[[
function TimeComponent:RemoveTimeScaleBySkillId(skillId)
	for id, timeScaleMap in pairs(self.skillTimeScaleMap) do
		if id ~= skillId or id == 0 then
			for scale, _ in pairs(timeScaleMap) do
				self.currTimeScales[scale] = 0
			end
			timeScaleMap = {}
		end
	end

	for id, curveMap in pairs(self.skillTimeScaleCurveMap) do
		if id ~= skillId or id == 0 then
			for _, insId in pairs(curveMap) do
				self.curves[insId] = nil
			end
			curveMap = {}
		end
	end

	self:UpdateCurveInfo()
end
]]
function TimeComponent:CheckRemovePauseFrameData(shieldUpdate)
	if not self.shieldPauseFrameData then return end
	local curFrame = self.fight.fightFrame
	if self.shieldPauseFrameData.endFrame <= curFrame then
		self:RemoveShieldData(shieldUpdate)
	end
end

function TimeComponent:RemoveShieldData(shieldUpdate)
	self.shieldPauseFrameData = nil
	if not shieldUpdate then
		self:UpdateCurveInfo()
	end
end
--[[
function TimeComponent:RemoveAllTimeScale()
	self.skillTimeScaleMap = {}
	self.skillTimeScaleCurveMap = {}

	self.currTimeScales = {}
	self.timeScaleWithDuration = {}
	self.curves = {}
	self.curCurvesTimeScale = -1

	self:UpdateCurveInfo()
end
]]
function TimeComponent:RemoveChildTimeScale(childInstanceId)
	if self.childTimeScaleMap then
		self.childTimeScaleMap[childInstanceId] = nil
	end
end

function TimeComponent:RemoveCanBreakPauseFrame()
	for k, v in pairs(self.timeScaleWithDuration or {}) do
		if v.isCanBreak then
			self:RemoveTimeScale(v.timeScale)
			self.timeScaleWithDuration[k] = nil
		end
	end

	for k, v in pairs(self.curves or {}) do
		if v.isCanBreak then
			self:RemoveTimeScaleCurve(k)
		end
	end
end

function TimeComponent:GetTimeScale()
	local scale = self.currTimeScale 
	if self.currTimeScale < 0 then
		if self.useEnemyCommonTimeScale then
			scale = self.enemyTimeScale
		elseif self.useRoleCommonTimeScale then
			scale = self.roleTimeScale
		else 
			scale = 1
		end
	end
	
	if self.parentTimeComponent and self.isUseParentTimeScale then
		return self.timeScale * self.parentRealTimeScale * scale
	else
		return self.timeScale * scale
	end
end

function TimeComponent:OnCache()
	self.fight.objectPool:Cache(TimeComponent,self)
end

function TimeComponent:__cache()
	self.time = 0
	self.frame = 0
	self.timeScale = 1
	self.currTimeScales = {}
	self.currTimeScale = 1
	self.parentRealTimeScale = 1
	self.parentTimeComponent = nil
	self.childTimeScaleMap = nil
	self.useEnemyCommonTimeScale = nil
	self.useRoleCommonTimeScale = nil
	self.timeScaleWithDuration = {}
	self.isUseParentTimeScale = true
end

function TimeComponent:__delete()
end