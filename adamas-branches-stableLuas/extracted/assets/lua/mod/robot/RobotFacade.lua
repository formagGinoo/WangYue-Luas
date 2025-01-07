RobotFacade = BaseClass("RobotFacade",Facade)

function RobotFacade:__init()
end

function RobotFacade:__InitFacade()
    self:BindCtrl(RobotCtrl)
    self:BindProxy(RobotProxy)
end