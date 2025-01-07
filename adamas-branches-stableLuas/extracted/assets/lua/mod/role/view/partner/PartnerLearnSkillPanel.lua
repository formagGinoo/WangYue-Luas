PartnerLearnSkillPanel = BaseClass("PartnerLearnSkillPanel", BasePanel)

local ShowSkillRowNum = 4
local PassiveSkillsNum = 8

function PartnerLearnSkillPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerLearnSkillPanel.prefab")
end

function PartnerLearnSkillPanel:__Create()
    
end

function PartnerLearnSkillPanel:__delete()
    -- EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function PartnerLearnSkillPanel:__BindListener()
    -- EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    self.LearnButton_btn.onClick:AddListener(self:ToFunc("OnClick_PassiveSkillSelectPanel"))
end

function PartnerLearnSkillPanel:__Hide()

end

function PartnerLearnSkillPanel:__Show()
    self:PartnerInfoChange()
end

function PartnerLearnSkillPanel:PartnerInfoChange()
    self.partnerData = self:GetPartnerData()
    self.passSkillList = {}
    self:PushAllUITmpObject("SkillItem", self.SkillItemCache_rect)
    self:InitNaturalSkills()
    self:InitPassiveSkills()
end

function PartnerLearnSkillPanel:OnClick_PassiveSkillSelectPanel(studyIndex, selectSkillId)
    local passSelPanel = self.parentWindow:GetPanel(PassiveSkillSelectPanel)
    if not passSelPanel or passSelPanel:Active() == false then --select面板是关闭的
        self.nowStudyIndex = studyIndex or self.autoStudyIndex
        if self.nowStudyIndex then
            UtilsUI.SetActive(self.passSkillList[self.nowStudyIndex].Select, true)
        end
        self.selectStudySkillId  = nil
        self.parentWindow:OpenPanel(PassiveSkillSelectPanel,{config = {
            partnerData = self.partnerData,
            onClick = self:ToFunc("OnClick_StudySkillBook"),
            hideFunc = function()
                if self.nowStudyIndex then
                    UtilsUI.SetActive(self.passSkillList[self.nowStudyIndex].Select, false)
                end
            end
        }})
    elseif studyIndex and passSelPanel and passSelPanel:Active() == true then
        if self.nowStudyIndex then
            UtilsUI.SetActive(self.passSkillList[self.nowStudyIndex].Select, false)
        end
        if self.nowStudyIndex == studyIndex and selectSkillId then
            PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                uid = self.uid,
                skillId = selectSkillId
            })
        end
        self.nowStudyIndex = studyIndex
        UtilsUI.SetActive(self.passSkillList[self.nowStudyIndex].Select, true)
    else
        if not self.selectStudySkillId then
            MsgBoxManager.Instance:ShowTips(TI18N("请选择要消耗的技能书"))
        elseif not self.nowStudyIndex then
            MsgBoxManager.Instance:ShowTips(TI18N("请选择要学习的槽位"))
        else
            self.parentWindow:OpenPanel(PartnerLearnSkillConfirmPanel,{config = {
                skillId = self.selectStudySkillId,
                studyIndex = self.nowStudyIndex or -1,
                partnerData = self.partnerData,
                bookItemId = self.selectStudyItemId, 
                onSubmitSuccess = function()
                    self.selectStudySkillId = nil
                    self.selectStudyItemId = nil
                    if self.nowStudyIndex then
                        UtilsUI.SetActive(self.passSkillList[self.nowStudyIndex].Select, false)
                    end
                    self.nowStudyIndex = nil
                    passSelPanel:PlayExitAnim()
                end
            }})
        end
    end
end

function PartnerLearnSkillPanel:OnClick_StudySkillBook(skillId, itemId)
    self.selectStudySkillId = skillId
    self.selectStudyItemId = itemId
end

function PartnerLearnSkillPanel:InitNaturalSkills()
    self.NaturalSkillsText_txt = TI18N("   天赋技能")
    local partnerId = self.partnerData.template_id
    local partnerMaxSkillCount = RoleConfig.GetPartnerSkillCount(partnerId)
    local showSkillItemNum = UtilsBase.ExpandToMultiple(partnerMaxSkillCount, ShowSkillRowNum)
    local curPartnerHasSkillList = self.partnerData.skill_list
    local tempLev
    local tempSkillNum
    tempSkillNum = 0
    for i = 1, showSkillItemNum do
        if curPartnerHasSkillList[i] then
            --已解锁的技能
            local objectInfo = self:PopUITmpObject("SkillItem", self.NaturalSkillsList_rect)
            self:InitSkillItem(objectInfo, curPartnerHasSkillList[i].key, false, true, true, true)
            objectInfo.Button_btn.onClick:AddListener(function()
                PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                    uid = self.uid,
                    skillId = curPartnerHasSkillList[i].key, 
                })
            end)
        elseif i <= partnerMaxSkillCount then
            if tempSkillNum < i then
                --需要等级提升解锁的
                tempLev = RoleConfig.GetPartnerNextUnlockSkillByType(
                    self.partnerData.template_id, 
                    tempLev or self.partnerData.lev, 
                    RoleConfig.PartnerSkillSlotType.add_skill)
                tempSkillNum = 0
                for lev = 1, tempLev, 1 do
                    tempSkillNum = tempSkillNum + RoleConfig.GetPartenrSkillCountByLev(self.partnerData.template_id, lev)
                end
            end
            local objectInfo = self:PopUITmpObject("SkillItem", self.NaturalSkillsList_rect)
            self:InitSkillItem(objectInfo, nil, true, tempLev, false, false)
        else
            --空技能
            local objectInfo = self:PopUITmpObject("SkillItem", self.NaturalSkillsList_rect)
            self:InitSkillItem(objectInfo, nil, false, nil, false, false)
        end
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.NaturalSkillsList.transform)
end

function PartnerLearnSkillPanel:InitPassiveSkills()
    self.PassiveSkillsText_txt.text = TI18N("   被动技能")
    self.passSkillList = {}
    local partnerData = self.partnerData
    local partnerId = self.partnerData.template_id
    local tempLev, studyIndex
    local showSkillItemNum = UtilsBase.ExpandToMultiple(PassiveSkillsNum, ShowSkillRowNum)
    local passiveSkill = partnerData.passive_skill_list
    local tempPassiveSkill = {}
    for key, value in pairs(passiveSkill) do
        tempPassiveSkill[value.key] = value.value
    end
    local partnerMaxSkillCount = RoleConfig.GetPartnerPassiveSkillCount(partnerData.template_id)
    local nowSkillNum = 0
    local tempSkillNum = 0
    for lev = 1, partnerData.lev, 1 do
       nowSkillNum = nowSkillNum + RoleConfig.GetPartenrPassiveSkillCountByLev(partnerData.template_id, lev)
    end
    for i = 1, showSkillItemNum, 1 do
        if tempPassiveSkill[i] then
            --已解锁的技能
            -- passive_skill_list key是号位 value是skillid
            local objectInfo = self:PopUITmpObject("SkillItem", self.PassiveSkillsList_rect)
            self:InitSkillItem(objectInfo, tempPassiveSkill[i], false, true, true, false)
            objectInfo.Button_btn.onClick:AddListener(function()
                self:OnClick_PassiveSkillSelectPanel(i, tempPassiveSkill[i])
            end)
            table.insert(self.passSkillList, objectInfo)
        elseif i <= partnerMaxSkillCount and i <= nowSkillNum then
            -- 可以打书
            local objectInfo = self:PopUITmpObject("SkillItem", self.PassiveSkillsList_rect)
            self:InitSkillItem(objectInfo, nil, false, nil, true, false)
            if not studyIndex then
                studyIndex = i
                self.autoStudyIndex = studyIndex
            end
            objectInfo.Button_btn.onClick:AddListener(function()
                self:OnClick_PassiveSkillSelectPanel(i, tempPassiveSkill[i])
            end)
            table.insert(self.passSkillList, objectInfo)
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
            local objectInfo = self:PopUITmpObject("SkillItem", self.PassiveSkillsList_rect)
            self:InitSkillItem(objectInfo, nil, true, tempLev, false, false)
            table.insert(self.passSkillList, objectInfo)
        else
            --空技能
            local objectInfo = self:PopUITmpObject("SkillItem", self.PassiveSkillsList_rect)
            self:InitSkillItem(objectInfo, nil, false, nil, false, false)
            table.insert(self.passSkillList, objectInfo)
        end
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.PassiveSkillsList.transform)
end

function PartnerLearnSkillPanel:SetCameraSetings()
    
end

function PartnerLearnSkillPanel:GetPartnerData()
    return self.parentWindow:GetPartnerData()
end

function PartnerLearnSkillPanel:HideAnim()
    
end

--- 初始化月灵天赋item
---@param objectInfo push出来的obj
---@param skillId 技能id
---@param isLock 是否能解锁
---@param unLockLv 解锁等级
---@param canAdd 可以打书
---@param isTalentSkill 是天赋技能
function PartnerLearnSkillPanel:InitSkillItem(objectInfo, skillId, isLock, unLockLv, canAdd, isTalentSkill)
    UtilsUI.GetContainerObject(objectInfo.object, objectInfo)
    UtilsUI.SetActive(objectInfo.object, true)
    objectInfo.Button_btn.onClick:RemoveAllListeners()
    UtilsUI.SetActive(objectInfo.SkillIcon, false)
    for i = 1, 5, 1 do
        objectInfo[string.format("Quality%s_tog", i)].isOn = false
    end
    if skillId then -- 已解锁
        local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
        SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon)
        UtilsUI.SetActive(objectInfo.SkillIcon, true)
        objectInfo[string.format("Quality%s_tog", baseConfig.quality)].isOn = true
        UtilsUI.SetActive(objectInfo.Quality, true)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        objectInfo.TalentSkillText_txt.text = baseConfig.tag_text
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
        UtilsUI.SetActive(objectInfo.Back, false)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
        UtilsUI.SetActive(objectInfo.Null, true)
    end
    UtilsUI.SetActive(objectInfo.TalentSkillIcon, isTalentSkill or false)
    return objectInfo
end