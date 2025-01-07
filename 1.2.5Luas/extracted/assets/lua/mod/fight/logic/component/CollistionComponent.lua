---@class CollistionComponent
CollistionComponent = BaseClass("CollistionComponent",PoolBaseClass)

local StepCheck = 0.5 -- 分步查询的单步长度
local collisionOffset = 0.05 --跟碰撞盒多近就算碰撞了
local ForceHeight = 3 --至少检测3米高度
local DirectionFixAngle = 0 --角度内方向修正为原位移方向

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

	self.radius = self.config.CollisionRadius or self.config.Radius
	self.height = self.config.Height
	
	self.extend = nil
	self.boneFollow = nil
	
	--debug
	self.debugDraw = false
end

function CollistionComponent:LateInit()
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
			self.boneFollow = self.entity.clientEntity.clientTransformComponent:GetTransform(part.config.FollowBone)
		end

		self.colliderData = part.colliderList[1]
		self.radius = self.colliderData.radius
		self.height = self.colliderData.height * 2

		local offset = self.colliderData.offset
		self.offset = Vec3.New(offset.x, offset.y, offset.z)

		EventMgr.Instance:AddListener(EventName.OnPlayAnimation, self:ToFunc("OnPlayAnimation"))
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
	
	self.rootTransform = self.entity.clientEntity.clientTransformComponent:GetTransform()
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

function CollistionComponent:OnPlayAnimation(instanceId, stateName, animName)
	if self.entity.instanceId ~= instanceId then
		return 
	end
	
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
	if not self.colliderData or not self.colliderData.colliderObj then
		return 
	end
	
	if not UtilsBase.IsNull(self.boneFollow) then
		local pos = self.boneFollow.position
		UnityUtils.SetPosition(self.colliderData.colliderTransform, pos.x, pos.y, pos.z)
	end
	
	local rotate = self.rootTransform.rotation
	if self.rotateFollow and not UtilsBase.IsNull(self.boneFollow) then
		rotate = self.boneFollow.rotation
	end
	UnityUtils.SetRotation(self.colliderData.colliderTransform, rotate.x, rotate.y, rotate.z, rotate.w)
end

function CollistionComponent:SetCollisionLayer(layer)
	self.layer = layer
	for k, v in pairs(self.parts) do
		v:SetCollisionLayer(layer)
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
	
	if self.forecastCollisionCmps[entity.collistionComponent] then
		return 
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
	
	--权重高也进行检测，因为高速移动带来的穿模，需要把信息传给低权重
	local myPriority = self.config.Priority
	local colPriority = entity.collistionComponent.config.Priority
	if myPriority > colPriority and not self.entity.stateComponent:IsState(FightEnum.EntityState.Skill) then
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

	if self.collisionCheckType == FightEnum.CollisionCheckType.TerrainOnly then
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
					--if self.config.Priority > entity.collistionComponent.config.Priority then
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
			--k.entity.clientEntity.clientTransformComponent:Async()
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
	self:SetCollisionLayer(FightEnum.Layer.IgonreRayCastLayer)
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
	self.entity.clientEntity.clientTransformComponent:Async()
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
		collistionCpm.entity.clientEntity.clientTransformComponent:Async()
	end
	
	local collision, x, y, z = self.extend:CalculateVector(idx, curOffset, self.config.Priority - collistionCpm.config.Priority)
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
	
	self.boneFollow = nil
	self.colliderData = nil

	EventMgr.Instance:RemoveListener(EventName.OnPlayAnimation, self:ToFunc("OnPlayAnimation"))
	self.fight.objectPool:Cache(CollistionComponent,self)
end

function CollistionComponent:__delete()
	EventMgr.Instance:RemoveListener(EventName.OnPlayAnimation, self:ToFunc("OnPlayAnimation"))
	
	if self.parts then
		for k, v in ipairs(self.parts) do
			if v.DeleteMe then
				v:DeleteMe()
			end
		end
		
		TableUtils.ClearTable(self.parts)
	end
end

function CollistionComponent:ChangeCollistionHeight(height)
	self.height = height
end

function CollistionComponent:ChangeCollistionRadius(radius)
	self.radius = radius
end