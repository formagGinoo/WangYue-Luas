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
			self.entity.owner = self.entity
		end
		self.fight.entityManager:AddBioEntity(self.entity)
	end
end

function TagComponent:OnCache()
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



-- EntityTempMenu

