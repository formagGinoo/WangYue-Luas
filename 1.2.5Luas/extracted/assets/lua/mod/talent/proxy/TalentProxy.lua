TalentProxy = BaseClass("TalentProxy",Proxy)

function TalentProxy:__init()

end

function TalentProxy:__InitProxy()
    self:BindMsg("talent_info")
    self:BindMsg("talent_lev_up")
end

function TalentProxy:__InitComplete()

end

function TalentProxy:Recv_talent_info(data)
    mod.TalentCtrl:UpdateTalentsList(data.talent_list)
end

function TalentProxy:Send_talent_lev_up(talentId)
    return {talent_id = talentId}
end

