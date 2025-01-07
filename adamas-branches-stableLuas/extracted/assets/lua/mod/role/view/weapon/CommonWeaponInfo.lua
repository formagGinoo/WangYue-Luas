CommonWeaponInfo = BaseClass("CommonWeaponInfo", PoolBaseClass)

function CommonWeaponInfo:__init()

end

function CommonWeaponInfo:Init(object,uid)
    self.node = UtilsUI.GetContainerObject(object.transform)
    if uid then
        self.uid = uid
        UtilsUI.SetActiveByScale(self.node.LockButton,false)
        UtilsUI.SetActiveByScale(self.node.PreviewButton,false)
    else
        UtilsUI.SetActiveByScale(self.node.LockButton,true)
    end
end

function CommonWeaponInfo:ChangeUIDetail(uniqueId, roleId)
    local node = self.node
    local weaponData = mod.BagCtrl:GetWeaponData(uniqueId,roleId,self.uid)
    local isRobot = mod.RoleCtrl:CheckRoleIsRobot(roleId)
    if isRobot then
        UtilsUI.SetActive(self.node.PreviewButton,false)
    else
        UtilsUI.SetActive(self.node.PreviewButton,true)
    end
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

    for i = 1, 5, 1 do
        if i == baseConfig.quality then
            UtilsUI.SetActiveByScale(node["Quality"..i],true)
        else
            UtilsUI.SetActiveByScale(node["Quality"..i],false)
        end
    end

    node.UnLock:SetActive(not weaponData.is_locked)
    node.IsLock:SetActive(weaponData.is_locked)

    SingleIconLoader.Load(node.Stage, "Textures/Icon/Single/StageIcon/" .. weaponData.stage .. ".png")

    node.CurLevel_txt.text = weaponData.lev
    node.MaxLevel_txt.text = stageConfig.level_limit

    if weaponData.lev == stageConfig.level_limit then
        if RoleConfig.GetWeaponLevelExp(weaponId, weaponData.lev + 1) then
            node.ProgressValue_img.fillAmount = 0
        else
            node.ProgressValue_img.fillAmount = 1
        end
    else
        local curExp = weaponData.exp
        local maxExp = RoleConfig.GetWeaponLevelExp(weaponId, weaponData.lev + 1)
        node.ProgressValue_img.fillAmount = curExp / maxExp
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
        if weaponData.refine < 5 then 
            UtilsUI.SetActive(self.node.RefineBg1,true)
            UtilsUI.SetActive(self.node.RefineBg2,false)
        else
            UtilsUI.SetActive(self.node.RefineBg1,false)
            UtilsUI.SetActive(self.node.RefineBg2,true)
        end

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