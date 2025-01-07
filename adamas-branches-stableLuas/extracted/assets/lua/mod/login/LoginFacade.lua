LoginFacade = BaseClass("LoginFacade",Facade)

function LoginFacade:__init()

end

function LoginFacade:__InitFacade()
    self:BindCtrl(LoginCtrl)

    self:BindProxy(LoginProxy)
end