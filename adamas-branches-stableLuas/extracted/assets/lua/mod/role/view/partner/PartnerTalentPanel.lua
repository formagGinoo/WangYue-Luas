PartnerTalentPanel = BaseClass("PartnerTalentPanel", BasePanel)

function PartnerTalentPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PartnerTalentPanel.prefab")
end

function PartnerTalentPanel:__Create()

end

function PartnerTalentPanel:__delete()

end

function PartnerTalentPanel:__BindListener()
    self.PowerUpButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))
end

function PartnerTalentPanel:__Hide()

end

function PartnerTalentPanel:__Show()
    self.curIndex = self.parentWindow:GetAndClearDefaultParm() or 1
    self:PartnerInfoChange()
    self:SetCameraSetings()
end

function PartnerTalentPanel:SetCameraSetings()
    local partner = self:GetPartnerData().template_id
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.Talent)
    Fight.Instance.modelViewMgr:GetView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    Fight.Instance.modelViewMgr:GetView():SetModelRotation("PartnerRoot", cameraConfig.model_rotation)
    Fight.Instance.modelViewMgr:GetView():PlayModelAnim("PartnerRoot", cameraConfig.anim, 0.5)
    local blurConfig = RoleConfig.GetPartnerBlurConfig(partner, RoleConfig.PartnerCameraType.Talent)
    Fight.Instance.modelViewMgr:GetView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

function PartnerTalentPanel:PartnerInfoChange()
    local uniqueId = self:GetPartnerData().unique_id
    self:ShowDetail()
    self:ChangeTalent(self.curIndex)
end

function PartnerTalentPanel:ShowDetail()
    self.talentList = self.talentList or {}
    self.itemList = self.itemList or {}
    local partnerData = self:GetPartnerData()
    local skills = RoleConfig.GetPartnerTalentSkill(partnerData.template_id)
    local skillCount = 1
    for i = 1, #skills, 1 do
        local skill =  RoleConfig.GetPartnerSkillConfig(skills[i])
        if skillCount > 2 then
            break
        end
        self.talentList[i] = skill.id
        self["Talent"..i.."_btn"].onClick:RemoveAllListeners()
        self["Talent"..i.."_btn"].onClick:AddListener(function ()
            self:ChangeTalent(i)
        end)
        self["Talent"..i]:SetActive(true)
        self["Talent"..i.."Null"]:SetActive(false)
        local node = self:GetTalentSkill(i)
        node.TalentName_txt.text = skill.name
        SingleIconLoader.Load(node.TalentIcon, skill.icon)
        local curLev = mod.BagCtrl:GetPartnerSkillLevel(partnerData.unique_id, skill.id) or 0
        local maxLev = RoleConfig.GetPartnerSkillMaxLev(partnerData.template_id)
        node.Level_txt.text = string.format("%s/%s", curLev, maxLev)
        skillCount = skillCount + 1
    end
    for i = skillCount, 2, 1 do
        self["Talent"..i]:SetActive(false)
        self["Talent"..i.."Null"]:SetActive(true)
    end
end

function PartnerTalentPanel:GetTalentSkill(index)
    self.talentNodes = self.talentNodes or {}
    if self.talentNodes[index] then
        return self.talentNodes[index]
    end
    local node = {}
    UtilsUI.GetContainerObject(self["Talent"..index.."_rect"], node)
    self.talentNodes[index] = node
	return node
end

function PartnerTalentPanel:ChangeTalent(index)
    if self.curIndex then
        local node = self:GetTalentSkill(self.curIndex)
        node.Selected:SetActive(false)
    end
    self.curIndex = index
    
    local partnerData = self:GetPartnerData()

    local node = self:GetTalentSkill(index)

    if not node then
        return
    end
    node.Selected:SetActive(true)
    local skillId = self.talentList[index]
    local curLev = mod.BagCtrl:GetPartnerSkillLevel(partnerData.unique_id, skillId)
    local maxLev = RoleConfig.GetPartnerSkillMaxLev(partnerData.template_id)
    self.UpInfo:SetActive(curLev ~= maxLev)

    self.CurLev_txt.text = string.format("%s<color=#878b93>/%s</color>", curLev, maxLev)
    local levConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, curLev)
    self.CurDesc_txt.text = levConfig.simple_desc
    if curLev == maxLev then
        return
    end
    self.Targetlev_txt.text = string.format("%s<color=#878b93>/%s</color>", curLev + 1, maxLev)
    local levConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, curLev + 1)
    self.TargetDesc_txt.text = levConfig.simple_desc
    for i = 1, #levConfig.need_item, 1 do
        local value = levConfig.need_item[i]
        local curCount = mod.BagCtrl:GetItemCountById(value[1])
        local itemInfo = {
            template_id = value[1],
            count = ItemConfig.GetItemCountInfo(curCount, value[2]),
            onlyCount = true,
            scale = 0.8
        }
        if self.itemList[i] then
            self.itemList[i]:SetItem(itemInfo)
            self.itemList[i]:Show()
        else
            self.itemList[i] = ItemManager.Instance:GetItem(self.ItemRoot, itemInfo)
        end
    end
    if #levConfig.need_item < #self.itemList then
        for i = #levConfig.need_item + 1, #self.itemList, 1 do
            self.itemList[i].object:SetActive(false)
        end
    end

    local needGold = levConfig.need_gold

    local curGold = mod.BagCtrl:GetGoldCount()

    self.NeedGold_txt.text = ItemConfig.GetGoldShowCount(curGold, needGold)
end

function PartnerTalentPanel:OnClick_Upgrade()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end

    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end
    
    local partnerData = self:GetPartnerData()
    local skillId = self.talentList[self.curIndex]
    local lev = mod.BagCtrl:GetPartnerSkillLevel(partnerData.unique_id, skillId)
    local levConfig = RoleConfig.GetPartnerSkillLevelConfig(skillId, lev + 1)
    

    local needGold = levConfig.need_gold
    local curGold = mod.BagCtrl:GetGoldCount()
    

    for key, value in pairs(levConfig.need_item) do
        local curCount = mod.BagCtrl:GetItemCountById(value[1])
        if curCount < value[2] then
            MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
            return
        end
    end
    
    if curGold < needGold then
        local desc = string.format(TI18N("%s不足"), ItemConfig.GetItemConfig(2).name)
        MsgBoxManager.Instance:ShowTips(desc)
        return
    end

    mod.RoleCtrl:PartnerSkillLevUp(self:GetPartnerData().unique_id, skillId)
end

function PartnerTalentPanel:GetPartnerData()
    return self.parentWindow:GetPartnerData()
end

function PartnerTalentPanel:HideAnim()
    self.PartnerTalentPanel_Exit:SetActive(true)
end
