TaskReviewFacade = BaseClass("TaskReviewFacade",Facade)

function TaskReviewFacade:__init()
end

function TaskReviewFacade:__InitFacade()
	self:BindCtrl(TaskReviewCtrl)
	self:BindProxy(TaskReviewProxy)
end