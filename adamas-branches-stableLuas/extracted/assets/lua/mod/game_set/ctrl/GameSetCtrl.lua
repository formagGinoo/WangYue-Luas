GameSetCtrl = BaseClass("GameSetCtrl", Controller)

local ViewSaveKey = GameSetConfig.SaveKey

function GameSetCtrl:__init()
	self.volumeSet = {}
	self.viewSet = {} 
	self.fightSet = {}
	self.driveSet = {}
end

function GameSetCtrl:LoadData(qualityData)

	QualityManager.Instance:Init(qualityData)

	-- 设置音量
	for saveKey, v in pairs(GameSetConfig.Volume) do
		local volume = self:GetVolume(saveKey)
		GameWwiseContext.SetRTPCValue(v.RTPC_Key, volume)
	end
	
	 -- PlayerPrefs.DeleteKey(ViewSaveKey.ViewQualityLevel)
	local firstSet = false
	-- 设置图像
	if not PlayerPrefs.HasKey(ViewSaveKey.ViewQualityLevel) then
		firstSet = true
		self:SetViewLevel(self:GetDefaultViewLevel())
	end

	-- PC分辨率设置	
	for _, v in pairs(GameSetConfig.View) do
		local saveKey = v.SaveKey
		if saveKey == ViewSaveKey.ViewResolution then
			local devmodeDatas = QualityManager.Instance:GetDevmodeDatas()
			for i = 0, devmodeDatas.Length - 1 do		
				local devmodeData = devmodeDatas[i]
				local name = string.format("%dX%d", devmodeData.dmPelsWidth, devmodeData.dmPelsHeight)
				if i == 0 then
					name = name..TI18N("(全屏)")
				end
				table.insert(v.SetValues, {name = name, value = i}) 
			end
		else 
			if not firstSet then
				local value = self:GetView(saveKey)
				self:SetView(saveKey, value)
			end
		end
	end

	GameSetCtrl.ScreenW = Screen.width
	GameSetCtrl.ScreenH = Screen.height
end

function GameSetCtrl:GetDefaultViewSet()
	if self.defalutViewSet then
		return self.defalutViewSet
	end

	local level = self:GetDefaultViewLevel()
	self.defalutViewSet = QualityManager.Instance:GetQualityLevel(level)

	return self.defalutViewSet
end

function GameSetCtrl:GetDefaultViewLevel()
	if Application.platform == RuntimePlatform.Android then
        return self:GetAndroidDefaultViewLevel()
    elseif Application.platform == RuntimePlatform.IPhonePlayer then
    	return self:GetIOSDefaultViewLevel()	
    end
    return GameSetConfig.ViewLevel.Highest
end

function GameSetCtrl:GetAndroidDefaultViewLevel()
	--todo读取型号分析
	return GameSetConfig.ViewLevel.High
end

function GameSetCtrl:GetIOSDefaultViewLevel()
	--todo读取型号分析
	return GameSetConfig.ViewLevel.High
end

function GameSetCtrl:GetVolume(key)
	if not PlayerPrefs.HasKey(key) then
		local volume = GameSetConfig.Volume[key].DefalutValue
		self:SetVolume(key, volume)
		return volume
	end

	if not self.volumeSet[key] then
		self.volumeSet[key] = PlayerPrefs.GetInt(key)
	end

	return self.volumeSet[key]
end

function GameSetCtrl:SetVolume(key, value)
	PlayerPrefs.SetInt(key, value)
	self.volumeSet[key] = value
	GameWwiseContext.SetRTPCValue(GameSetConfig.Volume[key].RTPC_Key, value)
end

function GameSetCtrl:GetFight(key)
	if not PlayerPrefs.HasKey(key) then
		local fight
		for i, v in ipairs(GameSetConfig.Fight) do
			if v.SaveKey == key then
				fight = GameSetConfig.Fight[i].DefalutValue
				self:SetFight(key, fight)
				return fight
			end
		end
	end

	if not self.fightSet[key] then
		self.fightSet[key] = PlayerPrefs.GetInt(key)
	end

	return self.fightSet[key]
end

function GameSetCtrl:SetFight(key, value)
	PlayerPrefs.SetInt(key, value)
	self.fightSet[key] = value
end
function GameSetCtrl:GetDrive(key)
	if not PlayerPrefs.HasKey(key) then
		local drive
		for i, v in ipairs(GameSetConfig.Dirve) do
			if v.SaveKey == key then
				drive = GameSetConfig.Dirve[i].DefalutValue
				self:SetFight(key, drive)
				return drive
			end
		end
	end

	if not self.driveSet[key] then
		self.driveSet[key] = PlayerPrefs.GetInt(key)
	end

	return self.driveSet[key]
end

function GameSetCtrl:SetDrive(key, value)
	PlayerPrefs.SetInt(key, value)
	self.driveSet[key] = value
end

function GameSetCtrl:GetView(key)
	if not PlayerPrefs.HasKey(key) then
		local defalutViewSet = self:GetDefaultViewSet()
		local info = GameSetConfig.GetViewInfo(key)
		local value = defalutViewSet[info.CSKey]
		self:_SetView(key, value)
		return value
	end

	if not self.viewSet[key] then
		self.viewSet[key] = PlayerPrefs.GetInt(key)
	end

	return self.viewSet[key]
end

function GameSetCtrl:SetViewLevel(level)
	self:_SetView(ViewSaveKey.ViewQualityLevel, level)

	local curSet = QualityManager.Instance:ChangeLevel(level)
	self:_SetView(ViewSaveKey.ViewRenderScale, curSet.IntRenderResolution)
	self:_SetView(ViewSaveKey.ViewAAType, curSet.IntAAType)

	self:_SetView(ViewSaveKey.ViewMsaaQuality, curSet.IntMsaaQuality)
	self:_SetView(ViewSaveKey.ViewSmaaQuality, curSet.IntSmaaQuality)
	self:_SetView(ViewSaveKey.ViewTaaQuality, curSet.IntTAAQuality)

	self:_SetView(ViewSaveKey.ViewFrame, curSet.FrameRate)
	self:_SetView(ViewSaveKey.ViewRenderScale, curSet.RenderResolutionIndex)

	--self:_SetView(ViewSaveKey.DLSSResolutionIndex, curSet.DLSSResolutionIndex)

	self:_SetView(ViewSaveKey.AnisotropicFilteringMode, curSet.IntAnisotropicFilteringMode)
end

function GameSetCtrl:_SetView(key, value)
	PlayerPrefs.SetInt(key, value)
	self.viewSet[key] = value
end

function GameSetCtrl:SetView(key, value, uiOp)
	if key == ViewSaveKey.ViewQualityLevel and value < 4 then
		self:SetViewLevel(value)
		return
	else
		-- 自定义切换
		if uiOp and key ~= ViewSaveKey.ViewResolution then
			self:_SetView(ViewSaveKey.ViewQualityLevel, GameSetConfig.ViewLevel.Customize)
		end
	end

	self:_SetView(key, value)

	if key == GameSetConfig.SaveKey.ViewResolution then
		QualityManager.Instance:SetScreenResolutionRatioIndex(value)
	    LuaTimerManager.Instance:AddTimer(1, 0.01, function ()
	    	GameSetCtrl.ScreenW = Screen.width
			GameSetCtrl.ScreenH = Screen.height
	    end)
		
	elseif key == GameSetConfig.SaveKey.ViewMsaaQuality or 
		key == GameSetConfig.SaveKey.ViewSmaaQuality or 
		key == GameSetConfig.SaveKey.ViewTaaQuality  or
		key == GameSetConfig.SaveKey.ViewAAType then
		local aaType = self:GetView(GameSetConfig.SaveKey.ViewAAType)
		local aaTypeValue = self:GetView(GameSetConfig.AASet[aaType].SaveKey)
		QualityManager.Instance:SetAA(aaType, aaTypeValue)
	elseif key == GameSetConfig.SaveKey.ViewFrame then
		QualityManager.Instance:SetFrameRate(value)
	elseif key == GameSetConfig.SaveKey.ViewRenderScale then
		QualityManager.Instance:SetResolutionRenderScale(value)
	--elseif key == GameSetConfig.SaveKey.DLSSResolutionIndex then
	--	if QualityManager.Instance:IsDLSSSupported() then
	--		if value == 0 then
	--			QualityManager.Instance:SetImageEnhancement(GameSetConfig.ImageEnhancementType.None, 0, 0)
	--		else
	--			QualityManager.Instance:SetImageEnhancement(GameSetConfig.ImageEnhancementType.DLSS, value - 1, 0)
	--		end
	--	end
	elseif key == GameSetConfig.SaveKey.AnisotropicFilteringMode then
		QualityManager.Instance:SetAnisotropicFilteringMode(value)
	end
end



function GameSetCtrl:__Clear()

end
