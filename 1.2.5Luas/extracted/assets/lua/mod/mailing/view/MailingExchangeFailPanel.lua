MailingExchangeFailPanel = BaseClass("MailingExchangeFailPanel", BasePanel)

function MailingExchangeFailPanel:__init()
	self:SetAsset("Prefabs/UI/Mailing/MailingExchangeFailPanel.prefab")
	
	self.blurBack = nil
end

function MailingExchangeFailPanel:__BindListener()
	self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClose"))
	self.ConfirmBtn_btn.onClick:AddListener(self:ToFunc("OnClose"))
	UtilsUI.SetHideCallBack(self.MailingExchangeFailPanel_Exit, self:ToFunc("Close_HideCallBack"))
end

function MailingExchangeFailPanel:__CacheObject()

end

function MailingExchangeFailPanel:__Create()
end

function MailingExchangeFailPanel:__delete()
	if self.blurBack then
		self.blurBack:Destroy()
	end
	
	if self.modelRtView then
		self.modelRtView:DeleteMe()
	end
end

function MailingExchangeFailPanel:__ShowComplete()
	if not self.blurBack then
		local setting = { bindNode = self.BlurNode }
		self.blurBack = BlurBack.New(self, setting)
	end
	self:SetActive(false)
	self.blurBack:Show({self:ToFunc("AfterBlurShow")})
end

function MailingExchangeFailPanel:__Hide()
	if self.blurBack then
		self.blurBack:Hide()
	end
	
	if self.modelRtView then
		self.modelRtView:Hide()
	end
end

function MailingExchangeFailPanel:__Show()
	self.parent = self.args
	self.Node:SetActive(false)
end

function MailingExchangeFailPanel:OnClose()
	--self.parent:ClosePanel(self)
	self.MailingExchangeFailPanel_Exit:SetActive(true)
end

function MailingExchangeFailPanel:Close_HideCallBack()
	self.parent:ClosePanel(self)
end

function MailingExchangeFailPanel:PlayDisappointedAnim()
	self.Node:SetActive(true)
	self.MailingModel:SetActive(true)
	if self.modelRtView then
		local animtor = self.modelRtView.showModel:GetComponentInChildren(Animator)
		if animtor then
			animtor:Play("DisapointLoop")
		end
	end
end

function MailingExchangeFailPanel:AfterBlurShow()
	if not self.modelRtView then
		self.modelRtView = ModelRtView.New(self, self.MailingModel_rimg, true, self:ToFunc("PlayDisappointedAnim"))
		self.modelRtView:SetCameraPosition(0, 0.25, 0.6)
	end
	
	if self.modelRtView then
		self.MailingModel:SetActive(false)
		self.modelRtView:ShowModel("Mailing")
		self.modelRtView:Show()
	end
end