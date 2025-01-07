CommonWeaponInfo = BaseClass("CommonWeaponInfo", PoolBaseClass)

function CommonWeaponInfo:__init()

end

function CommonWeaponInfo:Init(object)
    self.node = UtilsUI.GetContainerObject(object.transform)
end

function CommonWeaponInfo:ChangeUIDetail(uniqueId)
    local node = self.node
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId)
    local weaponId = weaponData.template_id
    local baseConfig = ItemConfig.GetItemConfig(weaponId)
    local typeConfig = RoleConfig.GetWeaponTypeConfig(baseConfig.type)
    local stageConfig =  RoleConfig.GetStageConfig(weaponId, weaponData.stage)
    local refineConfig = RoleConfig.GetWeaponRefineConfig(weaponId, weaponData.refine)

    node.LockButton_btn.onClick:RemoveAllListeners()
    node.LockButton_btn.onClick:AddListener(function ()
        mod.BagCtrl:SetItemLockState(uniqueId, not weaponData.is_locked, BagEnum.BagType.Weapon)
    end)
    node.PreviewButton_btn.onClick:RemoveAllListeners()
    node.PreviewButton_btn.onClick:AddListener(function ()
        PanelManager.Instance:OpenPanel(BaseStagePreviewPanel, {id = weaponId, startStage = weaponData.stage, caseType = BaseStagePreviewPanel.CaseType.Weapon})
    end)

    node.Name_txt.text = baseConfig.name
    node.TypeName_txt.text = typeConfig.type_name
    if typeConfig.type_icon ~= "" then
        SingleIconLoader.Load(node.QualityIcon, typeConfig.type_icon)
    end
    node.UnLock:SetActive(not weaponData.is_locked)
    node.IsLock:SetActive(weaponData.is_locked)

    SingleIconLoader.Load(node.Stage, "Textures/Icon/Single/StageIcon/" .. weaponData.stage .. ".png")

    node.CurLevel_txt.text = weaponData.lev
    node.MaxLevel_txt.text = stageConfig.level_limit

    if weaponData.lev == stageConfig.level_limit then
        node.ProgressValue_img.fillAmount = 0
        node.ProgressEffect_img.fillAmount = 0
    else
        local curExp = weaponData.exp
        local maxExp = RoleConfig.GetWeaponLevelExp(weaponId, weaponData.lev + 1)
        if maxExp then
            node.ProgressValue_img.fillAmount = curExp / maxExp
            node.ProgressEffect_img.fillAmount = curExp / maxExp
        else
            node.ProgressValue_img.fillAmount = 0
            node.ProgressEffect_img.fillAmount = 0
        end

    end

    local attrTable = RoleConfig.GetWeaponBaseAttrs(weaponId, weaponData.lev, weaponData.stage)
    local attrCount = 2
    local curCount = 0
    for key, value in pairs(attrTable) do
        curCount = curCount + 1
        if curCount > 2 then
            curCount = curCount - 1
            break
        end
        node["Attr"..curCount]:SetActive(true)
        SingleIconLoader.Load(node["AttrIcon"..curCount], RoleConfig.GetAttrConfig(key).icon)
        node["AttrName"..curCount.."_txt"].text = RoleConfig.GetAttrConfig(key).name
        if RoleConfig.GetAttrConfig(key).value_type == FightEnum.AttrValueType.Percent then
            value = value /100 .."%"
        end
        node["AttrValue"..curCount.."_txt"].text = value
    end
    for i = curCount + 1, attrCount, 1 do
        node["Attr"..i]:SetActive(false)
    end

    if refineConfig and refineConfig.skill_name ~= "" then
    end
    if refineConfig and refineConfig.desc ~= "" then
        UnityUtils.SetActive(node.RefineInfo, true)
        UnityUtils.SetActive(node.SkillDescribe, true)
        node.RefineText_txt.text = weaponData.refine
        node.RefineDescribe_txt.text = string.format(TI18N("精炼%s级"), weaponData.refine)
        node.SkillDescribe_txt.text = refineConfig.desc
    else
        UnityUtils.SetActive(node.RefineInfo, false)
        UnityUtils.SetActive(node.SkillDescribe, false)
    end

    node.WeaponDescribe:SetActive(baseConfig.desc ~= "")
    if baseConfig.desc ~= "" then
        node.WeaponDescribe_txt.text = baseConfig.desc
    end
end

function CommonWeaponInfo:OnCache()
    Fight.Instance.objectPool:Cache(CommonWeaponInfo, self)
end

function CommonWeaponInfo:__cache()
    
end