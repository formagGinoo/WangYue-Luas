DecorationFacade = BaseClass("DecorationFacade", Facade)

function DecorationFacade:__init()

end

function DecorationFacade:__InitFacade()
	self:BindCtrl(DecorationCtrl)
	self:BindProxy(DecorationProxy)
end