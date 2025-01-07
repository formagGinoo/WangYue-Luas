---@type Entity
Entity = BaseClass("Entity",PoolBaseClass)
local componentType = FightEnum.ComponentType
local _fightEnum = FightEnum
local _unityUtils = UnityUtils
local _eventMgr = EventMgr
local _eventName = EventName
local _luaEntityProfiler = LuaEntityProfiler
local _DebugConfig = DebugConfig
local BF = BehaviorFunctions
function Entity:__init()
	self.components = {}
	self.parent = nil
	self.child = {}
	self.childInstance = {}
	self.values = {}

	self.magicParams = {}
	self.stateSigns = {}
	self.removesState = {}
	self.interactId = 1
	self.interactItemState = true
	self.interactItem = {}
	self.isOnScreen = true
	self.isLodDelay = true
	self.triggerHideType = {}
end

function Entity:Init(fight,instanceId,entityId, sInstanceId, params)
	self.fight = fight
	self.entityManager = fight.entityManager
	self.instanceId = instanceId
	-- 生态id
	self.sInstanceId = sInstanceId
	self.entityId = entityId
	self.config = EntityConfig.GetEntity(entityId)

	if self.parent and next(self.parent) then
		self.parent:AddChild(self)
	end
	
	self.trigger = {}
	self.triggerArea = {}

	self.params = params

	self.updateComponentEnable = true
	self.defaultSkillLevel = nil
	self.defaultSkillType = nil
	
	self.entitySignRecord = {}--对EntitySign做记录(用于复活后给对应的实体添加状态)
	self.entityMagicRecord = {}--对Magic做记录(用于复活后给对应的实体添加状态)
end

-- 初始化组件
function Entity:InitComponents()
	if self.behaviorComponent then
		self.behaviorComponent:Init(self.fight,self)
	end

	if self.commonBehaviorComponent then
		self.commonBehaviorComponent:Init(self.fight, self)
	end

	for i = 1, componentType.Lenght do
		local component = self.components[i]
		if component and component.Init then
			component:Init(self.fight,self)
		end
	end
end

-- 初始化组件依赖关系
function Entity:LateInitComponents()
	for i = 1, componentType.Lenght do
		local component = self.components[i]
		if component and component.LateInit then
			_unityUtils.BeginSample("LateInitComponents_"..component.__className)
			component:LateInit()
			_unityUtils.EndSample()
		end
	end

	if self.timeComponent then
		self.timeComponent:LateInit()
	end
	
	if self.moveComponent then
		self.moveComponent:LateInit()
	end
	
	--behavior在这里操作数据了，得放到所有都初始化完再初始化
	if self.behaviorComponent and self.behaviorComponent.LateInit then
		self.behaviorComponent:LateInit()
	end

	if self.commonBehaviorComponent and self.commonBehaviorComponent.LateInit then
		self.commonBehaviorComponent:LateInit()
	end
end

function Entity:BeforeUpdate(centerPos)
	--_luaEntityProfiler:OnEntityUpdateStart(self.instanceId,self.entityId)
	self:UpdateComponentLodInfo(centerPos)
	

	if self.transformComponent then
		self:BeforeUpdateComponent("transformComponent")
	end
	if _DebugConfig.NpcAiLOD and not self.updateComponentEnable then
		return
	end
	--TODO
	if self.behaviorComponent then
		self:BeforeUpdateComponent("behaviorComponent")
	end

	if self.commonBehaviorComponent then
		self:BeforeUpdateComponent("commonBehaviorComponent")
	end

	if not self.stateComponent or 
		self.stateComponent.backstage ~= _fightEnum.Backstage.Background then
		if self.moveComponent then
			self:BeforeUpdateComponent("moveComponent")
		end
	end
	--_luaEntityProfiler:OnEntityUpdateEnd(self.instanceId,self.entityId)
end

function Entity:Update()
	--_luaEntityProfiler:OnEntityUpdateStart(self.instanceId,self.entityId)
	--新增实体能时间加速逻辑
	-- local updateTimes = 0
	-- if self.timeComponent then
	-- 	updateTimes = self.timeComponent:GetUpdateTimes()
	-- end
	
	-- self:RealUpdate(updateTimes)--有些组件不受时间影响，所以0和1都要跑一次
	-- -->=2 才会跑多一次
	-- for i = 2, updateTimes do
	-- 	self:RealUpdate(updateTimes)
	-- end

	if self.timeComponent and self.timeComponent:TryUpdate() then
		self:RealUpdate(1)
		while self.timeComponent and self.timeComponent:TryUpdate() do
			self:RealUpdate(1)
		end
	else
		self:RealUpdate(0)
	end

	--_luaEntityProfiler:OnEntityUpdateEnd(self.instanceId,self.entityId)
end

function Entity:RealUpdate(updateTimes)
	if _DebugConfig.NpcAiLOD and not self.updateComponentEnable then
		-- TODO 临时代码
		self:UpdateComponent("triggerComponent")
		return
	end

	self:StartEntitySample()
	local isPauseBehavior = self.buffComponent and self.buffComponent:CheckState(_fightEnum.EntityBuffState.PauseBehavior)
	if self.behaviorComponent and not isPauseBehavior then
		self:UpdateComponent("behaviorComponent")
	end

	if self.commonBehaviorComponent and not isPauseBehavior then
		self:UpdateComponent("commonBehaviorComponent")
	end
	
	if self.buffComponent then
		self:UpdateComponent("buffComponent")
	end

	if self.customFSMComponent then
		self:UpdateComponent("customFSMComponent")
	end

	if not self.stateComponent or 
		self.stateComponent.backstage == _fightEnum.Backstage.Foreground then
		self:UpdateForeGroundComp(updateTimes)
	elseif self.stateComponent.backstage == _fightEnum.Backstage.Combination then
		self:UpdateCombineGroundComp(updateTimes)
	else
		if self.stateComponent and self.stateComponent:IsState(_fightEnum.EntityState.Revive) then
			self:UpdateComponent("stateComponent")
		end
		if self.skillSetComponent then
			self.skillSetComponent:UpdateIgnoreTimeScale()
		end
	end

	self:UpdateSignsState()

	self:EndEntitySample()
end

function Entity:AfterUpdate()
	if _DebugConfig.NpcAiLOD and not self.updateComponentEnable then
		return
	end
	--_luaEntityProfiler:OnEntityUpdateStart(self.instanceId,self.entityId)
	--TODO
	if self.attrComponent then
		self:AfterUpdateComponent("attrComponent")
	end

	if self.behaviorComponent then
		self:AfterUpdateComponent("behaviorComponent")
	end

	if self.commonBehaviorComponent then
		self:AfterUpdateComponent("commonBehaviorComponent")
	end

	if self.timeoutDeathComponent then
		self:AfterUpdateComponent("timeoutDeathComponent")
	end

	if not self.stateComponent or 
		self.stateComponent.backstage ~= _fightEnum.Backstage.Background then
		if self.swimComponent then
			self:AfterUpdateComponent("swimComponent")
		end
		if self.rotateComponent then
			self:AfterUpdateComponent("rotateComponent")
		end
		_unityUtils.BeginSample("moveComponent AfterUpdate")
		
		_unityUtils.EndSample()
		if self.climbComponent then
			self:AfterUpdateComponent("climbComponent")
		end
		if self.blowComponent then
			self:AfterUpdateComponent("blowComponent")
		end
		
		if self.transformComponent then
			self:AfterUpdateComponent("transformComponent")
		end
		if self.moveComponent then
			self:AfterUpdateComponent("moveComponent")
		end
	elseif self.stateComponent.backstage == _fightEnum.Backstage.Background then
		self.moveComponent:SetForcePositionOffset(0, 0, 0)
	end

	if self.componentLodInfo then
		self.componentLodInfo.UpdateFrame = self.fight.fightFrame + self.componentLodInfo.IntervalFrame
	end
	--_luaEntityProfiler:OnEntityUpdateEnd(self.instanceId,self.entityId)
end

function Entity:BeforeUpdateComponent(componentName)
	if _DebugConfig.NpcAiLOD and self.componentLodInfo and
		not self.componentLodInfo.UpdateComponents[componentName] then
		return
	end

	self[componentName]:BeforeUpdate()
end

function Entity:UpdateComponent(componentName)
	if _DebugConfig.NpcAiLOD and self.componentLodInfo and
		not self.componentLodInfo.UpdateComponents[componentName] then
		-- TODO 临时代码
		if componentName == "triggerComponent" and self[componentName] then
			self[componentName]:Update()
		end
		return
	end

	self:StartEntitySample(componentName)
	self[componentName]:Update()
	self:EndEntitySample()
end

function Entity:AfterUpdateComponent(componentName)
	if  _DebugConfig.NpcAiLOD and self.componentLodInfo and
		not self.componentLodInfo.UpdateComponents[componentName] then
		return
	end

	self[componentName]:AfterUpdate()
end

function Entity:UpdateForeGroundComp(updateTimes)
	if self.stateComponent then
		self:UpdateComponent("stateComponent")
	end
	
	if self.skillComponent then
		self.skillComponent:UpdateIgnoreTimeScale()
	end
	
	if self.animatorComponent then
		self:UpdateComponent("animatorComponent")
	end

	if self.swimComponent then
		self:UpdateComponent("swimComponent")
	end

	if self.moveComponent then
		self:UpdateComponent("moveComponent")
	end

	if self.deathComponent then
		self:UpdateComponent("deathComponent")
	end

	if self.skillSetComponent then
		self.skillSetComponent:UpdateIgnoreTimeScale()
	end

	if self.elementStateComponent then
		self.elementStateComponent:UpdateIgnoreTimeScale()
	end

	if self.timeComponent then
		if updateTimes == 0 then
			return
		end
	end

	for i = 1, componentType.Lenght do
		local component = self.components[i]
		if self.instanceId == 0 then return end
		local ingoreUpdate = i == componentType.State or i == componentType.Animator
		if not ingoreUpdate and component and component.Update then
			self:UpdateComponent(component.name)
		end
	end
end

function Entity:RemoveComponent(componentType)
	local component = self.components[componentType]
	if component then 
		if component.name then
			self[component.name] = nil
		end

		component:OnCache()
		self.components[componentType] = nil
	end
end

function Entity:UpdateCombineGroundComp(updateTimes)
	if self.skillComponent then
		self:UpdateComponent("skillComponent")
		self.skillComponent:UpdateIgnoreTimeScale()
	end
	if self.stateComponent then
		self:UpdateComponent("stateComponent")
		self.stateComponent:UpdateIgnoreTimeScale()
	end

	if self.deathComponent then
		self:UpdateComponent("deathComponent")
	end

	if self.timeComponent then
		if updateTimes == 0 then
			return
		end
	end

	if self.skillComponent then
		self:UpdateComponent("skillComponent")
	end
	if self.stateComponent then
		self:UpdateComponent("stateComponent")
	end
	if self.animatorComponent then
		self:UpdateComponent("animatorComponent")
	end

	if self.combinationComponent then
		self:UpdateComponent("combinationComponent")
	end
end

function Entity:LifeBindEntity(instanceId)
	self.lifeBindEntity = self.lifeBindEntity or {}
	table.insert(self.lifeBindEntity, instanceId)
end

function Entity:CallBehaviorFun(funName, ...)
	_unityUtils.BeginSample("Entity:CallBehaviorFun".. funName)
	if self.behaviorComponent then
		self.behaviorComponent:CallFunc(funName, ...)
	end
	if self.commonBehaviorComponent then
		self.commonBehaviorComponent:CallFunc(funName, ...)
	end
	_unityUtils.EndSample()
end

function Entity:__cache()
	if self.behaviorComponent then
		self.behaviorComponent:OnCache()
		self.behaviorComponent = nil
	end

	if self.commonBehaviorComponent then
		self.commonBehaviorComponent:OnCache()
		self.commonBehaviorComponent = nil
	end

	for i = 1, componentType.Lenght do
		local component = self.components[i]
		if component then
			if component.name then
				self[component.name] = nil
			end
			if not component.OnCache then
				LogError(component.name.."没有写回收逻辑")
			else
				component:OnCache()
			end
		end
	end

	for k, v in pairs(self.stateSigns) do
		self.fight.objectPool:Cache(StateSign, v)
		self.stateSigns[k] = nil
	end

	if self.moveComponent then
		self.moveComponent:OnCache()
		self.moveComponent = nil
	end
	if self.climbComponent then
		self.climbComponent:OnCache()
		self.climbComponent = nil
	end
	if self.swimComponent then
		self.swimComponent:OnCache()
		self.swimComponent = nil
	end
	if self.buffComponent then
		self.buffComponent:OnCache()
		self.buffComponent = nil
	end
	if self.timeComponent then
		self.timeComponent:OnCache()
		self.timeComponent = nil
	end
	if self.deathComponent then
		self.deathComponent:OnCache()
		self.deathComponent = nil
	end
	local entityManager = self.entityManager
	if self.lifeBindEntity then
		for k, instanceId in pairs(self.lifeBindEntity) do
			entityManager:RemoveEntity(instanceId)
		end
		self.lifeBindEntity = nil
	end

	if self.child and next(self.child) then
		for i = #self.child, 1, -1 do
			entityManager:RemoveEntity(self.child[i].instanceId)
		end
	end

	if self.parent then
		self.parent:RemoveChild(self)
	end

	TableUtils.ClearTable(self.components)
	--self.components = {}
	self.instanceId = 0
	self.entityId = 0
	self.sInstanceId = nil
	self.fight = nil
	self.parent = nil
	self.root = nil
	self.interactItemState = true
	self.isOnScreen = true
	self.isLodDelay = true
	--self.child = {}
	TableUtils.ClearTable(self.child)
	--self.childInstance = {}
	TableUtils.ClearTable(self.childInstance)
	TableUtils.ClearTable(self.values)
	TableUtils.ClearTable(self.magicParams)
	
	self:RemoveTrigger()

	if self.componentLodList then
		self.updateComponentEnable = true
		self.componentLodInfo = nil
		self.componentLodList = nil	
	end
end

function Entity:RemoveBehaviorComponent()
	if self.behaviorComponent then
		self.behaviorComponent:DeleteMe()
		self.behaviorComponent = nil
	end
end

function Entity:GetComponentConfig(componentType)
	local configName = _fightEnum.ComponentConfigName[componentType]
	return self.config.Components[configName]
end

function Entity:OnSwitchPlayerCtrl()
	if self.clientEntity.clientIkComponent then
		self.clientEntity.clientIkComponent:OnSwitchPlayerCtrl()
	end
end

function Entity:Revive(isTransport, reviveLife)
	if not self.stateComponent or not self.stateComponent:IsState(_fightEnum.EntityState.Death) then
		return
	end

	self.stateComponent:SetState(_fightEnum.EntityState.Revive, isTransport, reviveLife)
end

function Entity:__delete()
	if not self.entityManager.removing then
		if self.child and next(self.child) then
			for i = #self.child, 1, -1 do
				self.entityManager:RemoveEntity(self.child[i].instanceId, true)
			end
		end

		if self.parent then
			self.parent:RemoveChild(self)
		end
	end

	self.instanceId = 0
	self.entityId = 0
	self.fight = nil
	self.interactId = 1
	self.interactItemState = true
	self.interactItem = {}

	for k,v in pairs(self.components) do
		if v.DeleteMe then
			v:DeleteMe()
		end
	end
	self.components = nil
	TableUtils.ClearTable(self.entitySignRecord)
	TableUtils.ClearTable(self.entityMagicRecord)
end

function Entity:StartEntitySample(name)
	local s = self.entityId * 10000 + self.instanceId
	_unityUtils.BeginSample(name or s)
end

function Entity:EndEntitySample()
	_unityUtils.EndSample()
end

function Entity:SetDeadTransport()
	local lifeType = EntityAttrsConfig.AttrType.Life
	self.attrComponent:SetValue(lifeType, 0, _fightEnum.AttrGroupType.Additvie)
	self.attrComponent:SetValue(lifeType, 0)
end

function Entity:AddChild(child)
	if self.childInstance[child.instanceId] then
		return
	end

	table.insert(self.child, child)
	self.childInstance[child.instanceId] = true
end

function Entity:RemoveChild(child, index)
	local removeIndex = index
	if not removeIndex then
		for i = #self.child, 1, -1 do
			if self.child[i].instanceId == child.instanceId then
				removeIndex = i
				break
			end
		end
	end

	table.remove(self.child, removeIndex)
	self.childInstance[child.instanceId] = nil
end

function Entity:OnTriggerEnter(triggerType, selfColliderInstanceId, otherColliderInstanceId, layer)
	for _, v in pairs(_fightEnum.TriggerType) do
		if v & triggerType ~= 0 then
			local data = self.trigger[v]
			if not data then
				self.trigger[v] = {}
				data = self.trigger[v]
			end

			local dataCollider = data[selfColliderInstanceId]
			if not dataCollider then
				data[selfColliderInstanceId] = {}
				dataCollider = data[selfColliderInstanceId]
			end

			dataCollider[otherColliderInstanceId] = layer
		end
	end

end

function Entity:OnTriggerExit(triggerType, selfColliderInstanceId, otherColliderInstanceId)
	for _, v in pairs(_fightEnum.TriggerType) do
		if v & triggerType ~= 0 then
			local data = self.trigger[v]
			if not data then
				return
			end
			
			local dataCollider = data[selfColliderInstanceId]
			if not dataCollider then
				return
			end
			
			dataCollider[otherColliderInstanceId] = nil
		end
	end
end

function Entity:TriggerInitialClear(colliderInstanceId)
	if not self.trigger then
		return
	end

	for _, data in pairs(self.trigger) do
		data[colliderInstanceId] = nil
	end
end

function Entity:OnTriggerRemove(triggerType, selfColliderInstanceId)
	if not self.trigger then
		return 
	end
	
	local hadTrigger = false
	for _, data in pairs(self.trigger) do
		for _, dataCollider in pairs(data) do
			if dataCollider[selfColliderInstanceId] then
				dataCollider[selfColliderInstanceId] = nil
				hadTrigger = true
			end
		end
	end
	
	return hadTrigger
end

function Entity:CheckTriggerEntity(triggerType, instanceId, colliderId)
	local data = self.trigger[triggerType]
	if not data then
		return false
	end
	
	local entityManager = self.fight.entityManager
	if not colliderId then
		for _, colliderData in pairs(data) do
			for k, _ in pairs(colliderData) do
				local entity = entityManager:GetColliderEntity(k)
				if entity and entity.instanceId == instanceId then
					return true
				end
			end
		end
		return false
	end

	local dataCollider = data[colliderId]
	if not dataCollider then
		return false
	end
	
	for k, _ in pairs(dataCollider) do
		local entity = entityManager:GetColliderEntity(k)
		if entity and entity.instanceId == instanceId then
			return true
		end
	end
	
	return false
end

function Entity:GetTriggerEntity(triggerType, colliderId, cacheTable)
	cacheTable = cacheTable or {}
	TableUtils.ClearTable(cacheTable)
	
	local data = self.trigger[triggerType]
	if not data then
		return cacheTable
	end

	local entityManager = self.fight.entityManager
	if not colliderId then
		for _, colliderData in pairs(data) do
			for k, _ in pairs(colliderData) do
				local entity = entityManager:GetColliderEntity(k)
				if entity and entity.instanceId ~= self.instanceId then
					table.insert(cacheTable, entity.instanceId)
				end
			end
		end
		return cacheTable
	end

	local dataCollider = data[colliderId]
	if not dataCollider then
		return cacheTable
	end

	for k, _ in pairs(dataCollider) do
		local entity = entityManager:GetColliderEntity(k)
		if entity and entity.instanceId ~= self.instanceId then
			table.insert(cacheTable, entity.instanceId)
		end
	end

	return cacheTable
end

function Entity:CheckTriggerLayer(triggerType, layer, colliderId)
	local data = self.trigger[triggerType]
	if not data then
		return false
	end
	
	if not colliderId then
		for _, colliderData in pairs(data) do
			for _, v in pairs(colliderData) do
				if v == layer then
					return true
				end
			end
		end
		return false
	end

	local dataCollider = data[colliderId]
	if not dataCollider then
		return false
	end
	
	for _, v in pairs(dataCollider) do
		if v == layer then
			return true
		end
	end
	
	return false
end

function Entity:GetTriggerData(triggerType, colliderId)
	local data = self.trigger[triggerType]
	if not data then
		return
	end
	
	if not colliderId then
		return data
	end
	
	return data[colliderId]
end

function Entity:TriggerEnterArea(areaName, logicName)
	self.triggerArea[areaName] = self.triggerArea[areaName] or {}
	self.triggerArea[areaName][logicName] = true
	self.entityManager:CallBehaviorFun("EnterArea", self.instanceId, areaName, logicName)

	_eventMgr.Instance:Fire(_eventName.EnterLogicArea, self.instanceId, areaName, logicName)
end

function Entity:TriggerExitArea(areaName, logicName)
	if self.triggerArea[areaName] then
		self.triggerArea[areaName][logicName] = nil
		self.entityManager:CallBehaviorFun("ExitArea", self.instanceId, areaName, logicName)

		_eventMgr.Instance:Fire(_eventName.ExitLogicArea, self.instanceId, areaName, logicName)
	end
end

function Entity:CheckIsInArea(areaName, logicName)
	if self.triggerArea[areaName] then
		return self.triggerArea[areaName][logicName]
	end

	return false
end

function Entity:RemoveTrigger()
	TableUtils.ClearTable(self.trigger)
	TableUtils.ClearTable(self.triggerArea)
end

function Entity:SetComponentLodInfo()
	-- todo硬编码影响npc和采集物, 固定lod组件
	self.tempNeedCheckValue = false
	if self.tagComponent and self.tagComponent.tag == FightEnum.EntityTag.Npc and (self.tagComponent.npcTag == FightEnum.EntityNpcTag.NPC
			or self.tagComponent.npcTag == FightEnum.EntityNpcTag.Animal) then
		self.tempNeedCheckValue = true
		self.componentLodList = {
			[1] = {
				Lod = 3,
				Distance = 30,
				IntervalFrame = 120,
				IsStopMove = true,
				UpdateComponents = {
					["behaviorComponent"] = true,
					["moveComponent"] = true,
					["transformComponent"] = true,
					["stateComponent"] = true,
					["rotateComponent"] = true,
				}
			},
			[2] = {
				Lod = 2,
				Distance = 15,
				IntervalFrame = 30,
				UpdateComponents = {
					["transformComponent"] = true,
					["moveComponent"] = true,
					["behaviorComponent"] = true,
					["rotateComponent"] = true,
					["stateComponent"] = true,
				}
			},
			[3] = {
				Lod = 1,
				Distance = 10,
				IntervalFrame = 15,
				UpdateComponents = {
					["transformComponent"] = true,
					["behaviorComponent"] = true,
					["commonBehaviorComponent"] = true,
					["stateComponent"] = true,
					["rotateComponent"] = true,
					["moveComponent"] = true,
					["skillComponent"] = true,
				}
			},
		}
	elseif self.tagComponent and self.tagComponent.tag == FightEnum.EntityTag.Npc and self.tagComponent.npcTag == FightEnum.EntityNpcTag.Monster then
		self.componentLodList = {
			[1] = {
				Lod = 2,
				Distance = 20,
				IntervalFrame = 120,
				UpdateComponents = {
					["moveComponent"] = true,
					["transformComponent"] = true,
					["behaviorComponent"] = true,
					["skillComponent"] = true,
					["rotateComponent"] = true,
					["stateComponent"] = true,
				}
			},
		}
	elseif self.tagComponent and self.tagComponent.tag == FightEnum.EntityTag.SceneObj and self.tagComponent.sceneObjectTag ~= FightEnum.EntitySceneObjTag.Decoration
			and (self.entityId ~= 2080110 and self.entityId ~= 2020603 and self.entityId ~= 2030412 and self.entityId ~= 2030903 and
			self.entityId ~= 2001 and self.entityId ~= 2002 and self.entityId ~= 2003 and self.entityId ~= 2004 and self.entityId ~= 2050105) then
		self.componentLodList = {
			[1] = {
				Lod = 1,
				Distance = 15,
				IntervalFrame = 360,
				IsStopMove = true,
				UpdateComponents = {
					["rotateComponent"] = true,
					["transformComponent"] = true,
					["moveComponent"] = true,
				}
			}
		}
	end
end

function Entity:UpdateComponentLodInfo(centerPos)
	-- self.componentLodInfo = nil
	-- self.updateComponentEnable = true

	-- do return end
	--TODO 很多临时代码，得做正式版
	if not self.componentLodList then
		return
	end

	if centerPos then
		local selfPos = self.transformComponent:GetPosition()
		self.playerDistance = Vec3.DistanceXZ(centerPos, selfPos)
	else
		self.playerDistance = self.clientTransformComponent:GetEntityWithPlayerDistance()
	end
	if self.stateComponent and self.stateComponent:IsState(FightEnum.EntityState.Death) then
		self.componentLodInfo = nil
		self.updateComponentEnable = true
		if self.clientAnimatorComponent and self.clientAnimatorComponent.isStopAnimator and self.clientAnimatorComponent.animator then
			self.clientAnimatorComponent.animator.enabled = true
			self.clientAnimatorComponent.isStopAnimator = false
		end
		return
	end
	self.isOnScreen = BF.CheckNPCOnScreen(self)
	if self.tagComponent and self.tagComponent.tag == FightEnum.EntityTag.Npc and self.tagComponent.npcTag == FightEnum.EntityNpcTag.Monster and
			((self.values["MonsterInFight"] or self.values["hadBattle"]) or centerPos) then
		self.componentLodInfo = nil
		self.updateComponentEnable = true
		if self.clientAnimatorComponent and self.clientAnimatorComponent.isStopAnimator and self.clientAnimatorComponent.animator then
			self.clientAnimatorComponent.animator.enabled = true
			self.clientAnimatorComponent.isStopAnimator = false
		end
		self.clientTransformComponent:BanKccMove(false)
		if not centerPos then
			self.values["hadBattle"] = true
		end
		return
	end
	if self.playerDistance < 40 and (self.isOnScreen or centerPos) and self.tagComponent and self.tagComponent.tag == FightEnum.EntityTag.Npc and
			(self.tagComponent.npcTag == FightEnum.EntityNpcTag.NPC and (self.values["InPathFinding"] or centerPos)) then
		self.componentLodInfo = nil
		self.updateComponentEnable = true
		if self.clientAnimatorComponent and self.clientAnimatorComponent.isStopAnimator and self.clientAnimatorComponent.animator then
			self.clientAnimatorComponent.animator.enabled = true
			self.clientAnimatorComponent.isStopAnimator = false
		end
		self.clientTransformComponent:BanKccMove(false)
		return
	end
	for k, v in ipairs(self.componentLodList) do
		if v.Distance <= self.playerDistance then
			if not self.componentLodInfo or self.componentLodInfo.Lod ~= v.Lod then
				self.componentLodInfo = v
				self.componentLodInfo.UpdateFrame = 0
			end
			--不在视野中或不需要移动
			if self.componentLodInfo.IsStopMove or not self.isOnScreen then
				--停掉动画
				if self.clientAnimatorComponent and not self.clientAnimatorComponent.isStopAnimator and self.clientAnimatorComponent.animator then
					self.clientAnimatorComponent.animator.enabled = false
					self.clientAnimatorComponent.isStopAnimator = true
				end
				--关掉kcc
				self.clientTransformComponent:BanKccMove(true)
				self.updateComponentEnable = false
			else
				if self.clientAnimatorComponent and self.clientAnimatorComponent.isStopAnimator and self.clientAnimatorComponent.animator then
					self.clientAnimatorComponent.animator.enabled = true
					self.clientAnimatorComponent.isStopAnimator = false
				end
				self.clientTransformComponent:BanKccMove(false)
				self.updateComponentEnable = self.isLodDelay or self.componentLodInfo.UpdateFrame < self.fight.fightFrame
				self.isLodDelay = false
			end
			--self.transformComponent:Async()
			--if self.triggerComponent then
			--	self.triggerComponent:Update()
			--end
			--self.componentLodInfo.debugShowDistance = self.playerDistance --仅调试用，去掉不影响
			return
		end
	end
	if self.clientAnimatorComponent and self.clientAnimatorComponent.isStopAnimator and self.clientAnimatorComponent.animator then
		self.clientAnimatorComponent.animator.enabled = true
		self.clientAnimatorComponent.isStopAnimator = false
	end
	self.clientTransformComponent:BanKccMove(false)
	self.componentLodInfo = nil
	self.updateComponentEnable = true
end

function Entity:IsTpEntity()
	local tpConfig = self:GetComponentConfig(_fightEnum.ComponentType.Tp)
	if not tpConfig then return false end
	return true
end


function Entity:UpdateSignsState()
	for sign, stateSign in pairs(self.stateSigns) do
		if not stateSign:IsValid() then
			table.insert(self.removesState, sign)
		end
	end

	for _, sign in pairs(self.removesState) do
		if self.stateSigns[sign] then
			self.fight.objectPool:Cache(StateSign, self.stateSigns[sign])
			self.stateSigns[sign] = nil
			self.fight.entityManager:CallBehaviorFun("RemoveEntitySign",self.instanceId, sign)
		end
	end
	self.removesState = {}
end

function Entity:AddSignState(state, lastFrame, ignoreTimeScale)
	if lastFrame == nil then
		LogError("Sign: ".. state .." 的持续时间为空")
		return
	end

	local sign = self.stateSigns[state]
	if not sign then
		sign = self.fight.objectPool:Get(StateSign)
		sign:Init(self.fight, self, lastFrame, ignoreTimeScale, self.fight.fightFrame, self.timeComponent.frame)
		self.stateSigns[state] = sign
	end
	sign:Refresh(lastFrame, ignoreTimeScale, self.fight.fightFrame, self.timeComponent.frame)

	self.fight.entityManager:CallBehaviorFun("AddEntitySign", self.instanceId, state)
end

function Entity:GetSignInfo(sign)
	local stateSign = self.stateSigns[sign]
	if not stateSign then
		LogError(" sign is nil, sign = "..sign)
	end
	return stateSign
end

function Entity:RemoveSignState(sign)
	local stateSign = self.stateSigns[sign]
	if stateSign then
		self.fight.objectPool:Cache(StateSign, stateSign)
		self.stateSigns[sign] = nil
		self.fight.entityManager:CallBehaviorFun("RemoveEntitySign", self.instanceId, sign)
	end
end

function Entity:RemoveAllEntitySign()
	if not self.stateSigns then return end 
	for sign, stateSign in pairs(self.stateSigns) do
		self:RemoveSignState(sign)
	end
end

function Entity:AddEntitySignRecord(fromType, sign, lastFrame, ignoreTimeScale)
	if not self.entitySignRecord[fromType] then
		self.entitySignRecord[fromType] = {}
	end
	if not self.entitySignRecord[fromType][sign] then
		self.entitySignRecord[fromType][sign] = {}
	end
	self.entitySignRecord[fromType][sign].lastFrame = lastFrame
	self.entitySignRecord[fromType][sign].ignoreTimeScale = ignoreTimeScale
end

function Entity:AddEntityMagicRecord(fromType, magicId, lev)
	if not self.entityMagicRecord[fromType] then
		self.entityMagicRecord[fromType] = {}
	end
	self.entityMagicRecord[fromType][magicId] = lev
end

function Entity:RemoveEntitySignRecord(fromType, sign)
	if not self.entitySignRecord[fromType] then
		return 
	end
	self.entitySignRecord[fromType][sign] = nil
end

function Entity:RemoveEntityMagicRecord(fromType, magicId)
	if not self.entityMagicRecord[fromType] then
		return 
	end
	self.entityMagicRecord[fromType][magicId] = nil
end

function Entity:AddEntitySignAndMagicRecord()
	if not self.entitySignRecord then return end
	
	for fromType, v in pairs(self.entitySignRecord) do
		for sign, values in pairs(v) do
			--加回去
			self:AddSignState(sign, values.lastFrame, values.ignoreTimeScale)
		end
	end

	if not self.entityMagicRecord then return end

	for fromType, v in pairs(self.entityMagicRecord) do
		for magicId, lev in pairs(v) do
			if self.buffComponent then
				self.buffComponent:AddBuff(self, magicId, lev, nil, fromType)
			end
		end
	end
end

function Entity:HasSignState(sign)
	local stateSign = self.stateSigns[sign]
	if not stateSign then
		return false
	else
		if stateSign:IsValid() then
			return true
		else
			return false
		end
	end
end

function Entity:AddInteractItem(type, icon, text, quality, count)
	if not self.interactItemState then
		return
	end

	local interactCfg = Config.InteractConfig.InteractStateCfg[type] or {}

	self.interactId = self.interactId + 1
	self.interactItem[self.interactId] = true
	self.entityManager:AddTriggerEntityInteract(self.instanceId, self.interactId, type, icon, text, quality, count)
	EventMgr.Instance:Fire(EventName.ActiveWorldInteract, type, icon, text, quality, count, self.interactId, self.instanceId)
	for k, fun in pairs(interactCfg) do
        if fun() == true then
			self:HideInteractItem(self.interactId, 1)
			self.entityManager:ChangeTriggerEntityInteractState(self.instanceId, self.interactId, false)
        end
    end
	return self.interactId
end

function Entity:HideInteractItem(interactId, type)
	if not self.interactItem[interactId] then
		return
	end
	self.triggerHideType[interactId] = self.triggerHideType[interactId] or {}
	self.triggerHideType[interactId][type] = true
	if TableUtils.GetTabelLen(self.triggerHideType[interactId]) > 1 then
		return
	end
	EventMgr.Instance:Fire(EventName.HideWorldInteract, self.instanceId, interactId)
end

-- TODO 临时修改 射线检测到不能显示
function Entity:ShowInteractItem(interactId, type)
	if self.triggerComponent and (self.triggerComponent.blockEntities and next(self.triggerComponent.blockEntities)) then
		return
	end

	if not self.interactItem[interactId] then
		return
	end
	self.triggerHideType[interactId] = self.triggerHideType[interactId] or {}
	self.triggerHideType[interactId][type] = nil
	if TableUtils.GetTabelLen(self.triggerHideType[interactId]) > 0 then
		return
	end
	EventMgr.Instance:Fire(EventName.ShowWorldInteract, self.instanceId, interactId)
end

function Entity:RemoveInteractItem(interactId)
	if not self.interactItem[interactId] then
		return
	end

	self.interactItem[interactId] = nil
	self.triggerHideType[interactId] = nil
	self.entityManager:RemoveTriggerEntityInteract(self.instanceId, interactId)
	EventMgr.Instance:Fire(EventName.RemoveWorldInteract, self.instanceId, interactId)
end

function Entity:SetWorldInteractState(state)
	self.interactItemState = state
	if not self.interactItemState then
		for k, v in pairs(self.interactItem) do
			self:RemoveInteractItem(k)
		end
	end
end

function Entity:GetInteractId()
	return self.interactId
end

function Entity:GetInteractItem()
	return self.interactItem
end

function Entity:GetInteractItemState()
	return self.interactItemState
end

function Entity:AddMagicParams(id, level, params)
	if not self.magicParams[id] then
		self.magicParams[id] = {}
	end

	if not self.magicParams[id][level] then
		self.magicParams[id][level] = {}
		local temp = self.magicParams[id][level]
		for k, v in pairs(params) do
			temp[k] = v
		end
		temp.count = 1
	else
		self.magicParams[id][level].count = self.magicParams[id][level].count + 1
	end
end

function Entity:RemoveMagicParams(id, level)
	if not self.magicParams[id] then
		return
	end

	if not self.magicParams[id][level] then
		return
	end
	self.magicParams[id][level].count = self.magicParams[id][level].count - 1
	if self.magicParams[id][level].count == 0 then
		self.magicParams[id][level] = nil
	end
end

function Entity:GetMagicParams(id, level, index)
	if not self.magicParams[id] or not next(self.magicParams[id]) then
		return LogError("未添加buff，不能获取其参数", id)
	end
	if not level then
		local k = next(self.magicParams[id])
		return self.magicParams[id][k][index]
	end

	if not self.magicParams[id][level] then
		return
	end

	return self.magicParams[id][level][index]
end

function Entity:SetDefaultSkillLevel(level)
	self.defaultSkillLevel = level
	--LogError("Set", self.entityId, self.defaultSkillLevel)
end

function Entity:GetDefaultSkillLevel()
	--LogError("Get", self.entityId, self.defaultSkillLevel)
	return self.defaultSkillLevel
end

function Entity:SetDefaultSkillType(skillType)
	if skillType and skillType ~= 0 then
		self.defaultSkillType = skillType
		if self.attackComponent then
			self.attackComponent:SetSkillType(skillType)
		end
	end
end

function Entity:GetDefaultSkillType(type)
	return self.defaultSkillType
end

--------------- 月灵缔结
function Entity:DoConcludeBuffState()
	local npcTag = self.tagComponent.npcTag
	if npcTag ~= FightEnum.EntityNpcTag.Monster and npcTag ~= FightEnum.EntityNpcTag.Boss then
		return
	end
	return true
end

function Entity:AddConcludeBuffState(buffId, buffLv, calcHpPrecent)
	if not self:DoConcludeBuffState() then return end
	local buffConfig = PartnerConfig.GetPartnerBuffCfg(buffLv)
	if not buffConfig then return end
	-- 计算概率，在后端没有返回最新的记录前使用前端计算的概率
	local itemId = buffConfig.correlation_item
	local conclude_item_cfg = PartnerConfig.GetPartnerBallCfg(itemId)
	if not conclude_item_cfg then return end

	local monsterCatchProb = conclude_item_cfg.monster_catch_prob
	local eliteCatchProb = conclude_item_cfg.elite_catch_prob
	local bossCatchProb = conclude_item_cfg.boss_catch_prob

	local tag = self.tagComponent.npcTag
	local precent = 0

	if tag == FightEnum.MonsterTypeId.Monster then
		precent = monsterCatchProb
	elseif tag == FightEnum.MonsterTypeId.Elite then
		precent = eliteCatchProb
	elseif tag == FightEnum.MonsterTypeId.Boss then
		precent = bossCatchProb
	end

	self.concludeBuffData = {
		buffId = buffId,
		buffLv = buffLv,
		precent = precent,
		AddPrecent = 0
	}
	self:UpdateLifebarConcludePrecent()
end

function Entity:UpdateCatchPrecent(precent)
	if not self:DoConcludeBuffState() then return end
	if not self.concludeBuffData then return end

	self.concludeBuffData.AddPrecent = precent - self.concludeBuffData.precent
	self.concludeBuffData.precent = precent
	self:UpdateLifebarConcludePrecent()
end

function Entity:RemoveConcludeBuffState()
	self.concludeBuffData  = nil
	Fight.Instance.partnerManager:ClearConcludeData(self.sInstanceId)
	self:UpdateLifebarConcludePrecent()
end

function Entity:CheckConcludeBuffState()
	if not self:DoConcludeBuffState() then return end
	return self.concludeBuffData
end

function Entity:GetConcludeBuffState()
	return self.concludeBuffData
end

function Entity:UpdateLifebarConcludePrecent()
	if not self.clientEntity.clientLifeBarComponent then
		return
	end
	self.clientEntity.clientLifeBarComponent:UpdateLifebarConcludePrecent()
end

function Entity:UpdateConcludeElementBreakState(isEnd)
	self.concludeElementBreak = not isEnd
end

function Entity:IsConcludeElementBreakState()
	return self.concludeElementBreak
end

function Entity:ElementBreakAddConcludeBuff(buffId, buffLv)
	self:AddConcludeBuffState(buffId, buffLv, true)
end