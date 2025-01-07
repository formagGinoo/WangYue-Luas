
---@class TimeComponent
TimeComponent = BaseClass("TimeComponent",PoolBaseClass)
local _insert = table.insert
local _remove = table.remove
---时间比较偏移---
local fix = 0.01

function TimeComponent:__init()
	self.timeScale = 1
	self.parentRealTimeScale = 1
	self.time = 0
	self.frame = 0
	self.realFrame = 0--不受缩放影响的帧率
	self.currTimeScales = {}
	self.currTimeScale = 1
	self.lastTimeScale = 1
	self.curves = {}
	self.curveInstance = 0
	self.curCurvesTimeScale = 1
	self.timeScaleWithDuration = {}
	self.isUseParentTimeScale = true
end

function TimeComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Time)
	if self.config and self.config.DefalutTimeScale then
		self.timeScale = self.config.DefalutTimeScale
	end
end

function TimeComponent:UpdateEnemyCommonTimeScale()
	if self.useEnemyCommonTimeScale then
		local scale = 1
		if self.fight.entityManager.enemyCommonTimeScale and self.entity.buffComponent and not self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.IgnoreCommonEnemyTimeScale) then
			scale = self.fight.entityManager.enemyCommonTimeScale
		end

		self.timeScale = self.config.DefalutTimeScale * scale
		self:ChangeTimeScale()
	end
end

function TimeComponent:LateInit()
	if self.entity.owner and self.entity.owner ~= self.entity
		 and self.entity.owner.timeComponent then
		self:BingParentTimeScale(self.entity.owner.timeComponent)
	end

	if self.entity.tagComponent then
		if self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Monster
			or self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Elite
			or self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Boss then
			self.timeScale = self.config.DefalutTimeScale * self.fight.entityManager.enemyCommonTimeScale
			self.useEnemyCommonTimeScale = true
		end
	end

	self:ChangeTimeScale()
end

function TimeComponent:AddTimeScale(timeScale, durationFrame, isCanBreak)
	if durationFrame then
		table.insert(self.timeScaleWithDuration, { timeScale = timeScale, durationFrame = durationFrame, isCanBreak = isCanBreak })
	end

	if self.currTimeScales[timeScale] then
		self.currTimeScales[timeScale] = self.currTimeScales[timeScale] + 1
	else
		self.currTimeScales[timeScale] = 1
	end
	self:ResetCalculateTimeScale()
end

function TimeComponent:RemoveTimeScale(timeScale)
	self.currTimeScales[timeScale] = self.currTimeScales[timeScale] - 1
	self:ResetCalculateTimeScale()
end

function TimeComponent:AddTimeScaleCurve(entityId, curveId, isCanBreak, frame)
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
	self:UpdateCurveInfo()
	return self.curveInstance
end

function TimeComponent:RemoveTimeScaleCurve(InstanceId)
	InstanceId = InstanceId or self.curveInstance
	self.curves[InstanceId] = nil
	self:UpdateCurveInfo()
end

function TimeComponent:UpdateCurveInfo()
	local timeScale = 1--self.curCurvesTimeScale
	local removeList = {}
	for k, v in pairs(self.curves) do
		local index = self.realFrame - v.startFrame
		local ts = v.curve[index] or v.scale
		v.scale = ts
		if ts and ts < timeScale then
			timeScale = ts
		end
		
		if v.endFrame <= self.realFrame then
			table.insert(removeList, v.Instance)
		end
	end
	
	for i = 1, #removeList do
		self:RemoveTimeScaleCurve(removeList[i])
	end
	
	self.curCurvesTimeScale = timeScale
	self:ResetCalculateTimeScale()
end

function TimeComponent:ResetCalculateTimeScale()
	local timeScale = self.curCurvesTimeScale
	for i, v in pairs(self.currTimeScales) do
		if i < timeScale and v > 0 then
			timeScale = i
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

	if self.childTimeScaleMap then
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
		local ctrlEntity = BehaviorFunctions.GetCtrlEntity()
		if ctrlEntity == self.entity.instanceId then
			self.fight.clientFight.cameraManager:UpdateNoiseTimeScale(timeScale)
		end
	end
end

function TimeComponent:TryUpdate()
	if self.entity.buffComponent then
		if self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.PauseEntityTime)
			or self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.PauseTime) then
			return false
		end
	end

	self.realFrame = self.realFrame + 1
	self:UpdateCurveInfo()
	local timeScale = self:GetTimeScale()
	if self.timeScaleWithDuration then
		for k, v in pairs(self.timeScaleWithDuration) do
			self.timeScaleWithDuration[k].durationFrame = self.timeScaleWithDuration[k].durationFrame - 1
			if self.timeScaleWithDuration[k].durationFrame <= 0 then
				self:RemoveTimeScale(v.timeScale)
				self.timeScaleWithDuration[k] = nil
			end
		end
	end

	self.time = self.time + timeScale * FightUtil.deltaTime
	if self.time + fix >= (self.frame + 1) * FightUtil.deltaTime then
		self.frame = self.frame + 1
		return true
	end
	return false
end

function TimeComponent:BingParentTimeScale(parentTimeComponent)
	self.parentTimeComponent = parentTimeComponent
	self.parentTimeComponent:AddChildTimeScale(self.entity.instanceId)
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
	if self.parentTimeComponent and self.isUseParentTimeScale then
		return self.timeScale * self.parentRealTimeScale * self.currTimeScale
	else
		return self.timeScale * self.currTimeScale
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
	self.timeScaleWithDuration = {}
	self.isUseParentTimeScale = true
end

function TimeComponent:__delete()
end