---@type Entity
Entity = BaseClass("Entity",PoolBaseClass)
local componentType = FightEnum.ComponentType
function Entity:__init()
	self.components = {}
	self.owner = nil
	self.child = {}
	self.childInstance = {}
	self.values = {}
end

function Entity:Init(fight,instanceId,entityId, sInstanceId, params)
	self.fight = fight
	self.entityManager = fight.entityManager
	self.instanceId = instanceId
	self.sInstanceId = sInstanceId
	self.entityId = entityId
	self.config = EntityConfig.GetEntity(entityId)

	if self.owner and next(self.owner) then
		self.owner:AddChild(self)
	end
	
	self.trigger = {}
	self.triggerArea = {}

	self.params = params

	self.updateComponentEnable = true
end

-- 初始化组件
function Entity:InitComponents()
	if self.behaviorComponent then
		self.behaviorComponent:Init(self.fight,self)
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
			UnityUtils.BeginSample("LateInitComponents_"..component.__className)
			component:LateInit()
			UnityUtils.EndSample()
		end
	end

	if self.timeComponent then
		self.timeComponent:LateInit()
	end
	
	--behavior在这里操作数据了，得放到所有都初始化完再初始化
	if self.behaviorComponent and self.behaviorComponent.LateInit then
		self.behaviorComponent:LateInit()
	end
end

function Entity:BeforeUpdate()
	self:UpdateComponentLodInfo()
	if not self.updateComponentEnable then
		return
	end

	--TODO
	if self.behaviorComponent then
		self:BeforeUpdateComponent("behaviorComponent")
	end

	if not self.stateComponent or 
		self.stateComponent.backstage ~= FightEnum.Backstage.Background then
		if self.moveComponent then
			self:BeforeUpdateComponent("moveComponent")
		end
	end
end

function Entity:Update()
	if not self.updateComponentEnable then
		self:StartEntitySample()
		-- 移动和旋转，每帧跑
		if self.stateComponent then
			self:UpdateComponent("stateComponent")
		end
		if self.rotateComponent then
			self:UpdateComponent("rotateComponent")
		end
		self:EndEntitySample()
		return
	end

	self:StartEntitySample()
	if self.behaviorComponent then
		if self.buffComponent then
			if not self.buffComponent:CheckState(FightEnum.EntityBuffState.PauseBehavior) then
				self:UpdateComponent("behaviorComponent")
			end
		else
			self:UpdateComponent("behaviorComponent")
		end
	end
	
	if self.buffComponent then
		self:UpdateComponent("buffComponent")
	end

	if self.customFSMComponent then
		self:UpdateComponent("customFSMComponent")
	end

	if not self.stateComponent or 
		self.stateComponent.backstage == FightEnum.Backstage.Foreground then
		self:UpdateForeGroundComp()
	elseif self.stateComponent.backstage == FightEnum.Backstage.Combination then
		self:UpdateCombineGroundComp()
	else
		if self.skillSetComponent then
			self.skillSetComponent:UpdateIgnoreTimeScale()
		end
	end

	self:EndEntitySample()
end

function Entity:AfterUpdate()
	if not self.updateComponentEnable then
		return
	end

	--TODO
	if self.attrComponent then
		self:AfterUpdateComponent("attrComponent")
	end

	if self.behaviorComponent then
		self:AfterUpdateComponent("behaviorComponent")
	end

	if self.timeoutDeathComponent then
		self:AfterUpdateComponent("timeoutDeathComponent")
	end

	if not self.stateComponent or 
		self.stateComponent.backstage ~= FightEnum.Backstage.Background then
		if self.swimComponent then
			self:AfterUpdateComponent("swimComponent")
		end
		if self.rotateComponent then
			self:AfterUpdateComponent("rotateComponent")
		end
		UnityUtils.BeginSample("moveComponent AfterUpdate")
		if self.moveComponent then
			self:AfterUpdateComponent("moveComponent")
		end
		UnityUtils.EndSample()
		if self.climbComponent then
			self:AfterUpdateComponent("climbComponent")
		end
	elseif self.stateComponent.backstage == FightEnum.Backstage.Background then
		self.moveComponent:SetForcePositionOffset(0, 0, 0)
	end

	if self.componentLodInfo then
		self.componentLodInfo.UpdateFrame = self.fight.fightFrame + self.componentLodInfo.IntevalFrame
	end
end

function Entity:BeforeUpdateComponent(componentName)
	if self.componentLodInfo and 
		not self.componentLodInfo.UpdateComponents[componentName] then
		return
	end

	self[componentName]:BeforeUpdate()
end

function Entity:UpdateComponent(componentName)
	if self.componentLodInfo and 
		not self.componentLodInfo.UpdateComponents[componentName] then
		return
	end

	self:StartEntitySample(componentName)
	self[componentName]:Update()
	self:EndEntitySample()
end

function Entity:AfterUpdateComponent(componentName)
	if self.componentLodInfo and 
		not self.componentLodInfo.UpdateComponents[componentName] then
		return
	end

	self[componentName]:AfterUpdate()
end

function Entity:UpdateForeGroundComp()
	if self.swimComponent then
		self:UpdateComponent("swimComponent")
	end

	if self.moveComponent then
		self:UpdateComponent("moveComponent")
	end
	if self.skillComponent then
		self.skillComponent:UpdateIgnoreTimeScale()
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
		if not self.timeComponent:TryUpdate() then 
			return 
		end
	end
	
	for i = 1, componentType.Lenght do
		local component = self.components[i]
		if self.instanceId == 0 then return end
		if component and component.Update then
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

function Entity:UpdateCombineGroundComp()
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
		if not self.timeComponent:TryUpdate() then 
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
	if self.behaviorComponent then
		UnityUtils.BeginSample("Entity:CallBehaviorFun".. funName)
		self.behaviorComponent:CallFunc(funName, ...)
		UnityUtils.EndSample()
	end
end

function Entity:__cache()
	if self.behaviorComponent then
		self.behaviorComponent:OnCache()
		self.behaviorComponent = nil
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
	if self.timeComponent then
		self.timeComponent:OnCache()
		self.timeComponent = nil
	end
	if self.buffComponent then
		self.buffComponent:OnCache()
		self.buffComponent = nil
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

	if self.owner then
		self.owner:RemoveChild(self)
	end

	TableUtils.ClearTable(self.components)
	--self.components = {}
	self.instanceId = 0
	self.entityId = 0
	self.sInstanceId = nil
	self.fight = nil
	self.owner = nil
	--self.child = {}
	TableUtils.ClearTable(self.child)
	--self.childInstance = {}
	TableUtils.ClearTable(self.childInstance)
	TableUtils.ClearTable(self.values)
	
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
	local configName = FightEnum.ComponentConfigName[componentType]
	return self.config.Components[configName]
end

function Entity:OnSwitchPlayerCtrl()
	if self.clientEntity.clientIkComponent then
		self.clientEntity.clientIkComponent:OnSwitchPlayerCtrl()
	end
end

function Entity:Revive(isTransport, reviveLife)
	if not self.stateComponent or not self.stateComponent:IsState(FightEnum.EntityState.Death) then
		return
	end

	self.stateComponent:SetState(FightEnum.EntityState.Revive, isTransport, reviveLife)
end

function Entity:__delete()
	if not self.entityManager.removing then
		if self.child and next(self.child) then
			for i = #self.child, 1, -1 do
				self.entityManager:RemoveEntity(self.child[i].instanceId, true)
			end
		end

		if self.owner then
			self.owner:RemoveChild(self)
		end
	end

	self.instanceId = 0
	self.entityId = 0
	self.fight = nil

	for k,v in pairs(self.components) do
		if v.DeleteMe then
			v:DeleteMe()
		end
	end
	self.components = nil
end

function Entity:StartEntitySample(name)
	local s = "entity"..self.entityId
	if name then
		s = s.."_"..name
	end
	UnityUtils.BeginSample(s)
end

function Entity:EndEntitySample()
	UnityUtils.EndSample()
end

function Entity:SetDeadTransport()
	local lifeType = EntityAttrsConfig.AttrType.Life
	self.attrComponent:SetValue(lifeType, 0, FightEnum.AttrGroupType.Additvie)
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
	for _, v in pairs(FightEnum.TriggerType) do
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
	for _, v in pairs(FightEnum.TriggerType) do
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
	self.fight.levelManager:CallBehaviorFun("EnterArea", self.instanceId, areaName, logicName)
	self.fight.taskManager:CallBehaviorFun("EnterArea", self.instanceId, areaName, logicName)

	EventMgr.Instance:Fire(EventName.EnterLogicArea, self.instanceId, areaName, logicName)
end

function Entity:TriggerExitArea(areaName, logicName)
	if self.triggerArea[areaName] then
		self.triggerArea[areaName][logicName] = nil
		self.fight.levelManager:CallBehaviorFun("ExitArea", self.instanceId, areaName, logicName)
		self.fight.taskManager:CallBehaviorFun("ExitArea", self.instanceId, areaName, logicName)

		EventMgr.Instance:Fire(EventName.ExitLogicArea, self.instanceId, areaName, logicName)
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
	if (self.entityId > 8000001 and self.entityId < 8999999) or
		(self.entityId > 2000001 and self.entityId < 2999999 and self.entityId ~= 2030502 and self.entityId ~= 2030501
				and self.entityId ~= 2030503 and self.entityId ~= 2030504) then
		-- todo 转成LOD配置导出
		self.componentLodList = {
			[1] = {
				Lod = 1,
				Distance = 10,
				IntevalFrame = 8,
				UpdateComponents = {
					["behaviorComponent"] = true,
					["commonBehaviorComponent"] = true,
					["stateComponent"] = true,
					["rotateComponent"] = true,
				}
			}
		}
	end
end

function Entity:UpdateComponentLodInfo()
	if not self.componentLodList then
		return
	end

	local entity = self.fight.playerManager:GetPlayer():GetCtrlEntityObject()
	local distance = self.transformComponent:GetDistanceFromTarget(entity, true)

	for k, v in ipairs(self.componentLodList) do
		if v.Distance < distance then
			if not self.componentLodInfo or self.componentLodInfo.Lod ~= v.Lod then 
				self.componentLodInfo = v
				self.componentLodInfo.UpdateFrame = 0
			end
			self.transformComponent:Async()
			if self.triggerComponent then
				self.triggerComponent:Update()
			end
			self.updateComponentEnable = self.componentLodInfo.UpdateFrame < self.fight.fightFrame
			self.componentLodInfo.debugShowDistance = distance --仅调试用，去掉不影响
			return
		end
	end

	self.componentLodInfo = nil
	self.updateComponentEnable = true
end

function Entity:IsTpEntity()
	local tpConfig = self:GetComponentConfig(FightEnum.ComponentType.Tp)
	if not tpConfig then return false end
	return true
end