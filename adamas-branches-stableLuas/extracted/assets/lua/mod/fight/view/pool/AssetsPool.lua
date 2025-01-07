AssetsPool = BaseClass("AssetsPool")
--TODO 资源缓存池  

function AssetsPool:__init(parent, poolName)
	poolName = poolName or "AssetsPool"
	self.clientFight = clientFight
	self.assetsPoolRoot = GameObject(poolName)
	self.assetsPoolRoot:SetActive(false)
	if parent then
		self.assetsPoolRoot.transform:SetParent(parent)
	else
		GameObject.DontDestroyOnLoad(self.assetsPoolRoot)
	end
	self.assetsPool = {}
	self.origins = {}
	self.originInsIds = {}
	self.getAssetsCount = 0
end

function AssetsPool:SetLoader(loader)
	self.loader = loader
end


function AssetsPool:Get(path)
	self.getAssetsCount = self.getAssetsCount + 1
	if not self.assetsPool[path] then
		self.assetsPool[path] = {}
		local asset = self.loader:Pop(path) --assetLoader:Pop 不能多次取出
		if not asset then
			LogError("Load Asset Error! path = "..path)
			self.getAssetsCount = self.getAssetsCount - 1
			return
		end

		local isPrefab = self.loader:GetAssetType(path) == AssetType.Prefab
		if not isPrefab then
			if AssetBatchLoader.UseLocalRes and ctx.Editor then
			else
				AssetMgrProxy.Instance:IncreaseReferenceCount(path)
			end
		else
			self.originInsIds[path] = asset:GetInstanceID()
		end

		self.origins[path] = asset        --从源拷贝资源
		self.getAssetsCount = self.getAssetsCount - 1

		if self.originInsIds[path] and #self.assetsPool[path] == 0 then
			return asset, self.originInsIds[path], self.origins[path]
		else
			return asset
		end
	end

	local asset = nil
	if self.assetsPool[path] and #self.assetsPool[path] > 0 then
		for k, v in pairs(self.assetsPool[path]) do
			asset = table.remove(self.assetsPool[path])
			if asset and not UtilsBase.IsNull(asset) then
				self.getAssetsCount = self.getAssetsCount - 1	
				if self.originInsIds[path] and #self.assetsPool[path] == 0 then
					return asset, self.originInsIds[path], self.origins[path]
				else
					return asset
				end
			end
		end
	end
	
	if not asset or UtilsBase.IsNull(asset) then
		if self.loader:GetAssetType(path) == AssetType.Prefab then
			--asset = GameObject.Instantiate(self.origins[path]) --self.generate(path)
			if UtilsBase.IsNull(self.origins[path]) then
				LogError("self.origins[path] null "..path)
			end

			asset = AssetMgrProxy.Instance:CloneGameObject(self.origins[path])
			if not asset then
				Log("asset == nil "..path)
			end

			self:ClearObjectDirty(self.origins[path], asset)
		else
			asset = self.origins[path] --GameObject.Instantiate(self.origins[path])
		end
		if AssetBatchLoader.UseLocalRes and ctx.Editor then
		else
			AssetMgrProxy.Instance:IncreaseReferenceCount(path)
		end
	end
	self.getAssetsCount = self.getAssetsCount - 1
	return asset
end

function AssetsPool:ClearObjectDirty(gameObject, cloneGameObject)
	
end

function AssetsPool:Contain(path)
	if not self.loader then
		return false
	end
	return self.loader:Contain(path)
end

function AssetsPool:CheckGetingCount()
	return self.getAssetsCount
end

function AssetsPool:Cache(path,go)
	if not self.assetsPool[path] then
		self.assetsPool[path] = {}
	end

	local trans = go.transform
	trans:SetParent(self.assetsPoolRoot.transform)
	table.insert(self.assetsPool[path],go)
end

function AssetsPool:__delete()
	GameObject.Destroy(self.assetsPoolRoot)
	self.fight = nil
	self.assetsPool = nil
	self.getAssetsCount = 0
end