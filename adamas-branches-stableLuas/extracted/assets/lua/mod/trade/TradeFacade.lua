TradeFacade = BaseClass("TradeFacade", Facade)

function TradeFacade:__init()
    
end

function TradeFacade:__InitFacade()
	self:BindCtrl(TradeCtrl)

	self:BindProxy(TradeProxy)
end