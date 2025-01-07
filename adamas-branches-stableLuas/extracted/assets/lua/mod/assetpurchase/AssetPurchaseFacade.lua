AssetPurchaseFacade = BaseClass("AssetPurchaseFacade",Facade)

function AssetPurchaseFacade:__init()

end

function AssetPurchaseFacade:__InitFacade()
	self:BindCtrl(AssetPurchaseCtrl)
	self:BindProxy(AssetPurchaseProxy)
end