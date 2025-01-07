StageUpDescPanel = BaseClass("StageUpDescPanel", BasePanel)

function StageUpDescPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleStageUpDescPanel.prefab")
end
function StageUpDescPanel:__BindEvent()

end

function StageUpDescPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function StageUpDescPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClick_ClosePanel"))
end

--[[
    相关参数
    config = {
        targetLev
        showBaseText
        baseText
        stage
        stageInfo
    }
]]

function StageUpDescPanel:__Show()
    local config = self.args.config
    self.targetLev = config.targetLev
    self.showBaseText = config.showBaseText
    self.baseText = config.baseText
    self.stageInfo = config.stageInfo
    self.stage = config.stage
    self:ShowInfo()
end

function StageUpDescPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BindNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function StageUpDescPanel:BlurComplete()
    self:SetActive(true)
end
function StageUpDescPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function StageUpDescPanel:ShowInfo()
    self.TipText:SetActive(self.showBaseText or false)
    self.LevelTip:SetActive(self.showBaseText or false)
    if self.showBaseText then
        self.TipText_txt.text = self.baseText or string.format(TI18N("角色达到 LV.s% 可突破"),self.targetLev)
        self.LevelTip_txt.text = "LV." .. self.targetLev
    end

    SingleIconLoader.Load(self.StageIcon, "Textures/Icon/Single/StageIcon/" .. self.stage .. ".png")
    for i = 1, 4 do
        if self.stageInfo[i] then
            self["StageInfo".. i]:SetActive(true)
            self["Desc"..i.."_txt"].text = self.stageInfo[i]
        else
            self["StageInfo".. i]:SetActive(false)
        end
    end
end

function StageUpDescPanel:OnClick_ClosePanel()
    --self.StageUpDescPanel_Eixt:SetActive(true)
    PanelManager.Instance:ClosePanel(self)
end