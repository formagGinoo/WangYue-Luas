PartnerCenterFacade = BaseClass("PartnerCenterFacade",Facade)

function PartnerCenterFacade:__init()

end

function PartnerCenterFacade:__InitFacade()
    self:BindCtrl(PartnerCenterCtrl)
    self:BindProxy(PartnerCenterProxy)
end

