MsgBoxManager = SingleClass("MsgBoxManager")

local MsgBoxType = {
	Text = 1,
	Tips = 2,
	Item = 3,
}

function MsgBoxManager:__init()
	self.textMsgBox = nil
	self.tips = nil
	self.itemMsgBox = nil
end

function MsgBoxManager:ShowTextMsgBox(text, confirmFunc, cancelFunc)
	local msgBox = self:GetMsgBox(MsgBoxType.Text)
	if msgBox ~= nil then
		msgBox:ResetView(text, confirmFunc, cancelFunc)
		msgBox:Show()
	end
	return msgBox
end

function MsgBoxManager:ShowItemMsgBox(itemList, tipsText)
	local msgBox = self:GetMsgBox(MsgBoxType.Item)
	if msgBox ~= nil then
		msgBox:ResetView(itemList, tipsText)
		msgBox:Show()
	end
	return msgBox
end

function MsgBoxManager:ShowTips(text, showTime)
	local tips = self:GetMsgBox(MsgBoxType.Tips)
	if tips ~= nil then
		tips:ResetView(text, showTime)
		tips:Show()
	end
	return tips
end

function MsgBoxManager:HideMsgBox(msgBox)
	if msgBox.active then
		msgBox:Hide()
	end
end

function MsgBoxManager:GetMsgBox(msgBoxType)
	local msgBox = nil
	if msgBoxType == MsgBoxType.Text then
		if self.textMsgBox == nil then
			self.textMsgBox = TextMsgBox.New(msgBoxType)
		end
		msgBox = self.textMsgBox
	elseif msgBoxType == MsgBoxType.Tips then
		if self.tips == nil then
			self.tips = TextTips.New(msgBoxType)
		end
		msgBox = self.tips
	elseif msgBoxType == MsgBoxType.Item then
		if self.itemMsgBox == nil then
			self.itemMsgBox = ItemMsgBox.New(msgBoxType)
		end
		msgBox = self.itemMsgBox
	end
	return msgBox
end