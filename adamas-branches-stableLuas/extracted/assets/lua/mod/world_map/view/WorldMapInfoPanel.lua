WorldMapInfoPanel = BaseClass("WorldMapInfoPanel", BasePanel)

local NormalBtn_Desc = {
    [StoryConfig.StoryTrigger.OpenNpcStore] = TI18N("传送"),
    [StoryConfig.StoryTrigger.MercenaryHunt] = TI18N("追踪"),
    [StoryConfig.StoryTrigger.Trace] = TI18N("追踪"),
    [StoryConfig.StoryTrigger.Transport] = TI18N("传送"),
    [StoryConfig.StoryTrigger.Task] = TI18N("确定"),
    [StoryConfig.StoryTrigger.Rogue] = TI18N("追踪"),
    [StoryConfig.StoryTrigger.Asset] = TI18N("追踪"),
}

local NormalTypeDesc = {
    [StoryConfig.StoryTrigger.OpenNpcStore] = TI18N("商店"),
    [StoryConfig.StoryTrigger.MercenaryHunt] = TI18N("佣兵"),
    [StoryConfig.StoryTrigger.Transport] = TI18N("篝火点"),
    [StoryConfig.StoryTrigger.Task] = TI18N("世界任务"),
}

local DataReward = Config.DataReward.Find

function WorldMapInfoPanel:__init()
    self:SetAsset("Prefabs/UI/WorldMap/WorldMapInfoPanel.prefab")

    self.mark = {}
    self.mapId = 0

    self.toggleMark = nil
    self.markTempPool = {}
    self.customTypeOnShow = {}

    -- 新增自定义标签的缓存位
    self.tempCustomType = nil
    self.tempCustomName = nil
    self.tempCustomPos = {}

    -- 已有的自定义标签缓存位
    self.changeCustomType = nil
    self.changeCustomName = nil

    self.itemsOnShow = {}
    self.taskItemOnShow = {}
    self.eventItemOnShow = {}

    self.waitShopId = nil
end

function WorldMapInfoPanel:__BindListener()
    self.markNameInput = self.MarkInput.transform:GetComponent(TMP_InputField)
    self.GmYInput = self.YInput.transform:GetComponent(TMP_InputField)

    self.MarkBtn1_btn.onClick:AddListener(self:ToFunc("OnClick_Trace"))
    self.MarkBtn2_btn.onClick:AddListener(self:ToFunc("OnClick_DelCustomMark"))
    self.MarkBtn3_btn.onClick:AddListener(self:ToFunc("OnClick_AddCustomMark"))

    self:SetHideNode("CloseNode")
    self:BindCloseBtn(self.BackClose_btn,self:ToFunc("CloseNodeCallBack"),self:ToFunc("OnClick_CloseBtn"))
    self:BindCloseBtn(self.CommonBack1_btn,self:ToFunc("CloseNodeCallBack"),self:ToFunc("OnClick_CloseBtn"))

    -- 不同类型会有不同的显示方法
    self.markInfoShowFunc = {
        [StoryConfig.StoryTrigger.OpenNpcStore] = self:ToFunc("ShowShop"),
        [StoryConfig.StoryTrigger.MercenaryHunt] = self:ToFunc("ShowMercenaryHunt"),
        [StoryConfig.StoryTrigger.Trace] = self:ToFunc("ShowTrace"),
        [StoryConfig.StoryTrigger.Rogue] = self:ToFunc("ShowRogueTrace"),
        [StoryConfig.StoryTrigger.Transport] = self:ToFunc("ShowTransport"),
        [StoryConfig.StoryTrigger.Asset] = self:ToFunc("ShowAsset"),
    }

    self.normalMarkBindFunc = {
        [StoryConfig.StoryTrigger.OpenNpcStore] = self:ToFunc("OnClick_Transport"),
        [StoryConfig.StoryTrigger.MercenaryHunt] = self:ToFunc("OnClick_Trace"),
        [StoryConfig.StoryTrigger.Trace] = self:ToFunc("OnClick_Trace"),
        [StoryConfig.StoryTrigger.Rogue] = self:ToFunc("OnClick_Trace"),
        [StoryConfig.StoryTrigger.Transport] = self:ToFunc("OnClick_Transport"),
        [StoryConfig.StoryTrigger.Asset] = self:ToFunc("OnClick_Asset"),
    }

    self.TaskBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Task"))
    self.markNameInput.onEndEdit:AddListener(self:ToFunc("OnEndEdit"))

    EventMgr.Instance:AddListener(EventName.ShopListUpdate, self:ToFunc("OnShopListUpdate"))
end

function WorldMapInfoPanel:__Show()
    self:SetAcceptInput(true)
    if self.args[1] then
        self:SetTempCustomMarkInfo(self.args[2], self.args[3], self.args[4], self.args[5])
    else
        self:UpdateInfo(self.args[2], self.args[3])
    end

    self.closeTimer = LuaTimerManager.Instance:AddTimer(1, 0.3, function ()
        UtilsUI.SetActive(self.BackClose, true)
        self.closeTimer = nil
    end)

    if DebugConfig.MapToolOpen then
        self.GMTool:SetActive(true)
        self.chuansongBtn_btn.onClick:AddListener(self:ToFunc("GMChuansong"))
    end
end

function WorldMapInfoPanel:SetTempCustomMarkInfo(uiPosX, uiPosY, customType, mapId)
    self.tempCustomPos = { x = uiPosX, y = uiPosY }
    self.tempCustomType = customType
    self.tempCustomName = TI18N("标记")
    self.mapId = mapId

    self:RefreshPanel()
end

function WorldMapInfoPanel:UpdateInfo(mapId, markInstanceId)
    self.mapId = mapId
    self.mark = mod.WorldMapCtrl:GetMark(markInstanceId)

    self:RefreshPanel()

    if DebugConfig.MapToolOpen then
        self.PosDesc_txt.text = string.format("坐标：x:%s | z:%s", self.mark.posX,self.mark.posY)
    end
end

function WorldMapInfoPanel:RefreshPanel()
    if self.tempCustomType then
        self.Task:SetActive(false)
        self.Normal:SetActive(false)
        self.Event:SetActive(false)
        self.CustomMark:SetActive(true)

        self:ShowTempCustomMark()
        return
    end

    self.CustomMark:SetActive(self.mark.type == FightEnum.MapMarkType.Custom)
    self.Task:SetActive(self.mark.type == FightEnum.MapMarkType.Task)
    self.Normal:SetActive(self.mark.type == FightEnum.MapMarkType.Ecosystem or self.mark.type == FightEnum.MapMarkType.LevelEvent)
    self.Event:SetActive(self.mark.type == FightEnum.MapMarkType.Event or self.mark.type == FightEnum.MapMarkType.SummonCar)

    self:ShowCustomMark()
    self:ShowTask()
    self:ShowNormal()
    self:ShowEvent()
    self:ShowSummonCar()
    LayoutRebuilder.ForceRebuildLayoutImmediate(self.DescPart.transform)
end

function WorldMapInfoPanel:ShowTempCustomMark()
    if not self.customTypeOnShow or not next(self.customTypeOnShow) then
        self:CreateCustomType()
    end

    self.markNameInput.text = self.tempCustomName

    self.MarkBtn1:SetActive(false)
    self.MarkBtn2:SetActive(false)
    self.MarkBtn3:SetActive(true)
end

function WorldMapInfoPanel:ShowCustomMark()
    if self.mark.type ~= FightEnum.MapMarkType.Custom then
        return
    end

    self.changeCustomName = self.mark.name
    self.changeCustomType = self.mark.customType
    if not self.customTypeOnShow or not next(self.customTypeOnShow) then
        self:CreateCustomType()
    end

    self.markNameInput.text = self.mark.name

    self.MarkBtn1:SetActive(true)
    self.MarkBtn2:SetActive(true)
    self.MarkBtn3:SetActive(false)
    self.MarkBtn1Text_txt.text = self.mark.inTrace and TI18N("取消追踪") or TI18N("追踪")
end

function WorldMapInfoPanel:CreateCustomType()
    for _, v in pairs(FightEnum.MapMarkCustomType) do
        local obj = self:GetMarkTemp()
        self.customTypeOnShow[v] = obj

        local onToggleFunc = function ()
            self:CustomTypeToggleFunc(v)
        end

        obj["21029"]:SetActive(false)
        SingleIconLoader.Load(obj.MarkIcon, "Textures/Icon/Single/MapIcon/mark.png")

        obj.MarkTemp_tog.onValueChanged:RemoveAllListeners()
        obj.MarkTemp_tog.onValueChanged:AddListener(onToggleFunc)

        if not self.toggleMark then
            if not obj.MarkTemp_tog.isOn then
                obj.MarkTemp_tog.isOn = true
            else
                onToggleFunc()
            end
        end
    end
end

function WorldMapInfoPanel:CustomTypeToggleFunc(type)
    for k, v in pairs(self.customTypeOnShow) do
        v["21029"]:SetActive(k == type)
    end

    self.toggleMark = type

    if self.tempCustomType then
        self.tempCustomType = type
        self.parentWindow:ChangeTempCustomMarkType(type)
    else
        self.changeCustomType = type
    end
end

function WorldMapInfoPanel:ShowTask()
    if self.mark.type ~= FightEnum.MapMarkType.Task then
        return
    end

    local task = Fight.Instance.taskManager:GetGuideTask()
    local areaName = self:GetAreaName()
    UnityUtils.SetActive(self.TaskGoalObj, areaName ~= nil)
    if areaName then
        self.TaskGoal_txt.text = areaName
    end

    self.TaskName_txt.text = task.taskConfig.task_name
    self.TaskDesc_txt.text = task.taskConfig.task_desc
    self.TaskBtnText_txt.text = TI18N("取消追踪")

    local taskType = mod.TaskCtrl:GetTaskType(task.taskId)
    local icon = AssetConfig.GetTaskTypeIcon(taskType)
    SingleIconLoader.Load(self.TaskTypeIcon, icon)

    if task.taskConfig.show_award and task.taskConfig.show_award ~= 0 then
        UnityUtils.SetActive(self.TaskItemPart, true)
        local rewardCfg = DataReward[task.taskConfig.show_award]
		for k, itemInfoData in pairs(rewardCfg.reward_list) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, scale = 0.63}
			local item = ItemManager.Instance:GetItem(self.TaskItemPart, itemInfo)
			table.insert(self.taskItemOnShow, item)
		end
    else
        UnityUtils.SetActive(self.TaskItemPart, false)
    end
end

function WorldMapInfoPanel:ShowNormal()
    if self.mark.type ~= FightEnum.MapMarkType.Ecosystem and self.mark.type ~= FightEnum.MapMarkType.LevelEvent then
        return
    end

    local jumpCfg = self.mark.jumpCfg
    if not jumpCfg then
        return
    end

    if jumpCfg.show_reward and jumpCfg.show_reward ~= 0 then
        UnityUtils.SetActive(self.ItemPart, true)
        local rewardCfg = DataReward[jumpCfg.show_reward]
		for k, itemInfoData in pairs(rewardCfg.reward_list) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, scale = 1}
			local item = ItemManager.Instance:GetItem(self.ItemPart, itemInfo)
			table.insert(self.itemsOnShow, item)
		end
    else
        UnityUtils.SetActive(self.ItemPart, false)
    end

    if self.markInfoShowFunc[jumpCfg.type] then
        self.markInfoShowFunc[jumpCfg.type]()
        return
    end

    local areaName = self:GetAreaName()
    UnityUtils.SetActive(self.IconObj, areaName ~= nil)
    if areaName then
        self.Name_txt.text = areaName
    end

    self.Desc_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.des or self.mark.ecoCfg.desc
    self.MainBtnText_txt.text = self:GetNormalBtnDesc(self.mark)
    self.TypeName_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.name or self.mark.ecoCfg.name

    local icon = self:GetMarkIcon(self.mark)
    SingleIconLoader.Load(self.TypeIcon, icon)

    self.MainBtn_btn.onClick:RemoveAllListeners()
    self:BindCloseBtn(self.MainBtn_btn,self:ToFunc("CloseNodeCallBack"),self:ToFunc("OnClick_CloseBtn"))
end

function WorldMapInfoPanel:ShowSummonCar()
    if self.mark.type ~= FightEnum.MapMarkType.SummonCar then
        return
    end

    local jumpCfg  = Config.DataNpcSystemJump.Find[100201]
    
	local desc = self.mark.inTrace and TI18N("取消追踪") or TI18N("追踪")

    self.EventTypeName_txt.text = jumpCfg.name
    --描述
    self.EventDesc_txt.text = jumpCfg.des
    --按钮文本
    self.eventMainBtnText_txt.text = desc
    
    local icon = jumpCfg.icon
    SingleIconLoader.Load(self.EventTypeIcon, icon)


    self.eventMainBtn_btn.onClick:RemoveAllListeners()
    self.eventMainBtn_btn.onClick:AddListener(self.normalMarkBindFunc[StoryConfig.StoryTrigger.Trace])

end

function WorldMapInfoPanel:ShowEvent()
    if self.mark.type ~= FightEnum.MapMarkType.Event then
        return
    end

    local jumpCfg = self.mark.jumpCfg
    if not jumpCfg then
        return
    end
    
    if self.markInfoShowFunc[jumpCfg.type] then
        self.markInfoShowFunc[jumpCfg.type]()
        return
    end

    if jumpCfg.show_reward and jumpCfg.show_reward ~= 0 then
        UnityUtils.SetActive(self.EventItemPart, true)
        local rewardCfg = DataReward[jumpCfg.show_reward]
		for k, itemInfoData in pairs(rewardCfg.reward_list) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, scale = 1}
			local item = ItemManager.Instance:GetItem(self.EventItemPart, itemInfo)
			table.insert(self.eventItemOnShow, item)
		end
    else
        UnityUtils.SetActive(self.EventItemPart, false)
    end

    self.eventMainBtn_btn.onClick:RemoveAllListeners()
    self:BindCloseBtn(self.eventMainBtn_btn,self:ToFunc("CloseNodeCallBack"),self:ToFunc("OnClick_CloseBtn"))
end

function WorldMapInfoPanel:ShowShop()
    local areaName = self:GetAreaName()
    UnityUtils.SetActive(self.IconObj, areaName ~= nil)
    if areaName then
        self.Name_txt.text = areaName
    end

    self.Desc_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.des or self.mark.ecoCfg.desc
    self.MainBtnText_txt.text = self:GetNormalBtnDesc(self.mark)
    self.TypeName_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.name or self.mark.ecoCfg.name

    local icon = self:GetMarkIcon(self.mark)
    SingleIconLoader.Load(self.TypeIcon, icon)

    self.MainBtn_btn.onClick:RemoveAllListeners()
    self.MainBtn_btn.onClick:AddListener(self.normalMarkBindFunc[self.mark.jumpCfg.type])

    local shopCfg = ShopConfig.GetShopInfoById(self.mark.jumpCfg.param[1])
    if shopCfg.show_reward and shopCfg.show_reward ~= 0 then
        UnityUtils.SetActive(self.ItemPart, true)
        local rewardCfg = DataReward[shopCfg.show_reward]
        for k, itemInfoData in pairs(rewardCfg.reward_list) do
			local itemInfo = {template_id = itemInfoData[1], count = itemInfoData[2], can_lock = false, scale = 1}
			local item = ItemManager.Instance:GetItem(self.ItemPart, itemInfo)
			table.insert(self.itemsOnShow, item)
		end
    end
end

function WorldMapInfoPanel:ShowTrace()
    local areaName = self:GetAreaName()
    UnityUtils.SetActive(self.IconObj, areaName ~= nil)
    if areaName then
        self.Name_txt.text = areaName
    end

    self.Desc_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.des or self.mark.ecoCfg.desc
    self.MainBtnText_txt.text = self:GetNormalBtnDesc(self.mark)
    self.TypeName_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.name or self.mark.ecoCfg.name

    local icon = self:GetMarkIcon(self.mark)
    SingleIconLoader.Load(self.TypeIcon, icon)

    self.MainBtn_btn.onClick:RemoveAllListeners()
    self.MainBtn_btn.onClick:AddListener(self.normalMarkBindFunc[self.mark.jumpCfg.type])
end

function WorldMapInfoPanel:ShowRogueTrace()
    --获取事件id
    local eventId = self.mark.eventId
    local rogueEventConfig = RoguelikeConfig.GetRougelikeEventConfig(eventId)
    if not rogueEventConfig then return end
    --名字
    self.EventTypeName_txt.text = rogueEventConfig.name
    --描述
    self.EventDesc_txt.text = rogueEventConfig.des
    --按钮文本
    self.eventMainBtnText_txt.text = self:GetNormalBtnDesc(self.mark)
    
    local eventTypeConfig = RoguelikeConfig.GetRougelikeEventTypeConfig(rogueEventConfig.event_type)
    if eventTypeConfig and eventTypeConfig.map_icon ~= "" then
        SingleIconLoader.Load(self.EventTypeIcon, eventTypeConfig.map_icon)
    end

    self.eventMainBtn_btn.onClick:RemoveAllListeners()
    self.eventMainBtn_btn.onClick:AddListener(self.normalMarkBindFunc[self.mark.jumpCfg.type])
end

function WorldMapInfoPanel:ShowTransport()
    local areaName = self:GetAreaName()
    UnityUtils.SetActive(self.IconObj, areaName ~= nil)
    if areaName then
        self.Name_txt.text = areaName
    end

    self.Desc_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.des or self.mark.ecoCfg.desc
    self.MainBtnText_txt.text = self:GetNormalBtnDesc(self.mark)
    self.TypeName_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.name or self.mark.ecoCfg.name

    local icon = self:GetMarkIcon(self.mark)
    SingleIconLoader.Load(self.TypeIcon, icon)

    self.MainBtn_btn.onClick:RemoveAllListeners()
    self.MainBtn_btn.onClick:AddListener(self.normalMarkBindFunc[self.mark.jumpCfg.type])
end

function WorldMapInfoPanel:ShowAsset()
    local areaName = self:GetAreaName()
    UnityUtils.SetActive(self.IconObj, areaName ~= nil)
    if areaName then
        self.Name_txt.text = areaName
    end

    self.Desc_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.des or self.mark.ecoCfg.desc
    self.MainBtnText_txt.text = self:GetNormalBtnDesc(self.mark)
    self.TypeName_txt.text = self.mark.jumpCfg and self.mark.jumpCfg.name or self.mark.ecoCfg.name

    local icon = self:GetMarkIcon(self.mark)
    SingleIconLoader.Load(self.TypeIcon, icon)

    self.MainBtn_btn.onClick:RemoveAllListeners()
    self.MainBtn_btn.onClick:AddListener(self.normalMarkBindFunc[self.mark.jumpCfg.type])
end

function WorldMapInfoPanel:GetMarkIcon(mark)
    if mark.type == FightEnum.MapMarkType.Ecosystem then
        local ecoCfg = mark.ecoCfg
        local jumpCfg = mark.jumpCfg
        local icon = jumpCfg.icon
        if ecoCfg.is_transport and not mod.WorldCtrl:CheckIsTransportPointActive(ecoCfg.id) then
            local tempStr = string.sub(icon, 1, string.len(icon) - 4)
            tempStr = tempStr .. "_lock.png"
            icon = tempStr
        end

        return icon
    else
        return mark.icon
    end
end

function WorldMapInfoPanel:GetAreaName()
    local areaInfo, areaType, bigAreaInfo = Fight.Instance.mapAreaManager:GetAreaInfoByPosition(self.mark.position, self.mapId)
    if areaInfo and next(areaInfo) then
        return bigAreaInfo.name.."·"..areaInfo.name
    end

    return
end

function WorldMapInfoPanel:GetNormalBtnDesc(mark)
    local desc = NormalBtn_Desc[mark.jumpCfg.type]
    if not desc then
        return TI18N("确认")
    end

    if mark.jumpCfg.type == StoryConfig.StoryTrigger.Transport then
        local isActive = mod.WorldCtrl:CheckIsTransportPointActive(self.mark.ecoCfg.id)
        desc = isActive and TI18N("传送") or (mark.inTrace and TI18N("取消追踪") or TI18N("追踪"))
    elseif mark.jumpCfg.type == StoryConfig.StoryTrigger.Trace then
        desc = mark.inTrace and TI18N("取消追踪") or TI18N("追踪")
    elseif mark.jumpCfg.type == StoryConfig.StoryTrigger.Rogue then
        desc = mark.inTrace and TI18N("取消追踪") or TI18N("追踪")
    elseif mark.jumpCfg.type == StoryConfig.StoryTrigger.Asset then
        if mod.AssetPurchaseCtrl:GetExistingAssetInfoById(mark.jumpCfg.param[1]) then
            desc = string.format(TI18N("传送至%s"),mark.jumpCfg.name)
        else
            desc = mark.inTrace and TI18N("取消追踪") or TI18N("追踪")
        end
    end

    return desc
end

function WorldMapInfoPanel:GetMarkTemp()
    if next(self.markTempPool) then
        local obj = table.remove(self.markTempPool)
        UnityUtils.SetActive(obj.obj, true)
        return obj
    end

    local obj = self:PopUITmpObject("MarkTemp")
    obj = UtilsUI.GetContainerObject(obj.objectTransform, obj)

    obj.object:SetActive(true)
    obj.objectTransform:SetParent(self.CreateList.transform)
    UnityUtils.SetLocalScale(obj.objectTransform, 1, 1, 1)
    UtilsUI.SetEffectSortingOrder(obj["21029"], self.canvas.sortingOrder + 1)

    return obj
end

function WorldMapInfoPanel:HidePanel(ingoreHideMark)
    self.ingoreHideMark = ingoreHideMark
    self.CloseNode:SetActive(true)
end

-- TODO 可能会有没有生态ID的传送
function WorldMapInfoPanel:OnClick_Transport()
    if self.mark.jumpCfg.type == StoryConfig.StoryTrigger.OpenNpcStore then
        local position = BehaviorFunctions.GetTerrainPositionP(self.mark.jumpCfg.position[2], self.mapId, self.mark.jumpCfg.position[1])
        local rot = Quat.New(position.rotX, position.rotY, position.rotZ, position.rotW):ToEulerAngles()
        mod.WorldMapFacade:SendMsg("map_enter", self.mapId, position.x, position.y, position.z, rot.x, rot.y, rot.z)
        return
    end

    if not mod.WorldCtrl:CheckIsTransportPointActive(self.mark.ecoCfg.id) then
        self:OnClick_Trace()
        return
    end

    local mapConfig = mod.WorldMapCtrl:GetMapConfig(self.mapId)
    mod.WorldMapCtrl:SendMapTransport(mapConfig.position_id, self.mark.ecoCfg.id)
    --WindowManager.Instance:CloseWindow(WorldMapWindow)
end

function WorldMapInfoPanel:OnClick_Trace()
    mod.WorldMapCtrl:ChangeMarkTraceState(self.mark.instanceId, not self.mark.inTrace)
    self.CloseNode:SetActive(true)
end

function WorldMapInfoPanel:OnClick_Task()
    local timerFunc = function ()
        local id, cmd = mod.TaskCtrl:ChangeGuideTask(0)
		mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
			mod.TaskCtrl:SetGuideTaskId()
		end)
    end

    LuaTimerManager.Instance:AddTimer(1, 0.05, timerFunc)
    self.CloseNode:SetActive(true)
end

function WorldMapInfoPanel:OnClick_DelCustomMark()
    mod.WorldMapCtrl:RemoveCustomMark(self.mark.customId)
    self.CloseNode:SetActive(true)
end

function WorldMapInfoPanel:OnClick_AddCustomMark()
    self.parentWindow:OnClick_RemoveTempMark(true)
    mod.WorldMapCtrl:SendCustomMapMark(self.tempCustomPos, self.tempCustomType, self.tempCustomName, self.mapId)
    self.CloseNode:SetActive(true)
end

function WorldMapInfoPanel:OnClick_Asset()
    if mod.AssetPurchaseCtrl:GetExistingAssetInfoById(self.mark.jumpCfg.param[1]) then
        mod.AssetPurchaseCtrl:GotoAsset(self.mark.jumpCfg.param[1])
    else
        mod.WorldMapCtrl:ChangeMarkTraceState(self.mark.instanceId, not self.mark.inTrace)
        self.CloseNode:SetActive(true)
    end
end

function WorldMapInfoPanel:OnEndEdit()
    if self.tempCustomType then
        self.tempCustomName = self.markNameInput.text
    else
        self.changeCustomName = self.markNameInput.text
    end
end

function WorldMapInfoPanel:OnClick_CloseBtn()
    if self.tempCustomType then
        self.parentWindow:OnClick_RemoveTempMark()
    elseif self.mark.name ~= self.changeCustomName or self.mark.customType ~= self.changeCustomType then
        mod.WorldMapCtrl:ChangeCustomMark(self.mark.instanceId, self.changeCustomName, self.changeCustomType)
    end
end

function WorldMapInfoPanel:CloseNodeCallBack()
    self:Hide()
end

function WorldMapInfoPanel:OnShopListUpdate(shopId)
    if not self.active or not self.waitShopId or self.waitShopId ~= shopId then
        return
    end

    self.waitShopId = nil
    local shopList = mod.ShopCtrl:GetGoodsList(self.mark.jumpCfg.param[1])
    if not shopList or not next(shopList) then
        UnityUtils.SetActive(self.ItemPart, false)
        return
    end

    UnityUtils.SetActive(self.ItemPart, true)
    for k, v in pairs(shopList) do
        local itemInfo = {
            template_id = v.item_id,
            scale = 1
        }

        table.insert(self.itemsOnShow, ItemManager.Instance:GetItem(self.ItemPart, itemInfo))
    end
end

function WorldMapInfoPanel:GMChuansong()
    local y = tonumber(self.GmYInput.text)
    local posX, posZ = mod.WorldMapCtrl:TransUIPosToWorldPos(self.mark.posX,  self.mark.posY, self.mapId)
    mod.WorldMapFacade:SendMsg("map_enter", self.mapId, posX, y or 150, posZ)
end

function WorldMapInfoPanel:__Hide()
    self.mark = {}
    self.toggleMark = nil
    self.parentWindow:ShowCloseNode()
    if not self.ingoreHideMark then
        self.ingoreHideMark = nil
        self.parentWindow:HideSelectedMark(self.tempCustomType ~= nil)
    end

    for k, v in pairs(self.itemsOnShow) do
        ItemManager.Instance:PushItemToPool(v)
        self.itemsOnShow[k] = nil
    end

    for k, v in pairs(self.taskItemOnShow) do
        ItemManager.Instance:PushItemToPool(v)
        self.taskItemOnShow[k] = nil
    end

    for k, v in pairs(self.eventItemOnShow) do
        ItemManager.Instance:PushItemToPool(v)
        self.eventItemOnShow[k] = nil
    end

    for _, v in pairs(self.customTypeOnShow) do
        local obj = table.remove(self.customTypeOnShow)
        UnityUtils.SetActive(obj.obj, false)
        table.insert(self.markTempPool, obj)
    end

    self.tempCustomType = nil
    self.tempCustomName = nil
    self.tempCustomPos = {}

    self.changeCustomType = nil
    self.changeCustomName = nil

    self.waitShopId = nil

    if self.closeTimer then
        LuaTimerManager.Instance:RemoveTimer(self.closeTimer)
        self.closeTimer = nil
    end

    UtilsUI.SetActive(self.BackClose, false)
end

function WorldMapInfoPanel:__delete()
    self.chuansongBtn_btn.onClick:RemoveAllListeners()
    self.mark = {}
end