TeachFacade = BaseClass("TeachFacade",Facade)

function TeachFacade:__init()
end

function TeachFacade:__InitFacade()
	self:BindCtrl(TeachCtrl)
	self:BindProxy(TeachProxy)
end