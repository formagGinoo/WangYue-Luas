MsgBoxManager = SingleClass("MsgBoxManager")

local MsgBoxType = {
	Text = 1,
	Tips = 2,
	Item = 3,
	ScrollTips = 4,
}

function MsgBoxManager:__init()
	self.textMsgBox = nil
	self.tips = nil
	self.itemMsgBox = nil
	self.scrollTextTips = nil

	self.showTipsList = {}
	
	self.tipsMap = {}--保存id和预设关系
end

--- func desc
---@param text any
---@param confirmFunc any 确认回调
---@param cancelFunc any 取消回调
---@param closeFunc any 关闭回调
function MsgBoxManager:ShowTextMsgBox(text, confirmFunc, cancelFunc, closeFunc)
	local msgBox = self:GetMsgBox(MsgBoxType.Text)
	if msgBox ~= nil then
		msgBox:ResetView(text, confirmFunc, cancelFunc, closeFunc)
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

function MsgBoxManager:ShowTips(text, showTime, originId, immediately)
	if self.tips and self.tips.active and not immediately then
		if self.tips.content == text then
			return
		end
		table.insert(self.showTipsList,{text = text,showTime = showTime})
	else
		local tips = self:GetMsgBox(MsgBoxType.Tips)
		if tips ~= nil then
			tips:ResetView(text, showTime)
			tips:Show()
		end
		if originId then
			self.tipsMap[originId] = tips
		end
		return tips
	end
end

function MsgBoxManager:ShowTipsImmediate(text, showTime)
	local tips = self:GetMsgBox(MsgBoxType.Tips)
	if tips ~= nil then
		tips:ResetView(text, showTime)
		tips:Show()
	end
	return tips
end

function MsgBoxManager:ShowScrollTips(text)
	local tips = self:GetMsgBox(MsgBoxType.ScrollTips)
	if tips ~= nil then
		tips:ShowTips(text)
		tips:Show()
	end
	return tips
end

function MsgBoxManager:HideTips(originId)
	--if not self.tipsMap[originId] then return end
	local tips
	if originId then
		tips = self.tipsMap[originId]
		self.tipsMap[originId] = nil
	else
		tips = self:GetMsgBox(MsgBoxType.Tips)
	end

	self:HideMsgBox(tips)
end

function MsgBoxManager:HideMsgBox(msgBox)
	if msgBox.active then
		msgBox:Hide()
		if msgBox.msgBoxType == MsgBoxType.Tips then
			while self.showTipsList and self.showTipsList[1] do
				if self.showTipsList[1].text ~= msgBox.content then
					self:ShowTips(self.showTipsList[1].text,self.showTipsList[1].showTime)
					table.remove(self.showTipsList,1)
					break
				end
				table.remove(self.showTipsList,1)
			end
		end
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
	elseif msgBoxType == MsgBoxType.ScrollTips then
		if self.scrollTextTips == nil then
			self.scrollTextTips = ScrollTextTips.New(msgBoxType)
		end
		msgBox = self.scrollTextTips
	end
	return msgBox
end