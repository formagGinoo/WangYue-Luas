InformationFacade = BaseClass("InformationFacade",Facade)

function InformationFacade:__init()

end

function InformationFacade:__InitFacade()
	self:BindCtrl(InformationCtrl)

	self:BindProxy(InformationProxy)
end