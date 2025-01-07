---@class MessageWindow
MessageWindow = BaseClass("MessageWindow", BaseWindow)

function MessageWindow:__init()
    self:SetAsset("Prefabs/UI/Message/SumMessageWindow2.prefab")
    self.MessageLeftContents={}
    self.MessageContents  = {}
    self.messageId = 0
    self.optionList = {}
    self.isFirstOpen = true
    self.nowTalkId = nil
    self.sortCount = 0
    self.IsFirstClose = true
    self.rightIndex = 0
end

function MessageWindow:__Show()
    self:CacheItem()
    self:UpdataeMessageInfo()          --初始化左侧面板
end

function MessageWindow:__ShowComplete()
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
    end
    self:SetActive(false)
    self.blurBack:Show()
end

function  MessageWindow:__BindEvent()
    EventMgr.Instance:AddListener(EventName.NpcCallbackMessage, self:ToFunc("CallbackMessageInfo"))
    EventMgr.Instance:AddListener(EventName.SortMessage, self:ToFunc("SortMessage"))
end

function MessageWindow:__delete()
    EventMgr.Instance:RemoveAllListener(EventName.NpcCallbackMessage, self:ToFunc("CallbackMessageInfo"))
    EventMgr.Instance:RemoveAllListener(EventName.SortMessage, self:ToFunc("SortMessage"))
    if self.IsFirstClose then
        self.IsFirstClose = nil
    end
end

function MessageWindow:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function MessageWindow:CacheItem()
    for i = 1, 5, 1 do
        BubbleItem.New(nil)
    end
   LeftPanelItem.New(nil)
end

--leftPanel
function MessageWindow:CreatItem(messageMainId,messages)
    if not self.MessageLeftContents[messageMainId]then
        self.MessageLeftContents[messageMainId]={}
        local itemInfo = {
        parent = self.LeftContentNode,
        messageMainId = messageMainId,
        messages = messages,
        clickCallback = self:ToFunc("SelectItemCallback"),
        closeNode = self:ToFunc("CloseNode"),
        UpdeatMessage = self:ToFunc("UpdateMessages"),

    }
        self.MessageLeftContents[messageMainId].itemInfo = itemInfo
        self.MessageLeftContents[messageMainId].Item = LeftPanelItem.New(itemInfo)
    end
end

function MessageWindow:UpdateMessages(MessageMainId,messageId)
    return MessageConfig.SortMessages[MessageMainId][messageId].type
end

function MessageWindow:CloseNode(node) --更改左侧面板里短信选项状态
    
    if self.lastNode == node then
        return
    end
    if not self.IsFirstClose and self.lastNode then
        self.lastNode:SetActive(false)
    end
    if  self.IsFirstClose then
        self.IsFirstClose = false
    end
    self.lastNode = node
end

function MessageWindow:SelectItemCallback(messageId,talkId)  --显示聊天内容
    if self.messageId ~= messageId then
        self.messageId = messageId
        self.nowTalkId = talkId
        self.sortCount = 0
        self.RightTopNode:SetActive(true)
        self.NotSelect:SetActive(false)
        if self.nowSelectItem and self.nowSelectItem.activeSelf then
            self.nowSelectItem:SetActive(false)
            self:ChangeContentSize(180)
        end
        self:ClearTalkItem(talkId)
        self:UpdateTopInfo()
    end
end

function MessageWindow:UpdataeMessageInfo()
 
    mod.MessageCtrl:SetSortMessage()
    for _k, _v in ipairs(MessageConfig.SortMessages) do
        self:CreatItem(_v.messageMainId,_v.value)
    end
end

function MessageWindow:SortMessage(SortMessage,type) 
    self:ClearItem()
    for _k, _v in ipairs(SortMessage) do
        self:CreatItem(_v.messageMainId,_v.value)
    end
    --显示筛选的类型
    self.SlifText_txt.text = TI18N(type)
end

function MessageWindow:ClearItem()
    for _k, _v in pairs(self.MessageLeftContents) do
        if _v.Item then
            _v.Item:ClosePanel()
            _v.Item:Hide()
            _v.Item:DeleteMe()
            _v.Item = nil
            _v.itemInfo = nil
        end
    end
    self.MessageLeftContents ={}
end
--RightPanel

function MessageWindow:__BindListener()
    -- self.NormalBtn01_btn.onClick:AddListener(self:ToFunc("OnClick_NormalTalk"))
    -- self.EmojiBtn02_btn.onClick:AddListener(self:ToFunc("OnClick_NormaEmoji"))
    
    self.SelectEmojiBtn01_btn.onClick:AddListener(self:ToFunc("OnClick_SelectEmojiOne"))
    self.SelectEmojiBtn02_btn.onClick:AddListener(self:ToFunc("OnClick_SelectEmojiTwo"))
    self.SelectEmojiBtn03_btn.onClick:AddListener(self:ToFunc("OnClick_SelectEmojiThree"))
  
    self.SelectBtn01_btn.onClick:AddListener(self:ToFunc("OnClick_Selectone"))
    self.SelectBtn02_btn.onClick:AddListener(self:ToFunc("OnClick_SelectTwo"))
    self.SelectBtn03_btn.onClick:AddListener(self:ToFunc("OnClick_SelectThree"))
  
    --self.Backbtn_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
    self:BindCloseBtn(self.Backbtn_btn,self:ToFunc("OnClick_ClosePanel"))
    self.LookIconBg_btn.onClick:AddListener(self:ToFunc("OnClick_CloseIcon"))
    self.Sortbtn_btn.onClick:AddListener(self:ToFunc("OnClick_OpenSort"))
  end

function MessageWindow:CallbackMessageInfo()

    if  self.nowId  ==0  then
        return
    end
    self.nowId = self.nowConfig.nest_id
    local delayTime = 1
    self.lastConfig = self.nowConfig--当对话结束时使用
    self.nowConfig = Config.DataMessageDialog.Find[self.nowId]
     if self.nowConfig ==nil then-- 对话结束显示任务Item,并且发送任务前置条件完成的事件
        local taskId = Config.DataMessageCome.Find[self.messageId].task_get_id
        if taskId >0  then
            self:CreatRightItem(self.lastConfig,0,taskId)
        end
        mod.InformationCtrl:SendMessageProgress(self.messageId,self.lastConfig.talk_id,self.optionList)
        -- 完成短信
        -- mod.MessageCtrl:MessagEnd(self.messageId)
        if BehaviorFunctions.CheckTaskIsFinish(taskId) then
            mod.MessageCtrl:SetRoelMessageConfig(self.messageId,self.lastConfig.talk_id,MessageConfig.ConditionType.End)
        else
            mod.MessageCtrl:SetRoelMessageConfig(self.messageId,self.lastConfig.talk_id,MessageConfig.ConditionType.Finish)
        end
        EventMgr.Instance:Fire(EventName.UpdateConditionType,self.messageId)
        self:DelayChangeScrollBar()
        return
     end
    
    self:DelayChangeScrollBar()
    self:DelayTalk(delayTime)
end

function MessageWindow:DelayTalk( delayTime)
		if delayTime == 0 then
            if self.nowConfig.talk_from_type~=1 then
                self:CreatRightItem(self.nowConfig)
                mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
            else
                self:AnswerSelect(self.nowConfig)
            end
		else
			local callback = function()
				if self.showTimer then
					LuaTimerManager.Instance:RemoveTimer(self.showTimer)
					self.showTimer = nil
				end
                if self.nowConfig then
                    if self.nowConfig.talk_from_type~=1 then
                        self:CreatRightItem(self.nowConfig)
                        mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
                    else
                        self:AnswerSelect(self.nowConfig)
                    end
                end
			end
			if self.showTimer then
				LuaTimerManager.Instance:RemoveTimer(self.showTimer)
				self.showTimer = nil
			end
			self.showTimer = LuaTimerManager.Instance:AddTimer(1, delayTime, callback)
		end
end

function MessageWindow:OnClick_ClosePanel()
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = false
    uiCamera.nearClipPlane = 0.01
    WindowManager.Instance:CloseWindow(MessageWindow)
end

function MessageWindow:OnClick_CloseIcon()
    self.LookIconBg:SetActive(false)
    self.MessageBg:SetActive(true)
end

function MessageWindow:OnClick_OpenSort()
    self.MessageBody:SetActive(false)
    local args =
    {
        callBackFunc = self:ToFunc("CloseSortPaenl")
    }
    self:OpenPanel(MessageSortPanel,args)
end

function MessageWindow:CloseSortPaenl()
    self:ClosePanel(MessageSortPanel)
    self.MessageBody:SetActive(true)
end

function MessageWindow:__Hide()
    self:ClearItem()
end

function MessageWindow:ClearTalkItem(talkId)
    for _k, _v in pairs(self.MessageContents) do
        if _v.Item then
            _v.Item:CloseItme()
            _v.Item:DeleteMe()
            _v.Item = nil
        end
    end
    self.MessageContents = {}
    self:InitMessageInfo(talkId)
end

function MessageWindow:InitMessageInfo(talkId)
    local groupId = Config.DataMessageDialog.Find[talkId].group_id
    self.scrollbar = self.MessageContent.transform:GetComponent(ScrollRect)
    self.messageGroup = mod.MessageCtrl:GetMessageReadingGroup(groupId)
    -- for _i, _v in ipairs(messageGroup) do
    --     if _v.talk_id~=talkId then
    --         self:CreatRightItem(_v)
    --     else
    --         self:CreatRightItem(_v)
    --         self.nowId = _v.talk_id
    --         self.nowConfig = Config.DataMessageDialog.Find[_v.talk_id]
    --         mod.InformationCtrl:SendMessageProgress(self.messageId,_v.talk_id,self.optionList)
    --         return
    --     end
    -- end
    self.rightIndex = 0
    self.IsInit = true
    self.IsLast = true
    self:StartCreatRightItem()
end

function MessageWindow:StartCreatRightItem()
    if self.IsInit == false then
        return
    end
    if self.IsLast == false  then
        self.IsInit = false
        mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowConfig.talk_id,self.optionList)
        return
    end
    self.rightIndex = self.rightIndex + 1
    local config = self.messageGroup[self.rightIndex]
    if not config then
        return
    end
    if config.talk_id~=self.nowTalkId then
        self:CreatRightItem(config)
    else
        self.IsLast = false
        self.nowId = config.talk_id
        self.nowConfig = Config.DataMessageDialog.Find[config.talk_id]
        self:CreatRightItem(config)
        return
    end

end

function MessageWindow:UpdateTopInfo()
    local config = Config.DataMessageCome.Find[self.messageId]
    local Infor = Config.DataMessageType.Find[config.message_main_id]
    if Infor then 
     self.TalkName_txt.text = Infor.message_main_name
     self.SignatureName_txt.text = Infor.tips
    end
end

function MessageWindow:DelayChangeScrollBar()
    self.scrollbar.inertia = false
    local function SetChatContY()
         self.scrollbar.verticalScrollbar.value = 0
    end
    local function SetInertia()
        self.scrollbar.inertia = true
    end
    LuaTimerManager.Instance:AddTimer(10, 0.05, SetChatContY)
    LuaTimerManager.Instance:AddTimer(1, 0.5, SetInertia)
end

function MessageWindow:AnswerSelect(info)             --回答的选项
    
    if self.nowSelectItem  then
       self.nowSelectItem:SetActive(false)
    end
    local type = info.type
    if type ==1 then                                     --常规文本
       self:NormalAnswer(info)
    elseif type ==2 then                                 --表情                             
       self:NormalEmoji(info)
    elseif type ==3 then                                 --图片
        
    elseif type ==4 then                                 --回复文本类型
       self:ShowSelect(info.options)
    elseif type ==5 then                                 --回复表情包类型
        self:ShowSelectEmoji(info.options)
    elseif type ==6 then                                 --常规文本类型
        self:CreatRightItem(info)
        mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    end
end

function MessageWindow:NormalAnswer(config)
    self:CreatRightItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
   
end

function MessageWindow:NormalEmoji(config)
    self:CreatRightItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
end

function MessageWindow:ShowSelect(selects)
    self.SelectNode:SetActive(true)
    self.Options ={}
    local k =1
    for _i, _v in pairs(selects) do
        local text = _v[1]
        local info = Config.DataMessageDialog.Find[_v[2]]
        self.Options[k] = {}
        self.Options[k].text = text
        self.Options[k].info = info
        k = k+1
    end

    self.SelectBtn01:SetActive(self.Options [1])
    self.SelectBtn02:SetActive(self.Options [2])
    self.SelectBtn03:SetActive(self.Options [3])

    if self.Options [1] then
        self.SelectText01_txt.text = self.Options [1].text
    end
    if self.Options [2] then
        self.SelectText02_txt.text = self.Options [2].text
    end
    if self.Options [3] then
        self.SelectText03_txt.text = self.Options [3].text
    end

    self.nowSelectItem = self.SelectNode
    self:ChangeContentSize(-180)
end

function MessageWindow:ShowSelectEmoji(selects)
    self.SelectEmojiNode:SetActive(true)
    self.EmojiOptions ={}
    local k =1
    for _i, _v in pairs(selects) do
        local info = Config.DataMessageDialog.Find[_v[2]]
        local path = Config.DataMeme.Find[tonumber(info.talk_content)].meme
        self.EmojiOptions[k]={}
        self.EmojiOptions[k].path = path
        self.EmojiOptions[k].talkId = _v[2]
        k = k+1
    end

    self.SelectEmojiBtn01:SetActive(self.EmojiOptions [1])
    self.SelectEmojiBtn02:SetActive(self.EmojiOptions [2])
    self.SelectEmojiBtn03:SetActive(self.EmojiOptions [3])

    if self.EmojiOptions [1] then
        SingleIconLoader.Load(self.SelectEmojiIcon01, self.EmojiOptions [1].path)
    end
    if self.EmojiOptions [2] then
        SingleIconLoader.Load(self.SelectEmojiIcon02, self.EmojiOptions [2].path)
    end
    if self.EmojiOptions [3] then
        SingleIconLoader.Load(self.SelectEmojiIcon03, self.EmojiOptions [3].path)
    end
    self.nowSelectItem = self.SelectEmojiNode
    self:ChangeContentSize(-180)
end

function MessageWindow:GetSelect(index)
    local config = self.Options[index].info
    self:CreatRightItem(config)
    self.nowConfig = config
    self.nowId = config.talk_id
    --发消息给服务器
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self:ChangeContentSize(180)
    self.nowSelectItem:SetActive(false)
end

function MessageWindow:GetSelectEmoji(index)
    local config = Config.DataMessageDialog.Find[self.EmojiOptions[index].talkId] 
    self:CreatRightItem(self.nowConfig,index)
    self.nowConfig = config
    self.nowId = config.talk_id
    --发消息给服务器
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self:ChangeContentSize(180)
    self.nowSelectItem:SetActive(false)
end

function MessageWindow:OnClick_Selectone()
    table.insert(self.optionList,1)
    self:GetSelect(1)
    
end
function MessageWindow:OnClick_SelectTwo()
    table.insert(self.optionList,2)
    self:GetSelect(2)
    
end
function MessageWindow:OnClick_SelectThree()
    table.insert(self.optionList,3)
    self:GetSelect(3)
end

function MessageWindow:OnClick_NormalTalk()
    local config = Config.DataMessageDialog.Find[self.nowId]
    self:CreatRightItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self.nowSelectItem:SetActive(false)
end

function MessageWindow:OnClick_NormaEmoji()
    local config = Config.DataMessageDialog.Find[self.nowId]
    self:CreatRightItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self.nowSelectItem:SetActive(false)
end

function MessageWindow:OnClick_SelectEmojiOne()
    table.insert(self.optionList,1)
    self:GetSelectEmoji(1)
end
function MessageWindow:OnClick_SelectEmojiTwo()
    table.insert(self.optionList,2)
    self:GetSelectEmoji(2)
end
function MessageWindow:OnClick_SelectEmojiThree()
    table.insert(self.optionList,3)
    self:GetSelectEmoji(3)
end

function MessageWindow:ChangeContentSize(Distance)
    local container =  self.MessageContent_rect
    UnityUtils.SetSizeDelata(container, container.sizeDelta.x , container.sizeDelta.y+Distance)
    self:DelayChangeScrollBar()
end

function MessageWindow:CreatRightItem(config,index,taskId)

    
    if not self.MessageContents[config.talk_id] then
        self.MessageContents[config.talk_id]={}
    end

    local itemInfo = {
        parent = self.TalkContent,
        itemInfo = config,
        itemtype = config.type,
        callAnswer = self:ToFunc("AnswerSelect"),
        callOpenIcon = self:ToFunc("LookIcon"),
        callCreatItem = self:ToFunc("StartCreatRightItem"),
        callSetContentY= self:ToFunc("DelayChangeScrollBar"),
        iconindex = index,
        taskId = taskId,
    }
    if  taskId  then
        self.MessageContents[taskId]={}
        self.MessageContents[taskId].itemInfo = itemInfo
        self.MessageContents[taskId].Item = BubbleItem.New(itemInfo)
    else
        self.MessageContents[config.talk_id].itemInfo = itemInfo
        self.MessageContents[config.talk_id].Item = BubbleItem.New(itemInfo)
    end

    self:DelayChangeScrollBar()
end

function MessageWindow:LookIcon(path)
    self.LookIconBg:SetActive(true)
    SingleIconLoader.Load(self.LookIconNode,path)
    self.MessageBg:SetActive(false)
end