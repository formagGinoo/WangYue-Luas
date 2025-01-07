RoleListWindow = BaseClass("RoleListWindow", BaseWindow)

local DataHeroElement = Config.DataHeroElement.Find
local DataHeroMain = Config.DataHeroMain.Find
local DataHeroLevUpgrade = Config.DataHeroLevUpgrade.Find

function RoleListWindow:__init()
    self:SetAsset("Prefabs/UI/Role/RoleListWindow.prefab")
    self.curRoleData = {}
    self.itemObjList = {}
    self.curSelectItem = nil
    self.isGradeDown = true
end

function RoleListWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.RoleInfoUpdate, self:ToFunc("onRoleInfoUpdate"))
end

--缓存对象
function RoleListWindow:__CacheObject()

end

function RoleListWindow:__Create()

end

--添加监听器
function RoleListWindow:__BindListener()
    --self:SetHideNode("RoleListWindow_Eixt")
    self:BindCloseBtn(self.CommonBack2_btn, self:ToFunc("PlayExitAnim"))
    self:BindCloseBtn(self.BackButton_btn, self:ToFunc("PlayExitAnim"))

    self.SortButton_btn.onClick:AddListener(self:ToFunc("OnOpenRoleSortPanel"))
    self.SortReverseButton_btn.onClick:AddListener(self:ToFunc("SetSortReverse"))
end

function RoleListWindow:__delete()

end

function RoleListWindow:__Hide()

end

function RoleListWindow:__Show()

end

function RoleListWindow:__ShowComplete()
    self.curRoleId = self.args.roleId
    self:UpdateRoleList({
        sortType = RoleConfig.RoleSortType.default,
        element = {},
        quality = {},
    })
    self:RefreshItemList()
end

function RoleListWindow:RefreshItemList()
    local listNum = #self.curShowRoleList
    self.HeadList_recyceList:SetLuaCallBack(self:ToFunc("RefreshItemCell"))
    self.HeadList_recyceList:SetCellNum(listNum)
end

function RoleListWindow:RefreshItemCell(index, go)
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

    roleDetailItem:InitItem(itemObj, self.curShowRoleList[index])
    --roleDetailItem:Show()
    local onClickFunc = function()
        self:OnClick_SingleItem(self.itemObjList[index])
    end
    roleDetailItem:SetBtnEvent(onClickFunc)

    if not self.curShowRoleList[index] then
        return
    end

    --TODO  角色增多后，要增加滑动列表到对应位置的功能
    if self.curRoleId == roleDetailItem.roleId then
        roleDetailItem:SetSelected_Normal(self.curRoleId == roleDetailItem.roleId)
        self:OnClick_SingleItem(self.itemObjList[index])
    else
        roleDetailItem:SetSelected_Normal(false)
    end
end

function RoleListWindow:OnClick_SingleItem(singleItem)
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
    SingleIconLoader.Load(self.ElementIcon, DataHeroElement[DataHeroMain[self.curRoleId].element].element_icon_big)
    self.RoleName_txt.text = DataHeroMain[singleItem.roleDetailItem.roleId].name

    self.CurLevel_txt.text = curRoleInfo.lev
    self.curLimitLevel = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(singleItem.roleDetailItem.roleId, curRoleInfo.stage)].limit_hero_lev
    self.LevelLimit_txt.text = "/" .. self.curLimitLevel
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.RoleLevel.transform)

    --经验条
    local nextLevelConfig = DataHeroLevUpgrade[curRoleInfo.lev + 1]
    local explorePercent = nextLevelConfig and curRoleInfo.exp / nextLevelConfig.need_exp or 1
    UnityUtils.SetSizeDelata(self.ExploreValueBar.transform, explorePercent * 298, 8)

    self.CancelCollectButton:SetActive(false)
    self.CollectButton:SetActive(true)

    mod.RoleCtrl:ChangeShowRole(singleItem.roleDetailItem.roleId)
    EventMgr.Instance:Fire(EventName.ChangeShowRole, singleItem.roleDetailItem.roleId)
end

function RoleListWindow:OnClick_Close()
    --Fight.Instance.modelViewMgr:GetView():RecoverCamera()
    self.RoleListWindow_Eixt:SetActive(true)
end

function RoleListWindow:SetSortReverse()
    self.isGradeDown = not self.isGradeDown
end

function RoleListWindow:UpdateRoleList(rule)
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
    if rule.element and elementCount > 0 then
        if #roleSortData > 1 then
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
        elseif #roleSortData == 1 then
            for i, v in pairs(rule.element) do
                if v == roleSortData[1].element then
                    break
                end
                if i == elementCount then
                    table.remove(roleSortData, 1)
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
            ruleText = string.format(TI18N("%s|紫色"), ruleText)
        elseif v == 5 then
            ruleText = string.format(TI18N("%s|橙色"), ruleText)
        end
    end
    --TODO 更新按钮文字
    self.SortRule_txt.text = ruleText
end

function RoleListWindow:OnOpenRoleSortPanel()
    self:OpenPanel(RoleSortPanel)
end

function RoleListWindow:Close_HideCallBack()
    WindowManager.Instance:CloseWindow(RoleListWindow)
end

function RoleListWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end