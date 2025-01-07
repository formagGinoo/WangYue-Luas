ExtendView = BaseClass("ExtendView",Module)
ExtendView._extendView = true

function ExtendView:__init(mainView)
    self.MainView = mainView
end

function ExtendView:__delete()

end

function ExtendView:SetSprite(image,path,name,defaultName)
    self.MainView:SetSprite(image,path,name,defaultName)
end

function ExtendView:RemoveSprite(image)
    self.MainView:RemoveSprite(image)
end

function ExtendView:Active()
    return self.MainView:Active()
end

function ExtendView:Find(path,component,transform)
    return self.MainView:Find(path,component,transform)
end

function ExtendView:GetAsset(file)
    return self.MainView:GetAsset(file)
end

function ExtendView:GetListener()
    return self.MainView:GetListener()
end

function ExtendView:BindEvent(event)
    self.MainView:BindEvent(event,self)
end

function ExtendView:BindLastingEvent(event)
    self.MainView:BindLastingEvent(event,self)
end

function ExtendView:BindBeforeEvent(event)
    self.MainView:BindBeforeEvent(event,self)
end

function ExtendView:SetTopLayer(canvas)
    self.MainView:SetTopLayer(canvas)
end

function ExtendView:SetActive(transform,active,isScale,x,y,z)
    BaseUtils.SetActive(transform,active,isScale,x,y,z)
end

function ExtendView:__CacheObject() end
function ExtendView:__Create() end
function ExtendView:__Show(args) end
function ExtendView:__RepeatShow(args) end
function ExtendView:__BindBeforeEvent() end
function ExtendView:__BindEvent() end
function ExtendView:__BindLastingEvent() end
function ExtendView:__BindListener() end
function ExtendView:__Hide() end