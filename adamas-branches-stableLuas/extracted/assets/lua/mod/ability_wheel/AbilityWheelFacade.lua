AbilityWheelFacade = BaseClass("AbilityWheelFacade", Facade)

function AbilityWheelFacade:__init()

end

function AbilityWheelFacade:__InitFacade()
    self:BindCtrl(AbilityWheelCtrl)
    self:BindProxy(AbilityWheelProxy)
end