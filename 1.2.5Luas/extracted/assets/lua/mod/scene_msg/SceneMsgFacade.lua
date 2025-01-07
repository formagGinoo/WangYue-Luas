SceneMsgFacade = BaseClass("SceneMsgFacade", Facade)

function SceneMsgFacade:__InitFacade()
    self:BindCtrl(SceneMsgCtrl)

	self:BindProxy(SceneMsgProxy)
end