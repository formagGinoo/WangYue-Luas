BulletChatFacade = BaseClass("BulletChatFacade", Facade)

function BulletChatFacade:__init()

end

function BulletChatFacade:__InitFacade()
    self:BindCtrl(BulletChatCtrl)
    self:BindProxy(BulletChatProxy)
end