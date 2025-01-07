FriendFacade = BaseClass("FriendFacade",Facade)

function FriendFacade:__init()

end

function FriendFacade:__InitFacade()
	self:BindCtrl(FriendCtrl)
	self:BindProxy(FriendProxy)
end