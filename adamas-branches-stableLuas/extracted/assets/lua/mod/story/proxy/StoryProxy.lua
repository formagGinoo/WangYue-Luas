StoryProxy = BaseClass("StoryProxy",Proxy)

function StoryProxy:__init()

end

function StoryProxy:__InitProxy()
    self:BindMsg("dialog_reward_info")
    self:BindMsg("dialog_select")
    self:BindMsg("dialog_reward_remove")
    self:BindMsg("dialog_reward_unlock")
end

function StoryProxy:__InitComplete()

end

function StoryProxy:Recv_dialog_reward_info(data)
    mod.StoryCtrl:UpdataoSelectDialog(data.group_id_maps)
end

function StoryProxy:Send_dialog_select(talk_id)
    return {talk_id = talk_id}
end

function StoryProxy:Recv_dialog_reward_remove(data)
    mod.StoryCtrl:RemoveSelectDialog(data.refresh_type)
end

function StoryProxy:Recv_dialog_reward_unlock(data)
    EventMgr.Instance:Fire(EventName.IdentityOptionUnlock)
end
