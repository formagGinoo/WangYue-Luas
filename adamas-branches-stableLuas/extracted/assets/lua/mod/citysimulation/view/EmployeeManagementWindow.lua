EmployeeManagementWindow = BaseClass("EmployeeManagementWindow", BaseWindow)
EmployeeManagementWindow.active = true

function EmployeeManagementWindow:__init()
    self:SetAsset("Prefabs/UI/CitySimulation/EmployeeManagementWindow.prefab")
    
    self.exhibitionCardItemDic = {}
    self.adjustmentCardItemDic = {}
    self.bottomCardItemDic = {}
end

function EmployeeManagementWindow:__BindListener()
    self.GoAdjustBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenAdjustmentPanel"))
    self.GoExhibitionBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenExhibitionPanel"))
    self.SortBtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenEmployeeSortPanel"))
    self.CommonBack2_btn.onClick:AddListener(self:ToFunc("PlayExitAnim"))

    EventMgr.Instance:AddListener(EventName.OpenAdjustmentPanel, self:ToFunc("OnClick_OpenAdjustmentPanel"))
    EventMgr.Instance:AddListener(EventName.OnClickSelectAdjustmentCard, self:ToFunc("OnClick_SelectAdjustmentCard"))
    EventMgr.Instance:AddListener(EventName.OnClickSelectBottomCard, self:ToFunc("OnClick_SelectBottomCard"))
end

function EmployeeManagementWindow:__Show()
    self:InitBar()
    self.shopId = self.args.shopId
    self.shopLevel = mod.CitySimulationCtrl:GetShopLevel(self.shopId)
    self.operateUpConfig = CitySimulationConfig:GetCityOperateUpData(self.shopId, self.shopLevel)
    
    self:UpdateTradeStateArea()
    
    self:UpdateEmployeeAbilityArea()
    
    self.ExhibitionPart_canvas.alpha = 1
    self.ExhibitionPart_canvas.blocksRaycasts = true    -- 防止设置透明度后组件仍会遮挡
    self.AdjustmentPart_canvas.alpha = 0
    self.AdjustmentPart_canvas.blocksRaycasts = false
    
    self:UpdateExhibitionPart()
    self:UpdateAdjustmentPart()
end

function EmployeeManagementWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end

    local cb = function ()
        self:BlurShowCb()
    end
    self.blurBack:Show({cb})
end

function EmployeeManagementWindow:BlurShowCb()
    if self.args and self.args.showCallback then
        self.args.showCallback()
    end
end

function EmployeeManagementWindow:__Hide()
    self:CacheBar()
end

function EmployeeManagementWindow:__delete()
    EventMgr.Instance:RemoveListener(EventName.OpenAdjustmentPanel, self:ToFunc("OnClick_OpenAdjustmentPanel"))
    EventMgr.Instance:RemoveListener(EventName.OnClickSelectAdjustmentCard, self:ToFunc("OnClick_SelectAdjustmentCard"))
    EventMgr.Instance:RemoveListener(EventName.OnClickSelectBottomCard, self:ToFunc("OnClick_SelectBottomCard"))
end

-- 更新营业状态和能力
function EmployeeManagementWindow:UpdateTradeStateArea()
    self.DailyTradeText_txt.text = TI18N("每日营业")
    self.TradeStateText_txt.text = TI18N("营业状态")
    self.AbilityText1_txt.text = TI18N("人气能力")
    self.AbilityText2_txt.text = TI18N("专业能力")
    
    -- todo 每日营业额度 = 店铺基础产量 * (1+店铺营业状态加成)*(1+店员能力加成)+店员能力固值
    local tradeState = "A"
    self.TradeState_txt.text = tradeState
    
    local currValue_1 = 220     -- todo    通过计算员工值得到
    local totalValue_1 = self.operateUpConfig.store_power_max[1]
    local currValue_2 = 90      -- todo    通过计算员工值得到
    local totalValue_2 = self.operateUpConfig.store_power_max[2]
    
    local rate_1 = currValue_1 / totalValue_1
    rate_1 = rate_1 >= 1 and 1 or rate_1
    local rate_2 = currValue_2 / totalValue_2
    rate_2 = rate_2 >= 1 and 1 or rate_2
    
    -- 游标设定
    local anchor_1 = self.TargetPoint1_rect
    local anchor_2 = self.TargetPoint2_rect
    local anchorRate_1 = self.operateUpConfig.store_power_order[1] / totalValue_1
    local anchorRate_2 = self.operateUpConfig.store_power_order[2] / totalValue_2
    local width = self.AbilityBarBg1_rect.rect.width
    UnityUtils.SetAnchored3DPosition(anchor_1, width * anchorRate_1, anchor_1.y, anchor_1.z)
    UnityUtils.SetAnchored3DPosition(anchor_2, width * anchorRate_2, anchor_2.y, anchor_2.z)
    
    -- 进度条填充和数值显示
    self.AbilityBarBg1_sld.value = rate_1
    self.AbilityBarBg2_sld.value = rate_2
    self.AbilityValue1_txt.text = currValue_1 .. "/" .. totalValue_1
    self.AbilityValue2_txt.text = currValue_2 .. "/" .. totalValue_2
end

-- 更新店员能力展示
function EmployeeManagementWindow:UpdateEmployeeAbilityArea()
    
end

-- 更新员工展示界面
function EmployeeManagementWindow:UpdateExhibitionPart()
    self.shopEmployeeNum = 2   -- todo 当前店铺员工数量,正式数据从Ctrl获取
    local maxEmployeeNum = self.operateUpConfig.staff_num
    local cardNum = self.shopEmployeeNum < maxEmployeeNum and self.shopEmployeeNum + 1 or self.shopEmployeeNum
    
    self:RefreshExhibitionCardList(cardNum)
end

-- 刷新店铺列表
function EmployeeManagementWindow:RefreshExhibitionCardList(_len)
    if not self.ExhibitionCardScrollView_recyceList then
        return
    end

    self.ExhibitionCardScrollView_recyceList:CleanAllCell()
    self.ExhibitionCardScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateExhibitionCardItem"))
    self.ExhibitionCardScrollView_recyceList:SetCellNum(_len)
end

-- 更新商铺Item
function EmployeeManagementWindow:UpdateExhibitionCardItem(_index, _obj)
    if not _obj then
        return
    end
    
    if not self.exhibitionCardItemDic[_index] then
        self.exhibitionCardItemDic[_index] = SingleExhibitionCardItem.New()
    end

    local data = {  }
    data.index = _index
    data.object = _obj
    data.shopId = self.shopId
    data.shopLevel = self.shopLevel
    data.shopEmployeeNum = self.shopEmployeeNum
    data.parentWindow = self

    local item = self.exhibitionCardItemDic[_index]
    item:UpdateData(data)
end

-- 更新员工调整界面
function EmployeeManagementWindow:UpdateAdjustmentPart()
    self.employeeTotalNum = 6       -- todo 测试数据，正式数据从Ctrl获取
    self.shopEmployeeNum = 2        -- todo 当前店铺员工数量,正式数据从Ctrl获取
    local maxEmployeeNum = self.operateUpConfig.staff_num
    
    self.EmployeeNumText_txt.text = TI18N("营业员工") .. " " .. self.shopEmployeeNum .. "/" .. maxEmployeeNum
    
    self:RefreshAdjustmentCardList(self.employeeTotalNum)
    
    self:UpdateBottomCardList(maxEmployeeNum) 
end

-- 刷新店铺列表
function EmployeeManagementWindow:RefreshAdjustmentCardList(_len)
    if not self.CardScrollView_recyceList then
        return
    end

    self.CardScrollView_recyceList:CleanAllCell()
    self.CardScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateAdjustmentCardItem"))
    self.CardScrollView_recyceList:SetCellNum(_len)
end

-- 
function EmployeeManagementWindow:UpdateAdjustmentCardItem(_index, _obj)
    if not _obj then
        return
    end

    if not self.adjustmentCardItemDic[_index] then
        self.adjustmentCardItemDic[_index] = SingleAdjustmentCardItem.New()
    end

    local data = {  }
    data.index = _index
    data.object = _obj
    data.shopId = self.shopId
    data.shopLevel = self.shopLevel
    data.employeeNum = self.shopEmployeeNum
    data.isSelected = false   -- todo 后续从后端获取

    local item = self.adjustmentCardItemDic[_index]
    item:UpdateData(data)
end

function EmployeeManagementWindow:UpdateBottomCardList(_len)
    if not self.BottomCardScrollView_recyceList then
        return
    end

    self.BottomCardScrollView_recyceList:CleanAllCell()
    self.BottomCardScrollView_recyceList:SetLuaCallBack(self:ToFunc("UpdateBottomCardItem"))
    self.BottomCardScrollView_recyceList:SetCellNum(_len)
end

function EmployeeManagementWindow:UpdateBottomCardItem(_index, _obj)
    if not _obj then
        return
    end
    
    if not self.bottomCardItemDic[_index] then
        self.bottomCardItemDic[_index] = SingleBottomCardItem.New()
    end

    local data = {  }
    data.index = _index
    data.object = _obj
    data.shopId = self.shopId
    data.shopLevel = self.shopLevel
    data.shopEmployeeNum = self.shopEmployeeNum

    local item = self.bottomCardItemDic[_index]
    item:UpdateData(data)
end

-- 根据规则对员工卡片排序
function EmployeeManagementWindow:SortEmployeeCard(_type)
    
end

-- 显示能力细节说明
function EmployeeManagementWindow:ShowDetailTips(_position)
    if self.AbilityTips then
        self.AbilityTips_canvas.alpha = 1
        self.AbilityTips_canvas.blocksRaycasts = true

        UnityUtils.SetLocalPosition(self.AbilityTips_rect,_position.x, _position.y + 70.0, _position.z)     -- 设置回本地坐标
    end
end

-- 隐藏能力细节说明
function EmployeeManagementWindow:HideDetailTips()
    if self.AbilityTips then
        self.AbilityTips_canvas.alpha = 0
        self.AbilityTips_canvas.blocksRaycasts = false
    end
end

-- 
function EmployeeManagementWindow:OnClick_SelectAdjustmentCard(_index)
    -- todo 点选的人员若已经在其他的店铺上班且为核心人员，则无法进行选择并在点击后提示：此店员在【店铺名称】为核心职员不可选择
    
    local item = self.adjustmentCardItemDic[_index]
    if item then
        item:SetSelectedState()
    end
    
    -- todo 点选的人员若已经在其他的店铺上班则会提示通用提示弹窗：此店员已在【店铺名称】工作是否确认更换
    
    -- todo 添加在BottomList
    for _, bottomItem in pairs(self.bottomCardItemDic) do
        if bottomItem and bottomItem.isNull then
            bottomItem:SetCommonState()
            break
        end
    end
end

function EmployeeManagementWindow:OnClick_SelectBottomCard(_index)
    local item = self.bottomCardItemDic[_index]
    if item and not item.isNull then
        item:SetNullState()
    end
end

function EmployeeManagementWindow:OnClick_OpenAdjustmentPanel()
    self.ExhibitionPart_canvas.alpha = 0
    self.ExhibitionPart_canvas.blocksRaycasts = false
    self.AdjustmentPart_canvas.alpha = 1
    self.AdjustmentPart_canvas.blocksRaycasts = true
end

function EmployeeManagementWindow:OnClick_OpenExhibitionPanel()
    self.ExhibitionPart_canvas.alpha = 1
    self.ExhibitionPart_canvas.blocksRaycasts = true
    self.AdjustmentPart_canvas.alpha = 0
    self.AdjustmentPart_canvas.blocksRaycasts = false
end

function EmployeeManagementWindow:OnClick_OpenEmployeeSortPanel()  
    self:OpenPanel(EmployeeSortPanel)
end

-- 初始化货币栏
function EmployeeManagementWindow:InitBar()
    self.currencyBar = Fight.Instance.objectPool:Get(CurrencyBar)

    local goldID = CitySimulationConfig:GetGoldIconID()
    self.currencyBar:init(self.CurrencyBar, goldID)
end

-- 移除货币栏
function EmployeeManagementWindow:CacheBar()
    self.currencyBar:OnCache()
end

function EmployeeManagementWindow:__AfterExitAnim()
    WindowManager.Instance:CloseWindow(self)
end 