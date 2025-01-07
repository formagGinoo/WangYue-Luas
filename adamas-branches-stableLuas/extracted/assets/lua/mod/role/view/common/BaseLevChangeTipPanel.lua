BaseLevChangeTipPanel = BaseClass("BaseLevChangeTipPanel", BasePanel)

function BaseLevChangeTipPanel:__init()
    self:SetAsset("Prefabs/UI/Role/RoleUpgradeTipPanel.prefab")
end

function BaseLevChangeTipPanel:__BindListener()
    self:BindCloseBtn(self.Close_btn, self:ToFunc("Close_HideCallBack"))
end

function BaseLevChangeTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BaseLevChangeTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

--[[
config
{
    oldLev,
    newLev,
    oldAttrTable
    newAttrTable
    callBack
}
]]

function BaseLevChangeTipPanel:__Show()
    self.config = self.args
    self:ShowDetail()
end

function BaseLevChangeTipPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 3, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
    self.Close:SetActive(false)
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1,1,function()
        self.Close:SetActive(true)
    end)
end

function BaseLevChangeTipPanel:BlurComplete()
    self:SetActive(true)
end

function BaseLevChangeTipPanel:ShowDetail()
    local config = self.config
    self.CurLevelText_txt.text = config.oldLev
    self.CurLevelText2_txt.text = config.newLev
    self:ShowPartnerChangeSkill(config.partnerSkillsInfo)
    self:ShowChangeAttr(config.oldAttrTable, config.newAttrTable)
end

function BaseLevChangeTipPanel:ShowPartnerChangeSkill(partnerSkillsInfo)
    if not partnerSkillsInfo then
        return
    end
    if #partnerSkillsInfo.add_skill > 0 then
        local str = ""
        for i, id in ipairs(partnerSkillsInfo.add_skill) do
            local config = RoleConfig.GetPartnerSkillConfig(id)
            str = string.format(TI18N("%s<color=#ffa234>%s</color> "), str, config.name)
        end
        local obj = self:PopUITmpObject("PartnerSkillSlotItem").object
        obj.transform:SetParent(self.AttributeList_rect)
        UnityUtils.SetLocalScale(obj.transform, 1, 1, 1)
        obj:SetActive(true)
        local node = UtilsUI.GetContainerObject(obj.transform)
        node.SlotItemTips_txt.text = string.format(TI18N("解锁天赋技%s"), str)
    end

    if partnerSkillsInfo.add_passive > 0 then
        local obj = self:PopUITmpObject("PartnerSkillSlotItem").object
        obj.transform:SetParent(self.AttributeList_rect)
        UnityUtils.SetLocalScale(obj.transform, 1, 1, 1)
        obj:SetActive(true)
        local node = UtilsUI.GetContainerObject(obj.transform)
        node.SlotItemTips_txt.text = string.format(TI18N("解锁<color=#ffa234>%s</color>个被动槽位"), partnerSkillsInfo.add_passive)
    end
    if partnerSkillsInfo.add_plate > 0 then
        local obj = self:PopUITmpObject("PartnerSkillSlotItem").object
        obj.transform:SetParent(self.AttributeList_rect)
        obj:SetActive(true)
        UnityUtils.SetLocalScale(obj.transform, 1, 1, 1)
        local node = UtilsUI.GetContainerObject(obj.transform)
        node.SlotItemTips_txt.text = string.format(TI18N("解锁<color=#ffa234>%s</color>个雕纹槽位"), partnerSkillsInfo.add_plate)
    end
end

function BaseLevChangeTipPanel:ShowChangeAttr(oldAttrTable, newAttrTable)
    local keySort = {}
    for key, value in pairs(newAttrTable) do
        local attr = {key = key, priority = RoleConfig.GetAttrPriority(key)}
        table.insert(keySort, attr)
    end
    table.sort(keySort,function (a, b)
        return a.priority > b.priority
    end)

    for i = 1, #keySort, 1 do
        local index = keySort[i].key
        local obj = self:PopUITmpObject("AttributeItem").object
        obj.transform:SetParent(self.AttributeList_rect)
		obj.transform:ResetAttr()
        obj:SetActive(true)
        local node = UtilsUI.GetContainerObject(obj.transform)
        node.Name_txt.text = RoleConfig.GetAttrConfig(index).name
        
        local value = newAttrTable[index]
        local oldValue = oldAttrTable[index] or value
        if RoleConfig.GetAttrConfig(index).value_type == FightEnum.AttrValueType.Percent then
            value = value / 100 .. "%"
            oldValue = oldValue / 100 .."%"
        end
        node.OldValue_txt.text = oldValue
        node.NewValue_txt.text = value
        node.UpArrow:SetActive(oldValue ~= value)
        if i % 2 == 0 then
            node.Bg:SetActive(false)
        else
            node.Bg:SetActive(true)
        end
    end
end



function BaseLevChangeTipPanel:OnClick_Close()
    self.RoleUpgradeTipPanel_exit:SetActive(true)
end

function BaseLevChangeTipPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(BaseLevChangeTipPanel)
end