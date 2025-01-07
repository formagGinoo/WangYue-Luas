AnnouncementFacade = BaseClass("AnnouncementFacade",Facade)

function AnnouncementFacade:__init()

end

function AnnouncementFacade:__InitFacade()
	self:BindCtrl(AnnouncementCtrl)
	self:BindProxy(AnnouncementProxy)
end