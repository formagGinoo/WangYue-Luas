GmFacade = BaseClass("GmFacade",Facade)

function GmFacade:__init()
end

function GmFacade:__InitFacade()
	self:BindCtrl(GmCtrl)
	self:BindProxy(GmProxy)
end