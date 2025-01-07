---@class CreateEntityComponent
CreateEntityComponent = BaseClass("CreateEntityComponent",PoolBaseClass)

function CreateEntityComponent:__init()
	self.createInfo = {}
end

function CreateEntityComponent:Init(fight,entity)
	self.fight = fight
	self.entity = entity
	self.config = entity:GetComponentConfig(FightEnum.ComponentType.CreateEntity)
	
	for i, v in ipairs(self.config.CreateEntityInfos) do
		self.createInfo[i] = {count = 0,createTime = 0}
	end
end

function CreateEntityComponent:Update()
	local curTime = self.entity.timeComponent.frame * FightUtil.deltaTimeSecond
	for i, v in ipairs(self.config.CreateEntityInfos) do
		if self.createInfo[i].count < v.MaxCount then
			if curTime > v.DelayTime then
				if curTime > self.createInfo[i].createTime then
					self.createInfo[i].createTime = curTime + v.IntervalTime
					self.createInfo[i].count = self.createInfo[i].count + 1
					self:CreateEntity(v)
				end
			end
		end
	end
end

function CreateEntityComponent:CreateEntity(info)
	local entity = self.fight.entityManager:CreateEntity(info.EntityId, self.entity.parent)
	local position = self.entity.transformComponent.position
	local bornOffset = position + self.entity.transformComponent.rotation * Vec3.New(info.OffsetX,info.OffsetY,info.OffsetZ)
	entity.transformComponent:SetPosition(bornOffset.x , bornOffset.y , bornOffset.z)
	entity.rotateComponent:SetRotation(self.entity.transformComponent.rotation)
end

function CreateEntityComponent:OnCache()
	TableUtils.ClearTable(self.createInfo)
	self.fight.objectPool:Cache(CreateEntityComponent,self)
end

function CreateEntityComponent:__cache()
	self.fight = nil
	self.entity = nil
end

function CreateEntityComponent:__delete()

end