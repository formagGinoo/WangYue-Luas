GetItemPanel = BaseClass("GetItemPanel", BasePanel)

--初始化
function GetItemPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Common/GetItemPanel.prefab")
    self.itemList = {}
end

--添加监听器
function GetItemPanel:__BindListener()
    self:SetHideNode("GetItemPanel_Eixt")
    self:BindCloseBtn(self.CloseButton_btn,self:ToFunc("Close_HideCallBack"))
end

--缓存对象
function GetItemPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function GetItemPanel:__Create()
    
end

function GetItemPanel:__BindEvent()
end

function GetItemPanel:__delete()
    for key, value in pairs(self.awardItemList) do
        value:Destroy()
        PoolManager.Instance:Push(PoolType.class, "AwardItem", value)
    end
end

function GetItemPanel:SetEffectLayer()
    local layer = WindowManager.Instance:GetCurOrderLayer()
    UtilsUI.SetEffectSortingOrder(self["22101"], layer + 1)
    self.ItemScroll.transform:GetComponent(Canvas).sortingOrder = layer + 2
end

function GetItemPanel:__Show(args)
    InputManager.Instance:AddLayerCount(InputManager.Instance.actionMapName, "UI")
    if not self.args.reward_list then
        return
    end
    self.awardItemList = {}
    self.itemList = self.args.reward_list
    self.callback = self.args.callback
    self.itemScrollComp = self.ItemScroll.transform:GetComponent(ScrollRect)
    self:UpdateData(self.itemList)
    self:SetEffectLayer()
    self:SetItemScroll()
    self:SetCloseTimer()
end

function GetItemPanel:__Hide()
    --[[
    if self.callback then
        self.callback()
    end
    ]]
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function ()
        EventMgr.Instance:Fire(EventName.CloseNoticePnl)
    end)
    
    InputManager.Instance:MinusLayerCount()
end

function GetItemPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function GetItemPanel:SetCloseTimer()
    UtilsUI.SetActiveByScale(self.CloseButton, false)
    LuaTimerManager.Instance:AddTimer(1, 1, function()
        UtilsUI.SetActiveByScale(self.CloseButton, true)
    end)
end

function GetItemPanel:SetItemScroll()
    if #self.itemList > 10 then
        self.itemScrollComp.movementType = 1
    else
        self.itemScrollComp.movementType = 2
    end
end

function GetItemPanel:UpdateData(itemList)
    for key, value in pairs(itemList) do
        local itemConfig = ItemConfig.GetItemConfig(value.template_id)
        if not itemConfig then
            LogError("找不到配置 id = ".. value.template_id)
            return
        end

        local itemCell = GameObject.Instantiate(self.AwardItem, self.Items_rect)
        self.awardItemList[key] = PoolManager.Instance:Pop(PoolType.class, "AwardItem")
        if not self.awardItemList[key] then
            self.awardItemList[key] = AwardItem.New()
        end
        self.awardItemList[key]:InitItem(itemCell, value.template_id, value.count, value.unique_id)
    end
end

function GetItemPanel:Close_HideCallBack()
    UtilsUI.SetActiveByScale(self.Items,false)
    PanelManager.Instance:ClosePanel(self)
	EventMgr.Instance:Fire(EventName.OnCloseGetItemPanel)
end