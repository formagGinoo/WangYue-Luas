PartnerBagFacade = BaseClass("PartnerBagFacade",Facade)

function PartnerBagFacade:__init()
end

function PartnerBagFacade:__InitFacade()
    self:BindCtrl(PartnerBagCtrl)
    self:BindProxy(PartnerBagProxy)
end