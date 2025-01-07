HeadInfoObj = BaseClass("HeadInfoObj", PoolBaseClass)

local objPrefab = "Prefabs/UI/Fight/HeadInfo/HeadInfoObj.prefab"

HeadInfoObj.INFO = {
    [1] = "Title",
    [2] = "Name",
    [3] = "Icon",
    [4] = "Talk"
}

HeadInfoObj.DistanceThreshold = {
    [0] = 50^2,--开始高频刷新
    [1] = 15^2,
    [2] = 15^2,
    [3] = 50^2,
    -- [4] = 8^2
}

HeadInfoObj.BubbleDistanceThreshold = 30 ^ 2

function HeadInfoObj:__init(headInfoManager)
    self.initFinish = false
    self.isDestroy = false
    self.gameObject = nil
    self.instanceId = nil
    self.entity = nil
    self.parent = nil
    self.showList = {}
	self.infoList = {
		[HeadInfoObj.INFO[1]] = "",
		[HeadInfoObj.INFO[2]] = "",
		[HeadInfoObj.INFO[3]] = "",
		[HeadInfoObj.INFO[4]] = "",
	}
    self.headInfo = nil
    self.talkId = nil
    self.timer = 0

    self.visible = true

    self.bubbleContent = nil
    self.bubbleDuration = 0
    self.bubbleTimer = 0
    self.bubbleVisible = false

    self.maxShowDistance = 0
    self.headInfoManager = headInfoManager

    self.bindTrans = nil
    self.localScale = 1
    self.isDirty = false

    self.distanceThreshold = {}
    for k, v in pairs(HeadInfoObj.DistanceThreshold) do
        self.distanceThreshold[k] = v
    end
end

function HeadInfoObj:__delete()
    if self.assertLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assertLoader)
        self.assertLoader = nil
    end
end

function HeadInfoObj:LoadHeadInfoObj(instanceId)
    local entity = BehaviorFunctions.GetEntity(instanceId)
    if not entity then
        LogError("instanceId = "..instanceId.." not found entity")
        return
    end

    self.entity = entity
    self.instanceId = instanceId
    local falg, obj = self:GetObject()

    self.parent = self:GetBindTrans()
    self.npcManager = Fight.Instance.entityManager.npcEntityManager

    if falg then
        self:OnLoadDone(obj)
    end
end

local distancePower

function HeadInfoObj:Update()
	-- PV专用
	if DebugClientInvoke.Cache.closeUI == true then
		UtilsUI.SetActiveByScale(self.gameObject,false)
		return
    else
        UtilsUI.SetActiveByScale(self.gameObject,true)
	end
    if not self.gameObject or not self.headInfoUpdate then return end

    if not self.visible then
        for i = 1, #self.distanceThreshold do
            self:SetShowIndex(false, i)
        end

        self:SetShowIndex(false, 4)
        return
    end

    self.timer = self.timer - FightUtil.deltaTimeSecond
    if self.bubbleTimer > 0 then
        self.bubbleTimer = self.bubbleTimer - FightUtil.deltaTimeSecond
	else
		self.bubbleVisible = false
    end

    if self.timer > 0 then
        return
    end

    distancePower = self.headInfoUpdate:CustomUpdate()
    if distancePower > self.distanceThreshold[0] then
        self.timer = 1
    else
        self.timer = 0
    end

    if distancePower > self.maxShowDistance then
        if self.isHide then
            return
        end
        self.isHide = true
    else
        self.isHide = false
    end

    self:UpdateShow(distancePower)

    
    if self.isDirty then
        self.DefaultShow()
    end

end

function HeadInfoObj:ChangeDistanceThreshold(arg0,arg1,arg2,arg3)
    self.distanceThreshold[0] = arg0 and arg0 or self.distanceThreshold[0]
    self.distanceThreshold[1] = arg1 and arg1 or self.distanceThreshold[1]
    self.distanceThreshold[2] = arg2 and arg2 or self.distanceThreshold[2]
    self.distanceThreshold[3] = arg3 and arg3 or self.distanceThreshold[3]
end

function HeadInfoObj:ChangeInfo()
    if not self.entity then
        return
    end

    if not self.npcManager then
        self.npcManager = Fight.Instance.entityManager.npcEntityManager
    end

    local npcCfg = self.npcManager:GetNpcConfig(self.entity.sInstanceId)
    if not npcCfg then
        
        return
    end

    self.infoList = {
        [HeadInfoObj.INFO[1]] = npcCfg.title,
        [HeadInfoObj.INFO[2]] = npcCfg.name,
        [HeadInfoObj.INFO[3]] = self.npcManager:GetNpcHeadIcon(self.entity.sInstanceId),
        [HeadInfoObj.INFO[4]] = self.bubbleContent,
    }
end

function HeadInfoObj:ChangeMaxDistance()
    local maxDistance = 0
    if self.infoList[HeadInfoObj.INFO[1]] and self.infoList[HeadInfoObj.INFO[1]] ~= "" then
		maxDistance = math.max(maxDistance, self.distanceThreshold[1])
    end

    if self.infoList[HeadInfoObj.INFO[2]] and self.infoList[HeadInfoObj.INFO[2]] ~= "" then
		maxDistance = math.max(maxDistance, self.distanceThreshold[2])
    end

    if self.infoList[HeadInfoObj.INFO[3]] and self.infoList[HeadInfoObj.INFO[3]] ~= "" then
		maxDistance = math.max(maxDistance, self.distanceThreshold[3])
    end

    if self.bubbleContent and self.bubbleContent ~= "" then
		maxDistance = math.max(maxDistance, HeadInfoObj.BubbleDistanceThreshold)
    end

    self.maxShowDistance = maxDistance
end

function HeadInfoObj:DefaultShow()
    if not self.gameObject then return end
    self.isDirty = false
    if not self.node then
        self.node = UtilsUI.GetContainerObject(self.gameObject.transform)
        self.spacing = self.node.Content:GetComponent(VerticalLayoutGroup).spacing
    end
    
    self.headInfoUpdate.customScale = self.localScale
    local switch = {
        [1] = function()
            if self.infoList[HeadInfoObj.INFO[1]] == "" then return end
            self.node.Title:GetComponent(TextMeshPro).text = self.infoList[HeadInfoObj.INFO[1]]
        end,
        [2] = function()
            if self.infoList[HeadInfoObj.INFO[2]] == "" then return end
            self.node.Name:GetComponent(TextMeshPro).text = self.infoList[HeadInfoObj.INFO[2]]
        end,
        [3] = function()
            if not self.infoList[HeadInfoObj.INFO[3]] or self.infoList[HeadInfoObj.INFO[3]] == "" then return end
            SingleIconLoader.Load(self.node.Icon, self.infoList[HeadInfoObj.INFO[3]])
        end,
        [4] = function()
            if self.infoList[HeadInfoObj.INFO[4]] == "" then return end
            self.node.TalkText:GetComponent(TextMeshPro).text = self.infoList[HeadInfoObj.INFO[4]]
        end
    }
    for i = 1, #HeadInfoObj.INFO do
        switch[i]()
        self.node[HeadInfoObj.INFO[i]]:SetActive(false)
    end
end

function HeadInfoObj:UpdateShow(distance)
    for i = 1, #self.distanceThreshold do
		local maxDis = self.distanceThreshold[i]
        if distance < maxDis then
            self:SetShowIndex(true, i)
        else
            self:SetShowIndex(false, i)
        end
    end

    local bubbleVisible = self.bubbleVisible and distance < HeadInfoObj.BubbleDistanceThreshold
    self:SetShowIndex(bubbleVisible, 4)
end

function HeadInfoObj:SetShowIndex(action, infoIndex, talkId)
    if self.showList[infoIndex] == action and self.node[HeadInfoObj.INFO[infoIndex]].activeSelf == action then return end
    self.showList[infoIndex] = action
    if talkId then
        self.talkId = talkId
    end
    if not self.node then
        self.node = UtilsUI.GetContainerObject(self.gameObject.transform)
    end
    self:DynamicEffect(infoIndex)
end

function HeadInfoObj:DynamicEffect(index)
    if self.infoList[HeadInfoObj.INFO[index]] == "" or self.infoList[HeadInfoObj.INFO[index]] == 0 then return end
    self.node[HeadInfoObj.INFO[index]]:SetActive(self.showList[index] or false)
    self:ScrollEffect(index, self.showList[index] or false)
end

--显示向下拉，隐藏向上拉
function HeadInfoObj:ScrollEffect(index, show)
    if show == nil then return end
	
    local y = self.spacing + self.node[HeadInfoObj.INFO[index].."_rect"].rect.height
    local tf = self.node.Content.transform
    if show then
        y = tf.anchoredPosition.y - y
    else
        y = tf.anchoredPosition.y + y
    end
    UnityUtils.SetAnchoredPosition(tf, tf.anchoredPosition.x, y)
end

function HeadInfoObj:SetBubbleVisible(visible)
    self.bubbleVisible = visible
    if visible then
        self.bubbleTimer = self.bubbleDuration
    end
end

function HeadInfoObj:SetHeadInfoVisible(visible)
    self.visible = visible
    if not visible then
        self.bubbleTimer = 0
    end
end

function HeadInfoObj:ChangeBubbleContent(content, duration, bubbleId)
    if not content or not duration then
        return
    end

    self.bubbleContent = content
    self.bubbleDuration = duration
    self.talkId = bubbleId

    self.isDirty = true
    self.infoList[HeadInfoObj.INFO[4]] = self.bubbleContent
	if not self.headInfoUpdate then
		return
	end

    local lastMaxDistance = self.maxShowDistance
    self:ChangeMaxDistance()
    self:DefaultShow()
    if lastMaxDistance ~= self.maxShowDistance then
        self.headInfoUpdate:Init(self:GetBindTrans(), self.maxShowDistance)
    end
end

function HeadInfoObj:ChangeHeadIcon(icon)
    if not icon then
        self.infoList[HeadInfoObj.INFO[3]] = ""
        if not self.entity or not self.entity.sInstanceId then
            goto continue
        end

        self.infoList[HeadInfoObj.INFO[3]] = self.npcManager:GetNpcHeadIcon(self.entity.sInstanceId)
    else
        self.infoList[HeadInfoObj.INFO[3]] = icon
    end

    self.isDirty = true
    ::continue::

	if not self.headInfoUpdate then
		return
	end

    local lastMaxDistance = self.maxShowDistance
    self:ChangeMaxDistance()
    self:DefaultShow()
    if lastMaxDistance ~= self.maxShowDistance then
        self.headInfoUpdate:Init(self:GetBindTrans(), self.maxShowDistance)
    end
end
function HeadInfoObj:GetBindTrans()
    if not self.bindTrans then
        -- 资产演出点位Decoration_MarkCase
        local trans = self.entity.clientTransformComponent:GetTransform("Decoration_MarkCase")
        if not trans then
            self.bindTrans = self.entity.clientEntity.clientTransformComponent.transform
        else
            self.bindTrans = trans
        end
    end
    return self.bindTrans
end

function HeadInfoObj:ChangeHeadTipScale(scale)


    self.localScale = scale
    self.isDirty = true
	if not self.headInfoUpdate then
		return
	end
    self:DefaultShow()
end
function HeadInfoObj:ChangeName(name)

    self.infoList[HeadInfoObj.INFO[2]] = name

    local lastMaxDistance = self.maxShowDistance

    self.isDirty = true
	if not self.headInfoUpdate then
		return
	end

    self:ChangeMaxDistance()
    self:DefaultShow()
    if lastMaxDistance ~= self.maxShowDistance then
        self.headInfoUpdate:Init(self:GetBindTrans(), self.maxShowDistance)
    end
end

function HeadInfoObj:GetObject()
    local obj = PoolManager.Instance:Pop(PoolType.object, "HeadInfoObject")
    if not obj then
        local callback = function ()
            local object = self.assertLoader:Pop(objPrefab)
            self:OnLoadDone(object)
        end
        local resList = {
            {path = objPrefab, type = AssetType.Prefab}
        }
        if self.assertLoader then
            AssetMgrProxy.Instance:CacheLoader(self.assertLoader)
            self.assertLoader = nil
        end
        self.assertLoader = AssetMgrProxy.Instance:GetLoader("HeadInfoObjLoader")
        self.assertLoader:AddListener(callback)
        self.assertLoader:LoadAll(resList)
        return false
    end
    return true, obj
end

function HeadInfoObj:OnLoadDone(object)
    if not self.entity then
        self.headInfoManager:DestoryHeadInfoObj(self.instanceId)
        return
    end

    local parent = Fight.Instance.clientFight.headInfoManager:GetRoot()
    object.transform:SetParent(parent.transform)
    self.gameObject = object
    self:ChangeInfo()
    self:ChangeMaxDistance()
    self.headInfoUpdate = object:GetComponent(HeadInfoUpdate)
    self.headInfoUpdate:Init(self:GetBindTrans(), self.maxShowDistance)
    self:DefaultShow()
end

function HeadInfoObj:OnReset()
    if self.gameObject then
        PoolManager.Instance:Push(PoolType.object, "HeadInfoObject", self.gameObject)
    end

    self.bindTrans = nil
    self.initFinish = false
    self.isDestroy = false
    self.gameObject = nil
    self.instanceId = nil
    self.entity = nil
    self.parent = nil
    self.showList = {}
    self.infoList = {
		[HeadInfoObj.INFO[1]] = "",
		[HeadInfoObj.INFO[2]] = "",
		[HeadInfoObj.INFO[3]] = "",
		[HeadInfoObj.INFO[4]] = "",
	}
    self.headInfo = nil
    self.talkId = nil
    self.timer = 0
    self.isHide = false
	
	

	self.bubbleContent = nil
	self.bubbleDuration = 0
	self.bubbleTimer = 0
	self.bubbleVisible = false
	self.maxShowDistance = 0
	self.localScale = 1
	self.isDirty = false

    self.distanceThreshold = {}
    for k, v in pairs(HeadInfoObj.DistanceThreshold) do
        self.distanceThreshold[k] = v
    end
	
end