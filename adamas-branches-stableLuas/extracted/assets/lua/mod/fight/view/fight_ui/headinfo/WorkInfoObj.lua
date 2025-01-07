WorkInfoObj = BaseClass("WorkInfoObj", PoolBaseClass)

local objPrefab = "Prefabs/UI/Fight/HeadInfo/WorkInfoObj.prefab"

WorkInfoObj.INFO = {
    [1] = "content",
    [2] = "icon",
    [3] = "num"
}

WorkInfoObj.PAGE = {
    [1] = "working",
    [2] = "finished",
    [3] = "stop"
}
WorkInfoObj.DistanceThreshold = {
    [0] = 50^2,--开始高频刷新
    [1] = 15^2,
}

WorkInfoObj.BubbleDistanceThreshold = 30 ^ 2

function WorkInfoObj:__init(headInfoManager)
    self.initFinish = false
    self.isDestroy = false
    self.gameObject = nil
    self.instanceId = nil
    self.entity = nil
    self.parent = nil
    self.showList = {}
	self.infoList = {
		[WorkInfoObj.INFO[1]] = "",
		[WorkInfoObj.INFO[2]] = "",
		[WorkInfoObj.INFO[3]] = "",
	}
    self.headInfo = nil
    self.page = WorkInfoObj.PAGE[1]
    self.timer = 0

    self.visible = true

    self.bubbleContent = nil
    self.bubbleTimer = 0
    self.bubbleVisible = false

    self.maxShowDistance = 0
    self.headInfoManager = headInfoManager

    self.bindTrans = nil
    self.localScale = 1
    self.isDirty = false

    self.distanceThreshold = {}
    for k, v in pairs(WorkInfoObj.DistanceThreshold) do
        self.distanceThreshold[k] = v
    end
end

function WorkInfoObj:__delete()
    if self.assertLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assertLoader)
        self.assertLoader = nil
    end
end

function WorkInfoObj:LoadWorkInfoObj(instanceId)
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

function WorkInfoObj:Update()
    if not self.gameObject or not self.headInfoUpdate then return end

    if not self.visible then
        self:SetShowIndex(false)
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

function WorkInfoObj:ChangeDistanceThreshold(arg0,arg1)
    self.distanceThreshold[0] = arg0 and arg0 or self.distanceThreshold[0]
    self.distanceThreshold[1] = arg1 and arg1 or self.distanceThreshold[1]
end

function WorkInfoObj:ChangeInfo()
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
        [WorkInfoObj.INFO[1]] = npcCfg.title,
        [WorkInfoObj.INFO[2]] = npcCfg.name,
        [WorkInfoObj.INFO[3]] = self.npcManager:GetNpcHeadIcon(self.entity.sInstanceId),
        [WorkInfoObj.INFO[4]] = self.bubbleContent,
    }
end

function WorkInfoObj:ChangeMaxDistance()
    local maxDistance = 0
    if self.infoList[WorkInfoObj.INFO[1]] and self.infoList[WorkInfoObj.INFO[1]] ~= "" 
		or self.infoList[WorkInfoObj.INFO[2]] and self.infoList[WorkInfoObj.INFO[2]] ~= "" 
		or self.infoList[WorkInfoObj.INFO[3]] and self.infoList[WorkInfoObj.INFO[3]] ~= "" then
		maxDistance = math.max(maxDistance, self.distanceThreshold[1])
    end
	

    self.maxShowDistance = maxDistance
end

function WorkInfoObj:DefaultShow()
    if not self.gameObject then return end
    self.isDirty = false
    if not self.node then
        self.node = UtilsUI.GetContainerObject(self.gameObject.transform)
		
    end
	
	for i = 1, #WorkInfoObj.PAGE do
		if not self[WorkInfoObj.PAGE[i]] then

			self[WorkInfoObj.PAGE[i]] = UtilsUI.GetContainerObject(self.node[WorkInfoObj.PAGE[i]])
		end
	end
	
    self.headInfoUpdate.customScale = self.localScale
    local switch = {
        [1] = function()
            if self.infoList[WorkInfoObj.INFO[1]] == "" then return end
            self[self.page].content_txt.text = self.infoList[WorkInfoObj.INFO[1]]
        end,
        [2] = function()
            if not self.infoList[WorkInfoObj.INFO[2]] or self.infoList[WorkInfoObj.INFO[2]] == "" then return end
            SingleIconLoader.Load(self[self.page].icon, self.infoList[WorkInfoObj.INFO[2]])
        end,
        [3] = function()
            if self.infoList[WorkInfoObj.INFO[3]] == "" then return end
            self[self.page].num_txt.text = self.infoList[WorkInfoObj.INFO[3]]
        end,
    }
    
    for i = 1, #WorkInfoObj.INFO do
        switch[i]()
    end

    for i = 1, #WorkInfoObj.PAGE do
        self[WorkInfoObj.PAGE[i]][WorkInfoObj.PAGE[i]]:SetActive(WorkInfoObj.PAGE[i] == self.page)
    end
end

function WorkInfoObj:UpdateShow(distance)
    local maxDis = self.distanceThreshold[1]
    if distance < maxDis then
        self:SetShowIndex(true, 1)
    else
        self:SetShowIndex(false, 1)
    end
end

function WorkInfoObj:SetShowIndex(action, infoIndex)
    if self.showList[infoIndex] == action and self.node.activeSelf == action then return end
    self.showList[infoIndex] = action

    if not self.node then
        self.node = UtilsUI.GetContainerObject(self.gameObject.transform)
    end
	self.gameObject:SetActive(action)
end


function WorkInfoObj:ChangeContent(content)
    if not content then
        return
    end

    self.isDirty = true
    self.infoList[WorkInfoObj.INFO[1]] = content
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

function WorkInfoObj:ChangeIcon(icon)
    if not icon then
        self.infoList[WorkInfoObj.INFO[2]] = ""
        if not self.entity or not self.entity.sInstanceId then
            goto continue
        end

        self.infoList[WorkInfoObj.INFO[2]] = self.npcManager:GetNpcHeadIcon(self.entity.sInstanceId)
    else
        self.infoList[WorkInfoObj.INFO[2]] = icon
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
function WorkInfoObj:GetBindTrans()
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

function WorkInfoObj:ChangePage(page)
    self.page = page
    self.isDirty = true
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
function WorkInfoObj:ChangeHeadTipScale(scale)


    self.localScale = scale
    self.isDirty = true
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
function WorkInfoObj:ChangeNum(num)

    self.infoList[WorkInfoObj.INFO[3]] = tostring(num) 


    self.isDirty = true
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

function WorkInfoObj:GetObject()
    local obj = PoolManager.Instance:Pop(PoolType.object, "WorkInfoObject")
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
        self.assertLoader = AssetMgrProxy.Instance:GetLoader("WorkInfoObjLoader")
        self.assertLoader:AddListener(callback)
        self.assertLoader:LoadAll(resList)
        return false
    end
    return true, obj
end

function WorkInfoObj:OnLoadDone(object)
    if not self.entity then
        self.headInfoManager:DestoryWorkInfoObj(self.instanceId)
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

function WorkInfoObj:OnReset()
    if self.gameObject then
        PoolManager.Instance:Push(PoolType.object, "WorkInfoObject", self.gameObject)
    end

    self.bindTrans = nil
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