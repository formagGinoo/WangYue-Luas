UseCureItemPanel = BaseClass("UseCureItemPanel", BasePanel)

local UseItemType = {
    [1033] = "CureItem",
    [1034] = "ReviveItem",
}

local LIFEBAR_DEFAULT = 102

function UseCureItemPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Bag/UseCureItemPanel.prefab")

    self.parent = parent
    self.itemConfig = nil
    self.entity = nil
    self.ingoreError = false
    self.maxCount = 0
    self.useCount = 0

    self.blurBack = nil
    self.roleOnShow = {}

    -- check Function
    self.checkFuncs = {}
    self.checkFuncs.CureItem = self.ItemCheck_CureItem
    self.checkFuncs.ReviveItem = self.ItemCheck_ReviveItem
end

function UseCureItemPanel:__BindEvent()

end

function UseCureItemPanel:__BindListener()
    self:SetHideNode("CommonTipPart_Exit")
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("ClosePanel"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("ClosePanel"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("ClosePanel"))
    
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmUse"))
    self.MaxBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MaxCount"))
    self.MinBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MinCount"))
    self.MinusBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MinusCount"))
    self.PlusBtn_btn.onClick:AddListener(self:ToFunc("OnClick_PlusCount"))

    EventMgr.Instance:AddListener(EventName.ItemUse, self:ToFunc("OnRecv_ItemUse"))
end

function UseCureItemPanel:__Show()
    self.player = Fight.Instance.playerManager:GetPlayer()
    self.entity = self.player:GetQTEEntityObject(1)
    self.itemConfig = ItemConfig.GetItemConfig(self.args.template_id)
    self.useCount = 1
    self.maxCount = 1
    self.ingoreError = true

    self:RefreshItemInfo()
    self:UpdateInfo()
    self:RefreshRoleInfo(true)
end

function UseCureItemPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    self:SetActive(false)

    local func = function()
        self.blurBack:Show()
    end

    local guideType = Fight.Instance.clientFight.guideManager:GetGuidingType()
    if guideType == FightEnum.GuidingType.Guiding then
        self.guideTimer = LuaTimerManager.Instance:AddTimer(1, 0.1, func)
    else
        func()
    end
end

function UseCureItemPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end

    if self.guideTimer then
        LuaTimerManager.Instance:RemoveTimer(self.guideTimer)
        self.guideTimer = nil
    end
end

function UseCureItemPanel:__delete()
    if self.blurBack then
        self.blurBack:Destroy()
    end

    if self.guideTimer then
        LuaTimerManager.Instance:RemoveTimer(self.guideTimer)
        self.guideTimer = nil
    end

    EventMgr.Instance:RemoveListener(EventName.ItemUse, self:ToFunc("OnRecv_ItemUse"))
end

function UseCureItemPanel:RefreshRoleInfo(firstShow, afterCure)
    local formation = mod.FormationCtrl:GetCurFormationInfo()
    local roleList = formation.roleList
    for i = 1, 3 do
        local haveRole = roleList[i]
        local roleObj = self:GetRoleObj(i)
        self.roleOnShow[i] = roleObj
        roleObj.Empty:SetActive(not haveRole)
        roleObj.Role:SetActive(haveRole)
        if haveRole then
            local entity = self.player:GetQTEEntityObject(i)
            local curLife = entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life)
            local maxLife = entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
			local roleData = mod.RoleCtrl:GetRoleData(roleList[i])
            roleObj.Lvl_txt.text = string.format("Lv.%s", roleData.lev)
            roleObj.DownFlag:SetActive(entity.stateComponent:IsState(FightEnum.EntityState.Death))
            UnityUtils.SetSizeDelata(roleObj.LeftLife.transform, math.min(1, (curLife / maxLife)) * LIFEBAR_DEFAULT, 11)

            if firstShow then
                local icon = Config.DataHeroMain.Find[roleData.id].rhead_icon
                SingleIconLoader.Load(roleObj.RoleIcon, icon)

                local togFunc = function (isOn)
                    self:OnToggle_Role(i, isOn)
                end
                roleObj.Role_tog.onValueChanged:RemoveAllListeners()
                roleObj.Role_tog.onValueChanged:AddListener(togFunc)

                local hcb_1 = function ()
                    UnityUtils.SetActive(roleObj.Selected_Loop, true)
                end
                roleObj.Selected_Open_hcb.HideAction:AddListener(hcb_1)

                local hcb_2 = function ()
                    UnityUtils.SetActive(roleObj.Selected_Loop, false)
                end
                roleObj.Selected_hcb.HideAction:AddListener(hcb_2)
            end

            if not self.selectedIndex or self.selectedIndex == i then
                if afterCure then
                    -- roleObj["21036"]:SetActive(false)
                    roleObj["21036"]:SetActive(true)
                end

                if roleObj.Role_tog.isOn then
                    self:OnToggle_Role(i, true)
                else
                    roleObj.Role_tog.isOn = true
                end
            end
        end
    end
end

function UseCureItemPanel:GetRoleObj(index)
    if next(self.roleOnShow) and self.roleOnShow[index] then
        return self.roleOnShow[index]
    end

    local roleObj = self:PopUITmpObject("RoleTemp")
    roleObj.objectTransform:SetParent(self.Left.transform)

    UtilsUI.GetContainerObject(roleObj.objectTransform, roleObj)
    UnityUtils.SetLocalScale(roleObj.objectTransform, 1, 1, 1)
    roleObj.object:SetActive(true)
    UtilsUI.SetEffectSortingOrder(roleObj["21036"], self.canvas.sortingOrder + 1)

    return roleObj
end

function UseCureItemPanel:OnToggle_Role(index, isOn)
    self.roleOnShow[index].Selected:SetActive(isOn)
    UnityUtils.SetActive(self.roleOnShow[index].Selected_Open, true)
    if not isOn then
        return
    end

    local entity = self.player:GetQTEEntityObject(index)
    local roleConfig = Config.DataHeroMain.Find[entity.masterId]
    -- TODO 临时逻辑
    if self.itemConfig.type == 1034 then
        self.maxCount = 1
    elseif self.itemConfig.type == 1033 then
        for i = 1, #self.itemConfig.use_effect do
            local magicConfig = MagicConfig.GetMagic(self.itemConfig.use_effect[i], nil, FightEnum.MagicConfigFormType.Level)
            if magicConfig and magicConfig.Type == FightEnum.MagicType.ChangeAttr and magicConfig.Param.AttrType == EntityAttrsConfig.AttrType.Life then
                local value = magicConfig.Param.AttrValue
                local curLife = entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life)
                local maxLife = entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
                
                self.maxCount = math.ceil((maxLife - curLife) / value)
            end
            break
        end
    end

    self.MinBtn_btn.interactable = self.useCount > 1
    self.MaxBtn_btn.interactable = self.useCount < self.maxCount
    self.PlusBtn_btn.interactable = self.useCount < self.maxCount
    self.MinusBtn_btn.interactable = self.useCount > 1

    self.selectedIndex = index
    self.TitleText_txt.text = roleConfig.name
    self.entity = entity
    self:RefreshItemEffect(true)
end

function UseCureItemPanel:UpdateInfo()
    self.MinBtn_btn.interactable = self.useCount > 1
    self.MaxBtn_btn.interactable = self.useCount < self.maxCount
    self.PlusBtn_btn.interactable = self.useCount < self.maxCount
    self.MinusBtn_btn.interactable = self.useCount > 1

    self.UseCount_txt.text = self.useCount
    self.LeftCount_txt.text = string.format("库存:%s", mod.BagCtrl:GetItemCountById(self.itemConfig.id))
    if not self.ingoreError then
        self:RefreshItemEffect(true)
    end
end

function UseCureItemPanel:RefreshItemInfo()
    local frontImg, backImg = ItemManager.GetItemColorImg(self.itemConfig.quality)
    local backPath = AssetConfig.GetQualityIcon(backImg)
    local icon = ItemConfig.GetItemIcon(self.itemConfig.id)
    SingleIconLoader.Load(self.Icon, icon)
    SingleIconLoader.Load(self.QualityBack, backPath)
end

function UseCureItemPanel:RefreshItemEffect(showError)
    if self.itemConfig.type ~= 1033 and self.itemConfig.type ~= 1034 then
        return
    end

    local itemType = UseItemType[self.itemConfig.type]
    local isCanUse, errorCode = self.checkFuncs[itemType](self)

    self.Submit:SetActive(isCanUse)
    self.CantUseBtn:SetActive(not isCanUse)
    if not isCanUse and showError and not self.ingoreError then
        MsgBoxManager.Instance:ShowTips(errorCode)
        return
    else
        local showExtraBar = false
        for i = 1, #self.itemConfig.use_effect do
            local magicConfig = MagicConfig.GetMagic(self.itemConfig.use_effect[i], nil, FightEnum.MagicConfigFormType.Level)
            if magicConfig and magicConfig.Type == FightEnum.MagicType.ChangeAttr and magicConfig.Param.AttrType == EntityAttrsConfig.AttrType.Life then
                showExtraBar = true
                local value = magicConfig.Param.AttrValue * self.useCount
                local curLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life)
                local maxLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
                UnityUtils.SetSizeDelata(self.roleOnShow[self.selectedIndex].ExtraLife.transform, math.min(1, ((curLife + value) / maxLife)) * LIFEBAR_DEFAULT, 11)
            end
            break
        end

        for i = 1, #self.roleOnShow do
            self.roleOnShow[i].ExtraLife:SetActive(showExtraBar and i == self.selectedIndex)
        end
    end

    if self.ingoreError then
        self.ingoreError = false
    end
end

function UseCureItemPanel:OnClick_ConfirmUse()
    --使用回复道具测试
    local magicIds = self.itemConfig.use_effect
    if magicIds and next(magicIds) then
        for i = 1, self.useCount do
            for k = 1, #magicIds do
                Fight.Instance.playerManager:GetPlayer():UseItem(self.selectedIndex, magicIds[k])
            end
        end
    end

    MsgBoxManager.Instance:ShowTips("使用道具成功")
    mod.BagCtrl:UseItem({ unique_id = self.args.unique_id, count = self.useCount })
end

function UseCureItemPanel:OnClick_MaxCount()
    local itemType = UseItemType[self.itemConfig.type]
    if not self.checkFuncs[itemType](self) then
        return
    end

    self.useCount = self.maxCount
    self:UpdateInfo()
end

function UseCureItemPanel:OnClick_MinCount()
    local itemType = UseItemType[self.itemConfig.type]
    if not self.checkFuncs[itemType](self) then
        return
    end

    self.useCount = 1
    self:UpdateInfo()
end

function UseCureItemPanel:OnClick_PlusCount()
    if self.useCount >= self.maxCount then
        return
    end

    local itemType = UseItemType[self.itemConfig.type]
    if not self.checkFuncs[itemType](self) then
        return
    end

    self.useCount = self.useCount + 1
    self:UpdateInfo()
end

function UseCureItemPanel:OnClick_MinusCount()
    if self.useCount <= 1 then
        return
    end

    local itemType = UseItemType[self.itemConfig.type]
    if not self.checkFuncs[itemType](self) then
        return
    end

    self.useCount = self.useCount - 1
    self:UpdateInfo()
end

function UseCureItemPanel:OnRecv_ItemUse()
    if not self.active then
        return
    end

    self.ingoreError = true

    self.useCount = 1
    self.maxCount = 1

    self:UpdateInfo()
    self:RefreshRoleInfo(false, true)
end

function UseCureItemPanel:ClosePanel()
    PanelManager.Instance:ClosePanel(self)
end

function UseCureItemPanel:ItemCheck_CureItem()
    if self:IsEntityDeath() then
        return false, "无法对倒下角色使用"
    end

    for i = 1, #self.itemConfig.use_effect do
        local magicConfig = MagicConfig.GetMagic(self.itemConfig.use_effect[i], nil, FightEnum.MagicConfigFormType.Level)
        if magicConfig and magicConfig.Type == FightEnum.MagicType.ChangeAttr and magicConfig.Param.AttrType == EntityAttrsConfig.AttrType.Life then
            local value = magicConfig.Param.AttrValue * self.useCount
            local curLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life)
            local maxLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)

            if (curLife + value - maxLife) >= magicConfig.Param.AttrValue then
                return false, "血量已满"
            end
        else
            break
        end
    end

    return true
end

function UseCureItemPanel:ItemCheck_ReviveItem()
    if not self:IsEntityDeath() then
        return false, "只能对倒下角色使用"
    end

    if self.useCount > 1 then
        return false, "不能使用多个复活道具"
    end

    return true
end

function UseCureItemPanel:IsEntityDeath()
    if not self.entity then
        return false
    end

    return self.entity.stateComponent:IsState(FightEnum.EntityState.Death)
end