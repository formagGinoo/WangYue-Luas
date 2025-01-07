-- SpriteAtlas icon加载
AtlasIconLoader = BaseClass("AtlasIconLoader")

function AtlasIconLoader.Load(gameObject, path, callback)
    if ctx.Editor and AssetBatchLoader.UseLocalRes then
        SingleIconLoader.Load(gameObject, path, callback)
    else
        CustomUnityUtils.SetAtlasSprite(gameObject, path, callback)
    end
end