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

function TextMsgBox:__Show()
	self.ContentText_txt.text = self.tipsContent
	-- if self.cancelCallback == nil then
	-- 	self.CancalButton:SetActive(false)
	-- 	--按钮1居中
	-- 	self.defaultSubmitButtonPos = self.Submit_rect.anchoredPosition
	-- 	self.Submit_rect.anchoredPosition = Vector2.zero
	-- end
end

function TextMsgBox:__BindListener()
	self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.Submit_btn,self:ToFunc("Back"),self:ToFunc("OnClickSubmitButton"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Back"),self:ToFunc("OnClickCancalButton"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Back"),self:ToFunc("OnClickCancalButton"))
end

function TextMsgBox:__Hide()
	if self.defaultSubmitButtonPos ~= nil then
		self.CancalButton:SetActive(true)
		self.Submit_rect.anchoredPosition = self.defaultSubmitButtonPos
	end
end

function TextMsgBox:ResetView(content, confirmFunc, cancelFunc)
	self.tipsContent = content
	self.confirmCallback = confirmFunc
	self.cancelCallback = cancelFunc
end

function TextMsgBox:OnClickSubmitButton()
	if self.confirmCallback ~= nil then
		self.confirmCallback()
	end
end

function TextMsgBox:OnClickCancalButton()
	if self.cancelCallback ~= nil then
		self.cancelCallback()
	end
end

function TextMsgBox:Back()
	MsgBoxManager.Instance:HideMsgBox(self)
end