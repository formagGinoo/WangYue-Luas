AlchemyGetItemPanel = BaseClass("AlchemyGetItemPanel", BasePanel)

function AlchemyGetItemPanel:__init()
    self:SetAsset("Prefabs/UI/Alchemy/AlchemyGetItemPanel.prefab")
    self.blurBack = nil
end

function AlchemyGetItemPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end
function AlchemyGetItemPanel:__BindListener()
    self.CommonGrid_btn.onClick:AddListener(self:ToFunc("OnClick_Close"))
end

function AlchemyGetItemPanel:__delete()

end

function AlchemyGetItemPanel:__Hide()

end

-- self.args = {reward_list}
function AlchemyGetItemPanel:__Show()
    self.itemId = self.args[1].template_id
    self.count = self.args[1].count or 1

    self.itemInfo = ItemConfig.GetItemConfig(self.itemId)

    if self.itemInfo.yinyang_icon == AlchemyConfig.TypeIcon.Yin then 
        self.type = AlchemyConfig.FormulaType.Yin
    elseif self.itemInfo.yinyang_icon == AlchemyConfig.TypeIcon.Yang then
        self.type = AlchemyConfig.FormulaType.Yang
    elseif self.itemInfo.yinyang_icon == AlchemyConfig.TypeIcon.Banlance then
        self.type = AlchemyConfig.FormulaType.Balance
    else
        self.type = AlchemyConfig.FormulaType.UpGrade
    end
    self:SetCloseTimer()
    self:SetTopIcon()
    self:SetItemInfo()
    
    local setting = { passEvent = UIDefine.BlurBackCaptureType.UI, blurRadius = 2, bindNode = self.BlurNode }
    self.blurBack = BlurBack.New(self, setting)
    self.blurBack:Show()

    LayoutRebuilder.ForceRebuildLayoutImmediate(self.ItemDesc.transform.parent)
end

function AlchemyGetItemPanel:SetCloseTimer()
    UtilsUI.SetActiveByScale(self.CommonGrid, false)
    LuaTimerManager.Instance:AddTimer(1, 1, function()
        UtilsUI.SetActiveByScale(self.CommonGrid, true)
    end)
end

function AlchemyGetItemPanel:SetTopIcon()
    if self.type == AlchemyConfig.FormulaType.UpGrade then
        UtilsUI.SetActiveByScale(self.Upgrade,true)
        UtilsUI.SetActiveByScale(self.Yin,false)
        UtilsUI.SetActiveByScale(self.Yang,false)
        UtilsUI.SetActiveByScale(self.Balance,false)
        UtilsUI.SetActiveByScale(self.Line,false)
        UtilsUI.SetActiveByScale(self.ItemDesc,false)
    elseif self.type == AlchemyConfig.FormulaType.Yin then
        UtilsUI.SetActiveByScale(self.Upgrade,false)
        UtilsUI.SetActiveByScale(self.Yin,true)
        UtilsUI.SetActiveByScale(self.Yang,false)
        UtilsUI.SetActiveByScale(self.Balance,false)
    elseif self.type == AlchemyConfig.FormulaType.Yang then
        UtilsUI.SetActiveByScale(self.Upgrade,false)
        UtilsUI.SetActiveByScale(self.Yin,false)
        UtilsUI.SetActiveByScale(self.Yang,true)
        UtilsUI.SetActiveByScale(self.Balance,false)
    elseif self.type == AlchemyConfig.FormulaType.Balance then
        UtilsUI.SetActiveByScale(self.Upgrade,false)
        UtilsUI.SetActiveByScale(self.Yin,false)
        UtilsUI.SetActiveByScale(self.Yang,false)
        UtilsUI.SetActiveByScale(self.Balance,true)
    end
end

function AlchemyGetItemPanel:SetItemInfo()
    if not self.getItem then
        self.getItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not self.getItem then
            self.getItem = CommonItem.New()
        end
    end
	self.itemInfo.template_id = self.itemId
    self.getItem:InitItem(self.CommonItem,self.itemInfo,true)
	self:SetItemCount(self.getItem,self.count)
    self:SetItemDesc()
end

function AlchemyGetItemPanel:SetItemCount(item,count)
    item.node.Level:SetActive(true)
	item.node.Level_txt.text = count
end

function AlchemyGetItemPanel:SetItemDesc()
    self.ItemDesc_txt.text = self.itemInfo.desc
end

function AlchemyGetItemPanel:OnClick_Close()
    PanelManager.Instance:ClosePanel(self)
    if self.callback then
        self.callback()
    end
end