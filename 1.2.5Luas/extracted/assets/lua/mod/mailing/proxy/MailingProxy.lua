MailingProxy = BaseClass("MailingProxy",Proxy)

function MailingProxy:__init()
end

function MailingProxy:__InitProxy()
	self:BindMsg("mailing_info")
	self:BindMsg("mailing_active")
	self:BindMsg("mailing_exchange")
end

function MailingProxy:__InitComplete()

end

function MailingProxy:Recv_mailing_info(data)
	mod.MailingCtrl:OnRecvMailingInfo(data.mailing_list)
end

function MailingProxy:Send_mailing_active(id)
	return {mailing_id = id}
end

function MailingProxy:Send_mailing_exchange(id, itemId, itemCount)
	return {mailing_id = id, item_id = itemId, item_count = itemCount}
end


function MailingProxy:Recv_mailing_exchange(data)
	-- data.err_code 
	mod.MailingCtrl:OnGetCommitResult(data)
end