ShopFacade = BaseClass("ShopFacade",Facade)

function ShopFacade:__init()

end

function ShopFacade:__InitFacade()
	self:BindCtrl(ShopCtrl)
	self:BindProxy(ShopProxy)
end