SceneMsgCtrl = BaseClass("SceneMsgCtrl", Controller)

function SceneMsgCtrl:__init()
    self.msgList ={}
    self.SystemMsgList = {}
end

function SceneMsgCtrl:__delete()

end

function SceneMsgCtrl:__InitComplete()

end

function SceneMsgCtrl:UpdateMsgList(data)
    for key, value in pairs(data) do
        for k, v in pairs(value) do
            if not self.msgList[v.scene_msg_id] then
                self.msgList[v.scene_msg_id] = {}
                self.msgList[v.scene_msg_id].id = v.scene_msg_id
            end
            self.msgList[v.scene_msg_id].operation = v.operation
            EventMgr.Instance:Fire(EventName.SceneMsgUpdateData, self.msgList[v.scene_msg_id])
        end
    end
end

function SceneMsgCtrl:UpdateMsgData(data)
    if not self.msgList[data.scene_msg_id] then
        self.msgList[data.scene_msg_id] = {}
        self.msgList[data.scene_msg_id].id = data.scene_msg_id
    end
    self.msgList[data.scene_msg_id].like = data.like
    self.msgList[data.scene_msg_id].dislike = data.dislike
    EventMgr.Instance:Fire(EventName.SceneMsgUpdateData, self.msgList[data.scene_msg_id])
end

function SceneMsgCtrl:GetLikeData(id)
    if self.msgList[id] and self.msgList[id].like and self.msgList[id].dislike then
        return self.msgList[id].like, self.msgList[id].dislike
    else
        mod.SceneMsgFacade:SendMsg("scene_msg_statistic", id)
    end
end

function SceneMsgCtrl:GetData(id)
    self:GetLikeData(id)
    if self.msgList[id] then
        return self.msgList[id]
    end
end

function SceneMsgCtrl:LikeMsg(id, operation)
    mod.SceneMsgFacade:SendMsg("scene_msg_operate", id, operation)
end

