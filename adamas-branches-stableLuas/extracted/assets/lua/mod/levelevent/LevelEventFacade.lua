LevelEventFacade = BaseClass("LevelEventFacade",Facade)

function LevelEventFacade:__init()

end

function LevelEventFacade:__InitFacade()
    self:BindCtrl(LevelEventCtrl)
    self:BindProxy(LevelEventProxy)
end