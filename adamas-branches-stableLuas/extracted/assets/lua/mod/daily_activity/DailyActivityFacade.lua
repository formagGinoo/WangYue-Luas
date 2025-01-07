DailyActivityFacade = BaseClass("DailyActivityFacade",Facade)

function DailyActivityFacade:__init()
end

function DailyActivityFacade:__InitFacade()
	self:BindCtrl(DailyActivityCtrl)
	self:BindProxy(DailyActivityProxy)
end