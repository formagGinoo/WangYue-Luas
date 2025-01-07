RolePartnerPanel = BaseClass("RolePartnerPanel", BasePanel)

local PartnerIndex = "PartnerRoot"

local ButtonState = {
    Replace = 1,
    Equip = 2,
    Cur = 3,
}

local ObjType = {
    Skill = "SkillItem",
}

local SelectState = {
    NotSelect = 1,
    Select = 2,
}

local PageIndex = {
    Attr = "Attribute",
    Skill = "Skill",
    Natural = "Natural"
}

function RolePartnerPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Partner/RolePartnerPanel.prefab")
    self.cacheMap = {}
    self.objectMap = {}
end

--添加监听器
function RolePartnerPanel:__BindListener()
    self.OpenListButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenList"))
    self.EquipButton_btn.onClick:AddListener(self:ToFunc("OnClick_ReplaceButton"))
    for key, index in pairs(PageIndex) do
        self[index .. "Toggle_tog"].onValueChanged:AddListener(function(isEnter)
            if isEnter then
                self:ChangePage(index, self.curSelect or self:GetRolePartner())
            end
        end
        )
    end

    local syetemLock = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerNatural)
    self[PageIndex.Natural .. "Mask"]:SetActive(not syetemLock)
    self[PageIndex.Natural .. "Mask_btn"].onClick:AddListener(function()
        local isPass, desc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerNatural)
        if not isPass then
            MsgBoxManager.Instance:ShowTips(desc)
        end
    end)

    self.BGButton_btn.onClick:AddListener(self:ToFunc("OnClick_BGButton"))
    self.LevelUpButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))

    self.UnLockTip_btn.onClick:AddListener(self:ToFunc("UnlockSkillPreView"))
    self.DetailButton_btn.onClick:AddListener(self:ToFunc("UnlockSkillPreView"))

    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    EventMgr.Instance:AddListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeRoleModel"))
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

--缓存对象
function RolePartnerPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function RolePartnerPanel:__Create()
end

function RolePartnerPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    EventMgr.Instance:RemoveListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeRoleModel"))
    EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
end

function RolePartnerPanel:__Hide()
    self:GetModelView():ShowModel(PartnerIndex)
    self:GetModelView():SetDepthOfFieldGaussian(true)
end

function RolePartnerPanel:__Show()
    self.BGButton:SetActive(false)
    self.selectState = SelectState.NotSelect
    self:ChangeShowRole(self:GetCurRole())
    self:SetModelView()
    self:LoadPartner(self.curSelect)
end

function RolePartnerPanel:__ShowComplete()

end

--角色信息改变
function RolePartnerPanel:RoleInfoUpdate(index, roledata)
    if roledata.id == self:GetCurRole() then
        if self.curSelect and self.curSelect == roledata.partner_id then
            self:SetButtonState(ButtonState.Cur)
        elseif roledata.partner_id == 0 then
            self:SetButtonState(ButtonState.Equip)
        end
    end
end


--佩从信息变化
function RolePartnerPanel:PartnerInfoChange(oldData, newData)
    if not self.active or oldData.hero_id ~= newData.hero_id then
        return
    end
    if self.curSelect and self.curSelect == newData.unique_id then
        self:UpdateShow(self.curSelect)
    elseif newData.unique_id == self:GetRolePartner() then
        self:UpdateShow()
    end
end

--改变当前角色
function RolePartnerPanel:ChangeShowRole()
    if not self.active then
        return
    end
    self.buttonState = nil
    self.ignoreHideFunc = true;
    self.parentWindow:ClosePanel(ItemSelectPanel)
    self.ignoreHideFunc = false;
    self:UpdateShow(self.curSelect)
end

--切换角色模型完成
function RolePartnerPanel:ChangeRoleModel()
    if not self.active then
        return
    end
    self:SetModelView()
    self:LoadPartner(self.curSelect)
end

function RolePartnerPanel:LoadPartner(uniqueId)
    local uniqueId = uniqueId or self:GetRolePartner()
    if uniqueId == 0 then
        self:GetModelView():ShowModel(PartnerIndex, false)
        local blurConfig = RoleConfig.GetRoleBlurConfig(0, RoleConfig.PageBlurType.UnEquipPartner)
        self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
        return
    end
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local onLoad = function()
        local cameraConfig = RoleConfig.GetPartnerCameraConfig(partnerData.template_id, self.selectState)
        self:GetModelView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
        self:GetModelView():RecordCamera()
        self:GetModelView():SetModelRotation(PartnerIndex, cameraConfig.model_rotation)
        self:GetModelView():PlayModelAnim(PartnerIndex, cameraConfig.anim, 0.5)

        local blurConfig = RoleConfig.GetRoleBlurConfig(partnerData.template_id, RoleConfig.PageBlurType.EquipPartner)
        self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
    end
    self:GetModelView():LoadModel(PartnerIndex, partnerData.template_id, onLoad)
end

function RolePartnerPanel:SetModelView()
    local roleCamera
    local uniqueId = self:GetRolePartner()
    if uniqueId == 0 then
        roleCamera = RoleConfig.GetRoleCameraConfig(self:GetCurRole(), RoleConfig.PageCameraType.UnEquipPartner)
        self:GetModelView():BlendToNewCamera(roleCamera.camera_position, roleCamera.camera_rotation, 24.5)
        self:GetModelView():RecordCamera()
    else
        roleCamera = RoleConfig.GetRoleCameraConfig(self:GetCurRole(), RoleConfig.PageCameraType.EquipPartner)
    end
    self:GetModelView():SetModelRotation("RoleRoot", roleCamera.model_rotation)
    self:GetModelView():PlayModelAnim("RoleRoot", roleCamera.anim, 0.5)
end

-- 以下内容可以抽出来
function RolePartnerPanel:UpdateShow(uniqueId)
    ---更新佩从数据
    local uniqueId = uniqueId or self:GetRolePartner()
    self.NullMask:SetActive(uniqueId == 0)
    self.UnEquip:SetActive(uniqueId == 0)
    self.OnEquip:SetActive(uniqueId ~= 0)
    self:SetRedPoint(uniqueId)
    self:SetButtonState(self.buttonState or ButtonState.Replace)
    if uniqueId ~= 0 then
        self:ShowUpdateTip(uniqueId)
        self:ChangePage(self.curPage or PageIndex.Attr, uniqueId)
    else
        self:GetModelView():ShowModel(PartnerIndex)
    end
end

function RolePartnerPanel:SetRedPoint(uniqueId)
    if uniqueId == 0 and mod.RoleCtrl:CheckPartnerRedPoint() then 
        UtilsUI.SetActive(self.PartnerRedPoint,true)
    else
        UtilsUI.SetActive(self.PartnerRedPoint,false)
    end
end

function RolePartnerPanel:ShowUpdateTip(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerId)

    self.Name_txt.text = baseConfig.name
    self.CurLevel_txt.text = partnerData.lev
    self.LevelLimit_txt.text = RoleConfig.PartnerMaxLev
    self.Locked:SetActive(partnerData.is_locked or false)
    self.QualityDesc_txt.text = qualityConfig.name
    SingleIconLoader.Load(self.QualityBg, qualityConfig.icon)

end

function RolePartnerPanel:ChangePage(index, uniqueId)
    self:ChangeToggle(index)
    if self.curPage then
        self[self.curPage .. "Page"]:SetActive(false)
        UtilsUI.SetTextColor(self[self.curPage .. "Text_txt"], "#757C86")
    end
    if self.curPage and self.curPage ~= index then
        self:OnClick_BGButton()
    end
    self.curPage = index
    UtilsUI.SetTextColor(self[index .. "Text_txt"], "#FFFFFF")
    self[index .. "Page"]:SetActive(true)
    if index == PageIndex.Attr then
        self:ShowAttrPage(uniqueId)
    elseif index == PageIndex.Skill then
        self:ShowSkillPage(uniqueId)
    elseif index == PageIndex.Natural then
        self:ShowNaturalPage(uniqueId)
    end
end

function RolePartnerPanel:ChangeToggle(index)
    if self.curPage == index then return end
    for _, v in pairs(PageIndex) do
        self[v.."Select"]:SetActive(false)
    end
    self[index.."Select"]:SetActive(true)
end

function RolePartnerPanel:ShowAttrPage(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = RoleConfig.GetPartnerConfig(partnerId)

    local attrTable = UtilsBase.copytab(partnerData.property_list) or {}
    local showCount = #attrTable
    showCount = math.min(showCount, 4)

    for i = 1, #attrTable, 1 do
        attrTable[i].priority = RoleConfig.GetAttrPriority(attrTable[i].key)
    end

    table.sort(attrTable, function(a, b)
        return a.priority > b.priority
    end)

    for i = 1, showCount, 1 do
        local attr = attrTable[i]
        local attrValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr.key, attr.value)
        self["Attribute" .. i]:SetActive(true)
        self:ShowAttr(i, attr.key, attr.value, attrValue)
    end
    for i = showCount + 1, 4, 1 do
        self["Attribute" .. i]:SetActive(false)
    end

    local talentId = baseConfig.talent
    local talentConfig = RoleConfig.GetPartnerTalentConfig(talentId)

    if not talentConfig then
        self.Talent:SetActive(false)
        return
    end
    self.Talent:SetActive(true)
    self.TalentType_txt.text = talentConfig.name
    SingleIconLoader.Load(self.TalentIcon, talentConfig.icon)

    --职业技能
    local skills = RoleConfig.GetPartnerTalentSkill(partnerId)
    local skillCount = 1
    for i = 1, #skills, 1 do
        local skill = RoleConfig.GetPartnerSkillConfig(skills[i])
        if skillCount > 2 then
            break
        end
        local node = self:GetTalentSkill(skillCount)

        self["Talent" .. skillCount .. "_btn"].onClick:RemoveAllListeners()
        self["Talent" .. skillCount .. "_btn"].onClick:AddListener(function()
            local callBack = function()
                self.BGButton:SetActive(true)
            end
            if self.oldNode then
                self.oldNode.Selected:SetActive(false)
            end
            node.Selected:SetActive(true)
            self.oldNode = node
            local panel = self.parentWindow:OpenPanel(PartnerSkillInfoPanel, { template_id = partnerId, unique_id = self.curSelect or self:GetRolePartner(), skillId = skill.id, index = i, callBack = callBack })
            panel:ChangeSkill(partnerId, self.curSelect or self:GetRolePartner(), skill.id, i)
        end)
        self["Talent" .. skillCount]:SetActive(true)
        self["Talent" .. skillCount .. "Null"]:SetActive(false)
        node.TalentName_txt.text = skill.name
        SingleIconLoader.Load(node.TalentIcon, skill.icon)
        local curLev = mod.BagCtrl:GetPartnerSkillLevel(uniqueId, skill.id) or 0
        local maxLev = RoleConfig.GetPartnerSkillMaxLev(partnerId)
        node.Level_txt.text = string.format("%s/%s", curLev, maxLev)
        skillCount = skillCount + 1
    end
    for i = skillCount, 2, 1 do
        self["Talent" .. i]:SetActive(false)
        self["Talent" .. i .. "Null"]:SetActive(true)
    end
end

function RolePartnerPanel:GetTalentSkill(index)
    self.talentNodes = self.talentNodes or {}
    if self.talentNodes[index] then
        return self.talentNodes[index]
    end
    local node = {}
    UtilsUI.GetContainerObject(self["Talent" .. index .. "_rect"], node)
    self.talentNodes[index] = node
    return node
end

function RolePartnerPanel:ShowAttr(index, attrType, value, attrValue)
    local rank, icon = RoleConfig.GetPartnerAttrRank(attrType, value)
    local name, showValue = RoleConfig.GetShowAttr(attrType, attrValue)
    SingleIconLoader.Load(self["AttributeRank" .. index], icon)
    self["AttributeDesc" .. index .. "_txt"].text = name
    self["AttributeValue" .. index .. "_txt"].text = showValue
end

function RolePartnerPanel:ShowSkillPage(uniqueId)
    self.curSkillObj = nil
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local baseConfig = RoleConfig.GetPartnerConfig(partnerData.template_id)

    local config = RoleConfig.GetPartnerSkillTypeConfig(baseConfig.skill_type)
    if config then
        SingleIconLoader.Load(self.ElementBg, config.bg)
        SingleIconLoader.Load(self.ElementType, config.icon)
        self.SkillType_txt.text = config.name
    end

    local maxCount = baseConfig.skill_count
    local skills = partnerData.skill_list
    local lev, count = RoleConfig.GetPartnerNextUnlockSkillCount(partnerData.template_id, partnerData.lev)
    if lev then
        self.UnLockTip:SetActive(true)
        self.StageTipText_txt.text = string.format("LV.%s", lev)
        self.StageTipText2_txt.text = string.format(TI18N("解锁%s个随机新战技"), count)
    else
        self.UnLockTip:SetActive(false)
    end

    self:CacheObjectByType(ObjType.Skill)
    local skillCount = 0
    for i = 1, #skills, 1 do
        local skill = RoleConfig.GetPartnerSkillConfig(skills[i].key)
        if skillCount < maxCount and skill and skill.type ~= RoleConfig.PartnerSkillType.Talent then
            self:ShowSkillObj(skills[i].key, skills[i].value)
            skillCount = skillCount + 1
        end
    end
    for i = skillCount + 1, maxCount, 1 do
        self:ShowSkillObj()
    end
end

function RolePartnerPanel:ShowNaturalPage(uniqueId)

end

function RolePartnerPanel:ShowSkillObj(skillId, level)
    local uniqueId = self.curSelect or self:GetRolePartner()
    local obj = self:GetTempObj(ObjType.Skill)
    obj.objectTransform:SetParent(self.SkillList_rect)
    obj.objectTransform:ResetAttr()
    obj.LockBg:SetActive(not skillId)
    obj.Select:SetActive(false)
    obj.Content:SetActive(skillId and true)
    if not skillId then
        return
    end
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
    obj.Box:SetActive(baseConfig.type == RoleConfig.PartnerSkillType.Specificity)
    obj.Level_txt.text = level
    obj.Select:SetActive(false)
    SingleIconLoader.Load(obj.Icon, baseConfig.icon)
    obj.Icon_btn.onClick:RemoveAllListeners()
    obj.Icon_btn.onClick:AddListener(function()
        if self.curSkillObj then
            self.curSkillObj.Select:SetActive(false)
        end
        obj.Select:SetActive(true)
        self.curSkillObj = obj
        local callBack = function()
            self.BGButton:SetActive(true)
        end
        local panel = self.parentWindow:OpenPanel(PartnerSkillInfoPanel, { template_id = partnerId, uniqueId = uniqueId, skillId = skillId, callBack = callBack })
        panel:ChangeSkill(partnerId, uniqueId, skillId)
        --self.curSelect
    end)
end

function RolePartnerPanel:GetTempObj(type)
    if self.cacheMap[type] and next(self.cacheMap[type]) then
        local obj = table.remove(self.cacheMap[type])
        table.insert(self.objectMap[type], obj)
        return obj
    end
    local obj = self:PopUITmpObject(type)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    if not self.objectMap[type] then
        self.objectMap[type] = {}
    end
    table.insert(self.objectMap[type], obj)
    return obj
end

function RolePartnerPanel:CacheObjectByType(type)
    if self.objectMap[type] then
        for key, value in pairs(self.objectMap[type]) do
            self:CacheObject(value, type)
        end
        self.objectMap[type] = {}
    end
end

function RolePartnerPanel:CacheObject(obj, type)
    obj.objectTransform:SetParent(self.CacheRoot_rect)
    if not self.cacheMap[type] then
        self.cacheMap[type] = {}
    end
    table.insert(self.cacheMap[type], obj)
end

function RolePartnerPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function RolePartnerPanel:GetRolePartner()
    local roleId = mod.RoleCtrl:GetCurUISelectRole()
    return mod.RoleCtrl:GetRolePartner(roleId)
end

function RolePartnerPanel:OnClick_BGButton()
    if self.oldNode then
        self.oldNode.Selected:SetActive(false)
    end
    self.BGButton:SetActive(false)
    local panel = self.parentWindow:GetPanel(PartnerSkillInfoPanel)
    if panel then
        panel:Close()
    end
    if self.curSkillObj then
        self.curSkillObj.Select:SetActive(false)
        self.curSkillObj = nil
    end
end

function RolePartnerPanel:OnClick_Upgrade()
    local isPass, desc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerUpgrade)
    WindowManager.Instance:OpenWindow(PartnerMainWindow, { uniqueId = self.curSelect or self:GetRolePartner(), initTag = RoleConfig.PartnerPanelType.Level })
end

function RolePartnerPanel:OnClick_OpenList()
    local config = {
        name = "佩从选择",
        width = 440,
        col = 3,
        bagType = BagEnum.BagType.Partner,
        onClick = self:ToFunc("SelectPartner"),
        hideFunc = self:ToFunc("HideSelectFunc"),
        defaultSelect = self:GetRolePartner()
    }
    self.selectState = SelectState.Select
    self.parentWindow:OpenPanel(ItemSelectPanel, { config = config })
end

function RolePartnerPanel:SelectPartner(uniqueId, templateId, type)
    if self.curSelect and self.curSelect == uniqueId then
        return
    end
    self.curSelect = uniqueId
    if self.curSelect == self:GetRolePartner() then
        self:SetButtonState(ButtonState.Cur)
    else
        self:SetButtonState(ButtonState.Equip)
    end
    self:UpdateShow(uniqueId)
    self:LoadPartner(uniqueId)
end

function RolePartnerPanel:HideSelectFunc()
    self.selectState = SelectState.NotSelect
    self.curSelect = nil
    if self.ignoreHideFunc then
        return
    end
    self:SetButtonState(ButtonState.Replace)
    self:UpdateShow()
    self:LoadPartner()
end

function RolePartnerPanel:SetButtonState(state)
    self.buttonState = state
    if self.buttonState == ButtonState.Replace then
        self.EquipText_txt.text = TI18N("替换")
    elseif self.buttonState == ButtonState.Equip then
        self.EquipText_txt.text = TI18N("替换")
    elseif self.buttonState == ButtonState.Cur then
        self.EquipText_txt.text = TI18N("换下")
    end
end

function RolePartnerPanel:OnClick_ReplaceButton()
    if self.buttonState == ButtonState.Replace then
        self:OnClick_OpenList()
        return
    end
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end

    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end

    local player = Fight.Instance.playerManager:GetPlayer()
    if player then
        local entityList = player:GetEntityList()
        for _, entity in pairs(entityList) do
            local partnerInstanceId = player:GetHeroPartnerInstanceId(player:GetInstanceIdByHeroId(entity.masterId))
            if partnerInstanceId and BehaviorFunctions.CheckEntityForeground(partnerInstanceId) then
                MsgBoxManager.Instance:ShowTips(TI18N("请等待佩从退场"))
                return
            end
        end
    end
    if self.buttonState == ButtonState.Equip then
        self:EquipPartner(self.curSelect)
        MsgBoxManager.Instance:ShowTips(TI18N("佩从替换成功"))
    elseif self.buttonState == ButtonState.Cur then
        self:EquipPartner()
        MsgBoxManager.Instance:ShowTips(TI18N("佩从换下成功"))
    end
end

function RolePartnerPanel:EquipPartner(uniqueId)
    mod.RoleCtrl:SetRolePartner(self:GetCurRole(), uniqueId)
end

function RolePartnerPanel:UnlockSkillPreView()
    PanelManager.Instance:OpenPanel(PartnerSkillPreviewPanel, { partnerId = self.curSelect or self:GetRolePartner() })
end

function RolePartnerPanel:OnClose()
    self.RolePartnerPanel_you_Exit:SetActive(true)
end

function RolePartnerPanel:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end