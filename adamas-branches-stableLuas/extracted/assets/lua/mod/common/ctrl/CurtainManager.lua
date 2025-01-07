CurtainManager = SingleClass("CurtainManager")

function CurtainManager:__init()
	self.count = 0
	self.waitCount = 0
end

function CurtainManager:__delete()
end


function CurtainManager:Update()
	if self.panel then
		self.panel:Update()
	end
	if self.waitPanel then
		self.waitPanel:Update()
	end
end

function CurtainManager:FadeIn(isDark,time)
	-- if not LoginCtrl.IsInGame() then
	-- 	return
	-- end
	if self.isStop then return end
	self.count = self.count + 1
	--LogError("进入黑幕指令，当前黑幕计数为"..self.count)
	if self.count > 1 then return end
	if self.panel == nil then
		self.panel = CurtainPanel.New()
	end
	self.panel:Show()
	self.panel:FadeIn(isDark,time)
	EventMgr.Instance:Fire(EventName.PauseTipQueue)
end

function CurtainManager:FadeOut(time)
	-- if not LoginCtrl.IsInGame() then
	-- 	return
	-- end
	if self.isStop then return end
	self.count = self.count - 1
	--LogError("退出黑幕指令，当前黑幕计数为(若小于0则按0处理)"..self.count)
	if self.count < 0 then 
		self.count = 0 
	end
	if self.count ~= 0 or not self.panel then return end
	self.panel:FadeOut(time)
	EventMgr.Instance:Fire(EventName.ResumeTipQueue)
end

function CurtainManager:Stop()
	if self.isStop then return end
	if self.count > 0 then
		self.count = 0
		self:FadeOut(0)
	end
	self.isStop = true
end

function CurtainManager:Start()
	if not self.isStop then return end
	self.isStop = false
end

function CurtainManager:SetAlpha(value)
	if value == 0 and self.panelV2 then
		self.panelV2:HideDisplay()
		return
	end
	if self.panelV2 == nil then
		self.panelV2 = CurtainV2Panel.New()
		self.panelV2:Show()
	end
	self.panelV2:SetAlpha(value)
end

function CurtainManager:ShowBlackCurtainTips(tipsConfig, ...)
	self:FadeIn(true, 0.3)
	self.panel:UpdateTipsList(tipsConfig.id)
end

function CurtainManager:ShowBlackCurtainTipsV2(tipsId, tipsUniqueId)
	if self.tipTimer then
		LuaTimerManager.Instance:RemoveTimer(self.tipTimer)
		self.tipTimer = nil
	end

	self:CurtainTipsEnd(0, 0.3, true)
	self.tipsUniqueId = tipsUniqueId
	self.inTipsCurtain = true
	self:FadeIn(true, 0.3)
	self.panel:UpdateTipsList(tipsId, tipsUniqueId)
end

function CurtainManager:CurtainTipsEnd(time, outTime, isBreak)
	if not self.inTipsCurtain then return end
	local function func()
		CurtainManager.Instance:FadeOut(outTime)
		self.inTipsCurtain = false
		--被打断不用移除，排队接着放
		if self.tipsUniqueId and TipQueueManger.Instance and not isBreak then
			TipQueueManger.Instance:RemoveLevelTips(self.tipsUniqueId, true)
		end
		self.tipsUniqueId = nil
	end
	if time == 0 then
		func()
	else
		self.tipTimer = LuaTimerManager.Instance:AddTimer(1, time, function ()
			self.tipTimer = nil
			func()
		end)
	end
end

function CurtainManager:IsCurtain()
	return self.count > 0
end


function CurtainManager:EnterWait(type)
	if not LoginCtrl.IsInGame() then
		--return
	end
	self.waitCount = self.waitCount + 1
	if self.waitPanel == nil then
		self.waitPanel = WaitCommandPanel.New()
		self.waitPanel:Show()
	end
	--LogError("EnterWait ".. self.waitCount)
	self.waitPanel:SetWaitType(type or SystemConfig.WaitType.Default)
	if self.waitCount == 1 then
		if InputManager.Instance then
			InputManager.Instance:SetCanInputState(false)
		end
		self.waitPanel:EnterWait()
		EventMgr.Instance:Fire(EventName.PauseTipQueue)
	end
end

function CurtainManager:ExitWait()
	if not LoginCtrl.IsInGame() then
		--return
	end
	self.waitCount = self.waitCount - 1
	if self.waitCount < 0 then
		self.waitCount = 0
	end
	--LogError("ExitWait ".. self.waitCount)
	if self.waitCount ~= 0 or not self.waitPanel then return end
	if InputManager.Instance then
		InputManager.Instance:SetCanInputState(true)
	end
	self.waitPanel:ExitWait()
	EventMgr.Instance:Fire(EventName.ResumeTipQueue)
end

function CurtainManager:ResetWait()
	if self.waitCount > 0 then
		self.waitCount = 0
		self:ExitWait()
	end
	
end