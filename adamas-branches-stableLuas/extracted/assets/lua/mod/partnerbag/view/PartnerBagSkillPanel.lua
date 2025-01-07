PartnerBagSkillPanel = BaseClass("PartnerBagSkillPanel", BasePanel)

local _tInsert = table.insert
local showSkillItemNum = 8

--通用被动的技能状态
local PassiveSkillState = {
    ShowSkill = 1, --已经解锁
    CanAdd = 2, --可以打书
    CanLock = 3, --未解锁但可以解锁
    UnLock = 4, --不能解锁
}

--初始化
function PartnerBagSkillPanel:__init()
    self:SetAsset("Prefabs/UI/PartnerBag/PartnerBagSkillPanel.prefab")

    self.naturalSkillList = {}
    
    --ui 
    self.fightSkillObjList = {}
    self.searchSkillObjList = {}
    self.selfPassiveSkillObjList = {}
    self.passiveSkillObjList = {}
end

--添加监听器
function PartnerBagSkillPanel:__BindListener()
    self.leanSkillBtn_btn.onClick:AddListener(self:ToFunc("OnClickLeanSkillBtn"))
    self.LockButton_btn.onClick:AddListener(self:ToFunc("OnClickLockBtn"))
    --self.skillRuleBtn_btn.onClick:AddListener(self:ToFunc("OnClickSkillRuleBtn"))
end

--缓存对象
function PartnerBagSkillPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.hide)
end
--
function PartnerBagSkillPanel:__Create()
    --只初始化一次
    self.uniqueId = self.args.uniqueId
    self:ShowUpdateTip()
    self:UpdateSkillList()
end

function PartnerBagSkillPanel:__Show(args)
    
end

function PartnerBagSkillPanel:__delete()
    self:ClearObjList()
end

function PartnerBagSkillPanel:__Hide()
    
end

function PartnerBagSkillPanel:__ShowComplete()

end

function PartnerBagSkillPanel:ClearObjList()
    for i, v in pairs(self.fightSkillObjList) do
        self:PushUITmpObject("skillTemp", v.obj)
    end
    self.fightSkillObjList = {}

    for i, v in pairs(self.searchSkillObjList) do
        self:PushUITmpObject("skillTemp", v.obj)
    end
    self.searchSkillObjList = {}

    for i, v in pairs(self.selfPassiveSkillObjList) do
        self:PushUITmpObject("skillTemp", v.obj)
    end
    self.selfPassiveSkillObjList = {}

    for i, v in pairs(self.passiveSkillObjList) do
        self:PushUITmpObject("skillTemp", v.obj)
    end
    self.passiveSkillObjList = {}

    if self.fightSkillRoot then
        self:PushUITmpObject("skillRoot", self.fightSkillRoot)
    end
    self.fightSkillRoot = nil
    if self.searchSkillRoot then
        self:PushUITmpObject("skillRoot", self.searchSkillRoot)
    end
    self.searchSkillRoot = nil
    if self.selfPassiveSkillRoot then
        self:PushUITmpObject("skillRoot", self.selfPassiveSkillRoot)
    end
    self.selfPassiveSkillRoot = nil
    if self.commonPassiveSkillRoot then
        self:PushUITmpObject("passiveSkillRoot", self.commonPassiveSkillRoot)
    end
    self.commonPassiveSkillRoot = nil
end

function PartnerBagSkillPanel:PartnerInfoChange(oldData, newData)
    if newData.unique_id ~= self.uniqueId then
        return
    end
    UtilsUI.SetActive(self.Locked, newData.is_locked == true)
    UtilsUI.SetActive(self.UnLock, newData.is_locked == false)
    self:UpdateSkillList()
end

function PartnerBagSkillPanel:ShowUpdateTip()
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    local partnerId = partnerData.template_id
    local baseConfig = ItemConfig.GetItemConfig(partnerId)
    local qualityConfig = RoleConfig.GetPartnerQualityConfig(partnerId)
    self.Name_txt.text = baseConfig.name
    
    SingleIconLoader.Load(self.QualityBg, qualityConfig.icon)
    
    UtilsUI.SetActive(self.Locked, partnerData.is_locked)
    UtilsUI.SetActive(self.UnLock, not partnerData.is_locked)
end

function PartnerBagSkillPanel:UpdateSkillList()
    --天赋技能
    self:InitNaturalSkills()
    --通用被动
    self:InitPassiveSkills()
end

function PartnerBagSkillPanel:InitNaturalSkills()
    --天赋技能
    self.naturalSkillList = {
        [PartnerBagConfig.PartnerSkillType.FightSkill] = {},
        [PartnerBagConfig.PartnerSkillType.ExploreSkill] = {},
        [PartnerBagConfig.PartnerSkillType.SelfPassiveSkill] = {},
    }
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    for i, v in ipairs(partnerData.skill_list) do
        local partnerSkillCfg = RoleConfig.GetPartnerSkillConfig(v.key)
        if self.naturalSkillList[partnerSkillCfg.type] then
            _tInsert(self.naturalSkillList[partnerSkillCfg.type], v)
        end
    end

    --资产那边佩丛的道具解锁的技能
    for _, id in pairs(partnerData.asset_skill_list) do
        local partnerSkillCfg = RoleConfig.GetPartnerSkillConfig(id)
        if self.naturalSkillList[partnerSkillCfg.type] then
            _tInsert(self.naturalSkillList[partnerSkillCfg.type], { key = id, value = 1})
        end
    end
    
    --更新ui
    self:UpdateFightSkillList(self.naturalSkillList[PartnerBagConfig.PartnerSkillType.FightSkill])
    self:UpdateSearchSkillList(self.naturalSkillList[PartnerBagConfig.PartnerSkillType.ExploreSkill])
    self:UpdateSelfPassiveSkillList(self.naturalSkillList[PartnerBagConfig.PartnerSkillType.SelfPassiveSkill])
end

function PartnerBagSkillPanel:CreateNaturalSkillRoot(parent, title, isShowRuleBtn)
    local obj = self:PopUITmpObject("skillRoot")
    obj.objectTransform:SetParent(parent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.SetActive(obj.object, true)

    UtilsUI.SetActive(obj.skillRuleBtn, isShowRuleBtn)
    obj.title_txt.text = title
    if isShowRuleBtn then
        obj.skillRuleBtn_btn.onClick:AddListener(self:ToFunc("OnClickSkillRuleBtn"))
    end

    return obj
end

function PartnerBagSkillPanel:CreatePassiveSkillRoot(parent, title)
    local obj = self:PopUITmpObject("passiveSkillRoot")
    obj.objectTransform:SetParent(parent.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.SetActive(obj.object, true)

    obj.title_txt.text = title
    
    return obj
end

function PartnerBagSkillPanel:UpdateFightSkillList(skillList)
    --先创建root节点
    if not self.fightSkillRoot then
        self.fightSkillRoot = self:CreateNaturalSkillRoot(self.skillContent, PartnerBagConfig.PartnerSkillTypeToName[PartnerBagConfig.PartnerSkillType.FightSkill],true)
    end

    if not next(skillList) then
        UtilsUI.SetActive(self.fightSkillRoot.skillRoot, false)
        return
    end
    UtilsUI.SetActive(self.fightSkillRoot.skillRoot, true)
    
    
    for i, v in pairs(self.fightSkillObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end
    
    for index, v in pairs(skillList) do
        self:InitSkillItem(self.fightSkillObjList, self.fightSkillRoot.fightContent, index, v.key)
    end
end

function PartnerBagSkillPanel:UpdateSearchSkillList(skillList)
    --先创建root节点
    if not self.searchSkillRoot then
        self.searchSkillRoot = self:CreateNaturalSkillRoot(self.skillContent, PartnerBagConfig.PartnerSkillTypeToName[PartnerBagConfig.PartnerSkillType.ExploreSkill],false)
    end
    
    if not next(skillList) then
        UtilsUI.SetActive(self.searchSkillRoot.skillRoot, false)
        return
    end

    UtilsUI.SetActive(self.searchSkillRoot.skillRoot, true)
    
    for i, v in pairs(self.searchSkillObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end

    for index, v in pairs(skillList) do
        self:InitSkillItem(self.searchSkillObjList, self.searchSkillRoot.fightContent, index, v.key)
    end
end

function PartnerBagSkillPanel:UpdateSelfPassiveSkillList(skillList)
    --先创建root节点
    if not self.selfPassiveSkillRoot then
        self.selfPassiveSkillRoot = self:CreateNaturalSkillRoot(self.skillContent, PartnerBagConfig.PartnerSkillTypeToName[PartnerBagConfig.PartnerSkillType.SelfPassiveSkill],false)
    end
    
    if not next(skillList) then
        UtilsUI.SetActive(self.selfPassiveSkillRoot.skillRoot, false)
        return
    end

    UtilsUI.SetActive(self.selfPassiveSkillRoot.skillRoot, true)

    for i, v in pairs(self.selfPassiveSkillObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end

    for index, v in pairs(skillList) do
        self:InitSkillItem(self.selfPassiveSkillObjList, self.selfPassiveSkillRoot.fightContent, index, v.key)
    end
end

function PartnerBagSkillPanel:InitSkillItem(list, parent, index, skillId)
    local obj, objectInfo = self:CreateItem(index, list, parent)

    UtilsUI.SetActive(objectInfo.ShowSkill, true)
    local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
    --技能品质
    objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
    --技能图标
    SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon, function ()
        UtilsUI.SetActive(objectInfo.SkillIcon, true)
    end)

    objectInfo.TalentSkillText_txt.text = baseConfig.tag_text
    objectInfo.TalentSkillIcon:SetActive(true)

    objectInfo.Button_btn.onClick:RemoveAllListeners()
    objectInfo.Button_btn.onClick:AddListener(function()
        self:ShowSkillTips(skillId)
    end)
end

function PartnerBagSkillPanel:InitPassiveSkills()
    --先创建root节点
    if not self.commonPassiveSkillRoot then
        self.commonPassiveSkillRoot = self:CreatePassiveSkillRoot(self.skillContent, TI18N("通用被动"))
    end
    
    for i, v in pairs(self.passiveSkillObjList) do
        UtilsUI.SetActive(v.obj.object, false)
    end
    
    local partnerData = mod.BagCtrl:GetPartnerData(self.uniqueId)
    UtilsUI.SetActive(self.commonPassiveSkillRoot.passiveSkillRoot, #partnerData.passive_skill_list ~= 0)
    if #partnerData.passive_skill_list == 0 then
        return
    end 
    
    local tempPassiveSkill = {}
    for key, value in pairs(partnerData.passive_skill_list) do
        tempPassiveSkill[value.key] = value.value
    end
    local partnerMaxSkillCount = RoleConfig.GetPartnerPassiveSkillCount(partnerData.template_id)
    local nowSkillNum = 0
    for lev = 1, partnerData.lev, 1 do
        nowSkillNum = nowSkillNum + RoleConfig.GetPartenrPassiveSkillCountByLev(partnerData.template_id, lev)
    end
    local tempSkillNum = 0
    local tempLev --提示等级解锁用 
    
    for i = 1, showSkillItemNum, 1 do
        local obj, objectInfo = self:CreateItem(i, self.passiveSkillObjList, self.commonPassiveSkillRoot.passiveContent)
        local args = {
            skillId = tempPassiveSkill[i],
            callback = nil,
        } -- 参数
        
        if tempPassiveSkill[i] then
            args.callback = function()
                self:ShowSkillTips(tempPassiveSkill[i])
            end
            --已解锁的技能
            self:InitPassiveSkillItem(objectInfo, args, PassiveSkillState.ShowSkill)
        elseif i <= partnerMaxSkillCount and i <= nowSkillNum then
            args.callback = function()
                --跳转 
                self:ShowPartnerLearnSkillPanel()
            end
            -- 可以打书
            self:InitPassiveSkillItem(objectInfo, args, PassiveSkillState.CanAdd)
        elseif i <= partnerMaxSkillCount then
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
            args.tempLev = tempLev
            --需要等级提升解锁的
            self:InitPassiveSkillItem(objectInfo, args, PassiveSkillState.CanLock)
        else
            --空技能
            self:InitPassiveSkillItem(objectInfo, args, PassiveSkillState.UnLock)
        end
    end
end

function PartnerBagSkillPanel:CreateItem(index, list, parent)
    local obj
    local objectInfo
    if not list[index] then
        list[index] = {}
        obj = self:PopUITmpObject("skillTemp", parent.transform)
        objectInfo = UtilsUI.GetContainerObject(obj.object)

        list[index].obj = obj
        list[index].objectInfo = objectInfo
    else
        obj = list[index].obj
        objectInfo = list[index].objectInfo
    end
    UtilsUI.SetActive(obj.object, true)
    return obj, objectInfo
end

--- 初始化月灵天赋item
---@param objectInfo --push出来的obj
function PartnerBagSkillPanel:InitPassiveSkillItem(objectInfo, args, state)
    local skillId = args.skillId
    local tempLev = args.tempLev
    local callback = args.callback
    
    if state == PassiveSkillState.ShowSkill then
        local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
        --显示icon， 品质 
        objectInfo[string.format("Quality%s_tog", baseConfig.quality)].isOn = true
        SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon)
    elseif state == PassiveSkillState.CanLock then
        objectInfo.LockTips_txt.text = TI18N(string.format("Lv.%d解锁", tempLev))
    end

    objectInfo.Button_btn.onClick:RemoveAllListeners()
    if callback then
        objectInfo.Button_btn.onClick:AddListener(callback)
    end
    UtilsUI.SetActive(objectInfo.TalentSkillIcon, false)
    UtilsUI.SetActive(objectInfo.ShowSkill, state == PassiveSkillState.ShowSkill)
    UtilsUI.SetActive(objectInfo.CanAdd,state == PassiveSkillState.CanAdd)
    UtilsUI.SetActive(objectInfo.CanLock, state == PassiveSkillState.CanLock)
    UtilsUI.SetActive(objectInfo.Null, state == PassiveSkillState.UnLock)
    UtilsUI.SetActive(objectInfo.Back, not (state == PassiveSkillState.UnLock))
    
    
    return objectInfo
end

function PartnerBagSkillPanel:ShowSkillTips(skillId)
    PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{ skillId = skillId, uniqueId = self.uniqueId })
end

function PartnerBagSkillPanel:ShowPartnerLearnSkillPanel()
    --local isPass, desc = Fight.Instance.conditionManager:CheckSystemOpen(SystemConfig.SystemOpenId.PartnerUpgrade)
    WindowManager.Instance:OpenWindow(PartnerMainWindow, {noLoadScene = true, uniqueId = self.uniqueId, initTag = RoleConfig.PartnerPanelType.LearnSkill })
end

function PartnerBagSkillPanel:OnClickLeanSkillBtn()
    self:ShowPartnerLearnSkillPanel()
end

function PartnerBagSkillPanel:OnClickLockBtn()
    mod.PartnerBagCtrl:LockPartner(self.uniqueId)
end

function PartnerBagSkillPanel:OnClickSkillRuleBtn()
    PanelManager.Instance:OpenPanel(CommonTipsDescPanel, {key = "PartnerSkill"} )
end


