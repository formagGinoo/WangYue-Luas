WeaponRefinePanel = BaseClass("WeaponRefinePanel", BasePanel)

function WeaponRefinePanel:__init()
    self:SetAsset("Prefabs/UI/Weapon/WeaponRefinePanel.prefab")
    self.itemList = {}
    self.weaponList = {}
end

function WeaponRefinePanel:__delete()
    
end

function WeaponRefinePanel:__BindListener()
    self.RefineButton_btn.onClick:AddListener(self:ToFunc("OnClick_Refine"))
end

function WeaponRefinePanel:__Show()
    self:WeaponInfoChange()
end

function WeaponRefinePanel:__Hide()
    for key, value in pairs(self.itemList) do
        ItemManager.Instance:PushItemToPool(value)
    end
    self.itemList = {}
end

function WeaponRefinePanel:WeaponInfoChange()
    for key, value in pairs(self.itemList) do
        ItemManager.Instance:PushItemToPool(value)
    end
    self.itemList = {}
    self.weaponList = {}
    self:ShowUIDetail()
end

function WeaponRefinePanel:ShowUIDetail()
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id
    local curRefineConfig = RoleConfig.GetWeaponRefineConfig(weaponId, weaponData.refine)
    local targetRefineConfig = RoleConfig.GetWeaponRefineConfig(weaponId, weaponData.refine + 1)
    if not curRefineConfig  then
        self.OldEffext:SetActive(false)
    elseif curRefineConfig then
        self.OldRefineText_txt.text = weaponData.refine
        self.OldRefineDescribe_txt.text = string.format(TI18N("精炼%s级"), weaponData.refine)
    
        if curRefineConfig.desc ~= "" then
            self.OldSkillDescribe_txt.text = curRefineConfig.desc
        end
    end

    if not targetRefineConfig then
        self.Bottom:SetActive(false)
        return
    else
        self.Bottom:SetActive(true)
    end

    self.NewRefineText_txt.text = weaponData.refine + 1
    self.NewRefineDescribe_txt.text = string.format(TI18N("精炼%s级"), weaponData.refine + 1)

    if targetRefineConfig.desc ~= "" then
        self.NewSkillDescribe_txt.text = targetRefineConfig.desc
    end
    for i = 1, #targetRefineConfig.need_item, 1 do
        local itemId = targetRefineConfig.need_item[i][1]
        local needCount = targetRefineConfig.need_item[i][2]
        local type = ItemConfig.GetItemType(itemId)
        if type == BagEnum.BagType.Item then
            local count = mod.BagCtrl:GetItemCountById(itemId)
            local showCount
            if count < needCount then
                showCount = string.format("<color=#ff0000>%s</color>/<color=#9b9fad>%s</color>", count, needCount)
            else
                showCount = string.format("%s/%s", count, needCount)
            end
            local itemInfo = {template_id = itemId, scale = 0.8, count = showCount}
            local item =  ItemManager.Instance:GetItem(self.CostList_rect, itemInfo, true)
            self.itemList[itemId] = item
        elseif type == BagEnum.BagType.Weapon then
            local weaponInfo = {curCount = 0,needCount = needCount, selectList = {}}
            local showCount = string.format("%s/%s", 0, needCount)
            local itemInfo = {
                template_id = itemId,
                scale = 0.8,
                count = showCount,
                btnFunc = function ()
                    self:OpenSelectPanel(itemId)
                end
            }
            local item =  ItemManager.Instance:GetItem(self.CostList_rect, itemInfo, true)
            self.itemList[itemId] = item
            self.weaponList[itemId] = weaponInfo
        end
    end
end

function WeaponRefinePanel:OpenSelectPanel(itemId)
    --self.parentWindow:ClosePanel(ItemSelectPanel)
    local weaponInfo = self.weaponList[itemId]
    local config = {
        width  = 480,
        col = 3,
        additionItem = {itemId},
        pauseSelect = weaponInfo.curCount == weaponInfo.needCount,
        selectMode = 2,
        onClick = self:ToFunc("SelectWeapon"),
        reduceFunc = self:ToFunc("UnSelectWeapon"),
        upgradeWeapon = self:GetWeaponData().unique_id,
        selectList = weaponInfo.selectList
    }
    self.parentWindow:OpenPanel(ItemSelectPanel, {config = config})
end

function WeaponRefinePanel:SelectWeapon(unique_id, template_id, type)
    local weaponInfo = self.weaponList[template_id]
    if not weaponInfo.selectList[type] then
        weaponInfo.selectList[type] = {}
    end
    if weaponInfo.curCount >= weaponInfo.needCount then
        return
    end

    weaponInfo.curCount = weaponInfo.curCount + 1
    if self.parentWindow:GetPanel(ItemSelectPanel) then
        self.parentWindow:GetPanel(ItemSelectPanel):PauseSelect(weaponInfo.curCount == weaponInfo.needCount)
    end
    weaponInfo.selectList[type][unique_id] = 1
    self:UpdateShow(template_id)
end

function WeaponRefinePanel:UnSelectWeapon(unique_id, template_id, type)
    local weaponInfo = self.weaponList[template_id]
    weaponInfo.curCount = weaponInfo.curCount - 1
    if self.parentWindow:GetPanel(ItemSelectPanel) then
        self.parentWindow:GetPanel(ItemSelectPanel):PauseSelect(weaponInfo.curCount == weaponInfo.needCount)
    end
    weaponInfo.selectList[type][unique_id] = nil
    self:UpdateShow(template_id)
end

function WeaponRefinePanel:UpdateShow(itemId)
    local commonItem = self.itemList[itemId]
    local weaponInfo = self.weaponList[itemId]
    local showCount = string.format("%s/%s", weaponInfo.curCount, weaponInfo.needCount)
    local itemInfo = 
    {
        template_id = itemId,
        scale = 0.8,
        count = showCount,
        btnFunc = function ()
            self:OpenSelectPanel(itemId)
        end
    }
    commonItem:SetItem(itemInfo)
    commonItem:Show()
end

function WeaponRefinePanel:OnClick_Refine()
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end
    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id
    local targetRefineConfig = RoleConfig.GetWeaponRefineConfig(weaponId, weaponData.refine + 1)
    for i = 1, #targetRefineConfig.need_item, 1 do
        local itemId = targetRefineConfig.need_item[i][1]
        local needCount = targetRefineConfig.need_item[i][2]
        local type = ItemConfig.GetItemType(itemId)
        if type == BagEnum.BagType.Item then
            local count = mod.BagCtrl:GetItemCountById(itemId)
            if count < needCount then
                MsgBoxManager.Instance:ShowTips(TI18N("所需道具数量不足"))
                return
            end
        elseif type == BagEnum.BagType.Weapon then
            local weaponInfo = self.weaponList[itemId]
            if weaponInfo.curCount < weaponInfo.needCount then
                MsgBoxManager.Instance:ShowTips(TI18N("所选武器数量不足"))
                return
            end
        end
    end
    local weaponIdList = {}
    for itemId, weaponInfo in pairs(self.weaponList) do
        if weaponInfo.selectList[BagEnum.BagType.Weapon] then
            for id, count in pairs(weaponInfo.selectList[BagEnum.BagType.Weapon]) do
                table.insert(weaponIdList, id)
            end
        end
    end
    self.parentWindow:ClosePanel(ItemSelectPanel)
    mod.RoleCtrl:RefineWeapon(weaponData.unique_id, weaponIdList)

end

function WeaponRefinePanel:GetWeaponData()
    return self.parentWindow:GetWeaponData()
end

function WeaponRefinePanel:HideAnim()
    self.WeaponRefinePanel_Eixt:SetActive(true)
end