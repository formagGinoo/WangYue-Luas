GetItemPanel = BaseClass("GetItemPanel", BasePanel)
local colorVal = {
    [1] = Color(0, 0, 0, 1),
    [2] = Color(203/255, 90/255, 90/255, 1),
    ["White"] = Color(255/255, 255/255, 255/255, 1),
    ["Yellow"] = Color(255/255, 223/255, 177/255, 1)
}

--初始化
function GetItemPanel:__init(parent)
    self:SetAsset("Prefabs/UI/Common/GetItemPanel.prefab")
    self.itemList = {}
    self.dupTime = 30
end

--添加监听器
function GetItemPanel:__BindListener()
    self:BindCloseBtn(self.CloseButton_btn, self:ToFunc("PlayExitAnim"))
    self.Cancel_btn.onClick:AddListener(self:ToFunc("ClickCancleBtn"))
    self.Submit_btn.onClick:AddListener(self:ToFunc("ClickSubBtn"))
end

--缓存对象
function GetItemPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function GetItemPanel:__Create()
    
end

function GetItemPanel:__BindEvent()
end

function GetItemPanel:__delete()
    if self.awardItemList and next(self.awardItemList)then
        for key, value in pairs(self.awardItemList) do
            value:Destroy()
            PoolManager.Instance:Push(PoolType.class, "AwardItem", value)
        end
    end
    self:StopDupTimerRun()
end

function GetItemPanel:SetEffectLayer()
    local layer = WindowManager.Instance:GetCurOrderLayer()
    UtilsUI.SetEffectSortingOrder(self["UI_GetItemPanel_fenwei"], layer + 1)
    -- self.ItemScroll.transform:GetComponent(Canvas).sortingOrder = layer + 2
end

function GetItemPanel:__Show(args)
    --TODO 临时处理
    --隐藏引导
    if true then
        local guideId, guideStage = Fight.Instance.clientFight.guideManager:GetPlayingGuide()
        if guideId then
            self.curGuideId = guideId
            self.curGuideStage = guideStage
        end
    end
    BehaviorFunctions.Pause()

    Fight.Instance.clientFight.guideManager:ClearGuidingData()
    --隐藏战斗UI
    EventMgr.Instance:Fire(EventName.ShowFightDisplay, false)

    InputManager.Instance:AddLayerCount("UI")
    EventMgr.Instance:Fire(EventName.ShowCursor, true)

    if not self.args.reward_list then
        return
    end
    self.awardItemList = {}
    self.itemList = self.args.reward_list
    self.callback = self.args.callback
    self.fightData = self.args.fightData
    self.tipHideEvent = self.args.tipHideEvent

    self:UpdateEventData()
    self:UpdateFightData()
    self.itemScrollComp = self.ItemScroll.transform:GetComponent(ScrollRect)
    self:UpdateData(self.itemList)
    self:SetEffectLayer()
    self:SetItemScroll()
    self:SetCloseTimer()
end

function GetItemPanel:__Hide()
    InputManager.Instance:MinusLayerCount("UI")
    BehaviorFunctions.Resume()
    EventMgr.Instance:Fire(EventName.ShowCursor, false)

     --TODO 临时处理
     if self.curGuideId then
        Fight.Instance.clientFight.guideManager:PlayGuideGroup(self.curGuideId, self.curGuideStage, true)
    end
    EventMgr.Instance:Fire(EventName.ShowFightDisplay, true)
    self:StopDupTimerRun()
    EventMgr.Instance:Fire(EventName.GrowNoticeResumeShow)
end

function GetItemPanel:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
    LuaTimerManager.Instance:AddTimer(1, 1, function()
        if self.gameObject.activeInHierarchy == false then
            self:SetActive(true)
            LogError("模糊背景可能坏了")
        end
    end)
end

function GetItemPanel:SetCloseTimer()
    if self.fightData then return end
        
    UtilsUI.SetActiveByScale(self.CloseButton, false)
    LuaTimerManager.Instance:AddTimer(1, 1, function()
        UtilsUI.SetActiveByScale(self.CloseButton, true)
    end)
end

function GetItemPanel:SetItemScroll()
    if #self.itemList > 5 then
        UnityUtils.SetAnchoredPosition(self.ItemScroll.transform, 0,-15)
    end
    if #self.itemList > 10 then
        self.itemScrollComp.movementType = 1
    else
        self.itemScrollComp.movementType = 2
    end
end

function GetItemPanel:UpdateData(itemList)
    local result =  mod.BagCtrl:CheckIsHaveImportant(itemList)
    self.GetImportantItemList:SetActive(result)
    self.GetItemList:SetActive(not result)
    self.ContinueText:SetActive(not result)
    for key, value in pairs(itemList) do
        local itemConfig = ItemConfig.GetItemConfig(value.template_id)
        if not itemConfig then
            LogError("找不到配置 id = ".. value.template_id)
            return
        end
        local itemCell
        if result then
            if mod.BagCtrl:CheckIsInportantItem(value.template_id) then
                itemCell = GameObject.Instantiate(self.AwardItem, self.ImportantItems_rect)
            else
                itemCell = GameObject.Instantiate(self.AwardItem, self.OtherItems_rect)
            end
        else
            itemCell = GameObject.Instantiate(self.AwardItem, self.Items_rect)
        end 
        self.awardItemList[key] = PoolManager.Instance:Pop(PoolType.class, "AwardItem")
        if not self.awardItemList[key] then
            self.awardItemList[key] = AwardItem.New()
        end
        self.awardItemList[key]:InitItem(itemCell, value.template_id, value.count, value.unique_id)

    end
    if result then
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.ImportantItems.transform)
        LayoutRebuilder.ForceRebuildLayoutImmediate(self.OtherItems.transform)
    end
end

function GetItemPanel:__AfterExitAnim()
    UtilsUI.SetActiveByScale(self.Items,false)
    PanelManager.Instance:ClosePanel(self)
	EventMgr.Instance:Fire(EventName.OnCloseGetItemPanel)
end

function GetItemPanel:UpdateEventData()
    if not self.args.eventData then
        return
    end
    
    local eventCfg = RoguelikeConfig.GetRougelikeEventConfig(self.args.eventData.eventId)
    if not eventCfg then
        LogError("缺少事件配置"..self.args.eventData.eventId)
        return
    end
    
    if (not self.args.eventData.finish_ts) or (self.args.eventData.finish_ts == 0) then
        self.Title_txt.text = eventCfg.name..TI18N("首次挑战成功")
        self.Title_txt.color = colorVal.Yellow
    else
        self.Title_txt.text = eventCfg.name..TI18N("挑战成功")
        self.Title_txt.color = colorVal.White
    end
end

function GetItemPanel:UpdateFightData()
    self.ContinueText:SetActive(true)
    self.CloseButton:SetActive(true)
    self.FighBtnContent:SetActive(false)
    self.CostInfo:SetActive(false)

    if not self.fightData then
        return
    end
    self.CloseButton:SetActive(false)
    self.ContinueText:SetActive(false)
    self.FighBtnContent:SetActive(true)

    local dupType = self.fightData.dupType
    if dupType == FightEnum.DuplicateType.Res then
        self:UpdateCostInfo()
    elseif dupType == FightEnum.DuplicateType.Dup then
        self.Title_txt.text = TI18N("挑战成功")
        self.ContinueText_txt.text = self.dupTime..TI18N("秒后自动退出副本")
        self.Submit:SetActive(false)
        self.ContinueText:SetActive(true)
        --开启倒计时30秒
        if not self.dupTimer then
            self.dupTimer = LuaTimerManager.Instance:AddTimer(self.dupTime, 1, self:ToFunc("DupTimerRun"))
        end
    end
end

function GetItemPanel:DupTimerRun()
    self.dupTime = self.dupTime - 1
    self.ContinueText_txt.text = self.dupTime..TI18N("秒后自动退出副本")
    if self.dupTime <= 0 then
        self:StopDupTimerRun()
        self:ClickCancleBtn()
    end
end

function GetItemPanel:StopDupTimerRun()
    if self.dupTimer then
        LuaTimerManager.Instance:RemoveTimer(self.dupTimer)
        self.dupTimer = nil
    end
end

function GetItemPanel:UpdateCostInfo()
    local costId = ResDuplicateConfig.FightCostResId
    local curVal = mod.BagCtrl:GetItemCountById(costId)
    if costId == ItemConfig.StrengthId then
        curVal = mod.BagCtrl:GetStrengthData()
    end
    local color = colorVal[1]
    if self.fightData.dupType == FightEnum.DuplicateType.Res then
        local dupId = self.fightData.resDupId
        local dupCfg = ResDuplicateConfig.GetDuplicateInfo(dupId)
        color = curVal >= dupCfg.cost and colorVal[1] or colorVal[2]
    end

    self.LastVal_txt.color = color
    self.LastVal_txt.text = curVal
    local itemIcon = ItemConfig.GetItemIcon(costId)
    SingleIconLoader.Load(self.CostIcon, itemIcon, function ()
        self.CostInfo:SetActive(true)
    end)
end

function GetItemPanel:ClickCancleBtn()
    local dupType = self.fightData.dupType
    if dupType == FightEnum.DuplicateType.Res then
        mod.ResDuplicateCtrl:QuitDuplicate()
    elseif dupType == FightEnum.DuplicateType.Dup then
        mod.DuplicateCtrl:QuitDuplicate()
        self:PlayExitAnim()
    else
        self:PlayExitAnim()
    end
end

function GetItemPanel:ClickSubBtn()
    local dupType = self.fightData.dupType
    if dupType == FightEnum.DuplicateType.Res then
        local dupId = self.fightData.resDupId
        local dupSysCfg = ResDuplicateConfig.GetDuplicateInfo(dupId)
        if mod.ResDuplicateCtrl:CheckFightCost(dupSysCfg.cost) then
            mod.ResDuplicateCtrl:EnterResDuplicateId(dupId)
            local dupCfg = ResDuplicateConfig.GetDuplicateConfig(dupSysCfg.duplicate_id)
            local lvId = dupCfg.level_id
            BehaviorFunctions.RemoveLevel(lvId)
            BehaviorFunctions.AddLevel(lvId)
            self:PlayExitAnim()
        end
    else
        self:PlayExitAnim()
    end
end

