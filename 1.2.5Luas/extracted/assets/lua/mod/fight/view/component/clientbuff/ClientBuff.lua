ClientBuff = BaseClass("ClientBuff",PoolBaseClass)

function ClientBuff:__init()

end

function ClientBuff:Init(clientFight, clientEntity, info, isActivity, buffId)
	self.clientFight = clientFight
	self.clientEntity = clientEntity
	self.ignoreTimeScale = false
	self.path = info.Effect
	self.buffId = buffId
	self.gameObject = self.clientFight.assetsPool:Get(self.path)
	if not self.gameObject then
		LogError("Get GameObject Fail Path = "..self.path.." entityId = "..self.clientEntity.entity.entityId)
		return false
	end
	self.transform = self.gameObject.transform
	self.parent = self.clientEntity.clientTransformComponent:GetTransform(info.EffectBone)
	if not self.parent then
		--LogError("get effect bone error "..info.EffectBone)
	end
	self.parentRoot = self.clientEntity.clientTransformComponent:GetTransform()

	self.offset = Vector3(info.OffsetX, info.OffsetY, info.OffsetZ)
	self.dontBindRotation = info.dontBindRotation or false
	self.onlyUpdateY = info.onlyUpdateY or false
	self.effectUtil = self.gameObject:GetComponent(EffectUtil)
	if self.effectUtil then
		self.effectUtil:SetSpeed(1)
	end

	self:SetActivity(isActivity)

	if not self.dontBindRotation then
		self.clientEntity.clientTransformComponent:SetTransformChild(self.transform, info.EffectBone)
		self.transform.localPosition = self.offset
		UnityUtils.SetRotation(self.transform, 0, 0, 0, 0)
	else
		self.transform:SetParent(self.clientFight.clientEntityManager.entityRoot.transform)
	end

	return true
end


function ClientBuff:SetActivity(active)
	UnityUtils.SetActive(self.gameObject,active)
end

function ClientBuff:Update()
	if self.dontBindRotation then
		if not self.parent then
			return
		end
		local position = self.offset
		if not self.onlyUpdateY then
			position = self.parent.rotation * self.offset
		end
		
		local toPosition = self.parent.position + position
		local x = self.onlyUpdateY and self.parentRoot.position.x or toPosition.x
		local y = toPosition.y
		local z = self.onlyUpdateY and self.parentRoot.position.z or toPosition.z
		
		UnityUtils.SetPosition(self.transform, x, y, z)
	end
	--if self.dontBindRotation then
		--local position = self.parent.rotation * self.offset
		--self.transform.position = self.parent.position + position
	--end
	
end

function ClientBuff:SetTimeScale(timeScale)
	self.timeScale = timeScale
	if not self.ignoreTimeScale and self.effectUtil then
		self.effectUtil:SetSpeed(timeScale)
	end
end

function ClientBuff:SetIgnoreTimeScale(ignoreTimeScale, scale)
	local timeScale = self.timeScale or self.clientEntity.entity.timeComponent:GetTimeScale() or 1
	self.ignoreTimeScale = ignoreTimeScale
	self.effectUtil:SetSpeed(scale or timeScale)
end

function ClientBuff:OnCache()
	self.parent = nil
	self.buffId = nil
	self.clientFight.fight.objectPool:Cache(ClientBuff,self)
end

function ClientBuff:__cache()
	self.clientFight.assetsPool:Cache(self.path,self.gameObject)
end

function ClientBuff:__delete()
	self.clientFight = nil
	self.clientEntity = nil
end