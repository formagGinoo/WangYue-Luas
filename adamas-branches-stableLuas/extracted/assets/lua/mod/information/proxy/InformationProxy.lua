InformationProxy = BaseClass("InformationProxy",Proxy)

function InformationProxy:__init()

end

function InformationProxy:__InitProxy()
    self:BindMsg("information")
    self:BindMsg("information_nick_name")
    self:BindMsg("information_signature")
    self:BindMsg("information_avatar_id")
    self:BindMsg("information_frame_id")
    self:BindMsg("information_birthday")
    self:BindMsg("information_hero_list")
    self:BindMsg("information_badge_list")
    self:BindMsg("frame_list")
    self:BindMsg("message_read")
    self:BindMsg("information_sex")
end

function InformationProxy:__InitComplete()

end

function InformationProxy:Recv_information(data)
    mod.InformationCtrl:UpdatePlayerInfo(data)
end

function InformationProxy:Recv_information_signature(data)
    local info = {
        signature = data.signature
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_signature(signature)
    return {signature = signature}
end

function InformationProxy:Recv_information_nick_name(data)
    local info = {
        nick_name = data.nick_name
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_nick_name(name)
    return {nick_name = name}
end

function InformationProxy:Recv_information_avatar_id(data)
    local info = {
        avatar_id = data.avatar_id
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_avatar_id(avatarId)
    return {avatar_id = avatarId}
end

function InformationProxy:Recv_information_frame_id(data)
    local info = {
        frame_id = data.frame_id
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_frame_id(frameId)
    return {frame_id = frameId}
end

function InformationProxy:Recv_information_birthday(data)
    local info = {
        birthday_month = data.birthday_month,
        birthday_day = data.birthday_day
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_birthday(month,day)
    return {birthday_month = month,birthday_day = day}
end

function InformationProxy:Recv_information_hero_list(data)
    local info = {
        hero_id_list = data.hero_id_list
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_hero_list(list)
    return {hero_id_list = list}
end

function InformationProxy:Recv_information_badge_list(data)
    local info = {
        badge_id_list = data.badge_id_list
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_badge_list(list)
    return {badge_id_list = list}
end

function InformationProxy:Recv_frame_list(data)
    mod.InformationCtrl:UpdataFrameList(data.frame_list)
end

function InformationProxy:Recv_message_read (data)
    mod.InformationCtrl:InitMessageInfor(data)
end

function InformationProxy:Send_message_read(list)
    return{message = list}
end

function InformationProxy:Recv_information_sex(data)
    local info = {
        sex = data.sex
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Send_information_sex(sex)
    return {sex = sex}
end