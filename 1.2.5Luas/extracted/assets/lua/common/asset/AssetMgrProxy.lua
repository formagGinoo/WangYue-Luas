-- C# AssetManager的代理，并提供一些资源管理额外的功能
-- 除了预设（GameObject）外，其它所有资源都不自动增加引用数
AssetMgrProxy = BaseClass("AssetMgrProxy",BaseManager)
local _string_format = string.format

function AssetMgrProxy:__init()
    if AssetMgrProxy.Instance then
        LogError("不可以对单例对象重复实例化")
    end
    AssetMgrProxy.Instance = self;
end

function AssetMgrProxy:__delete()
end

-- 增加引用数
function AssetMgrProxy:IncreaseReferenceCount(path)
    if AssetBatchLoader.UseLocalRes then
        return
    end
    AssetManager.IncreaseReferenceCount(path)
end

-- 减少引用数
function AssetMgrProxy:DecreaseReferenceCount(path)
    if AssetBatchLoader.UseLocalRes then
        return
    end
	AssetManager.DecreaseReferenceCount(path)
end

-- 设置Icon
function AssetMgrProxy:SetIcon(gameObject, sprite, path)
    local image = gameObject:GetComponent(Image)
    local autoReleaser = gameObject:GetComponent(IconAutoReleaser)
    if autoReleaser == nil then
        autoReleaser = gameObject:AddComponent(IconAutoReleaser)
    else
        if autoReleaser.path ~= nil and autoReleaser.path ~= "" then
            image.sprite = nil
            self:DecreaseReferenceCount(autoReleaser.path)
        end
    end
    image.sprite = nil
    autoReleaser.path = path
    self:IncreaseReferenceCount(path)
    image.sprite = sprite
end

-- 克隆统一用此方法
-- 同一资源对象需要两个或以上的使用该方法
-- 该方法针对挂上IAutoReleaser的对象，如果是UI预设中的某个节点且节点树中没有挂IAutoReleaser，还是可以使用GameObject.Instantiate方法
function AssetMgrProxy:CloneGameObject(gameObject)
    local go = GameObject.Instantiate(gameObject)
	if AssetBatchLoader.UseLocalRes and ctx.Editor then
	else
	    local releaser = go:GetComponentsInChildren(IAutoReleaser, true)
	    local length = releaser.Length
	    for i = 1, length do
	        releaser[i - 1]:OnClone()
	        --releaser[i]:OnClone()
	    end
	end
    return go
end

function AssetMgrProxy:ChangeSprite(gameObject, name)
    local image = gameObject:GetComponent(Image)
    local atlasPath = image.spriteKey
    local s, t = string.find(atlasPath, "folderSprite")
    local physicalPath = nil
    if s ~= nil then
        physicalPath = string.sub(atlasPath, 0, s + 5)
        local obj = AssetManager.GetSubObjectByPhysicalPath(physicalPath, name)
        if obj ~= nil then
            image.sprite = obj
        else
            LogError("ChangeSprite出错了，找不到subSprite信息:[" .. image.name .. ":" .. name .. "]")
        end
    else
        LogError("ChangeSprite出错了，找不到spriteKey信息:[" .. image.name .. ":" .. name .. "]")
    end
end

function AssetMgrProxy:DoUnloadUnusedAssets()
    ctx:DoUnloadUnusedAssets() -- 清理资源
end

function AssetMgrProxy.ToAssetPath(path)
    local targetPath = Application.streamingAssetsPath .. "/" .. path

    if ctx.Editor then
        targetPath = "file:///" .. ctx.EditorResPath .. "/" .. path
        return targetPath
    end

    if AssetManager.ExistLocalAsset(path) then
        if Application.platform == RuntimePlatform.Android then
            return AssetManager.LocalResPath .. "/" .. path
        else
            return "file:///" .. ctx.LocalResPath .. "/" .. path
        end
    else
        if Application.platform == RuntimePlatform.Android then
            return Application.dataPath .. "!assets/" .. path
        elseif Application.platform == RuntimePlatform.IPhonePlayer then
            return "file:///" .. Application.streamingAssetsPath .. "/" .. path
        else
             return "file:///" .. Application.streamingAssetsPath .. "/" .. path
        end
    end
end

function AssetMgrProxy.ConvertUrlToPath(url)
     if Application.platform == RuntimePlatform.Android then
         return url
     else
        return string.gsub(url,"file:///", "")
     end
end