TalentFacade = BaseClass("TalentFacade",Facade)

function TalentFacade:__init()

end

function TalentFacade:__InitFacade()
	self:BindCtrl(TalentCtrl)
	self:BindProxy(TalentProxy)
end