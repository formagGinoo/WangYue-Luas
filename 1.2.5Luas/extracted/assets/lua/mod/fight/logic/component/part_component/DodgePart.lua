DodgePart = BaseClass("DodgePart", PartBase)

function DodgePart:Init(fight, entity, config)
	self:BaseFunc("Init", fight, entity, config)

	self.colliderFollow = config.ColliderFollow or 0
	
	self.cacheEnties = {}
end

function DodgePart:InitCollider()
	self.layer = FightEnum.Layer.IgonreRayCastLayer
	self.isTrigger = true
	self.triggerType = FightEnum.TriggerType.Fight
	self.checkLayer = FightEnum.LayerBit.Entity

	for k, v in pairs(self.config.BoneColliders) do
		self:CreateCollider(v, true)
	end
end

function DodgePart:OnCache()
	self:BaseFunc("DestroyCollider")
	TableUtils.ClearTable(self.cacheEnties)

	self.fight.objectPool:Cache(DodgePart,self)
end

function DodgePart:GetTriggerEntity()
	TableUtils.ClearTable(self.cacheEnties)
	local entityManager = self.fight.entityManager
	for _, collider in pairs(self.colliderList) do
		local triggerData = self.entity:GetTriggerData(collider.triggerType, collider.colliderObjInsId)
		if triggerData then
			for k, _ in pairs(triggerData) do
				local entity = entityManager:GetColliderEntity(k)
				if entity then
					self.cacheEnties[k] = entity
					--table.insert(self.cacheEnties, entity)
				end
			end
		end
	end
	
	return self.cacheEnties
end