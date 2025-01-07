---@class CollistionComponent
CollistionComponent = BaseClass("CollistionComponent",PoolBaseClass)
local EntityCollisionLayer = FightEnum.Layer.EntityCollision

local StepCheck = 0.5 -- 分步查询的单步长度
local collisionOffset = 0.05 --跟碰撞盒多近就算碰撞了
local ForceHeight = 3 --至少检测3米高度
local DirectionFixAngle = 0 --角度内方向修正为原位移方向

local CrashEffect = 204080207
local SmokehEffect = 204080208


local RotateFollowAnim = {
	["HitDown"] = true,
	["Lie"] = true,
	["StandUp"] = true,
	["HitFlyUp"] = true,
	["HitFlyFall"] = true,
	["HitFlyLand"] = true,
}

function CollistionComponent:__init()
	self.parts = {}
	self.forecastCollisionCmps = {}
	
    self.potEntities = {}	--被设置了渲染层优先的实体
end

function CollistionComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.transformComponent = entity.transformComponent
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Collision)
	self.collisionCheckType = self.config.CollisionCheckType or FightEnum.CollisionCheckType.Normal
	self.fixAngle = self.config.FixAngle
	self.colliderData = nil
	self.layer = FightEnum.Layer.EntityCollision
	self.priority = self.config.Priority

	self.checkTagFlags = self.config.CheckTagFlags or -1
	self.beCheckTagFlags = self.config.BeCheckTagFlags or -1
	self.worldRadius = self.config.Radius
	self.radius = self.config.CollisionRadius or self.config.Radius
	self.height = self.config.Height >= 2 * self.radius and self.config.Height or 2 * self.radius
	self.offsetY = self.config.offsetY
	
	self.extend = nil
	self.boneFollow = nil
	
	--debug
	self.debugDraw = false
	
	EventMgr.Instance:AddListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
end

function CollistionComponent:LateInit()
	--do return end
	if self.entity.partComponent then--碰撞和部位合并后,兼容只有碰撞的情况
		return
	end
	
	self.gameObject = self.entity.clientTransformComponent:GetGameObject()

	if self.config.PartList then
		for k, v in ipairs(self.config.PartList) do
			local part = self.fight.objectPool:Get(ColliderPart)
			part:Init(self.fight, self.entity, v)
			table.insert(self.parts, part)
		end
	end
	
	local getPartConfig = false
	local part = self:GetCollisionPart()
	if part then
		if part.colliderFollow == FightEnum.ColliderFollow.PositionOnly then
			self.boneFollow = self.entity.clientTransformComponent:GetTransform(part.config.FollowBone)
		end

		self.colliderData = part.colliderList[1]
		self.radius = self.colliderData.radius
		self.height = self.colliderData.height * 2

		local offset = self.colliderData.offset
		self.offset = Vec3.New(offset.x, offset.y, offset.z)
		local rotation = self.colliderData:GetRotation()
		if self.boneFollow then
			self.boneFollowInitRotation = self.boneFollow.rotation
		end
		self.rotation = Quat.New(rotation.x, rotation.y, rotation.z, rotation.w):ToEulerAngles()
		getPartConfig = true
	end
	
	if not getPartConfig then
		self.radius = self.config.CollisionRadius or self.config.Radius
		self.height = self.config.Height
		
		local x = self.config.offsetX or 0
		local y = self.config.offsetY or 0
		local z = self.config.offsetZ or 0
		self.offset = Vec3.New(x, y, z)
	end
	
	self.rootTransform = self.entity.clientTransformComponent:GetTransform()
	self.extend = self.rootTransform:GetComponent(CollisionExtend)
	if not self.extend then
		self.extend = self.rootTransform.gameObject:AddComponent(CollisionExtend)
	end
	self.extend:Init(self.radius, self.height, self.offset, self.colliderData and self.colliderData.colliderCmp or nil)
end

function CollistionComponent:GetCollisionPart()
	if #self.parts == 0 then
		return 
	end

	if #self.parts == 1 then
		return self.parts[1]
	end
	
	for k, v in pairs(self.parts) do
		if v.colliderFollow == FightEnum.ColliderFollow.PositionOnly then
			return v
		end
	end
end

function CollistionComponent:OnPlayAnimation(stateName, animName)
	self.rotateFollow = RotateFollowAnim[animName]
end

function CollistionComponent:GetPart(partName)
	if not partName or partName == "" then
		return self.parts[1]
	end

	for k, v in pairs(self.parts) do
		if v.partName and v.partName == partName then
			return v
		end
	end
end

--以cmp为单位，那多部位的基本就是错误的
function CollistionComponent:SetForecastCollision(offset, move, cmp)
	self.forecastCollisionCmps[cmp] = {offset, move}
end

local DrawEnable = false
local DrawColor = Color(0, 0, 1, 0.5)
function CollistionComponent:Update()
	if DebugClientInvoke.Cache.ShowCollider or self.debugDraw then
		for k, v in ipairs(self.parts) do
			--v:UpdateCollisionListTransfrom()
			v:Draw(DrawColor, DebugClientInvoke.Cache.ShowCollider)
		end
		
		self.debugDraw = DebugClientInvoke.Cache.ShowCollider
	end
	
	
	for k, v in ipairs(self.parts) do
		v:Update()
	end
	self:UpdatePresentationOnlyTrigger()
	if not self.boneFollow or not self.colliderData or not self.colliderData.colliderObj then
		return 
	end

	if not UtilsBase.IsNull(self.boneFollow) then
		local pos = self.boneFollow.position
		UnityUtils.SetPosition(self.colliderData.colliderTransform, pos.x, pos.y, pos.z)
	end

	if self.rotateFollow and not UtilsBase.IsNull(self.boneFollow) then
		local rotate = self.boneFollow.rotation * Quaternion.Inverse(self.boneFollowInitRotation)
		UnityUtils.SetRotation(self.colliderData.colliderTransform, rotate.x, rotate.y, rotate.z, rotate.w)
	else
		if self.boneFollow then
			self.boneFollowInitRotation = self.boneFollow.rotation
		end
		UnityUtils.SetLocalEulerAngles(self.colliderData.colliderTransform, self.rotation.x, self.rotation.y, self.rotation.z)
	end
end

function CollistionComponent:UpdatePresentationOnlyTrigger()

	if self.PresentationOnlyTrigger and self.crashBox then
		local entityManager = self.fight.entityManager

		for k, v in pairs(self.potEntities) do
			self.potEntities[k] = false
		end

		local newPotEntities = {}
		for i, v in ipairs(self.crashBox.colliderList) do
			local id = v.colliderObjInsId
			local triggerData = self.entity:GetTriggerData(FightEnum.TriggerType.Collision, id)
			if triggerData then
				for colliderInsId, layer in pairs(triggerData) do
					if layer == EntityCollisionLayer then
						local entity = entityManager:GetColliderEntity(colliderInsId)
						if entity and entity.instanceId ~= BehaviorFunctions.GetCtrlEntity() and entity.tagComponent and entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Car then
							if self.potEntities[entity.instanceId] == nil then
								newPotEntities[entity.instanceId] = true
							end
							self.potEntities[entity.instanceId] = true

						end
					end
				end
			end
		end

		
		local trafficMode = BehaviorFunctions.GetTrafficMode()
		
		for k, v in pairs(newPotEntities) do
			
			local entity = entityManager:GetEntity(k)

			if trafficMode == FightEnum.TrafficMode.Normal then

				EventMgr.Instance:Fire(EventName.CrashCar, entity.instanceId)
				
			else
				BehaviorFunctions.SetEntityTranslucentV2(k,0.5,1000,0.5)
			end
			
		end

		for k, v in pairs(self.potEntities) do
			local entity = entityManager:GetEntity(k)
			if entity then
				if not v then

					if trafficMode == FightEnum.TrafficMode.Normal then
						-- 暂时不在这里恢复pto状态，等待实体回收
						--self:SetEntityPto(entity,false)
					else
		
						BehaviorFunctions.SetEntityTranslucentV2(k,0,1,0.5)
					end
					self.potEntities[k] = nil
				end
			else
				self.potEntities[k] = nil
			end
		end

		if trafficMode == FightEnum.TrafficMode.Safe then
			if TableUtils.GetTabelLen(self.potEntities) > 0 then
				BehaviorFunctions.SetEntityTranslucentV2(self.entity.instanceId ,0.5,1000,0.5)
			else
				BehaviorFunctions.SetEntityTranslucentV2(self.entity.instanceId ,0,1,0.5)
			end
		end
		
	end
	
end

function CollistionComponent:OnEnterTriggerLayer(instanceId, layer,enterInsId,objInsId,vecter3)
	if instanceId == self.entity.instanceId  then
		if self.crashBoxInsId and self.crashBoxInsId == objInsId  then
			if not enterInsId or enterInsId ~= BehaviorFunctions.GetCtrlEntity() then
				local canShow = true
				if enterInsId then
					local entity = self.fight.entityManager:GetEntity(enterInsId)
					local trafficMode = BehaviorFunctions.GetTrafficMode()
					if entity and entity.tagComponent and entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Car and trafficMode == FightEnum.TrafficMode.Safe then
						canShow = false
					end
				end
				if canShow then
					--self:PlayCarCrashEffect(vecter3)
				end
			end
		end
	end
end
function CollistionComponent:PlayCarCrashEffect(Vec3)
	if Vec3 then
		local crashEffect = BehaviorFunctions.CreateEntity(CrashEffect, nil,Vec3.x,Vec3.y,Vec3.z)
		self.entity:LifeBindEntity(crashEffect)

		--[[ 烟雾特效暂时关了
		if not self.smokehEffect then
			self.smokehEffect = BehaviorFunctions.CreateEntity(SmokehEffect, self.entity.instanceId)
			self.entity:LifeBindEntity(self.smokehEffect)
		end
		]]

		
		SoundManager.Instance:PlayObjectSound("Drive_Crash", self.gameObject)
	end
	
end

function CollistionComponent:CameraShake()
	--BehaviorFunctions.DoMagic(1000,self.entity.instanceId,100002202)
	BehaviorFunctions.AddBuff(1,self.entity.instanceId,1000011)
	BehaviorFunctions.AddBuff(1,self.entity.instanceId,1000022)
	BehaviorFunctions.AddBuff(1,self.entity.instanceId,1000012)
end

-- 开启交通撞击能力，重叠透明/设置被撞击
function CollistionComponent:SetPresentationOnlyTrigger(isOn)
	self.PresentationOnlyTrigger = isOn
	local trafficMode = BehaviorFunctions.GetTrafficMode()
	if isOn then
		-- 取消安全驾驶时与车辆层的碰撞
		if trafficMode == FightEnum.TrafficMode.Safe then
			local invoke = self.entity.clientTransformComponent.gameObject:GetComponent(TCCAInvoke)
			invoke:AddBodyExcludeLayer(FightEnum.LayerBit.CarBody)
		end
		
		self:EnableCrashBox(true)
	else
		if trafficMode == FightEnum.TrafficMode.Safe then
			local invoke = self.entity.clientTransformComponent.gameObject:GetComponent(TCCAInvoke)
			invoke:ResetBodyExcludeLayer()
		end
	end
end
-- 开启CrashBox
function CollistionComponent:EnableCrashBox(isOn)
	do 
		return
	end
	if isOn then
		self.crashBox = self.crashBox or self:GetPart("CrashBox")
		if UtilsBase.IsNull(self.crashBox) then
			LogError("遇到这个LOG 上报给一程 entityId = "..self.entity.entityId)
			return
		end
		
		for k, v in pairs(self.parts) do
			if v ~= self.crashBox then
				v:SetPartEnable(false)
			end
		end
		
		self.crashBoxInsId = self.crashBox.colliderList[1].colliderObjInsId
		if self.crashBox then
			-- 实体碰撞和default碰撞
			self.crashBox:SetTriggerComponent(FightEnum.TriggerType.Collision,FightEnum.LayerBit.EntityCollision | FightEnum.LayerBit.Default, true)
			self.crashBox:SetPartEnable(true)
			self.crashBox:GetRigidBody()
		end
	else
		for k, v in pairs(self.parts) do
			if v ~= self.crashBox then
				v:SetPartEnable(true)
			end
		end
		self.crashBoxInsId = nil
		if self.crashBox then
			self.crashBox:SetPartEnable(false)
			self.crashBox = nil
		end
	end
end
function CollistionComponent:SetCollisionLayer(layer)
	self.layer = layer
	for k, v in pairs(self.parts) do
		v:SetCollisionLayer(layer)
	end
end

function CollistionComponent:SetCollisionEnable(enable)
	self.enable = enable
	for k, v in pairs(self.parts) do
		v:SetCollisionEnable(enable)
	end
end

function CollistionComponent:CheckCollider(colliderInsId)
	if not self.colliderData then
		return true
	end

	return self.colliderData.colliderObjInsId == colliderInsId and self.colliderData.colliderCmp.enabled
end

function CollistionComponent:CheckCollisionValid(entity, colliderInsId)
	if not entity or not entity.collistionComponent then
		return false
	end
	
	if (1 << entity.tagComponent.npcTag) & self.checkTagFlags == 0 then
		return false
	end
	
	if (1 << self.entity.tagComponent.npcTag) & entity.collistionComponent.beCheckTagFlags == 0 then
		return false
	end
	
	if entity.collistionComponent.collisionCheckType == FightEnum.CollisionCheckType.GenerateOnly then
		return false
	end
	
	if self.forecastCollisionCmps[entity.collistionComponent] then
		return false
	end

	if not entity.collistionComponent:CheckCollider(colliderInsId) then
		return false
	end

	if entity.stateComponent and entity.stateComponent.backstage ~= FightEnum.Backstage.Foreground then
		return false
	end

	if entity.buffComponent and entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneByCollision) then
		return false
	end
	
	local myPriority = self.priority
	local colPriority = entity.collistionComponent.priority
	if myPriority > colPriority and self.entity.stateComponent and 
		not self.entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
		return false
	end
	
	return true
end

function CollistionComponent:NeedCheck()
	if self.layer ~= FightEnum.Layer.EntityCollision then
		return false
	end
	
	if self.entity.stateComponent and self.entity.stateComponent.backstage == FightEnum.Backstage.Combination then
		return false
	end

	if self.collisionCheckType == FightEnum.CollisionCheckType.TerrainOnly or 
		self.collisionCheckType == FightEnum.CollisionCheckType.GenerateOnly then
		return false
	end

	if self.entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneToCollision) then
		return false
	end
	
	if self.colliderData and not self.colliderData.colliderCmp.enabled then
		return false
	end
	
	return true
end

local calcVec = Vec3.New()
function CollistionComponent:GetCollisionVector(count, curFrom, offset)
	offset = offset or Vec3.zero
	calcVec:Set()
	
	local touchCount = 0
	for j = 0, count - 1 do
		local instanceId, colliderInsId = self.extend:GetInstanceIdByIndex(j)
		if instanceId and instanceId ~= self.entity.instanceId then
			local entity = self.fight.entityManager:GetEntity(instanceId)
			if self:CheckCollisionValid(entity, colliderInsId) then
				local vector = self:CalcVector(curFrom, offset, j, entity.collistionComponent, true)
				if vector ~= Vec3.zero then
					--if self.priority > entity.collistionComponent.priority then
						----碰撞现场的数据，高权重高速移动时低权重大概率无法捕获到
						--entity.collistionComponent:SetForecastCollision(cols[j].transform.position - curFrom, offset, self)
					--else
						--calcVec:Add(vector)
						--touchCount = touchCount + 1
					--end
					
					calcVec:Add(vector)
					touchCount = touchCount + 1
				end
			end
		end
	end
	return calcVec, touchCount
end

function CollistionComponent:CalcCollisionOffset(newTo, height, fixAngle)
	--需要预计算的碰撞信息
	--for k, v in pairs(self.forecastCollisionCmps) do
		--local collider = k.colliderData and k.colliderData.colliderCmp
		--if collider then
			----提前同步的目的是让collider.transform.position准确，或者都不同步也是可以的
			--k.entity.clientTransformComponent:Async()
			----还原碰撞现场
			--local vector = self:CalcVector(collider.transform.position + v[1], -v[2], collider, k)
			--newTo = newTo + vector
		--end
	--end	
	
	if newTo == Vec3.zero then
		local count = self.extend:GetCollidingEntities(self.transformComponent.position, self.transformComponent.rotation,
			newTo)
		local vec, touch = self:GetCollisionVector(count, self.transformComponent.position)
		return vec
	else
		local len = Vec3.Magnitude(newTo) --移动总长
		local ceil = math.ceil(len / StepCheck) --分段段数
		local singlePercent = len > 0 and StepCheck / len or 0 --单段比例
		local singleVec = newTo * singlePercent --单段向量
		for i = 0, ceil - 1 do
			local curFrom = self.transformComponent.position + singleVec * i --当前步骤的初始位置
			local curOffset = (i + 1) * StepCheck > len and len - i * StepCheck or StepCheck --当前步骤的偏移量
			curOffset = newTo * (curOffset / len)

			local count = self.extend:GetCollidingEntities(curFrom, self.transformComponent.rotation, curOffset)
			local vec, touch = self:GetCollisionVector(count, curFrom, curOffset)
			if touch > 0 then
				vec = singleVec * i + curOffset + vec
				
				local angle = Vec3.AngleSigned(newTo, vec)
				if math.abs(angle) <= fixAngle then
					vec = Vec3.Project(vec, curOffset)
				end
				
				return vec
			end
		end
	end
	return newTo
end

function CollistionComponent:CheckCollistion(newTo)
	if not self:NeedCheck() then
		return newTo
	end
	
	UnityUtils.BeginSample("CollistionComponent:SetCollisionLayer")
	self:SetCollisionLayer(FightEnum.Layer.IgnoreRayCastLayer)
	UnityUtils.EndSample()
	
	local checkHeight = math.max(ForceHeight, self.height)
	local fixAngle = DirectionFixAngle
	if self.entity.stateComponent and self.entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
		local target = self.entity.skillComponent.target
		if target and target.collistionComponent then
			fixAngle = target.collistionComponent.fixAngle or fixAngle
		end
	end
	UnityUtils.BeginSample("CollistionComponent:Async")
	self.entity.clientTransformComponent:Async()
	UnityUtils.EndSample()
	
	UnityUtils.BeginSample("CollistionComponent:CalcCollisionOffset")
	newTo = self:CalcCollisionOffset(newTo, checkHeight, fixAngle)
	UnityUtils.EndSample()
	
	--pingpong问题分析并不准确
	--if newTo ~= Vec3.zero then
		--local foreastNewTo = self:CalcCollisionOffset(newTo, checkHeight, fixAngle)
		--if Vec3.Dot(newTo, foreastNewTo) < 0 then
			--newTo = newTo * 0.1
		--end
	--end
	
	TableUtils.ClearTable(self.forecastCollisionCmps)
	self:SetCollisionLayer(FightEnum.Layer.EntityCollision)
	return newTo
end

function CollistionComponent:CheckPush(myPriority, colPriority, colTransform)
	if myPriority ~= colPriority then
		return myPriority < colPriority
	end
	
	local colY = colTransform.position.y
	local myY = self.colliderData and self.colliderData.colliderTransform.position.y or
				self.entity.transformComponent.position.y + self.height * 0.5

	local halfColHeight = colTransform.localScale.y
	local halfMyHeight = self.colliderData and self.colliderData.colliderTransform.localScale.y or self.height * 0.5
	if halfColHeight + halfMyHeight >= math.abs(colY - myY) then
		return true
	end
	
	return false
end

local calcTo = Vec3.New()
function CollistionComponent:CalcVector(curFrom, curOffset, idx, collistionCpm, colAsync)
	if colAsync then
		collistionCpm.entity.clientTransformComponent:Async()
	end
	
	local collision, x, y, z = self.extend:CalculateVector(idx, curOffset, self.priority - collistionCpm.priority)
	if collision then
		self.fight.entityManager:CallBehaviorFun("OnEntityCollision", self.entity.instanceId, collistionCpm.entity.instanceId)
	end

	calcTo:Set(x, y, z)
	return calcTo
end

function CollistionComponent:GetDistance(from,to)
	local x1 = from.x
	local y1 = from.z
	local x2 = to.x
	local y2 = to.z
	return math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2))
end

function CollistionComponent:SphereCastObject(layer)
	local position = self.entity.transformComponent.position
	local heightCheck = self.height * 0.5
	return CS.PhysicsTerrain.GetSphereCastObject(position.x, position.y, position.z, self.radius, self.height, heightCheck, layer)	
end

function CollistionComponent:OnCache()
	for k, v in pairs(self.parts) do
		v:OnCache()
	end
	TableUtils.ClearTable(self.parts)
	TableUtils.ClearTable(self.forecastCollisionCmps)

	if TableUtils.GetTabelLen(self.potEntities) > 0 then
		for k, v in pairs(self.potEntities) do
			BehaviorFunctions.SetEntityTranslucentV2(k,0,1,0.5)
		end
	end
	TableUtils.ClearTable(self.potEntities)
	
	if self.isSetEntityPto then
		self:SetEntityPto(false)
	end
	if self.PresentationOnlyTrigger then
		self:SetPresentationOnlyTrigger(false)
	end
	
	
	self.boneFollow = nil
	self.colliderData = nil

	self.fight.objectPool:Cache(CollistionComponent,self)
	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
end

function CollistionComponent:__delete()
	if self.parts then
		for k, v in ipairs(self.parts) do
			if v.DeleteMe then
				v:DeleteMe()
			end
		end
		
		TableUtils.ClearTable(self.parts)
	end
	
	EventMgr.Instance:RemoveListener(EventName.EnterTriggerLayer, self:ToFunc("OnEnterTriggerLayer"))
end

function CollistionComponent:ChangeCollistionHeight(height)
	self.height = height
	self.extend:ChangeCollistionHeight(height)
	if self.colliderData then
		self.colliderData:UpdateColliderTransform(self.radius, self.height)
	end
end

function CollistionComponent:ChangeCollistionRadius(radius)
	self.radius = radius
	self.extend:ChangeCollistionRadius(radius)
	if self.colliderData then
		self.colliderData:UpdateColliderTransform(self.radius, self.height)
	end
end

function CollistionComponent:ChangeCollisionCheckTagFlags(reset, flags)
	if reset then
		self.checkTagFlags = self.config.CheckTagFlags or -1
		return
	end
	
	self.checkTagFlags = flags
end

function CollistionComponent:ChangeCollisionBeCheckTagFlags(reset, flags)
	if reset then
		self.beCheckTagFlags = self.config.BeCheckTagFlags or -1
		return
	end

	self.beCheckTagFlags = flags
end

function CollistionComponent:SetPriority(priority)
	priority = priority or self.config.Priority
	self.priority = priority
end