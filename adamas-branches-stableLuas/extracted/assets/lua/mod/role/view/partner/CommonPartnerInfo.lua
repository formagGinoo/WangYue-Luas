CommonPartnerInfo = BaseClass("CommonPartnerInfo", PoolBaseClass)

local ObjType = {
    Skill = "SkillItem",
}

local PageIndex = {
    Attr = "Attribute",
    Work = "Work",
    Skill = "Skill",
    ExSkill = "ExSkill"
}

local UnActiveAlpha = Color(1, 1, 1, 0.3)
local ActiveAlpha = Color(1, 1, 1, 1)
local TextUnActiveAlpha = Color(0.325, 0.345,0.415, 0.5)
local TextActiveAlpha = Color(0.325, 0.345,0.415, 1)

function CommonPartnerInfo:__init()
    self.cacheMap = {}
    self.objectMap = {}
    self.careerObjList = {}
    self.careerAffixObjList = {}
end
-- object,对应的go isOutSide是否是外部非角色界面进来的
function CommonPartnerInfo:Init(object, isOutSide)
    self.isOutSide = isOutSide or false
    UtilsUI.GetContainerObject(object.transform, self)
    for key, index in pairs(PageIndex) do
        self[index.."Toggle_tog"].onValueChanged:RemoveAllListeners()
        self[index.."Toggle_tog"].onValueChanged:AddListener(function (isEnter)
			if isEnter then
				self:ChangePage(index, self.uniqueId)
			end
        end
        )
    end
end
function CommonPartnerInfo:GetCurRole()
    if self.isOutSide then
        return -1
    end
    return mod.RoleCtrl:GetCurUISelectRole()
end

function CommonPartnerInfo:OnCache()
    TableUtils.ClearTable(self.cacheMap)
    TableUtils.ClearTable(self.objectMap)
    TableUtils.ClearTable(self.talentNodes)
    TableUtils.ClearTable(self.careerObjList)
    TableUtils.ClearTable(self.careerAffixObjList)
    self.curPage = nil
    Fight.Instance.objectPool:Cache(CommonPartnerInfo, self)
end

function CommonPartnerInfo:__cache()
    self.uiTmpObjMap = {}
end

function CommonPartnerInfo:UpdateShow(uniqueId)
    ---更新月灵数据
    if uniqueId ~= 0 then
        self.uniqueId = uniqueId
        self.partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
        self:ShowUpdateTip(uniqueId)
        self:ChangePage(self.curPage or PageIndex.Attr, uniqueId)
        UtilsUI.SetActive(self.HaveLock, self.partnerData.is_locked == true)
        UtilsUI.SetActive(self.Unlock, self.partnerData.is_locked == false)
        self.Node_Lock_btn.onClick:RemoveAllListeners()
        self.Node_Lock_btn.onClick:AddListener(function()
            local wheelPartnerList = mod.AbilityWheelCtrl:GetAbilityWheelPartnerList()
            for k, v in pairs(wheelPartnerList) do
                if uniqueId == v then
                    MsgBoxManager.Instance:ShowTips(TI18N("该月灵在轮盘列表中，请先从轮盘列表卸下。"))
                    return
                end
            end
            mod.BagCtrl:SetItemLockState(uniqueId, not self.partnerData.is_locked, BagEnum.BagType.Partner)
        end)
    end
end

function CommonPartnerInfo:ShowUpdateTip(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    local talentId = baseConfig.talent
    local talentConfig = RoleConfig.GetPartnerTalentConfig(talentId)
    local qualityData = ItemManager.GetItemColorData(baseConfig.quality)
    for i = 1, 5, 1 do
        UtilsUI.SetActive(self["QualityBack".. i], i == baseConfig.quality)
    end
    self.ItemName_txt.text = baseConfig.name
    self.TypeName_txt.text = TI18N("月灵")
    SingleIconLoader.Load(self.ItemIcon, baseConfig.chead_icon)

    self.CurLevel_txt.text = partnerData.lev
    self.MaxLevel_txt.text = RoleConfig.GetPartnerMaxLevByPartnerId(partnerData.template_id)
 
    self.Equiped:SetActive(partnerData.hero_id ~= 0 or partnerData.work_info.asset_id ~= 0)
    if partnerData.hero_id ~= 0 then
        self.EquipedTips_txt.text = string.format(TI18N("%s已装备"), RoleConfig.GetRoleConfig(partnerData.hero_id).name)
        local icon = RoleConfig.GetRoleConfig(partnerData.hero_id).rhead_icon
        SingleIconLoader.Load(self.Belong, icon)
    elseif partnerData.work_info.asset_id ~= 0 then
        self.EquipedTips_txt.text = TI18N("正在资产中")
        UtilsUI.SetActive(self.Belong, false)
        local assetCfg = AssetPurchaseConfig.GetAssetConfigById(partnerData.work_info.asset_id)
        if assetCfg and assetCfg.icon ~= "" then
            local callback = function()
                UtilsUI.SetActive(self.Belong, true)
            end
            SingleIconLoader.Load(self.Belong, assetCfg.icon, callback)
        end
    end

    -- 没雕纹的月灵不让切换
    UtilsUI.SetActive(self.ExSkillToggleNull, not next(partnerData.panel_list))
    UtilsUI.SetActive(self.ExSkillText, next(partnerData.panel_list))
    --佩丛工作没开放或者没有生产功能的不让切换
    local isPartnerWorkOpen = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerWork)
    local partnerWorkConfig = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    UtilsUI.SetActive(self.WorkToggle, isPartnerWorkOpen and partnerWorkConfig)
    
    for _, index in pairs(PageIndex) do
        if not next(partnerData.panel_list) and index == PageIndex.ExSkill then
            self[index .. "Toggle_tog"].enabled = false
        else
            self[index .. "Toggle_tog"].enabled = true
        end
    end
    if not next(partnerData.panel_list) then
        self:ChangePage(PageIndex.Attr, uniqueId)
    end
end

function CommonPartnerInfo:ChangePage(index, uniqueId)
    self[index .. "Toggle_tog"].isOn = true
    self:ChangeToggle(index)
    if self.curPage then
        self[self.curPage .."Page"]:SetActive(false)
        UtilsUI.SetTextColor(self[self.curPage .."Text_txt"], "#D0D0D0")
    end
    if self.curPage and self.curPage ~= index then
        --self:OnClick_BGButton()
    end
    self.curPage = index
    UtilsUI.SetTextColor(self[index.."Text_txt"], "#191818")
    self[index.."Page"]:SetActive(true)
    if index == PageIndex.Attr then
        self:ShowAttrPage(uniqueId)
    elseif index == PageIndex.Work then
        self:ShowWorkPage(uniqueId)
    elseif index == PageIndex.Skill then
        self:ShowSkillPage(uniqueId)
    elseif index == PageIndex.ExSkill then
        self:ShowExSkillPage(uniqueId)
    end
end

function CommonPartnerInfo:ShowAttrPage(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid)
    local partnerId = partnerData.template_id
    local baseConfig = RoleConfig.GetPartnerConfig(partnerId)
    local levelUp = RoleConfig.GetPartnerLevPlan(partnerId).plan
    local attrTable = RoleConfig.PartnerAttrShowList(self:GetCurRole()) or {}
    local showCount = #attrTable
    local scroll = self.AttrScroll.transform:GetComponent(ScrollRect)
    self:PushAllUITmpObject("AttrItem", self.AttrItemCache_rect)
    local bgActiveNum = 1
    local attrRes = RoleConfig.GetPartnerPlateAttr(partnerData)
    RoleConfig.GetPartnerPassiveSkillAttr(partnerData, attrRes)
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
        if attr >= 1 and attr <= 3  and roleEntity then
            local baseAttr = roleEntity.attrComponent:GetBaseValue(attr)
            local attrPercentValue = RoleConfig.GetPartnerAttr(partnerId, partnerData.lev, attr + 20) + (attrRes[attr + 20] or 0) / 10000
            attrValue = attrValue + math.ceil(baseAttr * attrPercentValue)
        end
        local isPerfectAttr = RoleConfig.CheckPartnerPerfectAttr(self:GetCurRole(), attr)
        local obj = self:PopUITmpObject("AttrItem", self.AttrContent.transform)
        UtilsUI.SetActive(obj.object, true)
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
        scroll.verticalScrollbar.value = 0
        UtilsUI.SetActive(obj.Bg, i == 4 * (bgActiveNum - 1) + 1)
        if i == 4 * (bgActiveNum - 1) + 1 then
           bgActiveNum = bgActiveNum + 1 
        end
    end
end

function CommonPartnerInfo:ShowWorkPage(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId)
    local partnerWorkConfig = PartnerBagConfig.GetPartnerWorkConfig(partnerData.template_id)
    
    if partnerWorkConfig then
        for index, data in ipairs(partnerWorkConfig.career) do
            self:InitCareerItem(index, data)
        end
    end

    for index, data in ipairs(partnerData.affix_list) do
        self:InitCareerAffixItem(index, data)
    end
    LuaTimerManager.Instance:AddTimerByNextFrame(1, 0, function()
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.workContent.transform)
    end)
end

function CommonPartnerInfo:InitCareerItem(index, data)
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
        self:OnClickCareerTips(careerId, careerLv)
    end)
end

function CommonPartnerInfo:InitCareerAffixItem(index, data)
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


function CommonPartnerInfo:ChangeToggle(index)
    if self.curPage == index then return end
    for _, v in pairs(PageIndex) do
        self[v.."Select"]:SetActive(false)
    end
    self[index.."Select"]:SetActive(true)
end

function CommonPartnerInfo:ShowAttr(index, attrType, value, attrValue)
    local rank, icon = RoleConfig.GetPartnerAttrRank(attrType, value)
    local name, showValue = RoleConfig.GetShowAttr(attrType, attrValue)
    SingleIconLoader.Load(self["AttributeRank"..index], icon)
    self["AttributeDesc"..index .."_txt"].text = name
    self["AttributeValue"..index .."_txt"].text = showValue
end

local ShowSkillRowNum = 4
function CommonPartnerInfo:ShowSkillPage(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid)
    local partnerId = partnerData.template_id
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerId)
    local unlockLev, count = RoleConfig.GetPartnerNextUnlockSkillCount(partnerData.template_id, partnerData.lev)
    local skillNum = RoleConfig.GetPartnerSkillCount(partnerId)
    local tempLev
    local config = RoleConfig.GetPartnerSkillTypeConfig(baseConfig.skill_type)
    local curPartnerHasSkillList = partnerData.skill_list
    local passiveSkill = partnerData.passive_skill_list
    self:PushAllUITmpObject("SkillItem", self.SkillCache_rect)
    local tempPassiveSkill = {}
    for key, value in pairs(passiveSkill) do
        tempPassiveSkill[value.key + #curPartnerHasSkillList] = value.value
    end
    local partnerMaxSkillCount = RoleConfig.GetPartnerPassiveSkillCount(partnerData.template_id) + #curPartnerHasSkillList

    local showSkillItemNum = UtilsBase.ExpandToMultiple(partnerMaxSkillCount, ShowSkillRowNum)
    for i = 1, showSkillItemNum, 1 do
        if curPartnerHasSkillList[i] then
            --已解锁的主动技能
            local objectInfo = self:PopUITmpObject("SkillItem", self.SkillContent_rect)
            self:InitSkillItem(objectInfo, curPartnerHasSkillList[i].key, false, true, true, true)
            objectInfo.Button_btn.onClick:AddListener(function()
                PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                    uid = self.uid,
                    skillId = curPartnerHasSkillList[i].key, 
                })
            end)
        elseif tempPassiveSkill[i] then
            --已解锁的被动技能
            -- passive_skill_list key是号位 value是skillid
            local objectInfo = self:PopUITmpObject("SkillItem", self.SkillContent_rect)
            self:InitSkillItem(objectInfo, tempPassiveSkill[i], false, true, true, false)
            objectInfo.Button_btn.onClick:AddListener(function()
                PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
                    uid = self.uid,
                    skillId =  tempPassiveSkill[i], 
                })
            end)
        elseif i <= partnerMaxSkillCount then
            -- 可以打书
            local objectInfo = self:PopUITmpObject("SkillItem", self.SkillContent_rect)
            self:InitSkillItem(objectInfo, nil, false, nil, true, false)
        else
            --空技能
            local objectInfo = self:PopUITmpObject("SkillItem", self.SkillContent_rect)
            self:InitSkillItem(objectInfo, nil, false, nil, false, false)
        end
    end
end


function CommonPartnerInfo:ShowExSkillPage(uniqueId)
    local partnerData = mod.BagCtrl:GetPartnerData(uniqueId,self.uid)
    local baseConfig = RoleConfig.GetPartnerConfig(partnerData.template_id)
    local tempLev
    local config = RoleConfig.GetPartnerSkillTypeConfig(baseConfig.skill_type)
    local skillNum = RoleConfig.GetPartnerSkillCount(partnerData.template_id)
    local plates = partnerData.panel_list
    MsgBoxManager.Instance:ShowTips(TI18N("暂未开放"))
end

--- 初始化月灵天赋item
---@param objectInfo push出来的obj
---@param skillId 技能id
---@param isLock 是否能解锁
---@param unLockLv 解锁等级
---@param canAdd 可以打书
---@param isTalentSkill 是天赋技能
function CommonPartnerInfo:InitSkillItem(objectInfo, skillId, isLock, unLockLv, canAdd, isTalentSkill)
    UtilsUI.GetContainerObject(objectInfo.object, objectInfo)
    UtilsUI.SetActive(objectInfo.object, true)
    objectInfo.Button_btn.onClick:RemoveAllListeners()
    UtilsUI.SetActive(objectInfo.SkillIcon, false)
    for i = 1, 5, 1 do
        objectInfo[string.format("Quality%s_tog", i)].isOn = false
    end
    if skillId then -- 已解锁
        local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
        SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon,function()
            UtilsUI.SetActive(objectInfo.SkillIcon, true)
        end)
        objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
        UtilsUI.SetActive(objectInfo.Quality, true)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
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
        UtilsUI.SetActive(objectInfo.UnLock, false)
        UtilsUI.SetActive(objectInfo.Select, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
    else --空
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Quality, false)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.SkillIcon, false)
        UtilsUI.SetActive(objectInfo.Null, true)
    end
    UtilsUI.SetActive(objectInfo.TalentSkillIcon, isTalentSkill or false)
    return objectInfo
end

function CommonPartnerInfo:OnClick_BGButton()
    --self.BGButton:SetActive(false)
    PanelManager.Instance:ClosePanel(PartnerSkillInfoPanel)
    if self.curSkillObj then
        self.curSkillObj.Select:SetActive(false)
        self.curSkillObj = nil
    end
end

function CommonPartnerInfo:OnClickCareerTips(careerId, careerLv, showType)
    PanelManager.Instance:OpenPanel(PartnerCareerTipsPanel, {id = careerId, lv = careerLv, type = showType})
end

function CommonPartnerInfo:PopUITmpObject(name, parent)
    local objectInfo = {}
    if self.uiTmpObjCache and self.uiTmpObjCache[name] then
        local objectInfo = self.uiTmpObjCache[name][1]
        if objectInfo then
            table.remove(self.uiTmpObjCache[name], 1)
            objectInfo.object:SetActive(true)
            self:_RecordTmpObject(name, objectInfo)
            if parent then
                objectInfo.objectTransform:SetParent(parent)
            end
            return objectInfo
        end
    end

    objectInfo.object = GameObject.Instantiate(self[name])
    objectInfo.objectTransform = objectInfo.object.transform
    if objectInfo.objectTransform:GetComponent(UIContainer) then
        UtilsUI.GetContainerObject(objectInfo.objectTransform, objectInfo)
    end
    self:_RecordTmpObject(name, objectInfo)
    if parent then
        objectInfo.objectTransform:SetParent(parent)
    end
    UnityUtils.SetLocalScale(objectInfo.objectTransform, 1,1,1)
    return objectInfo, true
end

function CommonPartnerInfo:PushUITmpObject(name, objectInfo, parent)
    self.uiTmpObjCache = self.uiTmpObjCache or {}
    self.uiTmpObjCache[name] = self.uiTmpObjCache[name] or {}
    objectInfo.object:SetActive(false)
    if parent then
        objectInfo.objectTransform:SetParent(parent)
    end
    table.insert(self.uiTmpObjCache[name], objectInfo)
end

function CommonPartnerInfo:PushAllUITmpObject(name, parent)
    if self.uiTmpObjMap and self.uiTmpObjMap[name] then
        for i = #self.uiTmpObjMap[name], 1, -1 do
            local obj = table.remove(self.uiTmpObjMap[name], i)
            self:PushUITmpObject(name, obj, parent)
        end
    end
end

function CommonPartnerInfo:_RecordTmpObject(name, info)
    self.uiTmpObjMap = self.uiTmpObjMap or {}
    self.uiTmpObjMap[name] = self.uiTmpObjMap[name] or {}
    table.insert(self.uiTmpObjMap[name], info)
end