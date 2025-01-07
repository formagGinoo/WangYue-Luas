AlchemyFacade = BaseClass("AlchemyFacade", Facade)

function AlchemyFacade:__init()

end

function AlchemyFacade:__InitFacade()
    self:BindCtrl(AlchemyCtrl)
    self:BindProxy(AlchemyProxy)
end