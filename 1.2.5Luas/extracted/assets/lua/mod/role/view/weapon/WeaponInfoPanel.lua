WeaponInfoPanel = BaseClass("WeaponInfoPanel", BasePanel)

function WeaponInfoPanel:__init()
    self.sourceObjList = {}
    self:SetAsset("Prefabs/UI/Weapon/WeaponInfoPanel.prefab")
end

function WeaponInfoPanel:__delete()
    self.itemTips:DeleteMe()
end

function WeaponInfoPanel:__Create()
    self.itemTips = CommonItemTip.New(self.CommonTips)
end

function WeaponInfoPanel:__BindEvent()

end

function WeaponInfoPanel:__BindListener()
end

function WeaponInfoPanel:__Show()
    self:WeaponInfoChange()
end

function WeaponInfoPanel:__Hide()
    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
end

function WeaponInfoPanel:WeaponInfoChange()
    self.itemInfo = self:GetWeaponData()
    self.itemConfig = ItemConfig.GetItemConfig(self.itemInfo.template_id)
    self.itemTips:SetItemInfo(self.itemInfo)
end


function WeaponInfoPanel:OnClick_LockWeapon()
    local weaponData = self:GetWeaponData()
    local type = ItemConfig.GetItemType(weaponData.template_id)
    local unique_id = weaponData.unique_id
    local is_lock = not weaponData.is_locked
    mod.BagCtrl:SetItemLockState(unique_id, is_lock, type)
end

function WeaponInfoPanel:GetWeaponData()
    return self.parentWindow:GetWeaponData()
end

function WeaponInfoPanel:HideAnim()
    self.WeaponInfoPanel_Exit:SetActive(true)
end