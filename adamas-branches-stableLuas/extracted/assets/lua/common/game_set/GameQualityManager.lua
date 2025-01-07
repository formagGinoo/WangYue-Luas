
GameQualityManager = SingleClass("GameQualityManager")

local SaveKeys =
{
	QualityLevel = "QualityLevel",
	Resolution = "Resolution", 
	MsaaQuality = "MsaaQuality", 
	SmaaQuality = "SmaaQuality", 
	AAType = "AAType", 
	EnablePP = "EnablePP",
	imageEnhancementType = "imageEnhancementType",
	--DLSSResolutionIndex = "DLSSResolutionIndex",
	AnisotropicFilteringMode = "AnisotropicFilteringMode",
}

function GameQualityManager:__init()
	self.QualityMap = {}
end

function GameQualityManager:Init(qualityData)
	QualityManager.Instance:Init(qualityData)
	-- if PlayerPrefs.GetString("GameQualityInit") == '' then
		PlayerPrefs.SetString("GameQualityInit", "true")
		self:ChangeLevel(self:GetDefaultLevel())
	-- else
	-- 	self:_SetResolution()
	-- 	self:_SetMsaaQuality()
	-- 	self:_SetSmaaQuality()
	-- 	self:_SetAAType()
	-- 	self:_EnablePP()
	-- end
end

function GameQualityManager:GetDefaultLevel()
	if Application.platform == RuntimePlatform.Android then
        return self:GetAndroidDefaultLevel()
    elseif Application.platform == RuntimePlatform.IPhonePlayer then
    	return self:GetIOSDefaultLevel()	
    end
    return QualityEnum.Level.Highest
end

function GameQualityManager:GetAndroidDefaultLevel()
	--todo读取型号分析
	return QualityEnum.Level.High
end

function GameQualityManager:GetIOSDefaultLevel()
	--todo读取型号分析
	return QualityEnum.Level.High
end

function GameQualityManager:ChangeLevel(level)
	self:SetIntPlayerPrefs(SaveKeys.QualityLevel, level)
	local curQualityLevel = QualityManager.Instance:ChangeLevel(level)

	self:SetIntPlayerPrefs(SaveKeys.Resolution, curQualityLevel.IntResolution)
	self:SetIntPlayerPrefs(SaveKeys.MsaaQuality, curQualityLevel.IntMsaaQuality)
	self:SetIntPlayerPrefs(SaveKeys.SmaaQuality, curQualityLevel.IntSmaaQuality)
	self:SetIntPlayerPrefs(SaveKeys.AAType, curQualityLevel.IntAAType)
	self:SetIntPlayerPrefs(SaveKeys.EnablePP, curQualityLevel.IntEnablePP)
	self:SetIntPlayerPrefs(SaveKeys.imageEnhancementType, curQualityLevel.imageEnhancementType)
	--self:SetIntPlayerPrefs(SaveKeys.DLSSResolutionIndex, curQualityLevel.DLSSResolutionIndex)
	self:SetIntPlayerPrefs(SaveKeys.AnisotropicFilteringMode, curQualityLevel.AnisotropicFilteringMode)
end

function GameQualityManager:_SetResolution(value)
	value = value or self:GetIntPlayerPrefs(SaveKeys.Resolution)
	QualityManager.Instance:SetResolutionRatioIndex(value)
end

function GameQualityManager:_SetMsaaQuality(value)
	value = value or self:GetIntPlayerPrefs(SaveKeys.MsaaQuality)
	QualityManager.Instance:SetMSAALevel(value)
end

function GameQualityManager:_SetSmaaQuality(value)
	value = value or self:GetIntPlayerPrefs(SaveKeys.SmaaQuality)
	QualityManager.Instance:SetSMAALevel(value)
end

function GameQualityManager:_SetAAType(value)
	value = value or self:GetIntPlayerPrefs(SaveKeys.AAType)
	QualityManager.Instance:SetAAType(value)
end

function GameQualityManager:_EnablePP(value)
	value = value or self:GetIntPlayerPrefs(SaveKeys.EnablePP)
	local enable = value == 1
	QualityManager.Instance:EnablePP(enable)
end

function GameQualityManager:SetIntPlayerPrefs(key, value)
	PlayerPrefs.SetInt(key, value)
	PlayerPrefs.Save()
	self.QualityMap[key] = value
end

function GameQualityManager:GetIntPlayerPrefs(key)
	local value = PlayerPrefs.GetInt(key)
	self.QualityMap[key] = value
	return value
end