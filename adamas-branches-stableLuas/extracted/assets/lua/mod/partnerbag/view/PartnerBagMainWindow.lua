PartnerBagMainWindow = BaseClass("PartnerBagMainWindow", BaseWindow)

local _tinsert = table.insert

local modelRoot = "PartnerRoot"

local emptyCameraRotation = Vec3.New(0,180,0)

--预留参数 todo 
--@partnerUniqueId 月灵unique_id
--@initTag 月灵详情界面选择的左边标签
function PartnerBagMainWindow.OpenWindow(partnerUniqueId, initTag)
    --加载场景
    Fight.Instance.modelViewMgr:LoadView(ModelViewConfig.ViewType.PartnerBag, function ()
        local partnerBagView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
        partnerBagView:LoadScene(ModelViewConfig.Scene.PartnerBag, function()
            Fight.Instance.modelViewMgr:ShowView(ModelViewConfig.ViewType.PartnerBag)
            partnerBagView:BlendToNewCamera(Vec3.zero, emptyCameraRotation)
            --打开界面UI
            WindowManager.Instance:OpenWindow(PartnerBagMainWindow, {unique_id = partnerUniqueId, _jump = { [1] = initTag} })
            BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(false)
        end)
    end)
end

function PartnerBagMainWindow:__init()
    self:SetAsset("Prefabs/UI/PartnerBag/PartnerBagMainWindow.prefab")

    
    --ui 
    self.itemObjList = {}
    self.skillObjList = {}
    self.careerObjList = {}
    self.careerAffixObjList = {}
    
end

function PartnerBagMainWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function PartnerBagMainWindow:__ShowComplete()

end

function PartnerBagMainWindow:__BindListener()
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("OnClickClose"))
    self.detailsBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Details"))
    self.careerRuleBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CareerRuleBtn"))
    self.careerAffixRuleBtn_btn.onClick:AddListener(self:ToFunc("OnClick_CareerAffixRuleBtn"))
end

function PartnerBagMainWindow:__Create()
    
end

function PartnerBagMainWindow:__RepeatShow()
    
end

function PartnerBagMainWindow:__Show()
    self:OpenPanel(PartnerSelectPanel,{
        selectPartnerFunc = self:ToFunc("SelectPartner"),
        showPartnerFunc = self:ToFunc("ShowRightPartner"),
    })
end

function PartnerBagMainWindow:__Hide()

end

function PartnerBagMainWindow:__delete()
    for i, v in pairs(self.skillObjList) do
        self:PushUITmpObject("skillTemp", v.obj)
    end
    self.skillObjList = {}
    
    for i, v in pairs(self.careerObjList) do
        self:PushUITmpObject("careerTemp", v.obj)
    end
    self.careerObjList = {}

    for i, v in pairs(self.careerAffixObjList) do
        self:PushUITmpObject("careerAffixTemp", v.obj)
    end
    self.careerAffixObjList = {}

end

function PartnerBagMainWindow:SetCameraSetings(partnerData)
    local partner = partnerData and partnerData.template_id or 0
    local cameraConfig = RoleConfig.GetPartnerCameraConfig(partner, RoleConfig.PartnerCameraType.PartnerBag)
    local partnerBagView = Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)

    partnerBagView:BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
    partnerBagView:SetModelRotation(modelRoot, cameraConfig.model_rotation)
    partnerBagView:PlayModelAnim(modelRoot, cameraConfig.anim, 0.5)

    --local blurConfig = RoleConfig.GetPartnerBlurConfig(partner, RoleConfig.PartnerCameraType.PartnerBag)
    --partnerBagView:SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
end

function PartnerBagMainWindow:UpdateModel(partnerData)
    if not partnerData then      
        return
    end
    
    if partnerData and self.curShowPartnerTemplateId == partnerData.template_id then
        return
    end
    local onLoad = function()
        self.curShowPartnerTemplateId = partnerData.template_id
        self:SetCameraSetings(partnerData)
    end
    --加载模型
    self:GetModelView():LoadModel(modelRoot, partnerData.template_id, onLoad)
end

function PartnerBagMainWindow:ShowPartnerModel(isShow)
    self:GetModelView():ShowModel(modelRoot, isShow)
end

function PartnerBagMainWindow:GetModelView()
    return Fight.Instance.modelViewMgr:GetView(ModelViewConfig.ViewType.PartnerBag)
end

function PartnerBagMainWindow:UpdateUI(partnerData)
    if not partnerData then
        return
    end
    if partnerData.unique_id ~= self.curUniqueId then
        return 
    end
    self:UpdateRight(partnerData)
end

function PartnerBagMainWindow:UpdateRight(partnerData)
    self:UpdateRightTop(partnerData)
    self:UpdateRightSkill(partnerData)
    self:UpdateRightCareer(partnerData)
    self:UpdateRightWorkState(partnerData)
end

function PartnerBagMainWindow:UpdateRightTop(partnerData)
    local itemConfig = ItemConfig.GetItemConfig(partnerData.template_id)
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerData.template_id)
    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerData.template_id)
    --名字
    self.partnerName_txt.text = itemConfig.name
    --图标icon
    SingleIconLoader.Load(self.qualityBg, qualityConfig.icon)
    --等级
    self.curLevel_txt.text = partnerData.lev
    self.levelLimit_txt.text = maxLev
    --lock 
    self.LockButton_btn.onClick:RemoveAllListeners()
    self.LockButton_btn.onClick:AddListener(function ()
        mod.PartnerBagCtrl:LockPartner(partnerData.unique_id)
    end)
    UtilsUI.SetActive(self.Locked, partnerData.is_locked == true)
    UtilsUI.SetActive(self.UnLock, partnerData.is_locked == false)
end

function PartnerBagMainWindow:UpdateRightSkill(partnerData)
    for i, v in pairs(self.skillObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end
    
    local curPartnerHasSkillList = TableUtils.CopyTable(partnerData.skill_list)
    for i, v in ipairs(partnerData.asset_skill_list) do
        _tinsert(curPartnerHasSkillList, {key = v, value = 1})
    end
    for index, value in pairs(curPartnerHasSkillList) do
        local skillId = value.key 
        local skillLev = value.value
        self:InitSkillItem(index, skillId)
    end
end

function PartnerBagMainWindow:InitSkillItem(index, skillId)
    local obj
    local objectInfo
    if not self.skillObjList[index] then
        self.skillObjList[index] = {}
        obj = self:PopUITmpObject("skillTemp", self.skillContent.transform)
        UnityUtils.SetLocalPosition(obj.object.transform, 0, 0, 0)
        UnityUtils.SetLocalScale(obj.object.transform, 1, 1, 1)
        objectInfo = UtilsUI.GetContainerObject(obj.object)
        
        self.skillObjList[index].obj = obj
        self.skillObjList[index].objectInfo = objectInfo
    else
        obj = self.skillObjList[index].obj
        objectInfo = self.skillObjList[index].objectInfo
    end
    UtilsUI.SetActive(obj.object, true)
    
    local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
    --技能品质
    objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
    --技能图标
    SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon, function ()
        UtilsUI.SetActive(objectInfo.SkillIcon, true)
    end)
    
    objectInfo.TalentSkillText_txt.text = baseConfig.tag_text
    UtilsUI.SetActive(objectInfo.TalentSkillIcon, true)
    
    objectInfo.Button_btn.onClick:RemoveAllListeners()
    objectInfo.Button_btn.onClick:AddListener(function()
        PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
            skillId = skillId,
            uniqueId = self.curUniqueId
        })
    end)
end

function PartnerBagMainWindow:UpdateRightCareer(partnerData)
    local isOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerWork)
    
    for i, v in pairs(self.careerObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end
    for i, v in pairs(self.careerAffixObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end

    UtilsUI.SetActive(self.careerRoot, false)
    UtilsUI.SetActive(self.line3, false)
    UtilsUI.SetActive(self.careerAffixRoot, false)

    if not isOpen then 
        return
    end
    
    --判断职业是否开启，以及月灵是否有职业
    self:UpdateCareer(partnerData)
    self:UpdateCareerAffix(partnerData)
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.itemContent.transform)
    end)
end

function PartnerBagMainWindow:UpdateCareer(partnerData)
    local partnerWorkConfig = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    if not partnerWorkConfig then
        return 
    end
    
    for index, data in ipairs(partnerWorkConfig.career) do
        self:InitCareerItem(index, data)
    end

    UtilsUI.SetActive(self.careerRoot, true)
    UtilsUI.SetActive(self.line3, true)
end

function PartnerBagMainWindow:InitCareerItem(index, data)
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
        UnityUtils.SetLocalPosition(obj.object.transform, 0, 0, 0)
        UnityUtils.SetLocalScale(obj.object.transform, 1, 1, 1)
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
        self:OnClickCareerTips(careerId, careerLv)
    end)
end

function PartnerBagMainWindow:UpdateCareerAffix(partnerData)
    for index, data in ipairs(partnerData.affix_list) do
        self:InitCareerAffixItem(index, data)
    end
    UtilsUI.SetActive(self.careerAffixRoot, #partnerData.affix_list > 0)
end

function PartnerBagMainWindow:InitCareerAffixItem(index, data)
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
        UnityUtils.SetLocalPosition(obj.object.transform, 0, 0, 0)
        UnityUtils.SetLocalScale(obj.object.transform, 1, 1, 1)
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

function PartnerBagMainWindow:UpdateRightWorkState(partnerData)
    --是否在资产中
    local isWorked = partnerData.work_info.asset_id ~= 0
    --是否已装备
    local isEquiped = partnerData.hero_id ~= 0
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
    
    if isEquiped then
        local roleCfg = RoleConfig.GetRoleConfig(partnerData.hero_id)
        if roleCfg and roleCfg.rhead_icon ~= "" then
            SingleIconLoader.Load(self.equipedIcon, roleCfg.rhead_icon)
        end
        self.equipedDes_txt.text = roleCfg.name..TI18N("已装备")
    end
    UtilsUI.SetActive(self.worked, isWorked)
    UtilsUI.SetActive(self.equiped, isEquiped)
end

--@careerId 职业id/职业特性id
--@careerLv 职业等级
function PartnerBagMainWindow:OnClickCareerTips(careerId, careerLv, showType)
    PanelManager.Instance:OpenPanel(PartnerCareerTipsPanel, {id = careerId, lv = careerLv, type = showType})
end

function PartnerBagMainWindow:OnClickClose()
    BehaviorFunctions.fight.clientFight.cameraManager:GetCurCamera().camera:SetActive(true)
    Fight.Instance.modelViewMgr:HideView(ModelViewConfig.ViewType.PartnerBag)
    WindowManager.Instance:CloseWindow(self)
end

function PartnerBagMainWindow:OnClick_Details()
    --self:GetModelView():RecordBlur()
    WindowManager.Instance:OpenWindow(PartnerBagDetailsWindow, {unique_id = self.curUniqueId})
end

function PartnerBagMainWindow:OnClick_CareerRuleBtn()
    PanelManager.Instance:OpenPanel(CommonTipsDescPanel, {key = "PartnerWorkCareer"})
end

function PartnerBagMainWindow:OnClick_CareerAffixRuleBtn()
    PanelManager.Instance:OpenPanel(CommonTipsDescPanel, {key = "PartnerWorkAffix"})
end

function PartnerBagMainWindow:SelectPartner(unique_id)
    self.curUniqueId = unique_id
    local partnerData = mod.BagCtrl:GetPartnerData(unique_id)
    self:UpdateModel(partnerData)
    self:UpdateUI(partnerData)
end

function PartnerBagMainWindow:ShowRightPartner(show)
    self.Right:SetActive(show)
    self:ShowPartnerModel(show)
end