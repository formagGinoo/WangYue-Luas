MessageTalkPanel = BaseClass("MessageTalkPanel", BasePanel)


function MessageTalkPanel:__init(parent,Config)
    self:SetAsset("Prefabs/UI/Phone/MessageTalkPanel.prefab")
    self.MessageContents  = {}
    self.optionList = {} --用来存储选项
end

function MessageTalkPanel:__CacheObject()
    self:SetCacheMode(UIDefine.CacheMode.destroy)
end

function  MessageTalkPanel:__BindEvent()
    EventMgr.Instance:AddListener(EventName.NpcCallbackMessage, self:ToFunc("UpdataeMessageInfo"))
end

function MessageTalkPanel:__delete()
    self:CloseTalkPanle()

    self.nowId = nil
    self.nowConfig = nil
    self.lastConfig = nil
    EventMgr.Instance:RemoveAllListener(EventName.NpcCallbackMessage, self:ToFunc("UpdataeMessageInfo"))
end

function MessageTalkPanel:UpdataeMessageInfo()

    if  self.nowId  ==0  then
        return
    end
    
    if self.nowConfig then
        self.nowId = self.nowConfig.nest_id
    end
    local delayTime = 1
    self.lastConfig = self.nowConfig--当对话结束时使用
    self.nowConfig = Config.DataMessageDialog.Find[self.nowId]
     if self.nowConfig ==nil then-- 对话结束显示任务Item,并且发送任务前置条件完成的事件
        local taskId = Config.DataMessageCome.Find[self.messageId].task_get_id
        if taskId>0 then
           self:CreatItem(self.lastConfig,false,0,taskId)
        end
        self.CloseBtn:SetActive(true)
        self.MaskBg:SetActive(false)
        self.parentWindow.isReadingMessage = false
        if BehaviorFunctions.CheckTaskIsFinish(taskId) then
            mod.MessageCtrl:SetRoelMessageConfig(self.messageId,self.lastConfig.talk_id,MessageConfig.ConditionType.End)
        else
            mod.MessageCtrl:SetRoelMessageConfig(self.messageId,self.lastConfig.talk_id,MessageConfig.ConditionType.Finish)
        end
        mod.InformationCtrl:SendMessageProgress(self.messageId,self.lastConfig.talk_id,self.optionList)
        -- 接取任务
        --mod.MessageCtrl:MessagEnd(self.messageId)
        self:ChangeScrollBar()
        return
     end
    
    self:ChangeScrollBar()
    self:DelayTalk(delayTime)
end

function MessageTalkPanel:DelayTalk( delayTime)
		if delayTime == 0 then
            if self.nowConfig.talk_from_type~=1 then
                self:CreatItem(self.nowConfig)--Npc发言
                mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
            else
                self:AnswerSelect(self.nowConfig)--玩家发言
            end
		else
			local callback = function()
				if self.showTimer then
					LuaTimerManager.Instance:RemoveTimer(self.showTimer)
					self.showTimer = nil
				end
                if self.nowConfig then
                    if self.nowConfig.talk_from_type~=1 then
                        self:CreatItem(self.nowConfig)
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

function MessageTalkPanel:__BindListener()
  --self.NormalBtn_btn.onClick:AddListener(self:ToFunc("OnClick_NormalTalk"))
  --self.Emojibtn_btn.onClick:AddListener(self:ToFunc("OnClick_NormaEmoji"))
  
  self.SelectEmojibtn01_btn.onClick:AddListener(self:ToFunc("OnClick_SelectEmojiOne"))
  self.SelectEmojibtn02_btn.onClick:AddListener(self:ToFunc("OnClick_SelectEmojiTwo"))
  self.SelectEmojibtn03_btn.onClick:AddListener(self:ToFunc("OnClick_SelectEmojiThree"))

  self.SelectOneBtn_btn.onClick:AddListener(self:ToFunc("OnClick_Selectone"))
  self.SelectTwoBtn_btn.onClick:AddListener(self:ToFunc("OnClick_SelectTwo"))
  self.SelectThreeBtn_btn.onClick:AddListener(self:ToFunc("OnClick_SelectThree"))

  self.CloseBtn_btn.onClick:AddListener(self:ToFunc("OnClick_ClosePanel"))
  self.LookIconBg_btn.onClick:AddListener(self:ToFunc("OnClick_CloseIcon"))

end

function MessageTalkPanel:OnClick_ClosePanel()
    self.closefunc()
end

function MessageTalkPanel:OnClick_CloseIcon()
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = false
    if self.blurBack then
        self.blurBack:SetActive(false)
    end
    self.LookIconBg:SetActive(false)
 end

function MessageTalkPanel:__Show()
    self.groupId = self.args.groupId
    self.talkId = self.args.talkId
    self.messageId = self.args.messageId
    self.closefunc = self.args.closefunc
    self:UpdateTopInfo()
    self:InitMessageInfo(self.groupId,self.talkId)
end

function MessageTalkPanel:__Hide()
  self:CloseTalkPanle()
end

function MessageTalkPanel:CloseTalkPanle()
    self.MessageContents = {}
 end

function MessageTalkPanel:InitMessageInfo(groupId,talkId)
    local messageType =  Config.DataMessageCome.Find[self.messageId].message_type 
    if messageType == 1 or messageType ==3 then
        self.CloseBtn:SetActive(false)
        self.MaskBg:SetActive(true)
        --按ecs无效
        self.parentWindow.isReadingMessage = true
    end
    self.scrollbar = self.MessageContent.transform:GetComponent(ScrollRect)
    local messageGroup = mod.MessageCtrl:GetMessageReadingGroup(groupId)
    for _i, _v in ipairs(messageGroup) do
        if _v.talk_id~=talkId then
            self:CreatItem(_v,true)
        else
            self.Isfirst = true
            self:CreatItem(_v,true)
            self.nowId = _v.talk_id
            self.nowConfig = Config.DataMessageDialog.Find[_v.talk_id]
            mod.InformationCtrl:SendMessageProgress(self.messageId,_v.talk_id,self.optionList)
            return
        end
    end
end

function MessageTalkPanel:UpdateTopInfo()
    local config = Config.DataMessageCome.Find[self.messageId]
    local Infor = Config.DataMessageType.Find[config.message_main_id]
    if Infor then 
     self.Name_txt.text = Infor.message_main_name
     self.Signature_txt.text = Infor.tips
    end
end

function MessageTalkPanel:ChangeScrollBar()

    self.scrollbar.inertia = false
    local function SetChatContY()
        if self.scrollbar then
            self.scrollbar.verticalScrollbar.value = 0
        end
    end
    local function SetInertia()
        if self.scrollbar then
            self.scrollbar.inertia = true
        end
    end
    LuaTimerManager.Instance:AddTimer(10, 0.05, SetChatContY)
    LuaTimerManager.Instance:AddTimer(1, 0.5, SetInertia)
end

function MessageTalkPanel:AnswerSelect(info)             --回答的选项
    if self.nowSelectItem then
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
        self:CreatItem(info)
        mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    end
end

function MessageTalkPanel:NormalAnswer(config)
    self:CreatItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
end

function MessageTalkPanel:NormalEmoji(config)
    self:CreatItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
end

function MessageTalkPanel:ShowSelect(selects)
    self.SelectBody:SetActive(true)
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

    self.SelectOneBtn:SetActive(self.Options [1])
    self.SelectTwoBtn:SetActive(self.Options [2])
    self.SelectThreeBtn:SetActive(self.Options [3])

    if self.Options [1] then
        self.SelectOneText_txt.text = self.Options [1].text
    end
    if self.Options [2] then
        self.SelectTwoText_txt.text = self.Options [2].text
    end
    if self.Options [3] then
        self.SelectThreeText_txt.text = self.Options [3].text
    end
    self.nowSelectItem = self.SelectBody
    self:ChangeContentSize(-220)
end

function MessageTalkPanel:ShowSelectEmoji(selects)
    self.SelectEmojiNodeBody:SetActive(true)
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
  
    self.SelectEmojibtn01:SetActive(self.EmojiOptions [1])
    self.SelectEmojibtn02:SetActive(self.EmojiOptions [2])
    self.SelectEmojibtn03:SetActive(self.EmojiOptions [3])
  
    if self.EmojiOptions[1] then
        SingleIconLoader.Load(self.SelectEmojiIcon1, self.EmojiOptions [1].path)
    end
    if self.EmojiOptions[2] then
        SingleIconLoader.Load(self.SelectEmojiIcon2, self.EmojiOptions [2].path)
    end
    if self.EmojiOptions[3] then
        SingleIconLoader.Load(self.SelectEmojiIcon3, self.EmojiOptions [3].path)
    end
    self.nowSelectItem = self.SelectEmojiNodeBody
    self:ChangeContentSize(-220)
end

function MessageTalkPanel:GetSelect(index)
    local config = self.Options[index].info
    self:CreatItem(config)
    self.nowConfig = config
    self.nowId = config.talk_id
    --发消息给服务器
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self.nowSelectItem:SetActive(false)
    self:ChangeContentSize(220)
end

function MessageTalkPanel:GetSelectEmoji(index)
    local config = Config.DataMessageDialog.Find[self.EmojiOptions[index].talkId] 
    self:CreatItem(self.nowConfig,false,index)
    self.nowConfig = config
    self.nowId = config.talk_id
    --发消息给服务器
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self.nowSelectItem:SetActive(false)
    self:ChangeContentSize(220)
end


function MessageTalkPanel:OnClick_Selectone()
    table.insert(self.optionList,1)
    self:GetSelect(1)
end
function MessageTalkPanel:OnClick_SelectTwo()
    table.insert(self.optionList,2)
    self:GetSelect(2)
end
function MessageTalkPanel:OnClick_SelectThree()
    table.insert(self.optionList,3)
    self:GetSelect(3)
end

function MessageTalkPanel:OnClick_NormalTalk()
    local config = Config.DataMessageDialog.Find[self.nowId]
    self:CreatItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self.nowSelectItem:SetActive(false)
end

function MessageTalkPanel:OnClick_NormaEmoji()
    local config = Config.DataMessageDialog.Find[self.nowId]
    self:CreatItem(config)
    mod.InformationCtrl:SendMessageProgress(self.messageId,self.nowId,self.optionList)
    self.nowSelectItem:SetActive(false)
end

function MessageTalkPanel:OnClick_SelectEmojiOne()
    table.insert(self.optionList,1)
    self:GetSelectEmoji(1)
    
end
function MessageTalkPanel:OnClick_SelectEmojiTwo()
    table.insert(self.optionList,2)
    self:GetSelectEmoji(2)
    
end
function MessageTalkPanel:OnClick_SelectEmojiThree()
    table.insert(self.optionList,3)
    self:GetSelectEmoji(3)
end

function MessageTalkPanel:ChangeContentSize(Distance)
    -- if self.Isfirst then
    --     self.Isfirst =false
    --     return
    -- end
    local container =  self.MessageContent_rect
    UnityUtils.SetSizeDelata(container, container.sizeDelta.x , container.sizeDelta.y+Distance)
    self:ChangeScrollBar()
end
function MessageTalkPanel:CreatItem(config,noSound,index,taskId)
    if not self.MessageContents[config.talk_id] then
        self.MessageContents[config.talk_id]={}
    end
    if(not noSound)then
        if(config.talk_from_type ==1)then
            SoundManager.Instance:PlaySound("UIMessageMine")
        else
            SoundManager.Instance:PlaySound("UIMessageOther")
        end
    end
    local itemInfo = {
        parent = self.ContentPanel,
        itemInfo = config,
        itemtype = config.type,
        callAnswer = self:ToFunc("AnswerSelect"),
        callOpenIcon = self:ToFunc("LookIcon"),
        callSetContentY = self:ToFunc("ChangeScrollBar"),
        iconindex = index,
        taskId = taskId,
    }
    self.MessageContents[config.talk_id].itemInfo = itemInfo
    self.MessageContents[config.talk_id].Item = MessageItem.New(itemInfo)
    self:ChangeScrollBar()
end

function MessageTalkPanel:LookIcon(path)
    local uiCamera = ctx.UICamera
    uiCamera.orthographic = true
    if not self.blurBack then
        local setting = { bindNode = self.BlurNode }
        self.blurBack = BlurBack.New(self, setting)
        self:SetActive(false)
        self.blurBack:Show()
    else
        self.blurBack:SetActive(true)
    end
    self.LookIconBg:SetActive(true)
    SingleIconLoader.Load(self.LookIconNode,path)
end