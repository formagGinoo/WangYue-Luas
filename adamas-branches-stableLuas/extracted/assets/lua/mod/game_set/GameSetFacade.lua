GameSetFacade = BaseClass("GameSetFacade",Facade)

function GameSetFacade:__init()

end

function GameSetFacade:Init()

end

function GameSetFacade:__InitFacade()
	self:BindCtrl(GameSetCtrl)
end