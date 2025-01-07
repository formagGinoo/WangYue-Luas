TaskFacade = BaseClass("TaskFacade",Facade)

function TaskFacade:__init()

end

function TaskFacade:__InitFacade()
    self:BindCtrl(TaskCtrl)

    self:BindProxy(TaskProxy)
end