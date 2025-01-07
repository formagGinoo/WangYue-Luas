InformationCtrl = BaseClass("InformationCtrl", Controller)

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
        self.playerInfo.nick_name = info.nick_name
    end
    if info.signature then
        self.playerInfo.signature = info.signature
    end
    if info.photo_id then
        self.playerInfo.photo_id = info.photo_id
    end
    if info.uid then
        self.playerInfo.uid = info.uid
    end

    EventMgr.Instance:Fire(EventName.PlayerInfoUpdate, info)
end

function InformationCtrl:GetPlayerInfo()
    return self.playerInfo
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

function InformationCtrl:ModifyPlayerHeadImage(id)
    mod.InformationFacade:SendMsg("information_photo_id", id)
end