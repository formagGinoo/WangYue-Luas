CurtainManager = SingleClass("CurtainManager")

function CurtainManager:__init()
	self.count = 0
	self.waitCount = 0
end

function CurtainManager:__delete()
end


function CurtainManager:FadeIn(isDark,time)
	-- if not LoginCtrl.IsInGame() then
	-- 	return
	-- end
	self.count = self.count + 1
	--Log("进入黑幕指令，当前黑幕计数为"..self.count)
	if self.count > 2 then return end
	if self.panel == nil then
		self.panel = CurtainPanel.New()
	end
	self.panel:Show()
	self.panel:FadeIn(isDark,time)
end

function CurtainManager:FadeOut(time)
	-- if not LoginCtrl.IsInGame() then
	-- 	return
	-- end
	self.count = self.count - 1
	--Log("退出黑幕指令，当前黑幕计数为(若小于0则按0处理)"..self.count)
	if self.count < 0 then 
		self.count = 0 
	end
	if self.count ~= 0 or not self.panel then return end
	self.panel:FadeOut(time)
end

function CurtainManager:IsCurtain()
	return self.count > 0
end


function CurtainManager:EnterWait()
	if not LoginCtrl.IsInGame() then
		return
	end
	InputManager.Instance:SetCanInputState(false)
	self.waitCount = self.waitCount + 1
	if self.waitPanel == nil then
		self.waitPanel = WaitCommandPanel.New()
		self.waitPanel:Show()
	end
	--LogError("EnterWait ".. self.waitCount)
	if self.waitCount == 1 then
		self.waitPanel:EnterWait()
	end
end

function CurtainManager:ExitWait()
	if not LoginCtrl.IsInGame() then
		return
	end
	InputManager.Instance:SetCanInputState(true)
	self.waitCount = self.waitCount - 1
	if self.waitCount < 0 then
		self.waitCount = 0
	end
	--LogError("ExitWait ".. self.waitCount)
	if self.waitCount ~= 0 or not self.waitPanel then return end
	self.waitPanel:ExitWait()
end

function CurtainManager:ResetWait()
	self.waitCount = 0
	if self.waitPanel then
		self.waitPanel:ExitWait()
	end
end