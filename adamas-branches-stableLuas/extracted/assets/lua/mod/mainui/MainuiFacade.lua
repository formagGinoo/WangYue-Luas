MainuiFacade = BaseClass("MainuiFacade",Facade)

function MainuiFacade:__init()

end

function MainuiFacade:__InitFacade()
    self:BindCtrl(MainCtrl)

    self:BindProxy(MainProxy)
end