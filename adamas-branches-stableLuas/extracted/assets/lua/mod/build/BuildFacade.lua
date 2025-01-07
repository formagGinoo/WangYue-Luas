BuildFacade = BaseClass("BuildFacade",Facade)

function BuildFacade:__init()

end

function BuildFacade:__InitFacade()
    self:BindCtrl(BuildCtrl)
    self:BindCtrl(BuildProxy)
end


