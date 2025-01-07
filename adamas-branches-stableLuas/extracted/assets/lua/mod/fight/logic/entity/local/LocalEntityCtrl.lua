LocalEntityCtrl = BaseClass("LocalEntityCtrl",PoolBaseClass)

function LocalEntityCtrl:__init()

end

function LocalEntityCtrl:Init(fight, config, entityManager)
	self.fight = fight
	self.config = config
	self.entityManager = entityManager
	-- TODO 动态加载/卸载距离
	self.loadRadius = 30 * 30
	self.unloadRadius = 40 * 40
	self.isLoad = false
	self.position = Vec3.New(config.posX, config.posY, config.posZ)
end


function LocalEntityCtrl:Update()
	if self.loadRadius == -1 or self.loading then
		return
	end

	if self.entity and self.entity.transformComponent then
		local position = self.entity.transformComponent:GetPosition()
		if not self.position or self.position.x ~= position.x or self.position.y ~= position.y or self.position.z ~= position.z then
			self.position = { x = position.x, y = position.y, z = position.z }
		end
	end
	if not self.position or self.loading then
		return
	end
	if self.isLoad then
		if not self:IsContain(self.unloadRadius) then
			self:Unload()
		end
	else
		if self:IsContain(self.loadRadius) then
			self:Load()
		end
	end
end

--获取距离平方，开方速度慢
function LocalEntityCtrl:IsContain(radiusSquare)
	local pos = self.position
	local lodCenter = self.fight.playerManager:GetPlayer():GetLodCenterPoint()
	local radiusSquare2 = (pos.x - lodCenter.x) * (pos.x - lodCenter.x) + 
	(pos.y - lodCenter.y) * (pos.y - lodCenter.y) + (pos.z - lodCenter.z) * (pos.z - lodCenter.z)
	return radiusSquare2 <= radiusSquare
end

function LocalEntityCtrl:Load()
	local config = self.config
	self.loading = true
	self.fight.clientFight.assetsNodeManager:LoadEntity(config.entityId, function()
		local entity
		entity = self.entityManager:CreateEntity(config.entityId)
		entity.transformComponent:SetPosition(config.posX, config.posY, config.posZ)
		entity.rotateComponent:SetRotation(Quat.New(config.rotX, config.rotY, config.rotZ, config.rotW))
		local gameObject = entity.clientTransformComponent:GetGameObject()
		if self.config.useCurScale then
			UnityUtils.SetLocalScale(gameObject.transform, config.scaleX, config.scaleY, config.scaleZ)
		end
		if entity.clientTransformComponent.lodRes then
			CustomUnityUtils.SetSceneUnityTransform(gameObject, config.posX, config.posY, config.posZ, 
			config.rotX, config.rotY, config.rotZ, config.rotW)
		end
		self.isLoad = true
		self.entity = entity
		self.loading = false
	end)
end

function LocalEntityCtrl:Unload()
	if self.entity then
		self.isLoad = false
		self.entityManager:RemoveEntity(self.entity.instanceId,true)
		self.entity = nil
	end
end

function LocalEntityCtrl:__cache()
	self:Unload()
	self.entity = nil
end

function LocalEntityCtrl:__delete()

end
