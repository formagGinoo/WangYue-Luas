MapListModel = BaseClass("MapListModel",BaseModel)
MapListModel.NotClear = true

function MapListModel:__init()
	self.window = nil

	self.visable = false
end

function MapListModel:__delete()
	if self.window ~= nil then
		self.window:DeleteMe()
		self.window = nil
		self.visable = false
	end
end

function MapListModel:InitMainUI()
	if self.window == nil then
		self.window = MapListView.New(self)
		self.window:SetParent(UIDefine.canvasRoot.transform)
		self.window:Show()
		self.visable = true
	else
		self.window:Show()
	end
end

function MapListModel:CloseMainUI()
	if self.window ~= nil then
		self.window:Destroy()
		self.window = nil
		self.visable = false
	end
end


