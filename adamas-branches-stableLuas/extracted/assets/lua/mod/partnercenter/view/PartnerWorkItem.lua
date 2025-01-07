PartnerWorkItem = BaseClass("PartnerWorkItem", BaseView)
--佩丛工作item

local itemPrefab = "Prefabs/UI/PartnerCenter/PartnerWorkItem.prefab"

--[[
    parent : 父节点
    clickCallback : 点击callback
    isCanDrag : 是否打开drag操作
]]--
function PartnerWorkItem:__init(obj)
    --self:SetItemInfo(itemInfo)

    self.careerObjList = {}
    self.itemObjectName = "PartnerWorkItem"
    self.assetLoader = AssetMgrProxy.Instance:GetLoader("PartnerWorkItemLoader")
    self.object = obj
    if not self.object then
        self:LoadItem()
        self.loadObj = true
    end
end

function PartnerWorkItem:SetItemInfo(itemInfo)
    self.parent = itemInfo.parent
    self.uniqueId = itemInfo.uniqueId
    self.descText = itemInfo.desc
    self.showCurSelect = itemInfo.showCurSelect or false

    --UI系列事件
    self.clickCallback = itemInfo.clickCallback
end

function PartnerWorkItem:__delete()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    if self.iconClass then
        self.iconClass:DeleteMe()
    end
    if self.node.careerScrollView_recyceList then
        self.node.careerScrollView_recyceList:CleanAllCell()
    end
    TableUtils.ClearTable(self.careerObjList)
    
    if self.loadObj and self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
end

function PartnerWorkItem:CreatItem()
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

function PartnerWorkItem:LoadItem()
    local item = self:CreatItem()

    if item then
        self.object = item
        --self:InitItem()
    end
end

function PartnerWorkItem:LoadDone()
    self:InitItem()
end

function PartnerWorkItem:InitItem()
    if self.parent then
        --设置父节点
        UtilsUI.AddUIChild(self.parent, self.object)
    end
    UtilsUI.SetActive(self.object, true)
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    
    --绑定点击事件
    self.node.bg_btn.onClick:RemoveAllListeners()
    self.node.bg_btn.onClick:AddListener(self:ToFunc("OnClickSelf"))
    self:BindListener()
    --根据id获取配置数据
    self:UpdateItem()
end

function PartnerWorkItem:BindListener()

end

function PartnerWorkItem:UpdateUI(itemInfo)
    self:SetItemInfo(itemInfo)
    self:InitItem()
    if itemInfo.itemMap then
        itemInfo.itemMap.SelectImg:SetActive(itemInfo.showCurSelect)
    end
end

function PartnerWorkItem:UpdateItem()
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    local state = mod.PartnerBagCtrl:GetAssetPartnerState(self.uniqueId)
    self.node.curSelect:SetActive(self.showCurSelect)
    --icon
    self:SetIcon(partnerData)
    self:SetIconState(state)
    --刷新职业
    self:UpdateCareerItem(partnerData)
    --设置详情描述
    self:SetDesc(partnerData)
end

function PartnerWorkItem:UpdateCareerItem(partnerData)
    if self.node.careerScrollView_recyceList then
        self.node.careerScrollView_recyceList:CleanAllCell()
    end
    TableUtils.ClearTable(self.careerObjList)
    local partnerWorkCfg = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    if not partnerWorkCfg then
        return
    end

    self.careerList = {}
    for i, v in ipairs(partnerWorkCfg.career) do
        if v[1] ~= 0 then
            table.insert(self.careerList, v)
        end
    end
    
    self.node.careerScrollView_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.node.careerScrollView_recyceList:SetCellNum(#self.careerList, true)
end

function PartnerWorkItem:RefreshItemCell(index, go)
    if not go then
        return
    end
    
    local objInfo
    if not self.careerObjList[index] then
        objInfo = UtilsUI.GetContainerObject(go.transform)
        self.careerObjList[index] = objInfo
    else
        objInfo = self.careerObjList[index]
    end
    UtilsUI.SetActive(go.transform, true)
    
    local data = self.careerList[index]
    local careerCfg = PartnerBagConfig.GetPartnerWorkCareerCfgById(data[1])

    objInfo.name_txt.text = careerCfg.name
    objInfo.lv_txt.text = "Lv." .. data[2]
    if careerCfg.icon ~= "" then
        SingleIconLoader.Load(objInfo.icon, careerCfg.icon)
    end
end

function PartnerWorkItem:SetDesc(partnerData)
   --在哪个物件工作
    self.node.desc_txt.text = self.descText
end

function PartnerWorkItem:SetIcon(partnerData)
    --更新icon
    if not self.iconClass then
        self.iconClass = CommonItem.New()
    end
    self.iconClass:InitItem(self.node.icon, partnerData, true)
    --icon
    self.iconClass:HideEquipedInfo(false)
    
    UtilsUI.SetActive(self.node.icon, true)
end

function PartnerWorkItem:SetIconState(state)
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

function PartnerWorkItem:OnClickSelf()
    if self.clickCallback then
        self.clickCallback(self.uniqueId, true)
    end
end

