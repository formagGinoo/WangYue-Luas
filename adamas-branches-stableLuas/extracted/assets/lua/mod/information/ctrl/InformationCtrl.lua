InformationCtrl = BaseClass("InformationCtrl", Controller)

local function sortFrame(a,b)
    return InformationConfig.GetFrameConfig(a).priority > InformationConfig.GetFrameConfig(b).priority
end

function InformationCtrl:__init()
    self.playerInfo = {}
    self.adventureInfo = {}
end

function InformationCtrl:__delete()

end

function InformationCtrl:__InitComplete()

end

function InformationCtrl:UpdatePlayerInfo(info)
    if info.nick_name then
        if info.nick_name == "" then
            self.playerInfo.nick_name = InformationConfig.GetDefalultName()
        else
            self.playerInfo.nick_name = info.nick_name
        end
    end
    if info.signature then
        self.playerInfo.signature = info.signature
    end
    -- if info.uid and info.uid ~= 0 then
    --     self.playerInfo.uid = info.uid
    -- end
    if info.avatar_id then
        if info.avatar_id == 0 then
            self:ModifyPlayerHeadImage(1001001,type)
        end
        self.playerInfo.avatar_id = info.avatar_id
    end
    if info.frame_id then
        self.playerInfo.frame_id = info.frame_id
    end
    if info.hero_id_list then
        self.playerInfo.hero_id_list = info.hero_id_list
    end
    if info.badge_id_list then
        self.playerInfo.badge_id_list = info.badge_id_list
    end
    if info.birthday_month and info.birthday_day then
        self.playerInfo.birthday_month = info.birthday_month
        self.playerInfo.birthday_day = info.birthday_day
    end
    if info.register_date then
        self.playerInfo.register_date = info.register_date
    end

    if info.sex then
        self.playerInfo.sex = info.sex
        if info.sex == 1 then 
            Config.DataHeroMain.Find[1001001] = Config.DataHeroMain.Find[10010011]
        elseif info.sex == 2 then 
            Config.DataHeroMain.Find[1001001] = Config.DataHeroMain.Find[10010012]
        end
    end
    EventMgr.Instance:Fire(EventName.PlayerInfoUpdate, info)
end

function InformationCtrl:SetUID(uid)
    self.playerInfo.uid = uid
end

function InformationCtrl:SetSex(sex)
    mod.InformationFacade:SendMsg("information_sex", sex)
end

function InformationCtrl:GetPlayerInfo()
    return self.playerInfo
end

function InformationCtrl:CheckIsSelf(id)
    return id == self.playerInfo.uid
end

function InformationCtrl:GetPlayerAdventureLevel()
    return self.adventureInfo.lev
end

function InformationCtrl:ModifyPlayerName(name)
    mod.InformationFacade:SendMsg("information_nick_name", name)
end

function InformationCtrl:ModifyPlayerSignature(signature)
    mod.InformationFacade:SendMsg("information_signature", signature)
end

function InformationCtrl:ModifyPlayerHeadImage(id,type)
    if type == InformationConfig.HeadIconType.Avatar then
        mod.InformationFacade:SendMsg("information_avatar_id", id)
    elseif type == InformationConfig.HeadIconType.Frame then
        mod.InformationFacade:SendMsg("information_frame_id", id)
    end
end

function InformationCtrl:UpdataFrameList(list)
    if self.frameList and next(self.frameList) then 
        for _, v in ipairs(list) do
            table.insert(self.frameList,v)
        end
    else
        self.frameList = list
    end
    if self.frameList and #self.frameList > 1 then
        table.sort(self.frameList,sortFrame)
    end 
end

function InformationCtrl:GetFrameList()
    return self.frameList
end

function InformationCtrl:GetHeadIconList()
    local headIconList = TableUtils.CopyTable(mod.RoleCtrl:GetRoleIdList())
    table.sort(headIconList)
    return headIconList
end

function InformationCtrl:InitMessageInfor(info)--初始化短信息

        for _k, _v in pairs(info.finish_list) do
            if not MessageConfig.SeverMessage [_v.message_id] then
                MessageConfig.SeverMessage [_v.message_id] ={}
                MessageConfig.SeverMessage [_v.message_id] = _v
            else
                MessageConfig.SeverMessage [_v.message_id] = _v
            end
        end
        for _k, _v in pairs(info.reading_list) do
            if not MessageConfig.SeverMessage [_v.message_id] then
                MessageConfig.SeverMessage [_v.message_id] ={}
                MessageConfig.SeverMessage [_v.message_id] = _v
            else
                MessageConfig.SeverMessage [_v.message_id] = _v
            end
        end
        mod.MessageCtrl:SetMessageTypes()
        mod.MessageCtrl:SetReadingMessage()
end

--TODO
function InformationCtrl:StartMessage(messageId)
    if not messageId then
        LogError("缺少短信配置ID,messageId = %s",messageId)
        return
    end
    local dataMessageCome = Config.DataMessageCome.Find
    if not dataMessageCome[messageId] then
        return
    end
    local groupId = dataMessageCome[messageId].group_id --短信的对话组ID
    local type = dataMessageCome[messageId].message_type --短信的类型1，主线，2，支线，3，关卡
    local talkId = mod.MessageCtrl:GetFirstTalkId(messageId)
    if not talkId then
        return
    end
    if type == 1 or type ==3 then
        EventMgr.Instance:Fire(EventName.StartMainMessage,messageId,talkId,groupId) --直接触发短信
    else
        EventMgr.Instance:Fire(EventName.StartNormalMessage,messageId,groupId,talkId) --触发消息提示
    end

    MessageConfig.MessageTypes[messageId] = Config.DataMessageDialog.Find[talkId] --用来存储每组对话的进度 key_短信Id(messageId) value_对话信息（talkId）
    mod.MessageCtrl:SetRoelMessageConfig(messageId,talkId,MessageConfig.ConditionType.Start)
end

function InformationCtrl:SendMessageProgress(messageId,talkId,optionList)

    local struct_message =
    {
        message_id = messageId,
        talk_id = talkId,
        option_list = optionList
    }

    if not MessageConfig.ReadingMessage[talkId] then
        local id,cmd = mod.InformationFacade:SendMsg("message_read", struct_message) --走服务器
        mod.LoginCtrl:AddClientCmdEvent(id, cmd, function()
            MessageConfig.MessageTypes[messageId] = Config.DataMessageDialog.Find[talkId]
            --设置短信的类型
            local type = mod.MessageCtrl:CheckConditionType(messageId,talkId)
            mod.MessageCtrl:SetRoelMessageConfig(messageId,talkId,type)
            if Config.DataMessageDialog.Find[talkId].type == 4 or Config.DataMessageDialog.Find[talkId].type ==5 then
                return
            end
            MessageConfig.ReadingMessage[talkId] =  Config.DataMessageDialog.Find[talkId]
            EventMgr.Instance:Fire(EventName.NpcCallbackMessage,messageId,talkId)     --将接受到的消息发送给对话面板
        end)
    else
        EventMgr.Instance:Fire(EventName.NpcCallbackMessage,messageId,talkId)   --走本地
    end
end