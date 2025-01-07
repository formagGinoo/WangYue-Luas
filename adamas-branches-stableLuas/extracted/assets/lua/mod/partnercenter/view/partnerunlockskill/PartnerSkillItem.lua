PartnerSkillItem = BaseClass("PartnerSkillItem")

function PartnerSkillItem:__init()

end

function PartnerSkillItem:Destory()

end
function PartnerSkillItem:OnReset()
    
end

function PartnerSkillItem:SetData(parent, data)
    self.item = data.obj
    self.transform = self.item.transform
    UtilsUI.GetContainerObject(self.transform, self)
    self.item:SetActive(true)
    self.data = data
    self.parent = parent

    self.ClickBtn_btn.onClick:RemoveAllListeners()
    self.ClickBtn_btn.onClick:AddListener(self:ToFunc("ClickSelect"))

    self:UpdateView()
end

function PartnerSkillItem:ClickSelect()
    local curSkillId = self.parent:GetCurSelectSkillId()
    if curSkillId and curSkillId == self.data.skillId then
        --如果已经选择了这个技能，再点击就弹tips
        PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{ skillId = self.data.skillId, uniqueId = self.data.curUniqueId })
    end

    self.parent:SelectPartnerSkill(self.data.skillId)
end

function PartnerSkillItem:UpdateView()
    local skillId = self.data.skillId
    local skillCfg = PartnerCenterConfig.GetPartnerSkillConfig(skillId)
    if not skillCfg then return end

    local quality = skillCfg.quality
    local icon = skillCfg.icon
    
    -- 设置图片Id
    SingleIconLoader.Load(self.SkillIcon, icon)

    -- 设置品质Id
    local qualityIcon = PartnerCenterConfig.GetPartnerSkillQualityIcon(quality)
    AtlasIconLoader.Load(self.QualityIcon, qualityIcon)
    local isUnLockSkill = mod.PartnerBagCtrl:CheckAssetPartnerSkillUnlock(self.data.curUniqueId, skillId)
    self:UpdateLockState(not isUnLockSkill)
end

function PartnerSkillItem:UpdateSelectState(isSelect)
    self.Select:SetActive(isSelect)
end

function PartnerSkillItem:UpdateLockState(isLock)
    self.Lock:SetActive(isLock)
    --if isLock then
    --    self.parent:UpdateUnlockResList(self.data.skillId)
    --end
end
