---@class ReferenceNodeBase
---资源依赖base，Node命名原因是节点嵌套，树状节点
DependenciesNodeBase = BaseClass("DependenciesNodeBase",PoolBaseClass)

function DependenciesNodeBase:__init(nodeManager,totalAssetPool)
	self.dependencies = {}--资源引用数组
	self.nodes = {}--子节点
	self.loadCount = 0
	self.loadDoneCount = 0
	self.referenceCount = 1
	self.nodeManager = nodeManager
	self.totalAssetPool = totalAssetPool
	self.callbacks = {}
	self.parentNode = nil --没有父节点即代表是根节点
	self.isLoading = true
	self.isDone = false
end

function DependenciesNodeBase:AddCallback(callback)
	table.insert(self.callbacks,callback)
end

function DependenciesNodeBase:AnalyseAssets(key)
	self.key = key
	self:Analyse(key)
end

function DependenciesNodeBase:SetAssets(resList)
	self.resList = resList
end

function DependenciesNodeBase:StartLoad()
	self.fullResList = TableUtils.CopyTable(self.resList)
	self.resList, self.resMap = self.totalAssetPool:DuplicateRemoval(self.resList)--需要加载的资源
	for k, v in pairs(self.fullResList) do
		if self.resMap[v.path] then
			self.totalAssetPool:AddLoadingReferenceCount(v.path)
		else
			self.totalAssetPool:AddReferenceCount(v.path)
		end
	end

	self.loadCount = #self.resList
	self.loadDoneCount = 0
	if self.loadCount == 0 then
		for k, v in pairs(self.nodes) do
			v:StartLoad()
		end
		self:SelfLoadDone()
		return
	end
	self.loader = AssetBatchLoader.New("AssetsLoader")
	local cellCallback = self:ToFunc("CellLoadCallback")
	for k, v in pairs(self.resList) do
		v.callback = cellCallback
	end
	self.loader:AddListener(self:ToFunc("SelfLoadDone"))
	self.loader:LoadAll(self.resList)
	for k, v in pairs(self.nodes) do
		v:StartLoad()
	end
	self.isLoading = true
end

function DependenciesNodeBase:IsLoading()
	if self.isLoading then
		return true
	end
	for k, v in pairs(self.nodes) do
		if v:IsLoading() then
			return true
		end
	end
	return false
end

function DependenciesNodeBase:IsPoping()
	if self.isPoping then
		return true
	end
	for k, v in pairs(self.nodes) do
		if v:IsPoping() then
			return true
		end
	end
	return false
end

function DependenciesNodeBase:CellLoadCallback()
	self.loadDoneCount = self.loadDoneCount + 1
	if self.cellCallBack then
		self.cellCallBack()
	end
end

--获取进度
function DependenciesNodeBase:GetLoadCount()
	local loadDoneCount = self.loadDoneCount
	local loadCount = self.loadCount
	for k, v in pairs(self.nodes) do
		local noteLoadDoneCount,noteLoadCount = v:GetLoadCount()
		loadDoneCount = loadDoneCount + noteLoadDoneCount
		loadCount = loadCount + noteLoadCount
	end
	return loadDoneCount,loadCount
end

function DependenciesNodeBase:AddChildNote(key,node,rootNode)
	if self.nodes[key] then
		self.nodes[key].referenceCount = self.nodes[key].referenceCount + 1
		return false
	end
	self.nodes[key] = node
	node.parentNode = self
	node.rootNote = self.rootNote
	return true
end

function DependenciesNodeBase:CheckChildNote(key)
	if self.nodes[key] then
		return true
	else
		return false
	end
end

function DependenciesNodeBase:UnLoadChildNote(key)
	if not self.nodes[key] then
		LogError("移除一个不存在的节点！"..key)
		return
	end
	local note = self.nodes[key]
	note.referenceCount = note.referenceCount - 1

	if note.referenceCount > 0 then
		return
	end
	note:Unload()
	self.nodes[key] = nil
end

function DependenciesNodeBase:Unload()
	for k, v in pairs(self.nodes) do
		v:Unload(k)
	end
	for key, value in pairs(self.fullResList) do
		self.totalAssetPool:RemoveReferenceCount(value.path)
	end
end

function DependenciesNodeBase:SelfLoadDone()
	self.isLoading = false
	if not self:IsLoading() and not self:IsPoping() then
		self:LoadDone()
	end
end

function DependenciesNodeBase:ChildLoadDone(key)
	if not self:IsLoading() and not self:IsPoping() then
		self:LoadDone()
	end
end

function DependenciesNodeBase:LoadDone()
	if self.isDone then
		return
	end
	self.isDone = true
	self.isPoping = true

	if self.loader then
		self.totalAssetPool:AddPopList(self.loader, self:ToFunc("PopDone"))
		--self.totalAssetPool:Update()
	else
		self:PopDone()
	end
end

function DependenciesNodeBase:PopDone()
	if self.isPoping == false then
		return
	end
	self.isPoping = false
	if self.parentNode then
		self.parentNode:ChildLoadDone(self.key)
	else
		self.nodeManager:LoadDone()
	end
	for k, v in pairs(self.callbacks) do
		v()
	end
	TableUtils.ClearTable(self.callbacks)
	--TableUtils.ClearTable(self.fullResList)
	TableUtils.ClearTable(self.resList)
	TableUtils.ClearTable(self.resMap)
	if self.callback then
		self.callback()
	end
end

function DependenciesNodeBase:OnCache()
	--self.fight.objectPool:Cache(ReferenceNodeBase,self)
end

function DependenciesNodeBase:__cache()
	self.referenceCount = 0
	self.loadCount = 0
	self.loadDoneCount = 0
	self.cellCallBack = nil
	TableUtils.ClearTable(self.dependencies)
	TableUtils.ClearTable(self.callBacks)
end

function DependenciesNodeBase:__delete()

end