BargainProxy = BaseClass("BargainProxy", Proxy)

function BargainProxy:__init()

end

function BargainProxy:__InitProxy()
    self:BindMsg("bargain_list")
    self:BindMsg("bargain_check_seq")
    self:BindMsg("bargain_point_info")
end

function BargainProxy:Recv_bargain_list(data)
    mod.BargainCtrl:UpdateBargainList(data.bargain_list)
end

function BargainProxy:Send_bargain_check_seq(type, relateId, negotiateId, playerChoice, npcChoice, score)
    return {type = type, relate_id = relateId, negotiate_id = negotiateId, npc_seq = npcChoice, client_seq = playerChoice, original_point = score}
end

function BargainProxy:Recv_bargain_point_info(data)
    mod.BargainCtrl:RecyBargainScore(data.original_point, data.bargain_count, data.negotiateId)
end