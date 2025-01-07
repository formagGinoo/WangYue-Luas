FightInteractPanel = BaseClass("FightInteractPanel", BasePanel)


function FightInteractPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightInteractPanel.prefab")
    self.mainView = mainView
    self.interactMap = {}--按钮列表
    self.cacheMap = {}
    self.interactList = {} --信息列表
    self.uniqueIdList = {} --独占id列表
    self.selectIndex = nil --默认选择第几个
    self.startIndex = 1
    self.endIndex = 3
end

function FightInteractPanel:__CacheObject()
end

function FightInteractPanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.ActiveWorldInteract, self:ToFunc("ActiveWorldInteract"))
    EventMgr.Instance:AddListener(EventName.RemoveWorldInteract, self:ToFunc("RemoveWorldInteract"))
    EventMgr.Instance:AddListener(EventName.HideWorldInteract, self:ToFunc("HideWorldInteract"))
    EventMgr.Instance:AddListener(EventName.ShowWorldInteract, self:ToFunc("ShowWorldInteract"))
    EventMgr.Instance:AddListener(EventName.WorldInteractKeyClick, self:ToFunc("WorldInteractKeyClick"))
    EventMgr.Instance:AddListener(EventName.GetLastInstanceId, self:ToFunc("GetLastInstanceId"))
    EventMgr.Instance:AddListener(EventName.ReWorldInteractClick, self:ToFunc("ReWorldInteractClick"))
    EventMgr.Instance:AddListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function FightInteractPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActiveWorldInteract, self:ToFunc("ActiveWorldInteract"))
    EventMgr.Instance:RemoveListener(EventName.RemoveWorldInteract, self:ToFunc("RemoveWorldInteract"))
    EventMgr.Instance:RemoveListener(EventName.HideWorldInteract, self:ToFunc("HideWorldInteract"))
    EventMgr.Instance:RemoveListener(EventName.ShowWorldInteract, self:ToFunc("ShowWorldInteract"))

    EventMgr.Instance:RemoveListener(EventName.WorldInteractKeyClick, self:ToFunc("WorldInteractKeyClick"))
    EventMgr.Instance:RemoveListener(EventName.GetLastInstanceId, self:ToFunc("GetLastInstanceId"))
    EventMgr.Instance:RemoveListener(EventName.ReWorldInteractClick, self:ToFunc("ReWorldInteractClick"))
    EventMgr.Instance:RemoveListener(EventName.ActionInput, self:ToFunc("OnActionInput"))
end

function FightInteractPanel:__BindEvent()

end

function FightInteractPanel:OnActionInput(key, value)
    if key == FightEnum.KeyEvent.MouseScroll then
        if not self.selectIndex then return end --代表界面还没出现，直接return
        
        if value.y > 100 then --往上滑
            self:OnScrollUp()
        elseif value.y < -100 then
            self:OnScrollDown()
        end
        self:UpdateInteractSelect()
        self:UpdateScrollViewPos()
    end
end

function FightInteractPanel:OnScrollUp()
    if self.selectIndex > 1 then
        self.selectIndex = self.selectIndex - 1
        
        if self.selectIndex < 1 then
            self.selectIndex = 1
        end
    end
end

function FightInteractPanel:OnScrollDown()
    if self.selectIndex >= 1 then
        self.selectIndex = self.selectIndex + 1
        
        if self.selectIndex > #self.uniqueIdList then
            self.selectIndex = #self.uniqueIdList
        end
    end
end

function FightInteractPanel:UpdateInteractSelect()
    local uniqueInfo = self.uniqueIdList[self.selectIndex]
    if not uniqueInfo then return end 
    for instanceId, v in pairs(self.interactMap) do
        if instanceId == uniqueInfo.instanceId and v[uniqueInfo.uniqueId] then
            for uniqueId, item in pairs(v) do
                if uniqueId == uniqueInfo.uniqueId then
                    UtilsUI.SetActive(item.Select, true)
                else
                    UtilsUI.SetActive(item.Select, false)
                end
            end
        else
            for _, item in pairs(v) do
                UtilsUI.SetActive(item.Select, false)
            end
        end
    end
end

function FightInteractPanel:UpdateMouseBtnState()
    local num = #self.uniqueIdList
    self.mouseBtn:SetActive(num > 1)
    if num == 2 then
        UnityUtils.SetLocalPosition(self.mouseBtn.transform, self.mouseBtn.transform.localPosition.x, 20,0)
    else
        UnityUtils.SetLocalPosition(self.mouseBtn.transform, self.mouseBtn.transform.localPosition.x, -20,0)
    end
end
 
--当滑动鼠标滚轮时，判断当前index
function FightInteractPanel:UpdateScrollViewPos()
    --如果在框里面，则不移动，在框外面则移动
    if self.selectIndex >= self.startIndex and self.selectIndex <= self.endIndex then 
        return 
    end 
    
    --如果超出框的位置，则更新框的起始下标和结束下标
    if self.selectIndex > self.endIndex then
        self.endIndex = self.selectIndex
        self.startIndex = self.endIndex - 2
    elseif self.selectIndex < self.startIndex then
        self.startIndex = self.selectIndex
        self.endIndex = self.startIndex + 2
    end

    local scrollviewHeight = 0
    if self.selectIndex > 3 then
        local addHeight = self.selectIndex - 3
        scrollviewHeight = addHeight * 60
    end

    local onclickFunc = function ()
        if self.mapMoveSequence then
            self.mapMoveSequence:Kill()
            self.mapMoveSequence = nil
        end

        self.mapMoveSequence = DOTween.Sequence()
        local targetPos = Vector3(0, scrollviewHeight, 0)
        local tween = self.WorldInteract.transform:DOLocalMove(targetPos, 0.1, true)
        self.mapMoveSequence:Append(tween)
    end
    onclickFunc()
end

function FightInteractPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightInteractPanel:__Show()
end

function FightInteractPanel:__Hide()
	self:RemoveAllInteract()
    self.selectIndex = nil
end

function FightInteractPanel:PopItem(uniqueId, instanceId, type)
    local initItem = function(itemInfo, _uniqueId, _instanceId, _type)
        itemInfo.uniqueId = _uniqueId
        itemInfo.instanceId = _instanceId
        itemInfo.Select:SetActive(false)
        --itemInfo.InteractIcon_img.color = Color.white
        itemInfo.drapEvent.onPointerEnter = function ()
            self:OnPointerEnter(itemInfo)
            --itemInfo.Select:SetActive(true)
            --itemInfo.UnSelect:SetActive(false)
            -- UtilsUI.SetTextColor(itemInfo.InteractText_txt, "#2C3339")
            -- if _type ~= WorldEnum.InteractType.Item and _type ~= WorldEnum.InteractType.Drive then
            --     UtilsUI.SetImageColor(itemInfo.InteractIcon_img, "#30373D")
            -- end
        end
        itemInfo.drapEvent.onPointerExit = function ()
            self:OnPointerExit(itemInfo)
            --itemInfo.Select:SetActive(false)
            --itemInfo.UnSelect:SetActive(true)
            -- itemInfo.InteractText_txt.color = Color.white
            -- if _type ~= WorldEnum.InteractType.Item and _type ~= WorldEnum.InteractType.Drive then
            --     itemInfo.InteractIcon_img.color = Color.white
            -- end
        end
    end

    if #self.cacheMap > 0 then
        local itemInfo = table.remove(self.cacheMap)
        UnityUtils.SetLocalScale(itemInfo.Interact_rect, 1, 1,1)
        itemInfo.Interact_rect:SetParent(self.WorldInteract.transform)
        initItem(itemInfo, uniqueId, instanceId, type)
        return itemInfo
    end
    local itemInfo = {}
    local itemInfo = self:PopUITmpObject("Interact", self.WorldInteract_rect)
    itemInfo.drapEvent = itemInfo.Interact:AddComponent(UIDragBehaviour)
    initItem(itemInfo, uniqueId, instanceId, type)
    UnityUtils.SetLocalScale(itemInfo.Interact_rect, 1, 1,1)
    -- UtilsUI.SetHideCallBack(itemInfo.InteractHideNode,function ()
    --     self:HideItem(itemInfo.uniqueId)
    -- end)
    itemInfo.Interact_btn.onClick:RemoveAllListeners()
    itemInfo.Interact_btn.onClick:AddListener(function ()
        itemInfo.Select:SetActive(false)
        --itemInfo.UnSelect:SetActive(true)
        --itemInfo.InteractText_txt.color = Color.white
        --itemInfo.InteractIcon_img.color = Color.white
        self:WorldInteractClick(itemInfo.uniqueId, itemInfo.instanceId)
    end)
    return itemInfo
end

function FightInteractPanel:PushItem(itemInfo)
    itemInfo.Interact_rect:SetParent(self.cache_rect)
    itemInfo.Select:SetActive(false)
    --itemInfo.UnSelect:SetActive(true)
    itemInfo.uniqueId = 0
    itemInfo.instanceId = 0
    table.insert(self.cacheMap, itemInfo)
end

function FightInteractPanel:OnPointerEnter(itemInfo)
    for index, v in pairs(self.uniqueIdList) do
        if v.uniqueId == itemInfo.uniqueId and v.instanceId == itemInfo.instanceId then
            self.selectIndex = index
            break
        end
    end
    self:UpdateInteractSelect()
end

function FightInteractPanel:OnPointerExit(itemInfo)

end

function FightInteractPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

function FightInteractPanel:ActiveWorldInteract(type, icon, text, quality, count, uniqueId, instanceId)
    if not self.active then
        return
    end

    if self.interactList[instanceId] and self.interactList[instanceId][uniqueId]  then
        return
    end

    if type == WorldEnum.InteractType.Jade then
        local costConfig = Config.DataCommonCfg.Find["PartnerObtain"]
        local itemInfo = ItemConfig.GetItemConfig(costConfig.int_val)
        local qualityColor = ItemConfig.QualityColor[itemInfo.quality]
        text = string.format("%s-消耗<color=#%s>%s*%d</color>",text,qualityColor,itemInfo.name,costConfig.int_val2)
    end

    local interactInfo = {
        type = type,
        icon = icon,
        text = text,
        quality = quality,
        time = os.time(),
        count = count,
        uniqueId = uniqueId,
        instanceId = instanceId
    }

    if not self.interactList[instanceId] then
        self.interactList[instanceId] = {}
    end
    self.interactList[instanceId][uniqueId] = interactInfo
    table.insert(self.uniqueIdList, { instanceId = instanceId, uniqueId = uniqueId , hide = false})

    self:ShowInteractItem(interactInfo)

    --每次都默认选第一个
    self.selectIndex = nil
    for index, v in pairs(self.uniqueIdList) do
        if v.hide == false then
            self.selectIndex = index
            break
        end
    end
    if not self.selectIndex then
        self.selectIndex = 1
    end
    self:UpdateInteractSelect()
    self:UpdateMouseBtnState()
end

function FightInteractPanel:ShowWorldInteract(instanceId, interactId)
    if not self.interactList[instanceId] or not self.interactList[instanceId][interactId] then
        return
    end
    local itemInfo = self.interactMap[instanceId][interactId]
    UtilsUI.SetActive(itemInfo.Interact, true)
    UtilsUI.SetActive(self.WorldInteract, true)
    self:UpdateMouseBtnState()
    for index, v in pairs(self.uniqueIdList) do
        if v.uniqueId == itemInfo.uniqueId and v.instanceId == itemInfo.instanceId then
            v.hide = false
        end
        if v.hide == false then
            self.selectIndex = index
        end
    end
    self:UpdateInteractSelect()
end

function FightInteractPanel:HideWorldInteract(instanceId, interactId)
    if not self.interactList[instanceId] or not self.interactList[instanceId][interactId] then
        return
    end
    local itemInfo = self.interactMap[instanceId][interactId]
    UtilsUI.SetActive(itemInfo.Interact, false)
    local temp = false
    for index, v in pairs(self.uniqueIdList) do
        if v.uniqueId == itemInfo.uniqueId and v.instanceId == itemInfo.instanceId then
            v.hide = true
        end
        if v.hide == false then
            self.selectIndex = index
            temp = true
        end

    end
    
    if temp == false then
        UtilsUI.SetActive(self.WorldInteract, false)
        UtilsUI.SetActive(self.mouseBtn, false)
    end
    self:UpdateInteractSelect()
end

function FightInteractPanel:ShowInteractItem(interactInfo)
    local interactObj = self:PopItem(interactInfo.uniqueId, interactInfo.instanceId, interactInfo.type)
    if not self.interactMap[interactInfo.instanceId] then
        self.interactMap[interactInfo.instanceId] = {}
    end
    self.interactMap[interactInfo.instanceId][interactInfo.uniqueId] = interactObj
    if next(self.interactMap) then
        self.WorldInteract:SetActive(true)
    end
    interactObj.Interact:SetActive(true)
    interactObj.InteractText_txt.color = Color.white
    local quality = interactInfo.quality or 1
    SingleIconLoader.Load(interactObj.Quality, ItemConfig.QualityIcon[quality])

    local icon = interactInfo.icon
    -- 有配icon的优先用icon
    if interactInfo.type ~= WorldEnum.InteractType.Item and not interactInfo.icon then
        icon = AssetConfig.GetInteractionTypeIcon(tostring(interactInfo.type))
    end
    SingleIconLoader.Load(interactObj.InteractIcon, icon)
    interactObj.InteractText_txt.text = interactInfo.text
    if interactInfo.count then
        interactObj.InteractCount_txt.text = interactInfo.count
        interactObj.CountNode:SetActive(true)
    else
        interactObj.CountNode:SetActive(false)
    end
end

function FightInteractPanel:WorldInteractClick(uniqueId, instanceId)
    if not instanceId or instanceId == 0 then return end
    if not uniqueId or uniqueId == 0 then return end
    local interactInfo = self.interactList[instanceId][uniqueId]
    if not interactInfo then
        return
    end
    self.lastInstanceId = interactInfo.instanceId
    self.lastUniqueId = interactInfo.uniqueId
	Fight.Instance.entityManager:CallBehaviorFun("WorldInteractClick", interactInfo.uniqueId, interactInfo.instanceId)
    EventMgr.Instance:Fire(EventName.WorldInteractClick, interactInfo.uniqueId, interactInfo.instanceId)
end

function FightInteractPanel:ReWorldInteractClick()
    self:WorldInteractClick(self.lastUniqueId, self.lastInstanceId)
end

function FightInteractPanel:RemoveWorldInteract(instanceId, uniqueId)
    if not self.active then
        return
    end

	if self.interactList[instanceId][uniqueId] == nil then
		return
	end
    self.interactList[instanceId][uniqueId] = nil
    local itemInfo = self.interactMap[instanceId][uniqueId]
    -- itemInfo.InteractHideNode:SetActive(true)
    itemInfo.Interact:SetActive(false)
    for k, v in pairs(self.uniqueIdList) do
        if v.uniqueId == uniqueId and v.instanceId == instanceId then
            table.remove(self.uniqueIdList, k)
            break
        end
    end
	self:HideItem(uniqueId, instanceId)
    
    self:SelectIndexUpdate()
    self:UpdateMouseBtnState()
end

function FightInteractPanel:SelectIndexUpdate()
    --优先选中他的下一个；如果没有下一个，则选中上一个
    if not next(self.uniqueIdList) then
        self.selectIndex = nil
        self.startIndex = 1
        self.endIndex = 3
    elseif self.uniqueIdList[self.selectIndex] then
        self.selectIndex = self.selectIndex --因为上面用了remove所以不用动 
    elseif self.uniqueIdList[self.selectIndex - 1] then
        self.selectIndex = self.selectIndex - 1
        self.startIndex = self.startIndex - 1
        self.endIndex = self.endIndex - 1
    end
    self:UpdateInteractSelect()
end

function FightInteractPanel:RemoveAllInteract()
	for instanceId, v in pairs(self.interactList) do
        for uniqueId, interactInfo in pairs(v) do
		    self:RemoveWorldInteract(uniqueId, instanceId)
        end
	end
end


function FightInteractPanel:HideItem(uniqueId, instanceId)
    if not self.interactMap or not self.interactMap[instanceId] or not self.interactMap[instanceId][uniqueId] then
        return
    end
    self.interactMap[instanceId][uniqueId].Interact:SetActive(false)
	self:PushItem(self.interactMap[instanceId][uniqueId])
    self.interactMap[instanceId][uniqueId] = nil
    if not next(self.interactMap[instanceId]) then
        self.interactMap[instanceId] = nil
    end

    if not next(self.interactMap) then
        self.WorldInteract:SetActive(false)
    end
end

function FightInteractPanel:WorldInteractKeyClick()
    local uniqueInfo = self.uniqueIdList[self.selectIndex]
    if uniqueInfo then
        -- 临时交互的时候播音量
        self.interactMap[uniqueInfo.instanceId][uniqueInfo.uniqueId].Interact_sound:PlayButtonSound()
        self:WorldInteractClick(uniqueInfo.uniqueId, uniqueInfo.instanceId)
    end
end

function FightInteractPanel:GetLastInstanceId(remove)
    local res = self.lastInstanceId or 0
    if remove then
        self.lastInstanceId = 0
    end
    return res
end