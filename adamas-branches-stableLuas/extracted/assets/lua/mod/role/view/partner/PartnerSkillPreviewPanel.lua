PartnerSkillPreviewPanel = BaseClass("PartnerSkillPreviewPanel", BasePanel)

function PartnerSkillPreviewPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerSkillPreviewPanelV2.prefab")
end

function PartnerSkillPreviewPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerSkillPreviewPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn)
    self.RightTabBtn_btn.onClick:AddListener(self:ToFunc("OnClick_RightBtn"))
    self.LeftTabBtn_btn.onClick:AddListener(self:ToFunc("OnClick_LeftBtn"))
end

function PartnerSkillPreviewPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function PartnerSkillPreviewPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 3, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
end

function PartnerSkillPreviewPanel:BlurComplete()
    self:SetActive(true)
end

function PartnerSkillPreviewPanel:__Show()
    self.uniqueId = self.args.uniqueId or 0
    self.partnerId = self.args.partnerId or 0
    self.partnerData = self.uniqueId and mod.BagCtrl:GetPartnerData(self.uniqueId) or
    {
        template_id = self.partnerId,
        lev = 1,
        skill_list = {}
    }
    self.levList = {}
    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(self.partnerData.template_id)
    local tempIndex = 0
    for lev = 1, maxLev, 1 do
        local config = RoleConfig.GetPartnerSkillRandomConfig(self.partnerData.template_id, lev)
        if config then
            tempIndex = tempIndex + 1
            table.insert(self.levList, lev)
            if lev <= self.partnerData.lev then
                self.curIndex = tempIndex
            end
        end
    end
    if self.levList[self.curIndex + 1] then
        self.curIndex = self.curIndex + 1
    end
    self:ShowDetail(self.levList[self.curIndex])
end

function PartnerSkillPreviewPanel:OnClick_LeftBtn()
    if not self.levList[self.curIndex - 1] then
        LogError("错误，不应该能按左边按钮")
        return
    end
    self.curIndex = self.curIndex - 1
    self:ShowDetail(self.levList[self.curIndex])
end
function PartnerSkillPreviewPanel:OnClick_RightBtn()
    if not self.levList[self.curIndex + 1] then
        LogError("错误，不应该能按右边按钮")
        return
    end
    self.curIndex = self.curIndex + 1
    self:ShowDetail(self.levList[self.curIndex])
end

function PartnerSkillPreviewPanel:ShowDetail(lev)
    self:TryActiveBtn()
    self:PushAllUITmpObject("PreviewItem", self.ItemCache_rect)
    local skillRamdomConfig = RoleConfig.GetPartnerSkillRandomConfig(self.partnerData.template_id, lev)
    local baseConfig = ItemConfig.GetItemConfig(self.partnerData.template_id)
    self.TitleTips_txt.text = string.format(TI18N("月灵升至<color=#ffa234>LV.%s</color>可获得"), lev)
    local addSkillCount = RoleConfig.GetPartenrSkillCountByLev(self.partnerData.template_id, lev)
    if addSkillCount > 0 then
        local str = ""
        for i, id in ipairs(skillRamdomConfig.add_skill) do
            if id ~= 0 then
                str = string.format("%s <color=#ffa234>%s</color> ",str, RoleConfig.GetPartnerSkillConfig(id).name)
            end
        end
        self:GetPreviewItemObject(self.Bg_rect, TI18N(string.format("解锁天赋技%s", str)))
    end
    if skillRamdomConfig.add_passive > 0 then
        self:GetPreviewItemObject(self.Bg_rect, TI18N(string.format("解锁<color=#ffa234>%s</color>个被动槽位", skillRamdomConfig.add_passive)))
    end
    if skillRamdomConfig.add_plate > 0 then
        self:GetPreviewItemObject(self.Bg_rect, TI18N(string.format("解锁<color=#ffa234>%s</color>个雕纹槽位", skillRamdomConfig.add_plate)))
    end
    UtilsUI.SetActive(self.BotTips, lev <= self.partnerData.lev)
end

function PartnerSkillPreviewPanel:TryActiveBtn()
    UtilsUI.SetActive(self.RightTabBtn, self.levList[self.curIndex + 1] ~= nil)
    UtilsUI.SetActive(self.LeftTabBtn, self.levList[self.curIndex - 1] ~= nil)
end

function PartnerSkillPreviewPanel:GetPreviewItemObject(parent, text)
    local obj = self:PopUITmpObject("PreviewItem")
    obj.object.transform:SetParent(parent, false)
    UtilsUI.SetActive(obj.object, true)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UnityUtils.SetLocalScale(obj.object.transform, 1, 1, 1)
    obj.ItmeText_txt.text = text
    return obj
end

function PartnerSkillPreviewPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end