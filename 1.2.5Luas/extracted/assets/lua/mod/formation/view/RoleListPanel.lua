RoleListPanel = BaseClass("RoleListPanel", BasePanel)

local DataHeroElement = Config.DataHeroElement.Find
local DataHeroMain = Config.DataHeroMain.Find

function RoleListPanel:__init()
    self:SetAsset("Prefabs/UI/Role/RoleListPanel.prefab")
    self.curRoleData = {}
    self.itemObjList = {}
    self.curSelectItem = nil
    self.isGradeDown = true
end

function RoleListPanel:__BindEvent()

end

--缓存对象
function RoleListPanel:__CacheObject()

end

function RoleListPanel:__Create()

end

--添加监听器
function RoleListPanel:__BindListener()
    self:SetHideNode("RoleListPanel_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn,self:ToFunc("Close_HideCallBack"))


    self.RoleButton_btn.onClick:AddListener(self:ToFunc("OpenRoleWindow"))
    self.SortButton_btn.onClick:AddListener(self:ToFunc("OnOpenRoleSortPanel"))
    self.SortReverseButton_btn.onClick:AddListener(self:ToFunc("SetSortReverse"))
    self.SubmitButton_btn.onClick:AddListener(self:ToFunc("OnClick_Submit"))
end

function RoleListPanel:__delete()

end

function RoleListPanel:__Hide()
	self.curSelectItem = nil
    EventMgr.Instance:Fire(EventName.FormationListHide)
end

function RoleListPanel:__Show()
    self:SetAcceptInput(true)
	self.curIndex = self.args.curIndex
	self.roleList = self.args.roleList or {}
	self.selectMode = self.args.selectMode or FormationConfig.SelectMode.Single
	self.curRoleId = self.roleList[self.curIndex]
	self:InitSelectMap()
end

function RoleListPanel:__ShowComplete()
    self:UpdateRoleList({
        sortType = RoleConfig.RoleSortType.default,
        element = {},
        quality = {},
    })
    self:RefreshItemList()
    self:ChangeButtonState()
end

function RoleListPanel:InitSelectMap()
    self.selectMap = {}
    for i = 1, 3, 1 do
        local roleId = self.roleList[i]
        if roleId and roleId ~= 0 then
            self.selectMap[roleId] = i
        end
    end
end

function RoleListPanel:UpdateFormation(roleList)
	self.roleList = roleList
    self:ChangeButtonState()
end

function RoleListPanel:RefreshItemList()
    local recyceList = self.HeadList_recyceList
    if recyceList then
        local listNum = #self.curShowRoleList
        recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
        recyceList:SetCellNum(listNum)
    end
end

function RoleListPanel:RefreshItemCell(index, go)
    if not go then
        return
    end

    local roleDetailItem
    local itemObj
    if self.itemObjList[index] then
        roleDetailItem = self.itemObjList[index].roleDetailItem
        itemObj = self.itemObjList[index].itemObj
    else
        roleDetailItem = RoleDetailItem.New()
        itemObj = go
        self.itemObjList[index] = {}
        self.itemObjList[index].roleDetailItem = roleDetailItem
        self.itemObjList[index].itemObj = itemObj
        self.itemObjList[index].isSelect = false
    end

    if self.firstShow then
        --roleDetailItem.showNode = go.transform:Find("ItemRefreshNode_").gameObject
        --go.transform:Find("ItemShowNode_").gameObject:SetActive(true)
    else
        -- roleDetailItem.showNode:SetActive(true)
    end

    roleDetailItem:InitItem(itemObj, self.curShowRoleList[index])
    --roleDetailItem:Show()
    local onClickFunc = function()
        if self.selectMode == FormationConfig.SelectMode.Single then
            self:OnClick_SingleItem(self.itemObjList[index])
        else
            self:OnClick_PluralItem(self.itemObjList[index])
        end
    end
    roleDetailItem:SetBtnEvent(onClickFunc)

    if not self.curShowRoleList[index] then
        return
    end

    --TODO  角色增多后，要增加滑动列表到对应位置的功能
    roleDetailItem:SetSelected_Formation(false)
    roleDetailItem:SetSelected_Normal(false)
    if self.selectMode == FormationConfig.SelectMode.Single then
        if self.curRoleId == roleDetailItem.roleId then
            roleDetailItem:SetSelected_Normal(true)
            self:OnClick_SingleItem(self.itemObjList[index])
        else
            roleDetailItem:SetSelected_Normal(false)
        end
    else
        if self.selectMap[roleDetailItem.roleId] then
            roleDetailItem:SetSelected_Formation(true, self.selectMap[roleDetailItem.roleId])
        else
            roleDetailItem:SetSelected_Formation(false)
        end
    end
end

function RoleListPanel:OnClick_SingleItem(singleItem)
    if not singleItem.roleDetailItem.roleId or singleItem == self.curSelectItem then
        return
    end
    if self.curSelectItem then
        self.curSelectItem.roleDetailItem:SetSelected_Normal(false)
    end
    self.curSelectItem = singleItem
    singleItem.roleDetailItem:SetSelected_Normal(true)
    ---切换角色
    local curRoleInfo = singleItem.roleDetailItem.curRoleInfo
    self.curRoleId = singleItem.roleDetailItem.roleId
    SingleIconLoader.Load(self.RoleStage, "Textures/Icon/Single/StageIcon/" .. curRoleInfo.stage .. ".png")
    self.RoleName_txt.text = DataHeroMain[singleItem.roleDetailItem.roleId].name

    self.CurLevel_txt.text = curRoleInfo.lev
    self.curLimitLevel = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(singleItem.roleDetailItem.roleId, curRoleInfo.stage)].limit_hero_lev
    self.LevelLimit_txt.text = "/" .. self.curLimitLevel
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.RoleLevel.transform)

    --self.CancelCollectButton:SetActive(false)
    --self.CollectButton:SetActive(true)
    self:ChangeButtonState()

    EventMgr.Instance:Fire(EventName.ChangeShowRole, singleItem.roleDetailItem.roleId)
end

function RoleListPanel:OnClick_PluralItem(singleItem)
    local roleId = singleItem.roleDetailItem.roleId
    if self.selectMap[roleId] then
        singleItem.roleDetailItem:SetSelected_Formation(false)
        self.selectMap[roleId] = nil
    else
        local minIndex
        local indexMap = {}
        for key, value in pairs(self.selectMap) do
            indexMap[value] = true
        end

        for i = 1, 3, 1 do
            if not indexMap[i] then
                minIndex = i
                break
            end
        end

        if minIndex then
            self.selectMap[roleId] = minIndex
            singleItem.roleDetailItem:SetSelected_Formation(true, minIndex)
        end
    end
    self:ChangeButtonState()
end

function RoleListPanel:ChangeButtonState()
    if self.selectMode == FormationConfig.SelectMode.Plural then
        local count = 0
        for key, value in pairs(self.selectMap) do
            count = count + 1
        end
        self.Submit:SetActive(count > 0)
        self.CurRole:SetActive(false)
        self.SubmitText_txt.text = TI18N("保存编队")
    else
        self.CurRole:SetActive(self.curRoleId and self.curRoleId ~= 0)
        self.Submit:SetActive(self.curRoleId and self.curRoleId ~= 0)
        if not self.roleList[self.curIndex] or self.roleList[self.curIndex] == 0 then
            self.SubmitText_txt.text = TI18N("上阵")
        elseif self.curRoleId == self.roleList[self.curIndex] then
            self.SubmitText_txt.text = TI18N("卸下")
        else
            self.SubmitText_txt.text = TI18N("替换")
        end
    end
end

function RoleListPanel:OnClick_Submit()
    if self.selectMode == FormationConfig.SelectMode.Plural then
        local roleList = {}
        for roleId, index in pairs(self.selectMap) do
            roleList[index] = roleId
        end
        for i = 1, 3, 1 do
            if not roleList[i] then
                roleList[i] = 0
            end
        end
        EventMgr.Instance:Fire(EventName.FormationSubmit, roleList)
    else
        EventMgr.Instance:Fire(EventName.FormationRoleSubmit, self.curSelectItem.roleDetailItem.roleId)
    end
end

function RoleListPanel:OpenRoleWindow()
    RoleMainWindow.OpenWindow(self.curSelectItem.roleDetailItem.roleId)
end

function RoleListPanel:SetSortReverse()
    self.isGradeDown = not self.isGradeDown
end

function RoleListPanel:UpdateRoleList(rule)
    self.roleIdList = mod.RoleCtrl:GetRoleIdList()
    ---构造比较所需数据的结构体
    local roleSortData = {}

    for k, id in pairs(self.roleIdList) do
        local RoleInfo = mod.RoleCtrl:GetRoleData(id)
        table.insert(roleSortData, {
            id = id,
            element = DataHeroMain[id].element,
            quality = DataHeroMain[id].quality,
            stage = RoleInfo.stage,
            level = RoleInfo.lev,
            priority = DataHeroMain[id].priority,
        })
    end

    ---  根据元素筛选
    local elementCount = #rule.element
    if rule.element and elementCount > 0 and #roleSortData > 1 then
        for index = #roleSortData, 1, -1 do
            for i, v in pairs(rule.element) do
                if v == roleSortData[index].element then
                    break
                end
                if i == elementCount then
                    table.remove(roleSortData, index)
                end
            end
        end
    end
    ---  根据品质筛选
    if rule.quality and #rule.quality > 0 and #roleSortData > 0 then
        for index = #roleSortData, 1, -1 do
            for i, v in pairs(rule.quality) do
                if v == roleSortData[index].quality then
                    break
                end
                if i == #rule.quality then
                    table.remove(roleSortData, index)
                end
            end
        end
    end

    ---筛选出编队中角色
    local CurFormation = mod.FormationCtrl:GetCurFormationInfo()
    local showFormationList = {}
    if #roleSortData > 0 then
        for _, roleId in pairs(CurFormation.roleList) do
            for index = #roleSortData, 1, -1 do
                if roleId == roleSortData[index].id then
                    table.remove(roleSortData, index)
                    table.insert(showFormationList, roleId)
                end
            end
        end
    end
    --TODO 筛选出收藏角色
    local collectList = {}

    ---突破
    local stageSortFun = function(a, b)
        if a.stage == b.stage then
            return "equal"
        elseif a.stage < b.stage then
            return not self.isGradeDown
        else
            return self.isGradeDown
        end
    end
    ---等级
    local levelSortFun = function(a, b)
        if a.lev == b.lev then
            return "equal"
        elseif a.lev < b.lev then
            return not self.isGradeDown
        else
            return self.isGradeDown
        end
    end
    ---品质
    local qualitySortFun = function(a, b)
        if a.quality == b.quality then
            return "equal"
        elseif a.quality < b.quality then
            return not self.isGradeDown
        else
            return self.isGradeDown
        end
    end
    ---元素
    local elementSortFun = function(a, b)
        if a.element == b.element then
            return "equal"
        elseif a.element < b.element then
            return true
        else
            return false
        end
    end
    ---优先级
    local prioritySortFun = function(a, b)
        if a.priority == b.priority then
            return "equal"
        elseif a.priority < b.priority then
            return not self.isGradeDown
        else
            return self.isGradeDown
        end
    end

    local sortFunList = {
        stageSortFun,
        levelSortFun,
        qualitySortFun,
        elementSortFun,
        prioritySortFun
    }

    if rule.sortType <= 3 then
        local fun = sortFunList[rule.sortType]
        table.remove(sortFunList, rule.sortType)
        table.insert(sortFunList, 1, fun)
    elseif rule.sortType == 4 then
        ---按脉象排序
    elseif rule.sortType == 5 then
        ---按好感排序
    end

    local roleSortResult = UtilsBase.BubbleSort(roleSortData, function(a, b)
        for i = 1, #sortFunList do
            local result = sortFunList[i](a, b)
            if result ~= "equal" then
                return result
            end
        end
        return true
    end)

    ---组合  编队-收藏-排序
    local result = {}
    for _, roleId in ipairs(showFormationList) do
        table.insert(result, roleId)
    end
    --TODO 插入收藏的角色列表
    for _, roleInfo in ipairs(collectList) do
        table.insert(result, roleInfo.id)
    end
    for _, roleInfo in ipairs(roleSortResult) do
        table.insert(result, roleInfo.id)
    end
    self.curShowRoleList = result

    local ruleText = RoleConfig.RoleSortText[rule.sortType]

    for k, v in pairs(rule.element) do
        ruleText = ruleText .. "|" .. DataHeroElement[v].name
    end
    for k, v in pairs(rule.quality) do
        if v == 4 then
            ruleText = ruleText .. "|" .. "紫色"
        elseif v == 5 then
            ruleText = ruleText .. "|" .. "橙色"
        end
    end
    --TODO 更新按钮文字
    self.SortRule_txt.text = ruleText
end

function RoleListPanel:OnOpenRoleSortPanel()
    self.parentWindow:OpenPanel(RoleSortPanel)
end

function RoleListPanel:Close_HideCallBack()
    self.parentWindow:ClosePanel(self)
end