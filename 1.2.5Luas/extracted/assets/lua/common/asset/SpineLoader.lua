-- spine Loader
-- @lizc
SpineLoader = BaseClass("SpineLoader")

function SpineLoader:__init(spineName, callback)
    self.callback = callback
    self.spineName = spineName
    
    -- 是否中途取消
    self.canceled = false
    self.modelPath = string.format(AssetConfig.spine_prefix_path, spineName)

    self.resList = {}
    local filePath = {path = self.modelPath, type = AssetType.Prefab}
    table.insert(self.resList, filePath)

    self.assetLoader = AssetBatchLoader.New(string.format("SpineLoader[%s]", spineName))
end

function SpineLoader:__delete()
    if self.assetLoader ~= nil then
        self.canceled = true
        self.assetLoader:DeleteMe()
        self.assetLoader = nil
    end
end

function SpineLoader:Load()    
    local assetLoadCompletedCallback = function()
        if self.canceled then
            self.assetLoader:DeleteMe()
            self.assetLoader = nil
        else
            self:BuildModel()
            if self.callback then
                --把self作为参数传递，方便在回调里将此Loader DeleteMe，当然，可用可不用
                self.callback(self.gameObject)
            end
            self.assetLoader:DeleteMe()
            self.assetLoader = nil
        end
    end
    self.assetLoader:AddListener(assetLoadCompletedCallback)
    self.assetLoader:LoadAll(self.resList)
end

--取消加载
function SpineLoader:Cancel()
    self.canceled = true
end

function SpineLoader:BuildModel()
    self.gameObject = self.assetLoader:Pop(self.modelPath)
end