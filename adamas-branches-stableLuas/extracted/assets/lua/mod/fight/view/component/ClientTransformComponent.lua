---@class ClientTransformComponent
ClientTransformComponent = BaseClass("ClientTransformComponent",PoolBaseClass)
local Vec3 = Vec3
local Quat = Quat

ClientTransformComponent.HideEffect = false

local TempQuat = Quat.New()
local SmallLuaCSharpArr = SmallLuaCSharpArr
local EntityLODManager = EntityLODManager

function ClientTransformComponent:__init()
	self.tag = FightEnum.EntityTag.None
	self.useRenderHeight = false
	self.hideBone = {}
	self.hideGroup = {}
	self.cacheTransform = {}
	self.cacheGroupTransform = {}
	self.eulerAngles = Vec3.New()
	self.lastPosition = Vec3.New()
	self.lastRotation = Quat.New()
	self.force = Vec3.New()
	self.relationForce = Vec3.New()
	self.presentationMoveVector = Vec3.New()
	self.climbAnimatorMoveVec = Vec3.New()
	self.lastRecordMoveFrame = 0
	self.isKinematic = true
	self.activityState = true
	self.isLuaControlEntityMove = true
	self.banKccMove = false
	self.materialMeshs = {}
end

function ClientTransformComponent:Bind(bindRotate,bindScale)

end

function ClientTransformComponent:SetActivity(activity)
	if self.activityState == activity then
		return
	end
	self.activityState = activity
	CustomUnityUtils.SetModelActive(self.gameObject, activity)
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
	if not self.transformGroup  then
		LogError("没有BindTransform组件",self.path, self.entity.entityId)
		return
	end
	self.transformGroup:SetBineVisible(name, visible)
	CustomUnityUtils.SetShadowRenderers(self.gameObject)
end

function ClientTransformComponent:SetTransformVisible(name, visible)
	self.transformGroup:SetTransformVisible(name, visible)
	self.setShadow = true
	--CustomUnityUtils.SetShadowRenderers(self.gameObject)
end

function ClientTransformComponent:GetHeadTransform()
	if not self.getHeadTransform then
		self.headTransform = self:GetTransform("Head") or self.transform
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
	self.setShadow = true
	--CustomUnityUtils.SetShadowRenderers(self.gameObject)
end

function ClientTransformComponent:Init(clientFight,clientEntity,info)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.entity = self.clientEntity.entity
	if self.entity.tagComponent then
		self.tag = self.entity.tagComponent.tag
	end
	self.transformComponent = self.entity.transformComponent
	self.rotateComponent = self.entity.rotateComponent
	self.timeComponent = self.entity.timeComponent
	self.combinationComponent = self.entity.combinationComponent
	self.collisionComponent = self.entity.collistionComponent

	self.info = info
	self.lodRes = info.LodRes 
	if self.lodRes then
		self.path = string.gsub(info.Prefab, ".prefab", "Unit.prefab")
	else
		self.path = info.Prefab
	end

	local poolOwner = self.entity.entityId
	if self.entity.parent then
		poolOwner = self.entity.parent.entityId
	end
	if ClientTransformComponent.HideEffect and string.find(self.path,"ffect") then
		self.gameObject = GameObject(self.path)
		self.isOrginGameObject = true
	else
		self.gameObject, self.isOrginGameObject = self.clientFight.assetsPool:Get(self.path, self.info.isClone)
	end

	if self.isOrginGameObject and self.entity.tagComponent and self.entity.tagComponent.tag == FightEnum.EntityTag.Npc then
		CustomUnityUtils.SetShadowRenderers(self.gameObject)
	end
	
	if not self.gameObject then
		LogError("error path: "..self.path.." id = "..self.entity.entityId)
	end

	self.gameObject:SetActive(true)
	self.transformGroup = self.gameObject:GetComponent(BindTransform)
	
	local name = info.Model
	if not name or name == "" then
		name = self.path:match("^.+/(.+)%..+$")
		--name = string.gsub(self.gameObject.name,"%(Clone%)","")
	end
	
	if self.transformGroup then
		self.model = self.transformGroup:GetTransform(name)
		if not UtilsBase.IsNull(self.model) and self.model == self.gameObject.transform then
			LogError(string.format("预制件bindTransform组件配置的Model结点【%s】为它自身，请检查修改！", name))
			self.model = nil
		end
	end

	if not self.model or UtilsBase.IsNull(self.model) then
		self.model = self.gameObject.transform:Find(name)
	end

    -- 攀爬
	local model = self.model and self.model or self.gameObject.transform
	self.isUseRenderAniMove = false
	self.animatorMove = model.gameObject:GetComponent(AnimatorMove)
	if not self.animatorMove then
		self.animatorMove = model.gameObject:AddComponent(AnimatorMove)
	end

	--使用渲染层的动画位移数据
	local ac = function(offsetX,offsetY,offsetZ)
		self.clientEntity.entity.climbComponent:SetPositionOffset(offsetX,offsetY,offsetZ)
	end
	self.animatorMove:SetClimbCallback(ac)

	--Rigidbody组件放在根节点，子节点都不必再挂Rigidbody组件
	--TODO 要改成离线添加Rigidbody组件
	 self.rigidbody = self.gameObject:GetComponent(Rigidbody)
	 if UtilsBase.IsNull(self.rigidbody) then
	 	self.gameObject:AddComponent(Rigidbody)
	 	self.rigidbody = self.gameObject:GetComponent(Rigidbody)
	 end
	 self.rigidbody.isKinematic = true
	if self.tag and self.tag == FightEnum.EntityTag.Bullet or (self.entity.tagComponent and self.entity.tagComponent.sceneObjectTag == FightEnum.EntitySceneObjTag.HackOrBuild) then
		self.rigidbody.collisionDetectionMode = CollisionDetectionMode.ContinuousSpeculative
	else
		self.rigidbody.collisionDetectionMode = CollisionDetectionMode.Discrete
	end


	self.transform = self.gameObject.transform
	if self.tag and self.tag == FightEnum.EntityTag.Bullet then
		self.transform:SetParent(self.clientFight.clientEntityManager.bulletRoot.transform)
	else
		self.transform:SetParent(self.clientFight.clientEntityManager.entityRoot.transform)
	end

	self.offsetX = 0--Vec3.New()
	self.lastOffsetX = 0--Vec3.New()

	if self.transformGroup and self.entity.tagComponent and self.entity.tagComponent:IsNeedEntityTranslucent() then
		self.entityTranslucent = self.gameObject:GetComponent(EntityTranslucent)
		if not self.entityTranslucent then
			self.entityTranslucent = self.gameObject:AddComponent(EntityTranslucent)
		end
		--local rootTransform = self:GetTransform(info.BoneName or "HitCase")
		--self.entityTranslucent:SetRootTransform(rootTransform)
		self.entityTranslucent:SetRootTransform(self.transform)
		self.entityTranslucent:SetParms(info.MinDistance or 0,info.MaxDistance or 1,info.MinTranslucent or 0,info.MaxTranslucent or 0.8, info.TranslucentHeight or 1.8)
	end

	if ctx and ctx.Editor then
		local showName = string.gsub(name,"%[%w+%]","")
		self.gameObject.name = string.format("%s[%d]", showName, self.entity.instanceId)
	end
	-- print("ClientTransformComponent "..self.clientEntity.entity.entityId.." path "..name)
	--pos:[1-3],pos_dirty[4],rotation:[5-8],rotation_dirty[9],LodLevel[10],Distance[11],isLuaControlEntityMove[12]
	self.smallLuaCSharpArr = self.clientFight.fight.objectPool:Get(SmallLuaCSharpArr)
	self.CSharpArr = self.smallLuaCSharpArr.CSharpArr
	EntityLODManager.Instance:OnCreateEntity(self.entity.instanceId, self.transform, self.smallLuaCSharpArr.access)
	self.firstSync = false
	--获取材质代理
	self.materialMeshs = self.transform:GetComponentsInChildren(MaterialPropertyAgentMesh)
end

function ClientTransformComponent:LateInit()
	if self.entity.moveComponent and 
	self.entity.moveComponent.config.MoveType == FightEnum.MoveType.AnimatorMoveData 
	and self.entity.collistionComponent
	and self.clientEntity.clientAnimatorComponent then
		self.kCCCharacterProxyGO = GameObject(tostring(self.entity.instanceId))
		self.kCCCharacterProxyGO.transform:SetParent(self.clientFight.clientEntityManager.kCCProxyRoot.transform)
		self.kCCCharacterProxyGO.layer = 15
		self.kCCCharacterProxy = self.kCCCharacterProxyGO:GetComponent(CS.KCCCharacterProxy)
		local rigidbody = self.kCCCharacterProxyGO:AddComponent(Rigidbody)
		rigidbody.isKinematic = true
		if not self.kCCCharacterProxy then
			self.kCCCharacterProxy = self.kCCCharacterProxyGO:AddComponent(CS.KCCCharacterProxy)
		end
		local cb = function(posX,posY,posZ)
			local transformComponent = self.entity.transformComponent
			if self.isLuaControlEntityMove and not self.banKccMove and transformComponent then
				transformComponent:SetCurPosition(posX,posY,posZ)
			end
		end
		self.kCCCharacterProxy:Init(cb,self.transform)
		self:SetKCCProxyHeight(self.entity.collistionComponent.height)
		self:SetKCCProxyRadius(self.entity.collistionComponent.radius)
		local offsetY = self.collisionComponent.offsetY == 0 and self.clientEntity.entity.collistionComponent.height * 0.5 or self.collisionComponent.offsetY
		self:SetKCCProxyYOffset(offsetY)
		self.animatorMove:SetProxy(self.kCCCharacterProxy)

		local colliderInstance = self.kCCCharacterProxyGO:GetInstanceID()
		self.clientFight.fight.entityManager:SetColliderEntity(colliderInstance, self.entity.instanceId)
	end
	self:SetLuaControlEntityMove(true)

	if self.entity.timeComponent then
		self.entity.timeComponent:OnUpdateTimeScale()
	end
end

function ClientTransformComponent:SetKCCProxyHeight(height)
	if self.kCCCharacterProxy then
		self.kccProxyHeight = height
		self.kCCCharacterProxy:SetHeight(height)
	end
end

function ClientTransformComponent:SetKCCProxyRadius(radius)
	if self.kCCCharacterProxy then
		self.kccProxyRadius = radius
		self.kCCCharacterProxy:SetRadius(radius)
	end
end

function ClientTransformComponent:SetKCCProxyYOffset(offset)
	if self.kCCCharacterProxy then
		self.kCCCharacterProxy:SetYOffset(offset)
	end
end

function ClientTransformComponent:SetKCCMaxStepHeight(height)
	if self.kCCCharacterProxy then
		self.kCCCharacterProxy:SetMaxStepHeight(height)
	end
end

function ClientTransformComponent:SetEntityTranslucentV2(value,time,fadeInTime)
	if UtilsBase.IsNull(self.entityTranslucent) then
		return
	end

	self.entityTranslucent:SetTranslucentV2(value,time,fadeInTime)
end

function ClientTransformComponent:SetEntityTranslucent(type,time)
	if UtilsBase.IsNull(self.entityTranslucent) then
		LogError("这个实体没有 entityTranslucent. entityId = " .. self.entity.entityId)
		return
	end

	if time then
		self.entityTranslucent:SetTranslucent(type,time)
	else
		self.entityTranslucent:SetTranslucent(type)
	end
	
end

function ClientTransformComponent:SetTranslucentPause(pause)
	if UtilsBase.IsNull(self.entityTranslucent) then
		return
	end

	self.entityTranslucent:SetPause(pause)
end

function ClientTransformComponent:SetMainRole(isMainRole)
	if UtilsBase.IsNull(self.entityTranslucent) then
		return
	end

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
	self.clientFight.clientEntityManager:MarkGameObjectDirty(self.gInstanceId, self.entity.instanceId)
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

function ClientTransformComponent:SetUseRenderAniMove(useRenderAniMove)
	self.animatorMove:SetUseRenderAniMove(useRenderAniMove)
	self.isUseRenderAniMove = useRenderAniMove
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

function ClientTransformComponent:RemoveBindTrans()
	if not self.bindTransform then
		return
	end

	local bindPos = self.bindTransform.position
	self.transform = self.gameObject.transform
	self.transform:SetParent(self.clientFight.clientEntityManager.entityRoot.transform)

	local posX = bindPos.x
	local posY = bindPos.y
	local posZ = bindPos.z

	if self.bindOffset then
		posX = posX + self.bindOffset.x
		posY = posY + self.bindOffset.y
		posZ = posZ + self.bindOffset.z
	end
	self.transformComponent:SetPosition(posX, posY, posZ)
	self.bindTransform = nil
end

function ClientTransformComponent:SetBindTransform(bindName, isBindMove, isHang, bindOffset, scaleOffset, bindPositionTime, bindRotationTime,bindEntity,IsBindWeapon,WeaponBindTransformName)
	local parent = bindEntity and bindEntity or self.entity.parent
	if not parent then
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
	
	bindPositionTime = bindPositionTime or -1
	bindRotationTime = bindRotationTime or -1

	self.bindTransform = IsBindWeapon and parent.clientEntity.weaponComponent:GetWeaponTransByBindName(bindName, WeaponBindTransformName) or parent.clientEntity.clientTransformComponent:GetTransform(bindName)
	if self.bindTransform ~= nil and UtilsBase.IsNull(self.bindTransform) then
		LogError(string.format("[%s]实体上的[%s]是null的请检查BindTransform", self.entity.entityId,bindName))
		return
	end
	if isHang then
		parent.clientEntity.clientTransformComponent:SetTransformChild(self.transform, bindName, self.transform.name)
		self.transform:ResetAttr()

		if bindOffset and (bindOffset[1] ~= 0 or bindOffset[2] ~= 0 or bindOffset[3] ~= 0) then
			self:SetBindTransformOffset(bindOffset[1], bindOffset[2], bindOffset[3])
		end
	
		if scaleOffset and (scaleOffset[1] ~= 0 or scaleOffset[2] ~= 0 or scaleOffset[3] ~= 0) then
			self:SetTransformScale(scaleOffset[1], scaleOffset[2], scaleOffset[3])
		else
			self:SetTransformScale(1, 1, 1)
		end
	end
	
	if isBindMove then
		self.bindTimeMode = true
		self.bindPositionTime = bindPositionTime
		self.bindRotationTime = bindRotationTime
		self.bindPositionStartTime = bindPositionTime
		self.bindRotationStartTime = bindRotationTime
		self.effectHang = isHang
	end
	self:_SetBindTransform(not isBindMove and isHang)
end

function ClientTransformComponent:_SetBindTransform(forceLocation)
	if not self.bindTransform then
		return	
	end
	
	local position = self.bindTransform.position
	local rotation = self.bindTransform.rotation
	if self.bindOffset then
		local offset = rotation * self.bindOffset
		position = offset + position
	end

	if forceLocation then
		self:SetForceLocation(position.x, position.y, position.z, rotation.x, rotation.y, rotation.z, rotation.w)
	end

	self.transformComponent:SetPosition(position.x, position.y, position.z)
	local entityRotation = Quat.New()
	entityRotation:CopyValue(rotation)
	self.entity.rotateComponent:SetRotation(entityRotation)
	self:Async()
end

function ClientTransformComponent:SetForceLocation(x, y, z, rx, ry, rz, rw)
	self.forceLocation = true
	self.forcePosition = Vec3.New(x, y, z)
	self.forceRotation = Quat.New(rx or 0, ry or 0, rz or 0, rw or 0)
	self:SetPositionByCSharpArr(x, y, z)
	self:SetRotationByCSharpArr(rx, ry, rz, rw)
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
			self.bindPositionTime = self.bindPositionTime > 0 and self.bindPositionTime or 0
		end

		if self.bindRotationStartTime ~= -1  and self.bindRotationTime > 0 then
			self.bindRotationTime = self.bindRotationTime - Time.deltaTime
			self.bindRotationTime = self.bindRotationTime > 0 and self.bindRotationTime or 0
		end

		if self.bindPositionStartTime == -1 or self.bindPositionTime > 0 then
			if self.bindOffset then
				local offset = self.bindTransform.rotation * self.bindOffset
				-- self.transform.position = self.bindTransform.position + offset
				local targetPos = self.bindTransform.position + offset
				self:SetPositionByCSharpArr(targetPos.x, targetPos.y, targetPos.z)
			else
				-- self.transform.position = self.bindTransform.position
				self:SetPositionByCSharpArr(self.bindTransform.position.x, self.bindTransform.position.y, self.bindTransform.position.z)
			end
		elseif self.forceLocation or self.effectHang then
			if self.effectHang then
				self.effectHang = false
				local position = self.transform.position
				local rotation = self.transform.rotation
				self:SetForceLocation(position.x, position.y, position.z, rotation.x, rotation.y, rotation.z, rotation.w)
			end
			
			if self.forceLocation then
				self:SetPositionByCSharpArr(self.forcePosition.x, self.forcePosition.y, self.forcePosition.z)
				self:SetRotationByCSharpArr(self.forceRotation.x, self.forceRotation.y, self.forceRotation.z, self.forceRotation.w)
			end
		end

		if self.bindRotationStartTime == -1 or self.bindRotationTime > 0 then
			self.transform.rotation = self.bindTransform.rotation
		end
	end
end

function ClientTransformComponent:RelationEntity(entity1, transformName1, entity2, transformName2, radius)
	if not ctx then
		LogError("RelationEntity 错误调用")
	end
	self.radius = radius
	if not self.rendLineComp then
		self.rendLineComp = self.gameObject:GetComponent(LineRenderer)
		if UtilsBase.IsNull(self.rendLineComp) then
			self.rendLineComp = self.gameObject:GetComponent(LinkEffect)
			self.rendLineComp.MainTransform = entity1.clientEntity.clientTransformComponent:GetTransform()
		end
	end
	self.relationTrasnform1 = entity1.clientEntity.clientTransformComponent:GetTransform(transformName1)
	self.relationTrasnform2 = entity2.clientEntity.clientTransformComponent:GetTransform(transformName2)
	self:SetPositionByCSharpArr(0, 0.2, 0)
	self:SetRotationByCSharpArr(0, 0, 0, 0)
	self:SetActivity(true)
end

function ClientTransformComponent:RemoveRelationEntity()
	self.relationTrasnform1 = nil
	self.relationTrasnform2 = nil
	self:SetActivity(false)
end

function ClientTransformComponent:UpdateRelationPos()
	if not self.rendLineComp or UtilsBase.IsNull(self.rendLineComp) then
		return
	end

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

function ClientTransformComponent:SetRelationPos(pos1, pos2)
	if not self.rendLineComp then
		self.rendLineComp = self.gameObject:GetComponent(LineRenderer)
		if UtilsBase.IsNull(self.rendLineComp) then
			self.rendLineComp = self.gameObject:GetComponent(LinkEffect)
		end
	end
	if not self.rendLineComp or UtilsBase.IsNull(self.rendLineComp) then
		return
	end
	self.rendLineComp:SetPosition(0, pos1)
	self.rendLineComp:SetPosition(1, pos2)
end

function ClientTransformComponent:SetLines(posList)
	if not self.rendLineComp then
		self.rendLineComp = self.gameObject:GetComponent(LineRenderer)
		if UtilsBase.IsNull(self.rendLineComp) then
			self.gameObject:AddComponent(LineRenderer)
			self.rendLineComp = self.gameObject:GetComponent(LineRenderer)
		end
	end

	if not self.rendLineComp or UtilsBase.IsNull(self.rendLineComp) then
		return
	end

	self.rendLineComp.positionCount = #posList
	for i = 1, #posList do
		self.rendLineComp:SetPosition(i - 1, posList[i])
	end
end

function ClientTransformComponent:Update(lerpTime)
	self.moveFlag = false
	self.rotateFlag = false
	if UtilsBase.IsNull(self.transform) then
		LogError(string.format("资源已经被删除,对象还存在, entityId = %s, path = %s", self.entity.entityId,self.path))
		LogError("需要检查！！临时移除此对象！")
		BehaviorFunctions.RemoveEntity(self.entity.instanceId)
		return
	end
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

		-- TODO 后续再优化 目前有位置延后同步导致特效绑定时/跟随移动有抽动的问题
		EntityLODManager.Instance:Async(self.entity.instanceId)
		return
	end

	if self.forceLocation then
		self:SetPositionByCSharpArr(self.forcePosition.x, self.forcePosition.y, self.forcePosition.z)
		self:SetRotationByCSharpArr(self.forceRotation.x, self.forceRotation.y, self.forceRotation.z, self.forceRotation.w)
	end

	if self.timeComponent and self.timeComponent:GetTimeScale() == 0 then
		return
	end

	self:UpdatePosition(lerpTime)
	self:UpdateRotate(lerpTime)

	-- TODO 后续再优化 目前有位置延后同步导致特效绑定时/跟随移动有抽动的问题
	EntityLODManager.Instance:Async(self.entity.instanceId)

	--self.setShadow = true
	--CustomUnityUtils.SetShadowRenderers(self.gameObject)
	if self.setShadow then
		CustomUnityUtils.SetShadowRenderers(self.gameObject)
		self.setShadow = false
	end
end
 
function ClientTransformComponent:Async()
	self:UpdatePosition(1)
	self:UpdateRotate(1)

	-- TODO 后续再优化 目前有位置延后同步导致特效绑定时/跟随移动有抽动的问题
	EntityLODManager.Instance:Async(self.entity.instanceId)
end
function ClientTransformComponent:SetPosition(x,y,z)
	if self.kCCCharacterProxy then
		self.kCCCharacterProxy:SetPosition(x, y, z)
	end
	self:Async()
end
function ClientTransformComponent:UpdatePosition(lerpTime)
	local offsetY = 0
	if self.pivotYOffset then
		offsetY = self.pivotYOffset
	end

	local timescale = self.timeComponent and self.timeComponent:GetTimeScale() or 1
	local time = Global.deltaTime * timescale
	if self.model and self.lastAnimX then
		local offsetX = self.lastOffsetX + (self.offsetX - self.lastOffsetX) * lerpTime * timescale
		--X轴的动画融合
		if self.curFusionTime < self.fusionTime then
			local weight = math.min(self.curFusionTime / self.fusionTime, 1)
			offsetX = self.lastAnimX * (1 - weight) + offsetX * weight
			self.curFusionTime = self.curFusionTime + time
		else
			self.lastAnimX = nil
			self.curFusionTime = nil
			self.fusionTime = nil
		end

		UnityUtils.SetLocalPosition(self.model, offsetX, -offsetY, 0)
	elseif self.model and offsetY ~= 0 then
		UnityUtils.SetLocalPosition(self.model, 0, -offsetY, 0)
	elseif self.model and not self.clientEntity.clientEffectComponent then
		local scale = 1
		if self.entity.timeComponent then
			scale = self.entity.timeComponent:GetTimeScale()
		end
		local offset = (self.offsetX - self.lastOffsetX) * scale
		local offsetX = self.lastOffsetX + offset * lerpTime
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

	--由C#控制位移和旋转
	if not self.isLuaControlEntityMove then
		if self.lastRecordMoveFrame ~= Fight.Instance.fightFrame then
			self.lastRecordMoveFrame = Fight.Instance.fightFrame
			self.presentationMoveVector:Set()
		end
		local pos = self.transform.position
		self.presentationMoveVector:AddXYZ(pos.x - self.transformComponent.position.x, pos.y - self.transformComponent.position.y, pos.z - self.transformComponent.position.z)

		self.transformComponent.position:SetA(self.transform.position)
		--如果有物理组件，则设置
		if self.rigidbody  then
			if self.constantForce then
				CustomUnityUtils.RigidbodyAddConstantForce(self.gameObject, self.force.x, self.force.y, self.force.z)
				CustomUnityUtils.RigidbodyAddConstantRelativeForce(self.gameObject, self.relationForce.x, self.relationForce.y, self.relationForce.z)
			end
		end

		self.transformComponent:SetCurPosition(self.CSharpArr[1], self.CSharpArr[2], self.CSharpArr[3])
	end

	local position = self.transformComponent.position
	local lastPosition = self.transformComponent.lastPosition
	-- if self.kCCCharacterProxy then
	-- 	position = self.kCCCharacterProxy.Position
	-- 	lastPosition = self.kCCCharacterProxy.LastPosition
	-- end

	--if not position:Equals(lastPosition) or not position:Equals(self.lastPosition) then
	local x, y, z
	if not Vec3.zero:Equals(lastPosition) then
		x, y, z = Vec3.LerpC(lastPosition, position, lerpTime)
	else
		x, y, z = position.x, position.y, position.z
	end
	if fixedY ~= 0 then
		-- LogError("origin y = "..y.." fusion = "..fixedY)
		self.transformComponent:SetPositionOffset(0, fixedY, 0)
	end

	if self.isLuaControlEntityMove then
		self:SetPositionByCSharpArr(x, y, z)
		if not self.firstSync then
			self.firstSync = true
			-- EntityLODManager.Instance:Async(self.clientEntity.entity.instanceId)
		end
	end

	self.moveFlag = true

		--self.lastPosition:SetA(position)
	--end

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

function ClientTransformComponent:ResetModelPos()
	self.offsetX = 0
	self.lastOffsetX = 0
	self.pivotYOffset = 0
	UnityUtils.SetLocalPosition(self.model, 0, 0, 0)
end

function ClientTransformComponent:UpdateRotate(lerpTime)
	-- 实机专供，渲染层影响逻辑层位移和旋转
	if not self.isLuaControlEntityMove then
		self.transformComponent.rotation:CopyValue(self.transform.rotation)
	end

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

	if self.isLuaControlEntityMove then
		Quat.LerpA(lastRotation, rotation, lerpTime, TempQuat)
		self:SetRotationByCSharpArr(TempQuat.x, TempQuat.y, TempQuat.z, TempQuat.w)
	end
	
	-- lua 欧拉角运行速度慢且产生GC，缓存记录
	self.eulerAngles:SetA(self.transform.eulerAngles)
	self.rotateFlag = true
end

function ClientTransformComponent:SetActive(flag)
	self.gameObject:SetActive(flag)
	if self.kCCCharacterProxy then
		self.kCCCharacterProxy:SetActive(flag)
	end
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

	self.gInstanceId = nil
	if not self.activityState then
		CustomUnityUtils.SetModelActive(self.gameObject, true)
	end
	self.rendLineComp = nil
	self.banKccMove = false
	self.activityState = true
	self.clientFight.fight.objectPool:Cache(ClientTransformComponent,self)
end

function ClientTransformComponent:SetTimeScale(timeScale)
	if self.effectUtil then
		self.effectUtil:SetSpeed(timeScale)
	end
end

function ClientTransformComponent:ResetTimeScale()
	if self.entity.timeComponent then
		-- timeScale = self.entity.timeComponent:GetTimeScale()
		self.entity.timeComponent:OnUpdateTimeScale()
		return
	end

	local timeScale = 1
	if self.effectUtil then
		self.effectUtil:SetSpeed(timeScale)
	end
end


function ClientTransformComponent:GetGroundMatLayer()
	local moveComponent = self.entity.moveComponent
	local isTouchWater = moveComponent:IsTouchWater()
	if isTouchWater then
		return TerrainMatLayerConfig.Layer.Water
	end

	local position = self.transformComponent.position
	local x = position.x
	local y = position.y
	local z = position.z

	if self.entity.stateComponent:IsState(FightEnum.EntityState.Climb) then
		local forward = self.transform.forward
		local gameObject = CS.PhysicsTerrain.GetRayCastObject(x,y,z,forward.x,forward.y,forward.z,1,-1)
		if gameObject then
			return ThingMatLayerConfig.GetMatLayer(gameObject, x, z)
		end
	end

	local gameObject =  CS.PhysicsTerrain.GetSphereCastObject(x, y + 0.5, z, 0.2, 0.5, ~FightEnum.LayerBit.Terrain)	
	if gameObject then
		return ThingMatLayerConfig.GetMatLayer(gameObject, x, z)
	end
	return TerrainMatLayerConfig.GetMatLayer(x, z)
end

function ClientTransformComponent:ReSetMeshRendererGetter()
	CustomUnityUtils.ReSetMeshRendererGetter(self.gameObject)
end

function ClientTransformComponent:BindWeapon(weaponId)
	if not self.clientEntity.weaponComponent then
		local component = self.clientFight.fight.objectPool:Get(ClientWeaponComponent)
		self.clientEntity.clientComponents["weaponComponent"] = component
		component:Init(self.clientFight, self.clientEntity, weaponId)
		component.name = "weaponComponent"
		self.clientEntity["weaponComponent"] = component
	else
		self.clientEntity.weaponComponent:ChangeWeapon(weaponId)
	end
end

function ClientTransformComponent:BindGlider(gliderId)
	local bindNode = "ItemCase_r"
	local moveComponent = self.entity.moveComponent
    if moveComponent and moveComponent.config.GlideBindNode and moveComponent.config.GlideBindNode ~= "" then
        bindNode = moveComponent.config.GlideBindNode
    end
	local bindTransform = self:GetTransform(bindNode)
	if bindTransform and bindTransform.childCount > 0 then
		for i = 0, bindTransform.childCount -1, 1 do
			GameObject.Destroy(bindTransform:GetChild(i).gameObject)
		end
	end

	local go = self.clientFight.assetsPool:Get("Character/Animal/Glider/Huaxiangsan/Huaxiangsan.prefab")
	self:SetTransformChild(go.transform, bindNode)
	--go.transform:SetParent(bindTransform)
	UnityUtils.SetLocalScale(go.transform, 1, 1, 1)
	-- 临时写一下
	local root = go.transform:Find("Huaxiangsan/Glider_Root")
	UnityUtils.SetLocalScale(root, 1, 1, 1)

	CustomUnityUtils.SetShadowRenderers(self.gameObject)

	return go
end

-- TODO 临时的缓存 后面添加装备缓存池后修改
function ClientTransformComponent:CacheGlider(go)
	if not go then
		return
	end

	self.clientFight.assetsPool:Cache("Character/Animal/Glider/Huaxiangsan/Huaxiangsan.prefab", go)
end

function ClientTransformComponent:SetMatKeyWord(keyWord, enable)
	CustomUnityUtils.SetMeshRendererKeyWord(self.gameObject, keyWord, enable)
end

function ClientTransformComponent:SetRigidBodyIsKinematic(isKinematic)
	if self.rigidbody then
		self.isKinematic = isKinematic
		self.rigidbody.isKinematic = isKinematic
		if not isKinematic then
			self.rigidbody.interpolation = RigidbodyInterpolation.Interpolate
		end
	end
end

function ClientTransformComponent:TempRemoveRigidBody()
	if self.rigidbody then
		GameObject.Destroy(self.rigidbody)
	end
	self.rigidbody = nil
end

function ClientTransformComponent:AddRigidBody()
	if not self.rigidbody then
		self.gameObject:AddComponent(Rigidbody)
		self.rigidbody = self.gameObject:GetComponent(Rigidbody)
		self.rigidbody.isKinematic = true
		self.rigidbody.collisionDetectionMode = CollisionDetectionMode.ContinuousSpeculative
	end
end

function ClientTransformComponent:SetRigidBodyUseGravity(isUse)
	if not self.rigidbody then
		return
	end
	self.rigidbody.useGravity = isUse
end

function ClientTransformComponent:AddConstantForceCmp()
	if not self.constantForce then
		self.gameObject:AddComponent(ConstantForce)
		self.constantForce = self.gameObject:GetComponent(ConstantForce)
	end
end

function ClientTransformComponent:RemoveConstantForceCmp()
	if not self.constantForce then
		GameObject.Destroy(self.constantForce)
	end
	self.constantForce = nil
end

function ClientTransformComponent:AddConstantForce(fx,fy,fz,Rfx,Rfy,Rfz)
	if not self.constantForce then
		self.gameObject:AddComponent(ConstantForce)
		self.constantForce = self.gameObject:GetComponent(ConstantForce)
	end
	self.force:AddXYZ(fx,fy,fz)
	self.relationForce:AddXYZ(Rfx,Rfy,Rfz)
end

function ClientTransformComponent:ResetConstantForce()
	self.force:Set(0,0,0)
	self.relationForce:Set(0,0,0)
end

function ClientTransformComponent:SetBakeData(bakeId)
	GraphicLightingRecord.Instance:SetDoorsLightMap(self.gameObject, bakeId)
	-- print("ClientTransformComponent bakeId "..bakeId)
end

function ClientTransformComponent:SetPositionByCSharpArr(x, y, z, isForce)
	if (self.isPauseUpdateTransform or not self.isLuaControlEntityMove) and not isForce then
		return
	end
	self.CSharpArr[1] = x
	self.CSharpArr[2] = y
	self.CSharpArr[3] = z
	self.CSharpArr[4] = 1
end

function ClientTransformComponent:SetRotationByCSharpArr(rx, ry, rz, rw, isForce)
	if (self.isPauseUpdateTransform or not self.isLuaControlEntityMove) and not isForce then
		return
	end
	self.CSharpArr[5] = rx or 0
	self.CSharpArr[6] = ry or 0
	self.CSharpArr[7] = rz or 0
	self.CSharpArr[8] = rw or 0
	self.CSharpArr[9] = 1
end

function ClientTransformComponent:GetEntityLODLevel()
	return self.CSharpArr[10]
end

--
function ClientTransformComponent:GetEntityWithPlayerDistance()
	return self.CSharpArr[11]
end

function ClientTransformComponent:BanKccMove(ban)
	if self.banKccMove ~= ban then
		self.banKccMove = ban
		if self.kCCCharacterProxyGO then
			self.kCCCharacterProxyGO:SetActive(not ban)
		end
	end
end

function ClientTransformComponent:SetLuaControlEntityMove(isLuaControl)
	local last = self.isLuaControlEntityMove
	self.isLuaControlEntityMove = isLuaControl
	self.CSharpArr[12] = isLuaControl and 1 or 0
	if isLuaControl == last then
		return
	end
	if self.kCCCharacterProxyGO then
		self:BanKccMove(not isLuaControl)
	end
	if isLuaControl then
		self.transformComponent:SetPosition(self.CSharpArr[1], self.CSharpArr[2], self.CSharpArr[3])
	else
		self:SetPositionByCSharpArr(self.transformComponent.position.x, self.transformComponent.position.y, self.transformComponent.position.z, true)
		self:SetRotationByCSharpArr(self.transformComponent.rotation.x, self.transformComponent.rotation.y, self.transformComponent.rotation.z, self.transformComponent.rotation.w, true)
		EntityLODManager.Instance:Async(self.entity.instanceId)
	end
end

function ClientTransformComponent:GetIsLuaControlEntityMove()
	return self.isLuaControlEntityMove
end

function ClientTransformComponent:SetMaterialMeshValue(name,value1,value2,value3,value4)
    for i = 1, self.materialMeshs.Length, 1 do
	   self.materialMeshs[i-1]:SetPropertyValue(name,value1,value2,value3,value4)
	end
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
	if self.rigidbody then
		self.rigidbody = nil
	end
	EntityLODManager.Instance:OnRemoveEntity(self.entity.instanceId)
	self.clientFight.fight.objectPool:Cache(SmallLuaCSharpArr, self.smallLuaCSharpArr)

	self.tag = FightEnum.EntityTag.None
	self.gameObject = nil
	self.bindTransform = nil
	self.bindPosFixY = nil
	self.bindOffset = nil
	self.bindTimeMode = nil
	self.bindParentMode = nil
	self.forcePosition = nil
	self.forceRotation = nil
	self.forceLocation = nil
	self.effectHang = nil
	self.forceRotateY = nil
	self.relationTrasnform1 = nil
	self.relationTrasnform2 = nil
	self.collistionComponent = nil
	self.weaponFollowCmpList = nil

	self.getHeadTransform = nil
	self.headTransform = nil
	self.model = nil
	self.isKinematic = true
	self.isLuaControlEntityMove = true

	self.entityTranslucent = nil

	self.firstSync = false
	self.CSharpArr = nil
	self.smallLuaCSharpArr = nil
	self.kCCCharacterProxy = nil
	GameObject.DestroyImmediate(self.kCCCharacterProxyGO)
	self.kCCCharacterProxyGO = nil
	TableUtils.ClearTable(self.hideBone)
	TableUtils.ClearTable(self.hideGroup)
	TableUtils.ClearTable(self.cacheTransform)
	TableUtils.ClearTable(self.cacheGroupTransform)
	self.eulerAngles:Set(0,0,0)
	self.lastPosition:Set(0,0,0)
	self.lastRotation:Set(0,0,0,0)
	
	local poolOwner = self.entity.parent ~= nil and self.entity.parent.entityId or self.entity.entityId
	if not UtilsBase.IsNull(self.transform) and not ClientTransformComponent.HideEffect then
		if self.info.isClone then
			GameObject.Destroy(self.transform.gameObject)
		else
			--UnityUtils.SetPosition(self.transform, 0, 0, 0)
			self.clientFight.assetsPool:Cache(self.path, self.transform.gameObject)
		end
	end
end

function ClientTransformComponent:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end