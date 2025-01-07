PhotoFacade = BaseClass("PhotoFacade", Facade)

function PhotoFacade:__init()

end

function PhotoFacade:__InitFacade()
    self:BindCtrl(PhotoCtrl)
    self:BindProxy(PhotoProxy)
end