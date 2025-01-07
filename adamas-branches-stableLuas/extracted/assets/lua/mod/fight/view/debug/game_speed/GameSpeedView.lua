GameSpeedView = BaseClass("GameSpeedView",BaseView)

function GameSpeedView:__init(model)
	self.model = model
	self:SetAsset(AssetConfig.debug_game_speed)
end

function GameSpeedView:__delete()
end

function GameSpeedView:__CacheObject()
	self.speedTxt = UtilsUI.GetText(self.transform:Find("SpeedText"))
	self.speedInput = self.transform:Find("InputField"):GetComponent(TMP_InputField)
end

function GameSpeedView:__Create()
	self.speedTxt.text = TI18N("当前游戏速度:")..Time.timeScale

	local canvas = self.gameObject:GetComponent(Canvas)
    if canvas ~= nil then
        canvas.pixelPerfect = false
        canvas.overrideSorting = true
    end
end

function GameSpeedView:__BindListener()
	local Speed0 = self.transform:Find("Speed0"):GetComponent(Button)
	Speed0.onClick:AddListener(function() self:SetGameSpeedInput(0) end)
	local Speed0_2 = self.transform:Find("Speed0.2"):GetComponent(Button)
	Speed0_2.onClick:AddListener(function() self:SetGameSpeedInput(0.2) end)
	local Speed0_5 = self.transform:Find("Speed0.5"):GetComponent(Button)
	Speed0_5.onClick:AddListener(function() self:SetGameSpeedInput(0.5) end)
	local Speed1 = self.transform:Find("Speed1"):GetComponent(Button)
	Speed1.onClick:AddListener(function() self:SetGameSpeedInput(1) end)
	local Speed2 = self.transform:Find("Speed2"):GetComponent(Button)
	Speed2.onClick:AddListener(function() self:SetGameSpeedInput(2) end)

	local Confirm = self.transform:Find("Confirm"):GetComponent(Button)
	Confirm.onClick:AddListener(function() self:SetGameSpeed() end)
	
	local Cancel = self.transform:Find("Cancel"):GetComponent(Button)
	Cancel.onClick:AddListener(function() self:Close() end)
end

function GameSpeedView:SetGameSpeedInput(timeScale)
	self.speedInput.text = tostring(timeScale)
end

function GameSpeedView:SetGameSpeed()
	local timeScale = tonumber(self.speedInput.text)
	Time.timeScale = timeScale
	
	self.speedTxt.text = TI18N("当前游戏速度:")..Time.timeScale
	self:Close()
end

function GameSpeedView:Close()
	self.model:CloseMainUI()
end