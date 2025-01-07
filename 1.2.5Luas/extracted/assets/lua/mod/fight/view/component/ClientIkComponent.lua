---@class ClientIkComponent
ClientIkComponent = BaseClass("ClientIkComponent",PoolBaseClass)

local CombinationRoot = FightEnum.CombinationRoot

function ClientIkComponent:__init()
	self.lookTargetEnterMap = {}
	self.lookedEntityMap = {}
end

function ClientIkComponent:Init(clientFight, clientEntity)
	self.clientEntity = clientEntity
	self.transform = self.clientEntity.clientTransformComponent:GetTransform()
	self.config = self.clientEntity.entity:GetComponentConfig(FightEnum.ComponentType.Ik)

	self.lookConfig = self.config.Look
	if self.lookConfig then
		self.isLookCtrlObject = self.lookConfig.IsLookCtrlObject
	end

	self.lookedConfig = self.config.Looked

	self.ikBoneShake = self.transform:GetComponentInChildren(CS.IKBoneShake)
end

function ClientIkComponent:LateInit()
	if self.lookConfig then
		self.lookAtController = self.transform:GetComponentInChildren(LookAtController)
	end

	if self.lookedConfig then
		self.lookedEnable = true
		self.lookedTransform = self.clientEntity.clientTransformComponent:GetTransform(self.lookedConfig.lookTransform)
	end

	self:OnSwitchPlayerCtrl()
end


function ClientIkComponent:OnSwitchPlayerCtrl()
	if self.isLookCtrlObject then
		local entity = Fight.Instance.playerManager:GetPlayer():GetCtrlEntityObject() 
		self:SetLookIKTarget(entity.instanceId)
	end
end

function ClientIkComponent:AttackShake(shakDir, strength, attackInstanceId)
	local entity = self.clientEntity.entity
	local targetEntity =  Fight.Instance.entityManager:GetEntity(attackInstanceId)
	local pos = entity.transformComponent.position
	local targetPos = targetEntity.transformComponent.position
	local rotation = entity.transformComponent.rotation
	local angle = CustomUnityUtils.AngleSigned(rotation * Vec3.forward, targetPos - pos) % 360
	local isFrontAttack = angle <= 90 or angle >= 270

	local shakeId, shakeDirType
	if shakDir == FightEnum.AttackShakeDir.Left then
		if isFrontAttack then
			shakeId = self.config.shakeLeftFrontId
			shakeDirType = FightEnum.AttackShakeDir.LeftFront
		else
			shakeId = self.config.shakeLeftBackId
			shakeDirType = FightEnum.AttackShakeDir.LeftBack
		end
	else
		if isFrontAttack then
			shakeId = self.config.shakeRightFrontId
			shakeDirType = FightEnum.AttackShakeDir.RightFront
		else
			shakeId = self.config.shakeRightBackId
			shakeDirType = FightEnum.AttackShakeDir.RightBack
		end
	end

	self:PlayShake(shakeId, strength, shakeDirType)
end

function ClientIkComponent:PlayShake(shakeId, strength, shakeDirType)
	if self.ikBoneShake then
		self.ikBoneShake:PlayIKShake(shakeId, strength, shakeDirType)
	end
end

function ClientIkComponent:StopPlayShake()
	if self.ikBoneShake then
		self.ikBoneShake:StopPlayShake(0)
	end
end

function ClientIkComponent:SetHeadIkVisible(enabled)
	self:SetLookEnable(enabled)
end

function ClientIkComponent:SetLookIKTargetPos(targetPos)
	if not self.targetPosCube then
		self.targetPosCube = Fight.Instance.clientFight.assetsPool:Get("Prefabs/Collider/Cube.prefab").transform
	end
	CustomUnityUtils.SetPosition(self.targetPosCube, targetPos.x, targetPos.y, targetPos.z)

	self.lookInstanceId = 0
	self:_SetLookIKTarget(self.targetPosCube, self.targetPosCube)
end


function ClientIkComponent:SetLookIKTarget(targetInstanceId)
	local entity = Fight.Instance.entityManager:GetEntity(targetInstanceId)
	if not entity then
		return
	end

	if targetInstanceId == self.lookInstanceId then
		return
	end

	local target = entity.clientEntity.clientIkComponent.lookedTransform
	if not target then
		return
	end

	self.lookInstanceId = targetInstanceId
	self:_SetLookIKTarget(target, target)
end

function ClientIkComponent:RemoveLookIKTarget()
	self.lookInstanceId = nil
	self:UpdateLookEnterTarget()
end

function ClientIkComponent:SetLookTargetEnter(targetInstanceId, isEnter, weight)
	local entity = Fight.Instance.entityManager:GetEntity(targetInstanceId)
	if not entity then
		return
	end

	if isEnter then
		local clientIkComponent = entity.clientEntity.clientIkComponent
		if not clientIkComponent or not clientIkComponent.lookedEnable then
			return
		end

		weight = weight or clientIkComponent.lookedConfig.weight
		self.lookTargetEnterMap[entity.instanceId] = weight or 0
		clientIkComponent:AddLookedEntity(self.clientEntity.entity.instanceId)
	else
		self.lookTargetEnterMap[entity.instanceId] = nil
	end

	local lookInsId = nil
	self.lookEnterInsId = nil
	local cmpWeght = -1	
	for k, weight in pairs(self.lookTargetEnterMap) do
		if cmpWeght == -1 or cmpWeght < weight then
			cmpWeght = weight
			self.lookEnterInsId = k
		end 
	end

	self:UpdateLookEnterTarget()
end

function ClientIkComponent:UpdateLookEnterTarget()
	if not self.lookInstanceId then
		if self.lookEnterInsId then
			local entity = Fight.Instance.entityManager:GetEntity(self.lookEnterInsId)
			if entity then
				local target = entity.clientEntity.clientIkComponent.lookedTransform
				self:_SetLookIKTarget(target, target)
			end
		else
			self:_SetLookIKTarget()
		end
	end
end

function ClientIkComponent:_SetLookIKTarget(rootTarget, target)
	self.lookTarget = rootTarget
	if rootTarget then
		CustomUnityUtils.SetIkLookAt(self.lookAtController, rootTarget, target)
	else
		CustomUnityUtils.RemoveIkLookAt(self.lookAtController)
	end
end

function ClientIkComponent:SetLookEnable(enabled)
	if self.lookAtController then
		local weight = enabled and 1 or 0
		CustomUnityUtils.SetIkLookAtWeight(self.lookAtController, weight)
	end
end

function ClientIkComponent:AddLookedEntity(instanceId)
	self.lookedEntityMap[instanceId] = true
end

function ClientIkComponent:SetLookedEnable(enabled)
	self.lookedEnable = enabled

	if not self.lookedEnable then
		for k, v in pairs(self.lookedEntityMap) do
			local entity = BehaviorFunctions.fight.entityManager:GetEntity(k)
			if entity then
				entity.clientEntity.clientIkComponent:SetLookTargetEnter(self.clientEntity.entity.instanceId, false)
			end
		end
		TableUtils.ClearTable(self.lookedEntityMap)
	end
end

function ClientIkComponent:OnCache()
	if self.targetPosCube then
		Fight.Instance.clientFight.assetsPool:Cache("Prefabs/Collider/Cube.prefab", self.targetPosCube)
		self.targetPosCube = nil
	end

	self.ikBoneShake = nil
	self.lookedConfig = nil

	TableUtils.ClearTable(self.lookedEntityMap)
	TableUtils.ClearTable(self.lookTargetEnterMap)
end

function ClientIkComponent:__cache()

end

function ClientIkComponent:__delete()

end



