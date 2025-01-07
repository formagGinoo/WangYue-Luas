BaseIconLoader = BaseClass("BaseIconLoader")
BaseIconLoader.isBaseIconLoader = true

function BaseIconLoader:__init()
    self.iconLoaders = nil
end

function BaseIconLoader:setSprite(image,path,name,nativeSize)
    self:initIconLoaders()
    self:loadIcon(image,path,name,nativeSize)
end

--function BaseIconLoader:isSameIconLoader(image,path,name)
--    if self.iconLoaders[image] == nil then return false end
--    return self.iconLoaders[image]:isSameLoader(path,name)
--end

function BaseIconLoader:loadIcon(image,path,name,nativeSize)
    local loader = self.iconLoaders[image]
    if loader == nil then 
        loader = PoolManager.Instance:Pop(PoolType.class,IconLoader.poolKey) or IconLoader.New() 
        self.iconLoaders[image] = loader 
    end
    loader:loadIcon(image,path,name,nil,nil,nativeSize)
end

--function BaseIconLoader:onIconLoaderCompleted(image)
    --self:pushIconLoader(image)
    --self.iconLoaders[image] = nil
--end

function BaseIconLoader:pushAllIconLoader()
    if self.iconLoaders == nil then return end
    for k,v in pairs(self.iconLoaders) do self:pushIconLoader(k) end
    self.iconLoaders = nil
end

function BaseIconLoader:pushIconLoader(image)
    if self.iconLoaders == nil then return end
    local loader = self.iconLoaders[image]
    if loader == nil then return end
    PoolManager.Instance:Push(PoolType.class,IconLoader.poolKey,loader)
    self.iconLoaders[image] = nil
end

function BaseIconLoader:initIconLoaders()
    if self.iconLoaders ~= nil then return end
    self.iconLoaders = {}
end
