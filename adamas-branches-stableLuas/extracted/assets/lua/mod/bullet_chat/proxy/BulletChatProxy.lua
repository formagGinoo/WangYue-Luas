BulletChatProxy = BaseClass("BulletChatProxy", Proxy)

function BulletChatProxy:__init()

end

function BulletChatProxy:__InitProxy()
    self:BindMsg("bullet_chat_history")
    self:BindMsg("bullet_chat_send")
end

function BulletChatProxy:Send_bullet_chat_history(timelineId)
    return { timeline_id = timelineId }
end

function BulletChatProxy:Recv_bullet_chat_history(data)
    mod.BulletChatCtrl:ReceiveBullteChat(data.timeline_id, data.history)
end

function BulletChatProxy:Send_bullet_chat_send(timelineId, time, content, color)
    if type(content) ~= string then
        content = tostring(content)
    end
    return { timeline_id = timelineId, bullet_chat = {
        send_time = time,
        content = content,
        color = color
    } }
end

