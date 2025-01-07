HeadInfoManager = BaseClass("HeadInfoManager")

function HeadInfoManager:__init(clientFight)
    self.clientFight = clientFight
    self.visible = true
    self.headInfoMap = {}
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
    UnityUtils.EndSample()
end

function HeadInfoManager:DeleteMe()
    for k, v in pairs(self.headInfoMap) do
        v:DeleteMe()
    end

    self.headInfoMap = {}
end

function HeadInfoManager:ShowCharacterHeadTips(instanceId)
    if not self.headInfoMap[instanceId] then
        self:CreateHeadInfoObj(instanceId)
    end
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

function HeadInfoManager:DestoryHeadInfoObj(instanceId)
    if self.headInfoMap[instanceId] then
        self:PushHeadInfoToPool(self.headInfoMap[instanceId])
        self.headInfoMap[instanceId] = nil
    end
end

function HeadInfoManager:GetHeadInfo()
    local infoTmp = PoolManager.Instance:Pop(PoolType.class, "HeadInfoObj")
    if not infoTmp then
        infoTmp = HeadInfoObj.New(self)
    end
    return infoTmp
end

function HeadInfoManager:PushHeadInfoToPool(HeadInfo)
    PoolManager.Instance:Push(PoolType.class, "HeadInfoObj", HeadInfo)
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

function HeadInfoManager:SetHeadInfoVisible(instanceId, visible)
    if not self.headInfoMap[instanceId] then
        return
    end

    self.headInfoMap[instanceId]:SetHeadInfoVisible(visible)
end