PartnerBagWorkPanel = BaseClass("PartnerBagWorkPanel", BasePanel)

local jumpId = PartnerBagConfig.PartnerWorkCommonEnum.PartnerFusionJumpId

--初始化
function PartnerBagWorkPanel:__init()
    self:SetAsset("Prefabs/UI/PartnerBag/PartnerBagWorkPanel.prefab")
    
    --ui 
    self.careerObjList = {}
    self.careerAffixObjList = {}
end

--添加监听器
function PartnerBagWorkPanel:__BindListener()
    self.LockButton_btn.onClick:AddListener(self:ToFunc("OnClickLockBtn"))
    self.blendBtn_btn.onClick:AddListener(self:ToFunc("OnClick_BlendBtn"))
    self.allocBtn_btn.onClick:AddListener(self:ToFunc("OnClick_AllocBtn"))
    self.workRuleBtn_btn.onClick:AddListener(self:ToFunc("OnClick_WorkRuleBtn"))
    self.careerRuleBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CareerRuleBtn"))
    self.careerAffixRuleBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CareerAffixRuleBtn"))
end

--缓存对象
function PartnerBagWorkPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end
--
function PartnerBagWorkPanel:__Create()

end

function PartnerBagWorkPanel:__Show(args)
    self.uniqueId = args and args.uniqueId or self.args.uniqueId
    self.showBtn = true
    if self.args and self.args.showBtn ~= nil then
        self.showBtn = self.args.showBtn
    end
    self.partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId) 
    self:UpdateUI()
end

-- 外部调用接口
function PartnerBagWorkPanel:UpdateData(uniqueId)
    self.uniqueId = uniqueId
    self.partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    self:UpdateUI()
end

function PartnerBagWorkPanel:__delete()
    for i, v in pairs(self.careerObjList) do
        self:PushUITmpObject("careerTemp", v.obj)
    end
    self.careerObjList = {}

    for i, v in pairs(self.careerAffixObjList) do
        self:PushUITmpObject("careerAffixTemp", v.obj)
    end
    self.careerAffixObjList = {}
end

function PartnerBagWorkPanel:__Hide()
   
end

function PartnerBagWorkPanel:__ShowComplete()
    
end

function PartnerBagWorkPanel:PartnerInfoChange(oldData, newData)
    if newData.unique_id ~= self.uniqueId then
        return 
    end
    self.partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    self:UpdateUI()
end

function PartnerBagWorkPanel:UpdateUI()
    self:ShowRightBtn(self.showBtn)
    self:UpdateRight()
end

function PartnerBagWorkPanel:UpdateRight()
    self:UpdateRightTop(self.partnerData)
    self.partnerWorkConfig = PartnerBagConfig.GetPartnerWorkConfig(self.partnerData.template_id)
    UtilsUI.SetActive(self.itemContent, self.partnerWorkConfig ~= nil)
    UtilsUI.SetActive(self.NullPanel, not self.partnerWorkConfig)
    UtilsUI.SetActive(self.worked, false)
    if not self.partnerWorkConfig then
        return
    end
    self:UpdateRightFeedAndSanValue(self.partnerData)
    self:UpdateRightCareer(self.partnerData)
    self:UpdateRightWorkState(self.partnerData)
end

function PartnerBagWorkPanel:UpdateRightTop(partnerData)
    local itemConfig = ItemConfig.GetItemConfig(partnerData.template_id)
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerData.template_id)
    --名字
    self.partnerName_txt.text = itemConfig.name
    --图标icon
    SingleIconLoader.Load(self.qualityBg, qualityConfig.icon)
    --lock
    self:SetLockItem(partnerData.is_locked)
end

function PartnerBagWorkPanel:SetLockItem(islock)
    UtilsUI.SetActive(self.Locked, islock)
    UtilsUI.SetActive(self.UnLock, not islock)
end

function PartnerBagWorkPanel:UpdateRightFeedAndSanValue(partnerData)
    local curFeedValue = partnerData.work_info.satiety
    local curSanValue = partnerData.work_info.san
    
    --上限值
    local maxFeed , maxSan = mod.PartnerBagCtrl:GetPartnerMaxFeedAndSanValue(partnerData.unique_id)
    
    self.feedValue_txt.text = string.format(TI18N("%s/%s"), curFeedValue, maxFeed)
    self.sanValue_txt.text = string.format(TI18N("%s/%s"), curSanValue, maxSan)
    self.feedFill_img.fillAmount = curFeedValue / maxFeed
    self.sanFill_img.fillAmount = curSanValue / maxSan
end

function PartnerBagWorkPanel:UpdateRightCareer(partnerData)
    for i, v in pairs(self.careerObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end
    for i, v in pairs(self.careerAffixObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end
    
    --判断职业是否开启，以及月灵是否有职业
    self:UpdateCareer(partnerData)
    self:UpdateCareerAffix(partnerData)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.workRoot.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.careerRoot.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.careerAffixRoot.transform)
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemContent.transform)
end

function PartnerBagWorkPanel:UpdateCareer(partnerData)
    for index, data in ipairs(self.partnerWorkConfig.career) do
        self:InitCareerItem(index, data)
    end
end

function PartnerBagWorkPanel:InitCareerItem(index, data)
    local careerId = data[1]
    local careerLv = data[2]
    if not careerId or careerId == 0 then
        return
    end
    local partnerWorkCareerCfg = PartnerBagConfig.GetPartnerWorkCareerCfgById(careerId)
    if not partnerWorkCareerCfg then
        LogError("月灵职业id对应配置不存在"..careerId)
        return
    end

    local obj
    local objectInfo
    if not self.careerObjList[index] then
        self.careerObjList[index] = {}
        obj = self:PopUITmpObject("careerTemp", self.careerContent.transform)
        objectInfo = UtilsUI.GetContainerObject(obj.object)

        self.careerObjList[index].obj = obj
        self.careerObjList[index].objectInfo = objectInfo
    else
        obj = self.careerObjList[index].obj
        objectInfo = self.careerObjList[index].objectInfo
    end
    UtilsUI.SetActive(obj.object, true)

    --职业名
    objectInfo.name_txt.text = partnerWorkCareerCfg.name
    --职业等级
    objectInfo.level_txt.text = string.format(TI18N("Lv.%s"), careerLv)
    --职业图标
    if partnerWorkCareerCfg.icon ~= "" then
        SingleIconLoader.Load(objectInfo.icon, partnerWorkCareerCfg.icon)
    end
    --注册监听
    objectInfo.bgBtn_btn.onClick:RemoveAllListeners()
    objectInfo.bgBtn_btn.onClick:AddListener(function ()
        self:OnClickCareerTips(careerId, careerLv, PartnerCareerTipsPanel.ShowType.Career)
    end)
end


function PartnerBagWorkPanel:UpdateCareerAffix(partnerData)
    for index, data in ipairs(partnerData.affix_list) do
        self:InitCareerAffixItem(index, data)
    end
end

function PartnerBagWorkPanel:InitCareerAffixItem(index, data)
    local affixId = data.id
    local affixLv = data.level
    local partnerWorkAffixCfg = PartnerBagConfig.GetPartnerWorkAffixCfg(affixId, affixLv)
    if not partnerWorkAffixCfg then
        LogError("月灵职业特性id对应配置不存在"..affixId)
        return
    end

    local obj
    local objectInfo
    if not self.careerAffixObjList[index] then
        self.careerAffixObjList[index] = {}
        obj = self:PopUITmpObject("careerAffixTemp", self.careerAffixContent.transform)
        objectInfo = UtilsUI.GetContainerObject(obj.object)

        self.careerAffixObjList[index].obj = obj
        self.careerAffixObjList[index].objectInfo = objectInfo
    else
        obj = self.careerAffixObjList[index].obj
        objectInfo = self.careerAffixObjList[index].objectInfo
    end
    UtilsUI.SetActive(obj.object, true)


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

function PartnerBagWorkPanel:UpdateRightWorkState(partnerData)
    --是否在工作
    local isWorked = partnerData.work_info.asset_id ~= 0
    if isWorked then
        UtilsUI.SetActive(self.workedIcon, false)
        local assetCfg = AssetPurchaseConfig.GetAssetConfigById(partnerData.work_info.asset_id)
        if assetCfg and assetCfg.icon ~= "" then
            local callback = function()
                UtilsUI.SetActive(self.workedIcon, true)
            end
            SingleIconLoader.Load(self.workedIcon, assetCfg.icon, callback)
        end
    end
    
    UtilsUI.SetActive(self.worked, isWorked)
end

function PartnerBagWorkPanel:ShowRightBtn(isShow)
    UtilsUI.SetActive(self.blendBtnRoot, isShow)
    UtilsUI.SetActive(self.allocBtnRoot, isShow)
end

function PartnerBagWorkPanel:TipHideEvent(className)
    if className == "PartnerBagAssetSelectPanel" then
        self:ShowRightBtn(true)
    end
end

function PartnerBagWorkPanel:OnClickLockBtn()
    if mod.PartnerBagCtrl:LockPartner(self.uniqueId) then
        self:SetLockItem(not self.partnerData.is_locked)
    end
end

--@careerId 职业id/职业特性id
--@careerLv 职业等级
function PartnerBagWorkPanel:OnClickCareerTips(careerId, careerLv, showType)
    PanelManager.Instance:OpenPanel(PartnerCareerTipsPanel, {id = careerId, lv = careerLv, type = showType})
end

function PartnerBagWorkPanel:OnClick_BlendBtn()
    local id = PartnerBagConfig.GetPartnerWorkCommonCfg(jumpId)
    JumpToConfig.DoJump(id)
end

function PartnerBagWorkPanel:OnClick_AllocBtn()
    self:ShowRightBtn(false)
    PanelManager.Instance:OpenPanel(PartnerBagAssetSelectPanel)
end

function PartnerBagWorkPanel:OnClick_WorkRuleBtn()
    PanelManager.Instance:OpenPanel(CommonTipsDescPanel, {key = "PartnerWorkState"} )
end

function PartnerBagWorkPanel:OnClick_CareerRuleBtn()
    PanelManager.Instance:OpenPanel(CommonTipsDescPanel, {key = "PartnerWorkCareer"})
end

function PartnerBagWorkPanel:OnClick_CareerAffixRuleBtn()
    PanelManager.Instance:OpenPanel(CommonTipsDescPanel, {key = "PartnerWorkAffix"})
end



