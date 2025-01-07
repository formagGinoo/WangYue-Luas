MapDebugModel = BaseClass("MapDebugModel",BaseModel)
MapDebugModel.NotClear = true

function MapDebugModel:__init()
	self.window = nil

	self.visable = false
end

function MapDebugModel:__delete()
	if self.window ~= nil then
		self.window:DeleteMe()
		self.window = nil
		self.visable = false
	end
end

function MapDebugModel:InitMainUI()
	if self.window == nil then
		self.window = MapDebugView.New(self)
		self.window:SetParent(UIDefine.canvasRoot.transform)
		self.window:Show()
		self.visable = true
	else
		self.window:Open()
	end
end

function MapDebugModel:CloseMainUI()
	if self.window ~= nil then
		self.window:Destroy()
		self.window = nil
		self.visable = false
	end
end


