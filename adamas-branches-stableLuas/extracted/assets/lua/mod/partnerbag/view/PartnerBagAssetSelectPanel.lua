PartnerBagAssetSelectPanel = BaseClass("PartnerBagAssetSelectPanel", BasePanel)

local Red = Color(255 / 255, 124 / 255, 110 / 255, 1)
local Black = Color(22 / 255, 22 / 255, 26 / 255, 1)
local White = Color(255 / 255, 255 / 255, 255 / 255, 1)
local _insert = table.insert


function PartnerBagAssetSelectPanel:__init()
    self:SetAsset("Prefabs/UI/PartnerBag/PartnerBagAssetSelectPanel.prefab")
    self.assetInfoList = {}
    self.curSelectIndex = nil --当前选择的索引
    
    --ui 
    self.itemList = {}
end



function PartnerBagAssetSelectPanel:__BindEvent()

end

--缓存对象
function PartnerBagAssetSelectPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerBagAssetSelectPanel:__BindListener()
    self.replaceBtn_btn.onClick:AddListener(self:ToFunc("OnClickReplaceBtn"))
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("OnClickCloseBtn"))
end

function PartnerBagAssetSelectPanel:__Create()

end

function PartnerBagAssetSelectPanel:__Show()
    --目前所有已经解锁的资产
    local list = mod.AssetPurchaseCtrl:GetExistingAssetInfo()
    for i, v in pairs(list) do
        _insert(self.assetInfoList, v)
    end
    self.curSelectIndex = nil
    self:UpdateUI()
    self:ChangeBtnState()
end

function PartnerBagAssetSelectPanel:__RepeatShow()
    
end

function PartnerBagAssetSelectPanel:__ShowComplete()

end

function PartnerBagAssetSelectPanel:__Hide()
    
end

function PartnerBagAssetSelectPanel:__delete()
    self.ScrollView_recyceList:CleanAllCell()
end

function PartnerBagAssetSelectPanel:UpdateUI()
    if #self.assetInfoList == 0 then
        self.Empty:SetActive(true)
        return
    end
    self.Empty:SetActive(false)
    
    self.ScrollView_recyceList:SetLuaCallBack(self:ToFunc("RefreshList"))
    self.ScrollView_recyceList:SetCellNum(#self.assetInfoList)
end

function PartnerBagAssetSelectPanel:RefreshList(idx, obj)
    if not obj then
        return
    end
    
    if not self.itemList[idx] then
        self.itemList[idx] = {}
        self.itemList[idx].obj = obj
        self.itemList[idx].node = UtilsUI.GetContainerObject(obj)
    end
    self.itemList[idx].node.bgBtn_btn.onClick:RemoveAllListeners()
    self.itemList[idx].node.bgBtn_btn.onClick:AddListener(function()
        self:OnClickItem(idx)
    end)
    self:UpdateItem(idx)
end

function PartnerBagAssetSelectPanel:UpdateItem(idx)
    local item = self.itemList[idx]
    local data = self.assetInfoList[idx]

    local assetConfig = AssetPurchaseConfig.GetAssetConfigById(data.asset_id)
    item.node.name_txt.text = assetConfig.name

    UtilsUI.SetActive(item.node.icon, false)
    if assetConfig.icon ~= " " then
        local callback = function()
            UtilsUI.SetActive(item.node.icon, true)
        end
        SingleIconLoader.Load(item.node.icon, assetConfig.icon, callback)
    end

    if self.curSelectIndex and self.curSelectIndex == idx then
        item.node.select:SetActive(true)
    else
        item.node.select:SetActive(false)
    end
end

function PartnerBagAssetSelectPanel:OnClickItem(idx)
    if self.curSelectIndex then
        local lastItem = self.itemList[self.curSelectIndex]
        if lastItem then
            lastItem.node.select:SetActive(false)
        end
    end
    
    local item = self.itemList[idx]
    self.curSelectIndex = idx
    item.node.select:SetActive(true)
    
    self:ChangeBtnState()
end

function PartnerBagAssetSelectPanel:ChangeBtnState()
    UtilsUI.SetActive(self.replaceBtn, self.curSelectIndex and true or false)
end

function PartnerBagAssetSelectPanel:OnClickReplaceBtn()
    if not self.curSelectIndex then
        return
    end
    local data = self.assetInfoList[self.curSelectIndex]
    mod.AssetPurchaseCtrl.JumpToAssetInfo(data.asset_id,true)
    PanelManager.Instance:ClosePanel(self)
end

function PartnerBagAssetSelectPanel:OnClickCloseBtn()
    PanelManager.Instance:ClosePanel(self)
end