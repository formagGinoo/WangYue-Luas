HeadInfoManager = BaseClass("HeadInfoManager")

function HeadInfoManager:__init(clientFight)
    self.clientFight = clientFight
    self.visible = true
    self.headInfoMap = {}
    self.workInfoMap = {}
    self.isShow = true
end

function HeadInfoManager:__delete()

end

function HeadInfoManager:StartFight()
    --TODO self.clientFight 极低概率会变空，临时保底
    if not self.clientFight then
        self.clientFight = Fight.Instance.clientFight
    end
    self.headInfoRoot = self.clientFight.assetsPool:Get("Prefabs/UI/Fight/HeadInfo/HeadInfoRoot.prefab")
    self.headInfoRoot.transform:SetParent(self.clientFight.fightRootTrans)
end

function HeadInfoManager:Update()
    UnityUtils.BeginSample("HeadInfoManager")
    for k, v in pairs(self.headInfoMap) do
        v:Update()
    end
    for k, v in pairs(self.workInfoMap) do
        v:Update()
    end
    UnityUtils.EndSample()
end

function HeadInfoManager:DeleteMe()
    for k, v in pairs(self.headInfoMap) do
        v:DeleteMe()
    end
    for k, v in pairs(self.workInfoMap) do
        v:DeleteMe()
    end
    self.headInfoMap = {}
    self.workInfoMap = {}
end

function HeadInfoManager:ShowCharacterHeadTips(instanceId)
    if not self.headInfoMap[instanceId] then
        self:CreateHeadInfoObj(instanceId)
    end
end

function HeadInfoManager:ShowWorkHeadTips(instanceId)
    if not self.workInfoMap[instanceId] then
        self:CreateWorkInfoObj(instanceId)
    end
    return self.workInfoMap[instanceId]
end

function HeadInfoManager:ChangeHeadInfo(instanceId, customInfo)
    if not self.headInfoMap or not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:ChangeInfo(customInfo)
end

function HeadInfoManager:HideCharacterHeadTips(instanceId)
    self:DestoryHeadInfoObj(instanceId)
end

function HeadInfoManager:HideWorkHeadTips(instanceId)
    self:DestoryWorkInfoObj(instanceId)
end

function HeadInfoManager:ShowAllHeadInfoObj()
    UtilsUI.SetActive(self:GetRoot(), true)
    -- for k, v in pairs(self.headInfoMap) do
    --     v.gameObject.SetActive(true)
    -- end
end

function HeadInfoManager:HideAllHeadInfoObj()
    UtilsUI.SetActive(self:GetRoot(), false)
    -- for k, v in pairs(self.headInfoMap) do
    --     v.gameObject.SetActive(false)
    -- end
end

function HeadInfoManager:GetRoot()
    if not self.headInfoRoot then
        Log("根节点引用丢失，重新创建")
        self.headInfoRoot = self.clientFight.assetsPool:Get("Prefabs/UI/Fight/HeadInfo/HeadInfoRoot.prefab")
        self.headInfoRoot.transform:SetParent(self.clientFight.fightRootTrans)
    end
    return self.headInfoRoot
end

function HeadInfoManager:CreateHeadInfoObj(instanceId)
    
    if not self.headInfoMap[instanceId] then
        self.headInfoMap[instanceId] = self:GetHeadInfo()
        self.headInfoMap[instanceId]:LoadHeadInfoObj(instanceId)
    end
end

function HeadInfoManager:CreateWorkInfoObj(instanceId)
    if not self.workInfoMap[instanceId] then
        self.workInfoMap[instanceId] = self:GetWorkInfo()
        self.workInfoMap[instanceId]:LoadWorkInfoObj(instanceId)
    end
end

function HeadInfoManager:DestoryHeadInfoObj(instanceId)
    if self.headInfoMap[instanceId] then
        self:PushHeadInfoToPool(self.headInfoMap[instanceId])
        self.headInfoMap[instanceId] = nil
    end
end

function HeadInfoManager:DestoryWorkInfoObj(instanceId)
    
    if self.workInfoMap[instanceId] then
        self:PushWorkInfoToPool(self.workInfoMap[instanceId])
        self.workInfoMap[instanceId] = nil
    end
end
function HeadInfoManager:GetHeadInfo()
    local infoTmp = PoolManager.Instance:Pop(PoolType.class, "HeadInfoObj")
    if not infoTmp then
        infoTmp = HeadInfoObj.New(self)
    end
    return infoTmp
end
function HeadInfoManager:GetWorkInfo()
    local infoTmp = PoolManager.Instance:Pop(PoolType.class, "WorkInfoObj")
    if not infoTmp then
        infoTmp = WorkInfoObj.New(self)
    end
    return infoTmp
end

function HeadInfoManager:PushHeadInfoToPool(HeadInfo)
    PoolManager.Instance:Push(PoolType.class, "HeadInfoObj", HeadInfo)
end
function HeadInfoManager:PushWorkInfoToPool(workInfo)
    PoolManager.Instance:Push(PoolType.class, "WorkInfoObj", workInfo)
end
function HeadInfoManager:GetHeadInfoBubbleId(instanceId)
    if not self.headInfoMap[instanceId] then
        return
    end

    return self.headInfoMap[instanceId].talkId
end

function HeadInfoManager:SetHeadInfoBubbleId(instanceId, bubbleId, bubbleCfg)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:ChangeBubbleContent(bubbleCfg[4], bubbleCfg[3], bubbleId)
end

function HeadInfoManager:SetBubbleContent(instanceId, content, duration)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:ChangeBubbleContent(content, duration)
end

function HeadInfoManager:SetBubbleVisible(instanceId, visible)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:SetBubbleVisible(visible)
end

function HeadInfoManager:SetHeadIcon(instanceId, icon)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:ChangeHeadIcon(icon)
end

function HeadInfoManager:SetHeadTipScale(instanceId, icon)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:ChangeHeadTipScale(icon)
end
function HeadInfoManager:SetChangeName(instanceId, icon)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:ChangeName(icon)
end

function HeadInfoManager:SetChangeDistanceThreshold(instanceId,arg0,arg1,arg2,arg3)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:ChangeDistanceThreshold(arg0,arg1,arg2,arg3)
end

function HeadInfoManager:SetHeadInfoVisible(instanceId, visible)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:SetHeadInfoVisible(visible)
end