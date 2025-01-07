MailFacade = BaseClass("MailFacade",Facade)

function MailFacade:__init()

end

function MailFacade:__InitFacade()
	self:BindCtrl(MailCtrl)
	self:BindProxy(MailProxy)
end