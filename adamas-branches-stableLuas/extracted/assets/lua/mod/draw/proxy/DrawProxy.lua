DrawProxy = BaseClass("DrawProxy", Proxy)

function DrawProxy:__init()
end

function DrawProxy:__InitProxy()
    self:BindMsg("draw")
    self:BindMsg("draw_history")
    self:BindMsg("draw_count")
    self:BindMsg("draw_guarantee")
end

function DrawProxy:Send_draw(poolId, buttonType)
    return { draw_id = poolId, button = buttonType }
end

function DrawProxy:Recv_draw(data)
    mod.DrawCtrl:RecvDrawResult(data.draw_id, data.item_list)
end

function DrawProxy:Send_draw_history(drawGroupId)
    return { draw_group_id = drawGroupId }
end

function DrawProxy:Recv_draw_history(data)
    mod.DrawCtrl:RecvDrawHistory(data.draw_group_id, data.history_list)
end

function DrawProxy:Recv_draw_count(data)
    mod.DrawCtrl:RecvDrawDrawCount(data.draw_id, data.draw_count, data.daily_draw_count)
end

function DrawProxy:Recv_draw_guarantee(data)
    mod.DrawCtrl:RecvDrawGuarantee(data.draw_group_id, data.current_count, data.max_count)
end