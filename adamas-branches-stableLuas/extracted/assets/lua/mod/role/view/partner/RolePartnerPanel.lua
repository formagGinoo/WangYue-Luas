RolePartnerPanel = BaseClass("RolePartnerPanel", BasePanel)

local PartnerIndex = "PartnerRoot"
local _tinsert = table.insert

local ButtonState = {
    Replace = 1,
    Equip = 2,
    Cur = 3,
}

local SelectState = {
    NotSelect = 1,
    Select = 2,
}

local PageIndex = {
    Attr = "Attribute",
    PassiveSkill = "PassiveSkill",
}

local MaxTalentSkillNum = 6
local MaxPassiveSkillNum = 9
local ShowSkillRowNum = 2 --一行俩
local ShowSkillLessRowNum = 4 --最少四个
local UnActiveAlpha = Color(1, 1, 1, 0.3)
local ActiveAlpha = Color(1, 1, 1, 1)
local TextUnActiveAlpha = Color(0.92941, 0.92941,0.92941, 0.5)
local TextActiveAlpha = Color(0.92941, 0.92941,0.92941, 1)

function RolePartnerPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Partner/RolePartnerPanel.prefab")
    self.cacheMap = {}
    self.objectMap = {}
    self.skillItemObjList = {}
end

--添加监听器
function RolePartnerPanel:__BindListener()
    self.OpenListButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenList"))
    self.NullMask_btn.onClick:AddListener(self:ToFunc("OnClick_OpenList"))
    self.EquipButton_btn.onClick:AddListener(self:ToFunc("OnClick_ReplaceButton"))
    for key, index in pairs(PageIndex) do
        self[index .. "Toggle_tog"].onValueChanged:AddListener(function(isEnter)
            if isEnter then
                self:ChangePage(index, self.curSelect or self:GetRolePartner())
            end
        end
        )
    end
    self.BGButton_btn.onClick:AddListener(self:ToFunc("OnClick_BGButton"))
    self.LevelUpButton_btn.onClick:AddListener(self:ToFunc("OnClick_Upgrade"))
    self.PreviewButton_btn.onClick:AddListener(self:ToFunc("UnlockSkillPreView"))
    self.AttributeDetailButton_btn.onClick:AddListener(self:ToFunc("OnClick_AttributeDetail"))
    EventMgr.Instance:AddListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    EventMgr.Instance:AddListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeRoleModel"))
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:AddListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    EventMgr.Instance:AddListener(EventName.TipHideEvent, self:ToFunc("TipHideEvent"))

end

--缓存对象
function RolePartnerPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end

function RolePartnerPanel:__Create()
    self.AttrScroll_scroll = self.AttrScroll.transform:GetComponent(ScrollRect)
    local modelView = self:GetModelView()
    local canvas = modelView:GetTargetTransform("RolePartnerCanvas", true)
    self.RolePartner3D = canvas
    self.RolePartner3DInfo = {}
    UtilsUI.GetContainerObject(self.RolePartner3D, self.RolePartner3DInfo)
    self.RolePartnerSetting3D = canvas.gameObject.transform:Find("RolePartnerRoot_/PartnerTalent3DPanel"):GetComponent(UIAnimationSetting)
    UtilsUI.SetHideCallBack(self.RolePartnerSetting3D.HideNode, self:ToFunc("Panel3D_HideCallBack"))
end

function RolePartnerPanel:__delete()
    for i, v in pairs(self.skillItemObjList) do
        for _, obj in pairs(v.skillItemList) do
            self:PushUITmpObject("SkillItem3D", obj, self.CacheRoot.transform)
        end
        self:PushUITmpObject("skillObj", v.obj, self.CacheRoot.transform)
    end
    TableUtils.ClearTable(self.skillItemObjList)
    EventMgr.Instance:RemoveListener(EventName.ChangeShowRole, self:ToFunc("ChangeShowRole"))
    EventMgr.Instance:RemoveListener(EventName.ShowRoleModelLoad, self:ToFunc("ChangeRoleModel"))
    EventMgr.Instance:RemoveListener(EventName.RoleInfoUpdate, self:ToFunc("RoleInfoUpdate"))
    EventMgr.Instance:RemoveListener(EventName.PartnerInfoChange, self:ToFunc("PartnerInfoChange"))
    EventMgr.Instance:RemoveListener(EventName.TipHideEvent, self:ToFunc("TipHideEvent"))
end

function RolePartnerPanel:__Hide()
    self:GetModelView():ShowModel(PartnerIndex)
    self.RolePartnerSetting3D:PlayExitAnimator()
end

function RolePartnerPanel:__Show()
    if self.args.uid then
        self.uid = self.args.uid 
        UtilsUI.SetActiveByScale(self.LockButton,false)
        UtilsUI.SetActiveByScale(self.OpenList,false)
        UtilsUI.SetActiveByScale(self.Equip,false)
        UtilsUI.SetActiveByScale(self.LevelUpButton,false)
        UtilsUI.SetActiveByScale(self.PreviewButton,false)
        UtilsUI.SetActiveByScale(self.NullMaskImg, false)
        self.NullMask_btn.enabled = false
    end

    self.BGButton:SetActive(false)
    self.selectState = SelectState.NotSelect
    self:ChangeShowRole(self:GetCurRole())
    self:SetModelView()
    self:LoadPartner(self.curSelect)
    self.RolePartnerSetting3D:PlayEnterAnimator()
    
    if self.args.uniqueId then
        self:OnClick_OpenList(self.args.uniqueId)
    end
end

function RolePartnerPanel:__ShowComplete()

end

function RolePartnerPanel:TipHideEvent(className)
    if className and className == "PartnerMainWindow" then
        self.AttrScroll_scroll.inertia = false
        LuaTimerManager.Instance:AddTimer(1,0.1, function()
            self.AttrScroll_scroll.inertia = true
            UnityUtils.SetAnchoredPosition(self.AttrContent.transform, 0, 0)
        end)
    end
end
--角色信息改变
function RolePartnerPanel:RoleInfoUpdate(index, roledata)
    if roledata.id == self:GetCurRole() then
        if self.curSelect and self.curSelect == roledata.partner_id then
            self:SetButtonState(ButtonState.Cur)
        elseif roledata.partner_id == 0 then
            self:SetButtonState(ButtonState.Equip)
        end
    end
end


--月灵信息变化
function RolePartnerPanel:PartnerInfoChange(oldData, newData)
    if not self.active or oldData.hero_id ~= newData.hero_id then
        return
    end
    if self.curSelect and self.curSelect == newData.unique_id then
        self:UpdateShow(self.curSelect)
    elseif newData.unique_id == self:GetRolePartner() then
        self:UpdateShow()
    end
    UtilsUI.SetActive(self.Locked, newData.is_locked == true)
    UtilsUI.SetActive(self.UnLock, newData.is_locked == false)
end

--改变当前角色
function RolePartnerPanel:ChangeShowRole()
    if not self.active then
        return
    end
   
    --self.parentWindow:ClosePanel(ItemSelectPanel)
    -- local selectpanel = self.parentWindow:GetPanel(ItemSelectPanel)
    -- if selectpanel then
    --     selectpanel:PlayExitAnim()
    -- end
    self.ignoreHideFunc = false;
    self:UpdateShow(self.curSelect)
end

--切换角色模型完成
function RolePartnerPanel:ChangeRoleModel()
    if not self.active then
        return
    end
    self:SetModelView()
    self:LoadPartner(self.curSelect)
end

function RolePartnerPanel:LoadPartner(uniqueId)
    local uniqueId = uniqueId or self:GetRolePartner()
    if uniqueId == 0 then
        self:GetModelView():ShowModel(PartnerIndex, false)
        local blurConfig = RoleConfig.GetRoleBlurConfig(0, RoleConfig.PageBlurType.UnEquipPartner)
        self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)
        self.curShowPartnerTemplateId = nil
        return
    end
    local roleId = self:GetCurRole()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid, roleId)
    local onLoad = function()
        local cameraConfig = RoleConfig.GetPartnerCameraConfig(partnerData.template_id, self.selectState)
        self:GetModelView():BlendToNewCamera(cameraConfig.camera_position, cameraConfig.camera_rotation, 24.5)
        self:GetModelView():RecordCamera()
        self:GetModelView():SetModelRotation(PartnerIndex, cameraConfig.model_rotation)
        self:GetModelView():PlayModelAnim(PartnerIndex, cameraConfig.anim, 0.5)
        local blurConfig = RoleConfig.GetPartnerBlurConfig(partnerData.template_id, self.selectState)
        self:GetModelView():SetDepthOfFieldBoken(true, blurConfig.focus_distance, blurConfig.focal_length, blurConfig.aperture)

        self.curShowPartnerTemplateId = partnerData.template_id
    end
    if self.curShowPartnerTemplateId ~= partnerData.template_id then
        self.curShowPartnerTemplateId = partnerData.template_id
        self:GetModelView():LoadModel(PartnerIndex, partnerData.template_id, onLoad)
    else
        onLoad()
        self:GetModelView():ShowModel(PartnerIndex, true)
    end
end

function RolePartnerPanel:SetModelView()
    local roleCamera
    local uniqueId = self:GetRolePartner()
    if uniqueId == 0 then
        roleCamera = RoleConfig.GetRoleCameraConfig(self:GetCurRole(), RoleConfig.PageCameraType.UnEquipPartner)
        self:GetModelView():BlendToNewCamera(roleCamera.camera_position, roleCamera.camera_rotation, 24.5)
        self:GetModelView():RecordCamera()
    else
        roleCamera = RoleConfig.GetRoleCameraConfig(self:GetCurRole(), RoleConfig.PageCameraType.EquipPartner)
    end
    self:GetModelView():SetModelRotation("RoleRoot", roleCamera.model_rotation)
    self:GetModelView():PlayModelAnim("RoleRoot", roleCamera.anim, 0.5)
end

function RolePartnerPanel:UpdateShow(uniqueId)
    ---更新月灵数据
    local uniqueId = uniqueId or self:GetRolePartner()
    self.NullMask:SetActive(uniqueId == 0)
    self.UnEquip:SetActive(uniqueId == 0)
    self.OnEquip:SetActive(uniqueId ~= 0)
    self.RolePartner3D:SetActive(uniqueId ~= 0 and self.parentWindow:Active() == true)
    self:SetRedPoint(uniqueId)
    self:SetButtonState(self.buttonState or ButtonState.Replace)
    if uniqueId ~= 0 then
        self:ShowUpdateTip(uniqueId)
        self:ChangePage(self.curPage or PageIndex.Attr, uniqueId)
    else
        self:GetModelView():ShowModel(PartnerIndex)
    end
end

function RolePartnerPanel:SetRedPoint(uniqueId)
    if uniqueId == 0 and mod.RoleCtrl:CheckPartnerRedPoint() then 
        UtilsUI.SetActive(self.PartnerRedPoint,true)
    else
        UtilsUI.SetActive(self.PartnerRedPoint,false)
    end
end

--巅峰盘技能排序
local function PlateSortFunc(a, b)
    local ac = RoleConfig.GetPartnerSkillConfig(a.skill_id)
    local bc = RoleConfig.GetPartnerSkillConfig(b.skill_id)
    if ac.type == bc.type then
        return ac.priority > bc.priority
    end
    return ac.type < bc.type
end

function RolePartnerPanel:ShowUpdateTip(uniqueId)
    local roleId = self:GetCurRole()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid, roleId)
    local partnerId = partnerData.template_id
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerId)
    self.Name_txt.text = baseConfig.name
    self.CurLevel_txt.text = partnerData.lev

    local maxLev = RoleConfig.GetPartnerMaxLevByPartnerId(partnerData.template_id)
    self.LevelLimit_txt.text = maxLev
    if partnerData.lev == maxLev then
        if RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev + 1) then
            self.ProgressValue_img.fillAmount = 0
        else
            self.ProgressValue_img.fillAmount = 1
        end
    else
        local curExp = partnerData.exp
        local maxExp = RoleConfig.GetPartnerLevelExp(partnerData.template_id, partnerData.lev + 1)
        self.ProgressValue_img.fillAmount = curExp / maxExp
    end
    self.Locked:SetActive(partnerData.is_locked or false)
    SingleIconLoader.Load(self.QualityBg, qualityConfig.icon)

   
    --先对已经解锁的技能分类（21类型战斗技能、22类型探索技能、23类型专属被动）
    local newSkillList = {
        [PartnerBagConfig.PartnerSkillType.FightSkill] = {},
        [PartnerBagConfig.PartnerSkillType.ExploreSkill] = {},
        [PartnerBagConfig.PartnerSkillType.SelfPassiveSkill] = {}
    }
    for i, v in pairs(partnerData.skill_list) do
        local partnerSkillCfg = RoleConfig.GetPartnerSkillConfig(v.key)
        if newSkillList[partnerSkillCfg.type] then
            _tinsert(newSkillList[partnerSkillCfg.type], v)
        end
    end

    --资产那边佩丛的道具解锁的技能
    for _, id in pairs(partnerData.asset_skill_list) do
        local partnerSkillCfg = RoleConfig.GetPartnerSkillConfig(id)
        if newSkillList[partnerSkillCfg.type] then
            _tinsert(newSkillList[partnerSkillCfg.type], { key = id, value = 1})
        end
    end
    
    --再处理未解锁的技能，对未解锁的技能进行分类
    local allUnlockSKill = RoleConfig.GetPartnerAllUnlockSkillByLevel(partnerData.template_id, partnerData.lev)
    if allUnlockSKill then
        for num, skillConfig in pairs(allUnlockSKill) do
            for i, v in ipairs(skillConfig.add_skill) do --固定技能
                if v ~= 0 then
                    local partnerSkillCfg = RoleConfig.GetPartnerSkillConfig(v)
                    _tinsert(newSkillList[partnerSkillCfg.type], { unlockLev = skillConfig.level, skillId = v})
                end
            end
        end
    end

    local tempList = {}
    local skillType = PartnerBagConfig.PartnerSkillType.FightSkill
    _tinsert(tempList, { type = skillType, list = newSkillList[skillType]} )
    skillType = PartnerBagConfig.PartnerSkillType.ExploreSkill
    _tinsert(tempList, { type = skillType, list = newSkillList[skillType]} )
    skillType = PartnerBagConfig.PartnerSkillType.SelfPassiveSkill
    _tinsert(tempList, { type = skillType, list = newSkillList[skillType]} )
    
    for _, value in ipairs(tempList) do
        self:CreateSkillItem(value.list, value.type)
    end
end

function RolePartnerPanel:CreateSkillItem(skillList, type)
    if not self.skillItemObjList[type] then
        self.skillItemObjList[type] = {}
        self.skillItemObjList[type].skillItemList = {}
        self.skillItemObjList[type].obj = self:GetSkillItemParent()
    end
    local obj = self.skillItemObjList[type].obj
    
    if #skillList == 0 then
        UtilsUI.SetActive(obj.object, false)
        return 
    end
    --显示
    UtilsUI.SetActive(obj.object, true)
    --名字
    obj.Name_txt.text = PartnerBagConfig.PartnerSkillTypeToName[type]
    --技能列表
    self:UpdateSkillItem(skillList, type)
end

function RolePartnerPanel:UpdateSkillItem(skillList, type)
    local parentObj = self.skillItemObjList[type]

    for i, v in pairs(parentObj.skillItemList) do
        UtilsUI.SetActive(v.object, false)
    end
    
    local showItemNum = UtilsBase.ExpandToMultiple(#skillList, ShowSkillRowNum)
    for i = 1, showItemNum do
        if not parentObj.skillItemList[i] then
            parentObj.skillItemList[i] = self:GetSkillItemObj(parentObj.obj.SkillsList.transform)
        end
        local skillItemObj = parentObj.skillItemList[i].object
        UtilsUI.SetActive(skillItemObj, true)
        local data = skillList[i]
        if data then
            if data.key then --已解锁技能
                local objectInfo = self:InitSkillItem(skillItemObj, data.key, false, true, true, true)
                objectInfo.Button_btn.onClick:AddListener(function()
                    PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                        uid = self.uid,
                        skillId = data.key,
                        showBtn = true,
                        objList = {
                            skillItemObj
                        },
                    })
                end)
            elseif data.unlockLev then --未解锁需要等级提升
                self:InitSkillItem(skillItemObj, nil, true, data.unlockLev, false, false)
            end
        else
            --空白
            self:InitSkillItem(skillItemObj, nil, false, nil, false, false)
        end
    end
    
    local sizeDelta = parentObj.obj.SkillsList_rect.sizeDelta
    sizeDelta.y = (showItemNum / ShowSkillRowNum) * 100
    parentObj.obj.SkillsList_rect.sizeDelta = sizeDelta
end

function RolePartnerPanel:GetSkillItemParent()
    local obj = self:PopUITmpObject("skillObj", self.RolePartner3DInfo["mask"].transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UnityUtils.SetLocalEulerAngles(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function RolePartnerPanel:GetSkillItemObj(parent)
    local obj = self:PopUITmpObject("SkillItem3D", parent)
    UnityUtils.SetLocalScale(obj.objectTransform, 1.2, 1.2, 1.2)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UnityUtils.SetLocalEulerAngles(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function RolePartnerPanel:ChangePage(index, uniqueId)
    local roleId = self:GetCurRole()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid, roleId)
    self:ChangeToggle(index)
    if self.curPage then
        UtilsUI.SetActive(self[self.curPage .. "Page"],false)
        UtilsUI.SetTextColor(self[self.curPage .. "Text_txt"], "#D0D0D0")
    end
    if self.curPage and self.curPage ~= index then
        self:OnClick_BGButton()
    end
    self.curPage = index
    UtilsUI.SetTextColor(self[index .. "Text_txt"], "#191818")
    UtilsUI.SetActive(self[self.curPage .. "Page"], true)
    if index == PageIndex.Attr then
        self:ShowAttrPage(uniqueId)
    elseif index == PageIndex.PassiveSkill then
        self:ShowSkillPage(uniqueId)
    end
    self.LockButton_btn.onClick:RemoveAllListeners()
    self.LockButton_btn.onClick:AddListener(function ()
        local wheelPartnerList = mod.AbilityWheelCtrl:GetAbilityWheelPartnerList()
        for k, v in pairs(wheelPartnerList) do
            if uniqueId == v then
                MsgBoxManager.Instance:ShowTips(TI18N("该月灵在轮盘列表中，请先从轮盘列表卸下。"))
                return
            end
        end
        mod.BagCtrl:SetItemLockState(uniqueId, not partnerData.is_locked, BagEnum.BagType.Partner)
    end)
    UtilsUI.SetActive(self.Locked, partnerData.is_locked == true)
    UtilsUI.SetActive(self.UnLock, partnerData.is_locked == false)
end

function RolePartnerPanel:ChangeToggle(index)
    for _, v in pairs(PageIndex) do
        UtilsUI.SetActive(self[v.."Select"], index == v)
    end
    self[index.."Toggle_tog"].isOn = true
end

function RolePartnerPanel:GetAttrItemObj()
    local obj = self:PopUITmpObject("AttrItem")
    obj.objectTransform:SetParent(self.AttrContent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UnityUtils.SetLocalPosition(obj.objectTransform, 0, 0, 0)
    UtilsUI.GetContainerObject(obj.objectTransform, obj)
    UtilsUI.SetActive(obj.object, true)
    return obj
end

function RolePartnerPanel:ShowAttrPage(uniqueId)
    local roleId = self:GetCurRole()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid, roleId)
    local partnerId = partnerData.template_id
    local baseConfig = RoleConfig.GetPartnerConfig(partnerId)
    local levelUp = RoleConfig.GetPartnerLevPlan(partnerId).plan
    local attrTable = RoleConfig.PartnerAttrShowList(self:GetCurRole()) or {}
    local showCount = #attrTable

    self:PushAllUITmpObject("AttrItem", self.AttrItemCache_rect)
    local bgActiveNum = 1
    local attrRes = RoleConfig.GetPartnerPlateAttr(partnerData)
    attrRes = RoleConfig.GetPartnerPassiveSkillAttr(partnerData, attrRes)
    local roleEntity
    local entityList = Fight.Instance.playerManager:GetPlayer():GetEntityList()
    for _, entity in pairs(entityList) do
        if entity.masterId == self:GetCurRole() then
            roleEntity = entity
            break
        end
    end
    for i = 1, showCount, 1 do
        local attr = attrTable[i]
        local attrValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr) + (attrRes[attr] or 0)
        if attr >= 1 and attr <= 3 and roleEntity then
            local baseAttr = roleEntity.attrComponent:GetBaseValue(attr)
            local attrPercentValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr + 20) + (attrRes[attr + 20] or 0) / 10000
            attrValue = attrValue +  math.floor(baseAttr * attrPercentValue)
        end
        local isPerfectAttr  = RoleConfig.CheckPartnerPerfectAttr(self:GetCurRole(), attr)
        local obj = self:GetAttrItemObj()
        UtilsUI.SetActive(obj.NiceIcon, isPerfectAttr) 
        local name, value = RoleConfig.GetShowAttr(attr, attrValue)
        obj.AttrValue_txt.text = value
        if attrValue == 0 then
            obj.AttrValue_txt.color = TextUnActiveAlpha
            obj.AttrIcon_img.color = UnActiveAlpha
        else
            obj.AttrValue_txt.color = TextActiveAlpha
            obj.AttrIcon_img.color = ActiveAlpha
        end
        UtilsUI.SetActive(obj.AttrIcon, RoleConfig.GetAttrConfig(attr).icon2 ~= "")
        UtilsUI.SetActive(obj.AttrIcon, false)
        SingleIconLoader.Load(obj.AttrIcon, RoleConfig.GetAttrConfig(attr).icon2,function()
            UtilsUI.SetActive(obj.AttrIcon, true)
        end)
        self.AttrScroll_scroll.verticalScrollbar.value = 0
        UtilsUI.SetActive(obj.Bg, i == 4 * (bgActiveNum - 1) + 1)
        if i == 4 * (bgActiveNum - 1) + 1 then
           bgActiveNum = bgActiveNum + 1 
        end
    end
end

function RolePartnerPanel:ShowAttr(index, attrType, value, attrValue)
    local rank, icon = RoleConfig.GetPartnerAttrRank(attrType, value)
    local name, showValue = RoleConfig.GetShowAttr(attrType, attrValue)
    SingleIconLoader.Load(self["AttributeRank" .. index], icon)
    self["AttributeDesc" .. index .. "_txt"].text = name
    self["AttributeValue" .. index .. "_txt"].text = showValue
end

function RolePartnerPanel:ShowSkillPage(uniqueId)
    self.curSkillObj = nil
    local roleId = self:GetCurRole()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid, roleId)
    local baseConfig = RoleConfig.GetPartnerConfig(partnerData.template_id)
    local tempLev, tempSkillNum
    local config = RoleConfig.GetPartnerSkillTypeConfig(baseConfig.skill_type)
    local skillNum = RoleConfig.GetPartnerSkillCount(partnerData.template_id)
    local passiveSkill = partnerData.passive_skill_list
    local partnerMaxSkillCount = RoleConfig.GetPartnerPassiveSkillCount(partnerData.template_id)
    local tempPassiveSkill = {}
    if not passiveSkill or not next(passiveSkill) then
        return 
    end
    for key, value in pairs(passiveSkill) do
        tempPassiveSkill[value.key] = value.value
    end
    local nowSkillNum = 0
    local tempSkillNum = 0
    for lev = 1, partnerData.lev, 1 do
       nowSkillNum = nowSkillNum + RoleConfig.GetPartenrPassiveSkillCountByLev(partnerData.template_id, lev)
    end
    for i = 1, MaxPassiveSkillNum, 1 do
        if tempPassiveSkill[i] then
            --已解锁的技能
            -- passive_skill_list key是号位 value是skillid
            local objectInfo = self:InitSkillItem(self["PassiveSkillItem" .. i], tempPassiveSkill[i], false, true, true, false)
            objectInfo.Button_btn.onClick:AddListener(function()
                PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                    uid = self.uid,
                    skillId = tempPassiveSkill[i],
                    showBtn = true,
                    objList = {self["PassiveSkillItem" .. i]},
                    uniqueId = uniqueId
                })
            end)
        elseif i <= partnerMaxSkillCount and i <= nowSkillNum then
            -- 可以打书
            local objectInfo = self:InitSkillItem(self["PassiveSkillItem" .. i], nil, false, nil, true, false)
            objectInfo.Button_btn.onClick:AddListener(function()
                if self.uid then
                    return
                end
                WindowManager.Instance:OpenWindow(PartnerMainWindow, 
                { 
                    uniqueId = uniqueId,
                    initTag = RoleConfig.PartnerPanelType.LearnSkill
                })
            end)
        elseif i <= partnerMaxSkillCount then
            --需要等级提升解锁的
            if tempSkillNum < i then
                tempLev = RoleConfig.GetPartnerNextUnlockSkillByType(
                    partnerData.template_id, 
                    tempLev or partnerData.lev, 
                    RoleConfig.PartnerSkillSlotType.add_passive)
                tempSkillNum = 0
                for lev = 1, tempLev, 1 do
                    tempSkillNum = tempSkillNum + RoleConfig.GetPartenrPassiveSkillCountByLev(partnerData.template_id, lev)
                end
            end
            local objectInfo = self:InitSkillItem(self["PassiveSkillItem" .. i], nil, true, tempLev, false, false)
        else
            --空技能
            local objectInfo = self:InitSkillItem(self["PassiveSkillItem" .. i], nil, false, nil, false, false)
        end
    end
end
function RolePartnerPanel:__TempShow()
    -- UtilsUI.SetActive(self.RolePartner3D, true)
    -- self:PlayEnterAnim()
    -- self.RolePartnerSetting3D:PlayExitAnimator()
end

function RolePartnerPanel:__TempHide(openWindow)
    -- self:PlayExitAnim()
    if openWindow.__className == "PartnerMainWindow" then
        self.RolePartnerSetting3D:PlayExitAnimator()
    end
end

function RolePartnerPanel:InitSkillItem(object, skillId, isLock, unLockLv, canAdd, isTalentSkill)
    local objectInfo = {}
    UtilsUI.GetContainerObject(object.transform, objectInfo)
    UtilsUI.SetActive(object, true)
    objectInfo.Button_btn.onClick:RemoveAllListeners()
    if skillId then -- 已解锁
        local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId) 
        SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon, function ()
            UtilsUI.SetActive(objectInfo.SkillIcon, true)
        end)
        objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
        UtilsUI.SetActive(objectInfo.Quality, true)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        objectInfo.TalentSkillText_txt.text = baseConfig.tag_text
    elseif isLock and unLockLv then --升级后解锁
        UtilsUI.SetActive(objectInfo.NoSkill, true)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.IsLock, true)
        UtilsUI.SetActive(objectInfo.UnLock, false)
        UtilsUI.SetActive(objectInfo.Select, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
        objectInfo.LockTips_txt.text = TI18N(string.format("Lv.%d解锁", unLockLv))

    elseif canAdd then -- 可以打书
        UtilsUI.SetActive(objectInfo.NoSkill, true)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.IsLock, false)
        UtilsUI.SetActive(objectInfo.UnLock, true)
        UtilsUI.SetActive(objectInfo.Select, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
    else --空
        UtilsUI.SetActive(objectInfo.Back, false)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
        UtilsUI.SetActive(objectInfo.Null, true)
    end
    UtilsUI.SetActive(objectInfo.TalentSkillIcon, isTalentSkill or false)
    return objectInfo
end

function RolePartnerPanel:GetCurRole()
    return mod.RoleCtrl:GetCurUISelectRole()
end

function RolePartnerPanel:GetRolePartner()
    local roleId = mod.RoleCtrl:GetCurUISelectRole()
    return mod.RoleCtrl:GetRolePartner(roleId,self.uid)
end

function RolePartnerPanel:OnClick_BGButton()
    if self.oldNode then
        UtilsUI.SetActive(self.oldNode.Selected, false)
    end
    UtilsUI.SetActive(self.BGButton, false)
    local panel = self.parentWindow:GetPanel(PartnerSkillInfoPanel)
    if panel then
        panel:Close()
    end
    if self.curSkillObj then
        UtilsUI.SetActive(self.curSkillObj.Select, false)
        self.curSkillObj = nil
    end
end

function RolePartnerPanel:OnClick_Upgrade()
    local isPass, desc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerUpgrade)
    self:GetModelView():RecordBlur()
    WindowManager.Instance:OpenWindow(PartnerMainWindow, { uniqueId = self.curSelect or self:GetRolePartner(), initTag = RoleConfig.PartnerPanelType.Level })
end

function RolePartnerPanel:OnClick_AttributeDetail()
    PanelManager.Instance:OpenPanel(PartnerAttributeDetailPanel, { 
        heroId = self:GetCurRole() , 
        uniqueId = self.curSelect or self:GetRolePartner(), 
        uid = self.uid})
end

function RolePartnerPanel:Panel3D_HideCallBack()
    UtilsUI.SetActive(self.RolePartner3D, false)
end

function RolePartnerPanel:OnClick_OpenList(uniqueId)
    local config = {
        name = TI18N("月灵选择"),
        width = 575,
        col = 3,
        bagType = BagEnum.BagType.Partner,
        onClick = self:ToFunc("SelectPartner"),
        hideFunc = self:ToFunc("HideSelectFunc"),
        defaultSelect = uniqueId or self:GetRolePartner()
    }
    self.selectState = SelectState.Select
    self.parentWindow:OpenPanel(ItemSelectPanel, { config = config })
end

function RolePartnerPanel:SelectPartner(uniqueId, templateId, type)
    if self.curSelect and self.curSelect == uniqueId then
        return
    end
    self.curSelect = uniqueId
    if self.curSelect == self:GetRolePartner() then
        self:SetButtonState(ButtonState.Cur)
    else
        self:SetButtonState(ButtonState.Equip)
    end
    self:UpdateShow(uniqueId)
    self:LoadPartner(uniqueId)
end

function RolePartnerPanel:HideSelectFunc()
    self.selectState = SelectState.NotSelect
    self.curSelect = nil
    if self.ignoreHideFunc then
        return
    end
    self:SetButtonState(ButtonState.Replace)
    self:UpdateShow()
    self:LoadPartner()
end

function RolePartnerPanel:SetButtonState(state)
    if self.uid then return end
    local roleId = self:GetCurRole()
    if roleId and ItemConfig.GetItemType(roleId) == BagEnum.BagType.Robot then
        self.NullMask_btn.enabled = false
        UtilsUI.SetActiveByScale(self.NullMaskImg, false) --携带按钮
        UtilsUI.SetActiveByScale(self.OpenList, false) --携带按钮
        UtilsUI.SetActiveByScale(self.Equip,false) --替换
        UtilsUI.SetActiveByScale(self.PreviewButton,false) --预览
        UtilsUI.SetActiveByScale(self.LevelUpButton,false) --强化
    else
        self.NullMask_btn.enabled = true
        UtilsUI.SetActiveByScale(self.NullMaskImg, true) --携带按钮
        UtilsUI.SetActiveByScale(self.OpenList, true) --携带按钮
        UtilsUI.SetActiveByScale(self.Equip,true)
        UtilsUI.SetActiveByScale(self.PreviewButton,true)
        UtilsUI.SetActiveByScale(self.LevelUpButton,true)
    end
    self.buttonState = state
    if self.buttonState == ButtonState.Replace then
        self.EquipText_txt.text = TI18N("替换")
    elseif self.buttonState == ButtonState.Equip then
        self.EquipText_txt.text = TI18N("替换")
    elseif self.buttonState == ButtonState.Cur then
        self.EquipText_txt.text = TI18N("换下")
    end
end

function RolePartnerPanel:OnClick_ReplaceButton()
    if self.buttonState == ButtonState.Replace then
        self:OnClick_OpenList()
        return
    end
    local isDup = mod.WorldMapCtrl:CheckIsDup()
    if isDup then
        MsgBoxManager.Instance:ShowTips(TI18N("副本中无法操作"))
        return
    end

    local uniqueId = self.curSelect or self:GetRolePartner()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid)
    if partnerData and partnerData.work_info.asset_id ~= 0 then
        local assetConfig = PartnerCenterConfig.GetAssetConfigById(partnerData.work_info.asset_id)
        MsgBoxManager.Instance:ShowTips(string.format(TI18N("此月灵已经在资产【%s】中进行工作"), assetConfig.name))
        return
    end
    if BehaviorFunctions.CheckPlayerInFight() then
        MsgBoxManager.Instance:ShowTips(TI18N("战斗中无法操作"))
        return
    end

    local player = Fight.Instance.playerManager:GetPlayer()
    if player then
        local entityList = player:GetEntityList()
        for _, entity in pairs(entityList) do
            local partnerInstanceId = player:GetHeroPartnerInstanceId(player:GetInstanceIdByHeroId(entity.masterId))
            if partnerInstanceId and BehaviorFunctions.CheckEntityForeground(partnerInstanceId) then
                MsgBoxManager.Instance:ShowTips(TI18N("请等待月灵退场"))
                --return
            end
        end
    end
    if self.buttonState == ButtonState.Equip then
        self:EquipPartner(self.curSelect)
    elseif self.buttonState == ButtonState.Cur then
        self:EquipPartner()
    end
end

function RolePartnerPanel:EquipPartner(uniqueId)
    mod.RoleCtrl:SetRolePartner(self:GetCurRole(), uniqueId)
end

function RolePartnerPanel:UnlockSkillPreView()
    local uniqueId = self.curSelect or self:GetRolePartner()
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid)
    PanelManager.Instance:OpenPanel(PartnerSkillPreviewPanel, { 
        uniqueId = uniqueId,
        partnerId = partnerData.template_id,
    })
end

function RolePartnerPanel:OnClose()
end

function RolePartnerPanel:GetModelView()
    return Fight.Instance.modelViewMgr:GetView()
end

function RolePartnerPanel:__BeforeExitAnim()
    self.RolePartnerSetting3D:PlayExitAnimator()
end

function RolePartnerPanel:__AfterExitAnim()
    UtilsUI.SetActive(self.RolePartner3D, false)
    self.parentWindow:ClosePanel(self)
    self:SetActive(false)
end