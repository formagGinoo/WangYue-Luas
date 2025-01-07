EntrustmentChoiceWindow = BaseClass("EntrustmentChoiceWindow", BaseWindow)
EntrustmentChoiceWindow.active = true

function EntrustmentChoiceWindow:__init()
    self:SetAsset("Prefabs/UI/CitySimulation/EntrustmentChoiceWindow.prefab")

    self.entrustmentCardConfigData = {}
    self.entrustmentCardItemDic = {}
    self.entrustmentObjList = {}
    self.entrustmentMoveIndex = 1           -- 判断页面是否可以左右移动
    self.currSelectCardIndex = 0            -- 当前选中的卡片Index
    self.currSelectEntrustmentId = 0        -- 当前选中卡片委托ID
end

function EntrustmentChoiceWindow:__BindListener()
    self.StartEntrustmentButton_btn.onClick:AddListener(self:ToFunc("OnClick_EnterDuplicate"))
    self.EntrustmentGradeButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenGradePanel"))
    self.CustomRewardButton_btn.onClick:AddListener(self:ToFunc("OnClick_OpenCustomizeRewardPanel"))
    self.JumpLeftButton_btn.onClick:AddListener(self:ToFunc("OnClick_MoveContentLeft"))
    self.JumpRightButton_btn.onClick:AddListener(self:ToFunc("OnClick_MoveContentRight"))
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))

    EventMgr.Instance:AddListener(EventName.RefreshCardsSelectState, self:ToFunc("RefreshCardsSelectState"))
    EventMgr.Instance:AddListener(EventName.RefreshEntrustmentChoiceWindow, self:ToFunc("RefreshWindow"))
end

function EntrustmentChoiceWindow:__Show()
    self:InitBar()
    self.shopID = self.args.shopId
    self.entrustmentLevel = mod.CitySimulationCtrl:GetCurrEntrustmentLevel(self.shopID)
    self.entrustmengRewardLevel = 1     --todo 假评级奖励等级
    
    -- 构建委托数据集
    self:UpdateEntrustmentCardData()
    
    -- 更新和生成Item
    self:InitEntrustmentCardList()
    
    -- 初始化跳转按钮显示
    self:UpdateJumpButtonState()
    
    -- 更新委托评级按钮显示
    local data = CitySimulationConfig:GetEntrustmentLevelInfoByShopID(self.shopID)
    self.GradeBtnText_txt.text = TI18N("委托评级: ") .. data[self.entrustmentLevel].des

    -- 更新副本按钮点击状态
    self:UpdateDuplicateButtonState()
end

function EntrustmentChoiceWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function EntrustmentChoiceWindow:BlurShowCb()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function EntrustmentChoiceWindow:__Hide()
    self:CacheBar()
end

function EntrustmentChoiceWindow:__TempShow()
    if not self.entrustmentCardItemDic then
        return
    end

    LuaTimerManager.Instance:AddTimer(1, 0.5, function ()
        for _, item in pairs(self.entrustmentCardItemDic) do
            item:SetScrollRectActive(true)
        end
    end)
end

function EntrustmentChoiceWindow:__delete()
    self.entrustmentCardConfigData = {}
    self.entrustmentCardItemDic = {}

    -- 删除卡片内的实例化对象
    for _, item in pairs(self.entrustmentCardItemDic) do
        item:Delete()
    end

    -- 删除卡片对象
    for i = 1, # self.entrustmentObjList do
        GameObject.Destroy(self.entrustmentObjList[i])
    end
    self.entrustmentObjList = {}

    EventMgr.Instance:RemoveListener(EventName.RefreshCardsSelectState, self:ToFunc("RefreshCardsSelectState"))
    EventMgr.Instance:RemoveListener(EventName.RefreshEntrustmentChoiceWindow, self:ToFunc("RefreshWindow"))
end

-- 准备委托显示数据
function EntrustmentChoiceWindow:UpdateEntrustmentCardData()
    self.entrustmentCardConfigData = {}
    
    local descData = CitySimulationConfig:GetCommonEntrustmentDescInfoByShopID(self.shopID)     -- {[委托ID] = {委托描述信息}, ...}

    local duplicateIDData = {}
    for entrustmentID,v in pairs(descData) do
        local data = CitySimulationConfig:GetEntrustmentDuplicateInfoByID(entrustmentID, self.entrustmentLevel, self.entrustmengRewardLevel)
        if data then
            duplicateIDData[entrustmentID] = data
        end
    end
    local enemyData = {}
    for entrustmentID, value in pairs(descData) do
        if value.entrust_show_type == 2 then
            local data = CitySimulationConfig:GetDuplicateEnemyInfoByID(entrustmentID, self.entrustmentLevel)
            if data then
                enemyData[entrustmentID] = data
            end
        end
    end

    -- 以委托描述表为基准，新增其他信息
    self.entrustmentCardConfigData = descData
    for entrustmentID, value in pairsByKeys(self.entrustmentCardConfigData) do
        if duplicateIDData[entrustmentID] then
            value.system_duplicate_id = duplicateIDData[entrustmentID].system_duplicate_id
            value.cost = duplicateIDData[entrustmentID].cost
            value.show_reward = duplicateIDData[entrustmentID].show_reward
        end

        if enemyData[entrustmentID] then
            value.show_element_id = enemyData[entrustmentID].show_element_id
            value.show_monster_id = enemyData[entrustmentID].show_monster_id
        end
    end
    
    --todo 获取紧急委托
end

-- 初始化委托列表
function EntrustmentChoiceWindow:InitEntrustmentCardList()
    local index = 1
    
    for entrustmentID, data in pairsByKeys(self.entrustmentCardConfigData) do
        if self.entrustmentCardItemDic[entrustmentID] == nil then
            local go = GameObject.Instantiate(self.SingleEntrustmentCardItem)
            table.insert(self.entrustmentObjList, go)
            
            data.object = go
            data.parent = self.CardContent_rect
            data.index = index
            index = index + 1
            
            local itemData = SingleEntrustmentCardItem.New()
            self.entrustmentCardItemDic[entrustmentID] = itemData
            itemData:UpdateData(data)
        end
    end
end

-- 刷新委托列表
function EntrustmentChoiceWindow:UpdateEntrustmentCardList()
    for entrustmentID, data in pairsByKeys((self.entrustmentCardConfigData)) do
        local item = self.entrustmentCardItemDic[entrustmentID]
        item:UpdateData(data)
    end
end

-- 更新跳转按钮显示
function EntrustmentChoiceWindow:UpdateJumpButtonState()
    UtilsUI.SetActive(self.JumpRightButton, false)
    UtilsUI.SetActive(self.JumpLeftButton, false)
    
    local num = TableUtils.GetTabelLen(self.entrustmentCardConfigData)
    if self.entrustmentMoveIndex + 3 <= num then
        UtilsUI.SetActive(self.JumpRightButton, true)
    end
    
    if self.entrustmentMoveIndex - 3 >= 1 then
        UtilsUI.SetActive(self.JumpLeftButton, true)
    end
end

-- 刷新Window内容
function EntrustmentChoiceWindow:RefreshWindow(_entrustmentLevel)
    self.entrustmentLevel = _entrustmentLevel
    self.currSelectEntrustmentId = 0

    -- 更新数据集
    self:UpdateEntrustmentCardData()

    -- 更新和生成Item
    self:UpdateEntrustmentCardList()

    -- 初始化跳转按钮显示
    self:UpdateJumpButtonState()

    -- 更新副本按钮点击状态
    self:UpdateDuplicateButtonState()

    -- 更新委托评级按钮显示
    local data = CitySimulationConfig:GetEntrustmentLevelInfoByShopID(self.shopID)
    self.GradeBtnText_txt.text = TI18N("委托评级: ") .. data[_entrustmentLevel].des
end

-- 打开评级选择Panel
function EntrustmentChoiceWindow:OnClick_OpenGradePanel()
    self.tabPanel = self:OpenPanel(EntrustmentGradePanel, {
        parent = self,
        shopID = self.shopID
    })
end

function EntrustmentChoiceWindow:OnClick_OpenCustomizeRewardPanel()
    self:OpenPanel(CustomRewardPanel)
end

-- 更新副本按钮点击状态
function EntrustmentChoiceWindow:UpdateDuplicateButtonState()
    if self.currSelectEntrustmentId == 0 then
        self.SelectedBg:SetActive(false)
        self.UnselectedBg:SetActive(true)
    else
        self.SelectedBg:SetActive(true)
        self.UnselectedBg:SetActive(false)
    end
end

-- 进入副本
function EntrustmentChoiceWindow:OnClick_EnterDuplicate()
    if self.currSelectEntrustmentId == 0 then 
        return
    end

    if not self:CanEnterDup() then
        PanelManager.Instance:OpenPanel(StrengthExchangePanel)
        return
    end
    
    local resDupId = self.entrustmentCardConfigData[self.currSelectEntrustmentId].system_duplicate_id
    if resDupId then
        if Fight.Instance then
            for _, item in pairs(self.entrustmentCardItemDic) do
                item:SetScrollRectActive(false)
            end
            
            Fight.Instance.duplicateManager:CreateDuplicate(resDupId, {shopID = self.shopID, currSelectEntrustmentId = self.currSelectEntrustmentId})
        end
    end
end

function EntrustmentChoiceWindow:OnClick_MoveContentRight()
    local beforePositonX = self.CardContent_rect.anchoredPosition3D.x
    local beforePositionY = self.CardContent_rect.anchoredPosition3D.y
    UnityUtils.SetAnchored3DPosition(self.CardContent_rect, beforePositonX - self.EntrustmentCardArea_rect.sizeDelta.x, beforePositionY, 0)

    self.entrustmentMoveIndex = self.entrustmentMoveIndex + 3
    self:UpdateJumpButtonState()
end

function EntrustmentChoiceWindow:OnClick_MoveContentLeft()
    local beforePositonX = self.CardContent_rect.anchoredPosition3D.x
    local beforePositionY = self.CardContent_rect.anchoredPosition3D.y
    UnityUtils.SetAnchored3DPosition(self.CardContent_rect, beforePositonX + self.EntrustmentCardArea_rect.sizeDelta.x, beforePositionY, 0)
    
    self.entrustmentMoveIndex = self.entrustmentMoveIndex - 3
    self:UpdateJumpButtonState()
end

-- 刷新委托卡片点击状态
function EntrustmentChoiceWindow:RefreshCardsSelectState(_index, _entrustmentID)
    local index = 1
    for _, item in pairsByKeys(self.entrustmentCardItemDic) do
        if index == _index then
            -- 卡片当前已经被选中则取消选中
            if self.currSelectEntrustmentId == _entrustmentID then
                item.Select:SetActive(false)
                item.Unselect:SetActive(true)
                item.isSelect = false

                self.currSelectEntrustmentId = 0
            else
                item.Select:SetActive(true)
                item.Unselect:SetActive(false)
                item.isSelect = true

                self.currSelectEntrustmentId = _entrustmentID
            end
        else
            item.Select:SetActive(false)
            item.Unselect:SetActive(true)
            item.isSelect = false
        end
        index = index + 1
    end
    
    -- 更新副本按钮状态
    self:UpdateDuplicateButtonState()
end

-- 检查当前体力能否进入副本
function EntrustmentChoiceWindow:CanEnterDup()
    local costVit = self.entrustmentCardConfigData[self.currSelectEntrustmentId].cost
    local currVit = mod.BagCtrl:GetItemCountById(CitySimulationConfig:GetVITIconID())
    
    return currVit >= costVit
end

-- 初始化货币和体力栏
function EntrustmentChoiceWindow:InitBar()
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)
    self.vitBar = Fight.Instance.objectPool:Get(CurrencyBar)

    local goldID = CitySimulationConfig:GetGoldIconID()
    local VITID = CitySimulationConfig:GetVITIconID()
    self.currencyBar:init(self.CurrencyBar, goldID)
    self.vitBar:init(self.VITBar, VITID)
end

-- 移除货币栏和体力栏
function EntrustmentChoiceWindow:CacheBar()
    self.currencyBar:OnCache()
    self.vitBar:OnCache()
end

-- 顺序输出迭代器
function pairsByKeys(t)
    local a = {}
    for n in pairs(t) do
        a[#a+1] = n
    end
    table.sort(a)
    local i = 0
    return function()
        i = i + 1
        return a[i], t[a[i]]

    end
end

function EntrustmentChoiceWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end

