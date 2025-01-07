BaseStageChangeTipPanel = BaseClass("BaseStageChangeTipPanel", BasePanel)

function BaseStageChangeTipPanel:__init()
    self:SetAsset("Prefabs/UI/Role/RoleStageUpTipPanel.prefab")
end

function BaseStageChangeTipPanel:__BindListener()
    self:SetHideNode("RoleStageUpTipPanel_Eixt")
    self:BindCloseBtn(self.Close_btn, self:ToFunc("Close_HideCallBack"))
end

function BaseStageChangeTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BaseStageChangeTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

--[[
config
{
    oldStage,
    newStage,
    oldAttrTable
    newAttrTable
}
]]

function BaseStageChangeTipPanel:__Show()
    self.config = self.args
    self:ShowDetail()
end

function BaseStageChangeTipPanel:__ShowComplete()
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

function BaseStageChangeTipPanel:BlurComplete()
    self:SetActive(true)
end

function BaseStageChangeTipPanel:ShowDetail()
    self.SkillItem:SetActive(false)
    local config = self.config
    self.LevelLimit_txt.text = string.format("%s/%s",config.oldLev, config.newLev)
    for i = 1, config.newStage, 1 do
        self["Stage"..i]:SetActive(true)
    end
    for i = config.newStage + 1, 6, 1 do
        self["Stage"..i]:SetActive(false)
    end
    self:ShowChangeAttr(config.oldAttrTable, config.newAttrTable)
end

function BaseStageChangeTipPanel:ShowChangeAttr(oldAttrTable, newAttrTable)
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
        obj.transform:SetParent(self.Content_rect)
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

function BaseStageChangeTipPanel:OnClick_ClosePanel()
    self.RoleStageUpTipPanel_Eixt:SetActive(true)
end

function BaseStageChangeTipPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(BaseStageChangeTipPanel)
end
