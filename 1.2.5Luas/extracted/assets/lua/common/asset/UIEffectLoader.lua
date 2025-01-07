-- UI特效 Loader
-- @ljh
UIEffectLoader = BaseClass("UIEffectLoader")

function UIEffectLoader:__init(effectId, callback)
	self.effectId = effectId
	self.callback = callback
    -- 是否中途取消
    self.cancel = false

     -- 分包逻辑需要使用的内容
    self.resData = {
    	effectId = self.effectId
    	,effectPath = string.format(AssetConfig.effect_path, self.effectId)
	}
end

function UIEffectLoader:Load()
    local resList = {
        {path = self.resData.effectPath, type = AssetType.Prefab}
    }
    
    local callback = function()
        if self.cancel then
            self.assetLoader:DeleteMe()
            self.assetLoader = nil
        else
            self:BuildEffect()
        end
    end
    self.assetLoader = AssetBatchLoader.New("UIEffectLoader[" .. self.resData.effectId.. "]");
    self.assetLoader:AddListener(callback)
    self.assetLoader:LoadAll(resList)
end

function UIEffectLoader:__delete()
    if self.assetLoader ~= nil then
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
end

function UIEffectLoader:Cancel()
    self.cancel = true
end

function UIEffectLoader:BuildEffect()
    if self.assetLoader == nil then
        return
    end
    
    self.effectObject = self.assetLoader:Pop(self.resData.effectPath)
    self.effectObject.name = string.format("Effect_%s", self.effectId)
    self.sortingOrderCtrl = self.effectObject:AddComponent(SortingOrderCtrl)

    if self.callback ~= nil then
        self.callback({effectObject = self.effectObject, sortingOrderCtrl = self.sortingOrderCtrl})
    end
    self.assetLoader:DeleteMe()
    self.assetLoader = nil
end
