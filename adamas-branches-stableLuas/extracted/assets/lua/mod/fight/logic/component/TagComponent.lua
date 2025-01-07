---@class TagComponent
TagComponent = BaseClass("TagComponent",PoolBaseClass)

function TagComponent:__init()
end

function TagComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.Tag)
	self.tag = self.config.Tag
	self.npcTag = self.config.NpcTag
	self.partTag = self.config.PartTag
	self.sceneObjectTag = self.config.SceneObjectTag
	if self.tag == FightEnum.EntityTag.Npc then
		if self.npcTag ~= FightEnum.EntityNpcTag.Partner then
			self.entity.parent = self.entity
			self.entity.root = self.entity
		end
		self.fight.entityManager:AddTagEntity(self.npcTag, self.entity)
	end

	self.camp = self.config.Camp
end

function TagComponent:OnCache()
	if self.tag == FightEnum.EntityTag.Npc then
		self.fight.entityManager:RemoveTagEntity(self.npcTag, self.entity)
	end
	self.fight.objectPool:Cache(TagComponent,self)
end

function TagComponent:__cache()
	self.fight = nil
	self.entity = nil
	self.tag = nil
	self.npcTag = nil
end

function TagComponent:__delete()

end

function TagComponent:SetCamp(camp)
	self.camp = camp
end

function TagComponent:IsNpc()
	if self.tag ~= FightEnum.EntityTag.Npc then
		return false
	end

	return self.npcTag == FightEnum.EntityNpcTag.NPC
end

function TagComponent:IsMonster()
	if self.tag ~= FightEnum.EntityTag.Npc then
		return false
	end

	return self.npcTag == FightEnum.EntityNpcTag.Monster or self.npcTag == FightEnum.EntityNpcTag.Boss or self.npcTag == FightEnum.EntityNpcTag.Elite
end

function TagComponent:IsPlayer()
	if self.tag ~= FightEnum.EntityTag.Npc then
		return false
	end

	return self.npcTag == FightEnum.EntityNpcTag.Player
end

function TagComponent:IsPartner()
	if self.tag ~= FightEnum.EntityTag.Npc then
		return false
	end

	return self.npcTag == FightEnum.EntityNpcTag.Partner
end

function TagComponent:IsNeedEntityTranslucent()
	return self:IsNpc() or self:IsMonster() or self:IsPlayer() or self:IsPartner() or self.npcTag == FightEnum.EntityNpcTag.Car
end

function TagComponent:CheckIsCanMoveUpTag()
	return self:IsNpc() or self:IsMonster() or self:IsPlayer() or self:IsPartner()
end

function TagComponent:IsCanHitObj()
	return self.sceneObjectTag == FightEnum.EntitySceneObjTag.CanHitObj
end

function TagComponent:ChangeNpcTag(tag)
	self.npcTag = tag
end

function TagComponent:GetMonsterAttackType()
	local monsterId = self.entity.masterId or 0
	local monsterCfg = Config.DataMonster.Find[monsterId]
	if not monsterCfg then
		return self.config.AttackType
	end

	return monsterCfg.attack_type
end

function TagComponent:GetMonsterPriority()
	local monsterId = self.entity.masterId or 0
	local monsterCfg = Config.DataMonster.Find[monsterId]
	if not monsterCfg then
		return self.config.Priority
	end

	return monsterCfg.priority
end
-- EntityTempMenu

