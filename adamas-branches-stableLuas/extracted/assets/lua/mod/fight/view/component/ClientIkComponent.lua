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
	self.lookEnable = true
	self.ikBoneShake = self.transform:GetComponentInChildren(CS.IKBoneShake)
	self.fullBodyBipedIK = self.transform:GetComponentInChildren(FullBodyBipedIK)
	local Grounder_FBBIK = self.clientEntity.clientTransformComponent:GetTransform("Grounder_FBBIK")
	if Grounder_FBBIK and not UtilsBase.IsNull(Grounder_FBBIK) then
		self.grounderFBBIK = Grounder_FBBIK:GetComponentInChildren(GrounderFBBIK)
	end

	local Bip001 = self.clientEntity.clientTransformComponent:GetTransform("Bip001")
	if Bip001 and not UtilsBase.IsNull(Bip001) then
		self.genericPoser = Bip001:GetComponentInChildren(GenericPoser)
	end
	self.oneHandAimEnable = false
	self.twoHandAimEnable = false
end

function ClientIkComponent:SetGrounderFBBIKActive(active)
	-- todo 暂停脚步ik
	do
		return
	end
	if self.fullBodyBipedIK then
		self.fullBodyBipedIK.enabled = active;
	end
	if self.grounderFBBIK then
		self.grounderFBBIK.enabled = active;
		if active then
			CustomUnityUtils.SetGrounderWeightFade(self.grounderFBBIK, 0, 1, 0.5)
		end
	end
end

function ClientIkComponent:SetGenericPoser(targetBip,active,startValue,endValue,duration,ease)
	if self.genericPoser then
		self.genericPoser.enabled = active;
		if active and targetBip then
			CustomUnityUtils.SetGenericPoserFade(self.genericPoser,targetBip, startValue, endValue, duration, ease)
		end
	end
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
		if entity then
			self:SetLookIKTarget(entity.instanceId)
		end
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
	
	local entity = self.clientEntity.entity
	local immuneHit
	if entity.buffComponent then
		immuneHit = entity.buffComponent:CheckState(FightEnum.EntityBuffState.AbsoluteImmuneHit) or
		(entity.buffComponent:CheckState(FightEnum.EntityBuffState.ImmuneHit) and
		not entity.buffComponent:CheckState(FightEnum.EntityBuffState.ForbiddenImmuneHit))
	end
	if self.ikBoneShake and (immuneHit or self.config.workWithOutImmuneHit)then
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
	self:SetLookFinalIKTarget(self.targetPosCube, self.targetPosCube)
end


function ClientIkComponent:SetLookIKTarget(targetInstanceId)
	local entity = Fight.Instance.entityManager:GetEntity(targetInstanceId)
	if not entity then
		return
	end

	if targetInstanceId == self.lookInstanceId then
		return
	end

	local target = entity.clientIkComponent.lookedTransform
	if not target then
		return
	end

	self.lookInstanceId = targetInstanceId
	self:SetLookFinalIKTarget(target, target)
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
		local clientIkComponent = entity.clientIkComponent
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
				local target = entity.clientIkComponent.lookedTransform
				self:SetLookFinalIKTarget(target, target)
			end
		else
			self:SetLookFinalIKTarget()
		end
	end
end

function ClientIkComponent:SetLookFinalIKTarget(rootTarget, target)
	self.lookTarget = rootTarget
	if rootTarget then
		CustomUnityUtils.SetIkLookAt(self.lookAtController, rootTarget, target)
	else
		CustomUnityUtils.RemoveIkLookAt(self.lookAtController)
	end
end

local notLookStates = 
{
	FightEnum.EntityState.Hit,
	FightEnum.EntityState.Stun
}

function ClientIkComponent:CheckStateLookEnable(notCheckState)
	local stateComponent = self.clientEntity.entity.stateComponent
	for k, v in pairs(notLookStates) do
		if notCheckState and notCheckState == v then
			goto continue
		end
		
		if stateComponent:IsState(v) then
			return false
		end
		
		:: continue ::
	end

	return true
end

function ClientIkComponent:SetStateLookEnable(enabled, notCheckState)
	if not self.lookEnable then
		return
	end
	
	if enabled and not self:CheckStateLookEnable(notCheckState) then
		return
	end

	if self.lookAtController then
		local weight = enabled and 1 or 0
		CustomUnityUtils.SetIkLookAtWeight(self.lookAtController, weight)
	end
end

function ClientIkComponent:SetLookEnable(enabled)
	self.lookEnable = enabled
	if enabled and not self:CheckStateLookEnable() then
		return
	end

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

-- 瞄准单手IK
function ClientIkComponent:SetOneHandAim(enabled)
	if self.oneHandAimEnable == enabled then
		return
	end
	self.oneHandAimEnable = enabled

	local aimSingleHand = self.config.AimSingleHand
	self:SetAimLookAt(aimSingleHand, enabled)

	if enabled then
		if not self.singleHandAim then
			local transform = self.clientEntity.clientTransformComponent:GetTransform(aimSingleHand.Aim.transform)
			self.singleHandAim = transform:GetComponent(AimController)
		end
		CustomUnityUtils.SetAimBoneWeight(self.singleHandAim, 0, aimSingleHand.Aim.Spine1Weight)
		CustomUnityUtils.SetAimBoneWeight(self.singleHandAim, 1, aimSingleHand.Aim.Spine2Weight)
	end
end

-- 瞄准双手IK
function ClientIkComponent:SetTwoHandAim(enabled)
	if self.twoHandAimEnable == enabled then
		return
	end
	self.twoHandAimEnable = enabled

	local aimTwoHand = self.config.AimTwoHand
	self:SetAimLookAt(aimTwoHand, enabled)
	if enabled then
		if not self.handAim1 then
			local transform = self.clientEntity.clientTransformComponent:GetTransform(aimTwoHand.AimL.transform)
			self.handAim1 = transform:GetComponent(AimController)
		end
		CustomUnityUtils.SetAimBoneWeight(self.handAim1, 0, aimTwoHand.AimL.Spine1Weight)
		CustomUnityUtils.SetAimBoneWeight(self.handAim1, 1, aimTwoHand.AimL.Spine2Weight)

		if not self.handAim2 then
			local transform = self.clientEntity.clientTransformComponent:GetTransform(aimTwoHand.AimR.transform)
			self.handAim2 = transform:GetComponent(AimController)
		end
		CustomUnityUtils.SetAimBoneWeight(self.handAim2, 0, aimTwoHand.AimR.Spine1Weight)
		CustomUnityUtils.SetAimBoneWeight(self.handAim2, 1, aimTwoHand.AimR.Spine2Weight)
	end
end

function ClientIkComponent:StopHandAim()
	self.oneHandAimEnable = false
	self.twoHandAimEnable = false
	self:SetAimLookAt(nil, false)
end


function ClientIkComponent:SetAimLookAt(config, enabled)
	if enabled then
		self.backLookDegreeUpX = self.lookAtController.IKDegreeUpX
		self.backLookDegreeDownX = self.lookAtController.IKDegreeDownX
		self.backLookWeightSmoothTime = self.lookAtController.weightSmoothTime
		self.backRootMaxTargetDist = self.lookAtController.RootMaxTargetDist

		self.lookAtController.IKDegreeUpX = config.DegreeUpX
		self.lookAtController.IKDegreeDownX = config.DegreeDownX
		self.lookAtController.weightSmoothTime = config.WeightSmoothTime
		self.lookAtController.targetSwitchSmoothTime = config.WeightSmoothTime
		self.lookAtController.RootMaxTargetDist = 1000
		self.lookAtController.smoothTurnTowardsTarget = false
	else
		self.lookAtController.IKDegreeUpX = self.backLookDegreeUpX 
		self.lookAtController.IKDegreeDownX = self.backLookDegreeDownX 
		self.lookAtController.weightSmoothTime = self.backLookWeightSmoothTime 
		self.lookAtController.RootMaxTargetDist = self.backRootMaxTargetDist
		self.lookAtController.targetSwitchSmoothTime = self.backLookWeightSmoothTime
		self.lookAtController.smoothTurnTowardsTarget = true
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





-- Assets/Things/AssetsData/PostProcessTemplate.asset
-- 133492677793113136133492432355086793