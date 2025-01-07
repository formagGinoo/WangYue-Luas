InformationProxy = BaseClass("InformationProxy",Proxy)

function InformationProxy:__init()

end

function InformationProxy:__InitProxy()
    self:BindMsg("information")
    self:BindMsg("information_nick_name")
    self:BindMsg("information_signature")
    self:BindMsg("information_photo_id")
end

function InformationProxy:__InitComplete()

end

function InformationProxy:Recv_information(data)
    -- Log("uid:"..data.uid)
    -- Log("nick_name:"..data.nick_name)
    -- Log("signature:"..data.signature)
    -- Log("photo_id:"..data.photo_id)
    local info = {
        nick_name = data.nick_name,
        signature = data.signature,
        photo_id = data.photo_id,
        uid = data.uid
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Recv_information_signature(data)
    local info = {
        signature = data.signature
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
end

function InformationProxy:Recv_information_photo_id(data)
    local info = {
        photo_id = data.photo_id
    }
    mod.InformationCtrl:UpdatePlayerInfo(info)
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

function InformationProxy:Send_information_signature(signature)
    return {signature = signature}
end

function InformationProxy:Send_information_photo_id(photoId)
    return {photo_id = photoId}
end