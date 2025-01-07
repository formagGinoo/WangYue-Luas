UnlockFacade = BaseClass("UnlockFacade",Facade)

function UnlockFacade:__init()
end

function UnlockFacade:__InitFacade()
	self:BindCtrl(UnlockCtrl)
	self:BindProxy(UnlockProxy)
end