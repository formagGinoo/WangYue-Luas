CreateRoleFacade = BaseClass("CreateRoleFacade",Facade)

function CreateRoleFacade:__init()
end

function CreateRoleFacade:__InitFacade()
	self:BindCtrl(CreateRoleCtrl)
	self:BindProxy(CreateRoleProxy)
end