NightMareDuplicateFacade = BaseClass("NightMareDuplicateFacade",Facade)

function NightMareDuplicateFacade:__init()
end

function NightMareDuplicateFacade:__InitFacade()
    self:BindCtrl(NightMareDuplicateCtrl)
    self:BindProxy(NightMareDuplicateProxy)
end