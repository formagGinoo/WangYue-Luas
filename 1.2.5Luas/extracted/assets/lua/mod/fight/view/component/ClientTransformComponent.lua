---@class ClientTransformComponent
ClientTransformComponent = BaseClass("ClientTransformComponent",PoolBaseClass)
local Vec3 = Vec3
local Quat = Quat

ClientTransformComponent.HideEffect = false

function ClientTransformComponent:__init()
	self.tag = FightEnum.EntityTag.None
	self.useRenderHeight = false
	self.hideBone = {}
	self.hideGroup = {}
	self.cacheTransform = {}
	self.cacheGroupTransform = {}
	self.weaponMap = {}
	self.eulerAngles = Vec3.New()
	self.lastPosition = Vec3.New()
	self.lastRotation = Quat.New()
end

function ClientTransformComponent:Bind(bindRotate,bindScale)

end

function ClientTransformComponent:SetActivity(activity)
	if self.gameObject.activeSelf ~= activity then
		self.gameObject:SetActive(activity)
		return true
	end
	return false
end

function ClientTransformComponent:UseRenderHeight(flag)
	self.useRenderHeight = flag
end

function ClientTransformComponent:GetTransform(name)
	if not name or name == "" or name == self.transform.name then
		return self.transform
	end

	if self.cacheTransform[name] then
		return self.cacheTransform[name]
	end

	if not self.transformGroup then
		return
	end

	self.cacheTransform[name] = self.transformGroup:GetTransform(name)

	return self.cacheTransform[name]
end

function ClientTransformComponent:SetBineVisible(name, visible)
	self.transformGroup:SetBineVisible(name, visible)
end

function ClientTransformComponent:GetHeadTransform()
	if not self.getHeadTransform then
		self.headTransform = self:GetTransform("Head")
		self.getHeadTransform = true
	end
	return self.headTransform
end

function ClientTransformComponent:TransformRayCastGroup(srcTransform, groupName)
	if not self.transformGroup then
		return
	end
	return self.transformGroup:TransformRayCastGroup(srcTransform, groupName, PhysicsTerrain.TerrainCheckLayer)
end

function ClientTransformComponent:GetGameObject()
	return self.gameObject
end

function ClientTransformComponent:GetTransformGroup(name)
	if not name or name == "" or not self.transformGroup then
		return
	end

	if self.cacheGroupTransform[name] then
		return self.cacheGroupTransform[name]
	end

	local transformList = self.transformGroup:GetTransformGroup(name)
	if transformList then
		self.cacheGroupTransform[name] = {}
		for i = 0, transformList.Count - 1 do
			table.insert(self.cacheGroupTransform[name], transformList[i])
		end
	end

	return self.cacheGroupTransform[name]
end

function ClientTransformComponent:GetShakeTransform(pos)
	if not self.transformGroup then
		return
	end

	return self.transformGroup:GetShakeTransform(pos)
end

function ClientTransformComponent:SetGroupVisible(groupName,visible)
	if not self.transformGroup then
		LogError("cant find self.transformGroup = "..groupName)
		return
	end

	self.transformGroup:SetGroupVisible(groupName,visible)
end

function ClientTransformComponent:Init(clientFight,clientEntity,info)
	
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	local entity = self.clientEntity.entity
	if entity.tagComponent then
		self.tag = entity.tagComponent.tag
	end
	self.transformComponent = entity.transformComponent
	self.rotateComponent = entity.rotateComponent
	self.timeComponent = entity.timeComponent
	self.combinationComponent = entity.combinationComponent

	self.info = info
	self.path = info.Prefab

	local poolOwner = entity.entityId
	if entity.owner then
		poolOwner = entity.owner.entityId
	end
	if ClientTransformComponent.HideEffect and string.find(self.path,"ffect") then
		self.gameObject = GameObject(self.path)
		self.isOrginGameObject = true
	else
		self.gameObject, self.isOrginGameObject = self.clientFight.assetsPool:Get(self.path, self.info.isClone)
	end

	if self.isOrginGameObject and entity.tagComponent and entity.tagComponent.tag == FightEnum.EntityTag.Npc then
		CustomUnityUtils.SetShadowRenderers(self.gameObject)
	end
	
	if not self.gameObject then
		LogError("error path: "..self.path.." id = "..self.clientEntity.entity.entityId)
	end

	self.gameObject:SetActive(true)
	local name = string.gsub(self.gameObject.name,"%(Clone%)","")
	self.model = self.gameObject.transform:Find(name)
	--self.gameObject.name = string.format("[实例Id:%s][实体Id:%s]",clientEntity.entity.instanceId,clientEntity.entity.entityId)
	local model = self.model and self.model or self.gameObject.transform
	local animatorMove = model.gameObject:GetComponent(AnimatorMove)
	if not animatorMove then
		model.gameObject:AddComponent(AnimatorMove)
	end
	
	
	self.transform = self.gameObject.transform
	self.transform:SetParent(self.clientFight.clientEntityManager.entityRoot.transform)
	
	self.offsetX = 0--Vec3.New()
	self.lastOffsetX = 0--Vec3.New()
	self.transformGroup = self.gameObject:GetComponent(BindTransform)
	if self.transformGroup then
		self.entityTranslucent = self.gameObject:GetComponent(EntityTranslucent)
		if not self.entityTranslucent then
			self.entityTranslucent = self.gameObject:AddComponent(EntityTranslucent)
		end
		--local rootTransform = self:GetTransform(info.BoneName or "HitCase")
		--self.entityTranslucent:SetRootTransform(rootTransform)
		self.entityTranslucent:SetRootTransform(self.transform)
		self.entityTranslucent:SetParms(info.MinDistance or 0,info.MaxDistance or 1,info.MinTranslucent or 0,info.MaxTranslucent or 0.8)
	end
	
	if ctx and ctx.Editor then
		local showName = string.gsub(name,"%[%w+%]","")
		self.gameObject.name = string.format("%s[%d]", showName, self.clientEntity.entity.instanceId)
	end
	-- print("ClientTransformComponent "..self.clientEntity.entity.entityId.." path "..name)
end

function ClientTransformComponent:SetEntityTranslucent(type,time)
	self.entityTranslucent:SetTranslucent(type,time)
end

function ClientTransformComponent:SetTranslucentPause(pause)
	self.entityTranslucent:SetPause(pause)
end

function ClientTransformComponent:SetMainRole(isMainRole)
	self.entityTranslucent:SetMainRole(isMainRole)
end

function ClientTransformComponent:InitEffectUtil()
	self.effectUtil = self:GetObjectComponent(EffectUtil)
	if self.effectUtil then
		self.effectUtil:LogicInit()
	end
end

function ClientTransformComponent:SetTransformChild(child, transformName, childName, transform) 
	transformName = transformName or ""
	transform = transform or self:GetTransform(transformName)

	child:SetParent(transform)

	if not self.isOrginGameObject then
		return
	end

	childName = childName or child.name
	self.transformChildMap = self.transformChildMap or {}
	self.transformChildMap[childName] = self.transformChildMap[childName] or {}
	table.insert(self.transformChildMap[childName], transformName) 
	self:MarkGameObjectDirty()
end

function ClientTransformComponent:MarkGameObjectDirty()
	if self.markGameObjectDirty then
		return
	end

	if not self.gInstanceId then
		self.gInstanceId = self.gameObject:GetInstanceID()
	end
	self.markGameObjectDirty = true
	self.clientFight.clientEntityManager:MarkGameObjectDirty(self.gInstanceId, self.clientEntity.entity.instanceId)
end

function ClientTransformComponent:GetObjectComponent(typeComponent)
	return self.gameObject:GetComponent(typeComponent)
end

function ClientTransformComponent:DoAnimationXFusion(lastAnimX)
	self.lastAnimX = lastAnimX
	--最多只融合0.1，试试效果
	self.fusionTime = 0.1
	self.curFusionTime = 0
end

function ClientTransformComponent:DoAnimationYFusion(fusionTarget, fusionTime)
	self.fusionTargetY = fusionTarget
	self.yfusionTime = fusionTime
	self.ycurFusionTime = 0
end

function ClientTransformComponent:SetPivotYOffset(offset)
	self.pivotYOffset = offset
end

function ClientTransformComponent:DoMoveX(offsetX)
	self.lastOffsetX = self.offsetX--Vec3.New()
	self.offsetX = offsetX--Vec3.New()
	
	--Log("DoMoveX "..offsetX)
	--do return end
	--local forward = (self.transformComponent.rotation * Vec3.right):SetNormalize()
	--self.lastOffsetX.x = self.offsetX.x
	--self.lastOffsetX.y = 0--self.offsetX.y
	--self.lastOffsetX.z = self.offsetX.z
	--self.offsetX.x = offsetX --* forward.x
	--self.offsetX.y = 0--self.offsetX.y + forward * offsetX
	--self.offsetX.z = 0--forward.z * offsetX
end

function ClientTransformComponent:ClearMoveX()
	self.lastOffsetX = 0--Vec3.New()
	self.offsetX = 0--Vec3.New()
end

function ClientTransformComponent:SetBindTransform(bindName, isBind, bindOffset, scaleOffset, bindPositionTime, bindRotationTime,bindEntity)
	local owner = bindEntity and bindEntity or self.clientEntity.entity.owner
	if not owner then
		return
	end

	if bindOffset and (bindOffset[1] ~= 0 or bindOffset[2] ~= 0 or bindOffset[3] ~= 0) then
		self:SetBindTransformOffset(bindOffset[1], bindOffset[2], bindOffset[3])
	end

	if scaleOffset and (scaleOffset[1] ~= 0 or scaleOffset[2] ~= 0 or scaleOffset[3] ~= 0) then
		self:SetTransformScale(scaleOffset[1], scaleOffset[2], scaleOffset[3])
	else
		self:SetTransformScale(1, 1, 1)
	end


	self.bindTransform = owner.clientEntity.clientTransformComponent:GetTransform(bindName)
	if not isBind then
		self:_SetBindTransform(true)
	else
		bindPositionTime = bindPositionTime or -1
		bindRotationTime = bindRotationTime or -1
		if bindPositionTime ~= -1 or bindRotationTime ~= -1 then
			self.bindTimeMode = true
			self.bindPositionTime = bindPositionTime
			self.bindRotationTime = bindRotationTime
			self.bindPositionStartTime = bindPositionTime
			self.bindRotationStartTime = bindRotationTime
			self:_SetBindTransform()
		end

		if not self.bindTimeMode then
			self.bindParentMode = true
			owner.clientEntity.clientTransformComponent:SetTransformChild(self.transform, bindName, self.transform.name)
			self.transform:ResetAttr()

			if self.bindOffset then
				UnityUtils.SetLocalPosition(self.transform, self.bindOffset.x, self.bindOffset.y, self.bindOffset.z)
			end
		end
	end
end

function ClientTransformComponent:_SetBindTransform(forcePosition)
	if not self.bindTransform then
		return	
	end
	
	local position = self.bindTransform.position
	local rotation = self.bindTransform.rotation
	if self.bindOffset then
		local offset = rotation * self.bindOffset
		position = offset + position
	end

	if forcePosition then
		self:SetForcePosition(position.x, position.y, position.z)
	end

	self.transformComponent:SetPosition(position.x, position.y, position.z)
	local entityRotation = Quat.New()
	entityRotation:CopyValue(rotation)
	self.clientEntity.entity.rotateComponent:SetRotation(entityRotation)
	self:Async()
end

function ClientTransformComponent:SetForcePosition(x, y, z)
	self.forcePosition = Vec3.New(x, y, z)
	UnityUtils.SetPosition(self.transform,x, y, z)
end

function ClientTransformComponent:SetBindTransformOffset(x, y, z)
	self.bindOffset = Vector3(x, y, z)
end

function ClientTransformComponent:SetTransformScale(x, y, z)
	UnityUtils.SetLocalScale(self.transform, x, y, z)
end

function ClientTransformComponent:SetRotationFollower(followTarget)
	if not self.rotationCmp then
		if not followTarget then
			return
		end
		self.rotationCmp = self.transform.gameObject:AddComponent(RotationFollow)
	end

	self.rotationCmp.target = followTarget
end

function ClientTransformComponent:UpdateBindTransform()
	if not UtilsBase.IsNull(self.bindTransform) and
		self.bindPositionStartTime and self.bindRotationStartTime then

		if self.bindPositionStartTime ~= -1 and self.bindPositionTime > 0 then
			self.bindPositionTime = self.bindPositionTime - Time.deltaTime
		end

		if self.bindRotationStartTime ~= -1  and self.bindRotationTime > 0 then
			self.bindRotationTime = self.bindRotationTime - Time.deltaTime
		end

		if self.bindPositionStartTime == -1 or self.bindPositionTime > 0 then
			if self.bindOffset then
				local offset = self.bindTransform.rotation * self.bindOffset
				self.transform.position = self.bindTransform.position + offset
			else
				self.transform.position = self.bindTransform.position
			end
		end

		if self.bindRotationStartTime == -1 or self.bindRotationTime > 0 then
			self.transform.rotation = self.bindTransform.rotation
		end
	end
end

function ClientTransformComponent:RelationEntity(entity1, entity2, radius)
	if not ctx then
		LogError("RelationEntity 错误调用")
	end
	self.radius = radius
	if not self.rendLineComp then
		self.rendLineComp = self.gameObject:GetComponent(LineRenderer)
	end
	self.relationTrasnform1 = entity1.clientEntity.clientTransformComponent.transform
	self.relationTrasnform2 = entity2.clientEntity.clientTransformComponent.transform
	UnityUtils.SetPosition(self.transform, 0, 0.2, 0)
	UnityUtils.SetRotation(self.transform, 0, 0, 0, 0)
	self:SetActivity(true)
end

function ClientTransformComponent:RemoveRelationEntity()
	self.relationTrasnform1 = nil
	self.relationTrasnform2 = nil
	self:SetActivity(false)
end

function ClientTransformComponent:UpdateRelationPos()
	if self.radius then
		local dir = self.relationTrasnform2.position - self.relationTrasnform1.position
		local pos1 = self.relationTrasnform1.position + dir.normalized * self.radius
		local pos2 = self.relationTrasnform2.position + -dir.normalized * self.radius
		self.rendLineComp:SetPosition(0, pos1)
		self.rendLineComp:SetPosition(1, pos2)
	else
		self.rendLineComp:SetPosition(0, self.relationTrasnform1.position)
		self.rendLineComp:SetPosition(1, self.relationTrasnform2.position)
	end
end

function ClientTransformComponent:Update(lerpTime)
	self.moveFlag = false
	self.rotateFlag = false
	if self.combinationComponent and self.combinationComponent:CombinationIngParent() then
		return
	end

	if self.relationTrasnform1 and self.relationTrasnform2 then
		self:UpdateRelationPos()
		return
	end

	if self.bindParentMode then
		return
	end

	if self.bindTimeMode then
		self.moveFlag = true
		self:UpdateBindTransform()
		return
	end

	if self.forcePosition then
		self:UpdatePosition(lerpTime)
		self:UpdateRotate(lerpTime)
		return
	end

	if self.timeComponent and self.timeComponent:GetTimeScale() == 0 then
		return
	end

	self:UpdatePosition(lerpTime)
	self:UpdateRotate(lerpTime)
end

function ClientTransformComponent:Async()
	self:UpdatePosition(1)
	self:UpdateRotate(1)
end

function ClientTransformComponent:UpdatePosition(lerpTime)
	local offsetY = 0
	if self.pivotYOffset then
		offsetY = self.pivotYOffset
	end

	local timescale = self.timeComponent and self.timeComponent:GetTimeScale() or 1
	local time = Global.deltaTime * timescale
	if self.model and self.lastOffsetX ~= self.offsetX and not self.lastAnimX then
		local offsetX = self.lastOffsetX + (self.offsetX - self.lastOffsetX) * lerpTime
		--X轴的动画融合
		if self.lastAnimX then
			if self.curFusionTime < self.fusionTime then
				local weight = math.min(self.curFusionTime / self.fusionTime, 1)
				offsetX = self.lastAnimX * (1 - weight) + offsetX * weight
				self.curFusionTime = self.curFusionTime + time
			else
				self.lastAnimX = nil
				self.curFusionTime = nil
				self.fusionTime = nil
			end
		end

		--local offsetZ = self.lastOffsetX.z + (self.offsetX.z - self.lastOffsetX.z) * lerpTime
		
		self.lastOffsetX = self.offsetX
		UnityUtils.SetLocalPosition(self.model, offsetX, -offsetY, 0)
	elseif self.model and offsetY ~= 0 then
		UnityUtils.SetLocalPosition(self.model, 0, -offsetY, 0)
	elseif self.model then
		local offsetX = self.lastOffsetX + (self.offsetX - self.lastOffsetX) * lerpTime
		UnityUtils.SetLocalPosition(self.model, offsetX, -offsetY, 0)
	end

	local fixedY = 0
	if self.fusionTargetY and self.ycurFusionTime < self.yfusionTime then
		local weight = math.min(time / self.yfusionTime, 1)
		fixedY = self.fusionTargetY * weight
		self.ycurFusionTime = self.ycurFusionTime + time
	else
		self.fusionTargetY = nil
		self.ycurFusionTime = nil
		self.yfusionTime = nil
	end

	local position = self.transformComponent.position
	local lastPosition = self.transformComponent.lastPosition

	if not position:Equals(lastPosition) or not position:Equals(self.lastPosition) then
		local x, y, z = Vec3.LerpC(lastPosition, position, lerpTime)
		if fixedY ~= 0 then
			-- LogError("origin y = "..y.." fusion = "..fixedY)
			self.transformComponent:SetPositionOffset(0, fixedY, 0)
		end
		UnityUtils.SetPosition(self.transform, x, y, z)
		self.moveFlag = true

		self.lastPosition:SetA(lastPosition)
	end

	if self.moveFlag then
		local guidePointers = self.transformComponent.guidePointers
		if guidePointers and next(guidePointers) then
			for k, v in pairs(self.transformComponent.guidePointers) do
				EventMgr.Instance:Fire(EventName.UpdateEntityGuidePos, k, position.x, position.y, position.z)
			end
		end
	end
end

-- 设置一下过度的角度
function ClientTransformComponent:SetOffsetRot(x, z)
	self.modelOffsetRot = {}
	self.modelOffsetRot.x = x and x or 0
	self.modelOffsetRot.z = z and z or 0
	self.lastOffsetRotX = self.model.eulerAngles.x > 180 and self.model.eulerAngles.x - 360 or self.model.eulerAngles.x
	self.lastOffsetRotZ = self.model.eulerAngles.z > 180 and self.model.eulerAngles.z - 360 or self.model.eulerAngles.z
end

function ClientTransformComponent:UpdateRotate(lerpTime)
	local rotation = self.transformComponent.rotation
	local lastRotation = self.transformComponent.lastRotation

	-- 做左右倾斜的过度动画
	if self.modelOffsetRot then
		self.lastOffsetRotX = self.lastOffsetRotX + ((self.modelOffsetRot.x - self.lastOffsetRotX) * lerpTime)
		self.lastOffsetRotZ = self.lastOffsetRotZ + ((self.modelOffsetRot.z - self.lastOffsetRotZ) * lerpTime)
		UnityUtils.SetLocalEulerAngles(self.model, self.lastOffsetRotX, 0, self.lastOffsetRotZ)

		if self.modelOffsetRot.x == self.lastOffsetRotX and self.lastOffsetRotZ == self.modelOffsetRot.z then
			self.modelOffsetRot = nil
			self.lastOffsetRotX = 0
			self.lastOffsetRotZ = 0
		end
	end

	if Quat.Equals(rotation, lastRotation) and rotation:Equals(self.lastRotation) then
		return
	end
	self.lastRotation:CopyValue(lastRotation)
	
	local x1, y1, z1, w1 = rotation:Get()
	local x2, y2, z2, w2 = lastRotation:Get()

	CustomUnityUtils.EulerAngleLerp(self.transform,x1,y1,z1,w1,x2,y2,z2,w2,lerpTime)
	-- lua 欧拉角运行速度慢且产生GC，缓存记录
	self.eulerAngles:SetA(self.transform.eulerAngles)
	self.rotateFlag = true

	-- local eulerAngles = rotation:ToEulerAnglues()
	-- local lastEulerAngles = lastRotation:ToElerAngles()

	-- local difRX = eulerAngles.x - lastEulerAngles.x
	-- difRX = difRX > 180 and 360 - difRX or difRX
	-- difRX = difRX < -180 and 360 + difRX or difRX
	-- local x = lastEulerAngles.x + difRX * lerpTime

	-- local difRY = eulerAngles.y - lastEulerAngles.y
	-- difRY = difRY > 180 and 360 - difRY or difRY
	-- difRY = difRY < -180 and 360 + difRY or difRY
	-- local y = lastEulerAngles.y + difRY * lerpTime

	-- local difRZ = eulerAngles.z - lastEulerAngles.z
	-- difRZ = difRZ > 180 and 360 - difRZ or difRZ
	-- difRZ = difRZ < -180 and 360 + difRZ or difRZ
	-- local z = lastEulerAngles.z + difRZ * lerpTime

	-- UnityUtils.SetEulerAngles(self.transform,x, y, z)
end

function ClientTransformComponent:SetActive(flag)
	self.gameObject:SetActive(flag)
end

function ClientTransformComponent:OnCache()
	if not UtilsBase.IsNull(self.effectUtil) then
		self.effectUtil:SetSpeed(1)
		self.effectUtil:SetGlobalKeyword(false)
		self.effectUtil = nil
	end

	if self.markGameObjectDirty then
		self.markGameObjectDirty = nil
		self.clientFight.clientEntityManager:RemoveGameObjectDirty(self.gInstanceId)
	end

	if self.transformChildMap then
		TableUtils.ClearTable(self.transformChildMap)
	end
	
	for _, info in pairs(self.weaponMap) do
		self.clientFight.assetsPool:Cache(info.path, info.obj)
	end

	if next(self.weaponMap) then
		CustomUnityUtils.SetShadowRenderers(self.gameObject)
	end

	TableUtils.ClearTable(self.weaponMap)

	self.gInstanceId = nil

	self.clientFight.fight.objectPool:Cache(ClientTransformComponent,self)
end

function ClientTransformComponent:SetTimeScale(timeScale)
	if self.effectUtil then
		self.effectUtil:SetSpeed(timeScale)
	end
end

function ClientTransformComponent:SetGrounderFBBIKActive(active)
	local transform = self:GetTransform("Grounder FBBIK")
	if transform then
		transform:SetActive(active)
		if active then
			CustomUnityUtils.SetGrounderWeightFade(transform, 0, 1, 0.5)
		end
	end
end

function ClientTransformComponent:GetGroundMatLayer()
	local moveComponent = self.clientEntity.entity.moveComponent
	local isTouchWater = moveComponent:IsTouchWater()
	if isTouchWater then
		return TerrainMatLayerConfig.Layer.Water
	end

	local position = self.transformComponent.position
	local x = position.x
	local y = position.y
	local z = position.z

	local gameObject =  CS.PhysicsTerrain.GetSphereCastObject(x, y + 0.5, z, 0.1, 0.5, -1)	
	if gameObject then
		return ThingMatLayerConfig.GetMatLayer(gameObject, x, z)
	end
	return TerrainMatLayerConfig.GetMatLayer(x, z)
end

function ClientTransformComponent:BindWeapon(weaponId)
	local bindConfig = RoleConfig.GetWeaponAsset(weaponId)
	if bindConfig then
		for i = 1, #bindConfig do
			local tf = self:GetTransform(bindConfig[i][1])
			if tf and tf.childCount > 0 then
				local go = tf:GetChild(0)
				self.clientFight.assetsPool:Cache(self.weaponMap[bindConfig[i][1]].path, go.gameObject)
			end
			local go = self.clientFight.assetsPool:Get(bindConfig[i][2])
			self:SetTransformChild(go.transform, bindConfig[i][1], go.name)
			go.transform:ResetAttr()
			self.weaponMap[bindConfig[i][1]] = {path = bindConfig[i][2], obj = go.gameObject}
		end
		CustomUnityUtils.SetShadowRenderers(self.gameObject)
	end
end

function ClientTransformComponent:BindGlider(gliderId)
	local bindNode = "ItemCase_r"
	local moveComponent = self.clientEntity.entity.moveComponent
    if moveComponent and moveComponent.config.GlideBindNode and moveComponent.config.GlideBindNode ~= "" then
        bindNode = moveComponent.config.GlideBindNode
    end
	local bindTransform = self:GetTransform(bindNode)
	if bindTransform and bindTransform.childCount > 0 then
		for i = 0, bindTransform.childCount -1, 1 do
			GameObject.Destroy(bindTransform:GetChild(i).gameObject)
		end
	end

	local go = self.clientFight.assetsPool:Get("Character/Animal/Glider/Zhiyao/Zhiyao.prefab")
	self:SetTransformChild(go.transform, bindNode)
	--go.transform:SetParent(bindTransform)
	UnityUtils.SetLocalScale(go.transform, 1, 1, 1)
	-- 临时写一下
	local root = go.transform:Find("Zhiyao/Glider_Root")
	UnityUtils.SetLocalScale(root, 1, 1, 1)

	CustomUnityUtils.SetShadowRenderers(self.gameObject)

	return go
end

-- TODO 临时的缓存 后面添加装备缓存池后修改
function ClientTransformComponent:CacheGlider(go)
	if not go then
		return
	end

	self.clientFight.assetsPool:Cache("Character/Animal/Glider/Zhiyao/Zhiyao.prefab", go)
end

function ClientTransformComponent:__cache()
	for k, v in pairs(self.hideGroup) do
		self:SetGroupVisible(k, true)
	end

	for k, v in pairs(self.hideBone) do
		self:GetTransform(k).gameObject:SetActive(true)
	end

	if self.rotationCmp then
		GameObject.Destroy(self.rotationCmp)
		self.rotationCmp = nil
	end

	self.tag = FightEnum.EntityTag.None
	self.gameObject = nil
	self.bindTransform = nil
	self.bindPosFixY = nil
	self.bindOffset = nil
	self.bindTimeMode = nil
	self.bindParentMode = nil
	self.forcePosition = nil
	self.forceRotateY = nil
	self.relationTrasnform1 = nil
	self.relationTrasnform2 = nil
	self.collistionComponent = nil
	self.weaponFollowCmpList = nil

	self.getHeadTransform = nil
	self.headTransform = nil
	
	TableUtils.ClearTable(self.hideBone)
	TableUtils.ClearTable(self.hideGroup)
	TableUtils.ClearTable(self.cacheTransform)
	TableUtils.ClearTable(self.cacheGroupTransform)
	self.eulerAngles:Set(0,0,0)
	self.lastPosition:Set(0,0,0)
	self.lastRotation:Set(0,0,0,0)
	
	local poolOwner = self.clientEntity.entity.owner ~= nil and self.clientEntity.entity.owner.entityId or self.clientEntity.entity.entityId
	if not UtilsBase.IsNull(self.transform) and not ClientTransformComponent.HideEffect then
		if self.info.isClone then
			GameObject.Destroy(self.transform.gameObject)
		else
			self.clientFight.assetsPool:Cache(self.path, self.transform.gameObject)
		end
	end
end

function ClientTransformComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end


