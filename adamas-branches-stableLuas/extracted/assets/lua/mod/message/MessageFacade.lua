MessageFacade = BaseClass("MessageFacade",Facade)

function MessageFacade:__init()

end

function MessageFacade:__InitFacade()
    self:BindCtrl(MessageCtrl)

    self:BindProxy(MessageProxy)
end