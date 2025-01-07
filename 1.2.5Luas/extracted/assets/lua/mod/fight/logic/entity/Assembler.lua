Assembler = BaseClass("Assembler")

local ComponentType = FightEnum.ComponentType

function Assembler:__init(fight)
	self.fight = fight
end

function Assembler:CreateEntity(instanceId,entityId,owner, sInstanceId, params)
	local entity = self.fight.objectPool:Get(Entity)
	if owner then
		entity.owner = owner
	end

	entity:Init(self.fight,instanceId,entityId, sInstanceId, params)
	UnityUtils.BeginSample("CreateComponents_"..entityId)
	self:CreateComponents(entity)
	UnityUtils.EndSample()
	UnityUtils.BeginSample("InitComponents_"..entityId)
	entity:InitComponents()
	UnityUtils.EndSample()
	if ctx then
		UnityUtils.BeginSample("BingClientEntity_"..entityId)
		self:BingClientEntity(entity)
		UnityUtils.EndSample()
	end

	if entity.moveComponent then
		entity.moveComponent:Init(self.fight,entity)
	end

	if entity.swimComponent then
		entity.swimComponent:Init(self.fight,entity)
	end

	if entity.climbComponent then
		entity.climbComponent:Init(self.fight,entity)
	end

	if entity.deathComponent then
		entity.deathComponent:Init(self.fight, entity)
	end

	--entity:LateInitComponents()
	return entity
end

function Assembler:CreateComponents(entity)
	self:AddComponent(entity, "behaviorComponent", ComponentType.Behavior, BehaviorComponent)
	self:AddComponent(entity, "transformComponent", ComponentType.Transform, TransformComponent)
	self:AddComponent(entity, "animatorComponent", ComponentType.Animator, AnimatorComponent)
	self:AddComponent(entity, "campComponent", ComponentType.Camp, CampComponent)
	self:AddComponent(entity, "collistionComponent", ComponentType.Collision, CollistionComponent)
	self:AddComponent(entity, "attackComponent", ComponentType.Attack, AttackComponent)
	self:AddComponent(entity, "partComponent", ComponentType.Part, PartComponent)
	self:AddComponent(entity, "skillComponent", ComponentType.Skill, SkillComponent)
	self:AddComponent(entity, "pasvComponent", ComponentType.Pasv, PasvComponent)
	self:AddComponent(entity, "stateComponent", ComponentType.State, StateComponent)
	self:AddComponent(entity, "rotateComponent", ComponentType.Rotate, RotateComponent)
	self:AddComponent(entity, "timeoutDeathComponent", ComponentType.TimeoutDeath, TimeoutDeathComponent)
	self:AddComponent(entity, "timeComponent", ComponentType.Time, TimeComponent, true)
	self:AddComponent(entity, "moveComponent", ComponentType.Move, MoveComponent)
	self:AddComponent(entity, "hitComponent", ComponentType.Hit, HitComponent)
	self:AddComponent(entity, "buffComponent", ComponentType.Buff, BuffComponent, true)
	self:AddComponent(entity, "attrComponent", ComponentType.Attributes, AttributesComponent)
	self:AddComponent(entity, "handleMoveInputComponent", ComponentType.HandleMoveInput, HandleMoveInputComponent)
	self:AddComponent(entity, "tagComponent", ComponentType.Tag, TagComponent)
	self:AddComponent(entity, "dodgeComponent", ComponentType.Dodge, DodgeComponent)
	self:AddComponent(entity, "triggerComponent", ComponentType.Trigger, TriggerComponent)
	self:AddComponent(entity, "skillSetComponent", ComponentType.SkillSet, SkillSetComponent)
	self:AddComponent(entity, "createEntityComponent", ComponentType.CreateEntity, CreateEntityComponent, true)
	self:AddComponent(entity, "combinationComponent", ComponentType.Combination, CombinationComponent)
	self:AddComponent(entity, "climbComponent", ComponentType.Climb, ClimbComponent)
	self:AddComponent(entity, "aimComponent", ComponentType.Aim, AimComponent)
	self:AddComponent(entity, "swimComponent", ComponentType.Swim, SwimComponent)
	self:AddComponent(entity, "deathComponent", ComponentType.Death, DeathComponent)
	self:AddComponent(entity, "reboundAttackComponent", ComponentType.ReboundAttack, ReboundAttackComponent)
	self:AddComponent(entity, "elementStateComponent", ComponentType.ElementState, ElementStateComponent)
	self:AddComponent(entity, "findPathComponent", ComponentType.FindPath, FindPathComponent)
	self:AddComponent(entity, "conditionComponent", ComponentType.Condition, ConditionComponent)
	self:AddComponent(entity, "commonBehaviorComponent", ComponentType.CommonBehavior, CommonBehaviorComponent)
	self:AddComponent(entity, "TpComponent", ComponentType.Tp, TpComponent, true)
	self:AddComponent(entity, "hackingInputHandleComponent", ComponentType.HackingInputHandle, HackingInputHandleComponent, true)
	self:AddComponent(entity, "customFSMComponent", ComponentType.CustomFSM, CustomFSMComponent, true)
end

function Assembler:AddComponent(entity, componentName, componentType, componentClass, bInit)
	if entity:GetComponentConfig(componentType) then
		UnityUtils.BeginSample("AddComponent_"..entity.entityId)
		
		local component = self.fight.objectPool:Get(componentClass)
		entity.components[componentType] = component

		component.name = componentName
		entity[componentName] = component

		if bInit then
			component:Init(self.fight, entity)
		end
		UnityUtils.EndSample()
		return component
	end
end

function Assembler:BingClientEntity(entity)
	--TODO ClientEntity Pool
	if ctx then
		UnityUtils.BeginSample("BingClientEntity"..entity.entityId)
		local clientEntity = self.fight.objectPool:Get(ClientEntity)
		clientEntity:Init(self.fight.clientFight,entity)
		entity.clientEntity = clientEntity
		clientEntity.entity = entity
		self:CreateClientComponents(clientEntity)
		self.fight.clientFight.clientEntityManager:AddClientEntity(clientEntity)

		for k, v in pairs(clientEntity.clientComponents) do
			if v.LateInit then
				v:LateInit()
			end
		end
		UnityUtils.EndSample()
	end
end

function Assembler:CreateClientComponents(clientEntity)
	local entityId = clientEntity.entity.entityId
	self:AddClientComponent(clientEntity, entityId, ComponentType.Transform, "clientTransformComponent", ClientTransformComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.Sound, "clientSoundComponent", ClientSoundComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.Animator, "clientAnimatorComponent", ClientAnimatorComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.FollowHalo, "clientFollowHaloComponent", ClientFollowHaloComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.Effect, "clientEffectComponent", ClientEffectComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.Buff, "clientBuffComponent", ClientBuffComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.Ik, "clientIkComponent", ClientIkComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.LifeBar, "clientLifeBarComponent", ClientLifeBarComponent)
	self:AddClientComponent(clientEntity, entityId, ComponentType.Camera, "clientCameraComponent", ClientCameraComponent)
end

function Assembler:AddClientComponent(clientEntity, entityId, componentType, componentName, componentClass)
	local configInfo = clientEntity.entity:GetComponentConfig(componentType)
	if ctx then
		if configInfo then
			local component = self.fight.objectPool:Get(componentClass)
			clientEntity.clientComponents[componentName] = component
			UnityUtils.BeginSample("ClientComponent:Init_"..componentName)
			component:Init(self.fight.clientFight, clientEntity, configInfo)
			UnityUtils.EndSample()
			component.name = componentName
			clientEntity[componentName] = component

			return component
		end	
	end
end

function Assembler:__delete()
end