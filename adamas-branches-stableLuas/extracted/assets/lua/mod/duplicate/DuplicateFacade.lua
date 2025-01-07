DuplicateFacade = BaseClass("DuplicateFacade",Facade)

function DuplicateFacade:__init()
end

function DuplicateFacade:__InitFacade()
    self:BindCtrl(DuplicateCtrl)
    self:BindProxy(DuplicateProxy)
end