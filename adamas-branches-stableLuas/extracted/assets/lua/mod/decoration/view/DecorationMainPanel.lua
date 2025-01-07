DecorationMainPanel = BaseClass("DecorationMainPanel", BasePanel)

local _tinsert = table.insert
local _tsort = table.sort

local DataCondition = Config.DataCondition.data_condition
local ClickLimitTime = 0.8 --防止连续多次点击按钮的时间间隔
function DecorationMainPanel:__init()
    self:SetAsset("Prefabs/UI/Decoration/DecorationWindow.prefab")
    self.decorationMapConfig = {}
    self.decorationMain = {}
    self.select = 0
    self.isFirst = true
    self.renderType = false
    self.itemList = {}
    self.limitNum = 0
    self.lockCondition = {}
    self.conditionList ={}
    self.clickSpace = ClickLimitTime
end

function DecorationMainPanel:__Show()
    if self.args then
        self.renderType = self.args.renderType
    end
    self:Init()
    self:InitShow()
    BehaviorFunctions.SetFightPanelVisible("100010000")
    InputManager.Instance:AddLayerCount("Build")
    Fight.Instance.clientFight.decorationManager:ShowMouseCursor()
end

function DecorationMainPanel:__BindListener()
    self:BindCloseBtn(self.CloseButton_btn,self:ToFunc("Close_HideCallBack"))
    self.EditorButton_btn.onClick:AddListener(self:ToFunc("OnStartEditor"))
    self.SaveButton_btn.onClick:AddListener(self:ToFunc("OnSave"))
    self.SaveCloseButton_btn.onClick:AddListener(self:ToFunc("CloseSaveTips"))
    self.SaveEnter_btn.onClick:AddListener(self:ToFunc("OnClickSave"))
    self.SaveCancel_btn.onClick:AddListener(self:ToFunc("OnClickCancelSave"))
    EventMgr.Instance:AddListener(EventName.UpdateDecorationInfo, self:ToFunc("UpdatePanel"))
    --EventMgr.Instance:AddListener(EventName.ConditionCheck, self:ToFunc("ShowResult"))
end

-- function DecorationMainPanel:ShowResult(data)
--     --记录解锁条件
--     self.lockCondition[data.id] = data.state
-- end

function DecorationMainPanel:ExitAsser()
    mod.DecorationCtrl:SetInitType()
end

function DecorationMainPanel:Init()
    local assetId = mod.AssetPurchaseCtrl:GetCurAssetId()
    self.decorationMapConfig = mod.DecorationCtrl:GetSceneDecorationTypeList(assetId)
    self.decorationMain = mod.DecorationCtrl:GetDecorationMain()
    self:GetTypeList()
    local list = mod.DecorationCtrl:GetBagDecorationList()
    local num = #list
    self.limitNum = num
    self.isFirst = true
end

function DecorationMainPanel:InitShow()
    local curGold = mod.BagCtrl:GetGoldCount()
    self.MoneyNumText_txt.text = curGold
end

function DecorationMainPanel:UpdatePanel()
    --更新界面
    self:ShowPageList(self.select)
    self.limitNum = #mod.DecorationCtrl:GetBagDecorationList()
    self:InitShow()
end

function DecorationMainPanel:GetTypeList()
    --TODO要改成Item形式
   local toggleList = {
		self["FunctionToggle_tog"],
        self["OutputToggle_tog"],
        self["HonorToggle_tog"],
        self["WallpaperToggle_tog"],
        self["FloorToggle_tog"],
        self["FloorToggle2_tog"],
        self["FloorToggle3_tog"],
        self["FloorToggle4_tog"]
	}
    self.TypeTogList = ToggleTab.New()
    self.TypeTogList:InitByToggles(toggleList, function(curSelect)
        self:SelectTab(curSelect,toggleList[curSelect])
    end)
    for i = 1, #toggleList, 1 do
        if not self.decorationMapConfig[i]  then
            toggleList[i].gameObject:SetActive(false)
        else
            toggleList[i].gameObject:SetActive(true)
        end
    end

    self:SelectTab(1,toggleList[1])
end
--选择物件的大类
function DecorationMainPanel:SelectTab(curSelect,toggle)
    if self.pageSelect then
        self.pageSelect:SetActive(false)
    end
    self.pageSelect =  toggle.transform:Find("PageButtonShow_")--显示选中
    self.pageSelect:SetActive(true)
    self:ShowPageList(curSelect)
end

function DecorationMainPanel:ShowPageList(curSelect)
    self:ClearItemList()
    local decorationMainConfig = mod.DecorationCtrl:GetDecorationMainConig(curSelect)
    self.TypeTitleText_txt.text = decorationMainConfig.type_desc
    local limitCount = self.decorationMain[curSelect].type_limit
    local typeCount = 0
    local bagCount = #self.decorationMapConfig[curSelect]
    for i = 1, bagCount, 1 do
        local v = self.decorationMapConfig[curSelect][i]
        local obj =  self:PopUITmpObject("DecorationItem", self.DecorationContent_rect)
        obj.DecorationItemLock:SetActive(true)
        obj.object.gameObject:SetActive(true)
        obj.NameText_txt.text = v.desc
        obj.SelectedBuyButton:SetActive(true)
        local listNum = 0
        local count = mod.DecorationCtrl:GetDecorationCount(v.id)--获取背包中的数据
        local realCount = mod.DecorationCtrl:GetrealDecorationCount(v.id)
        typeCount = typeCount + realCount
        obj.NumText_txt.text= string.format("%d/%d",count,realCount)

        local listCount = 0
        for k, _v in pairs(v.building_condition_list) do
            if _v[1]~=0 then
                listCount = listCount +1
            end
        end
        local canBuy = true
        local num = 0
        local Dec =""
        for _k, _v in pairs(v.building_condition_list) do
            num = num+1
            if _v[1] == 0 then
                listNum = listNum + 1
                if listNum == #v.building_condition_list then
                    obj.DecorationItemLock:SetActive(false)
                end
                if _v[2] ~=0 then
                    local limit =_v[2]
                    if realCount< limit then
                        canBuy = true
                        obj.UnselectedBuyIcon:SetActive(false)
                    else
                        canBuy = false
                        obj.SelectedBuyButton:SetActive(false)
                        obj.UnselectedBuyIcon:SetActive(false)
                    end
                end
                goto continue
            end
            local isOpen
            local failDesc
            local useNum = 0
            --TODO临时处理通过使用道具获得的物件
            local conditionConfig = Config.DataCondition.data_condition[_v[1]]
            if conditionConfig.type == 15205 then
                useNum =  mod.BagCtrl:GetItemObtainedCount(tonumber(conditionConfig.arg1))
            end
            if useNum>0 then
                isOpen = true
            elseif self.lockCondition[_v[1]] then
                isOpen = true
            else
                isOpen, failDesc = Fight.Instance.conditionManager:CheckConditionByConfig(_v[1],true)
            end
            if isOpen  then
                obj.DecorationItemLock:SetActive(false)
                local limit = _v[2]
                if realCount < limit then
                    canBuy = true
                    obj.UnselectedBuyIcon:SetActive(false)
                else
                    canBuy = false
                    obj.UnselectedBuyIcon:SetActive(true)
                end
                if num == listCount then
                    if canBuy then
                        obj.SelectedBuyButton:SetActive(true)
                    else
                        obj.SelectedBuyButton:SetActive(false)
                        obj.UnselectedBuyIcon:SetActive(false)
                    end
                end
            else
                --后续解锁条件可以购买
                if num == listCount and not canBuy  then
                    obj.SelectedBuyButton:SetActive(false)
                    obj.UnselectedBuyIcon:SetActive(true)
                    Dec = DataCondition[_v[1]].description
                end
            end
            ::continue::
        end
        obj.tempBgButton_btn.onClick:AddListener(function ()
            local id = v.id
            local value = v
            local selfCanBuy = canBuy
            if selfCanBuy then
                if count==0 then
                    self:OnShowTip(DecorationConfig.decorationTipTypes.buy,value)
                else
                    self:ReadyStartEditor(id)
                end
            else
                if count==0 then
                    if not obj.UnselectedBuyIcon.activeSelf then
                        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("该物件已全部放入资产"))
                    else
                        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("达成"..Dec.."后可购买更多"))
                    end
                    return
                else
                    self:ReadyStartEditor(id)
                end
            end
        end)
        obj.LockBtn_btn.onClick:AddListener(function ()
            self:OnClickLock(v)
        end)
        if v.icon then
            SingleIconLoader.Load(obj.tempIcon,v.icon)
        end
        table.insert(self.itemList,obj)
        if i== bagCount and self.isFirst then
            --延迟0.3s进行刷新
            self.finishTimer = LuaTimerManager.Instance:AddTimer(1, 0.3,function ()
                self:UpdatePanel()
            end)
            self.isFirst = false
        end
    end

    if limitCount ==0 then
        self.Uplimit:SetActive(false)
    else
        self.Uplimit:SetActive(true)
        self.LimitNumText_txt.text = typeCount.."/"..limitCount
    end

    self.select = curSelect
end

function DecorationMainPanel:Update()
    if self.clickSpace>0 then
        self.clickSpace =  self.clickSpace-Time.deltaTime
    end
end

function DecorationMainPanel:OnClickLock(config)
    if self.clickSpace>0 then
        MsgBoxManager.Instance:ShowTipsImmediate(TI18N("当前操作过于频繁，请稍后再试"))
        return
    else
        for _k, _v in pairs(config.building_condition_list) do
            local isOpen
            local failDesc
            if self.lockCondition[_v[1]] then
                isOpen = true
            else
                isOpen, failDesc = Fight.Instance.conditionManager:CheckConditionByConfig(_v[1])
            end
            if not isOpen then
                local tips = Fight.Instance.conditionManager:GetConditionDesc(_v[1])
                MsgBoxManager.Instance:ShowTipsImmediate(tips)
                self.clickSpace = ClickLimitTime
                return
            end
        end
    end
end

function DecorationMainPanel:ClearItemList()
    for k, v in pairs(self.itemList) do
        v.tempBgButton_btn.onClick:RemoveAllListeners()
        v.LockBtn_btn.onClick:RemoveAllListeners()
        self:PushUITmpObject("DecorationItem",v,self.DecorationContent_rect)
    end
    self.itemList = {}
end

function DecorationMainPanel:ReadyStartEditor(id)
    SoundManager.Instance:PlaySound("ChongGouMenu_Select")
    local config = mod.DecorationCtrl:GetDecorationConfig(id)
    mod.DecorationCtrl:SetCurDecorationInfo(id)
    if config.decoration_type==2 then
        mod.DecorationCtrl:ChangeMaterial(config)
        local info = mod.DecorationCtrl.curDecorationInfo
        local pos_info =DecorationConfig.deviceType.wallPaper
        mod.DecorationCtrl:SendChangeDecoration(info.id,pos_info)
        mod.DecorationCtrl:SetLastMaterial(info)
        --替换成功
        local type = self.decorationMain[self.select]
        MsgBoxManager.Instance:ShowTipsImmediate(string.format("[%s]已替换",type.type_desc))
    else
        local count= mod.DecorationCtrl:GetDecorationCount(id)
        if count==0  then
            MsgBoxManager.Instance:ShowTipsImmediate(TI18N("该物件已全部放入资产"))
            return
        end
        self:OnStartEditor(id,DecorationConfig.decorationType.create)
    end
end

--进入编辑模式
function DecorationMainPanel:OnStartEditor(id,type)
    if not id then
        type = DecorationConfig.decorationType.editor
    end
    self:Close_HideCallBack(true)
    Fight.Instance.clientFight.decorationManager:OpenDecorationControlPanel(id,type)
end

function DecorationMainPanel:OnShowTip(type,config)
    -- 打开购买界面
    local args = {}
    args.type = type
    args.config = config
    PanelManager.Instance:OpenPanel(DecorationTipsPanel,args)
end

function DecorationMainPanel:OnSave()
    mod.DecorationCtrl:OnSaveData()
end

function DecorationMainPanel:CacheObj()
    self:PushAllUITmpObject("DecorationItem", self.DecorationContent_rect)
end

function DecorationMainPanel:Close_HideCallBack(value)
    local count = mod.DecorationCtrl:GetSaveList()
    if count>0 and not value then
       self.DecorationSaveTip:SetActive(true)
       return
    end
    local mainUi = WindowManager.Instance:GetWindow("FightMainUIView")
    mainUi:ClosePanel(DecorationMainPanel)
end

function DecorationMainPanel:CloseSaveTips()
    self.DecorationSaveTip:SetActive(false)
end

function DecorationMainPanel:OnClickSave()
    mod.DecorationCtrl:OnSaveData()
    self.DecorationSaveTip:SetActive(false)
    local mainUi = WindowManager.Instance:GetWindow("FightMainUIView")
    mainUi:ClosePanel(DecorationMainPanel)
end

function DecorationMainPanel:OnClickCancelSave()
    mod.DecorationCtrl:OnCancelSaveData()
    self.DecorationSaveTip:SetActive(false)
    local mainUi = WindowManager.Instance:GetWindow("FightMainUIView")
    mainUi:ClosePanel(DecorationMainPanel)
end

function DecorationMainPanel:__Hide()
    BehaviorFunctions.SetFightPanelVisible("-1")
    InputManager.Instance:MinusLayerCount("Build")
    Fight.Instance.clientFight.decorationManager:HideMouseCursor()
    if self.finishTimer then
        LuaTimerManager.Instance:RemoveTimer(self.finishTimer)
		self.finishTimer = nil
    end
end

function DecorationMainPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.UpdateDecorationInfo, self:ToFunc("UpdatePanel"))
    --EventMgr.Instance:RemoveListener(EventName.ConditionCheck, self:ToFunc("ShowResult"))
end