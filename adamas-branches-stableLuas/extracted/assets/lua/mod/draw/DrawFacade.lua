DrawFacade = BaseClass("DrawFacade", Facade)

function DrawFacade:__init()

end

function DrawFacade:__InitFacade()
	self:BindCtrl(DrawCtrl)
	self:BindProxy(DrawProxy)
end