---@class TotalAssetPool
--总资源池
TotalAssetPool = BaseClass("TotalAssetPool")

function TotalAssetPool:__init(assetNodeManager)
	self.assetNodeManager = assetNodeManager
	self.assets = {}--资源池
	self.origins = {}--原资源
	self.originInsIds = {}
	self.removeList = {}
	self.isPrefab = {}
	self.assetsLoadingCount = {}--加载中的资源引用计数
	self.assetsCount = {}--资源引用计数
	self.assetPoolRoot = nil
	
	--实例化相关
	self.popList = {}
	self.curIndex = 1

	EventMgr.Instance:AddListener(EventName.UnityUpdate, self:ToFunc("UnityUpdate"))
	EventMgr.Instance:AddListener(EventName.LogicUpdate, self:ToFunc("LogicUpdate"))
end

---comment
---@param path string
---@param clone boolean 以克隆的方式获取资源（获取的资源不会成为原始资源，可以不用回池，解决脏标记难处理的情况）
function TotalAssetPool:Get(path, clone, ingoreWarning)
	TotalAssetPool.DebugLog("Get",path)
	if not self.assets[path] and not ingoreWarning then
		LogError("资源不存在！"..path)
		return
	end
	if clone and self.isPrefab[path] then
		local originAsset = self.origins[path]
		if UtilsBase.IsNull(originAsset) then
			LogError("资源为空！"..path)
		end
		local asset = AssetMgrProxy.Instance:CloneGameObject(originAsset)
		self:ClearObjectDirty(originAsset, asset)
		asset:SetActive(true)
		return asset
	end

	local pool = self.assets[path]
	if pool then
		local asset = table.remove(pool)
		if asset then
			local isOriginObj = false
			if self.isPrefab[path] then
				if not asset.activeSelf then
					asset:SetActive(true)
				end
				local instanceId = asset:GetInstanceID()
				isOriginObj = self.originInsIds[instanceId]
			end
			return asset, isOriginObj
		end
	end
	if self.isPrefab[path] then
		local originAsset = self.origins[path]
		if UtilsBase.IsNull(originAsset) then
			LogError("资源为空！"..path)
		end
		asset = AssetMgrProxy.Instance:CloneGameObject(originAsset)

		self:ClearObjectDirty(originAsset, asset)
	else
		asset = self.origins[path]
	end
	
	if not asset then
		Log("asset == nil "..path)
	end
	
	if self.isPrefab[path] then
		if not asset.activeSelf then
			asset:SetActive(true)
		end
		UnityUtils.SetLocalScale(asset.transform, 1, 1, 1)
	end
	return asset
end

function TotalAssetPool:Cache(path,go,isPrefab,isload)
	if not self.origins then
		LogError("这个池子已经Delete了，别再放东西进来", path)
	end
	TotalAssetPool.DebugLog("Cache",path)
	if not self.origins[path] then
		if not isload then
			Log("尝试缓存一个已经被移除的资源", path)
			return
		end
		if not self.assets[path] then
			self.assets[path] = {}
		end
		table.insert(self.assets[path],go)
		if isPrefab then
			self.isPrefab[path] = true
			local instanceId = go:GetInstanceID()
			self.originInsIds[instanceId] = true
		end
		self.origins[path] = go
		self.assetsCount[path] = 0
		TotalAssetPool.DebugLog("Create"..path)
	else
		table.insert(self.assets[path],go)
	end
	if go and go.transform then
		UnityUtils.SetLocalScale(go.transform, 1, 1, 1)
		go.transform:SetParent(self.assetPoolRoot, false)
	end
end

function TotalAssetPool:AddLoadingReferenceCount(path)
	if self.assetsLoadingCount[path] then
		self.assetsLoadingCount[path] = self.assetsLoadingCount[path] + 1
	else
		self.assetsLoadingCount[path] = 1
	end
end

function TotalAssetPool:RemoveLoadingReferenceCount(path)
	if self.assetsLoadingCount[path] then
		self.assetsLoadingCount[path] = self.assetsLoadingCount[path] - 1
		if self.assetsLoadingCount[path] <= 0 then
			self.assetsLoadingCount[path] = nil
		end
	end
	
end

function TotalAssetPool:AddReferenceCount(path)
	if not self.assetsCount[path] then
		LogError("找不到引用！"..path)
		return
	end
	self.assetsCount[path] = self.assetsCount[path] + 1
	TotalAssetPool.DebugLog("AddReferenceCount"..path.."_"..self.assetsCount[path])
end

function TotalAssetPool:RemoveReferenceCount(path)
	if not self.assetsCount[path] then
		LogError("找不到引用！"..path)
		return
	end
	self.assetsCount[path] = self.assetsCount[path] - 1
	TotalAssetPool.DebugLog("RemoveReferenceCount_"..path.."_"..self.assetsCount[path])
	if self.assetsCount[path] == 0 and not self.assetsLoadingCount[path] then
		if not self.removeList[path] then
			self.removeList[path] = true
		end
	end
end

--去重，只加载需要部分，粒度更细
function TotalAssetPool:DuplicateRemoval(resList)
	local resMap = {}
	for k, v in pairs(resList) do
		if self.origins[v.path] then
			resList[k] = nil
		else
			resMap[v.path] = true
		end
	end
	local temp = {}
	for k, v in pairs(resList) do
		table.insert(temp,v)
	end
	return temp, resMap
end

function TotalAssetPool:Contain(path)
	return self.origins[path]
end

function TotalAssetPool:ClearObjectDirty(gameObject, cloneGameObject)
	Fight.Instance.clientFight.clientEntityManager:ClearGameObjectDirty(gameObject, cloneGameObject)
end

--分帧实例化
TotalAssetPool.PopCountByFrame = 5

local Frame = 0
function TotalAssetPool:UnityUpdate()
	Frame = Frame + 1
	self:FrameInstantiation()
end
function TotalAssetPool:LogicUpdate()
	self:RemoveUpdate()
end

function TotalAssetPool:RemoveUpdate()
	for path, _ in pairs(self.removeList) do
		if self.assetsCount[path] <= 0 and not self.assetsLoadingCount[path]  then
			local go = self.origins[path]
			if self.isPrefab[path] then
				self.originInsIds[go:GetInstanceID()] = nil
				TotalAssetPool.DebugLog("Destroy "..path)
				if go.transform.parent ~= self.assetPoolRoot then
					Log("删除了未回池的对象", path)
				end
				GameObject.Destroy(go)
				for key, value in pairs(self.assets[path]) do
					if value.transform.parent ~= self.assetPoolRoot then
						Log("删除了未回池的对象", path)
					end
					GameObject.Destroy(value)
				end
			else
				TotalAssetPool.DebugLog("RemoveReferenceCount not prefab "..path)
				AssetMgrProxy.Instance:DecreaseReferenceCount(path)
			end
			TableUtils.ClearTable(self.assets[path])
			self.origins[path] = nil
			self.assetsCount[path] = nil
		end
		self.removeList[path] = nil
	end
end

function TotalAssetPool:FrameInstantiation()
	if not next(self.popList) then
		return
	end
	local i = 0
	local notFrameInstantiation = (LoadPanelManager.Instance:IsLoading() or CurtainManager.Instance:IsCurtain())
	local loadCount = notFrameInstantiation and 99999 or TotalAssetPool.PopCountByFrame
	while i < loadCount do
		i = i + 1
		local path = self:PopNextAsset()
		if not path then
			i = i - 1
		else
			--Log("分帧实例化 frame:" .. Frame.. ", index:".. i .. ", path:".. path)
		end
		if not next(self.popList) then
			return
		end
	end
end

function TotalAssetPool.GetFrame()
	return Frame
end

function TotalAssetPool:AddPopList(loader, callback)
	if not self.popList then
		return
	end

	local tb = {loader = loader, callback = callback}
	table.insert(self.popList, tb)
end

function TotalAssetPool:PopNextAsset()
	if next(self.popList) then
	local loader = self.popList[1].loader
		local resList = loader.resList

		if self.curIndex > #resList then
			self.curIndex = 1
			self.popList[1].callback()
			table.remove(self.popList, 1)
			return false
		end

		local v = resList[self.curIndex]
		local asset = loader:Pop(v.path)
		if asset then
			TotalAssetPool.DebugLog("PopNextAsset"..v.path)
			if v.type ~= AssetType.Prefab then
				AssetMgrProxy.Instance:IncreaseReferenceCount(v.path)
			end
			self:Cache(v.path,asset,v.type == AssetType.Prefab,true)
		end
		self:AddReferenceCount(v.path)
		self:RemoveLoadingReferenceCount(v.path)
		self.curIndex = self.curIndex + 1
		return v.type == AssetType.Prefab and v.path or false
	else
		return false
	end
end

function TotalAssetPool:__delete()
	for path, go in pairs(self.origins) do
		if not self.isPrefab[path] then
			AssetMgrProxy.Instance:DecreaseReferenceCount(path)
		end
	end
	self.origins = {}

	EventMgr.Instance:RemoveListener(EventName.UnityUpdate, self:ToFunc("UnityUpdate"))
	EventMgr.Instance:RemoveListener(EventName.LogicUpdate, self:ToFunc("LogicUpdate"))

	--TODO 需要补全管理
end

local ShowLog = false
function TotalAssetPool.DebugLog(...)
	if ShowLog then
		LogError(...)
	end
end