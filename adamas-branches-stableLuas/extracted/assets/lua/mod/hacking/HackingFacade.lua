HackingFacade = BaseClass("HackingFacade",Facade)

function HackingFacade:__init()

end

function HackingFacade:__InitFacade()
    self:BindCtrl(HackingCtrl)
    self:BindCtrl(HackingProxy)
end


