---@type ClientEntity
ClientEntity = BaseClass("ClientEntity",PoolBaseClass)

function ClientEntity:__init()
	self.clientComponents = {}
end

function ClientEntity:Init(clientFight,entity)
	self.clientFight = clientFight
	self.entity = entity
end

function ClientEntity:Update(lerpTime)
	UnityUtils.BeginSample("ClientEntity:Update"..self.entity.entityId)
	for k, v in pairs(self.clientComponents) do
	 	if v.Update then
	 		UnityUtils.BeginSample("CE:clientComponent "..k)
			v:Update(lerpTime)
			UnityUtils.EndSample()
		end
	end
	UnityUtils.EndSample()
end

function ClientEntity:__cache()
	for k, v in pairs(self.clientComponents) do
		self[v.name] = nil
		v:OnCache()
	end
	TableUtils.ClearTable(self.clientComponents)
end

function ClientEntity:__delete()
	for k, v in pairs(self.clientComponents) do
		v:DeleteMe()
	end
	self.clientComponents = nil
end