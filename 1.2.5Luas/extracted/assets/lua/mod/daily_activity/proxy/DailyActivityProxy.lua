DailyActivityProxy = BaseClass("DailyActivityProxy",Proxy)

function DailyActivityProxy:__init()

end

function DailyActivityProxy:__InitProxy()
    self:BindMsg("activity_info")
    self:BindMsg("activity_award")
end

function DailyActivityProxy:Send_activity_info(data)
end

function DailyActivityProxy:Recv_activity_info(data)
	mod.DailyActivityCtrl:UpdateInfo(data)
end

function DailyActivityProxy:Send_activity_award(activation)
	return {award_value = activation}
end

function DailyActivityProxy:Recv_activity_award(data)
    mod.DailyActivityCtrl:OnGetAwardResult(data)
end