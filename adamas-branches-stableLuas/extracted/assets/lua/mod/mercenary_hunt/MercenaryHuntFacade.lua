MercenaryHuntFacade = BaseClass("MercenaryHuntFacade",Facade)

function MercenaryHuntFacade:__init()
end

function MercenaryHuntFacade:__InitFacade()
	self:BindCtrl(MercenaryHuntCtrl)
	self:BindProxy(MercenaryHuntProxy)
end