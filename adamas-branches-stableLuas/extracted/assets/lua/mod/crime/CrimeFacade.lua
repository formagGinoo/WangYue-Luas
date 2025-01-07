---@class CrimeFacade : Facade
CrimeFacade = BaseClass("CrimeFacade", Facade)

function CrimeFacade:__init()

end

function CrimeFacade:__InitFacade()
    self:BindCtrl(CrimeCtrl)
    self:BindProxy(CrimeProxy)
end