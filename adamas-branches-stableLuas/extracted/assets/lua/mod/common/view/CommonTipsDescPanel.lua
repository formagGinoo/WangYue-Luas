CommonTipsDescPanel = BaseClass("CommonTipsDescPanel", BasePanel)

local DataRuleNote = Config.DataRuleNote.Find

--初始化
function CommonTipsDescPanel:__init()
    self:SetAsset("Prefabs/UI/Common/CommonTipsDescPanel.prefab")

end

--添加监听器
function CommonTipsDescPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("ClosePanel"))
end

--缓存对象
function CommonTipsDescPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end
--
function CommonTipsDescPanel:__Create()

end

function CommonTipsDescPanel:__Show(args)
    self.key = self.args.key
    self:ShowTips()
end

function CommonTipsDescPanel:__delete()

end

function CommonTipsDescPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function CommonTipsDescPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function CommonTipsDescPanel:ShowTips()
    if not self.key then
        return
    end
    local str = DataRuleNote[self.key].string_val
    self.tips_txt.text = str
end

function CommonTipsDescPanel:ClosePanel()
    PanelManager.Instance:ClosePanel(self)
end


