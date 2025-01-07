WeaponStageUpPanel = BaseClass("WeaponStageUpPanel", BasePanel)

function  WeaponStageUpPanel:__init()
    self:SetAsset("Prefabs/UI/Weapon/WeaponStageUpPanel.prefab")
    self.itemList = {}
    self.cacheMap = {}
    self.attrList = {}
end
function WeaponStageUpPanel:__delete()
    
end

function WeaponStageUpPanel:__BindListener()
    self.StageUpButton_btn.onClick:AddListener(self:ToFunc("WeaponStageUp"))
end

function WeaponStageUpPanel:__Show()
	self:CheckCondition()
    self:ShowUIDetail()
end

function WeaponStageUpPanel:__Hide()
    for i = #self.itemList, 1, -1 do
        local item = table.remove(self.itemList, i)
        ItemManager.Instance:PushItemToPool(item)
    end
    self:CacheAllAttrObj()
end

function WeaponStageUpPanel:CheckCondition()
    local weaponData = self:GetWeaponData()
    local weaponConfig = RoleConfig.GetStageConfig(weaponData.template_id, weaponData.stage + 1)
    if not weaponConfig then
        return
    end
    local isPass, desc
    if weaponConfig.condition_id and next(weaponConfig.condition_id) then
        isPass, desc = Fight.Instance.conditionManager:CheckConditionByConfig(weaponConfig.condition_id[1])
        if not isPass then
            self.LimitTipText_txt.text = Fight.Instance.conditionManager:GetConditionDesc(weaponConfig.condition_id[1])
        end
    else
        isPass = true
    end
    self.StageUpButton:SetActive(isPass)
    self.LimitTip:SetActive(not isPass)
end

function WeaponStageUpPanel:ShowUIDetail()
    local weaponData = self:GetWeaponData()
    local weaponId = weaponData.template_id
    local oldStageConfig = RoleConfig.GetStageConfig(weaponId, weaponData.stage)
    local newStageConfig = RoleConfig.GetStageConfig(weaponId, weaponData.stage + 1)
    local oldAttrTable = RoleConfig.GetWeaponBaseAttrs(weaponId, weaponData.lev, weaponData.stage)
    local newAttrTable = RoleConfig.GetWeaponBaseAttrs(weaponId, weaponData.lev, weaponData.stage + 1)
    SingleIconLoader.Load(self.Stage, "Textures/Icon/Single/StageIcon/" .. weaponData.stage .. ".png")
    self.OldCur_txt.text = weaponData.lev
    self.OldMax_txt.text = oldStageConfig.level_limit

    if newStageConfig and next(newAttrTable) then
        self.TextChange_txt.text = string.format(TI18N("等级上限提升至%s级"),newStageConfig.level_limit)
        self:ShowChangeAttr(oldAttrTable, newAttrTable)
    else
        self.TextChange_txt.text = TI18N("已达到突破等级上限")
        self:ShowAllAttr(oldAttrTable)
        self.NewStage:SetActive(false)
        self.NeedItem:SetActive(false)
        self.StageUpButton:SetActive(false)
        self.GoldRoot:SetActive(false)
        self.LimitTip:SetActive(true)
        self.LimitTipText_txt.text =  TI18N("已达到突破等级上限")
        return
    end
    
    self.NewCur_txt.text = weaponData.lev
    self.NewMax_txt.text = newStageConfig.level_limit


    local curGold = self:GetPlayerGold()
    local needGold = newStageConfig.need_gold
    if curGold < needGold then
        self.NeedGold_txt.text = string.format("<color=#ff0000>%s</color>/<color=#9b9fad>%s</color>", curGold, needGold)
    else
        self.NeedGold_txt.text = string.format("%s/%s", curGold, needGold)
    end
    
    local needItem = newStageConfig.need_item
    for index, value in ipairs(needItem) do
        local curCount = mod.BagCtrl:GetItemCountById(value[1])
        local needCount = value[2]
        local count
        if curCount < needCount then
            count = string.format("<color=#ff0000>%s</color>/<color=#ffffff>%s</color>",curCount, needCount)
        else
            count = string.format("%s/%s",curCount, needCount)
        end
        local itemInfo = {
            template_id = value[1],
            count = count,
            scale = 0.8,
        }
        local item = ItemManager.Instance:GetItem(self.ItemRoot, itemInfo, true)
        table.insert(self.itemList, item)
    end
end

function WeaponStageUpPanel:ShowAllAttr(attrTable)
    local count = 0
    for index, value in pairs(attrTable) do
        if RoleConfig.GetAttrConfig(index).value_type == FightEnum.AttrValueType.Percent then
            value = value / 100 .. "%"
        end
        count = count + 1
        local attr, node = self:GetAttrObj()
        node.OldValue:SetActive(false)
        node.arrow1:SetActive(false)
        node.arrow2:SetActive(false)
        node.AttrText_txt.text = RoleConfig.GetAttrConfig(index).name
        node.NewValue_txt.text = value
        node.arrow2:SetActive(false)
        if count % 2 == 0 then
            node.BG:SetActive(false)
        else
            node.BG:SetActive(true)
        end
        table.insert(self.attrList, attr)
    end
end

function WeaponStageUpPanel:ShowChangeAttr(oldAttrTable, newAttrTable)
    local count = 0
    for index, value in pairs(newAttrTable) do
        count = count + 1
        local attr, node = self:GetAttrObj()
        node.AttrText_txt.text = RoleConfig.GetAttrConfig(index).name
        local oldValue = oldAttrTable[index] or value
        if RoleConfig.GetAttrConfig(index).value_type == FightEnum.AttrValueType.Percent then
            value = value / 100 .. "%"
            oldValue = oldValue / 100 .."%"
        end
        node.OldValue_txt.text = oldValue
        node.NewValue_txt.text = value
        node.arrow2:SetActive(oldValue ~= value)
        if count % 2 == 0 then
            node.BG:SetActive(false)
        else
            node.BG:SetActive(true)
        end
        table.insert(self.attrList, attr)
    end
end

function WeaponStageUpPanel:GetAttrObj()
    local attr
    if next(self.cacheMap) then
        attr = table.remove(self.cacheMap)
    else
        attr = {}
		local obj = self:PopUITmpObject("AttrObject")
        attr.tf = obj.objectTransform
        attr.node = UtilsUI.GetContainerObject(attr.tf)
    end
    attr.tf:SetParent(self.AttrRoot_rect)
    UnityUtils.SetLocalScale(attr.tf, 1, 1, 1)
    return attr, attr.node
end
function WeaponStageUpPanel:CacheAttrObj(attr)
    attr.tf:SetParent(self.Cache_rect)
    local node = attr.node
    node.NewValue:SetActive(true)
    node.arrow1:SetActive(true)
    node.arrow2:SetActive(true)
    table.insert(self.cacheMap, attr)
end

function WeaponStageUpPanel:CacheAllAttrObj()
    for i = #self.attrList, 1, -1 do
        local attr = table.remove(self.attrList,i)
        self:CacheAttrObj(attr)
    end
end

function WeaponStageUpPanel:GetWeaponData()
    return self.parentWindow:GetWeaponData()
end

function WeaponStageUpPanel:GetPlayerGold()
    return mod.BagCtrl:GetGoldCount()
end

function WeaponStageUpPanel:WeaponStageUp()
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
    local itemConfig = RoleConfig.GetStageConfig(weaponId, weaponData.stage + 1)
    if itemConfig then
        local needItem = itemConfig.need_item
        local needGold = itemConfig.need_gold
        for key, value in ipairs(needItem) do
            if mod.BagCtrl:GetItemCountById(value[1]) < value[2] then
                MsgBoxManager.Instance:ShowTips(TI18N("所需道具不足"))
                return
            end 
        end
        if needGold > mod.BagCtrl:GetGoldCount() then
            local desc = ItemConfig.GetItemConfig(2).name .. TI18N("不足")
            MsgBoxManager.Instance:ShowTips(desc)
            return
        end
        mod.RoleCtrl:WeaponStageUp(weaponData.unique_id)
        self:PlayExitAnim()
    end

end

function WeaponStageUpPanel:__AfterExitAnim()
    self:Hide()
end