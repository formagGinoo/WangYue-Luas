CommonItemTip = BaseClass("CommonItemTip",Module)


function CommonItemTip:__init(gameObject)
    UtilsUI.GetContainerObject(gameObject.transform, self)
    self.sourceObjList = {}
    self.sourceObjPool = {}
end

function CommonItemTip:__delete()
    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
end

function CommonItemTip:SetItemInfo(itemInfo)
    self.itemInfo = itemInfo
    self.itemConfig = ItemConfig.GetItemConfig(itemInfo.template_id)
    self:UpdateBaseInfo()
    self:UpdateDetailInfo()
end


function CommonItemTip:UpdateBaseInfo()
    local itemConfig = self.itemConfig
    local itemInfo = self.itemInfo
    local itemType = ItemConfig.GetItemType(itemInfo.template_id)
    -- 设置Quality
    local qualityData = ItemManager.GetItemColorData(itemConfig.quality)
    SingleIconLoader.Load(self.QualityLine, AssetConfig.GetQualityIcon(qualityData.front))
    SingleIconLoader.Load(self.QualityBack, AssetConfig.GetQualityIcon(qualityData.tipsFront))

    -- 设置Icon
    local path
    UnityUtils.SetSizeDelata(self.ItemIcon_rect, 189, 189)
    if itemType == BagEnum.BagType.Role then
        path = self.itemConfig.head_icon
        UnityUtils.SetSizeDelata(self.ItemIcon_rect, 180, 212)
    elseif itemType == BagEnum.BagType.Partner then
        path = self.itemConfig.head_icon
    else
        path = ItemConfig.GetItemIcon(itemInfo.template_id)
    end
    SingleIconLoader.Load(self.ItemIcon, path)

    -- 设置名字
    self.ItemName_txt.text = itemConfig.name

    -- 设置基础信息或者类别
    self.Weapon:SetActive(itemType == BagEnum.BagType.Weapon)
    self.TypeName:SetActive(itemType ~= BagEnum.BagType.Weapon)
    self.Partner:SetActive(itemType == BagEnum.BagType.Partner)
    if itemType == BagEnum.BagType.Weapon then
        self.HaveAttr:SetActive(false)
        self.NoAttr:SetActive(false)
        self.LevelInfo:SetActive(true)
        SingleIconLoader.Load(self.Stage, "Textures/Icon/Single/StageIcon/" .. (itemInfo.stage or 0) .. ".png")
        self.WeaponTypeName_txt.text = RoleConfig.GetWeaponTypeConfig(itemConfig.type).type_name
        self.CurLevel_txt.text = itemInfo.lev or 1
        self.MaxLevel_txt.text = RoleConfig.GetStageConfig(itemInfo.template_id, itemInfo.stage or 0).level_limit
    elseif itemType == BagEnum.BagType.Role then
        self.HaveAttr:SetActive(false)
        self.NoAttr:SetActive(true)
        self.LevelInfo:SetActive(false)
        --local roleConfig = RoleConfig.GetRoleConfig(itemInfo.template_id)
        self.TypeName_txt.text = TI18N("脉者")
    elseif itemType == BagEnum.BagType.Partner then
        self.HaveAttr:SetActive(false)
        self.NoAttr:SetActive(true)
        self.LevelInfo:SetActive(true)
        local partnerTalentConfig = RoleConfig.GetPartnerTalentConfig(itemConfig.talent)
        SingleIconLoader.Load(self.PartnerTalent, partnerTalentConfig.icon)
        local partnerSkillConfig = RoleConfig.GetPartnerSkillTypeConfig(itemConfig.skill_type)
        SingleIconLoader.Load(self.PartnerSkillTypeBg, partnerSkillConfig.bg)
        SingleIconLoader.Load(self.PartnerSkillTypeIcon, partnerSkillConfig.icon)

        -- TODO 临时处理 后续需要跟随培养系统修改
        self.CurLevel_txt.text = itemInfo.lev or 1
        self.MaxLevel_txt.text = RoleConfig.PartnerMaxLev
    else
        self.HaveAttr:SetActive(false)
        self.NoAttr:SetActive(true)
        self.LevelInfo:SetActive(false)
        local typeConfig = ItemConfig.GetItemTypeConfig(itemConfig.type)
        self.TypeName_txt.text = typeConfig.type_name
    end
end

function CommonItemTip:UpdateDetailInfo()
    local showStrength = false
    local itemInfo = self.itemInfo
    local itemConfig = self.itemConfig
    local itemType = ItemConfig.GetItemType(itemConfig.id)
    local showLock = itemType == BagEnum.BagType.Weapon
    -- TODO 临时处理 后续需要跟随培养系统修改
    self.Node_Grow:SetActive(showLock)
    self.Node_GrowTop:SetActive(showLock or showStrength)
    self.Node_Lock:SetActive(showLock)

    self.Unlock:SetActive(not itemInfo.is_locked and itemInfo.refine)
    self.HaveLock:SetActive(itemInfo.is_locked)

    -- 武器属性
    self.Node_Refine:SetActive(itemType == BagEnum.BagType.Weapon)
    self.Node_Attr:SetActive(itemType == BagEnum.BagType.Weapon)
    if itemType == BagEnum.BagType.Weapon then
        local attrTable = RoleConfig.GetWeaponBaseAttrs(itemInfo.template_id, itemInfo.lev or 1, itemInfo.stage or 0)
        local curCount = 0
        for key, value in pairs(attrTable) do
            curCount = curCount + 1
            if curCount > 2 then
                curCount = curCount - 1
                break
            end
            self["Attr" .. curCount]:SetActive(true)
            SingleIconLoader.Load(self["AttrIcon" .. curCount], RoleConfig.GetAttrConfig(key).icon)
            self["AttrName" .. curCount .. "_txt"].text = RoleConfig.GetAttrConfig(key).name
            if RoleConfig.GetAttrConfig(key).value_type == FightEnum.AttrValueType.Percent then
                value = value / 100 .. "%"
            end
            self["AttrValue" .. curCount .. "_txt"].text = value
        end
        for i = curCount + 1, 2, 1 do
            self["Attr" .. i]:SetActive(false)
        end

        -- 培养线没有出来之前暂时先只显示描述和来源
        -- 精炼信息
        self.RefineLvl_txt.text = itemInfo.refine or 1
        self.RefineName_txt.text = string.format("精炼%s阶", itemInfo.refine or 1)
    end

    -- 佩从天赋
    self.Node_Partner:SetActive(itemType == BagEnum.BagType.Partner)
    if itemType == BagEnum.BagType.Partner then
        local talentConfig = RoleConfig.GetPartnerTalentConfig(itemConfig.talent)
        self.TalentType_txt.text = talentConfig.name
        SingleIconLoader.Load(self.TalentIcon, talentConfig.icon)

        --职业技能
        local skills = RoleConfig.GetPartnerTalentSkill(itemConfig.id)
        local skillCount = 1
        for i = 1, #skills, 1 do
            local skill =  RoleConfig.GetPartnerSkillConfig(skills[i])
            if skillCount > 2 then
                break
            end
            self["Talent"..skillCount.."_btn"].onClick:RemoveAllListeners()
            self["Talent"..skillCount.."_btn"].onClick:AddListener(function ()
                local panel = PanelManager.Instance:GetPanel(PartnerSkillInfoPanel)
                if panel then
                    panel:ChangeSkill(itemConfig.id, nil, skills[i], i)
                else
                    PanelManager.Instance:OpenPanel(PartnerSkillInfoPanel,{template_id = itemConfig.id, skillId = skills[i], index = i})
                end
            end)

            self["Talent"..skillCount]:SetActive(true)
            self["Talent"..skillCount.."Null"]:SetActive(false)
            local node = self:GetTalentSkill(skillCount)

            node.TalentName_txt.text = skill.name
            SingleIconLoader.Load(node.TalentIcon, skill.icon)
            local curLev = 1
            local maxLev = RoleConfig.GetPartnerSkillMaxLev(itemConfig.id)
            node.Level_txt.text = string.format("%s/%s", curLev, maxLev)
            skillCount = skillCount + 1
        end
        for i = skillCount, 2, 1 do
            self["Talent"..i]:SetActive(false)
            self["Talent"..i.."Null"]:SetActive(true)
        end
    end

    -- 显示描述
    if itemType == BagEnum.BagType.Item or itemType == BagEnum.BagType.Currency then
        self.Node_Desc:SetActive(itemConfig.desc ~= nil and itemConfig.desc ~= "")
        self.MainDesc_txt.text = itemConfig.desc
        --TODO 暂时没有内容
        self.SubDesc_txt.text = ""
    elseif itemType == BagEnum.BagType.Weapon then
        local refineConfig = RoleConfig.GetWeaponRefineConfig(itemInfo.template_id, itemInfo.refine or 1)
        self.Node_Desc:SetActive(true)
        if not refineConfig then
            self.MainDesc_txt.text = ""
        else
            self.MainDesc_txt.text = refineConfig.desc
        end
        self.SubDesc_txt.text = itemConfig.desc
    elseif itemType == BagEnum.BagType.Role then
        self.Node_Desc:SetActive(itemConfig.detail_desc ~= nil and itemConfig.detail_desc ~= "")
        self.MainDesc_txt.text = itemConfig.detail_desc
    elseif itemType == BagEnum.BagType.Partner then
        self.Node_Desc:SetActive(itemConfig.desc ~= nil and itemConfig.desc ~= "")
        self.MainDesc_txt.text = itemConfig.desc
    end

    --装备者
    if itemInfo.hero_id and itemInfo.hero_id ~= 0 then
        self.Equiped:SetActive(true)
        self.EquipedTips_txt.text = RoleConfig.GetRoleConfig(itemInfo.hero_id).name .. TI18N("已装备")
        local icon = RoleConfig.GetRoleConfig(itemInfo.hero_id).rhead_icon
        SingleIconLoader.Load(self.Belong, icon)
    else
        self.Equiped:SetActive(false)
    end

    for i = #self.sourceObjList, 1, -1 do
        self.sourceObjList[i].object:SetActive(false)
        table.insert(self.sourceObjPool, table.remove(self.sourceObjList))
    end
    self.Node_Source:SetActive(itemConfig.gain_way and next(itemConfig.gain_way))
    if itemConfig.gain_way and next(itemConfig.gain_way) then
        for i = 1, #itemConfig.gain_way do
			local sourceObj = self:GetSourceObj()

			local jumpId = itemConfig.jump_ids[i]
			local title = JumpToConfig.GetTitle(jumpId)
			sourceObj.USourceDesc_txt.text = title
			sourceObj.ASourceDesc_txt.text = title

			--#region 测试逻辑
			sourceObj.ASource:SetActive(true)
			sourceObj.USource:SetActive(false)
			--#endregion

			if JumpToConfig.HasJumpEvent(jumpId) then
				local onclickFunc = function()
					self:OnClick_Source(jumpId)
				end
				sourceObj.SingleSource_btn.onClick:RemoveAllListeners()
				sourceObj.SingleSource_btn.onClick:AddListener(onclickFunc)
			end
			sourceObj.object:SetActive(true)

            self.sourceObjList[i] = sourceObj
        end
    end

    --#region 测试逻辑 延迟修改Tips大小
    local delayFunc = function()
        local detailHeight = Mathf.Clamp(self.TipsDContent_rect.rect.height, 200, 320)
        UnityUtils.SetSizeDelata(self.TipsDetail.transform, self.TipsDetail_rect.rect.width, detailHeight)
    end

    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
    self.testTimer = LuaTimerManager.Instance:AddTimer(5, 0.03, delayFunc)
    --#endregion

    -- Node_Decorations 分两种状态 灰色色号7b7b7b 激活绿色色号007d53
end

function CommonItemTip:ReSetInfo()
    UtilsUI.SetActive(self.LevelInfo,false)
    UtilsUI.SetActive(self.Weapon,false)
    UtilsUI.SetActive(self.Partner,false)
    UtilsUI.SetActive(self.Node_Decorations,false)
    UtilsUI.SetActive(self.Node_Equips,false)
    UtilsUI.SetActive(self.Node_Partner,false)
    UtilsUI.SetActive(self.Node_Desc,false)
    UtilsUI.SetActive(self.Node_Source,false)
    UtilsUI.SetActive(self.Equiped,false)
    self.MainDesc_txt.text = ""
    self.SubDesc_txt.text = ""
    self.TypeName_txt.text = ""
end

function CommonItemTip:GetSourceObj()
    if next(self.sourceObjPool) then
        return table.remove(self.sourceObjPool)
    end
    local objectInfo = {}
    objectInfo.object = GameObject.Instantiate(self.SingleSource)
    objectInfo.objectTransform = objectInfo.object.transform
    objectInfo.objectTransform:SetParent(self.Node_Source.transform)
    UtilsUI.GetContainerObject(objectInfo.objectTransform, objectInfo)
    UnityUtils.SetLocalScale(objectInfo.objectTransform, 1, 1, 1)

    return objectInfo
end

function CommonItemTip:GetTalentSkill(index)
    self.talentNodes = self.talentNodes or {}
    if self.talentNodes[index] then
        return self.talentNodes[index]
    end
    local node = {}
    UtilsUI.GetContainerObject(self["Talent"..index.."_rect"], node)
    self.talentNodes[index] = node
    return node
end

function CommonItemTip:OnClick_LockItem()
    local itemInfo = self.itemInfo
    local type = ItemConfig.GetItemType(itemInfo.template_id)
    local unique_id = itemInfo.unique_id
    local is_lock = not itemInfo.is_locked
    mod.BagCtrl:SetItemLockState(unique_id, is_lock, type)
end

function CommonItemTip:OnClick_Source(jumpId)
    if Fight.Instance then
        return
    end

    JumpToConfig.DoJump(jumpId)
end

