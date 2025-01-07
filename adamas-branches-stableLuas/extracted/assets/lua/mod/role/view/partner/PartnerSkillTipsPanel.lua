PartnerSkillTipsPanel = BaseClass("PartnerSkillTipsPanel", BasePanel)

local passiveSkillType = 11 -- 被动技能
local exporeSkillType = 1 -- 探索能力

function PartnerSkillTipsPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerSkillTipsPanel.prefab")
end

function PartnerSkillTipsPanel:__Create()

end

function PartnerSkillTipsPanel:__delete()

end

function PartnerSkillTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerSkillTipsPanel:__BindListener()
    self.BackBg_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
    self.LearnSkillBtn_btn.onClick:AddListener(self:ToFunc("OnClick_LearnSkillPanel"))
end

function PartnerSkillTipsPanel:__Hide()

end

function PartnerSkillTipsPanel:OnClick_Close()
    self:PlayExitAnim()
end

function PartnerSkillTipsPanel:__Show()
    self:SetLayOut()
    self:ShowDetail(self.args.skillId, self.args.uid, self.args.showBtn)
    self:SelectObjActive(true)
end

function PartnerSkillTipsPanel:SelectObjActive(active)
    if self.args.objList and next(self.args.objList) then
        for i, obj in ipairs(self.args.objList) do
            -- local go = GameObject.Instantiate(obj, self.BackBg.transform, true)
            local node = UtilsUI.GetContainerObject(obj.transform)
            UtilsUI.SetActive(node.Select, active)
        end
    end
end

function PartnerSkillTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function PartnerSkillTipsPanel:SetLayOut()
    UnityUtils.SetAnchoredPosition(self.Tips.transform, self.args.tipsPosX or 0, self.args.tipsPosY or 0)
end

function PartnerSkillTipsPanel:OnClick_LearnSkillPanel()
    if not self.args.skillId then
        LogError("月灵技能Tips没有传入SkillId")
        return
    end
    if RoleConfig.GetPartnerSkillConfig(self.args.skillId).type == passiveSkillType and self.args.uniqueId then
        WindowManager.Instance:OpenWindow(PartnerMainWindow, 
        { 
            uniqueId = self.args.uniqueId,
            initTag = RoleConfig.PartnerPanelType.LearnSkill
        })
    else
        local window = WindowManager.Instance:GetWindow("RoleMainWindow")
        if window then 
            window:Close_HideCallBack()
        end
        mod.AbilityWheelCtrl:OpenAbilityWheelSetWindow(AbilityWheelEnum.WindowSelectType.Wheel)
    end

    self:OnClick_Close()
end

function PartnerSkillTipsPanel:ShowDetail(skillId, uid, showBtn)
    showBtn = showBtn or false
    uid = uid or nil
    if not skillId then
        LogError("月灵技能Tips没有传入SkillId")
        return
    end
    local skillConfig = RoleConfig.GetPartnerSkillConfig(skillId)

    self.skillItemInfo = {}
    UtilsUI.GetContainerObject(self.SkillItem, self.skillItemInfo)
    UtilsUI.SetActive(self.skillItemInfo.SkillIcon, false)
    SingleIconLoader.Load(self.skillItemInfo.SkillIcon , skillConfig.icon,function()
        UtilsUI.SetActive(self.skillItemInfo.SkillIcon, true)
    end)
    
    -- 品质
    local quality = AssetConfig.GetPartnerSkillQuality(skillConfig.quality)
    for i = 1, 5, 1 do
        UtilsUI.SetActive(self["Quality" .. i], i == skillConfig.quality)
        self.skillItemInfo["Quality" .. i .."_tog"].isOn = (i == skillConfig.quality)
    end
    UtilsUI.SetActive(self.skillItemInfo.Quality, true)
    
    self.SkillName_txt.text = skillConfig.name
    self.MainSkillDesc_txt.text = skillConfig.desc
    -- 时间
    UtilsUI.SetActive(self.Time, skillConfig.show_cd ~= 0)
    if skillConfig.show_cd ~= 0 then
        self.TimeText_txt.text = string.format("%s秒", skillConfig.show_cd)
    end
    -- 标签
    if skillConfig.tag and skillConfig.tag[1] then
        local tag = RoleConfig.GetPartnerSkillTagConfig(skillConfig.tag[1])
        UtilsUI.SetActive(self.State, false)
        SingleIconLoader.Load(self.State, tag.bg, function()
            UtilsUI.SetActive(self.State, true)
        end)
        self.StateText_txt.text = tag.name
    end
    -- 学习按钮
    if not uid and (skillConfig.type == passiveSkillType  or skillConfig.tag[1] == exporeSkillType) and showBtn then
        UtilsUI.SetActive(self.LearnSkillBtn, true)
        UnityUtils.SetSizeDelata(self.DescScroll_rect, self.DescScroll_rect.sizeDelta.x, 270)
    else
        UtilsUI.SetActive(self.LearnSkillBtn, false)
        UnityUtils.SetSizeDelata(self.DescScroll_rect, self.DescScroll_rect.sizeDelta.x, 375)
    end
    if RoleConfig.GetPartnerSkillConfig(self.args.skillId).type == passiveSkillType then
        self.LearnSkillText_txt.text = TI18N("学习技能")
    else
        self.LearnSkillText_txt.text = TI18N("能力装配")
    end
end
function PartnerSkillTipsPanel:__BeforeExitAnim()
    self:SelectObjActive(false)
end

function PartnerSkillTipsPanel:__AfterExitAnim()
    PanelManager.Instance:ClosePanel(self)
end