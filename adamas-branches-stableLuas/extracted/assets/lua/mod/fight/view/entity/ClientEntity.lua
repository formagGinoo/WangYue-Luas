---@type ClientEntity
ClientEntity = BaseClass("ClientEntity",PoolBaseClass)
local _luaEntityProfiler = LuaEntityProfiler
local debug = ctx.IsDebug
local _UnityUtils = UnityUtils
local _DebugConfig = DebugConfig
function ClientEntity:__init()
	self.clientComponents = {}
end

function ClientEntity:Init(clientFight,entity)
	self.clientFight = clientFight
	self.entity = entity
end

function ClientEntity:Update(lerpTime)
	if _DebugConfig.NpcAiLOD and (not self.entity.updateComponentEnable and not self.entity.isOnScreen) then
		--self.clientComponents["clientTransformComponent"]:Update(lerpTime)
		return
	end

	if debug then
		local s = self.entity.entityId * 10000 + self.entity.instanceId
		_UnityUtils.BeginSample(s)
		--_luaEntityProfiler:OnEntityUpdateStart(self.entity.instanceId, self.entity.entityId)
	end
	for k, v in pairs(self.clientComponents) do
	 	if v.Update then
			_UnityUtils.BeginSample(k)
			v:Update(lerpTime)
			_UnityUtils.EndSample()
		end
	end
	if debug then
		--_luaEntityProfiler:OnEntityUpdateEnd(self.entity.instanceId, self.entity.entityId)
		_UnityUtils.EndSample()
	end
end

function ClientEntity:AfterUpdate()
	if _DebugConfig.NpcAiLOD and (not self.entity.updateComponentEnable and not self.entity.isOnScreen) then
		return
	end
	if debug then
		local s = self.entity.entityId * 10000 + self.entity.instanceId
		_UnityUtils.BeginSample(s)
		--_luaEntityProfiler:OnEntityUpdateStart(self.entity.instanceId, self.entity.entityId)
	end
	for k, v in pairs(self.clientComponents) do
		if v.AfterUpdate then
			v:AfterUpdate()
		end
	end
	if debug then
		--_luaEntityProfiler:OnEntityUpdateEnd(self.entity.instanceId, self.entity.entityId)
		_UnityUtils.EndSample()
	end
end

function ClientEntity:__cache()
	for k, v in pairs(self.clientComponents) do
		self[v.name] = nil
		self.entity[v.name] = nil
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