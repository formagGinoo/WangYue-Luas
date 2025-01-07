---@class RoleFacade : Facade
RoleFacade = BaseClass("RoleFacade",Facade)

function RoleFacade:__init()

end

function RoleFacade:__InitFacade()
	self:BindCtrl(RoleCtrl)

	self:BindProxy(RoleProxy)
end