UseCureItemPanel = BaseClass("UseCureItemPanel", BasePanel)

local UseItemType = {
    [1033] = "CureItem",
    [1034] = "ReviveItem",
}

local LIFEBAR_DEFAULT = 140

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
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("ClosePanel"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("ClosePanel"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("ClosePanel"))
    -- self.playableDirector = self.UseCureItemPanel_Open:GetComponent(PlayableDirector)
    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmUse"))
    self.MaxBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MaxCount"))
    self.MinBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MinCount"))
    self.MinusBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MinusCount"))
    self.PlusBtn_btn.onClick:AddListener(self:ToFunc("OnClick_PlusCount"))

    EventMgr.Instance:AddListener(EventName.ItemUse, self:ToFunc("OnRecv_ItemUse"))
end

function UseCureItemPanel:__Show()
    self.TitleText_txt.text = TI18N("使用道具")
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


    if self.guideTimer then
        LuaTimerManager.Instance:RemoveTimer(self.guideTimer)
        self.guideTimer = nil
    end

    if self.commonItem then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.commonItem)
        self.commonItem = nil
    end
    

    EventMgr.Instance:RemoveListener(EventName.ItemUse, self:ToFunc("OnRecv_ItemUse"))
end

function UseCureItemPanel:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function UseCureItemPanel:RefreshRoleInfo(firstShow, afterCure)
    local formation = mod.FormationCtrl:GetCurFormationInfo()
    local roleList = formation.roleList
    if firstShow then
        for i = 1, 3, 1 do
            self.roleOnShow[i] = self:GetRoleObj(i)
        end
    end
    for i = 1, 3 do
        local haveRole = roleList[i]
        local roleObj = self.roleOnShow[i]
        roleObj.Empty:SetActive(not haveRole)
        roleObj.Role:SetActive(haveRole)
        if haveRole then
            local entity = self.player:GetQTEEntityObject(i)
            local curLife = entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life)
            local maxLife = entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
			local roleData = mod.RoleCtrl:GetRoleData(roleList[i])
            local roleConfig = ItemConfig.GetItemConfig(roleData.id)
            roleObj.Lvl_txt.text = roleData.lev
            roleObj.RoleName_txt.text = roleConfig.name
            roleObj.DownFlag:SetActive(entity.stateComponent:IsState(FightEnum.EntityState.Death))

            local frontImg, backImg, frontImg, frontImg2,backImg2 = ItemManager.GetItemColorImg(roleConfig.quality)
            if not frontImg or not backImg then
                return
            end
            local backPath = AssetConfig.GetQualityIcon(backImg)
            local back2Path = AssetConfig.GetQualityIcon(backImg2)
            SingleIconLoader.Load(roleObj.QualityBack, backPath)
            SingleIconLoader.Load(roleObj.QualityBack2, back2Path)

            local frontPath = AssetConfig.GetQualityIcon(frontImg)
            local frontPath2 = AssetConfig.GetQualityIcon(frontImg2)
            SingleIconLoader.Load(roleObj.QualityFront, frontPath)
            SingleIconLoader.Load(roleObj.QualityFront2, frontPath2)

            SingleIconLoader.Load(roleObj.ElementIcon, RoleConfig.GetAElementIcon(roleConfig.element))

            UnityUtils.SetSizeDelata(roleObj.LeftLife.transform, math.min(1, (curLife / maxLife)) * LIFEBAR_DEFAULT, 11)

            if firstShow then
                local icon = Config.DataHeroMain.Find[roleData.id].rhead_icon
                SingleIconLoader.Load(roleObj.RoleIcon, icon)

                local togFunc = function (isOn)
                    self:OnToggle_Role(i, isOn)
                end
                roleObj.Role_tog.onValueChanged:RemoveAllListeners()
                roleObj.Role_tog.onValueChanged:AddListener(togFunc)
            end

            if not self.selectedIndex or self.selectedIndex == i then
                if afterCure then
                    roleObj["UI_UseCureItemPanel_huixue"]:SetActive(true)
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
    UtilsUI.SetEffectSortingOrder(roleObj["UI_UseCureItemPanel_huixue"], self.canvas.sortingOrder + 1)

    return roleObj
end

function UseCureItemPanel:OnToggle_Role(index, isOn)
    if self.selectedIndex then
        self.roleOnShow[self.selectedIndex].Selected:SetActive(false)
    end
    
    self.roleOnShow[index].Selected:SetActive(true)
    UnityUtils.SetActive(self.roleOnShow[index].Selected_Open, true)
    -- if not isOn then
    --     return
    -- end

    local entity = self.player:GetQTEEntityObject(index)
    local roleConfig = Config.DataHeroMain.Find[entity.masterId]
    local lev = self.itemConfig.property1 or 0
    lev = math.max(lev, 1)
    -- TODO 临时逻辑
    if self.itemConfig.type == 1034 then
        self.maxCount = 1
    elseif self.itemConfig.type == 1033 then
        for i = 1, #self.itemConfig.use_effect do
            local magicConfig = MagicConfig.GetMagic(self.itemConfig.use_effect[i], nil, FightEnum.MagicConfigFormType.Level)
            if magicConfig and magicConfig.Type == FightEnum.MagicType.DoCure then
                local magicType = FightEnum.MagicFuncName[magicConfig.Type]
                local param = MagicManager.GetMagicParam(magicType, magicConfig, lev)
                local value = param.SkillAdditionParam
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
    -- self.TitleText_txt.text = roleConfig.name
    self.entity = entity
    self:RefreshItemEffect(true)
end

function UseCureItemPanel:UpdateInfo()
    self.MinBtn_btn.interactable = self.useCount > 1
    self.MaxBtn_btn.interactable = self.useCount < self.maxCount
    self.PlusBtn_btn.interactable = self.useCount < self.maxCount
    self.MinusBtn_btn.interactable = self.useCount > 1

    self.UseCount_txt.text = self.useCount
    self.LeftCount_txt.text = string.format(TI18N("库存:%s"), mod.BagCtrl:GetItemCountById(self.itemConfig.id))
    if not self.ingoreError then
        self:RefreshItemEffect(true)
    end
end

function UseCureItemPanel:RefreshItemInfo()
    self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") --CommonItem.New()
    if not self.commonItem then
        self.commonItem = CommonItem.New()
    end 
    self.commonItem:InitItem(self.UseItem, self.itemConfig, true,2)
end

function UseCureItemPanel:RefreshItemEffect(showError)
    if self.itemConfig.type ~= 1033 and self.itemConfig.type ~= 1034 then
        return
    end

    local itemType = UseItemType[self.itemConfig.type]
    local isCanUse, errorCode = self.checkFuncs[itemType](self)

    self.Submit:SetActive(isCanUse)
    self.CantUseBtn:SetActive(not isCanUse)
    local lev = self.itemConfig.property1 or 0
    lev = math.max(lev, 1)
    if not isCanUse and showError and not self.ingoreError then
        MsgBoxManager.Instance:ShowTips(errorCode)
        --return
    end
        local showExtraBar = false
        for i = 1, #self.itemConfig.use_effect do
            local magicConfig = MagicConfig.GetMagic(self.itemConfig.use_effect[i], nil, FightEnum.MagicConfigFormType.Level)
            if magicConfig and magicConfig.Type == FightEnum.MagicType.DoCure then
                showExtraBar = true
                local magicType = FightEnum.MagicFuncName[magicConfig.Type]
                local param = MagicManager.GetMagicParam(magicType, magicConfig, lev)
                local value = self:GetCureValue(param) * (self.useCount or 1)
                local curLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life)
                local maxLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
                self.roleOnShow[self.selectedIndex].ExtraLife_img.fillAmount = math.min(1, ((curLife + value) / maxLife))
            end
            break
        end

        for i = 1, #self.roleOnShow do
            self.roleOnShow[i].ExtraLife:SetActive(showExtraBar and i == self.selectedIndex)
        end

    if self.ingoreError then
        self.ingoreError = false
    end
end

function UseCureItemPanel:GetCureValue(param)
    Fight.Instance.damageCalculate:ClearCureBuild()
    local value = Fight.Instance.damageCalculate:CalcCure(Fight.Instance, self.entity, self.entity, self.entity.attrComponent, self.entity.attrComponent, param)
    Fight.Instance.damageCalculate:ClearCureBuild()
    return value 
end

function UseCureItemPanel:OnClick_ConfirmUse()
    local itemType = UseItemType[self.itemConfig.type]
    local isCanUse, errorCode = self.checkFuncs[itemType](self)
    isCanUse = isCanUse and mod.BagCtrl:GetItemCountById(self.itemConfig.id) >= self.useCount
    if isCanUse then
        --使用回复道具测试
        local magicIds = self.itemConfig.use_effect
        local lev = self.itemConfig.property1 or 0
        lev = math.max(lev, 1)
        if magicIds and next(magicIds) then
            for i = 1, self.useCount do
                for k = 1, #magicIds do
                    Fight.Instance.playerManager:GetPlayer():UseItem(self.selectedIndex, magicIds[k], lev)
                end
            end
        end
        MsgBoxManager.Instance:ShowTips(TI18N("使用道具成功"))
        mod.BagCtrl:UseItem({ unique_id = self.args.unique_id, count = self.useCount })
    else
        MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
    end

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
        return false, TI18N("无法对倒下角色使用")
    end
    local curLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.Life)
    local maxLife = self.entity.attrComponent:GetValue(EntityAttrsConfig.AttrType.MaxLife)
    if curLife == maxLife then
        return false, TI18N("血量已满")
    end
    return true
end

function UseCureItemPanel:ItemCheck_ReviveItem()
    if not self:IsEntityDeath() then
        return false, TI18N("只能对倒下角色使用")
    end

    if self.useCount > 1 then
        return false, TI18N("不能使用多个复活道具")
    end

    return true
end

function UseCureItemPanel:IsEntityDeath()
    if not self.entity then
        return false
    end

    return self.entity.stateComponent:IsState(FightEnum.EntityState.Death)
end