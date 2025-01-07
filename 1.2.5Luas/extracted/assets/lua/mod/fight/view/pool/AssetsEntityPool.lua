AssetsEntityPool = BaseClass("AssetsEntityPool", AssetsPool)

function AssetsEntityPool:__init()
	self.callBacks = {}
    self.referenceCount = 0
end

function AssetsEntityPool:LoadEntity(entityId, callBack, notDoneCache)
    self.loader = AssetBatchLoader.New("AssetsEntityPool"..entityId)
    self.loaderHelp = FightResuorcesLoadHelp.New()
    self.notDoneCache = notDoneCache

	if callBack then
		table.insert(self.callBacks,callBack)
	end

    self.loaderHelp:PreloadEntity(entityId)
    self:Load(entityId)
end


function AssetsEntityPool:ClearObjectDirty(gameObject, cloneGameObject)
    Fight.Instance.clientFight.clientEntityManager:ClearGameObjectDirty(gameObject, cloneGameObject)
end


function AssetsEntityPool:Load(entityId)
    self.loader:AddListener(self:ToFunc("LoadDone"))
    self.resCount = self.loaderHelp.resList
    self.loader:LoadAll(self.loaderHelp.resList)
end

function AssetsEntityPool:AddCallBack(callBack)
	if callBack then
		table.insert(self.callBacks,callBack)
	end
end

function AssetsEntityPool:LoadDone()
    if not self.notDoneCache then
        for k, v in pairs(self.loaderHelp.resList) do
            local assets = self:Get(v.path, true)
            if assets.transform then
                self:Cache(v.path, assets)
            end
        end
    end

    for k, v in pairs(self.callBacks) do
		v()
	end
end