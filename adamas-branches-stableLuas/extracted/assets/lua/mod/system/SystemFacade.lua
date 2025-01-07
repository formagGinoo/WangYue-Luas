SystemFacade = BaseClass("SystemFacade",Facade)

function SystemFacade:__init()
end

function SystemFacade:__InitFacade()
	self:BindCtrl(SystemCtrl)
	self:BindProxy(SystemProxy)
end