FightTipsView = BaseClass("FightTipsView",BaseView)

function FightTipsView:__init()
	self:SetAsset(AssetConfig.fight_tips)
end

function FightTipsView:__delete()
	self:RemoveTimer()
end

function FightTipsView:__CacheObject()
	self.centerNode = self:Find("center_node").gameObject
	self.centerMsgText = UtilsUI.GetText(self:Find("center_node/msg"))
	self.bottomNode = self:Find("bottom_node").gameObject
	self.bottomMsgText = UtilsUI.GetText(self:Find("bottom_node/msg"))
end

function FightTipsView:__Create()
end

function FightTipsView:__Show()
	self.tips = self.args[1]
	self.tipsConfig = self.args[2]
	self:ShowTip()
end

function FightTipsView:RefreshTips(tips, tipsConfig)
	self.tips = tips
	self.tipsConfig = tipsConfig
	self:ShowTip()
end

function FightTipsView:ShowTip()
	if self.tipsConfig.type == FightEnum.FightTipsType.Center then
		self.centerNode:SetActive(true)
		self.bottomNode:SetActive(false)
		self.centerMsgText.text = self.tips
	elseif self.tipsConfig.type == FightEnum.FightTipsType.Bottom then
		self.centerNode:SetActive(false)
		self.bottomNode:SetActive(true)
		self.bottomMsgText.text = self.tips
		UnityUtils.SetSizeDelata(self.bottomNode.transform,self.bottomMsgText.preferredWidth + 150,58)
	end

	self:RemoveTimer()
	self.tipsTimer = LuaTimerManager.Instance:AddTimer(1, self.tipsConfig.time, self:ToFunc("HideComplete"))
end

function FightTipsView:HideComplete()
	self.tipsTimer = nil
	self:RemoveTimer()
	self.centerNode:SetActive(false)
	self.bottomNode:SetActive(false)
end

function FightTipsView:GetCurDisplayTip()

end

function FightTipsView:HideTip(tipId)
	if tipId ~= self.tipsConfig.id then
		return
	end

	self:RemoveTimer()
	self.centerNode:SetActive(false)
	self.bottomNode:SetActive(false)
end

function FightTipsView:RemoveTimer()
	if self.tipsTimer then
		LuaTimerManager.Instance:RemoveTimer(self.tipsTimer)
		self.tipsTimer = nil
	end
end