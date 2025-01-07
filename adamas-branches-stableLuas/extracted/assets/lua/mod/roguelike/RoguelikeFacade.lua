RoguelikeFacade = BaseClass("RoguelikeFacade",Facade)

function RoguelikeFacade:__init()
end

function RoguelikeFacade:__InitFacade()
	self:BindCtrl(RoguelikeCtrl)
	self:BindProxy(RoguelikeProxy)
end