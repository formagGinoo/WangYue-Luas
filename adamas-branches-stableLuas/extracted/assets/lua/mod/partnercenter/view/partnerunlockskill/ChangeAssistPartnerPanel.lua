ChangeAssistPartnerPanel = BaseClass("ChangeAssistPartnerPanel", BasePanel)
local _tinsert = table.insert

local deviceTemplateId = 1001006
--初始化
function ChangeAssistPartnerPanel:__init(parent)
    self:SetAsset("Prefabs/UI/PartnerSkill/ChangeAssistPartnerPanel.prefab")
    self.parent = parent
end

--添加监听器
function ChangeAssistPartnerPanel:__BindListener()
    self.CloseBtn_btn.onClick:AddListener(self:ToFunc("ClickClose"))
end

function ChangeAssistPartnerPanel:__BindEvent()
end

--缓存对象
function ChangeAssistPartnerPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function ChangeAssistPartnerPanel:__Create()
end

function ChangeAssistPartnerPanel:__delete()

end

function ChangeAssistPartnerPanel:__Hide()
    for i, v in pairs(self.assistPartnerItemMap) do
        if v.commonItem then
            PoolManager.Instance:Push(PoolType.class, "PartnerAssistItem", v.commonItem)
        end
    end
    self.assistPartnerItemMap = {}
    self.ItemScroll_recyceList:CleanAllCell()
end

function ChangeAssistPartnerPanel:__ShowComplete()
end

function ChangeAssistPartnerPanel:ClickClose()
	
	self.curSelectAssistPartner = nil
    self.parentWindow:ClosePanel(self)
end

function ChangeAssistPartnerPanel:__Show()
    self.assistPartnerItemMap = {}

    self.deviceUniqueId = self.args.deviceUniqueId
    -- self.curOriginData = {}
    -- local partnerData = mod.BagCtrl:GetBagByType(BagEnum.BagType.Partner)
    -- for i, v in pairs(partnerData) do
    --     _tinsert(self.curOriginData, v)
    -- end
    -- self.curBagData = TableUtils.CopyTable(self.curOriginData)

    -- local curUniqueId = self.args.curUniqueId
    local partnerId = self.args.partnerId
    self.curSelectAssistPartner = self.args.selectAssistPartner

    local careerCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerId)
    self.sortRule = {
        sortType = PartnerBagConfig.SortType.SortByQuality,
        element = {},
        quality = {},
    }

    if careerCfg then
        for i, v in ipairs(careerCfg.career) do
            if v[1] ~= 0 then
                self.sortRule.element[v[1]] = true
            end
        end
    end
    local partnerMap = {}
    local asset_id = mod.AssetPurchaseCtrl:GetCurAssetId()
    local partnerData = mod.AssetPurchaseCtrl:GetAssetPartnerList(asset_id)
    if next(partnerData) then
        for i, UniqueId in pairs(partnerData) do
            local data = mod.BagCtrl:GetPartnerData(UniqueId)
            if data then
                _tinsert(partnerMap, data)
            end
        end
    end

    local career = {}
    local deviceCfg = AssetPurchaseConfig.GetAssetDeviceInfoById(deviceTemplateId)
    career[deviceCfg.career] = true
    local sort = {
        sortType = {},
        element = {},
        quality = {},
    }

    local newData = mod.PartnerBagCtrl:PickItem(partnerMap, sort)
    -- self:SortData(newData)
    self.curBagData = newData
    self:RefreshItemList()
end

-- function ChangeAssistPartnerPanel:SortData(data)
--     local deviceCfg = AssetPurchaseConfig.GetAssetDeviceInfoById(deviceTemplateId)
--     career[deviceCfg.career] = true
-- end

function ChangeAssistPartnerPanel:RefreshItemList()
    local bagCount = #self.curBagData
    if bagCount == 0 then
        --隐藏掉面板，卸载模型
        self.ItemScroll_recyceList:CleanAllCell()
        return
    end

    self.NullPanel:SetActive(false)
    if self.showPartnerFunc then
        self.showPartnerFunc(true)
    end
    
    self.ItemScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.ItemScroll_recyceList:SetCellNum(bagCount, true)
end

function ChangeAssistPartnerPanel:RefreshItemCell(index, go)
    if not go then return end
    
    local data = self.curBagData[index]
    
    local commonItem
    local itemInfo
    if not self.assistPartnerItemMap[index] then
        commonItem = PoolManager.Instance:Pop(PoolType.class, "PartnerAssistItem")
        if not commonItem then
            commonItem = PartnerAssistItem.New()
        end
        itemInfo = UtilsUI.GetContainerObject(go)
        self.assistPartnerItemMap[index] = {commonItem = commonItem, itemInfo = itemInfo}
    else
        commonItem = self.assistPartnerItemMap[index].commonItem
        itemInfo = self.assistPartnerItemMap[index].itemInfo
    end
    commonItem:Init(itemInfo.PartnerTempc)
    
    
    local newData = {
        parent = go.transform,
        uniqueId = data.unique_id,
        deviceUniqueId = self.deviceUniqueId,
        clickCallback = self:ToFunc("ClickAssistPartner"),
        showCurSelect = data.unique_id == self.curSelectAssistPartner
    }

    commonItem:UpdateUI(newData)
    --更新选中
    self.assistPartnerItemMap[index].itemInfo.select:SetActive(data.unique_id == self.curSelectAssistPartner)
end

function ChangeAssistPartnerPanel:ClickAssistPartner(uniqueId)
    self.parentWindow:ChangeAssistPartner(uniqueId)
    self:ClickClose()
end