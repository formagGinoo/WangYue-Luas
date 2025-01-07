RoleStageUpTipPanel = BaseClass("RoleStageUpTipPanel", BasePanel)

local DataHeroStageAttr = Config.DataHeroStageAttr.Find

function RoleStageUpTipPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Role/RoleStageUpTipPanel.prefab")
    self.itemList = {}
end

function RoleStageUpTipPanel:__BindListener()
    self:SetHideNode("RoleStageUpTipPanel_Eixt")
    self:BindCloseBtn(self.Close_btn, self:ToFunc("Close_HideCallBack"))
end

function RoleStageUpTipPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function RoleStageUpTipPanel:__delte()
    if self.blurBack then
        self.blurBack:Destroy()
    end
end

function RoleStageUpTipPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end
function RoleStageUpTipPanel:__Show()
    self.heroId = self.args.heroId
    self.oldStage = self.args.oldStage
    self.newStage = self.args.newStage
    self.curRoleInfo = mod.RoleCtrl:GetRoleData(self.args.heroId)
    self.SkillItem:SetActive(false)
    for _, item in pairs(self.itemList) do
        item.object:SetActive(false)
    end
    self:showAttributeChange()
end

function RoleStageUpTipPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { passEvent = UIDefine.BlurBackCaptureType.Scene, blurRadius = 2, bindNode = self.BlurBack }
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

function RoleStageUpTipPanel:BlurComplete()
    self:SetActive(true)
end

function RoleStageUpTipPanel:showAttributeChange()
    local curAttr = EntityAttrsConfig.GetHeroBaseAttr(self.heroId, self.curRoleInfo.lev)
    local oldStageAttr = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.oldStage)
    local newStageAttr = EntityAttrsConfig.GetHeroStageAttr(self.heroId, self.newStage)
    local stageUpInfo = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)]
    if not newStageAttr or not stageUpInfo then
        return
    end
    for i = 1, self.newStage do
        self["Stage" .. (i)]:SetActive(true)
    end

    UtilsUI.SetEffectSortingOrder(self["22030_"..self.newStage], self.canvas.sortingOrder + 1)
    UtilsUI.SetEffectSortingOrder(self["22031_"..self.newStage].transform:GetChild(0).gameObject, self.canvas.sortingOrder)
    UtilsUI.SetEffectSortingOrder(self["22031_"..self.newStage].transform:GetChild(1).gameObject, self.canvas.sortingOrder + 2)
    self["22030_"..self.newStage]:SetActive(true)
    self["22031_"..self.newStage]:SetActive(true)


    self.LevelLimit_txt.text = self.curRoleInfo.lev .. "/" .. Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(self.heroId, self.newStage)].limit_hero_lev
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.LevelLimit.transform.parent)
    self.SkillItem:SetActive(stageUpInfo.deblock_skill_id ~= 0)

    local showAttrList = DataHeroStageAttr[UtilsBase.GetStringKeys(self.heroId, self.curRoleInfo.stage)]
    for index, attr_id in pairs(showAttrList.ui_show_attr) do
        local item = self.itemList[index] or self:getAttributeItem()
        item.Bg:SetActive(index % 2 ~= 0)
        item.Name_txt.text = Config.DataAttrsDefine.Find[attr_id].name
        local curValue = curAttr[attr_id] + oldStageAttr[attr_id] or 0
        local nextValue = curAttr[attr_id] + newStageAttr[attr_id] or 0
        if EntityAttrsConfig.AttrPercent2Attr[attr_id] then
            curValue = curValue * 0.01 .. "%"
            nextValue = nextValue * 0.01 .. "%"
        end
        item.OldValue_txt.text = curValue
        item.NewValue_txt.text = nextValue
        item.UpArrow:SetActive(newStageAttr[attr_id] and newStageAttr[attr_id] > 0)
        item.object:SetActive(true)
        self.itemList[index] = item
    end
end

function RoleStageUpTipPanel:getAttributeItem()
    local obj = self:PopUITmpObject("AttributeItem")
    obj.objectTransform:SetParent(self.Content.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end

function RoleStageUpTipPanel:OnClick_ClosePanel()
    self.RoleStageUpTipPanel_Eixt:SetActive(true)
end

function RoleStageUpTipPanel:Close_HideCallBack()
    PanelManager.Instance:ClosePanel(RoleStageUpTipPanel)
end