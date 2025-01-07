CommonPartnerInfo = BaseClass("CommonPartnerInfo", PoolBaseClass)

local ObjType = {
    Skill = "SkillItem",
}

local PageIndex = {
    Attr = "Attribute",
    Skill = "Skill",
    Natural = "Natural"
}

function CommonPartnerInfo:__init()
    self.cacheMap = {}
    self.objectMap = {}
end

function CommonPartnerInfo:Init(object)
    UtilsUI.GetContainerObject(object.transform, self)
    for key, index in pairs(PageIndex) do
        self[index.."Toggle_tog"].onValueChanged:RemoveAllListeners()
        self[index.."Toggle_tog"].onValueChanged:AddListener(function (isEnter)
			if isEnter then
				self:ChangePage(index, self.uniqueId)
			end
        end
        )
    end

    local syetemLock = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerNatural)
    self[PageIndex.Natural .."Mask"]:SetActive(not syetemLock)
    self[PageIndex.Natural .."Mask_btn"].onClick:AddListener(function ()
        local isPass, desc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerNatural)
        if not isPass then
            MsgBoxManager.Instance:ShowTips(desc)
        end
    end)

    --self.BGButton_btn.onClick:AddListener(self:ToFunc("OnClick_BGButton"))
end

function CommonPartnerInfo:OnCache()
    TableUtils.ClearTable(self.cacheMap)
    TableUtils.ClearTable(self.objectMap)
    TableUtils.ClearTable(self.talentNodes)
    self.curPage = nil
    Fight.Instance.objectPool:Cache(CommonPartnerInfo, self)
end

function CommonPartnerInfo:__cache()
    
end

function CommonPartnerInfo:UpdateShow(uniqueId)
    ---更新佩从数据
    if uniqueId ~= 0 then
        self.uniqueId = uniqueId
        self:ShowUpdateTip(uniqueId)
        self:ChangePage(self.curPage or PageIndex.Attr, uniqueId)
    end
end

function CommonPartnerInfo:ShowUpdateTip(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    local talentId = baseConfig.talent
    local talentConfig = RoleConfig.GetPartnerTalentConfig(talentId)
    SingleIconLoader.Load(self.Talent, talentConfig.icon)

    local qualityConfig = RoleConfig.GetPartnerSkillTypeConfig(baseConfig.skill_type)
    SingleIconLoader.Load(self.SkillTypeBg, qualityConfig.bg)
    SingleIconLoader.Load(self.SkillTypeIcon, qualityConfig.icon)

    local qualityData = ItemManager.GetItemColorData(baseConfig.quality)
    SingleIconLoader.Load(self.QualityLine, AssetConfig.GetQualityIcon(qualityData.front))
    SingleIconLoader.Load(self.QualityBack, AssetConfig.GetQualityIcon(qualityData.tipsFront))

    self.ItemName_txt.text = baseConfig.name
    SingleIconLoader.Load(self.ItemIcon, baseConfig.head_icon)

    self.CurLevel_txt.text = partnerData.lev
    self.MaxLevel_txt.text = RoleConfig.PartnerMaxLev

    self.Equiped:SetActive(partnerData.hero_id ~= 0)
    if partnerData.hero_id ~= 0 then
        self.EquipedTips_txt.text = RoleConfig.GetRoleConfig(partnerData.hero_id).name .. TI18N("已装备")
        local icon = RoleConfig.GetRoleConfig(partnerData.hero_id).rhead_icon
        SingleIconLoader.Load(self.Belong, icon)
    end
    -- self.Name_txt.text = baseConfig.name
    -- self.CurLevel_txt.text = partnerData.lev
    -- self.LevelLimit_txt.text = RoleConfig.PartnerMaxLev
    -- self.Locked:SetActive(partnerData.is_locked or false)
    -- self.QualityDesc_txt.text = qualityConfig.name
    -- SingleIconLoader.Load(self.QualityBg, qualityConfig.icon)

end

function CommonPartnerInfo:ChangePage(index, uniqueId)
    self:ChangeToggle(index)
    if self.curPage then
        self[self.curPage .."Page"]:SetActive(false)
        UtilsUI.SetTextColor(self[self.curPage .."Text_txt"], "#757C86")
    end
    if self.curPage and self.curPage ~= index then
        --self:OnClick_BGButton()
    end
    self.curPage = index
    UtilsUI.SetTextColor(self[index.."Text_txt"], "#FFFFFF")
    self[index.."Page"]:SetActive(true)
    if index == PageIndex.Attr then
        self:ShowAttrPage(uniqueId)
    elseif index == PageIndex.Skill then
        self:ShowSkillPage(uniqueId)
    elseif index == PageIndex.Natural then
        self:ShowNaturalPage(uniqueId)
    end
end

function CommonPartnerInfo:ShowAttrPage(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = RoleConfig.GetPartnerConfig(partnerId)

    local attrTable = UtilsBase.copytab(partnerData.property_list) or {}
    local showCount = #attrTable
    showCount = math.min(showCount, 4)

    for i = 1, #attrTable, 1 do
        attrTable[i].priority = RoleConfig.GetAttrPriority(attrTable[i].key)
    end

    table.sort(attrTable, function (a, b)
        return a.priority > b.priority
    end)

    for i = 1, showCount, 1 do
        local attr = attrTable[i]
        local attrValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr.key, attr.value)
        self["Attribute"..i]:SetActive(true)
        self:ShowAttr(i, attr.key, attr.value, attrValue)
    end
    for i = showCount + 1, 4, 1 do
        self["Attribute"..i]:SetActive(false)
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
        local skill =  RoleConfig.GetPartnerSkillConfig(skills[i])
        if skillCount > 2 then
            break
        end
        self["Talent"..skillCount.."_btn"].onClick:RemoveAllListeners()
        self["Talent"..skillCount.."_btn"].onClick:AddListener(function ()
            local callBack = function ()
                --self.BGButton:SetActive(true)
            end
            local panel = PanelManager.Instance:GetPanel(PartnerSkillInfoPanel)
            if panel then
                panel:ChangeSkill(partnerId, self.uniqueId, skills[i], i)
            else
                PanelManager.Instance:OpenPanel(PartnerSkillInfoPanel,{template_id = partnerId, uniqueId = self.uniqueId, skillId = skills[i],index = i, callBack = callBack})
            end
        end)
        self["Talent"..skillCount]:SetActive(true)
        self["Talent"..skillCount.."Null"]:SetActive(false)
        local node = self:GetTalentSkill(skillCount)
        node.TalentName_txt.text = skill.name
        SingleIconLoader.Load(node.TalentIcon, skill.icon)
        local curLev = mod.BagCtrl:GetPartnerSkillLevel(uniqueId, skill.id) or 0
        local maxLev = RoleConfig.GetPartnerSkillMaxLev(partnerId)
        node.Level_txt.text = string.format("%s/%s", curLev, maxLev)
        skillCount = skillCount + 1
    end
    for i = skillCount, 2, 1 do
        self["Talent"..i]:SetActive(false)
        self["Talent"..i.."Null"]:SetActive(true)
    end
end

function  CommonPartnerInfo:ChangeToggle(index)
    if self.curPage == index then return end
    for _, v in pairs(PageIndex) do
        self[v.."Select"]:SetActive(false)
    end
    self[index.."Select"]:SetActive(true)
end

function CommonPartnerInfo:GetTalentSkill(index)
    self.talentNodes = self.talentNodes or {}
    if self.talentNodes[index] then
        return self.talentNodes[index]
    end
    local node = {}
    UtilsUI.GetContainerObject(self["Talent"..index.."_rect"], node)
    self.talentNodes[index] = node
	return node
end

function CommonPartnerInfo:ShowAttr(index, attrType, value, attrValue)
    local rank, icon = RoleConfig.GetPartnerAttrRank(attrType, value)
    local name, showValue = RoleConfig.GetShowAttr(attrType, attrValue)
    SingleIconLoader.Load(self["AttributeRank"..index], icon)
    self["AttributeDesc"..index .."_txt"].text = name
    self["AttributeValue"..index .."_txt"].text = showValue
end

function CommonPartnerInfo:ShowSkillPage(uniqueId)
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
    -- local lev, count = RoleConfig.GetPartnerNextUnlockSkillCount(partnerData.template_id, partnerData.lev)
    -- if lev then
    --     self.UnLockTip:SetActive(true)
    --     self.UnLockTip_txt.text = string.format(TI18N("升至LV.%s解锁%s个随机战技"), lev, count)
    -- else
    --     self.UnLockTip:SetActive(false)
    -- end

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

function CommonPartnerInfo:ShowNaturalPage(uniqueId)
    
end

function CommonPartnerInfo:ShowSkillObj(skillId, level)
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    local partnerId = partnerData.template_id
    local obj = self:GetTempObj(ObjType.Skill)
    obj.objectTransform:SetParent(self.SkillList_rect)
    obj.objectTransform:ResetAttr()
    obj.LockBg:SetActive(not skillId)
    obj.Select:SetActive(false)
    obj.Content:SetActive(skillId and true)
    if not skillId then
        return
    end
    local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
    obj.Box:SetActive(baseConfig.type == RoleConfig.PartnerSkillType.Specificity)
    obj.Level_txt.text = level
    obj.Select:SetActive(false)
    SingleIconLoader.Load(obj.Icon, baseConfig.icon)
    obj.Icon_btn.onClick:RemoveAllListeners()
    obj.Icon_btn.onClick:AddListener(function ()
        if self.curSkillObj then
            self.curSkillObj.Select:SetActive(false)
        end
        obj.Select:SetActive(true)
        self.curSkillObj = obj
        local callBack = function ()
            --self.BGButton:SetActive(true)
        end
        local panel = PanelManager.Instance:GetPanel(PartnerSkillInfoPanel)
        if panel then
            panel:ChangeSkill(partnerId, self.uniqueId, skillId)
        else
            PanelManager.Instance:OpenPanel(PartnerSkillInfoPanel,{template_id = partnerId, uniqueId = self.uniqueId, skillId = skillId, callBack = callBack})
        end
    end)
end

function CommonPartnerInfo:GetTempObj(type)
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

function CommonPartnerInfo:CacheObjectByType(type)
    if self.objectMap[type] then
        for key, value in pairs(self.objectMap[type]) do
            self:CacheObject(value, type)
        end
        self.objectMap[type] = {}
    end
end

function CommonPartnerInfo:CacheObject(obj, type)
    obj.objectTransform:SetParent(self.CacheRoot_rect)
    if not self.cacheMap[type] then
        self.cacheMap[type] = {}
    end
    table.insert(self.cacheMap[type], obj)
end

function CommonPartnerInfo:OnClick_BGButton()
    --self.BGButton:SetActive(false)
    PanelManager.Instance:ClosePanel(PartnerSkillInfoPanel)
    if self.curSkillObj then
        self.curSkillObj.Select:SetActive(false)
        self.curSkillObj = nil
    end
end

function CommonPartnerInfo:PopUITmpObject(name)
    local objectInfo = {}
    if self.uiTmpObjCache and self.uiTmpObjCache[name] then
        local objectInfo = self.uiTmpObjCache[name][1]
        if objectInfo then
            table.remove(self.uiTmpObjCache[name], 1)
            objectInfo.object:SetActive(true)

            return objectInfo
        end
    end

    objectInfo.object = GameObject.Instantiate(self[name])
    objectInfo.objectTransform = objectInfo.object.transform
    return objectInfo, true
end