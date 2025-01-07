RoleStageUpDescPanel = BaseClass("RoleStageUpDescPanel", BasePanel)

local DataItem = Config.DataItem.Find

function RoleStageUpDescPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleStageUpDescPanel.prefab")
    self.costItemList = {}
end
function RoleStageUpDescPanel:__BindEvent()

end

function RoleStageUpDescPanel:__BindListener()
    --self:BindCloseBtn(self.CommonBack1_btn)
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
end

function RoleStageUpDescPanel:__Create()

end

function RoleStageUpDescPanel:__Show()
    self.heroId = self.args.heroId
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self.showStage = self.curRoleInfo.stage + 1
    self.showStageConfig = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.showStage)]
    self:ShowInfo()
end

function RoleStageUpDescPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 1, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function RoleStageUpDescPanel:BlurComplete()
    self:SetActive(true)
end

function RoleStageUpDescPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function RoleStageUpDescPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end

function RoleStageUpDescPanel:ShowInfo()
    SingleIconLoader.Load(self.StageIcon, "Textures/Icon/Single/StageIcon/" .. self.showStage .. ".png")
    local curConfig = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)]
    self.TitleText_txt.text = TI18N("突破")
    self.TipText_txt.text = string.format(TI18N("角色达到            可突破"))
    self.LevelTip_txt.text = "LV." .. curConfig.limit_hero_lev
    for i = 1, 4 do
        if self.showStageConfig.stage_info[i] then
            self["StageInfo".. i]:SetActive(true)
            self["Desc"..i.."_txt"].text = self.showStageConfig.stage_info[i]
            self["Desc"..i.."_txt"].text = self.showStageConfig.stage_info[i]
        else
            self["StageInfo".. i]:SetActive(false)
        end
    end
end

function RoleStageUpDescPanel:getCostItem()

end