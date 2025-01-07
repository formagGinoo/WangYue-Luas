GmManager = SingleClass("GmManager")

function GmManager:__init()
	self.window = nil
	self.windowVisible = false
end

function GmManager:__delete()
	if self.window ~= nil then
		self.window:DeleteMe()
		self.window = nil
		
		self.windowVisible = false
	end
end

function GmManager:OpenGmPanel()
	if not self.window then
		self.window = GmView.New()
	end
	
	if not self.window.active then
		self.window:Show()
		self.windowVisible = true
	end
end

function GmManager:CloseGmPanel()
	if not self.window then
		return
	end

	if self.window.active then
		self.window:Hide()
		self.windowVisible = false
	end
end