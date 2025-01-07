TextTips = BaseClass("TextTips", BaseView)

defauleShowTime = 2

function TextTips:__init(msgBoxType)
	self:SetAsset("Prefabs/UI/Common/TextTips.prefab")
	self:SetParent(UIDefine.canvasRoot.transform)

	self.showTime = defauleShowTime
	self.msgBoxType = msgBoxType
	self.content = ""
end

function TextTips:__Create()
end

function TextTips:__Show()
	self:SetLayer()
	self:RemoveTimer()
	self.timer = LuaTimerManager.Instance:AddTimer(1, self.showTime, self:ToFunc("HideTips"))
	self.TipsContent_txt.text = self.content
end

function TextTips:SetLayer()
	self.gameObject.transform:GetComponent(Canvas).sortingOrder = WindowManager.Instance:GetCurOrderLayer() + 11
end

function TextTips:HideTips()
	self:RemoveTimer()
	MsgBoxManager.Instance:HideMsgBox(self)
end

function TextTips:ResetView(content, showTime)
	self.showTime = showTime or defauleShowTime
	self:HideTips()
	self.content = content
end

function TextTips:RemoveTimer()
	if self.timer then
		LuaTimerManager.Instance:RemoveTimer(self.timer)
		self.timer = nil
	end
end
