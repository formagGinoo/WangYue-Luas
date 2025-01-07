BubbleItem = BaseClass("BubbleItem")
local itemPrefab = "Prefabs/UI/Message/BubbleItems2.prefab"

function BubbleItem:__init(ItemInfo)
    if ItemInfo then
    self.parent = ItemInfo.parent
	self.messageInfo = ItemInfo.itemInfo
    self.type = ItemInfo.itemtype
    self.callAnswerFunc = ItemInfo.callAnswer
    self.openIconFunc = ItemInfo.callOpenIcon
    self.setContentY = ItemInfo.callSetContentY
    self.iconindex = ItemInfo.iconindex
    self.taskId = ItemInfo.taskId
    self.callCreatItem = ItemInfo.callCreatItem
    end
    self.noSelectNode = nil
    self.itemObjectName = "BubbleItem"
    self.assetLoader = AssetMgrProxy.Instance:GetLoader("BubbleItemLoader")
    self:LoadItem()
end

function BubbleItem:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function BubbleItem:__delete()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    if self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
end

function BubbleItem:__Hide()
    if self.assetLoader then
        AssetMgrProxy.Instance:CacheLoader(self.assetLoader)
        self.assetLoader = nil
    end
    if self.object then
        PoolManager.Instance:Push(PoolType.object, self.itemObjectName, self.object)
    end
end

function BubbleItem:InitItem()
    if not self.parent then
        self:DeleteMe()
        return
    end
    UtilsUI.AddUIChild(self.parent, self.object)
    self.node = UtilsUI.GetContainerObject(self.object.transform)
    if not self.taskId  then
        self:SetType()
    else
        self:OpenTaskITem(self.taskId)
    end
    self:BindListener()
    self.setContentY()
end

function BubbleItem:BindListener()
    --self.node.AcceptTaskBtn_btn.onClick:AddListener(self:ToFunc("GotoTask"))
    self.node.DefaultIcon_btn.onClick:AddListener(self:ToFunc("LookIcon"))
end

function BubbleItem:LookIcon()
    local path = self.messageInfo.talk_content
    self.openIconFunc(path)
end

function BubbleItem:SetType()

    local type = self.messageInfo.type
    local talkfromtype = self.messageInfo.talk_from_type
    if type ==1 then--常规文本
        if self.messageInfo.talk_from_type ==1 then
             --右侧气泡
            self.node.RightRoot:SetActive(true)
            self:SetName(self.node.RightName_txt,self.messageInfo)
            self:SetHeadIcon(self.node.RightHeadIcon)
            self:SetContent(self.node.RightContent_txt)
            self.noSelectNode = self.node.RightRoot
        else
            --左侧气泡
            self.node.LeftRoot:SetActive(true)
            self:SetName(self.node.LeftName_txt,self.messageInfo)
            self:SetHeadIcon(self.node.LeftHeadIcon)
            self:SetContent(self.node.LeftContent_txt)
            self.noSelectNode = self.node.LeftRoot
        end
    elseif type ==2 then--表情
        local path = Config.DataMeme.Find[tonumber(self.messageInfo.talk_content)].meme
        local headIconpath = self.messageInfo.icon
        if self.messageInfo.talk_from_type ==2 then
            self.node.leftEmojiNode:SetActive(true)
            SingleIconLoader.Load(self.node.leftEmojiicon, path)
            SingleIconLoader.Load(self.node.leftEmojiHeadIcon, headIconpath)
            self:SetName(self.node.leftEmojiName_txt,self.messageInfo)
            self.noSelectNode = self.node.leftEmojiNode
        else
            self.node.rightEmojiNode:SetActive(true)
            SingleIconLoader.Load(self.node.rightEmojiicon, path)
            SingleIconLoader.Load(self.node.rightEmojiHeadIcon, headIconpath)
            self:SetName(self.node.rightEmojiName_txt,self.messageInfo)
            self.noSelectNode = self.node.rightEmojiNode
        end
    elseif type ==3 then--图片
        self.node.IconNode:SetActive(true)
        local path =self.messageInfo.talk_content
        local headIcon = self.messageInfo.icon
        SingleIconLoader.Load(self.node.DefaultIcon, path)
        SingleIconLoader.Load(self.node.DefaultHeadIcon, headIcon)
        if talkfromtype == 1  then
            local headIconNoed =self.node.DefaultIconBg
        UnityUtils.SetLocalPosition(headIconNoed, headIconNoed.localPosition.x+200, headIconNoed.localPosition.y, headIconNoed.localPosition.z)
        end
        self:SetName(self.node.DefalultName_txt,self.messageInfo)
        self.noSelectNode = self.node.IconNode
    elseif type ==4 then--回复文本类型
        if self.messageInfo.talk_from_type ==1 then
            --右侧气泡
           self.node.RightRoot:SetActive(true)
           self:SetName(self.node.RightName_txt,self.messageInfo)
           self:SetHeadIcon(self.node.RightHeadIcon)
           self:SetContent(self.node.RightContent_txt)
           self.noSelectNode = self.node.RightRoot
       else
           --左侧气泡
           self.node.LeftRoot_:SetActive(true)
           self:SetName(self.node.LeftName_txt,self.messageInfo)
           self:SetHeadIcon(self.node.LeftHeadIcon)
           self:SetContent(self.node.LeftContent_txt)
           self.noSelectNode = self.node.LeftRoot_
       end
    elseif type ==5 then--回复表情包类型
        self.node.rightEmojiNode:SetActive(true)
        local icon = self.messageInfo.options[self.iconindex][1]
        local path = Config.DataMeme.Find[tonumber(icon)].meme
        local MyConfig =  Config.DataMessageDialog.Find[self.messageInfo.options[self.iconindex][2]]
        local headpath = MyConfig.icon
        SingleIconLoader.Load(self.node.rightEmojiicon, path)
        SingleIconLoader.Load(self.node.rightEmojiHeadIcon, headpath)
        self:SetName(self.node.rightEmojiName_txt,MyConfig)
        self.noSelectNode = self.node.rightEmojiNode
    elseif type ==6 then--常规文本类型
        self.node.DefauleTextItem:SetActive(true)
        self.node.DefauleTextItem_txt.text= self.messageInfo.talk_content
        self.noSelectNode = self.node.DefauleTextItem
    end
    self:callCreatItem()
end

function BubbleItem:GotoTask()
    BehaviorFunctions.AcceptTask(self.taskId) --接受任务
end

function BubbleItem:SetName(node,config)
    if self.messageInfo.talk_name == "<nick_name>" or config.talk_name == "<nick_name>" then
        local infor =  mod.InformationCtrl:GetPlayerInfo()
        node.text = infor.nick_name
    else
        node.text = config.talk_name
    end
    
end

function BubbleItem:SetContent(node)
    if self.messageInfo.talk_content then
        node.text = self.messageInfo.talk_content
    end
end

function BubbleItem:OpenTaskITem(taskId)
    self.node.TaskItem:SetActive(true)
    self.noSelectNode = self.node.TaskItem
    local taskConfig = Config.DataTask.data_task[taskId]
    if not taskConfig then
        return
    end
    if taskConfig.type==1 then     --主线任务显示橙色
       self.node.Orange:SetActive(true)
       self.node.Violet:SetActive(false)
    else
       self.node.Violet:SetActive(true)
       self.node.Orange:SetActive(false)
    end
    self.node.TaskName_txt.text= taskConfig.task_name
end

function BubbleItem:CloseItme()
    if not self.noSelectNode then
        return
    end
    self.noSelectNode:SetActive(false)
end

function BubbleItem:SetHeadIcon(node)
    local path = self.messageInfo.icon
    SingleIconLoader.Load(node, path)
end

function BubbleItem:LoadItem()
    local item = self:CreatItem()
    
    if item then
        self.object = item
        self:InitItem()
    end
end

function BubbleItem:CreatItem()
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

function BubbleItem:CreatItem2()
    
    GameObject.Instantiate(self[name])
    local objectInfo, new = self:PopUITmpObject("BubbleItems")
    objectInfo.object.transform:SetParent(self.TalkContent.transform)
end

function BubbleItem:LoadDone()
    self:InitItem()
end