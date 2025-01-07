LanguageManager = BaseClass("LanguageManager")

local DataText = Config.DataI18n.Find

function LanguageManager:__init()
    if LanguageManager.Instance then
        LogError("拒绝重复实例化单例" .. debug.force_traceback())
        return
    end

    self.defaultLanguage = "zh"

    self.currentLanguage = self.defaultLanguage

    self.supportedLanguages = {
        "zh",
        "en",
        "zh_tw",
    }

    LanguageManager.Instance = self
end

function LanguageManager:__delete()
    
end

function LanguageManager:SetLanguage(language)
    if self:IsLanguageSupported(language) and self.currentLanguage ~= language then
        self.currentLanguage = language
        self:ReloadLocalizedResources()
        self:NotifyLanguageChange()
    else
        print("切换语言" .. language .. "失败")
    end
end

function LanguageManager:ReloadLocalizedResources()
    
end

function LanguageManager:NotifyLanguageChange()
    EventMgr.Instance:Fire(EventName.ChangeLanguage)
end

function LanguageManager:IsLanguageSupported(language)
    for _, lang in ipairs(self.supportedLanguages) do
        if lang == language then
            return true
        end
    end
    return false
end

function LanguageManager:GetLocalizedText(key)
    if DataText[key] and DataText[key][self.currentLanguage] then 
        return DataText[key][self.currentLanguage]
    end
    --Log("未被翻译："..key)
    return key
end