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
    self.infoList = {}
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

    self.parent = self.entity.clientEntity.clientTransformComponent.transform
    self.npcManager = Fight.Instance.entityManager.npcEntityManager

    if falg then
        self:OnLoadDone(obj)
    end
end

local distancePower

function HeadInfoObj:Update()
    if not self.gameObject or not self.headInfoUpdate then return end

    if not self.visible then
        for i = 1, #HeadInfoObj.DistanceThreshold do
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
    if distancePower > HeadInfoObj.DistanceThreshold[0] then
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
end

function HeadInfoObj:ChangeInfo()
    if not self.entity then
        return
    end

    local npcCfg = self.npcManager:GetNpcConfig(self.entity.sInstanceId)
    if not npcCfg then
        self.infoList = {
            [HeadInfoObj.INFO[1]] = "",
            [HeadInfoObj.INFO[2]] = "",
            [HeadInfoObj.INFO[3]] = "",
            [HeadInfoObj.INFO[4]] = "",
        }
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
		maxDistance = math.max(maxDistance, HeadInfoObj.DistanceThreshold[1])
    end

    if self.infoList[HeadInfoObj.INFO[2]] and self.infoList[HeadInfoObj.INFO[2]] ~= "" then
		maxDistance = math.max(maxDistance, HeadInfoObj.DistanceThreshold[2])
    end

    if self.infoList[HeadInfoObj.INFO[3]] and self.infoList[HeadInfoObj.INFO[3]] ~= "" then
		maxDistance = math.max(maxDistance, HeadInfoObj.DistanceThreshold[3])
    end

    if self.bubbleContent and self.bubbleContent ~= "" then
		maxDistance = math.max(maxDistance, HeadInfoObj.BubbleDistanceThreshold)
    end

    self.maxShowDistance = maxDistance
end

function HeadInfoObj:DefaultShow()
    if not self.gameObject then return end
    if not self.node then
        self.node = UtilsUI.GetContainerObject(self.gameObject.transform)
        self.spacing = self.node.Content:GetComponent(VerticalLayoutGroup).spacing
    end
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
    for i = 1, #HeadInfoObj.DistanceThreshold do
        if distance < HeadInfoObj.DistanceThreshold[i] then
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
	
	if not self.headInfoUpdate then
		return
	end

    local lastMaxDistance = self.maxShowDistance
    self.infoList[HeadInfoObj.INFO[4]] = self.bubbleContent
    self:ChangeMaxDistance()
    self:DefaultShow()
    if lastMaxDistance ~= self.maxShowDistance then
        self.headInfoUpdate:Init(self.entity.clientEntity.clientTransformComponent.transform, self.maxShowDistance)
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

    ::continue::

    local lastMaxDistance = self.maxShowDistance
    self:ChangeMaxDistance()
    self:DefaultShow()
    if lastMaxDistance ~= self.maxShowDistance then
        self.headInfoUpdate:Init(self.entity.clientEntity.clientTransformComponent.transform, self.maxShowDistance)
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
            self.assertLoader:DeleteMe()
            self.assertLoader = nil
        end
        self.assertLoader = AssetBatchLoader.New("HeadInfoObjLoader")
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
    self:DefaultShow()
    self.headInfoUpdate = object:GetComponent(HeadInfoUpdate)
    self.headInfoUpdate:Init(self.entity.clientEntity.clientTransformComponent.transform, self.maxShowDistance)
end

function HeadInfoObj:OnReset()
    if self.gameObject then
        PoolManager.Instance:Push(PoolType.object, "HeadInfoObject", self.gameObject)
    end

    self.initFinish = false
    self.isDestroy = false
    self.gameObject = nil
    self.instanceId = nil
    self.entity = nil
    self.parent = nil
    self.showList = {}
    self.infoList = {}
    self.headInfo = nil
    self.talkId = nil
    self.timer = 0
    self.isHide = false
end