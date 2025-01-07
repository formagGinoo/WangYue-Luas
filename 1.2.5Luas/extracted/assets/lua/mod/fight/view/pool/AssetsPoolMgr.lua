AssetsPoolMgr = BaseClass("AssetsPoolMgr")

function AssetsPoolMgr:__init()
	self.poolParent = nil
	self.fightAssetsPool = nil
	self.levelAssetsPool = {}
	self.entityAssetsPool = {}
	self.weaponAssetsPool = {}
	self.partnerSkillPool = {}
	self.otherAssetPool = {}
	self.otherPoolCount = 0
	self.assetIdPool = {}
	self.roleAssetMgr = RolePoolMgr.New(self)
end

function AssetsPoolMgr:LoadLevelPool(levelId, loadedCallBack)
	local levelPool = self.levelAssetsPool[levelId]
	if levelPool then
		if loadedCallBack then
			if levelPool.resLoaded then 
				loadedCallBack()
			else
				table.insert(levelPool.callBackList, loadedCallBack)
			end
		end
		return
	end

	local pool = AssetsPoolLevel.New(self.poolParent, "AssetsPoolLevel"..levelId) 
	local blackCurtain,blackTime = pool:LoadLevelRes(levelId, loadedCallBack)
	self.levelAssetsPool[levelId] = pool
	return blackCurtain, blackTime
end

function AssetsPoolMgr:UnLoadLevelPool(levelId)
	if not self.levelAssetsPool[levelId] then
		return
	end

	self.levelAssetsPool[levelId]:DeleteMe()
	self.levelAssetsPool[levelId] = nil
end

function AssetsPoolMgr:LoadFightPool(poolParent)
	self.poolParent = poolParent
	self.fightAssetsPool = AssetsPool.New(self.poolParent) 
end

function AssetsPoolMgr:UnLoadFightPool()
	if self.fightAssetsPool then
		self.fightAssetsPool:DeleteMe()
		self.fightAssetsPool = nil
	end
	self.poolParent = nil
end

function AssetsPoolMgr:LoadEntityPool(entityId, callBack, notDoneCache, notCount)
	if self.entityAssetsPool[entityId] and next(self.entityAssetsPool[entityId]) then
		local pool = self.entityAssetsPool[entityId]
		if pool.loader.isLoading then
			pool:AddCallBack(callBack)
		elseif callBack then
			callBack()
		end
		if not notCount then
			pool.referenceCount = pool.referenceCount + 1
		end
		return
	end

	local pool = AssetsEntityPool.New(self.poolParent, "AssetsEntityPool"..entityId)
	pool:LoadEntity(entityId, callBack, notDoneCache)
	if not notCount then
		pool.referenceCount = pool.referenceCount + 1
	end
	self.entityAssetsPool[entityId] = pool
end

function AssetsPoolMgr:UnLoadEntityPool(entityId)
	if not self.entityAssetsPool[entityId] then
		return
	end
	local pool = self.entityAssetsPool[entityId]
	pool.referenceCount = pool.referenceCount - 1
	if pool.referenceCount <= 0 then
		self.entityAssetsPool[entityId]:DeleteMe()
		self.entityAssetsPool[entityId] = nil
	end
end

function AssetsPoolMgr:UnLoadAllEntityPool()
	for k, v in pairs(self.entityAssetsPool) do
		v:DeleteMe()
	end
	TableUtils.ClearTable(self.entityAssetsPool)
end

function AssetsPoolMgr:CheckEntityPool(entityId)
	return self.entityAssetsPool[entityId] and next(self.entityAssetsPool[entityId])
end

function AssetsPoolMgr:Get(path)
	if self.fightAssetsPool then
		if self.fightAssetsPool:Contain(path) then
			return self:_PoolGet(self.fightAssetsPool, path)
		end
	end

	for k, v in pairs(self.entityAssetsPool) do
		if v:Contain(path) then
			return self:_PoolGet(v, path)
		end
	end

	for k, v in pairs(self.levelAssetsPool) do
		if v:Contain(path) then
			return self:_PoolGet(v, path)
		end
	end

	for k, v in pairs(self.weaponAssetsPool) do
		if v:Contain(path) then
			return self:_PoolGet(v, path)
		end
	end
end

function AssetsPoolMgr:_PoolGet(pool, path)
	local asset, originInsId, originObject = pool:Get(path)
	if originInsId then
		self.assetIdPool[originInsId] = pool
	end

	return asset, originObject
end

function AssetsPoolMgr:GetFromEntity(path, entityId)
	if not self.entityAssetsPool or not self.entityAssetsPool[entityId] then
		return self:Get(path)
	end

	if not self.entityAssetsPool[entityId]:Contain(path) then
		return self:Get(path)
	end

	return self:_PoolGet(self.entityAssetsPool[entityId], path)
end

function AssetsPoolMgr:Contain(path)
	if self.fightAssetsPool:Contain(path) then
		return true
	end

	for k, v in pairs(self.entityAssetsPool) do
		if v:Contain(path) then
			return true
		end
	end

	for k, v in pairs(self.levelAssetsPool) do
		if v:Contain(path) then
			return true
		end
	end

	return false
end

function AssetsPoolMgr:Cache(path, go)
	local instanceId = go:GetInstanceID()
	local orginPool = self.assetIdPool[instanceId]
	if orginPool then
		self.assetIdPool[instanceId] = nil
		if orginPool.assetsPool then
			orginPool:Cache(path, go)
			return
		end
	end

	if self.fightAssetsPool:Contain(path) then
		self.fightAssetsPool:Cache(path, go)
		return
	end

	for k, v in pairs(self.entityAssetsPool) do
		if v:Contain(path) then
			v:Cache(path, go)
			return
		end
	end

	for k, v in pairs(self.levelAssetsPool) do
		if v:Contain(path) then
			v:Cache(path, go)
			return
		end
	end

	
	for k, v in pairs(self.weaponAssetsPool) do
		if v:Contain(path) then
			return v:Cache(path, go)
		end
	end

	if orginPool then
		Log("orgin go destroy " .. path)
	end
	
	GameObject.DestroyImmediate(go)
end

function AssetsPoolMgr:CacheByEntity(path, go, entityId)
	if not self.entityAssetsPool or not self.entityAssetsPool[entityId] then
		self:Cache(path, go)
		return
	end

	if not self.entityAssetsPool[entityId]:Contain(path) then
		self:Cache(path, go)
		return
	end

	self.entityAssetsPool[entityId]:Cache(path, go)
end

function AssetsPoolMgr:CheckGetingCount(key)
	if key then
		if self.entityAssetsPool and self.entityAssetsPool[key] then
			return self.entityAssetsPool[key]:CheckGetingCount()
		elseif self.levelAssetsPool and self.levelAssetsPool[key] then
			return self.levelAssetsPool[key]:CheckGetingCount()
		end

		return 0
	end

	return self.fightAssetsPool:CheckGetingCount()
end

function AssetsPoolMgr:LoadWeaponPool(weaponId, callBack, notCount)
	if self.weaponAssetsPool and self.weaponAssetsPool[weaponId] then
		local pool = self.weaponAssetsPool[weaponId]
		if not notCount then
			pool.referenceCount = pool.referenceCount + 1
		end
		if self.weaponAssetsPool[weaponId].loader.isLoading then
			self.weaponAssetsPool[weaponId]:AddCallBack(callBack)
		else
			if callBack then
				callBack()
			end
		end
		return
	end
	local pool = AssetsWeaponPool.New(self.poolParent, "WeaponAssetsPool"..weaponId)
	pool:LoadWeapon(weaponId, callBack)
	self.weaponAssetsPool[weaponId] = pool
	if not notCount then
		pool.referenceCount = 1
	end
end

function AssetsPoolMgr:UnLoadWeaponPool(weaponId)
	if not self.weaponAssetsPool[weaponId] then
		return
	else
		local pool = self.weaponAssetsPool[weaponId]
		pool.referenceCount = pool.referenceCount - 1
		if pool.referenceCount <= 0 then
			self.weaponAssetsPool[weaponId]:DeleteMe()
			self.weaponAssetsPool[weaponId] = nil
		end
	end
end

function AssetsPoolMgr:UnLoadAllWeaponPool()
	for key, value in pairs(self.weaponAssetsPool) do
		self.weaponAssetsPool[key]:DeleteMe()
		self.weaponAssetsPool[key] = nil
	end
end

function AssetsPoolMgr:LoadGliderPool(gliderId, callBack, notCount)
	if self.gliderAssetsPool and self.gliderAssetsPool[gliderId] then
		local pool = self.gliderAssetsPool[gliderId]
		if not notCount then
			pool.referenceCount = pool.referenceCount + 1
		end
		if self.gliderAssetsPool[gliderId].loader.isLoading then
			self.gliderAssetsPool[gliderId]:AddCallBack(callBack)
		else
			if callBack then
				callBack()
			end
		end
		return
	end
	local pool = AssetsWeaponPool.New(self.poolParent, "GliderAssetsPool"..gliderId)
	pool:LoadWeapon(gliderId, callBack)
	self.gliderAssetsPool[gliderId] = pool
	if not notCount then
		pool.referenceCount = 1
	end
end

function AssetsPoolMgr:UnLoadGliderPool(gliderId)
	if not self.gliderAssetsPool[gliderId] then
		return
	else
		local pool = self.gliderAssetsPool[gliderId]
		pool.referenceCount = pool.referenceCount - 1
		if pool.referenceCount <= 0 then
			self.gliderAssetsPool[gliderId]:DeleteMe()
			self.gliderAssetsPool[gliderId] = nil
		end
	end
end

function AssetsPoolMgr:UnLoadAllGliderPool()
	for key, value in pairs(self.gliderAssetsPool) do
		self.gliderAssetsPool[key]:DeleteMe()
		self.gliderAssetsPool[key] = nil
	end
end

function AssetsPoolMgr:LoadPartnerSkillPool(skillId, lev, callBack, notCount)
	local key = UtilsBase.GetDoubleKeys(skillId, lev, 32)
	if self.partnerSkillPool and self.partnerSkillPool[key] then
		local pool = self.partnerSkillPool[key]
		if not notCount then
			pool.referenceCount = pool.referenceCount - 1
		end
		if self.partnerSkillPool[key].loader.isLoading then
			self.partnerSkillPool[key]:AddCallBack(callBack)
		else
			if callBack then
				callBack()
			end
		end
		return
	end
	local pool = AssetsWeaponPool.New(self.poolParent, "AssetsPartnerSKillPool"..key)
	pool:LoadSkill(skillId, callBack)
	self.partnerSkillPool[key] = pool
	if not notCount then
		pool.referenceCount = 1
	end
end

function AssetsPoolMgr:UnLoadPartnerSkillPool(skillId, lev)
	local key = UtilsBase.GetDoubleKeys(skillId, lev, 32)
	if not self.partnerSkillPool[key] then
		return
	else
		local pool = self.partnerSkillPool[key]
		pool.referenceCount = pool.referenceCount - 1
		if pool.referenceCount <= 0 then
			self.partnerSkillPool[key]:DeleteMe()
			self.partnerSkillPool[key] = nil
		end
	end
end

function AssetsPoolMgr:UnLoadAllPartnerSkillPool()
	for key, value in pairs(self.partnerSkillPool) do
		self.partnerSkillPool[key]:DeleteMe()
		self.partnerSkillPool[key] = nil
	end
end

function AssetsPoolMgr:GetRoleMgr()
	return self.roleAssetMgr
end

---杂乱的资源池，主要是为了解决重复取出同一资源
function AssetsPoolMgr:LoadOtherPool(loaderName, resList, callBack)
	self:UnLoadOtherPool(loaderName)
	if not self.otherAssetPool[loaderName] then
		self.otherAssetPool[loaderName] = AssetsPool.New(self.poolParent, tostring(loaderName))
		local loader = AssetBatchLoader.New(tostring(loaderName))
		loader:AddListener(callBack)
		loader:LoadAll(resList)
		self.otherAssetPool[loaderName]:SetLoader(loader)
		self.otherPoolCount = self.otherPoolCount + 1
	end
end

function AssetsPoolMgr:UnLoadOtherPool(loaderName)
	if self.otherAssetPool[loaderName] then
		self.otherAssetPool[loaderName]:DeleteMe()
		self.otherAssetPool[loaderName] = nil
		self.otherPoolCount = self.otherPoolCount - 1
		return
	end
end

function AssetsPoolMgr:UnLoadAllOtherPool()
	for k, v in pairs(self.otherAssetPool) do
		self:UnLoadOtherPool(k)
	end
end

function AssetsPoolMgr:GetFormOther(loaderName,path)
	if self.otherAssetPool[loaderName] then
		if self.otherAssetPool[loaderName]:Contain(path) then
			return self.otherAssetPool[loaderName]:Get(path)
		end
	end
end

-- Chunk_Bamboo_10020001_07_Plain