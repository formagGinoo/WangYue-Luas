PartnerAssistItem = BaseClass("PartnerAssistItem", Module)
--佩丛技能解锁item
local assetProductId = 100100601
local itemPrefab = "Prefabs/UI/PartnerCenter/PartnerAssistItem.prefab"

--[[
    parent : 父节点
    clickCallback : 点击callback
    isCanDrag : 是否打开drag操作
]]--
function PartnerAssistItem:__init()
    self.itemObjectName = "PartnerAssistItem"
end

function PartnerAssistItem:Init(obj)
    self.object = obj
    if not self.object then
        self.assetLoader = AssetMgrProxy.Instance:GetLoader("PartnerAssistItemLoader")
        self:LoadItem()
        self.loadObj = true
    end
end

function PartnerAssistItem:SetItemInfo(itemInfo)
    self.parent = itemInfo.parent
    self.uniqueId = itemInfo.uniqueId
    self.deviceUniqueId = itemInfo.deviceUniqueId --哪个设备打开的id
    self.showCurSelect = itemInfo.showCurSelect or false

    --UI系列事件
    self.clickCallback = itemInfo.clickCallback
end

function PartnerAssistItem:__delete()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    if self.iconClass then
        PoolManager.Instance:Push(PoolType.class, "CommonItem", self.iconClass)
    end
    if self.loadObj and not PoolManager.Instance:Has(PoolType.object, self.itemObjectName) then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
end

function PartnerAssistItem:OnReset()
    
end

function PartnerAssistItem:CreatItem()
    local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)

    if not item then
        local callback = function()
            self.object = self.assetLoader:Pop(itemPrefab)
            --self:LoadDone()
        end

        local resList = {
            {path = itemPrefab, type = AssetType.Prefab}
        }
        self.assetLoader:AddListener(callback)
        self.assetLoader:LoadAll(resList)
        return false
    end
    return item
end

function PartnerAssistItem:LoadItem()
    local item = self:CreatItem()

    if item then
        self.object = item
        --self:InitItem()
    end
end

function PartnerAssistItem:LoadDone()
    self:InitItem()
end

function PartnerAssistItem:InitItem()
    if self.parent then
        --设置父节点
        UtilsUI.AddUIChild(self.parent, self.object)
    end
    UtilsUI.SetActive(self.object, true)
    self.node = UtilsUI.GetContainerObject(self.object.transform)

    --绑定点击事件
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function PartnerAssistItem:BindListener()
    self.node.bg_btn.onClick:RemoveAllListeners()
    self.node.bg_btn.onClick:AddListener(self:ToFunc("OnClickSelf"))
end

function PartnerAssistItem:UpdateUI(itemInfo)
    self:SetItemInfo(itemInfo)
    self:InitItem()
end

function PartnerAssistItem:UpdateItem()
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    local state = mod.PartnerBagCtrl:GetAssetPartnerState(self.uniqueId)
    self.node.curSelect:SetActive(self.showCurSelect)
    --icon
    self:SetIcon(partnerData)
    self:SetIconState(state)
    --刷新职业
    self:UpdateCareerItem(partnerData)
    --设置详情描述
    self:SetDeviceDesc(partnerData)
    --设置其他描述
    self:SetOtherDesc(partnerData)
end

function PartnerAssistItem:UpdateCareerItem(partnerData)
    local careerId, careerLv
    local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)

    local deviceInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(self.deviceUniqueId)
    local deviceCfg = PartnerCenterConfig.GetAssetDeviceCfg(deviceInfo.template_id)
    careerId = deviceCfg.career
    for i, v in ipairs(partnerWorkCfg.career) do
        if v[1] == careerId then
            careerLv = v[2]
            break
        end
    end
    
    --优先选择符合设备的职业，如果没有，选择职业等级最高的，如果职业等级都一样，显示id最小的
    if not careerLv then
        careerId, careerLv = PartnerBagConfig.GetPartnerMaxCareerIdAndLvBySort(partnerData.template_id)
    end
    local careerCfg = PartnerBagConfig.GetPartnerWorkCareerCfgById(careerId)
    
    self.node.careerName_txt.text = careerCfg.name
    self.node.careerLv_txt.text = "Lv." .. careerLv
    if careerCfg.icon ~= "" then
        SingleIconLoader.Load(self.node.careerIcon, careerCfg.icon)
    end
end

function PartnerAssistItem:SetDeviceDesc(partnerData)
    local str = TI18N("")
    if partnerData.work_info.work_decoration_id ~= 0 then
        local deviceInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(partnerData.work_info.work_decoration_id)
        local deviceCfg = PartnerCenterConfig.GetAssetDeviceCfg(deviceInfo.template_id)
        str = string.format(TI18N("%s设备中工作"), deviceCfg.name)
    end
    --在哪个物件工作
    self.node.deviceDesc_txt.text = str
end

function PartnerAssistItem:SetOtherDesc(partnerData)
    local desc = TI18N("")
    --符合设备对应的职业才显示
    local deviceInfo = mod.AssetPurchaseCtrl:GetCurAssetDeviceWorkData(self.deviceUniqueId)
    local deviceCfg = PartnerCenterConfig.GetAssetDeviceCfg(deviceInfo.template_id)
    local isHaveCareer = mod.PartnerBagCtrl:CheckPartnerIsHaveCareer(self.uniqueId, deviceCfg.career)
    
    if isHaveCareer then
        local partnerList = {[1] = self.uniqueId}
        local productivity = mod.PartnerCenterCtrl:GetMaterialReturnProductivity(assetProductId, partnerList, deviceCfg.career)
        productivity = productivity or 0
        productivity = math.floor((productivity * 100) + 0.5)

        local cfg = PartnerCenterConfig.GetAssetDeviceProductCfg(assetProductId)
        local parameterVal = cfg.formula_parameter
        parameterVal = math.floor((parameterVal * 0.01) + 0.5)

        desc = SystemConfig.GetCommonValue("AssetPruductBackRewardTip").string_val
        desc = string.format(desc, productivity .. "%", parameterVal .. "%")
    end
    --返还材料的概率
    self.node.desc_txt.text = desc
end

function PartnerAssistItem:SetIcon(partnerData)
    --更新icon
    if not self.iconClass then
        self.iconClass = PoolManager.Instance:Pop(PoolType.class, "CommonItem")
        if not self.iconClass then
            self.iconClass = CommonItem.New()
        end
    end
    self.iconClass:InitItem(self.node.icon, partnerData, true)
    --icon
    self.iconClass:HideEquipedInfo(false)

    UtilsUI.SetActive(self.node.icon, true)
end

function PartnerAssistItem:SetIconState(state)
    if state == FightEnum.PartnerStatusEnum.HungerAndSad or state == FightEnum.PartnerStatusEnum.Sad then
        UtilsUI.SetActive(self.node.sad, true)
        UtilsUI.SetActive(self.node.hunger, false)
    elseif state == FightEnum.PartnerStatusEnum.Hunger then
        UtilsUI.SetActive(self.node.sad, false)
        UtilsUI.SetActive(self.node.hunger, true)
    else
        UtilsUI.SetActive(self.node.sad,false)
        UtilsUI.SetActive(self.node.hunger,false)
    end
end

function PartnerAssistItem:OnClickSelf()
    if self.clickCallback then
        self.clickCallback(self.uniqueId, true)
    end
end

