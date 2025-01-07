---@class ClientEntityManager
ClientEntityManager = BaseClass("ClientEntityManager")

function ClientEntityManager:__init(clientFight)
	self.clientFight = clientFight
	---@type ClientEntity[]
	self.clientEntites = {}
	self.entityRoot = GameObject("EntityRoot")
	self.entityRoot.transform:SetParent(self.clientFight.fightRoot.transform)
	UnityUtils.SetPosition(self.entityRoot.transform,0, 0, 0)
	self.gameObjectDirties = {}
end

function ClientEntityManager:AddClientEntity(clientEntity)
	self.clientEntites[clientEntity.entity.instanceId] = clientEntity
end

function ClientEntityManager:RemoveClientEntity(instanceId, noCache, entityId)
	local clientEntity = self.clientEntites[instanceId]
	local noCache = noCache or false
	self.clientFight.fight.objectPool:Cache(ClientEntity, clientEntity)
	if noCache then
		self.clientFight.assetsNodeManager:UnloadEntity(entityId)
	end

	self.clientEntites[instanceId] = nil
end

---@return ClientEntity
function ClientEntityManager:GetEntity(instanceId)
	return self.clientEntites[instanceId]
end

function ClientEntityManager:MarkGameObjectDirty(gInstanceId, instanceId)
	self.gameObjectDirties[gInstanceId] = instanceId
end

function ClientEntityManager:RemoveGameObjectDirty(gInstanceId)
	self.gameObjectDirties[gInstanceId] = nil
end

function ClientEntityManager:ClearGameObjectDirty(gameObject, cloneGameObject)
	local gInstanceId = gameObject:GetInstanceID()
	local instanceId = self.gameObjectDirties[gInstanceId]
	if not instanceId then
		return gameObject
	end

	local clientEntity = self.clientEntites[instanceId]
	if not clientEntity then
		return gameObject
	end
	
	local cloneBindTransform = cloneGameObject:GetComponent(BindTransform)
	if cloneBindTransform then
		cloneBindTransform:TrySerialize()
	end
	local transformChildMap = clientEntity.clientTransformComponent.transformChildMap
	if transformChildMap then
		for childName, transformList in pairs(transformChildMap) do
			for k, transformName in ipairs(transformList) do
				local transform 
				if cloneBindTransform and transformName ~= '' and transformName ~= gameObject.name then
					transform = cloneBindTransform:GetTransform(transformName)
				else
					transform = cloneGameObject.transform
				end
				
				if transform then
					local removeObject = transform:Find(childName)
					if removeObject then
						GameObject.DestroyImmediate(removeObject.gameObject)
					end
				end
			end
		end
		--只有角色在克隆时需要更新
		if clientEntity.entity.masterId then
			CustomUnityUtils.SetShadowRenderers(gameObject)
		end
	end

	if cloneBindTransform then
		for k, v in pairs(clientEntity.clientTransformComponent.hideGroup) do
			cloneBindTransform:SetGroupVisible(k, true)
		end

		for k, v in pairs(clientEntity.clientTransformComponent.hideBone) do
			local tf = cloneBindTransform:GetTransform(k)
			if tf and tf.gameObject then
				tf.gameObject:SetActive(true)
			end
		end
	end
end

function ClientEntityManager:Update(lerpTime)
	for k, v in pairs(self.clientEntites) do
		v:Update(lerpTime)
	end
end

function ClientEntityManager:__delete()
	--local assetsPoolMgr = self.clientFight.assetsPool
	--assetsPoolMgr:UnLoadAllEntityPool()

	for k, v in pairs(self.clientEntites) do
		v:DeleteMe()
	end

	self.clientFight = nil
	self.clientEntites = nil
end