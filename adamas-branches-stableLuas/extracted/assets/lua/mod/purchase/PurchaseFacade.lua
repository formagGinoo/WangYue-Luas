PurchaseFacade = BaseClass("PurchaseFacade",Facade)

function PurchaseFacade:__init()

end

function PurchaseFacade:__InitFacade()
    self:BindCtrl(PurchaseCtrl)
    self:BindProxy(PurchaseProxy)
end