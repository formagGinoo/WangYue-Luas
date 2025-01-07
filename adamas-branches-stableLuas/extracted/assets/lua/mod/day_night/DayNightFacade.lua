DayNightFacade = BaseClass("DayNightFacade", Facade)

function DayNightFacade:__init()

end

function DayNightFacade:__InitFacade()
	self:BindCtrl(DayNightCtrl)
	self:BindProxy(DayNightPorxy)
end