EntrustmentGradePanel = BaseClass("EntrustmentGradePanel", BasePanel)
EntrustmentGradePanel.active = true

function EntrustmentGradePanel:__init()
    self:SetAsset("Prefabs/UI/CitySimulation/EntrustmentGradePanel.prefab")
    
    self.GradeItemDic = {}                  -- index -> SingleGradeItem映射表
    self.GradeItemConfigData = {}           -- index -> 评级解锁和奖励配置表
    self.EntrustmentGradeItemDic = {}
    self.EntrustmentGradeItemConfigData = {}
    self.currIndex = 0
    self.currEntrustmentLevel = 1
end

function EntrustmentGradePanel:__BindListener()
    self.CommonBack1_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
    self.ConfirmButton_btn.onClick:AddListener(self:ToFunc("OnClick_ChangeGrade"))

    EventMgr.Instance:AddListener(EventName.RefreshGradeItemSelectState, self:ToFunc("RefreshGradeItemSelectState"))
    EventMgr.Instance:AddListener(EventName.RefreshEntrustmentGradePanel, self:ToFunc("RefreshPanel"))
end

function EntrustmentGradePanel:__Show()
    self.parent = self.args.parent
    self.shopID = self.args.shopID

    -- 初始化数据
    local table = CitySimulationConfig:GetEntrustmentLevelInfoByShopID(self.shopID)
    for i = 1, #table do
        self.GradeItemConfigData[i] = table[i]
    end
    
    self.GradeTipsText_txt.text = TI18N("委托评级越高，委托完成后的奖励越好")
    self.ConfirmButtonText_txt.text = TI18N("确认切换")

    -- 设置默认状态
    self.currEntrustmentLevel = mod.CitySimulationCtrl:GetCurrEntrustmentLevel(self.shopID)
    self.currIndex = self.currEntrustmentLevel
    if self.GradeItemConfigData[self.currEntrustmentLevel] then
        self:RefreshGradeItemList()

        -- 设置选中状态
        self.GradeItemDic[self.currEntrustmentLevel]:SetSelectState(true)
        
        -- 设置按钮默认状态为不可切换
        self.SelectedBg:SetActive(false)
        self.UnselectedBg:SetActive(true)

        -- 设置锁状态
        self:RefreshGradeItemLockState()

        -- 设置标题评级
        self:UpdateEntrustmentLevelText(self.currEntrustmentLevel)
        
        self:RefreshEntrustmentGradeItemList(self.currEntrustmentLevel)
    end
    
end

function EntrustmentGradePanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode, blurRadius = 1}
        self.blurBack = BlurBack.New(self, setting)
    end

    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function EntrustmentGradePanel:BlurShowCb()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function EntrustmentGradePanel:__Hide()
    
end

function EntrustmentGradePanel:__delete()
    -- 释放内存
    for _, item in pairs(self.EntrustmentGradeItemDic) do
        item:Delete()
    end
    self.EntrustmentGradeItemDic = {}
    
    EventMgr.Instance:RemoveListener(EventName.RefreshGradeItemSelectState, self:ToFunc("RefreshGradeItemSelectState"))
    EventMgr.Instance:RemoveListener(EventName.RefreshEntrustmentGradePanel, self:ToFunc("RefreshPanel"))
end 

-- 刷新评级列表
function EntrustmentGradePanel:RefreshGradeItemList()
    if not self.GradeScrollView_recyceList then
        return
    end

    self.GradeScrollView_recyceList:CleanAllCell()

    local len = #self.GradeItemConfigData
    self.GradeScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateGradeItem"))
    self.GradeScrollView_recyceList:SetCellNum(len)
end

function EntrustmentGradePanel:UpdateGradeItem(_index, _obj)
    if not _obj then
        return
    end

    if not self.GradeItemDic[_index] then
        self.GradeItemDic[_index] = SingleGradeItem.New()
    end

    local currInfo = self.GradeItemConfigData[_index]
    local data = currInfo
    data.index = _index
    data.object = _obj

    local item = self.GradeItemDic[_index]
    item:UpdateData(data)
end

-- 刷新委托列表
function EntrustmentGradePanel:RefreshEntrustmentGradeItemList(_entrustmentLevel)
    if not self.EntrustmentGradeList_recyceList then
        return
    end

    -- 初始化数据
    local entrustmentIDTable = CitySimulationConfig:GetCommonEntrustmentJumpInfoByShopID(self.shopID)
    for i = 1,  #entrustmentIDTable do
        local data = CitySimulationConfig:GetEntrustmentDuplicateInfoByID(entrustmentIDTable[i].entrust_id, _entrustmentLevel, 1) -- todo 先写死委托挡位
        self.EntrustmentGradeItemConfigData[i] = data
        self.EntrustmentGradeItemConfigData[i].icon = entrustmentIDTable[i].icon
    end

    self.EntrustmentGradeList_recyceList:CleanAllCell()

    local len = #self.EntrustmentGradeItemConfigData
    self.EntrustmentGradeList_recyceList:SetLuaCallBack(self:ToFunc("UpdateEntrustmentGradeItem"))
    self.EntrustmentGradeList_recyceList:SetCellNum(len)
end

function EntrustmentGradePanel:UpdateEntrustmentGradeItem(_index, _obj)
    if not _obj then
        return
    end

    if not self.EntrustmentGradeItemDic[_index] then
        self.EntrustmentGradeItemDic[_index] = SingleEntrustmentGradeItem.New()
    end

    local currInfo = self.EntrustmentGradeItemConfigData[_index]
    local data = currInfo
    data.index = _index
    data.object = _obj

    local item = self.EntrustmentGradeItemDic[_index]
    item:UpdateData(data)
end

-- 刷新选择状态
function EntrustmentGradePanel:RefreshGradeItemSelectState(_index)
    if self.currIndex == _index then
        return
    end
    
    local entrustmentLevel = self.GradeItemConfigData[_index].entrust_level
    local conditionID = self.GradeItemConfigData[_index].conditon

    -- 未达到解锁条件时显示提示
    local state = Fight.Instance.conditionManager:CheckConditionByConfig(conditionID)
    if not state then
        local text = Fight.Instance.conditionManager:GetConditionDesc(conditionID)
        MsgBoxManager.Instance:ShowTips(TI18N(text))
        return
    end

    self.currIndex = _index
    
    -- 刷新选择状态
    for index, item in pairs(self.GradeItemDic) do
        item:SetSelectState(index == _index)
    end
    
    -- 刷新委托列表
    self:RefreshEntrustmentGradeItemList(entrustmentLevel)
    
    -- 刷新解锁状态
    self:RefreshGradeItemLockState()
    
    -- 刷新切换按钮状态
    self:UpdateConfirmButtonState(_index)
    
end

-- 刷新评级列表解锁状态
function EntrustmentGradePanel:RefreshGradeItemLockState()
    local maxUnlockableLevel = 0
    for i = 1, #self.GradeItemConfigData do
        local conditionID = self.GradeItemConfigData[i].conditon
        local state = Fight.Instance.conditionManager:CheckConditionByConfig(conditionID)
        if state then
            maxUnlockableLevel = i
        end
    end
    
    for i = 1, maxUnlockableLevel do
        self.GradeItemDic[i]:SetLockState(false)
    end
end

-- 更新按钮状态
function EntrustmentGradePanel:UpdateConfirmButtonState(_index)
    local conditionID = self.GradeItemConfigData[_index].conditon
    local state = Fight.Instance.conditionManager:CheckConditionByConfig(conditionID)
    
    if state and _index ~= self.currEntrustmentLevel then
        self.SelectedBg:SetActive(true)
        self.UnselectedBg:SetActive(false)
    else
        self.SelectedBg:SetActive(false)
        self.UnselectedBg:SetActive(true)
    end
end

-- 更新标题评级
function EntrustmentGradePanel:UpdateEntrustmentLevelText(_level)
    local level = self.GradeItemConfigData[_level].des
    self.CurrentGradeText_txt.text = TI18N("当前委托评级 ") .. level
end

-- 刷新Panel
function EntrustmentGradePanel:RefreshPanel(_entrustmentLevel)
    self.currEntrustmentLevel = _entrustmentLevel
    
    -- 设置按钮状态
    self:UpdateConfirmButtonState(_entrustmentLevel)

    -- 设置标题评级
    self:UpdateEntrustmentLevelText(self.currEntrustmentLevel)
    
end

function EntrustmentGradePanel:OnClick_ChangeGrade()
    local conditionID = self.GradeItemConfigData[self.currIndex].conditon
    local state = Fight.Instance.conditionManager:CheckConditionByConfig(conditionID)

    -- 满足条件且不是委托Item有变化时向后端发送请求
    if state and self.currIndex ~= self.currEntrustmentLevel then
        mod.CitySimulationCtrl:SendMsg_SetEntrustmentLevel(self.shopID, self.currIndex, self.currIndex)
    end
end

function EntrustmentGradePanel:OnClick_ClosePanel()
    self.parent:ClosePanel(EntrustmentGradePanel)
end


