ActivityProxy = BaseClass("ActivityProxy",Proxy)

function ActivityProxy:__init()
end

function ActivityProxy:__InitProxy()
    self:BindMsg("daily_sign_in_info")
	self:BindMsg("daily_sign_in_award")
	self:BindMsg("novice_info")
	self:BindMsg("novice_award")
end

function ActivityProxy:Send_daily_sign_in_info() 
end

function ActivityProxy:Recv_novice_info(data)
	mod.ActivityCtrl:UpdateTaskActivity(data)
end
function ActivityProxy:Recv_daily_sign_in_info(data)
    mod.ActivityCtrl:UpdateSignInActivity(data);
end

function ActivityProxy:Send_novice_award(id, day)
    return { id = id ,reward_value = day}
end
function ActivityProxy:Send_daily_sign_in_award(id, day)
    return { id = id ,nth_day = day}
end
