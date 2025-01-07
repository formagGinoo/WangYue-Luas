GuideFacade = BaseClass("GuideFacade",Facade)

function GuideFacade:__init()

end

function GuideFacade:__InitFacade()
    self:BindCtrl(GuideCtrl)
    self:BindProxy(GuideProxy) 
end