---@class BagFacade : Facade
BagFacade = BaseClass("BagFacade", Facade)

function BagFacade:__init()

end

function BagFacade:__InitFacade()
    self:BindCtrl(BagCtrl)
    self:BindProxy(BagProxy)
end