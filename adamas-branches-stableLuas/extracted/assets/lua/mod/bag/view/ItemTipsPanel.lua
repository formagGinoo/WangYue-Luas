ItemTipsPanel = BaseClass("ItemTipsPanel", BasePanel)

function ItemTipsPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Bag/ItemTipsPanel.prefab")

    self.parent = parent
    self.itemInfo = {}
    self.itemConfig = {}
    self.sourceObjList = {}
    self.sourceObjPool = {}
end

function ItemTipsPanel:__BindListener()
    self:SetHideNode("ItemTipsPanel_Exit")
    self:BindCloseBtn(self.BackBtn_btn,self:ToFunc("ClosePanel"))
end

function ItemTipsPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ItemTipsPanel:__Show()
    InputManager.Instance:AddLayerCount("UI")
    self:SetItemInfo(self.args.itemInfo)
    self:UpdateBaseInfo()
    self:UpdateDetailInfo()
end

function ItemTipsPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function ItemTipsPanel:__delete()
    self.itemInfo = {}
    self.itemConfig = {}
    self.sourceObjList = {}


end

function ItemTipsPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
    InputManager.Instance:MinusLayerCount("UI")
end

function ItemTipsPanel:SetItemInfo(itemInfo)
    self.itemInfo = itemInfo
    self.itemConfig = ItemConfig.GetItemConfig(itemInfo.template_id)
end

function ItemTipsPanel:UpdateBaseInfo()
    local itemConfig = self.itemConfig
    local itemInfo = self.itemInfo
    local itemType = ItemConfig.GetItemType(itemInfo.template_id)
    -- 设置Quality
    -- local qualityData = ItemManager.GetItemColorData(itemConfig.quality)
    -- SingleIconLoader.Load(self.QualityBack, AssetConfig.GetQualityIcon(qualityData.tipsFront))
    for i = 1, 5, 1 do
        UtilsUI.SetActive(self["QualityBack".. i], i == itemConfig.quality)
    end

    -- 设置Icon
    local path
    if itemType == BagEnum.BagType.Role then
        path = self.itemConfig.chead_icon
    elseif itemType == BagEnum.BagType.Partner then
        path = self.itemConfig.chead_icon
    else
        path = ItemConfig.GetItemIcon(itemInfo.template_id)
    end
    SingleIconLoader.Load(self.ItemIcon, path)

    -- 设置名字
    self.ItemName_txt.text = itemConfig.name

    -- 设置状态Icon
    self:UpdateStateIcon()

    -- 设置基础信息或者类别
    self.Weapon:SetActive(itemType == BagEnum.BagType.Weapon)
    self.TypeName:SetActive(itemType ~= BagEnum.BagType.Weapon)
    self.Partner:SetActive(itemType == BagEnum.BagType.Partner)
    if itemType == BagEnum.BagType.Weapon then
        self.NoAttr:SetActive(false)
        self.LevelInfo:SetActive(true)
        SingleIconLoader.Load(self.Stage, "Textures/Icon/Single/StageIcon/" .. (itemInfo.stage or 0) .. ".png")
        self.WeaponTypeName_txt.text = RoleConfig.GetWeaponTypeConfig(itemConfig.type).type_name
        self.CurLevel_txt.text = itemInfo.lev or 1
        self.MaxLevel_txt.text = RoleConfig.GetStageConfig(itemInfo.template_id, itemInfo.stage or 0).level_limit
    elseif itemType == BagEnum.BagType.Role then
        self.NoAttr:SetActive(true)
        self.LevelInfo:SetActive(false)
        --local roleConfig = RoleConfig.GetRoleConfig(itemInfo.template_id)
        self.TypeName_txt.text = TI18N("脉者")
    elseif itemType == BagEnum.BagType.Partner then
        self.NoAttr:SetActive(true)
        self.LevelInfo:SetActive(true)
        self.TypeName_txt.text = TI18N("月灵")
        -- TODO 临时处理 后续需要跟随培养系统修改
        self.CurLevel_txt.text = itemInfo.lev or 1
        self.MaxLevel_txt.text = RoleConfig.GetPartnerMaxLevByPartnerId(itemInfo.template_id)
    else
        self.NoAttr:SetActive(true)
        self.LevelInfo:SetActive(false)
        local typeConfig = ItemConfig.GetItemTypeConfig(itemConfig.type)
        self.TypeName_txt.text = typeConfig.type_name
    end
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.LevelInfo.transform)
end

function ItemTipsPanel:UpdateStateIcon()
    self:UpdateYingYangIcon()
    self:UpdateAdditionIcon()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.StateIcon.transform)
end

function ItemTipsPanel:UpdateYingYangIcon()
    local yinyangIcon = self.itemConfig.yinyang_icon
    if yinyangIcon == "" or not yinyangIcon then
        if self.YingYangIcon then
            self.YingYangIcon:SetActive(false)
        end
        return
	end
	self.YingYangIcon:SetActive(true)
	SingleIconLoader.Load(self.YingYangIcon, yinyangIcon)
end

function ItemTipsPanel:UpdateAdditionIcon()
    local additionIcon = self.itemConfig.add_icon
    if additionIcon == "" or not additionIcon then
        if self.AdditionIcon then
            self.AdditionIcon:SetActive(false)
        end
        return
	end
	self.AdditionIcon:SetActive(true)
	SingleIconLoader.Load(self.AdditionIcon, additionIcon)
end

function ItemTipsPanel:UpdateDetailInfo()
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
        self.RefineName_txt.text = string.format(TI18N("精炼%s阶"), itemInfo.refine or 1)
    end

    -- 月灵
    self.Node_Partner:SetActive(itemType == BagEnum.BagType.Partner)
    if itemType == BagEnum.BagType.Partner then
        local skillList = RoleConfig.GetPartnerSkillList(itemInfo.template_id)
        self:PushAllUITmpObject("SkillItem", self.SkillItemCache_rect)
        for i, skillId in ipairs(skillList) do
            --- 初始化月灵天赋item
            local objectInfo = self:PopUITmpObject("SkillItem", self.SkillContent_rect)
            UtilsUI.GetContainerObject(objectInfo.object, objectInfo)
            UtilsUI.SetActive(objectInfo.object, true)
            objectInfo.Button_btn.onClick:RemoveAllListeners()
            if skillId then -- 已解锁
                local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
                SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon)
                UtilsUI.SetActive(objectInfo.SkillIcon, true)
                objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
                UtilsUI.SetActive(objectInfo.Quality, true)
                UtilsUI.SetActive(objectInfo.NoSkill, false)
                UtilsUI.SetActive(objectInfo.Back, true)
                UtilsUI.SetActive(objectInfo.Null, false)
                UtilsUI.SetActive(objectInfo.TalentSkillIcon, false)
                objectInfo.Button_btn.onClick:AddListener(function()
                    PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                        uid = self.uid,
                        skillId = skillId,
                        showBtn = true,
                        objList = {
                            objectInfo.object,
                        },
                    })
                end)
            end
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
        self.SubDesc_txt.text = ""
    elseif itemType == BagEnum.BagType.Partner then
        self.Node_Desc:SetActive(itemConfig.desc ~= nil and itemConfig.desc ~= "")
        self.MainDesc_txt.text = itemConfig.desc
        self.SubDesc_txt.text = ""
    end
    --装备者
    if itemInfo.hero_id and itemInfo.hero_id ~= 0 then
        self.Equiped:SetActive(true)
        self.EquipedTips_txt.text = string.format(TI18N("%s已装备"), RoleConfig.GetRoleConfig(itemInfo.hero_id).name)
        local icon = RoleConfig.GetRoleConfig(itemInfo.hero_id).rhead_icon
        SingleIconLoader.Load(self.Belong, icon)
    else
        self.Equiped:SetActive(false)
    end

    for i = #self.sourceObjList, 1, -1 do
        self.sourceObjList[i].object:SetActive(false)
        table.insert(self.sourceObjPool, table.remove(self.sourceObjList))
    end
    self.Node_Source:SetActive(itemConfig.jump_ids and next(itemConfig.jump_ids))
    if itemConfig.jump_ids and next(itemConfig.jump_ids) then
        for i = 1, #itemConfig.jump_ids do
			local sourceObj = self:GetSourceObj()

			local jumpId = itemConfig.jump_ids[i]
			local title = JumpToConfig.GetTitle(jumpId)
			sourceObj.USourceDesc_txt.text = title
			sourceObj.ASourceDesc_txt.text = title
            sourceObj.SingleSource_btn.onClick:RemoveAllListeners()
            if not JumpToConfig.HasJumpEvent(jumpId) then 
			    sourceObj.ASource:SetActive(true)
			    sourceObj.USource:SetActive(false)
            else
                sourceObj.ASource:SetActive(false)
			    sourceObj.USource:SetActive(true)
                local onclickFunc = function()
					self:OnClick_Source(jumpId)
                    ItemManager.Instance:CloseItemTipsPanel()
                    PanelManager.Instance:ClosePanel(self)
				end
				sourceObj.SingleSource_btn.onClick:AddListener(onclickFunc)
            end

			sourceObj.object:SetActive(true)

            self.sourceObjList[i] = sourceObj
        end
    end

    --#region 测试逻辑 延迟修改Tips大小
    local delayFunc = function()
        local detailHeight = Mathf.Clamp(self.TipsDContent_rect.rect.height, 285, 415)
        UnityUtils.SetSizeDelata(self.TipsDetail.transform, self.TipsDetail_rect.rect.width, detailHeight)
        UnityUtils.SetSizeDelata(self.QualityBack.transform, self.TipsDetail_rect.rect.width , detailHeight + 324)
    end

    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
    self.testTimer = LuaTimerManager.Instance:AddTimer(5, 0.03, delayFunc)
    --#endregion

    -- Node_Decorations 分两种状态 灰色色号7b7b7b 激活绿色色号007d53
end

function ItemTipsPanel:GetSourceObj()
    if next(self.sourceObjPool) then
        return table.remove(self.sourceObjPool)
    end

    local sourceObj = self:PopUITmpObject("SingleSource")
    sourceObj.objectTransform:SetParent(self.Node_Source.transform)
    UtilsUI.GetContainerObject(sourceObj.objectTransform, sourceObj)
    UnityUtils.SetLocalScale(sourceObj.objectTransform, 1, 1, 1)

    return sourceObj
end

function ItemTipsPanel:GetTalentSkill(index)
    self.talentNodes = self.talentNodes or {}
    if self.talentNodes[index] then
        return self.talentNodes[index]
    end
    local node = {}
    UtilsUI.GetContainerObject(self["Talent"..index.."_rect"], node)
    self.talentNodes[index] = node
    return node
end

function ItemTipsPanel:OnClick_Source(jumpId)
    if not Fight.Instance then
        return
    end

    JumpToConfig.DoJump(jumpId)
end

function ItemTipsPanel:OnClick_Back()
    self.ItemTipsPanel_Exit:SetActive(true)
end

function ItemTipsPanel:ClosePanel()
    ItemManager.Instance:CloseItemTipsPanel()
    PanelManager.Instance:ClosePanel(self)
end
