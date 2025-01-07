---@class FormationFacade : Facade
FormationFacade = BaseClass("FormationFacade",Facade)

function FormationFacade:__init()

end

function FormationFacade:__InitFacade()
	self:BindCtrl(FormationCtrl)

	self:BindProxy(FormationProxy)
end