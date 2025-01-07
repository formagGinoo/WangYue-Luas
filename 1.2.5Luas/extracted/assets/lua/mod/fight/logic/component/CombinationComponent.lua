---@class CombinationComponent
CombinationComponent = BaseClass("CombinationComponent",PoolBaseClass)

local CombinationRoot = FightEnum.CombinationRoot

function CombinationComponent:__init()
end

function CombinationComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.childEntity = nil
	self.parentEntity = nil
	self.dmgParent = false
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Combination)

	-- print("CombinationComponent Init" ..self.entity.entityId)
end

function CombinationComponent:LateInit()
	self.transform = self.entity.clientEntity.clientTransformComponent:GetTransform()
end

function CombinationComponent:Update()
	if self.parentPartComponent then
		local position = self.transform.position
		self.entity.transformComponent:SetPosition(position.x, position.y, position.z)
	end
end

function CombinationComponent:SetCombinationChild(entity, dmgParent)
	self.dmgParent = dmgParent 
	self.childEntity = entity
	self.combinationInsid = entity.instanceId
end

function CombinationComponent:RemoveCombination()
	if self.parentEntity then
		local position = self.parentTransformComponent.position
		self.parentTransformComponent = nil
		self.parentPartComponent = nil
		if self.dmgParent then
			self.entity.stateComponent.backstage = FightEnum.Backstage.Foreground
			local part = self.parentPartComponent.partComponent:GetPart(CombinationRoot)
			part:SetLogicVisible(false)
		end

		self.transform:SetParent(self.fight.clientFight.clientEntityManager.entityRoot.transform)
		CustomUnityUtils.SetShadowRenderersEnable(self.transform.gameObject, true)

		local parentGo = self.parentEntity.clientEntity.clientTransformComponent:GetGameObject()
		CustomUnityUtils.SetShadowRenderersEnable(parentGo, true)

		self.parentEntity = nil

		if ctx then
			self.entity.clientEntity.clientTransformComponent:SetRotationFollower(nil)
		end
	end

	self.dmgParent = nil
	self.childEntity = nil 
end

function CombinationComponent:SetCombinationParent(entity, dmgParent)
	self.dmgParent = dmgParent 
	self.parentEntity = entity
	self.parentTransformComponent = entity.transformComponent
	self.parentPartComponent = entity.partComponent
	self.combinationInsid = entity.instanceId
	-- 伤害合体走部位规则, 子对象只用于表现
	if self.dmgParent then
		self.entity.stateComponent.backstage = FightEnum.Backstage.Combination
		local part = self.parentPartComponent:GetPart(CombinationRoot)
		-- part:SetLogicLock(true)
		part:SetLogicVisible(true)
	end

	if ctx then
		local clientEntity = self.entity.clientEntity
		local transformParent = self.parentEntity.clientEntity.clientTransformComponent:GetTransform(CombinationRoot)
		self.transform:SetParent(transformParent)
		self.transform:ResetAttr()
		CustomUnityUtils.SetShadowRenderersEnable(self.transform.gameObject, false)
		CustomUnityUtils.SetShadowRenderersEnable(transformParent.gameObject, true)

		if not self.animatorController then
			self.animatorController = self.fight.clientFight.assetsPool:Get(self.config.Animator)
			if self.config.AnimatorName then
				self.entity.moveComponent.moveComponent:InitAnimationData(self.config.AnimatorName)
			end
		end
		clientEntity.clientAnimatorComponent:SetController(self.animatorController)
		clientEntity.clientTransformComponent:SetRotationFollower(self.parentEntity.clientEntity.clientTransformComponent:GetTransform())
	end

	self:Update()
end

function CombinationComponent:PlayAnimation(name)
	if self.childEntity then
		self.childEntity.animatorComponent:PlayAnimation(name)
	end
end

function CombinationComponent:CombinationIngParent()
	return self.parentEntity ~= nil
end

function CombinationComponent:GetParentAttacked()
	if self.dmgParent then
		return self.parentEntity
	end
end

function CombinationComponent:OnCache()
	self.childEntity = nil
	self.parentEntity = nil
	self.fight.objectPool:Cache(CombinationComponent,self)
end

function CombinationComponent:__cache()
	CustomUnityUtils.SetShadowRenderersEnable(self.transform.gameObject, true)
	-- self.fight.clientFight.assetsPool:Cache(self.config.Animator, self.animatorController)
end

function CombinationComponent:__delete()
end