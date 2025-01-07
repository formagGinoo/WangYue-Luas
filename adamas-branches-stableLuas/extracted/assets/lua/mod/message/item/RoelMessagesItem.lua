RoelMessagesItem = BaseClass("RoelMessagesItem", Module)
local itemPrefab = "Prefabs/UI/Message/RoelMessageItem2.prefab"

function RoelMessagesItem:__init(ItemInfo)
    if ItemInfo then
    self.parent = ItemInfo.parent
    self.messageId = ItemInfo.messageId
    self.talkId = ItemInfo.talkId
    self.type  = ItemInfo.type
    self.clickCallback =ItemInfo.clickCallback
    self.closeNode = ItemInfo.clickCloseNode
    self.changeType = ItemInfo.changeType
    self.config = Config.DataMessageDialog.Find[self.talkId]
    self.groupId = self.config.group_id
    end
    self.itemObjectName = "RoelMessagesItem"
    
    self.assetLoader = AssetMgrProxy.Instance:GetLoader("RoelMessagesItemLoader")
    self.node = nil
    self:LoadItem()
end

function RoelMessagesItem:__delete() 
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    if self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
    EventMgr.Instance:RemoveAllListener(EventName.UpdateConditionType, self:ToFunc("UpdateConditionType"))
    if self.nowNode then
        self.nowNode:SetActive(false)
    end
    self.nowNode =nil
    if  self.BaiNode then
        self.BaiNode:SetActive(false)
    end
    self.BaiNode = nil
end

function RoelMessagesItem:Hide()
end

function RoelMessagesItem:InitItem()
    if not self.parent then
        self:DeleteMe()
        return
    end
	self.node = UtilsUI.GetContainerObject(self.object.transform)
    UtilsUI.AddUIChild(self.parent, self.object)
    self:BindListener()
    self:Show()
end

function RoelMessagesItem:BindListener()
    self.node.MessageBody_btn.onClick:AddListener(self:ToFunc("OnClick_Self"))
    EventMgr.Instance:AddListener(EventName.UpdateConditionType, self:ToFunc("UpdateConditionType"))
end

function RoelMessagesItem:UpdateConditionType(messageId)
    if messageId~= self.messageId  then
        return
    end
    local type
    for _k, _v in ipairs(MessageConfig.SortMessages) do
        for messageId, value in pairs(_v.value) do
            if messageId == self.messageId then
               type = value.type
            end
        end
    end
    if self.nowNode and self.nowNode.activeSelf then
        self.nowNode:SetActive(false)
    end
    local Content = self:GetFirstContent()
    self:SetType(type,Content)
    self:OnClick_Self()
end

function RoelMessagesItem:GetFirstContent()
   local Config = Config.DataMessageDialog.Find
   local messageGroup = {}
   local k = 1
   for _k, _v in pairs(Config) do
    if _v.group_id == self.groupId then
        messageGroup[k] = _v
        k = k+1
    end
   end

   table.sort(messageGroup,function (a, b)
    return a.talk_id < b.talk_id
   end)
   return messageGroup[1].talk_content
end

function RoelMessagesItem:Show()
  local Content = self:GetFirstContent()
  self:SetType(self.type,Content)
end

function RoelMessagesItem:SetType(type,content)
    self.nowNode = nil
    if type == MessageConfig.ConditionType.Finish  then   --已完成的对话
       self.node.MessageFinishBody:SetActive(true)
       if self.config.type ==2 then
        content  = Config.DataMeme.Find[tonumber(content)].title
       end
       self:SetContent(self.node.MessageFinishContent_txt,content)
       self:SetContent(self.node.MessageFinishContent2_txt,content)
       self.nowNode = self.node.MessageFinishBody
       self.BaiNode = self.node.FBai
    elseif type == MessageConfig.ConditionType.End then   --任务进行中的对话
        self.node.MessageEndBody:SetActive(true)
        if self.config.type ==2 then
            content  = Config.DataMeme.Find[tonumber(content)].title
           end
        self:SetContent(self.node.MessageEndContent_txt,content)
        self:SetContent(self.node.MessageEndContent2_txt,content)
        self.nowNode = self.node.MessageEndBody
        self.BaiNode = self.node.EBai
    elseif type == MessageConfig.ConditionType.Reading then   --正在阅读中的任务
        self.node.MessageReadingBody:SetActive(true)
        if self.config.type ==2 then
            content  = Config.DataMeme.Find[tonumber(content)].title
           end
        self:SetContent(self.node.MessageReadingContent_txt,content)
        self:SetContent(self.node.MessageReadingContent2_txt,content)
        self.nowNode = self.MessageReadingBody
        self.BaiNode = self.node.RBai
    elseif type == MessageConfig.ConditionType.Start then    --对话开始未接取
        self.node.MessageStartBody:SetActive(true)
        if self.config.type ==2 then
            content  = Config.DataMeme.Find[tonumber(content)].title
           end
        self:SetContent(self.node.MessageStartContent_txt,content)
        self:SetContent(self.node.MessageStartContent2_txt,content)
        self.nowNode = self.node.MessageStartBody
        self.BaiNode = self.node.SBai
    end
end

function RoelMessagesItem:SetContent(node,content)
    node.text = content
end

function RoelMessagesItem:OnClick_Self()
   local talkId = MessageConfig.MessageTypes[self.messageId].talk_id
   self.clickCallback(self.messageId,self.talkId)
   self.BaiNode:SetActive(true)
   self.closeNode(self.BaiNode)
   --self.changeType()
end

function RoelMessagesItem:CloseItem()
    if self.nowNode then
        self.nowNode:SetActive(false)
    end
end

function RoelMessagesItem:LoadItem()
    local item = self:CreatItem()
    
    if item then
        self.object = item
        self:InitItem()
    end
end

function RoelMessagesItem:CreatItem()
    local item = PoolManager.Instance:Pop(PoolType.object, self.itemObjectName)

    if not item then
        local callback = function()
            self.object = self.assetLoader:Pop(itemPrefab)
            self:LoadDone()
        end

        local resList = {
            {path = itemPrefab, type = AssetType.Prefab}
        }
        self.assetLoader:AddListener(callback)
        self.assetLoader:LoadAll(resList)
        return false
    end
    return item
end

function RoelMessagesItem:LoadDone()
    self:InitItem()
end
