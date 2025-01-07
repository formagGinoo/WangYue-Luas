AssetTaskFacade = BaseClass("AssetTaskFacade",Facade)

function AssetTaskFacade:__init()
end

function AssetTaskFacade:__InitFacade()
	self:BindCtrl(AssetTaskCtrl)
	self:BindProxy(AssetTaskProxy)
end