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
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))
    self.BGBtn_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))

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
    --self.selectRoleId = self.args.roleId
	self.roleList = self.args.roleList or {}
    self.teamRequestId = self.args.team_request_id or {}
    self.team_type = self.args.team_type
    self.hideCurRole = self.args.hideCurRole
    self.submitBtnText = self.args.submitBtnText
	self.selectMode = self.args.selectMode or FormationConfig.SelectMode.Single
    self.listsize = 3
    if self.selectMode == InformationConfig.SelectMode then
        self.listsize = 4
    end
	self.curRoleId = self.roleList[self.curIndex]
	self:InitSelectMap()
    self:InitTeamRequestList()
end

function RoleListPanel:__ShowComplete()
    local rule = {
        sortType = RoleConfig.RoleSortType.default,
        element = {},
        quality = {},
        --roleId = self.selectRoleId,
    }
    self:UpdateRoleList(self.rule or rule)
    self:RefreshItemList()
    self:ChangeButtonState()
end

function RoleListPanel:InitSelectMap()
    self.selectMap = {}
    for i = 1, self.listsize, 1 do
        local roleId = self.roleList[i]
        if roleId and roleId ~= 0 then
            self.selectMap[roleId] = i
        end
    end
end

function RoleListPanel:InitTeamRequestList()
    self.teamRequestList = {} --保存角色id和机器人id（双重映射关系）
    for i, id in pairs(self.teamRequestId) do
        if id ~= 0 and id ~= -1 then
            local robotCfg = ItemConfig.GetItemConfig(id)
            self.teamRequestList[id] = robotCfg.hero_id
            self.teamRequestList[robotCfg.hero_id] = id
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
        self.itemObjList[index].itemObj = go
        itemObj = go
    else
        roleDetailItem = RoleDetailItem.New()
        itemObj = go
        self.itemObjList[index] = {}
        self.itemObjList[index].roleDetailItem = roleDetailItem
        self.itemObjList[index].itemObj = itemObj
        self.itemObjList[index].isSelect = false
    end


    roleDetailItem:InitItem(itemObj, self.curShowRoleList[index])
    roleDetailItem:SetRedPoint(false)
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
    --这里做个校验，如果编队中已经选择了角色，则不能再选择同id的机器人
    local instanceId = self.teamRequestList[singleItem.roleDetailItem.roleId] --获取机器人与角色的映射关系
    local minIndex = self.selectMap[instanceId]
    if minIndex and minIndex ~= self.curIndex then
        MsgBoxManager.Instance:ShowTips(TI18N("队伍中存在相同角色"))
        return
    end
    if self.curSelectItem then
        self.curSelectItem.roleDetailItem:SetSelected_Normal(false)
    end
    self.curSelectItem = singleItem
    singleItem.roleDetailItem:SetSelected_Normal(true)
    ---切换角色
    local curRoleInfo = singleItem.roleDetailItem.curRoleInfo
    if curRoleInfo.isRobot then
        self.robotTips:SetActive(true)
    else
        self.robotTips:SetActive(false)
    end
    self.curRoleId = singleItem.roleDetailItem.roleId
    self:UpdateRightPart(curRoleInfo)
    --LayoutRebuilder.ForceRebuildLayoutImmediate(self.RoleLevel.transform)

    --self.CancelCollectButton:SetActive(false)
    --self.CollectButton:SetActive(true)
    self:ChangeButtonState()

    EventMgr.Instance:Fire(EventName.ChangeShowRole, curRoleInfo.id)
end

function RoleListPanel:UpdateRightPart(curRoleInfo)
    SingleIconLoader.Load(self.RoleStage, "Textures/Icon/Single/StageIcon/" .. curRoleInfo.stage .. ".png")
    self.RoleName_txt.text = DataHeroMain[curRoleInfo.id].name

    self.CurLevel_txt.text = curRoleInfo.lev
    self.curLimitLevel = Config.DataHeroStageUpgrade.Find[UtilsBase.GetStringKeys(curRoleInfo.id, curRoleInfo.stage)].limit_hero_lev
    self.LevelLimit_txt.text = "/" .. self.curLimitLevel
end

function RoleListPanel:OnClick_PluralItem(singleItem)
    local roleId = singleItem.roleDetailItem.roleId
    local instanceId = self.teamRequestList[roleId] --获取机器人与角色的映射关系
    if self.selectMap[roleId] then
        singleItem.roleDetailItem:SetSelected_Formation(false)
        self.selectMap[roleId] = nil
    else
        local minIndex
        local indexMap = {}
        for key, value in pairs(self.selectMap) do
            indexMap[value] = true
        end

        for i = 1, self.listsize, 1 do
            if not indexMap[i] then
                minIndex = i
                break
            end
        end

        if minIndex then
            --这里做多选时，不允许同时存在角色和机器人，选择后面这个
            if self.selectMap[instanceId] then
                minIndex = self.selectMap[instanceId]
                self.selectMap[instanceId] = nil
                --把之前那个关掉
                self:SetSingleItemFalseByRoleId(instanceId)
            end
            self.selectMap[roleId] = minIndex
            singleItem.roleDetailItem:SetSelected_Formation(true, minIndex)
        end
    end
    self:ChangeButtonState()
end

function RoleListPanel:SetSingleItemFalseByRoleId(_roleId)
    for i, v in pairs(self.itemObjList) do
        if v.roleDetailItem.roleId == _roleId then
            v.roleDetailItem:SetSelected_Formation(false)
        end
    end
end

function RoleListPanel:ChangeButtonState()
    if self.selectMode == FormationConfig.SelectMode.Single then
        UtilsUI.SetActive(self.SubmitButton, self.curRoleId and true or false)
    end
    if self.hideCurRole then
        self.CurRole:SetActive(false)
        self.SubmitText_txt.text = self.submitBtnText
        return
    end
    
    if self.selectMode == FormationConfig.SelectMode.Plural then
        local count = 0
        for key, value in pairs(self.selectMap) do
            count = count + 1
        end
        self.Submit:SetActive(count > 0)
        self.CurRole:SetActive(false)
        self.SubmitText_txt.text = TI18N("保存编队")
    elseif self.selectMode == InformationConfig.SelectMode then
        UtilsUI.SetActive(self.CurRole,false)
        self.SubmitText_txt.text = TI18N("保存")
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
        for i = 1, self.listsize, 1 do
            if not roleList[i] then
                roleList[i] = 0
            end
        end
        EventMgr.Instance:Fire(EventName.FormationSubmit, roleList)
    elseif self.selectMode == InformationConfig.SelectMode then
        local roleList = {}
        for roleId, index in pairs(self.selectMap) do
            roleList[index] = roleId
        end
        for i = 1, self.listsize, 1 do
            if not roleList[i] then
                roleList[i] = 0
            end
        end
        EventMgr.Instance:Fire(EventName.InformationRoleSubmit, roleList)
    else
        EventMgr.Instance:Fire(EventName.FormationRoleSubmit, self.curSelectItem.roleDetailItem.roleId)
    end
end

function RoleListPanel:OpenRoleWindow()
    Fight.Instance.modelViewMgr:GetView():SetVCCameraBlend(0)
    CurtainManager.Instance:EnterWait()
    LuaTimerManager.Instance:AddTimer(1, 0.5, function()
        CurtainManager.Instance:ExitWait()
        Fight.Instance.modelViewMgr:GetView():SetVCCameraBlend()
    end)
    RoleMainWindow.OpenWindow(self.curSelectItem.roleDetailItem.roleId, {team_request_id = self.teamRequestId})
end

function RoleListPanel:SetSortReverse()
    self.isGradeDown = not self.isGradeDown
    self:UpdateRoleList()
    self:RefreshItemList()
    self:ChangeButtonState()
end

function RoleListPanel:UpdateShowListByTeamType()
    local roleSortData = {}
    local curId = self.teamRequestId[self.curIndex]
    if curId == -1 then 
        return 
    end

    if self.team_type == DuplicateConfig.formationType.limitHeroType then
        --1.编队类型为2情况下，并且该位置有机器人筛选出角色id和机器人数据
        --2.编队类型为2情况下，该位置无机器人，但是整个队伍有机器人时，不显示限制的角色和机器人
        if curId ~= 0 then --代表该位置是机器人
            --增加机器人和角色
            local robotInfo = RobotConfig.GetRobotHeroCfgById(curId)
            table.insert(roleSortData, {
                id = curId,
                roleId = robotInfo.hero_id,
                element = DataHeroMain[robotInfo.hero_id].element,
                quality = DataHeroMain[robotInfo.hero_id].quality,
                stage = robotInfo.weapon_stage,
                level = robotInfo.hero_level,
                priority = DataHeroMain[robotInfo.hero_id].priority,
            })
            local RoleInfo = mod.RoleCtrl:GetRoleData(robotInfo.hero_id)
            table.insert(roleSortData, {
                id = robotInfo.hero_id,
                element = DataHeroMain[robotInfo.hero_id].element,
                quality = DataHeroMain[robotInfo.hero_id].quality,
                stage = RoleInfo.stage,
                level = RoleInfo.lev,
                priority = DataHeroMain[robotInfo.hero_id].priority,
            })
        else
            for k, id in pairs(self.roleIdList) do --当前拥有的角色
                if not self.teamRequestList[id] then
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
            end
        end
    elseif self.team_type == DuplicateConfig.formationType.heroType then 
        --编队类型为3的情况下
        --机器人在最前面
        for i, id in pairs(self.teamRequestId) do
            if id ~= 0 and id ~= -1 then
                local robotInfo = RobotConfig.GetRobotHeroCfgById(id)
                table.insert(roleSortData, {
                    id = id,
                    roleId = robotInfo.hero_id,
                    element = DataHeroMain[robotInfo.hero_id].element,
                    quality = DataHeroMain[robotInfo.hero_id].quality,
                    stage = robotInfo.weapon_stage,
                    level = robotInfo.hero_level,
                    priority = DataHeroMain[robotInfo.hero_id].priority,
                })
            end
        end
        for k, id in pairs(self.roleIdList) do --当前拥有的角色
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
    end
    
    return roleSortData
end

function RoleListPanel:UpdateRoleList(rule)
    self.rule = rule or self.rule
    rule = self.rule
    self.roleIdList = mod.RoleCtrl:GetRoleIdList()
    ---构造比较所需数据的结构体
    local roleSortData = {}

    if self.team_type and self.team_type ~= 0 then
        roleSortData = self:UpdateShowListByTeamType()
    else
        for k, id in pairs(self.roleIdList) do
            local RoleInfo = mod.RoleCtrl:GetRoleData(id)
            table.insert(roleSortData, {
                id = id,
                element = DataHeroMain[id].element,
                quality = DataHeroMain[id].quality,
                stage = RoleInfo.stage,
                level = RoleInfo.lev,
                star = RoleInfo.star,
                priority = DataHeroMain[id].priority,
            })
        end
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
        if a.level == b.level then
            return "equal"
        elseif a.level < b.level then
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
    local starSortFun = function(a, b)
        if a.star == b.star then
            return "equal"
        elseif a.star < b.star then
            return not self.isGradeDown
        else
            return self.isGradeDown
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
        starSortFun,
        prioritySortFun
    }

    if rule.sortType <= 4 then
        local fun = sortFunList[rule.sortType]
        table.remove(sortFunList, rule.sortType)
        table.insert(sortFunList, 1, fun)
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
    -- self.curShowRoleList = {}
    -- -- 不显示已排除的角色（编队机器人）
    -- if self.args.excludeList then
    --     for _, v in ipairs(self.args.excludeList) do
    --         for i = #result,1,-1 do
    --             if result[i] == v then
    --                 table.remove(result,i)
    --             end
    --         end
    --     end
    -- end
    -- -- 只显示对应角色（编队机器人）
    -- if self.selectRoleId then
    --     for i, v in ipairs(result) do
    --         if v == self.selectRoleId then
    --             table.insert(self.curShowRoleList, v)
    --         end
    --     end
    -- else
        self.curShowRoleList = result
    --end

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

function RoleListPanel:OnOpenRoleSortPanel()
    self.parentWindow:OpenPanel(RoleSortPanel, {rule = self.rule})
end

function RoleListPanel:__AfterExitAnim()
    self.parentWindow:ClosePanel(self)
end

function RoleListPanel:UpdateRoleData(roleData)
    local roleId = roleData.id
    for k, id in pairs(self.curShowRoleList) do
        if id == roleId and self.HeadList_recyceList:CheckIndexState(k) then
            local roleDetailItem = self.itemObjList[k].roleDetailItem
            roleDetailItem:SetItem(roleId)
            roleDetailItem:Show()
        end
    end
    if self.curRoleId == roleId then
        self:UpdateRightPart(roleData)
    end
end