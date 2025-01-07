ActivityFacade = BaseClass("ActivityFacade",Facade)

function ActivityFacade:__init()
end

function ActivityFacade:__InitFacade()
	self:BindCtrl(ActivityCtrl)
	self:BindProxy(ActivityProxy)
end