---@class FriendCtrl : Controller
FriendCtrl = BaseClass("FriendCtrl", Controller)

local REFRESHINTERVAL = Config.DataCommonCfg.Find["RefreshInterval"].int_val
local MAXFRIENDCOUNT = Config.DataCommonCfg.Find["FriendLimit"].int_val

local function sortFunc(a,b)
    local aInfo = mod.FriendCtrl:GetFriendInfo(a)
    local bInfo = mod.FriendCtrl:GetFriendInfo(b)
    if aInfo.offline_timestamp == bInfo.offline_timestamp then
        if aInfo.adventure_lev == bInfo.adventure_lev then
            return aInfo.information.uid < bInfo.information.uid
        else
            return aInfo.adventure_lev > bInfo.adventure_lev
        end
    else
        if bInfo.offline_timestamp == 0 then return false end
        return aInfo.offline_timestamp == 0 or aInfo.offline_timestamp > bInfo.offline_timestamp
    end
end

-- offline_timestamp
function FriendCtrl:__init()
    self.friendIdList = {}
    self.friendInfoDic = {}
    self.friendRecommendList = {}
    self.friendRequestList = {}
    self.friendBlackList = {}
    self.friendRemarkDic = {}
    --self.friendTimeStamp = {}
    self.friendChatList = {}
    self.friendChatUnReadList  = {}
    self.firendLastChatTime = {}
    self.ChatUnShowList = {}
    self.ChatMemeList = {}
    self.lastRefreshRecommendTime = 0
    --self.curShowFriend = nil
end

function FriendCtrl:__delete()
end

function FriendCtrl:__InitComplete()
end

-- function FriendCtrl:SetCurShowFriend(id)
--     self.curShowFriend = id
-- end

-- function FriendCtrl:GetCurShowFriend()
--     return self.curShowFriend
-- end

function FriendCtrl:UpdataFriendList(friendList)
    for _, v in ipairs(friendList) do
        if v.info.information.uid == 0 or not v.info.information.uid then
            v.info.information.uid = v.target_id
        end
        if v.info.information.nick_name == "" then
            v.info.information.nick_name = InformationConfig.GetDefalultName()
        end
        for _, val in ipairs(v.info.hero_list) do
            if val.id == 1001001 then
                if v.info.information.sex < 2 then 
                    val.id = 10010011
                else
                    val.id = 10010012
                end
            end
        end

        for i, id in ipairs(self.friendRequestList) do
            if id == v.target_id then
                table.remove(self.friendRequestList,i)
                EventMgr.Instance:Fire(EventName.FriendListRefresh,3)
                break
            end
        end
        local isSame = false
        for i, id in ipairs(self.friendIdList) do
            if id == v.target_id then
                isSame = true
            end
        end
        if not isSame then
            table.insert(self.friendIdList,v.target_id)
        end
        if v.remark and v.remark ~= "" then
            self.friendRemarkDic[v.target_id] = v.remark
        end
        self.friendInfoDic[v.target_id] = v.info
    end
    table.sort(self.friendIdList,sortFunc)
    EventMgr.Instance:Fire(EventName.FriendListRefresh,1)
end

function FriendCtrl:UpdataRequestList(list)
    if not list or not next(list) then return end
    for _, v in ipairs(list) do
        table.insert(self.friendRequestList,v.target_id)
        if v.info.information.uid == 0 or not v.info.information.uid then
            v.info.information.uid = v.target_id
        end
        if v.info.information.nick_name == "" then
            v.info.information.nick_name = InformationConfig.GetDefalultName()
        end
        for _, val in ipairs(v.info.hero_list) do
            if val.id == 1001001 then
                if v.info.information.sex < 2 then 
                    val.id = 10010011
                else
                    val.id = 10010012
                end
            end
        end
        self.friendInfoDic[v.target_id] = v.info
    end
    EventMgr.Instance:Fire(EventName.FriendListRefresh,3)
end

function FriendCtrl:UpdataBlackList(list)
    for _, v in ipairs(list) do
        table.insert(self.friendBlackList,v.target_id)
        if v.remark and v.remark ~= "" then
            self.friendRemarkDic[v.target_id] = v.remark
        end
        if v.info.information.uid == 0 or not v.info.information.uid then
            v.info.information.uid = v.target_id
        end
        if v.info.information.nick_name == "" then
            v.info.information.nick_name = InformationConfig.GetDefalultName()
        end
        for _, val in ipairs(v.info.hero_list) do
            if val.id == 1001001 then
                if v.info.information.sex < 2 then 
                    val.id = 10010011
                else
                    val.id = 10010012
                end
            end
        end
        self.friendInfoDic[v.target_id] = v.info
    end
    EventMgr.Instance:Fire(EventName.FriendBlackListRefresh)
end

function FriendCtrl:UpdataRecommend(list)
    TableUtils.ClearTable(self.friendRecommendList)
    for _, v in pairs(list) do
        if v.info.information.uid == 0 or not v.info.information.uid then
            v.info.information.uid = v.target_id
        end
        if v.info.information.nick_name == "" then
            v.info.information.nick_name = InformationConfig.GetDefalultName()
        end
        for _, val in ipairs(v.info.hero_list) do
            if val.id == 1001001 then
                if v.info.information.sex < 2 then 
                    val.id = 10010011
                else
                    val.id = 10010012
                end
            end
        end
        table.insert(self.friendRecommendList,v.target_id)
        self.friendInfoDic[v.target_id] = v.info
    end
    table.sort(self.friendRecommendList,sortFunc)
    EventMgr.Instance:Fire(EventName.FriendListRefresh,2)
end

function FriendCtrl:UpdataFriendState(targetId,timestamp)
    --self.friendTimeStamp[targetId] = timestamp
    self.friendInfoDic[targetId].offline_timestamp = timestamp
    EventMgr.Instance:Fire(EventName.FriendStateRefresh,targetId)
end

function FriendCtrl:GetLastRefreshRecommendTime()
    return self.lastRefreshRecommendTime
end

function FriendCtrl:SetLastRecommendTime(time)
    self.lastRefreshRecommendTime = time
end

function FriendCtrl:ShowPlayerInfo(uid,info)
    if info.information.uid == 0 or not info.information.uid then
        info.information.uid = uid
    end
    if info.information.nick_name == "" then
        info.information.nick_name = InformationConfig.GetDefalultName()
    end
    for _, val in ipairs(info.hero_list) do
        if val.id == 1001001 then
            if info.information.sex < 2 then 
                val.id = 10010011
            else
                val.id = 10010012
            end
        end
    end
    self.friendInfoDic[uid] = info
    WindowManager.Instance:OpenWindow(PlayerInfoWindow,{uid = uid})
end

function FriendCtrl:CheckIsFriend(uid)
   for i, v in ipairs(self.friendIdList) do
        if v == uid then
            return true
        end
   end 
   return false
end

function FriendCtrl:GetFriendIdList()
    return self.friendIdList
end

function FriendCtrl:GetFriendInfo(targetId)
    return self.friendInfoDic[targetId]
end

function FriendCtrl:GetFriendRemark(targetId)
    return self.friendRemarkDic[targetId]
end

function FriendCtrl:FreshRecommendList()
    local id,cmd = mod.FriendFacade:SendMsg("friend_recommend")
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            self.lastRefreshRecommendTime = TimeUtils.GetCurTimestamp()
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:SetFriendRemark(targetId,remark)
    local id,cmd = mod.FriendFacade:SendMsg("friend_remark",targetId,remark)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            if remark == "" then 
                self.friendRemarkDic[targetId] = nil
            else
                self.friendRemarkDic[targetId] = remark
            end
            EventMgr.Instance:Fire(EventName.RemakrNameChange,targetId)
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:RefreshRedommendList()
    mod.FriendFacade:SendMsg("friend_recommend")
end

function FriendCtrl:GetRecommendList()
    return self.friendRecommendList
end

function FriendCtrl:GetApplicationList()
    return self.friendRequestList
end

function FriendCtrl:RefreshBlackList()
    mod.FriendFacade:SendMsg("friend_black_fetch")
end

function FriendCtrl:GetBlackList() 
    return self.friendBlackList
end

function FriendCtrl:GetPlayerInfo(targetId)
    return self.friendInfoDic[targetId]
end

function FriendCtrl:CheckIsSelf(targetId)
    return mod.InformationCtrl:GetPlayerInfo().uid == targetId
end

function FriendCtrl:AddFriend(targetId)
    if self.friendIdList and #self.friendIdList >= MAXFRIENDCOUNT then
        MsgBoxManager.Instance:ShowTips(TI18N("你的好友数量已达上限，无法添加新好友"))
        return 
    end
    local id,cmd = mod.FriendFacade:SendMsg("friend_request", targetId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            MsgBoxManager.Instance:ShowTips(TI18N("好友申请发送成功"))
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:RemoveFriend(targetId)
    local id,cmd = mod.FriendFacade:SendMsg("friend_remove", targetId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            for i, v in ipairs(self.friendIdList) do
                if v == targetId then 
                    table.remove(self.friendIdList,i)
                    self.friendRemarkDic[targetId] = nil
                    break
                end
            end
            EventMgr.Instance:Fire(EventName.FriendListRefresh,1)
            self:DelChatListByFriendId(targetId)
            self:DelUnReadRedPointByFriendId(targetId)
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:SearchByID(targetId)
    local id,cmd = mod.FriendFacade:SendMsg("friend_info_fetch", targetId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE ~= 0 then
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:AddToBlackList(targetId)
    local id,cmd = mod.FriendFacade:SendMsg("friend_black_add", targetId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            for i, v in ipairs(self.friendIdList) do
                if v == targetId then 
                    table.remove(self.friendIdList,i)
                    self.friendRemarkDic[targetId] = nil
                    --table.insert(self.friendBlackList,v)
                    break
                end
            end
            self:FreshRecommendList()
            EventMgr.Instance:Fire(EventName.FriendListRefresh,1)
            self:DelChatListByFriendId(targetId)
            self:DelUnReadRedPointByFriendId(targetId)
            EventMgr.Instance:Fire(EventName.FriendBlackListRefresh)
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:RemoveBlackList(targetId)
    local id,cmd = mod.FriendFacade:SendMsg("friend_black_remove", targetId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            for i, v in ipairs(self.friendBlackList) do
                if v == targetId then
                    table.remove(self.friendBlackList,i)
                    break
                end
            end
            EventMgr.Instance:Fire(EventName.FriendBlackListRefresh)
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:RefuseRequest(targetId)
    local id,cmd = mod.FriendFacade:SendMsg("friend_request_reply",false,targetId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            if targetId == 0 then 
                self.friendRequestList = {}
            else
                for i, v in ipairs(self.friendRequestList) do
                    if v == targetId then 
                        table.remove(self.friendRequestList,i)
                        break
                    end
                end
            end
            EventMgr.Instance:Fire(EventName.FriendListRefresh,3)
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:AgreeRequest(targetId)
    local id,cmd = mod.FriendFacade:SendMsg("friend_request_reply",true,targetId)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function (ERRORCODE)
        if ERRORCODE == 0 then
            if targetId == 0 then 
                self.friendRequestList = {}
            else
                for i, v in ipairs(self.friendRequestList) do
                    if v == targetId then 
                        table.remove(self.friendRequestList,i)
                        break
                    end
                end
            end
            EventMgr.Instance:Fire(EventName.FriendListRefresh,3)
        else
            MsgBoxManager.Instance:ShowTips(Config.DataErrorCode.data_error_code[ERRORCODE])
        end
    end)
end

function FriendCtrl:FriendRemove(targetId)
    for i, v in ipairs(self.friendIdList) do
        if v == targetId then
            table.remove(self.friendIdList,i)
            break
        end
    end
    EventMgr.Instance:Fire(EventName.FriendListRefresh,1)
    self:DelChatListByFriendId(targetId)
    self:DelUnReadRedPointByFriendId(targetId)
end

function FriendCtrl:GetFriendRoleData(roleId,uid)
    for _, v in pairs(self.friendInfoDic[uid].hero_list) do
        if v.id == roleId or (roleId == 1001001 and (v.id == 10010011 or v.id == 10010012)) then 
            return v
        end
    end
end

function FriendCtrl:GetFriendRoleIdList(uid)
    local list = {}
    for i, v in ipairs(self.friendInfoDic[uid].information.hero_id_list) do
        if v ~= 0 then 
            table.insert(list,v)
        end
    end
    return list
end

function FriendCtrl:GetFirstShowRole(uid)
    for i, v in ipairs(self.friendInfoDic[uid].information.hero_id_list) do
        if v ~= 0 then
            return v
        end
    end
    
end

function FriendCtrl:GetFriendPartnerInfo(partnerId,uid)
    for _, v in pairs(self.friendInfoDic[uid].partner_list) do
        if v.unique_id == partnerId then
            return v
        end
    end
end

function FriendCtrl:GetFriendRolePartner(roleId,uid)
    local roleData = self:GetFriendRoleData(roleId,uid)

    if not roleData then
        roleData = mod.RoleCtrl:GetRoleData(roleId)   
    end

    return roleData.partner_id
end

function FriendCtrl:GetFriendWeaponInfo(weaponId,uid)
    for _, v in pairs(self.friendInfoDic[uid].weapon_list) do
        if v.unique_id == weaponId then 
            return v
        end
    end
    return mod.BagCtrl:GetWeaponData(weaponId)
end

function FriendCtrl:GetFriendRoleWeapon(roleId,uid)
    local roleData = self:GetFriendRoleData(roleId,uid)

    if not roleData then
        roleData = mod.RoleCtrl:GetRoleData(roleId)   
    end

    return roleData.weapon_id
end

function FriendCtrl:GetFriendSkillInfo(roleId,skillId,uid)
    for _, v in pairs(self.friendInfoDic[uid].hero_list) do
        if v.id == roleId or (roleId == 1001001 and (v.id == 10010011 or v.id == 10010012)) then
            for _, skill in pairs(v.skill_list) do
                if skill.order_id == skillId then
                    return skill.lev,skill.ex_lev
                end
            end
        end
    end
    return 0,0
end

function FriendCtrl:CheckInBlackList(targetId)
    for i, v in ipairs(self.friendBlackList) do
        if v == targetId then
            return true
        end
    end
    return false
end

function FriendCtrl:CheckFriendRedPoint()
    if self.friendRequestList and #self.friendRequestList > 0 then
        return true
    end
    return false
end

function FriendCtrl:SendChat(targetId, content)
    local id,cmd = mod.FriendFacade:SendMsg("friend_chat", targetId, content)
    mod.LoginCtrl:AddClientCmdEvent(id, cmd, function ()
        mod.FriendFacade:SendMsg("friend_chat_read", targetId)
        EventMgr.Instance:Fire(EventName.ChatRedPointRefresh)
    end)
end

function FriendCtrl:SetFriendReadStateToServer(targetId)
    if self.friendChatUnReadList[targetId] == false then
        return
    end
    mod.FriendFacade:SendMsg("friend_chat_read", targetId)
end

function FriendCtrl:UpdateChatListByServer(data)
    local targetId = data.target_id
    local contentList = data.content_list
    self:SetClearChatUnShowListByFriendId(targetId)
    if not data.is_unread then
        self.friendChatUnReadList[targetId] = false
    end
    
    -- 登录
    if not self.friendChatList[targetId] then
        self.friendChatList[targetId] = {}
    end
    -- 登录/增量
    for i, info in ipairs(contentList) do
        table.insert(self.friendChatList[targetId],info)
        self.firendLastChatTime[targetId] = info.timestamp
    end
    self.friendChatUnReadList[targetId] = data.is_unread
end

-- 自己发的消息
function FriendCtrl:UpdateChatListBySendChat(targetId, content, nowTimeStamp)
    if not self.friendChatList[targetId] then
        self.friendChatList[targetId] = {}
    end
    table.insert(self.friendChatList[targetId],{
        content = content,
        from_id = mod.InformationCtrl:GetPlayerInfo().uid,
        timestamp = nowTimeStamp,
    })
    self.firendLastChatTime[targetId] = nowTimeStamp
    self.friendChatUnReadList[targetId] = false
end

function FriendCtrl:GetChatListByFriendId(targetId)
    if not self.friendChatList[targetId] then
        return nil
    end
    return self.friendChatList[targetId]
end

-- 删除聊天记录
function FriendCtrl:DelChatListByFriendId(targetId)
    self.friendChatList[targetId] = nil
end

-- 设置消息为已读
function FriendCtrl:SetChatReadStateByTargetId(targetId)
    if not targetId then
        LogError("SetChatReadStateByTargetId传了个空的targetId")
    end
    self:SetFriendReadStateToServer(targetId)
    self.friendChatUnReadList[targetId] = false
    EventMgr.Instance:Fire(EventName.ChatRedPointRefresh)
end

function FriendCtrl:GetChatReadStateByTargetId(targetId)
    return self.friendChatUnReadList[targetId] or false
end

--删除未读红点
function FriendCtrl:DelUnReadRedPointByFriendId(targetId)
    self.friendChatUnReadList[targetId] = nil
    EventMgr.Instance:Fire(EventName.ChatRedPointRefresh)
end

--是否显示未读红点
function FriendCtrl:CheckUnReadRedPointState()
    for _, isUnRead in pairs(self.friendChatUnReadList) do
        if isUnRead == true then
            return true
        end
    end
    return false
end

function FriendCtrl:GetLastChatTimeByFriendId(targetId)
    return self.firendLastChatTime[targetId] or 0
end

function FriendCtrl:SetChatUnShowListByFriendId(targetId)
    self.ChatUnShowList[targetId] = true
end

function FriendCtrl:SetClearChatUnShowListByFriendId(targetId)
    self.ChatUnShowList[targetId] = nil
end

function FriendCtrl:GetChatUnShowListByFriendId(targetId)
    if self.ChatUnShowList[targetId] then
        return true
    end
    return false
end

function FriendCtrl:UpdateMemeList(list)
    if not self.ChatMemeList then
        self.ChatMemeList = {}
    end
    for _, memeId in ipairs(list) do
        self.ChatMemeList[memeId] = true
    end
end

function FriendCtrl:CheckMemeByMemeId(memeId)
    if self.ChatMemeList[memeId] then
        return true
    end
    return false
end

function FriendCtrl:GetMemeList()
    return self.ChatMemeList
end

function FriendCtrl:CheckMemeByGroupId(groupId)
    for k, info in pairs(FriendConfig.GetMemeListByGroupId(groupId)) do
        if mod.FriendCtrl:CheckMemeByMemeId(info.id) == true then
            return true
        end
    end
    return false
end