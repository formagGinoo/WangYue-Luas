SceneMsgProxy = BaseClass("SceneMsgProxy", Proxy)

function SceneMsgProxy:__init()

end

function SceneMsgProxy:__InitProxy()
    self:BindMsg("scene_msg_operate_list")
    self:BindMsg("scene_msg_statistic")
    self:BindMsg("scene_msg_operate")
end

function SceneMsgProxy:__InitComplete()

end

function SceneMsgProxy:Recv_scene_msg_operate_list(data)
    mod.SceneMsgCtrl:UpdateMsgList(data)
end

--请求对应传书id数据
function SceneMsgProxy:Send_scene_msg_statistic(id)
    return {scene_msg_id = id}
end

--返回对应传书的数据
function SceneMsgProxy:Recv_scene_msg_statistic(data)
    mod.SceneMsgCtrl:UpdateMsgData(data)
end

--对传书点赞或点踩
function SceneMsgProxy:Send_scene_msg_operate(id, operation)
    return {scene_msg = {scene_msg_id = id, operation = operation}}
end