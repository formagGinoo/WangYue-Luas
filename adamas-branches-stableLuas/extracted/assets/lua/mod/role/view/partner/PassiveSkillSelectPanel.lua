PassiveSkillSelectPanel = BaseClass("PassiveSkillSelectPanel", BasePanel)

local SelectMode = {
    Single = 1,
    Plural = 2
}
local maxToggleNum = 3
local passiveSkillType = 1057 --技能书类型
local valuableType = 6 --贵重类型
local DataItem = Config.DataItem.Find

PassiveSkillSelectPanel.Type = {
    Have = 1,   --已有的技能书
    Nomal = 2,  --普通的
    High = 3,   --高级的
}


function PassiveSkillSelectPanel:__init()
    self:SetAsset("Prefabs/UI/Partner/PassiveSkillSelectPanel.prefab")
end

function PassiveSkillSelectPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
end

function PassiveSkillSelectPanel:__Create()
end

function PassiveSkillSelectPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end


function PassiveSkillSelectPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.ItemUpdate, self:ToFunc("ItemUpdate"))
end

function PassiveSkillSelectPanel:__BindListener()
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close"))

    for index = 1, maxToggleNum, 1 do
        self["PagingBar" ..index.. "_tog"].onValueChanged:AddListener(function (isEnter)
			if isEnter then
                self:ChangeToggle(index)
                self.curType = index
                self:RefreshItemList(self.curType)
            else

			end
        end)
    end
end

function PassiveSkillSelectPanel:ChangeToggle(index)
    for i = 1, maxToggleNum, 1 do
        if i == index then
            self["PagingBar"..i .."Select"]:SetActive(true)
        else
            self["PagingBar"..i .."Select"]:SetActive(false)
        end
    end
end

function PassiveSkillSelectPanel:__Hide()
    self.curSelectObj = nil
    self.curSelectIndex = nil
    self.curType = nil
    if self.testTimer then
        LuaTimerManager.Instance:RemoveTimer(self.testTimer)
        self.testTimer = nil
    end
    if self.hideFunc then
        self.hideFunc()
    end
    self:HideItemTips()
end

function PassiveSkillSelectPanel:__Show()
    self:SetAcceptInput(true)
    self.itemObjList = {}
    self.args = self.args or {}
    local config = self.args.config or {}
    local item = self.SkillSelectItem_rect
    self.SkillSelectScroll_recyceList:SetItem(item)


    self.isFirstAnalyse = true
    self:AnalyseConfig(config)
    self["PagingBar" .. self.defaultSelect .. "_tog"].isOn = true
    self:RefreshItemList(self.curType or self.defaultSelect)
end

function PassiveSkillSelectPanel:__ShowComplete()
end

function PassiveSkillSelectPanel:AnalyseConfig(config)
    self.onClick = config.onClick
    self.hideFunc = config.hideFunc
    self.defaultSelect = self.curUniqueId or config.defaultSelect or PassiveSkillSelectPanel.Type.Have
    self.partnerData = config.partnerData
    self.LeftPageTitle_txt.text = config.name or TI18N("消耗技能书选择")

    local tempPassiveSkill = self.partnerData.passive_skill_list
    self.passiveSkill = {}
    for key, value in pairs(tempPassiveSkill) do
        self.passiveSkill[value.key] = value.value
    end

    self.haveList = {} -- 已有的
    self.itemIdList = {} -- 标记下itemid 不能重复
    local bagData = mod.BagCtrl:SortBag(valuableType, BagEnum.SortType.Quality, nil, BagEnum.BagType.Item) or {}
    
    local bagSortFunc = function(a, b)
        local aIsStudy = 1
        local bIsStudy = 1
        local aConfig = ItemConfig.GetItemConfig(a.template_id)
        local bConfig = ItemConfig.GetItemConfig(b.template_id)

        for pos, id in pairs(self.passiveSkill) do
            if id == aConfig.property1 then
                aIsStudy = 2
            end
            if id == bConfig.property1 then
                bIsStudy = 2
            end
        end
        if aIsStudy == bIsStudy then
            return aConfig.quality > bConfig.quality
        end
        return aIsStudy < bIsStudy
    end
    table.sort(bagData, bagSortFunc)
    for key, value in pairs(bagData) do
        local config = ItemConfig.GetItemConfig(value.template_id)
        if config.type == passiveSkillType and not self.itemIdList[value.template_id] then
            table.insert(self.haveList, config)
            self.itemIdList[value.template_id] = true
        end
    end

    if not self.isFirstAnalyse then
        return
    end    
    self.normalList = {} -- quality < 5
    self.highList = {} -- quality == 5
    for id, value in pairs(DataItem) do
        if passiveSkillType == value.type then
            if value.quality < 5 then
                table.insert(self.normalList, value)
            elseif value.quality == 5 then
                table.insert(self.highList, value)
            end
        end
    end
    local configSortFunc = function(a, b)
        local aIsStudy = 1
        local bIsStudy = 1
        for pos, id in pairs(self.passiveSkill) do
            if id == a.property1 then
                aIsStudy = 2
            end
            if id == b.property1 then
                bIsStudy = 2
            end
        end
        if aIsStudy == bIsStudy then
            return a.quality > b.quality
        end
        return aIsStudy < bIsStudy
    end
    table.sort(self.highList, configSortFunc)
    table.sort(self.normalList, configSortFunc)

    self.isFirstAnalyse = false
end

function PassiveSkillSelectPanel:ItemUpdate()
    if not self.active then
        return
    end
    self.curSelectObj = nil
    self.curSelectIndex = nil
    self:AnalyseConfig(self.args.config)
    self:RefreshItemList(self.curType)
end

function PassiveSkillSelectPanel:RefreshItemList(type)
    if not type then
        type = PassiveSkillSelectPanel.Type.Have
    end
    if type == PassiveSkillSelectPanel.Type.Have then
        self.curData = self.haveList
    elseif type == PassiveSkillSelectPanel.Type.Nomal then
        self.curData = self.normalList
    elseif type == PassiveSkillSelectPanel.Type.High then
        self.curData = self.highList
    end

    if not self.firstRefresh then
        self.firstRefresh = true
        self.SkillSelectScroll_recyceList:ResetList()
    end
    local count = #self.curData
    UtilsUI.SetActive(self.NullPanel, count == 0)
    if self.curSelectObj then
        UtilsUI.SetActive(self.curSelectObj.Select, false)
        self.curSelectObj = nil
        self.curSelectIndex = nil
    end
    self.SkillSelectScroll_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.SkillSelectScroll_recyceList:SetCellNum(count, true)
end

function PassiveSkillSelectPanel:RefreshItemCell(index, go)
    if not go and self.curData[index] then
        return
    end
    local objInfo = {}
    UtilsUI.GetContainerObject(go, objInfo)
    UtilsUI.SetActive(objInfo.Select, self.curSelectIndex == index)
    local function SelectFunc()
        if self.curSelectObj then
            UtilsUI.SetActive(self.curSelectObj.Select, false)
        end
        UtilsUI.SetActive(objInfo.Select, true)
        self.curSelectObj = objInfo
        self.curSelectIndex = index
        if self.onClick then
            self.onClick(self.curData[index].property1, self.curData[index].id)
        end
    end
    self:SetSkillSelectItem(objInfo, self.curData[index], SelectFunc)
end
function PassiveSkillSelectPanel:HideItemTips()
end

function PassiveSkillSelectPanel:Close()

end
local textNormalColor = "#FFA234"
local textNotEnoughColor = "#F95240"
local isStudyColor = Color(1, 1, 1, 0.5)
local unStudyColor = Color(1, 1, 1, 1)
function PassiveSkillSelectPanel:SetSkillSelectItem(item, info, btnFunc)
    local isStudy = false
    local notEnough = false
    item.SkillName_txt.text = RoleConfig.GetPartnerSkillConfig(info.property1).name
    local hasCount = mod.BagCtrl:GetItemCountById(info.id)
    if hasCount > 0 then
        item.HasNum_txt.text = hasCount
        UtilsUI.SetTextColor(item.HasNum_txt, textNormalColor)
    else
        item.HasNum_txt.text = TI18N("不足")
        UtilsUI.SetTextColor(item.HasNum_txt, textNotEnoughColor)
        notEnough = true
    end

    local objectInfo = self:InitSkillItem(item.PartnerSkillItem, info.property1)
    objectInfo.Button_btn.onClick:AddListener(function()
        PanelManager.Instance:OpenPanel(PartnerSkillTipsPanel,{
            uid = self.uid,
            skillId = info.property1, 
        })
    end)
    --未学
    UtilsUI.SetActive(item.LearnedTag, false)
    objectInfo.SkillIcon_img.color = unStudyColor
    for pos, id in pairs(self.passiveSkill) do
        --已学
        if id == info.property1 then
            UtilsUI.SetActive(item.LearnedTag, true)
            objectInfo.SkillIcon_img.color = isStudyColor
            isStudy = true
        end
    end
    if btnFunc then
        item.Button_btn.onClick:RemoveAllListeners()
        item.Button_btn.onClick:AddListener(function()
            if isStudy then
                MsgBoxManager.Instance:ShowTips(TI18N("该技能已学习"))
            end
            if notEnough then
                MsgBoxManager.Instance:ShowTips(TI18N("该技能未拥有"))
            end
            if not isStudy and not notEnough then
                btnFunc()
            end
        end)
    end
end

--- 初始化月灵天赋item
---@param objectInfo push出来的obj
---@param skillId 技能id
function PassiveSkillSelectPanel:InitSkillItem(object, skillId)
    local objectInfo = {}
    UtilsUI.GetContainerObject(object, objectInfo)
    UtilsUI.SetActive(object, true)
    objectInfo.Button_btn.onClick:RemoveAllListeners()
    for i = 1, 5, 1 do
        objectInfo[string.format("Quality%s_tog", i)].isOn = false
    end
    if skillId then -- 已解锁
        local baseConfig = RoleConfig.GetPartnerSkillConfig(skillId)
        SingleIconLoader.Load(objectInfo.SkillIcon, baseConfig.icon)
        UtilsUI.SetActive(objectInfo.SkillIcon, true)
        objectInfo[string.format("Quality%d_tog", baseConfig.quality)].isOn = true
        UtilsUI.SetActive(objectInfo.Quality, true)
        UtilsUI.SetActive(objectInfo.NoSkill, false)
        UtilsUI.SetActive(objectInfo.Back, true)
        UtilsUI.SetActive(objectInfo.Null, false)
        UtilsUI.SetActive(objectInfo.TalentSkillIcon, false)
    end
    return objectInfo
end

function PassiveSkillSelectPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end