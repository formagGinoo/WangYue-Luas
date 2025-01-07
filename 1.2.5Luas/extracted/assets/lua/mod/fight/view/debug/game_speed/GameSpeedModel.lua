GameSpeedModel = BaseClass("GameSpeedModel",BaseModel)
GameSpeedModel.NotClear = true

function GameSpeedModel:__init()
	self.window = nil

	self.visable = false
end

function GameSpeedModel:__delete()
	if self.window ~= nil then
		self.window:Destroy()
		self.window = nil
		self.visable = false
	end
end

function GameSpeedModel:InitMainUI()
	if self.window == nil then
		self.window = GameSpeedView.New(self)
		self.window:SetParent(UIDefine.canvasRoot.transform)
		self.window:Show()
		self.visable = true
	else
		self.window:Show()
	end
end

function GameSpeedModel:CloseMainUI()
	if self.window ~= nil then
		self.window:Destroy()
		self.window = nil
		self.visable = false
	end
end


