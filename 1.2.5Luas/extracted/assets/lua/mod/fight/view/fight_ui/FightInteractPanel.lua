FightInteractPanel = BaseClass("FightInteractPanel", BasePanel)


function FightInteractPanel:__init(mainView)
    self:SetAsset("Prefabs/UI/Fight/FightInteractPanel.prefab")
    self.mainView = mainView
    self.interactMap = {}--按钮列表
    self.cacheMap = {}
    self.interactList = {} --信息列表
    self.uniqueIdList = {} --独占id列表
end

function FightInteractPanel:__CacheObject()
    self.audio = self.gameObject:GetComponent(AudioSource)
end

function FightInteractPanel:__BindListener()
    EventMgr.Instance:AddListener(EventName.ActiveWorldInteract, self:ToFunc("ActiveWorldInteract"))
    EventMgr.Instance:AddListener(EventName.RemoveWorldInteract, self:ToFunc("RemoveWorldInteract"))
    EventMgr.Instance:AddListener(EventName.WorldInteractKeyClick, self:ToFunc("WorldInteractKeyClick"))
    EventMgr.Instance:AddListener(EventName.GetLastInstanceId, self:ToFunc("GetLastInstanceId"))
end

function FightInteractPanel:__BindEvent()

end

function FightInteractPanel:__BaseShow()
	self:SetParent(self.mainView.PanelParent.transform)
end

function FightInteractPanel:__Show()
end

function FightInteractPanel:__Hide()
	self:RemoveAllInteract()
end

function FightInteractPanel:PopItem(uniqueId, type)
    if #self.cacheMap > 0 then
        local itemInfo = table.remove(self.cacheMap)
        itemInfo.uniqueId = uniqueId
        itemInfo.Interact_rect:SetParent(self.WorldInteract.transform)
        itemInfo.InteractIcon_img.color = Color.white
        itemInfo.drapEvent.onPointerEnter = function ()
            itemInfo.Select:SetActive(true)
            itemInfo.UnSelect:SetActive(false)
            UtilsUI.SetTextColor(itemInfo.InteractText_txt, "#2C3339")
            if type ~= WorldEnum.InteractType.Item then
                UtilsUI.SetImageColor(itemInfo.InteractIcon_img, "#30373D")
            end
        end
        itemInfo.drapEvent.onPointerExit = function ()
            itemInfo.Select:SetActive(false)
            itemInfo.UnSelect:SetActive(true)
            itemInfo.InteractText_txt.color = Color.white
            if type ~= WorldEnum.InteractType.Item then
                itemInfo.InteractIcon_img.color = Color.white
            end
        end
        return itemInfo
    end
    local itemInfo = {}
    local go = GameObject.Instantiate(self.Interact, self.WorldInteract_rect)
    UtilsUI.GetContainerObject(go,itemInfo)
    itemInfo.drapEvent = itemInfo.Interact:AddComponent(UIDragBehaviour)
    itemInfo.InteractIcon_img.color = Color.white
    itemInfo.drapEvent.onPointerEnter = function ()
        itemInfo.Select:SetActive(true)
        itemInfo.UnSelect:SetActive(false)
        UtilsUI.SetTextColor(itemInfo.InteractText_txt, "#2C3339")
        if type ~= WorldEnum.InteractType.Item then
            UtilsUI.SetImageColor(itemInfo.InteractIcon_img, "#30373D")
        end
    end
    itemInfo.drapEvent.onPointerExit = function ()
        itemInfo.Select:SetActive(false)
        itemInfo.UnSelect:SetActive(true)
        itemInfo.InteractText_txt.color = Color.white
        if type ~= WorldEnum.InteractType.Item then
            itemInfo.InteractIcon_img.color = Color.white
        end
    end

    itemInfo.uniqueId = uniqueId
    UtilsUI.SetHideCallBack(itemInfo.InteractHideNode,function ()
        self:HideItem(itemInfo.uniqueId)
    end)
    itemInfo.Interact_btn.onClick:RemoveAllListeners()
    itemInfo.Interact_btn.onClick:AddListener(function ()
        itemInfo.Select:SetActive(false)
        itemInfo.UnSelect:SetActive(true)
        itemInfo.InteractText_txt.color = Color.white
        self:WorldInteractClick(itemInfo.uniqueId)
        self.audio:PlayOneShot(self.audio.clip,1)
    end)
    return itemInfo
end

function FightInteractPanel:PushItem(itemInfo)
    itemInfo.Interact_rect:SetParent(self.cache_rect)
    itemInfo.Select:SetActive(false)
    itemInfo.UnSelect:SetActive(true)
    itemInfo.InteractText_txt.color = Color.white
    itemInfo.uniqueId = 0
    table.insert(self.cacheMap, itemInfo)
end

function FightInteractPanel:__delete()
    EventMgr.Instance:RemoveListener(EventName.ActiveWorldInteract, self:ToFunc("ActiveWorldInteract"))
    EventMgr.Instance:RemoveListener(EventName.RemoveWorldInteract, self:ToFunc("RemoveWorldInteract"))
    EventMgr.Instance:RemoveListener(EventName.WorldInteractKeyClick, self:ToFunc("WorldInteractKeyClick"))
    EventMgr.Instance:RemoveListener(EventName.GetLastInstanceId, self:ToFunc("GetLastInstanceId"))
end

function FightInteractPanel:__ShowComplete()
	self.mainView:AddLoadDoneCount()
end

local onSort = function (a, b)
    if a.type ~= b.type then
        return a.type < b.type
    end

    if a.quality ~= b.quality then
        return a.quality > b.quality
    end

    return a.time < b.time
end

function FightInteractPanel:ActiveWorldInteract(type, icon, text, quality, count, uniqueId, instanceId)
    if not self.active then
        return
    end

    if self.interactList[uniqueId] then
        return
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

    --table.insert(self.interactList, interactInfo)
    self.interactList[uniqueId] = interactInfo
    table.insert(self.uniqueIdList, uniqueId)

    --table.sort(self.interactList, onSort)
    self:ShowInteractItem(interactInfo)
end

function FightInteractPanel:ShowInteractItem(interactInfo)
    local interactObj = self:PopItem(interactInfo.uniqueId, interactInfo.type)
    self.interactMap[interactInfo.uniqueId] = interactObj
    if next(self.interactMap) then
        self.WorldInteract:SetActive(true)
    end
    --table.insert(self.interactMap, interactObj)
    --local index = #self.interactMap
    interactObj.Select:GetComponent(CanvasGroup).alpha = 1
    interactObj.Interact:SetActive(true)
    local colorData = FightGatherPanel.QualityColor[interactInfo.quality]
    UtilsUI.SetImageColor(interactObj.Quality_img, colorData)
    local icon
    if interactInfo.type == WorldEnum.InteractType.Item then
        icon = interactInfo.icon
    else
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

function FightInteractPanel:WorldInteractClick(uniqueId)
    if not uniqueId or uniqueId == 0 then return end
    local interactInfo = self.interactList[uniqueId]
    if not interactInfo then
        return
    end
    self.lastInstanceId = interactInfo.instanceId
	Fight.Instance.entityManager:CallBehaviorFun("WorldInteractClick", interactInfo.uniqueId)
end

function FightInteractPanel:RemoveWorldInteract(uniqueId)
    if not self.active then
        return
    end

	if self.interactList[uniqueId] == nil then
		return
	end
    self.interactList[uniqueId] = nil
    local itemInfo = self.interactMap[uniqueId]
    itemInfo.InteractHideNode:SetActive(true)
    for k, v in pairs(self.uniqueIdList) do
        if v == uniqueId then
            table.remove(self.uniqueIdList, k)
            break
        end
    end
end

function FightInteractPanel:RemoveAllInteract()
	for uniqueId, interactInfo in pairs(self.interactList) do
		self:RemoveWorldInteract(uniqueId)
	end
end


function FightInteractPanel:HideItem(uniqueId)
    if not self.interactMap or  not self.interactMap[uniqueId] then
        return
    end
    self.interactMap[uniqueId].InteractHideNode:SetActive(false)
	self:PushItem(self.interactMap[uniqueId])
    self.interactMap[uniqueId] = nil
    if not next(self.interactMap) then
        self.WorldInteract:SetActive(false)
    end
end

function FightInteractPanel:WorldInteractKeyClick()
    local uniqueId = self.uniqueIdList[1]
    if uniqueId then
        self:WorldInteractClick(uniqueId)
		self.audio:PlayOneShot(self.audio.clip,1)
    end
end

function FightInteractPanel:GetLastInstanceId(remove)
    local res = self.lastInstanceId or 0
    if remove then
        self.lastInstanceId = 0
    end

    Fight.Instance.storyDialogManager:OnRecv_LastInstanceId(res)

    return res
end