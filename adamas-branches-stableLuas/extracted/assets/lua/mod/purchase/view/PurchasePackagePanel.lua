PurchasePackagePanel = BaseClass("PurchasePackagePanel", BasePanel)

function PurchasePackagePanel:__init()
    self:SetAsset("Prefabs/UI/Purchase/PurchasePackagePanel.prefab")
    self.typeObjList = {}
    self.packageObjList = {}
    self.packagesList = {}
end

function PurchasePackagePanel:__BindListener()
    --self:SetHideNode("PurchasePackagePanel_Eixt")
    --self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("Close_HideCallBack"), self:ToFunc("OnBack"))
    EventMgr.Instance:AddListener(EventName.GetPurchasePackage, self:ToFunc("ShowInfo"))
    EventMgr.Instance:AddListener(EventName.GetPurchasePackage, self:ToFunc("CheckTypeList"))
end

function PurchasePackagePanel:__CacheObject()

end

function PurchasePackagePanel:__Create()
    self.defaultSelect = 1
    self:CreateTypeList()

    local args = self.args or {}
    local selectType = args._jump and args._jump[1]
    if selectType then
        selectType = tonumber(selectType)
        self.tabPanel:SelectType(selectType)
    end
end

function PurchasePackagePanel:__delete()
    for k, v in pairs(self.packageObjList) do
        PoolManager.Instance:Push(PoolType.class, "PurchaseCommonPackage", v.commonPackages)
    end
    self.packageObjList = {}
    EventMgr.Instance:RemoveListener(EventName.GetPurchasePackage, self:ToFunc("ShowInfo"))
    EventMgr.Instance:RemoveListener(EventName.GetPurchasePackage, self:ToFunc("CheckTypeList"))

end

function PurchasePackagePanel:__ShowComplete()
    if self.curType then
        self:SelectType(self.curType)
    end
end

function PurchasePackagePanel:__Hide()
end

function PurchasePackagePanel:__Show()
end

function PurchasePackagePanel:CheckTypeList()
    local tempList = {}
    for page, typeInfo in pairs(self.typeObjList) do
        if mod.PurchaseCtrl:GetPackageList(page) 
        and next(mod.PurchaseCtrl:GetPackageList(page)) 
        and mod.PurchaseCtrl:CheckCanSeeItemByPage(page) then
            tempList[page] = self.typeObjList[page]
        else
            GameObject.Destroy(self.typeObjList[page].object)
        end
    end
    self.typeObjList = tempList
end

function PurchasePackagePanel:CreateTypeList()
    local tabList = {}
    local i = 1
    for k, info in pairs(PurchaseConfig:GetPackagePage()) do
        table.insert(tabList, { type = i, page = info.id, name = info.name, callback = function(parent, isSelect)
            if isSelect then
                self:ActivePackagesInteract(info)
            end
        end })
        i = i + 1
    end

    for _, typeInfo in pairs(tabList) do
        ---检查是否显示页签
        if mod.PurchaseCtrl:GetPackageList(typeInfo.page) 
        and next(mod.PurchaseCtrl:GetPackageList(typeInfo.page)) 
        and mod.PurchaseCtrl:CheckCanSeeItemByPage(typeInfo.page)then
            local typeObj = self:GetTypeObj()
            local redPointIndex = PurchaseConfig.PackageTypeRedPoint[typeInfo.type]
            if redPointIndex then
                self:BindRedPoint(redPointIndex, typeObj.RedPoint)
            end
            
            typeObj.UTypeName_txt.text = typeInfo.name
            typeObj.STypeName_txt.text = typeInfo.name
            typeObj.callback = typeInfo.callback
            local onToggleFunc = function(isEnter)
                self:OnToggle_Type(typeInfo.type, isEnter)
            end
            local hideCb = function()
                typeObj.Selected:SetActive(false)
            end
            typeObj.SingleType_tog.onValueChanged:RemoveAllListeners()
            typeObj.SingleType_tog.onValueChanged:AddListener(onToggleFunc)
            typeObj.object:SetActive(true)
            self.typeObjList[typeInfo.type] = typeObj
        end
    end
    if self.defaultSelect then
        self:SelectType(self.defaultSelect)
    end
end

function PurchasePackagePanel:ActivePackagesInteract(interactInfo)
    self.packagePageId = interactInfo.id
    self:ShowInfo(self.packagePageId)
end

function PurchasePackagePanel:ShowInfo()
    local oldPackageList = self.packagesList[self.packagePageId]
    self.packagesList[self.packagePageId] = mod.PurchaseCtrl:GetPackageList(self.packagePageId)
    self:AnalysisPackageList()
    self.isMod = not UtilsBase.sametab(self.packagesList[self.packagePageId], oldPackageList)
    self:RefreshScroll()
end

function PurchasePackagePanel:AnalysisPackageList()
    local newList = {}
    for i, info in ipairs(self.packagesList[self.packagePageId]) do
        local packageId = info.id
        if mod.PurchaseCtrl:GetPackageBuyRecord(packageId) < info.buy_limit or
        info.soldout_show == true then
            table.insert(newList, info)
        end
    end
    local sortfun = function(a,b)
        local conditionA = a.buy_limit > mod.PurchaseCtrl:GetPackageBuyRecord(a.id)
        local conditionB = b.buy_limit > mod.PurchaseCtrl:GetPackageBuyRecord(b.id)
        if conditionA and not conditionB then
            return true
        elseif not conditionA and conditionB then
            return false
        else
            return a.priority > b.priority
        end
    end
    table.sort(newList, sortfun)
    self.packagesList[self.packagePageId] = newList
end

function PurchasePackagePanel:RefreshScroll()
    local AwardCount = TableUtils.GetTabelLen(self.packagesList[self.packagePageId] or {})
    local listNum = AwardCount
    local scroll = self.PackageList.transform:GetComponent(ScrollRect)
    scroll.inertia = false
    LuaTimerManager.Instance:AddTimer(1,0.1, function()
        scroll.inertia = true
    end)
    if not self.packages then
        self.packages = {}
    end

    if not self.packages[self.packagePageId] then
        self.packages[self.packagePageId] = {}
    elseif self.isMod == true then
        for k, data in pairs(self.packages[self.packagePageId]) do
            GameObject.Destroy(data.gameObject)
        end
        self.packages[self.packagePageId] = {}
    end

    for _, page in pairs(self.packages) do
        if page and next(page) then
            for k, item in pairs(page) do
                UtilsUI.SetActive(item.gameObject,false)
            end
        end
    end
    for k, info in pairs(self.packagesList[self.packagePageId]) do
        if not self.packages[self.packagePageId][info.id] then
            local go = GameObject.Instantiate(self.PackageItem,self.PackageItem.transform.parent)
            self.packages[self.packagePageId][info.id] = {gameObject = go, info = info}
            self:InitCell(info.id,go)
        else
            self:RefreshCell(info.id)
        end
    end
end

function PurchasePackagePanel:RefreshCell(id)
    local data = self.packages[self.packagePageId][id]
    UtilsUI.SetActive(data.gameObject, true)
    data.commonPackages:InitPackages(data.gameObject, data.info, 10000, true)
    -- local onClickFunc = function()
    --     self:OnClick_SinglePackages(data.info)
    -- end
    -- data.commonPackages:SetBtnEvent(false, onClickFunc)
end

function PurchasePackagePanel:InitCell(id, go)
    if not go then
        return
    end
    local commonPackages = PurchaseCommonPackage.New()
    local index
    for i, info in pairs(self.packagesList[self.packagePageId]) do
        if info.id == id then
            index = i
        end
    end
    commonPackages:InitPackages(go, self.packagesList[self.packagePageId][index], 10000, true)
    local onClickFunc = function()
        self:OnClick_SinglePackages(self.packagesList[self.packagePageId][index])
    end
    commonPackages:SetBtnEvent(false, onClickFunc)
    self.packages[self.packagePageId][id].commonPackages = commonPackages
end

function PurchasePackagePanel:OnClick_SinglePackages(info)
    local panelClass = PanelManager.Instance:GetPanel(PurchasePackagePreviewPanel)
    if panelClass then
        return
    end
    PanelManager.Instance:OpenPanel(PurchasePackagePreviewPanel, { packagePageId = self.packagePageId, data = info })
end

function PurchasePackagePanel:SelectType(typeId)
    local typeObj = self.typeObjList[typeId]
    if typeObj then
        if typeObj.SingleType_tog.isOn == true then
            self:OnToggle_Type(typeId, true)
        end
        typeObj.SingleType_tog.isOn = true
    end
end

function PurchasePackagePanel:OnToggle_Type(typeId, isEnter)
    self.curType = typeId
    local typeObj = self.typeObjList[typeId]
    if not typeObj then
        return
    end

    if isEnter then
        typeObj.Selected:SetActive(true)
        --typeObj.Selected_ShowNode:SetActive(false)
        typeObj.UnSelect:SetActive(false)
    else
        typeObj.Selected:SetActive(false)
        --typeObj.Selected_HideNode:SetActive(false)
        typeObj.UnSelect:SetActive(true)
    end

    typeObj.callback(self, typeObj.SingleType_tog.isOn)
end

function PurchasePackagePanel:GetTypeObj()
    local obj = self:PopUITmpObject("SingleType")
    if self.closeSound then
        --obj.SingleType_sound.notActive = true
    else
        --obj.SingleType_sound.notActive = false
    end
    obj.objectTransform:SetParent(self.TypeList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    return obj
end
