ColliderPart = BaseClass("ColliderPart", PartBase)

function ColliderPart:Init(fight, entity, config)
	self:BaseFunc("Init", fight, entity, config)
	
	self.colliderFollow = config.ColliderFollow or 0
end

function ColliderPart:InitCollider()
	self.layer = FightEnum.Layer.EntityCollision
	local isPlayer = self.entity.tagComponent and self.entity.tagComponent.npcTag == FightEnum.EntityNpcTag.Player
	local isLevelEntity = self.fight.entityManager:CheckEntityIsBelongLevel(self.entity.instanceId)
	local isJointOrHacking = self.entity.tagComponent and self.entity.tagComponent.tag == FightEnum.EntityTag.SceneObj and
			self.entity.tagComponent.sceneObjectTag == FightEnum.EntitySceneObjTag.HackOrBuild
	if isPlayer or isLevelEntity or isJointOrHacking then
		self.isTrigger = true
		self.triggerType = FightEnum.TriggerType.Terrain
		self.checkLayer = FightEnum.LayerBit.InRoom | FightEnum.LayerBit.Area
	end
	
	for k, v in pairs(self.config.BoneColliders) do
		self:CreateCollider(v)
	end
end

function ColliderPart:OnCache()
	self:BaseFunc("DestroyCollider")
	self.fight.objectPool:Cache(ColliderPart,self)
end