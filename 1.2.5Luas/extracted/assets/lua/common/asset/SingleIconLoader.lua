-- 单icon加载
SingleIconLoader = BaseClass("SingleIconLoader")

function SingleIconLoader.Load(gameObject, path, callback)
    local loader = PoolManager.Instance:Pop(PoolType.class, "SingleIconLoader")
    if not loader then
        loader = SingleIconLoader.New()
    end
    
    if ctx.Editor then
        local instanceId = gameObject:GetInstanceID()
        loader.tracebackMap[instanceId] = debug.traceback()
    end

    loader:LoadIcon(gameObject, path, callback)
end

function SingleIconLoader:__init()
    self.resList = {
        {path = "", type = AssetType.Object, holdTime = 56}
    }
    self.tracebackMap = {}
    local callback = function()
        self:SetIcon()
    end
    self.assetLoader = AssetBatchLoader.New("SingleIconLoader");
    self.assetLoader:AddListener(callback)
end

function SingleIconLoader:LoadIcon(gameObject, path, callback)
    self.path = path
    self.gameObject = gameObject
    self.curInstanceId = gameObject:GetInstanceID()
    self.callback = callback
    self.resList[1].path = path
    self.assetLoader:LoadAll(self.resList)
end

function SingleIconLoader:__delete()
    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
end

function SingleIconLoader:ClearCacheInfo()
    local instanceId = self.curInstanceId
    self.tracebackMap[instanceId] = nil
    self.curInstanceId = nil
end

function SingleIconLoader:SetIcon()
    if UtilsBase.IsNull(self.gameObject) then
        self:ClearCacheInfo()
        return
    end

    if not self.gameObject.AddComponent then
        LogError("加载图片错误")
        if ctx.Editor and self.tracebackMap[self.curInstanceId] then
            print("self.gameObject = ", self.gameObject, self.tracebackMap[self.curInstanceId])
        end
        self:ClearCacheInfo()
        return
    end

    self:ClearCacheInfo()
    local image = self.gameObject:GetComponent(Image)
    
	local UseLocalRes = AssetBatchLoader.UseLocalRes and ctx.Editor
	local autoReleaser 
	if not UseLocalRes then
		autoReleaser = self.gameObject:GetComponent(IconAutoReleaser)
		if autoReleaser == nil then
			autoReleaser = self.gameObject:AddComponent(IconAutoReleaser)
		end
		if autoReleaser.path ~= nil and autoReleaser.path ~= "" and not UtilsBase.IsNull(autoReleaser.path) then
			AssetMgrProxy.Instance:DecreaseReferenceCount(autoReleaser.path)
			image.sprite = nil
		end
		autoReleaser.path = self.path
		AssetMgrProxy.Instance:IncreaseReferenceCount(self.path)
		image.sprite = self.assetLoader:Pop(self.path)
	else
		local t2d = self.assetLoader:Pop(self.path)
		local sprite = CS.EditorAssetLoad.CastToSprite(t2d)
		image.sprite = sprite
	end
    
    if self.assetLoader ~= nil then
         self.assetLoader.resDict = {}
    end

    self.path = nil
    self.gameObject = nil

    if self.callback ~= nil then
        self.callback()
    end

    PoolManager.Instance:Push(PoolType.class, "SingleIconLoader", self)
end


function SingleIconLoader:OnReset()

end