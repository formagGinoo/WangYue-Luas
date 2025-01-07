RoleUpgradeTipPanel = BaseClass("RoleUpgradeTipPanel", BasePanel)

local DataHeroLevAttr = Config.DataHeroLevAttr.Find

function RoleUpgradeTipPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleUpgradeTipPanel.prefab")
    self.itemList = {}
end

function RoleUpgradeTipPanel:__BindEvent()

end

function RoleUpgradeTipPanel:__BindListener()
    self:SetHideNode("RoleUpgradeTipPanel_exit")
    self:BindCloseBtn(self.Close_btn, self:ToFunc("Close_HideCallBack"))
end

function RoleUpgradeTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RoleUpgradeTipPanel:__Create()

end

function RoleUpgradeTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function RoleUpgradeTipPanel:__Show()
    self.heroId = self.args.heroId
    self.oldLev = self.args.oldLev
    self.newLev = self.args.newLev
    self.stage = self.args.stage
    self.CurLevelText_txt.text = self.oldLev
    self.CurLevelText2_txt.text = self.newLev
    for _, item in pairs(self.itemList) do
        item.object:SetActive(false)
    end
    self:showAttributeChange()
end

function RoleUpgradeTipPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 2, bindNode = self.BlurBack }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show({ self:ToFunc("BlurComplete") })
    self.Close:SetActive(false)
    LuaTimerManager.Instance:RemoveTimer(self.delayTimer)
    self.delayTimer = LuaTimerManager.Instance:AddTimer(1,1,function()
        if self.Close then
            self.Close:SetActive(true)
        end
    end)
end

function RoleUpgradeTipPanel:BlurComplete()
    self:SetActive(true)
end

function RoleUpgradeTipPanel:showAttributeChange()
    --目前养成系统只有升级，所以属性值仅统计等级和突破带来的基础属性，后续增加武器和佩从的统计
    local oldAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.oldLev)
    local newAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.newLev)
    local stageAttr = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.stage)
    local attrId = UtilsBase.GetStringKeys(self.heroId, self.newLev)
    for index, attr_id in pairs(DataHeroLevAttr[attrId].ui_show_attr) do
        local item = self.itemList[index] or self:getAttributeItem()
        item.Bg:SetActive(index % 2 ~= 0)
        item.Name_txt.text = Config.DataAttrsDefine.Find[attr_id].name
        local curValue = oldAttr[attr_id] + stageAttr[attr_id] or 0
        local nextValue = newAttr[attr_id] + stageAttr[attr_id] or 0
        if EntityAttrsConfig.AttrPercent2Attr[attr_id] then
            curValue = curValue * 0.01 .. "%"
            nextValue = nextValue * 0.01 .. "%"
        end
        item.OldValue_txt.text = curValue
        item.NewValue_txt.text = nextValue
        item.UpArrow:SetActive(oldAttr[attr_id] < newAttr[attr_id])
        item.object:SetActive(true)
        self.itemList[index] = item
    end
    UnityUtils.SetSizeDelata(self.AttributeList.transform, 695, 50 * #DataHeroLevAttr[attrId].ui_show_attr)
end

function RoleUpgradeTipPanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    obj.objectTransform:SetParent(self.AttributeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function RoleUpgradeTipPanel:OnClick_Close()
    self.RoleUpgradeTipPanel_exit:SetActive(true)
end

function RoleUpgradeTipPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(RoleUpgradeTipPanel)
end