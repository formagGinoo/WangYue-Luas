AnnouncementProxy = BaseClass("AnnouncementProxy",Proxy)

function AnnouncementProxy:__init()

end

function AnnouncementProxy:__InitProxy()
    self:BindMsg("noticeboard_list")
    self:BindMsg("noticeboard_redpoint")
end

function AnnouncementProxy:__InitComplete()

end
function AnnouncementProxy:Recv_noticeboard_list(data)
    -- mod.AnnouncementCtrl:UpdateAnnouncementsList(data.notice_list)
    EventMgr.Instance:Fire(EventName.AnnouncementRefresh)
end

function AnnouncementProxy:Send_noticeboard_redpoint(Id)
    return {notice_id = Id}
end

function AnnouncementProxy:Recv_noticeboard_redpoint(data)
    -- mod.AnnouncementCtrl:UpdateAnnouncementsReadList(data.notice_id_list)
    -- EventMgr.Instance:Fire(EventName.AnnouncementRefresh)
end