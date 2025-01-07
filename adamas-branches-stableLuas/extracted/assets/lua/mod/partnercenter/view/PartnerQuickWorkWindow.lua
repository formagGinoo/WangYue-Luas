PartnerQuickWorkWindow = BaseClass("PartnerQuickWorkWindow", BaseWindow)

function PartnerQuickWorkWindow:__init()
    self:SetAsset("Prefabs/UI/PartnerCenter/PartnerQuickWorkWindow.prefab")
    self.curIndex = nil
    self.curUniqueId = nil
    self.firstRefresh = true -- 是否第一次选择
    
    --data
    self.curPartnerList = {}
    
    --ui
    self.itemObjList = {}
    self.careerAffixObjList = {}
end

function PartnerQuickWorkWindow:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("Close"))
    self.CommonButton_Btn_btn.onClick:AddListener(self:ToFunc("OnClickSubmitBtn"))
end

function PartnerQuickWorkWindow:__Show(args)
    self:SetBlurBack()
    local curAssetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    self.uniqueId = args and args.uniqueId or self.args.uniqueId -- 当前选择的佩丛uniqueId
    local curAssetPartnerList = mod.AssetPurchaseCtrl:GetAssetPartnerList(curAssetId)
    for i, v in ipairs(curAssetPartnerList) do
        local data = mod.BagCtrl:GetPartnerData(v)
        table.insert(self.curPartnerList, {uniqueId = v, partnerData = UtilsBase.copytab(data)})
    end
    table.sort(self.curPartnerList, function(a, b)
        local aConfig = ItemConfig.GetItemConfig(a.partnerData.template_id)
        local bConfig = ItemConfig.GetItemConfig(b.partnerData.template_id)
        if aConfig.quality ~= bConfig.quality then
            return aConfig.quality > bConfig.quality
        end
        if a.partnerData.lev ~= b.partnerData.lev then
            return a.partnerData.lev > b.partnerData.lev
        end
    end)
    self:UpdateLeft()
    self:UpdateBtnState()
end

function PartnerQuickWorkWindow:__Hide()
    
end

function PartnerQuickWorkWindow:__delete()
    for i, v in pairs(self.itemObjList) do
        --if v.workItem then
        --    v.workItem:DeleteMe()
        --end
    end
    TableUtils.ClearTable(self.itemObjList)
    if self.leftScrollView_recyceList then
        self.leftScrollView_recyceList:CleanAllCell()
    end
    for i, v in pairs(self.careerAffixObjList) do
        self:PushUITmpObject("careerAffixTemp", v)
    end
    TableUtils.ClearTable(self.careerAffixObjList)
end

function PartnerQuickWorkWindow:UpdateLeft()
    --获取目前所有的在该资产的佩丛
    self.leftScrollView_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.leftScrollView_recyceList:SetCellNum(#self.curPartnerList, true)
end

function PartnerQuickWorkWindow:UpdateRight()
    local partnerData = mod.BagCtrl:GetPartnerData(self.curUniqueId)
    if not self.rightPartnerItemClass then 
        self.rightPartnerItemClass = PartnerWorkItem.New(self.rightWorkItem)
    end
    local data = {
        uniqueId = partnerData.unique_id,
        desc = TI18N("无工作内容安排"), --在哪个设备工作
        showCurSelect = partnerData.unique_id == self.uniqueId,
    }
    data.desc = mod.PartnerBagCtrl:GetPartnerStateText(partnerData.unique_id)
    
    self.rightPartnerItemClass:UpdateUI(data)
    --职业特性
    self:UpdateRightCareerAffix(partnerData)
end

function PartnerQuickWorkWindow:UpdateBtnState()
    --没有选择状态下置灰
    if not self.curUniqueId then
        self.CommonButton_Btn:SetActive(false)
        return
    end
    
    local curPartnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    local curPartnerWorkDeviceId = curPartnerData.work_info.work_decoration_id
    local targetPartnerData = mod.BagCtrl:GetPartnerData(self.curUniqueId)
    local targetPartnerWorkDeviceId = targetPartnerData.work_info.work_decoration_id

    local isCanChange = PartnerCenterConfig.CheckPartnerCanWorkInDevice(curPartnerData.template_id, targetPartnerWorkDeviceId)
    if isCanChange then
        isCanChange = PartnerCenterConfig.CheckPartnerCanWorkInDevice(targetPartnerData.template_id, curPartnerWorkDeviceId)
    end
    
    --更新按钮状态
    --1.与当前交互的佩丛一致 或者 设备id一致 按钮置灰
    --2.当前选择员工没有工作,更换目标也没有工作
    --3.当前选择的员工的职业与更换目标所在的工作需求的职业不符合
    if (self.curUniqueId == self.uniqueId) or (curPartnerWorkDeviceId == targetPartnerWorkDeviceId) then
        self.CommonButton_Btn:SetActive(false)
    elseif curPartnerData.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.None and
            targetPartnerData.work_info.status == PartnerBagConfig.PartnerWorkStatusEnum.None then
        self.CommonButton_Btn:SetActive(false)
    elseif not isCanChange then
        self.CommonButton_Btn:SetActive(false)
    else
        self.CommonButton_Btn:SetActive(true)
    end
end

function PartnerQuickWorkWindow:UpdateRightCareerAffix(partnerData)
    for i, v in pairs(self.careerAffixObjList) do
        UtilsUI.SetActive(v.object, false)
    end
    for index, data in ipairs(partnerData.affix_list) do
        self:InitCareerAffixItem(index, data)
    end
end

function PartnerQuickWorkWindow:InitCareerAffixItem(index, data)
    local affixId = data.id
    local affixLv = data.level
    local partnerWorkAffixCfg = PartnerBagConfig.GetPartnerWorkAffixCfg(affixId, affixLv)
    if not partnerWorkAffixCfg then
        LogError("月灵职业特性id对应配置不存在"..affixId)
        return
    end
    
    local objectInfo
    if not self.careerAffixObjList[index] then
        self.careerAffixObjList[index] = self:GetCareerAffixItem(self.rightCareerContent.transform)
        objectInfo = self.careerAffixObjList[index]
    else
        objectInfo = self.careerAffixObjList[index]
    end
    UtilsUI.SetActive(objectInfo.object, true)


    --职业特性名 
    objectInfo.name_txt.text = partnerWorkAffixCfg.name
    --职业特性等级
    objectInfo.level_txt.text = string.format(TI18N("Lv.%s"), affixLv)
    --职业特性图标
    if partnerWorkAffixCfg.icon ~= "" then
        SingleIconLoader.Load(objectInfo.icon, partnerWorkAffixCfg.icon)
    end
    --注册监听
    objectInfo.bgBtn_btn.onClick:RemoveAllListeners()
    objectInfo.bgBtn_btn.onClick:AddListener(function ()
        self:OnClickCareerTips(affixId, affixLv, PartnerCareerTipsPanel.ShowType.CareerAffix)
    end)
end


function PartnerQuickWorkWindow:RefreshItemCell(index, go)
    if not go then
        return
    end
   
    local itemInfo
    local workItem
    if not self.itemObjList[index] then
        self.itemObjList[index] = {}
        itemInfo = UtilsUI.GetContainerObject(go)
        workItem = PartnerWorkItem.New(itemInfo.PartnerWorkItem)
        self.itemObjList[index].itemInfo = itemInfo
        self.itemObjList[index].workItem = workItem
    else
        itemInfo = self.itemObjList[index].itemInfo
        workItem = self.itemObjList[index].workItem
    end
    
    local partnerData = self.curPartnerList[index].partnerData
    
    local data = {
        parent = go.transform,
        uniqueId = partnerData.unique_id,
        desc = TI18N("无工作内容安排"), --在哪个设备工作
        clickCallback = function ()
            self:SingleSelect(index)
            self:selectPartnerFunc(partnerData.unique_id)
        end,
        showCurSelect = partnerData.unique_id == self.uniqueId,
    }
    
    if self.firstRefresh and self.uniqueId == partnerData.unique_id then
        data.clickCallback()
        self.firstRefresh = false
    end
    
    data.desc = mod.PartnerBagCtrl:GetPartnerStateText(partnerData.unique_id)
    workItem:UpdateUI(data)
    self:UpdateSelect(index)
end

function PartnerQuickWorkWindow:SingleSelect(index)
    if self.curIndex then
        --隐藏之前的选中框
        self.itemObjList[self.curIndex].itemInfo.select:SetActive(false)
    end
    self.curIndex = index
    self.itemObjList[self.curIndex].itemInfo.select:SetActive(true)
end

function PartnerQuickWorkWindow:UpdateSelect(index)
    if self.curIndex == index then
        self.itemObjList[index].itemInfo.select:SetActive(true)
    else
        self.itemObjList[index].itemInfo.select:SetActive(false)
    end
end

function PartnerQuickWorkWindow:GetCareerAffixItem(parent)
    local obj = self:PopUITmpObject("careerAffixTemp", parent)
    --UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)


    return obj
end

function PartnerQuickWorkWindow:selectPartnerFunc(uniqueId)
    self.curUniqueId = uniqueId
    self:UpdateRight()
    self:UpdateBtnState()
end

--@careerId 职业id/职业特性id
--@careerLv 职业等级
function PartnerQuickWorkWindow:OnClickCareerTips(careerId, careerLv, showType)
    PanelManager.Instance:OpenPanel(PartnerCareerTipsPanel, {id = careerId, lv = careerLv, type = showType})
end

function PartnerQuickWorkWindow:OnClickSubmitBtn()
    if not self.curUniqueId then
        return
    end
    if not self.uniqueId then
        return
    end
    
    --符合条件调用替换工作协议
    mod.PartnerCenterCtrl:ReplacePartnerWorkDevice(self.uniqueId, self.curUniqueId)
    self:Close()
end

function PartnerQuickWorkWindow:Close()
    WindowManager.Instance:CloseWindow(self)
end
