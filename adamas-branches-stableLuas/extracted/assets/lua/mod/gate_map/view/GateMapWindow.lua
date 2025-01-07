

GateMapWindow = BaseClass("GateMapWindow",BaseWindow)

function GateMapWindow:__init(model)
	self.model = model
	self:SetAsset(AssetConfig.gate_map_ui)

	self.selectChapterIndex = 0
	-- self.InitCompletedEvent = EventLib.New()
end

function GateMapWindow:__delete()
end

function GateMapWindow:__CacheObject()
	self.pnlTask = self.transform:Find("pnlTask")
	self.pnlChapter = self.transform:Find("pnlChapter")
	self.pnlSelect = self.transform:Find("pnlTask/pnlSelect")
end

function GateMapWindow:__BindListener()
	local btnReturn = self.transform:Find("btnReturn"):GetComponent(Button)
    btnReturn.onClick:AddListener(function() self:OnReturn() end)

	local btnMain = self.transform:Find("btnMain"):GetComponent(Button)
	btnMain.onClick:AddListener(function() self:OnReturn() end)

	local btnTask1 = self.transform:Find("pnlTask/btnTask1"):GetComponent(Button)
	btnTask1.onClick:AddListener(function() self:OnSelectTask() end)

	for i = 1, 4 do 
		local btnChapter = self.transform:Find("pnlChapter/btnChapter"..i):GetComponent(ButtonEx)
		btnChapter.onTouchBegan:AddListener(function() self:OnSelectChapter(i) end)
		btnChapter.onTouchEnded:AddListener(function() self:OnSelectChapterEnd(i) end)
		btnChapter.onTouchCancelEnded:AddListener(function() self:OnSelectChapterEnd(i) end)

		--test
		if i > 1 then 
			self.transform:Find("pnlChapter/btnChapter"..i).gameObject:SetActive(false)
		end
	end
end

function GateMapWindow:__Create()
	local canvas = self.gameObject:GetComponent(Canvas)
    if canvas ~= nil then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end
end

function GateMapWindow:__Show()
	MainDebugManager.Instance.model:CloseMainUI()
end

-- 目前只有第一个任务
function GateMapWindow:OnSelectTask()
	if self.selectTask then
		return
	end

	self.selectTask = true
	local rect = self.pnlTask:GetComponent(RectTransform)
	rect.sizeDelta = Vector2(500, 312)

	self.pnlChapter.gameObject:SetActive(true)
	self.pnlSelect.gameObject:SetActive(true)

	local txtSelect = UtilsUI.GetText(self.transform:Find("pnlTask/btnTask1"))
	CustomUnityUtils.SetTextColor(txtSelect, 240, 10, 50, 255)	
end

function GateMapWindow:OnSelectChapter(index)
	if self.selectChapterIndex > 0 then
		local imgSelect = self.transform:Find("pnlChapter/btnChapter"..self.selectChapterIndex.."/ImgSelect")
		imgSelect.gameObject:SetActive(false)
		local txtSelect = UtilsUI.GetText(self.transform:Find("pnlChapter/btnChapter"..self.selectChapterIndex.."/text"))
		CustomUnityUtils.SetTextColor(txtSelect, 220, 0, 0, 255)	
	end

	local imgSelect = self.transform:Find("pnlChapter/btnChapter"..index.."/ImgSelect")
	imgSelect.gameObject:SetActive(true)
	local txtSelect = UtilsUI.GetText(self.transform:Find("pnlChapter/btnChapter"..index.."/text"))
	CustomUnityUtils.SetTextColor(txtSelect, 0, 0, 0, 255)	

	self.selectChapterIndex = index
end

function GateMapWindow:OnSelectChapterEnd(index)
	WindowManager.Instance:OpenWindow(GateDetailWindow)
end

function GateMapWindow:OnReturn()
	WindowManager.Instance:CloseWindow(GateMapWindow)
end