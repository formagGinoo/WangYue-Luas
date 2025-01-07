-- 单icon加载
SingleIconLoader = BaseClass("SingleIconLoader")
function SingleIconLoader.Load(gameObject, path, callback, loadType)
    if not gameObject then
        LogError("加载图标的gameobject为空")
        return
    end
    if not path then
        LogError("加载图标的path为空")
        return
    end
    CustomUnityUtils.SetSingleSprite(gameObject, path, callback, loadType or AssetLoadType.BothAsync)
end

function SingleIconLoader:__init()
    
end

function SingleIconLoader:__delete()
end

function SingleIconLoader:OnReset()

end