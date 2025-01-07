--通用货币栏
CurrencyBar = BaseClass("CurrencyBar", PoolBaseClass)

function CurrencyBar:__init()
end

function CurrencyBar:init(object, currencyId)
    self.object = object
    self.currencyId = currencyId
    self.nodes = UtilsUI.GetContainerObject(self.object.transform)
    self:UpdateCurrencyCount()
    self:RegisterCallBack()
    self:SetBtnEvent()

    SingleIconLoader.Load(self.nodes.Icon, ItemConfig.GetItemIcon(currencyId))
end

-- 注册货币变更事件回调
function CurrencyBar:RegisterCallBack()
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
end

-- 更新货币数量显示
function CurrencyBar:UpdateCurrencyCount()
    local count = BagCtrl:GetItemCountById(self.currencyId)
    self.nodes.Count_txt.text = count
end

-- 为货币栏设置点击事件
function CurrencyBar:SetBtnEvent()
    local onclickFunc = function()
        ItemManager:ShowItemTipsPanel({ template_id = self.currencyId })
    end
    self.nodes.BgButton_btn.onClick:RemoveAllListeners()
    self.nodes.BgButton_btn.onClick:AddListener(onclickFunc)
end

-- 放入缓存
function CurrencyBar:OnCache()
    Fight.Instance.objectPool:Cache(CurrencyBar, self)
end


-- 放入缓存
function CurrencyBar:__cache()
    self.object = nil
    self.currencyId = nil
    self.itemConfig = nil
    self.nodes = nil
    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
end

--
function CurrencyBar:__delete()

end