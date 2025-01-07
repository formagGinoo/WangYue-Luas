TextMsgBox = BaseClass("TextMsgBox", BaseView)

function TextMsgBox:__init(msgBoxType)
	self:SetAsset("Prefabs/UI/Common/TextMsgBox.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)

	self.msgBoxType = msgBoxType
	self.tipsContent = ""
	self.confirmCallback = nil
	self.cancelCallback = nil
end

function TextMsgBox:__Create()
	self.SubmitText_txt.text = TI18N("确认")
	self.CancelText_txt.text = TI18N("取消")
end

function TextMsgBox:__CacheObject()
	self.canvas = self.transform:GetComponent(Canvas)
	self.canvas.overrideSorting = true
end

function TextMsgBox:__delete()
end

function TextMsgBox:__Show()
	self:SetBlurBack()
	self:SetActive(false)
	self.isSubmit = false
	self.ContentText_txt.text = self.tipsContent
	self.TitleText_txt.text = TI18N("提示")
	self.Cancel:SetActive(self.cancelCallback ~= nil)
	self.canvas.sortingOrder = WindowManager.Instance:GetCurOrderLayer() + 100
	if self.submitText then
		self.SubmitText_txt.text = self.submitText
	end
	if self.hideCloseBtn then
		self.CommonGrid:SetActive(false)
		self.CommonBack1:SetActive(false)
	end
end

function TextMsgBox:__ShowComplete()
end

function TextMsgBox:__BindListener()
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClickSubmitButton"))
	self.Cancel_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
	self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
	self.CommonGrid_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function TextMsgBox:__Hide()
	if self.hideCloseBtn then
		self.CommonGrid:SetActive(true)
		self.CommonBack1:SetActive(true)
	end
	self.hideCloseBtn = nil
	self.confirmCallback = nil
	self.cancelCallback = nil
	self.closeCallback = nil
	self.submitText = nil
end

function TextMsgBox:SetSubmitText(submitText)
	self.submitText = submitText
	if self.active then
		self.SubmitText_txt.text = submitText
	end
end

function TextMsgBox:HideCloseBtn()
	self.hideCloseBtn = true
	if self.active then
		self.CommonGrid:SetActive(false)
		self.CommonBack1:SetActive(false)
	end
end

function TextMsgBox:ResetView(content, confirmFunc, cancelFunc, closeFunc)
	self.tipsContent = content
	self.confirmCallback = confirmFunc
	self.cancelCallback = cancelFunc
	self.closeCallback = closeFunc
end

function TextMsgBox:OnClickSubmitButton()
	if self.confirmCallback ~= nil then
		self.confirmCallback()
	end
	self.isSubmit = true
	self:PlayExitAnim()
end

function TextMsgBox:OnClickCancalButton()
	if self.cancelCallback ~= nil then
		self.cancelCallback()
	end
end

function TextMsgBox:__BeforeExitAnim()
	if self.isSubmit then
		return
	end
	if self.closeCallback ~= nil then
		self.closeCallback()
	elseif self.cancelCallback ~= nil then
		self.cancelCallback()
	end
end

function TextMsgBox:__AfterExitAnim()
	MsgBoxManager.Instance:HideMsgBox(self)
end