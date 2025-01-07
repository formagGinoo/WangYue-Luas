IdentityFacade = BaseClass("IdentityFacade",Facade)

function IdentityFacade:__init()
end

function IdentityFacade:__InitFacade()
	self:BindCtrl(IdentityCtrl)
	self:BindProxy(IdentityProxy)
end