ResDuplicateFacade = BaseClass("ResDuplicateFacade",Facade)

function ResDuplicateFacade:__init()
end

function ResDuplicateFacade:__InitFacade()
	self:BindCtrl(ResDuplicateCtrl)
	self:BindProxy(ResDuplicateProxy)
end