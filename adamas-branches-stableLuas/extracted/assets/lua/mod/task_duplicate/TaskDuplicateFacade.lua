TaskDuplicateFacade = BaseClass("TaskDuplicateFacade",Facade)

function TaskDuplicateFacade:__init()
end

function TaskDuplicateFacade:__InitFacade()
    self:BindCtrl(TaskDuplicateCtrl)
    self:BindProxy(TaskDuplicateProxy)
end