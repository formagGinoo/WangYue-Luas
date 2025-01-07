MessageCtrl = BaseClass("MessageCtrl", Controller)


function MessageCtrl:__init()
   self.MessageType = nil
end

function MessageCtrl:__BindListener()
   
end

function MessageCtrl:__delete()
   if self.MessageType then
    self.MessageType = nil
   end
end

function MessageCtrl:__InitComplete()

end

function MessageCtrl:GetSiftMessageByGroup(messageMainId)
    local SiftMessage = {}
    for index, _v in ipairs(MessageConfig.SortMessages) do
        if _v.messageMainId == messageMainId then
            table.insert(SiftMessage,_v)
        end
    end
    return SiftMessage
end

function MessageCtrl:GetSiftMessageByType(type)
    if type == 0 then
        return MessageConfig.SortMessages
    end
    local SiftMessage = {}
    for index, _v in ipairs(MessageConfig.SortMessages) do      --划分个人和群聊
        local mytype = Config.DataMessageType.Find[_v.messageMainId].message_main_type
        if mytype == type then
            table.insert(SiftMessage,_v)
        end
    end
    return SiftMessage
end

function MessageCtrl:GetProgressTalkId(ItemInfo)
    for key, value in pairs(MessageConfig.MessageTypes) do
        if value.group_id==ItemInfo.group_id then
            return value.talk_id
        end
    end
end

function MessageCtrl:GetFirstTalkId(messageId)
    local groupId = Config.DataMessageCome.Find[messageId].group_id
    local Config = Config.DataMessageDialog.Find
    local messages = {}
    for _k, _v in pairs(Config) do
        if _v.group_id == groupId then
            table.insert(messages,_v)
        end
    end
    table.sort(messages, function (a, b)
        return a.talk_id < b.talk_id
    end)
    local firstTalkId = messages[1].talk_id
    return firstTalkId
end

function MessageCtrl:SortMessageLeftPanel(SiftMessage,SelectType)
    EventMgr.Instance:Fire(EventName.SortMessage,SiftMessage,SelectType)
end

function MessageCtrl:SetReadingMessageConfig(talkId)
    MessageConfig.ReadingMessage[talkId] = Config.DataMessageDialog.Find[talkId]
end

function MessageCtrl:SetMessageTypesConfig(messageId,talkId)
    MessageConfig.MessageTypes[messageId] = Config.DataMessageDialog.Find[talkId]
	self:SetRoelMessageConfig(messageId,talkId,MessageConfig.ConditionType.Start)
end

function MessageCtrl:CheckHaveNewMessage()
    for _k, _v in pairs(MessageConfig.SeverMessage) do
        if _v.talk_id == self:GetFirstTalkId(_v.message_id) then
            return true
        end
    end
    return false
end

function MessageCtrl:CheckNewMessageRed()

    for _k, _v in pairs(MessageConfig.MessageTypes) do
        if _v.talk_id == self:GetFirstTalkId(_k) then
            return true
        end
    end
    return false
end

function MessageCtrl:SetRoelMessageConfig(messageId,talkId,type)
    local messageMainId = Config.DataMessageCome.Find[messageId].message_main_id

    if not MessageConfig.RoelMessages[messageMainId]  then
        MessageConfig.RoelMessages[messageMainId] = {}
    end
    if not MessageConfig.RoelMessages[messageMainId][messageId] then
        MessageConfig.RoelMessages[messageMainId][messageId] ={}
        MessageConfig.RoelMessages[messageMainId][messageId].talkId = talkId
        MessageConfig.RoelMessages[messageMainId][messageId].type = type
    else
        MessageConfig.RoelMessages[messageMainId][messageId].talkId = talkId
        MessageConfig.RoelMessages[messageMainId][messageId].type = type
    end
end

function MessageCtrl:SetSortMessage()
    local k =1
    for key, value in pairs(MessageConfig.RoelMessages) do
        MessageConfig.SortMessages[k] = {}
        MessageConfig.SortMessages[k].messageMainId = key
        MessageConfig.SortMessages[k].value = value
        k =k+1
    end
    table.sort(MessageConfig.SortMessages, function (a, b)
        return a.messageMainId<b.messageMainId
    end)
end

function MessageCtrl:CheckConditionType(messageId,talkId)
    local firstId = self:GetFirstTalkId(messageId)
    local config = Config.DataMessageDialog.Find[talkId]
    local messageCome = Config.DataMessageCome.Find[messageId]
    if firstId == talkId then
      return MessageConfig.ConditionType.Start
    elseif config.is_finish then
        if BehaviorFunctions.CheckTaskIsFinish(messageCome.task_get_id) then
            return MessageConfig.ConditionType.End
        else
            return MessageConfig.ConditionType.Finish
        end
    else
      return MessageConfig.ConditionType.Reading
    end
end

function MessageCtrl:SetMessageTypes()
    for _k, _v in pairs(MessageConfig.SeverMessage) do
    MessageConfig.MessageTypes[_v.message_id] = Config.DataMessageDialog.Find[_v.talk_id]
    local conditonType = self:CheckConditionType(_v.message_id,_v.talk_id)
	self:SetRoelMessageConfig(_v.message_id,_v.talk_id,conditonType)
    end
end

function MessageCtrl:GetMessageGroup(groupId)
    local messageConfig = Config.DataMessageDialog.Find
    local nowMessageGroup ={}
    local k =1
    for _i, _v in pairs(messageConfig) do
        if _v.group_id== groupId then
            nowMessageGroup[k]=_v
            k = k + 1
        end
    end
    table.sort(nowMessageGroup,function (a,b)
        return a.talk_id<b.talk_id
    end)
    return nowMessageGroup
end

function MessageCtrl:GetMessageReadingGroup(groupId)
    local messageConfig= MessageConfig.ReadingMessage
    local nowMessageGroup ={}
    local k =1
    for _i, _v in pairs(messageConfig) do
        if _v.group_id== groupId then
            nowMessageGroup[k]=_v
            k = k + 1 
        end
    end
    table.sort(nowMessageGroup,function (a,b)
        return a.talk_id<b.talk_id
    end)
    return nowMessageGroup
end

function MessageCtrl:MessagEnd(messageId)
    --完成短信
    EventMgr.Instance:Fire(EventName.MessageEnd,messageId)
end

function MessageCtrl:SetReadingMessage()              --初始时调用用来存储短信数据
    for _k, _v in pairs(MessageConfig.SeverMessage) do
        local k =1
        local config =Config.DataMessageDialog.Find[_v.talk_id]
        local MessageGroup = self:GetMessageGroup(config.group_id)
        local Isselect =false
        local optionCount =0
        local selectcount = 1
        local befortalkId = 0
        for i = 1, #MessageGroup, 1 do
            if MessageGroup[i].talk_id == _v.talk_id then      --当前Id与数组Id相同时，加入表中就结束了，开始下一组信息
                MessageConfig.ReadingMessage[MessageGroup[i].talk_id] =  Config.DataMessageDialog.Find[MessageGroup[i].talk_id]
                befortalkId = 0
                break
            end
            if not Isselect and MessageGroup[i].type ~= 4 and MessageGroup[i].type ~=5 then  --不是选择内容时就加入到表中
                if befortalkId == 0 then
                    MessageConfig.ReadingMessage[MessageGroup[i].talk_id] =  Config.DataMessageDialog.Find[MessageGroup[i].talk_id]
                    befortalkId = MessageGroup[i].talk_id
                else
                    if Config.DataMessageDialog.Find[befortalkId].nest_id == MessageGroup[i].talk_id then
                        MessageConfig.ReadingMessage[MessageGroup[i].talk_id] =  Config.DataMessageDialog.Find[MessageGroup[i].talk_id]
                        befortalkId = MessageGroup[i].talk_id
                    else
                        goto continue
                    end
                end
            else
                selectcount = selectcount+1
            end
            if MessageGroup[i].type == 4 or MessageGroup[i].type ==5 then
                local id = _v.option_list[k]
                if not id then
                    id =1
                end
                local talkId = MessageGroup[i].options[id][2]
                optionCount = #MessageGroup[i].options
                k= k+1
                MessageConfig.ReadingMessage[talkId] =  Config.DataMessageDialog.Find[talkId]
                befortalkId =talkId
                Isselect = true
            end
            if selectcount>optionCount+1 then
                Isselect =false
                selectcount =1
            end
            ::continue::
        end
    end
end