UseItemPanel = BaseClass("UseItemPanel", BasePanel)

function UseItemPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Bag/UseItemPanel.prefab")

    self.parent = parent
    self.itemConfig = nil
    self.maxCount = 0
    self.useCount = 0

    self.blurBack = nil
end

function UseItemPanel:__CacheObject()
	self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function UseItemPanel:__BindListener()
     
    self:BindCloseBtn(self.CommonGrid_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.Cancel_btn,self:ToFunc("Back"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("Back"))

    self.Submit_btn.onClick:AddListener(self:ToFunc("OnClick_ConfirmUse"))
    self.MaxBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MaxCount"))
    self.MinBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MinCount"))
    self.MinusBtn_btn.onClick:AddListener(self:ToFunc("OnClick_MinusCount"))
    self.PlusBtn_btn.onClick:AddListener(self:ToFunc("OnClick_PlusCount"))
end

function UseItemPanel:__Show()
    self.TitleText_txt.text = TI18N("提示")
    self.itemConfig = ItemConfig.GetItemConfig(self.args.template_id)
    self.maxCount = self.args.count
    self.useCount = 1
    
    self.commonItem = PoolManager.Instance:Pop(PoolType.class, "CommonItem") --CommonItem.New()
    if not self.commonItem then
        self.commonItem = CommonItem.New()
    end 
    self.commonItem:InitItem(self.Item, self.itemConfig, true,2)

    self.LeftCount_txt.text = string.format(TI18N("库存:%s"), self.maxCount)
    self:UpdateInfo()
end

function UseItemPanel:__ShowComplete()
     if not self.blurBack then
         local setting = { bindNode = self.BlurNode }
         self.blurBack = BlurBack.New(self, setting)
     end
     self:SetActive(false)
     self.blurBack:Show()
end

function UseItemPanel:__Hide()
    if self.blurBack then
        self.blurBack:Hide()
    end
end

function UseItemPanel:__delete()

end

function UseItemPanel:UpdateInfo()
    self.UseCount_txt.text = self.useCount
    -- self.Tips_txt.text = string.format(TI18N("确认使用%s个%s?"), self.useCount, self.itemConfig.name)
end

function UseItemPanel:OnClick_ConfirmUse()
    if self.useCount < 1 then
        return
    end

    -- 需要优化
    local magicIds = self.itemConfig.use_effect
    local lev = self.itemConfig.property1 or 0
    lev = math.max(lev, 1)
    if magicIds and next(magicIds) then
        for i = 1, self.useCount do
            for k = 1, #magicIds do
                Fight.Instance.playerManager:GetPlayer():UseItemForAll(magicIds[k], lev)
            end
        end
    end

    mod.BagCtrl:UseItem({ unique_id = self.args.unique_id, count = self.useCount })
    PanelManager.Instance:ClosePanel(self)
end

function UseItemPanel:OnClick_MaxCount()
    self.useCount = self.maxCount
    self:UpdateInfo()
end

function UseItemPanel:OnClick_MinCount()
    self.useCount = 1
    self:UpdateInfo()
end

function UseItemPanel:OnClick_PlusCount()
    if self.useCount >= self.maxCount then
        return
    end

    self.useCount = self.useCount + 1
    self:UpdateInfo()
end

function UseItemPanel:OnClick_MinusCount()
    if self.useCount <= 1 then
        return
    end

    self.useCount = self.useCount - 1
    self:UpdateInfo()
end

function UseItemPanel:Back()
	PanelManager.Instance:ClosePanel(self)
end