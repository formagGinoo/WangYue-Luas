BargainFacade = BaseClass("BargainFacade", Facade)

function BargainFacade:__init()

end

function BargainFacade:__InitFacade()
    self:BindCtrl(BargainCtrl)
    self:BindProxy(BargainProxy)
end