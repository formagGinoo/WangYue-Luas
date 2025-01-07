IconLoader = BaseClass("IconLoader")
IconLoader.poolKey = "icon_loader"

function IconLoader:__init()
    self.isReleaser = true
    self.assetLoadCallback = function() self:setIcon() end
end

function IconLoader:__delete()
    self:Releaser()
    self:StopDebugReference()
end

function IconLoader:loadIcon(image, assetPath, name, module, callback, nativeSize,encrypt)
    if UtilsBase.IsNull(image) then LogError("IconLoader传入空的图片对象") return end
    if assetPath == "" or assetPath == nil then LogError("IconLoader传入空的路径") return end
    if image:GetType():ToString() ~= "UnityEngine.UI.Image" then
        LogError("IconLoader传入错误的组件类型:"..tostring(image:GetType():ToString()))
        return
    end

    if name == "" then name = nil end
    if self:checkSameIcon(assetPath,name) and self.image == image then self:noticeCompleted() return end

    --if IS_DEBUG then
        --self.debug = debug.traceback()
    --end

    self:Releaser()
    self:clearAutoReleaser()

    --self:onReset()

    self.isLoaded = false
    self.image = image
    self.path = assetPath
    self.name = name
    self.module = module
    self.callback = callback
    --self.resList = {{path = self.path, type = AssetType.Object, holdTime = 60, loadType = AssetLoadType.PureSync}}
    self.resList = {{path = self.path, type = AssetType.Object, holdTime = 60}}
    self.assetLoader = nil
    --self.autoReleaser = nil
    --self.assetLoadCallback = nil
    self.nativeSize = nativeSize
    
    --self.transform = self.image.transform
    --self.originScale = self.transform.localScale
    self.image.enabled = false
    self.encrypt = encrypt
    --  UnityUtils.setLocalScale(self.image.transform,0,1,1)
    self:load()
end

function IconLoader:__delete()
    self:OnReset()
end

function IconLoader:load()
    self.assetLoader = AssetBatchLoader.New()
    self.assetLoader:AddListener(self.assetLoadCallback)
    self.assetLoader:LoadAll(self.resList)
end

function IconLoader:checkSameIcon(assetPath,name)
    if not self.isLoaded then return false end
    if self.path == assetPath and self.name == name then return true end
    return false
end

function IconLoader:setIcon()
    --self:decreaseReference()
    --if self.autoReleaser == nil then
    --    self.autoReleaser = self.image.gameObject:AddComponent(IconAutoReleaser)
    --end

    --self.autoReleaser.path = self.path
    if UtilsBase.IsNull(self.image) then 
        self:clearAutoReleaser()
        LogError("不应该先删除icon对象:" .. tostring(self.path).."\n")
        return 
    end

    self.isLoaded = true
    AssetMgrProxy.Instance:IncreaseReferenceCount(self.path)
    self.isReleaser = false
    self.image.enabled = true
    self:setSingleSprite()
    self:setAtlasSprite()
    self:clearAutoReleaser()
    self:noticeCompleted()
    if self.nativeSize then self.image:SetNativeSize() end
    self:DebugReference()
end

function IconLoader:DebugReference()
    if not IS_DEBUG then return end
    self.debugTimer = TimerManager.Instance:AddTimer(0,3,self:ToFunc("CheckReference"))
end

function IconLoader:CheckReference()
    if not self._isCreate and not self.isReleaser then
        LogErrorFormat("Icon引用泄露[%s][创建堆栈:\n%s]",tostring(self.path),self.debug)
    elseif UtilsBase.IsNull(self.image) and not self.isReleaser then
        LogErrorFormat("Icon引用泄露[%s][创建堆栈:\n%s]",tostring(self.path),self.debug)
    end
end

function IconLoader:StopDebugReference()
    if not self.debugTimer then return end
    TimerManager.Instance:RemoveTimer(self.debugTimer)
    self.debugTimer = nil
end


function IconLoader:setSingleSprite()
    if self.name ~= nil then return end
    
    if self.encrypt then
        self.image.sprite = EncryptImageUtils.LoadEncryptImage(self.assetLoader:Pop(self.path))
    else
        self.image.sprite = self.assetLoader:Pop(self.path)
    end
end

function IconLoader:setAtlasSprite()
    if self.name == nil then return end
    self.image.sprite = AssetManager.GetSubObject(self.path, self.name)
    if self.image.sprite ~= nil then return end
    LogDebug(string.format("icon资源异常:[path:%s][name:%s]", self.path, self.name))
    local assetList = AssetManager.GetSubObjectNames(self.path)
    self.image.sprite = AssetManager.GetSubObject(self.path, assetList[1])
end

function IconLoader:noticeCompleted()
    if self.callback == nil then return end
    if self.module == nil then self.callback(self.image) return end
    self.callback(self.module, self.image)
end

function IconLoader:clearAutoReleaser()
    if self.assetLoader == nil then return end
    self.assetLoader:RemoveListener(self.assetLoadCallback)
    self.assetLoader:DeleteMe()
    self.assetLoader = nil
end

function IconLoader:OnReset()
    local image = self.image
    local path = self.path
    local isLoaded = self.isLoaded
    self:clearAutoReleaser()
    self.module = nil
    self.image = nil
    --self.path = nil
    self.name = nil
    self.callback = nil
    self.originColor = nil
    self.resList = nil
    --self.autoReleaser = nil
    --self.assetLoadCallback = nil
    self.transform = nil

    self:Releaser()
    if image ~= nil and not UtilsBase.IsNull(image) then 
        image.enabled = true
    end

    self:StopDebugReference()
end

function IconLoader:Releaser()
    local path = self.path
    if not self.isLoaded or path == nil then return end
    self.isLoaded = false
    self.path = nil
    AssetMgrProxy.Instance:DecreaseReferenceCount(path)
    if self.encrypt then
        if not UtilsBase.IsNull(self.image) then
            GameObject.Destroy(self.image.sprite.texture)
        end
    end
    self.isReleaser = true
end