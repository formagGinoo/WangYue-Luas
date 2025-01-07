StoryFacade = BaseClass("StoryFacade",Facade)

function StoryFacade:__init()

end

function StoryFacade:__InitFacade()
    self:BindCtrl(StoryCtrl)
	self:BindProxy(StoryProxy)
end