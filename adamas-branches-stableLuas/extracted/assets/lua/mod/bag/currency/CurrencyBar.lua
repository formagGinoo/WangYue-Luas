--通用货币栏
CurrencyBar = BaseClass("CurrencyBar", PoolBaseClass)

local Id2clickFunc = {
	[3] = function()
		PanelManager.Instance:OpenPanel(FreeCurrencyExchangePanel)
	end,
	
	[5] = function()
		PanelManager.Instance:OpenPanel(StrengthExchangePanel)
	end,
}

function CurrencyBar:__init()
end

function CurrencyBar:init(object, currencyId)
    self.object = object
    self.currencyId = currencyId
    self.nodes = UtilsUI.GetContainerObject(self.object.transform)
    self:UpdateCurrencyCount()
    self:RegisterCallBack()
    self:SetBtnEvent()

	self.object:SetActive(false)
    SingleIconLoader.Load(self.nodes.Icon, ItemConfig.GetItemIcon(currencyId), 
		function() 
			self.object:SetActive(true) 
		end)
end

-- 注册货币变更事件回调
function CurrencyBar:RegisterCallBack()
	EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
	EventMgr.Instance:AddListener(EventName.StrengthUpdate, self:ToFunc("UpdateCurrencyCount"))
end

-- 更新货币数量显示
function CurrencyBar:UpdateCurrencyCount()
	local count = mod.BagCtrl:GetItemCountById(self.currencyId)
	if self.currencyId == 5 then
		local val, maxVal = mod.BagCtrl:GetStrengthData()
		count = string.format("%d/%d", val, maxVal)
	end
    self.nodes.Count_txt.text = count
end

-- 更新货币数量显示
function CurrencyBar:ChangeCurrencyId(currencyId)
    self.currencyId = currencyId
    self:UpdateCurrencyCount()
    self:SetBtnEvent()
    SingleIconLoader.Load(self.nodes.Icon, ItemConfig.GetItemIcon(currencyId))
end

-- 为货币栏设置点击事件
function CurrencyBar:SetBtnEvent()
    local onclickFunc = function()
        ItemManager.Instance:ShowItemTipsPanel({ template_id = self.currencyId })
    end
    self.nodes.BgButton_btn.onClick:RemoveAllListeners()
    self.nodes.BgButton_btn.onClick:AddListener(Id2clickFunc[self.currencyId] or onclickFunc)
end

-- 放入缓存
function CurrencyBar:OnCache()
    Fight.Instance.objectPool:Cache(CurrencyBar, self)
end

-- 放入缓存
function CurrencyBar:__cache()
    self.nodes.BgButton_btn.onClick:RemoveAllListeners()
    self.object = nil
    self.currencyId = nil
    self.itemConfig = nil
    self.nodes = nil
	
	EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("UpdateCurrencyCount"))
	EventMgr.Instance:RemoveListener(EventName.StrengthUpdate, self:ToFunc("UpdateCurrencyCount"))
end

function CurrencyBar:__delete()

end