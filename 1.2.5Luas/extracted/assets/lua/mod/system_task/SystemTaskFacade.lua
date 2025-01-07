SystemTaskFacade = BaseClass("SystemTaskFacade",Facade)

function SystemTaskFacade:__init()
end

function SystemTaskFacade:__InitFacade()
	self:BindCtrl(SystemTaskCtrl)
	self:BindProxy(SystemTaskProxy)
end