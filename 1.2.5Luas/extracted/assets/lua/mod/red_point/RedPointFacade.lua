RedPointFacade = BaseClass("RedPointFacade",Facade)

function RedPointFacade:__init()

end

function RedPointFacade:__InitFacade()
    RedPointMgr.Instance:InitRedTree()
end