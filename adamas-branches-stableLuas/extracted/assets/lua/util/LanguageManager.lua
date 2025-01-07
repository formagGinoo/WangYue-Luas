LanguageManager = BaseClass("LanguageManager")

local DataText = {}
function LanguageManager:__init()
    if LanguageManager.Instance then
        LogError("拒绝重复实例化单例" .. debug.force_traceback())
        return
    end

    self.defaultLanguage = "DataI18nZh"

    self.currentLanguage = PlayerPrefs.GetString("Language") == "" and self.defaultLanguage or PlayerPrefs.GetString("Language")

    DataText = Config[self.currentLanguage].Find

    self.supportedLanguages = {
        "DataI18nZh",
        "DataI18nEn",
        "DataI18nTw",
    }

    LanguageManager.Instance = self
end

function LanguageManager:__delete()
    
end

function LanguageManager:SetLanguage(language)
    if self:IsLanguageSupported(language) and self.currentLanguage ~= language then
        self.currentLanguage = language
        PlayerPrefs.SetString("Language",language)
        DataText = Config[self.currentLanguage].Find
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
    return DataText[key] or key
end