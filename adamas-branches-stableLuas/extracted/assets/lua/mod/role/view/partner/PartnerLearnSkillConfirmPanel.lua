PartnerLearnSkillConfirmPanel = BaseClass("PartnerLearnSkillConfirmPanel", BasePanel)
function PartnerLearnSkillConfirmPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerLearnSkillConfirmPanel.prefab")
end

local MaxPassiveSkillNum = 8
local SkillType = {
    Old = "OldPartnerSkillItem",
    Target = "TargetPartnerSkillItem"
}

function PartnerLearnSkillConfirmPanel:__delete()
end

function PartnerLearnSkillConfirmPanel:__Create()
end

function PartnerLearnSkillConfirmPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end


function PartnerLearnSkillConfirmPanel:__BindEvent()

end

function PartnerLearnSkillConfirmPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn)
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnSubmit"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("OnBack"))
end

function PartnerLearnSkillConfirmPanel:__Hide()

end

function PartnerLearnSkillConfirmPanel:__Show()
    self.args = self.args or {}
    local config = self.args.config or {}
    self.studyIndex = config.studyIndex
    self.skillId = config.skillId
    self.bookItemId = config.bookItemId
    self.partnerData = config.partnerData
    self.onSubmitSuccess = config.onSubmitSuccess
    self.TitleText_txt.text = TI18N("学习结果")
    self:InitPassiveSkills(SkillType.Old)
    self:InitPassiveSkills(SkillType.Target)
    self:SetStudySkillInfo()
end

function PartnerLearnSkillConfirmPanel:SetStudySkillInfo()
    local studyObjectInfo = self:InitSkillItem(self[SkillType.Target .. self.studyIndex], self.skillId, false, true, true, false)
    studyObjectInfo.Button_btn.onClick:AddListener(function()
        PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
            uid = self.uid,
            skillId = self.skillId, 
        })
    end)
    UtilsUI.SetActive(studyObjectInfo.Select, true)
    local oldObjInfo = {}
    UtilsUI.GetContainerObject(self[SkillType.Old .. self.studyIndex].transform, oldObjInfo)
    UtilsUI.SetActive(oldObjInfo.Select, true)

    local studyPartnerSkillConfig = RoleConfig.GetPartnerSkillConfig(self.skillId)
    if self.oldSkillId then
        local oldPartnerSkillConfig = RoleConfig.GetPartnerSkillConfig(self.oldSkillId)
        self.successTips = TI18N(string.format("遗忘技能<color=#CE6600>%s</color>，习得技能<color=#CE6600>%s</color>", oldPartnerSkillConfig.name, studyPartnerSkillConfig.name)) 

    else
        self.successTips = TI18N(string.format("习得技能<color=#CE6600>%s</color>", studyPartnerSkillConfig.name)) 
    end
    self.StudyText_txt.text = self.successTips
end

function PartnerLearnSkillConfirmPanel:InitSkillItem(object, skillId, isLock, unLockLv, canAdd, isTalentSkill)
    local objectInfo = {}
    UtilsUI.GetContainerObject(object.transform, objectInfo)
    UtilsUI.SetActive(object, true)
    objectInfo.Button_btn.onClick:RemoveAllListeners()
    UtilsUI.SetActive(objectInfo.SkillIcon, false)
    for i = 1, 5, 1 do
        objectInfo[string.format("Quality%d_tog", i)].isOn = false
    end
    if skillId then -- 已解锁
        local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId) 
        SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon, function()
            UtilsUI.SetActive(objectInfo.SkillIcon, true)
        end) 
        objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
        objectInfo.TalentSkillText_txt.text = baseConfig.tag_text
        UtilsUI.SetActive(objectInfo.Quality, true)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
    elseif isLock and unLockLv then --升级后解锁
        UtilsUI.SetActive(objectInfo.NoSkill, true)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.IsLock, true)
        UtilsUI.SetActive(objectInfo.UnLock, false)
        UtilsUI.SetActive(objectInfo.Select, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
        objectInfo.LockTips_txt.text = TI18N(string.format("Lv.%d解锁", unLockLv))

    elseif canAdd then -- 可以打书
        UtilsUI.SetActive(objectInfo.NoSkill, true)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.IsLock, false)
        UtilsUI.SetActive(objectInfo.UnLock, true)
        UtilsUI.SetActive(objectInfo.Select, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
    else --空
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
        UtilsUI.SetActive(objectInfo.Null, true)
    end
    UtilsUI.SetActive(objectInfo.TalentSkillIcon, isTalentSkill or false)
    return objectInfo
end

function PartnerLearnSkillConfirmPanel:InitPassiveSkills(type)
    if not type then
        return
    end
    local partnerData = self.partnerData
    local baseConfig = RoleConfig.GetPartnerConfig(partnerData.template_id)
    local tempLev, tempSkillNum
    local config = RoleConfig.GetPartnerSkillTypeConfig(baseConfig.skill_type)
    local skillNum = RoleConfig.GetPartnerSkillCount(partnerData.template_id)
    local passiveSkill = partnerData.passive_skill_list
    local partnerMaxSkillCount = RoleConfig.GetPartnerPassiveSkillCount(partnerData.template_id)

    local tempPassiveSkill = {}
    for key, value in pairs(passiveSkill) do
        tempPassiveSkill[value.key] = value.value
    end
    local nowSkillNum = 0
    local tempSkillNum = 0
    for lev = 1, partnerData.lev, 1 do
       nowSkillNum = nowSkillNum + RoleConfig.GetPartenrPassiveSkillCountByLev(partnerData.template_id, lev)
    end
    -- 获取替换的技能id
    if type == SkillType.Old and tempPassiveSkill[self.studyIndex] then
        self.oldSkillId = tempPassiveSkill[self.studyIndex]
    end
    for i = 1, MaxPassiveSkillNum, 1 do
        if tempPassiveSkill[i] then
            if type == SkillType.Target and i == self.studyIndex then
                goto continue
            end
            --已解锁的技能
            -- passive_skill_list key是号位 value是skillid
            local objectInfo = self:InitSkillItem(self[type .. i], tempPassiveSkill[i], false, true, true, false)
            objectInfo.Button_btn.onClick:AddListener(function()
                PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                    uid = self.uid,
                    skillId = tempPassiveSkill[i], 
                })
            end)
        elseif i <= partnerMaxSkillCount and i <= nowSkillNum then
            -- 可以打书
            local objectInfo = self:InitSkillItem(self[type .. i], nil, false, nil, true, false)
        elseif i <= partnerMaxSkillCount then
            --需要等级提升解锁的
            if tempSkillNum < i then
                tempLev = RoleConfig.GetPartnerNextUnlockSkillByType(
                    partnerData.template_id, 
                    tempLev or partnerData.lev, 
                    RoleConfig.PartnerSkillSlotType.add_passive)
                tempSkillNum = 0
                for lev = 1, tempLev, 1 do
                    tempSkillNum = tempSkillNum + RoleConfig.GetPartenrPassiveSkillCountByLev(partnerData.template_id, lev)
                end
            end
            local objectInfo = self:InitSkillItem(self[type .. i], nil, true, tempLev, false, false)
        else
            --空技能
            local objectInfo = self:InitSkillItem(self[type .. i], nil, false, nil, false, false)
        end
        ::continue::
    end
end

function PartnerLearnSkillConfirmPanel:OnBack()
    self:PlayExitAnim()
end

function PartnerLearnSkillConfirmPanel:OnSubmit()
    if self.studyIndex == -1 or nil then
        MsgBoxManager.Instance:ShowTips(TI18N("请选择要学习的槽位"))
        return
    end
    mod.RoleCtrl:UseSkillBook(self.partnerData.unique_id, self.studyIndex, self.bookItemId, self.successTips)
    if self.onSubmitSuccess then
        self.onSubmitSuccess()
    end
    self:PlayExitAnim()
end

function PartnerLearnSkillConfirmPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function PartnerLearnSkillConfirmPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end