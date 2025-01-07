MailingFacade = BaseClass("MailingFacade",Facade)

function MailingFacade:__init()

end

function MailingFacade:__InitFacade()
	self:BindCtrl(MailingCtrl)
	self:BindProxy(MailingProxy)
end