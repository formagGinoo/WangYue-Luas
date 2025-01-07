-- 资源预加载
PreloadManager = BaseClass("PreloadManager")

function PreloadManager:__init()
    if PreloadManager.Instance then
        LogError("不可以对单例对象重复实例化")
    end
    PreloadManager.Instance = self;



    self.cellbc = function(filePath)
        self:UpdateProgress(filePath)
    end

    self.resList = {
        -- {path = AssetConfig.syht_heavy, type = AssetType.Asset, callback = self.cellbc}
        -- {path = AssetConfig.carp, type = AssetType.Asset, callback = self.cellbc}
        --,{path = AssetConfig.unlit_texture_shader, type = AssetType.Asset, callback = self.cellbc}
        {path = AssetConfig.wwiseEventBank, type = AssetType.Object, callback = self.cellbc}
        ,{path = AssetConfig.quality_data, type = AssetType.Object, callback = self.cellbc}
        ,{path = AssetConfig.ui_bank, isSoundBank = true, holdTime = -1, callback = self.cellbc}
        -- ,{path = AssetConfig.npc_common_bank, isSoundBank = true, holdTime = -1, callback = self.cellbc}
        -- ,{path = AssetConfig.terrain_bank, isSoundBank = true, holdTime = -1, callback = self.cellbc}
        ,{path = AssetConfig.bgm_logic_bank, isSoundBank = true, holdTime = -1, callback = self.cellbc}
        ,{path = AssetConfig.action_bank, isSoundBank = true, holdTime = -1, callback = self.cellbc}
        -- ,{path = AssetConfig.graphic, type = AssetType.Prefab, callback = self.cellbc}
        
        -- ,{path = AssetConfig.mainui_icon_prefab, type = AssetType.Asset, callback = self.cellbc}
        -- ,{path = AssetConfig.demo_multiple_icon_task, type = AssetType.Asset, callback = self.cellbc}
        --,{path = AssetConfig.sound_effct_214_path, type = AssetType.Asset, callback = self.cellbc}
        -- ,{path = AssetConfig.graphic, type = AssetType.Prefab, callback = self.cellbc}
        -- ,{path = AssetConfig.proto, type = AssetType.Asset, callback = self.cellbc}
    }

    self.assetCache = {}

    self.assetLoader = nil
    self.progress = 0
    self.total = #self.resList
end

function PreloadManager:__delete()
end

function PreloadManager:Preload(callback)
    ctx.LoadingPage:Show(TI18N("预加载文件(0%)"))
    if self.assetLoader == nil then
        local cbfunc = function()
            self.finish = true
			--CustomUnityUtils.ShaderFindUtilInit()
            callback()
        end
        self.assetLoader =  AssetMgrProxy.Instance:GetLoader("PreloadManager")
        self.assetLoader:AddListener(cbfunc)
        self.assetLoader:LoadAll(self.resList)
    else
        LogError("PreloadManager不可以重复加载")
    end
end

-- 更新进度条
function PreloadManager:UpdateProgress(filePath)
    self.progress = self.progress + 1
    if self.progress > self.total then
        self.progress = self.total
    end

    local percent = (self.progress / self.total) * 100
    ctx.LoadingPage:Progress(string.format(TI18N("预加载文件(%0.1f%%)"), tostring(percent)), percent)
end

function PreloadManager:GetGameObject(path, notCache)
    if not notCache then
        return self:GetObject(path)
    else
        return self.assetLoader:Pop(path)
    end
end

function PreloadManager:GetObject(path)
    if self.assetCache[path] ~= nil then
        return self.assetCache[path]
    else
        local asset = self.assetLoader:Pop(path)
        self.assetCache[path] = asset
        AssetMgrProxy.Instance:IncreaseReferenceCount(path)
        return asset
    end
end

-- 设置Icon
function PreloadManager:SetIcon(gameObject, path, name)
    if not self.assetLoader:Contain(path) then
        LogError("PreloadManager:GetSprite出错，该文件并没有预加载:" .. path)
    else
        -- 这一句不能直接调用
        local sprite = AssetManager.GetSubObject(path, name)
        AssetMgrProxy.Instance:SetIcon(gameObject, sprite, path)
    end
end

function PreloadManager:GetEffectSoundClip(name)
    return self:GetSubObject("sound$effect.folder", name)
end

-- 获取子资源
-- 预加载文件才可以这样写
function PreloadManager:GetSubObject(physicalPath, name)
    local obj = AssetManager.GetSubObjectByPhysicalPath(physicalPath, name)
    if obj ~= nil then
        return obj
    else
        return nil
    end
end
