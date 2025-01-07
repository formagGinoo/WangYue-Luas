FriendProxy = BaseClass("FriendProxy",Proxy)

function FriendProxy:__init()
    self:BindMsg("friend_fetch")
    self:BindMsg("friend_offline")
    self:BindMsg("friend_search")
    self:BindMsg("friend_request")
    self:BindMsg("friend_request_reply")
    self:BindMsg("friend_remove")
    self:BindMsg("friend_black_fetch")
    self:BindMsg("friend_black_add")
    self:BindMsg("friend_black_remove")
    self:BindMsg("friend_info_fetch")
    self:BindMsg("friend_remark")
    self:BindMsg("friend_recommend")
    self:BindMsg("friend_chat")
    self:BindMsg("friend_chat_read")
    self:BindMsg("meme_list")
end

function FriendProxy:__InitProxy()
end

function FriendProxy:__InitComplete()
end

function FriendProxy:Send_friend_fetch()
end

function FriendProxy:Recv_friend_fetch(data)
    local friendList = data.friend_list
    mod.FriendCtrl:UpdataFriendList(friendList)
end

function FriendProxy:Recv_friend_offline(data)
    local targetId = data.target_id
    local timestamp = data.timestamp
    mod.FriendCtrl:UpdataFriendState(targetId,timestamp)
end

function FriendProxy:Send_friend_search(targetId)
    return {target_id = targetId}
end

function FriendProxy:Send_friend_request(targetId)
    return {target_id = targetId}
end

function FriendProxy:Recv_friend_request(data)
    local list = data.request_list
    mod.FriendCtrl:UpdataRequestList(list)
end


function FriendProxy:Send_friend_request_reply(isAccept,targetId)
    return {is_accept = isAccept,target_id = targetId}
end

function FriendProxy:Send_friend_remove(targetId)
    return {target_id = targetId}
end

function FriendProxy:Recv_friend_remove(data)
    mod.FriendCtrl:FriendRemove(data.target_id)
    EventMgr.Instance:Fire(EventName.FriendRemove, data.target_id)
end

function FriendProxy:Send_friend_black_fetch()
end

function FriendProxy:Recv_friend_black_fetch(data)
    local list = data.black_list
    mod.FriendCtrl:UpdataBlackList(list)
end

function FriendProxy:Send_friend_black_add(targetId)
    return {target_id = targetId}
end

function FriendProxy:Send_friend_black_remove(targetId)
    return {target_id = targetId}
end

function FriendProxy:Send_friend_info_fetch(targetId)
    return {target_id = targetId}
end

function FriendProxy:Recv_friend_info_fetch(data)
    local targetId = data.target_id
    local playerInfo = data.info
    mod.FriendCtrl:ShowPlayerInfo(targetId,playerInfo)
end

function FriendProxy:Send_friend_remark(targetId,remark)
    return {target_id = targetId,remark = remark}
end

function FriendProxy:Send_friend_recommend()
end

function FriendProxy:Recv_friend_recommend(data)
    local list = data.recommend_list
    mod.FriendCtrl:UpdataRecommend(list)
end

function FriendProxy:Send_friend_chat(targetId, content)
    return {target_id = targetId, content = content}
end

function FriendProxy:Send_friend_chat_read(targetId)
    return {target_id = targetId}
end

function FriendProxy:Recv_friend_chat(data)
    mod.FriendCtrl:UpdateChatListByServer(data)
    EventMgr.Instance:Fire(EventName.ChatListRefresh, data.target_id)
end

function FriendProxy:Recv_meme_list(data)
    mod.FriendCtrl:UpdateMemeList(data.meme_list)
end